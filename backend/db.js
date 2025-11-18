const mysql = require('mysql2/promise');

const dbConfig = {
    host: 'localhost',
    database: 'Grocery_Inventory',
    connectionLimit: 10
};

const adminPool = mysql.createPool({
    host: 'localhost',
    user: 'user_admin',
    password: 'StrongAdminPass!123',
    connectionLimit: 10
});

// Pool for the 'public_user'
const publicPool = mysql.createPool({
    ...dbConfig,
    user: 'public_user',
    password: 'PublicPass123!'
});

// Create a connection pool for each role
const pools = {
    manager: mysql.createPool({
        ...dbConfig,
        user: 'manager_suresh',
        password: 'StrongManagerPass!2025'
    }),
    cashier: mysql.createPool({
        ...dbConfig,
        user: 'cashier_pooja',
        password: 'StrongCashierPass!789'
    }),
    stocker: mysql.createPool({
        ...dbConfig,
        user: 'stocker_rajesh',
        password: 'StrongStockerPass!456'
    }),
    default: publicPool
};

/**
 * Gets a database connection from the pool based on the user's role.
 * @param {string} role - The role of the user ('manager', 'cashier', 'stocker').
 * @returns {Promise<mysql.PoolConnection>} A database connection.
 */
const getConnection = async (role) => {
    let pool;
    switch (role) {
        case 'manager':
            pool = pools.manager;
            break;
        case 'cashier':
            pool = pools.cashier;
            break;
        case 'stocker':
            pool = pools.stocker;
            break;
        default:z``
            pool = pools.default;
    }
    
    try {
        return await pool.getConnection();
    } catch (error) {
        console.error(`Failed to get connection for role ${role}: ${error.message}`);
        if (error.code === 'ER_ACCESS_DENIED_ERROR') {
            console.error(`Access denied for user: ${pools[role]?.config.user}`);
        }
        throw error;
    }
};

module.exports = {
    getConnection,
    getAdminPool: () => adminPool
};