const express = require('express');
const cors = require('cors');
const { getConnection, getAdminPool } = require('./db');

const app = express();
const port = 3000;

// Middleware
app.use(cors());
app.use(express.json());

const attachDbConnection = async (req, res, next) => {
    const role = req.headers['x-user-role'] || 'default';
    let connection;
    try {
        connection = await getConnection(role);
        req.dbConnection = connection; // Attach the connection to the request object
        next(); // Move to the next function (the API endpoint)
    } catch (error) {
        res.status(503).json({ error: 'Database service unavailable. Check role credentials.' });
    }
};

app.use(attachDbConnection);

/**
 * REQUIREMENT: Procedure (with GUI)
 * Calls the sp_get_low_stock_items procedure
 */
app.get('/api/stock/low', async (req, res) => {
    const { store_id = 1, threshold = 100 } = req.query;
    try {
        const [results] = await req.dbConnection.execute(
            'CALL sp_get_low_stock_items(?, ?)',
            [store_id, threshold]
        );
        res.json(results[0]);
    } catch (error) {
        res.status(500).json({ error: error.message });
    } finally {
        if (req.dbConnection) req.dbConnection.release();
    }
});

/**
 * REQUIREMENT: Function (with GUI)
 * Calls the fn_get_customer_total_spent function
 */
app.get('/api/customers/:id/total-spent', async (req, res) => {
    const { id } = req.params;
    try {
        const [results] = await req.dbConnection.execute(
            'SELECT fn_get_customer_total_spent(?) AS total_spent',
            [id]
        );
        res.json(results[0]);
    } catch (error) {
        res.status(500).json({ error: error.message });
    } finally {
        if (req.dbConnection) req.dbConnection.release();
    }
});

/**
 * REQUIREMENT: Nested Query (with GUI)
 * Finds products stocked in a specific city
 */
app.get('/api/products/by-city', async (req, res) => {
    const { city = 'Bengaluru' } = req.query;
    const query = `
        SELECT name, brand FROM Product WHERE product_id IN (
            SELECT product_id FROM Stock WHERE store_id IN (
                SELECT store_id FROM Store WHERE city = ?
            )
        );
    `;
    try {
        const [results] = await req.dbConnection.execute(query, [city]);
        res.json(results);
    } catch (error) {
        res.status(500).json({ error: error.message });
    } finally {
        if (req.dbConnection) req.dbConnection.release();
    }
});

/**
 * REQUIREMENT: Join Query (with GUI)
 * Gets detailed purchase information
 */
app.get('/api/purchases/detailed', async (req, res) => {
    const query = `
        SELECT c.name AS customer_name, p.purchase_date, pr.name AS product_name, 
               pr.brand, pi.quantity, (pr.price * pi.quantity) AS item_total_price
        FROM Customer c
        JOIN Purchase p ON c.customer_id = p.customer_id
        JOIN Purchase_Items pi ON p.purchase_id = pi.purchase_id
        JOIN Product pr ON pi.product_id = pr.product_id
        ORDER BY p.purchase_date DESC, c.name
        LIMIT 50; -- Added a limit for performance
    `;
    try {
        const [results] = await req.dbConnection.execute(query);
        res.json(results);
    } catch (error) {
        res.status(500).json({ error: error.message });
    } finally {
        if (req.dbConnection) req.dbConnection.release();
    }
});

/**
 * REQUIREMENT: Aggregate Query (with GUI)
 * Gets total units sold per product
 */
app.get('/api/reports/sales-by-product', async (req, res) => {
    const query = `
        SELECT p.name, p.brand, SUM(pi.quantity) AS total_units_sold
        FROM Purchase_Items pi
        JOIN Product p ON pi.product_id = p.product_id
        GROUP BY p.product_id, p.name, p.brand
        ORDER BY total_units_sold DESC;
    `;
    try {
        const [results] = await req.dbConnection.execute(query);
        res.json(results);
    } catch (error) {
        res.status(500).json({ error: error.message });
    } finally {
        if (req.dbConnection) req.dbConnection.release();
    }
});

/**
 * REQUIREMENT: Trigger (with GUI)
 * Demonstrated via a CREATE operation on the Employee table.
 */
app.post('/api/employees', async (req, res) => {
    const { employee_id, first_name, last_name, role, salary, dob, store_id } = req.body;
    const query = `
        INSERT INTO Employee (employee_id, first_name, last_name, role, salary, dob, store_id) 
        VALUES (?, ?, ?, ?, ?, ?, ?);
    `;
    try {
        await req.dbConnection.execute(query, [employee_id, first_name, last_name, role, salary, dob, store_id]);
        res.status(201).json({ message: 'Employee created successfully' });
    } catch (error) {
        // This is how you catch the trigger's custom error!
        if (error.sqlState === '45000') {
            res.status(400).json({ error: error.message });
        } else {
            res.status(500).json({ error: error.message });
        }
    } finally {
        if (req.dbConnection) req.dbConnection.release();
    }
});

// --- Bonus: Full CRUD Endpoints for Product ---

// GET (Read) all products
app.get('/api/products', async (req, res) => {
    try {
        const [results] = await req.dbConnection.execute('SELECT * FROM Product ORDER BY name');
        res.json(results);
    } catch (error) {
        res.status(500).json({ error: error.message });
    } finally {
        if (req.dbConnection) req.dbConnection.release();
    }
});

// PUT (Update) a product's price
app.put('/api/products/:id/price', async (req, res) => {
    const { id } = req.params;
    const { price } = req.body;
    try {
        await req.dbConnection.execute('UPDATE Product SET price = ? WHERE product_id = ?', [price, id]);
        res.json({ message: 'Product price updated successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    } finally {
        if (req.dbConnection) req.dbConnection.release();
    }
});

// DELETE a product
app.delete('/api/products/:id', async (req, res) => {
    const { id } = req.params;
    try {
        await req.dbConnection.execute('DELETE FROM Product WHERE product_id = ?', [id]);
        res.json({ message: 'Product deleted successfully' });
    } catch (error) {
        // Handle foreign key constraint error
        if (error.code === 'ER_ROW_IS_REFERENCED_2') {
            res.status(400).json({ error: 'Cannot delete product. It is referenced in purchases or stock.' });
        } else {
            res.status(500).json({ error: error.message });
        }
    } finally {
        if (req.dbConnection) req.dbConnection.release();
    }
});

app.post('/api/users/create', async (req, res) => {
    const loggedInRole = req.headers['x-user-role'];

    // 1. Application-Level Security Check
    if (loggedInRole !== 'manager') {
        // Release the connection obtained by the middleware
        if (req.dbConnection) req.dbConnection.release(); 
        return res.status(403).json({ error: 'Forbidden: Only managers can create users.' });
    }

    const { username, password, role } = req.body;

    // 2. Validation
    if (!username || !password || !role) {
        if (req.dbConnection) req.dbConnection.release();
        return res.status(400).json({ error: 'Username, password, and role are required.' });
    }
    if (!['cashier', 'stocker', 'manager'].includes(role)) {
        if (req.dbConnection) req.dbConnection.release();
        return res.status(400).json({ error: 'Invalid role. Must be cashier, stocker, or manager.' });
    }
    // Basic validation to prevent some SQL injection in username
    if (!/^[a-zA-Z0-9_]+$/.test(username)) {
        if (req.dbConnection) req.dbConnection.release();
        return res.status(400).json({ error: 'Username can only contain letters, numbers, and underscores.' });
    }

    let adminConnection;
    try {
        // 3. Use the high-privilege (admin) connection pool
        // We CANNOT use req.dbConnection (from manager) as it lacks CREATE USER permission.
        adminConnection = await getAdminPool().getConnection();
        await adminConnection.beginTransaction();

        // 4. Execute SQL Commands
        // We use '?' for values, which are parameterized.
        // We MUST hardcode '@'localhost' for security.
        
        // Create the user
        createUserQuery = `CREATE USER IF NOT EXISTS '${username}'@'localhost' IDENTIFIED BY '${password}'`;
        await adminConnection.execute(
            createUserQuery
        );
        
        // Grant the specified role (which we validated is a safe value)
        let grantRoleQuery = `GRANT '${role}' TO '${username}'@'localhost';`;
        await adminConnection.execute(
            grantRoleQuery
        );
        
        // Set the default role
        let setDefaultQuery = `SET DEFAULT ROLE '${role}' TO '${username}'@'localhost'`
        await adminConnection.execute(
            setDefaultQuery
        );

        await adminConnection.commit();
        
        res.status(201).json({ message: `User '${username}' created and granted '${role}' role.` });

    } catch (error) {
        if (adminConnection) await adminConnection.rollback();
        console.error(error);
        res.status(500).json({ error: `Database error: ${error.message}` });
    } finally {
        // Release BOTH connections
        if (adminConnection) adminConnection.release();
        if (req.dbConnection) req.dbConnection.release();
    }
});

// Start the server
app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});