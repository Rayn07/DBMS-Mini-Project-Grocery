document.addEventListener('DOMContentLoaded', () => {
    const API_BASE_URL = 'http://localhost:3000/api';

    // --- Navigation ---
    const navLinks = document.querySelectorAll('.nav-link');
    const pages = document.querySelectorAll('.page-content');
    const roleSwitcher = document.getElementById('role-switcher');
    const adminNavLink = document.querySelector('[data-page="page-admin"]').parentElement;

    navLinks.forEach(link => {
        link.addEventListener('click', () => {
            // Hide all pages
            pages.forEach(page => page.classList.add('hidden'));
            // Show target page
            const targetPage = document.getElementById(link.dataset.page);
            if (targetPage) {
                targetPage.classList.remove('hidden');
            }
            // Style active link
            navLinks.forEach(nav => nav.classList.remove('bg-blue-600'));
            link.classList.add('bg-blue-600');
        });
    });

    roleSwitcher.addEventListener('change', (e) => {
        const selectedRole = e.target.value;
        
        // Hide/Show Admin link based on role
        if (selectedRole === 'manager') {
            adminNavLink.style.display = 'block';
        } else {
            adminNavLink.style.display = 'none';
            
            // If user switches role while on admin page, kick them back to dashboard
            const adminPage = document.getElementById('page-admin');
            if (adminPage && !adminPage.classList.contains('hidden')) {
                // Reset nav link styles
                navLinks.forEach(link => link.classList.remove('bg-blue-600'));
                document.querySelector('[data-page="page-dashboard"]').classList.add('bg-blue-600');
                
                // Hide all pages and show dashboard
                pages.forEach(page => page.classList.add('hidden'));
                document.getElementById('page-dashboard').classList.remove('hidden');
            }
        }
    });

        roleSwitcher.dispatchEvent(new Event('change'));

    // --- API Helper Functions ---
    
    /** Gets the currently selected role for the API header */
    function getApiHeaders() {
        return {
            'Content-Type': 'application/json',
            'X-User-Role': roleSwitcher.value
        };
    }

    /** Renders data as a table */
    function renderTable(containerId, data, columns) {
        const container = document.getElementById(containerId);
        if (!data || data.length === 0) {
            container.innerHTML = '<p class="text-gray-500">No data found.</p>';
            return;
        }
        
        // Use provided columns or infer from first object
        const headers = columns || Object.keys(data[0]);
        
        let table = '<table class="min-w-full divide-y divide-gray-200">';
        table += '<thead class="bg-gray-50"><tr>';
        headers.forEach(header => {
            table += `<th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">${header.replace('_', ' ')}</th>`;
        });
        table += '</tr></thead>';
        table += '<tbody class="bg-white divide-y divide-gray-200">';
        
        data.forEach(row => {
            table += '<tr>';
            headers.forEach(header => {
                let cellData = row[header];
                // Check if cellData is an object (like for product CRUD)
                if (typeof cellData === 'object' && cellData !== null) {
                    cellData = JSON.stringify(cellData);
                }
                table += `<td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">${cellData}</td>`;
            });
            table += '</tr>';
        });
        
        table += '</tbody></table>';
        container.innerHTML = table;
    }

    /** Shows a success/error toast message */
    function showToast(message, isError = false) {
        const toast = document.getElementById('toast');
        const toastMessage = document.getElementById('toast-message');
        
        toastMessage.innerText = message;
        toast.classList.remove('hidden', 'bg-green-500', 'bg-red-500');
        toast.classList.add(isError ? 'bg-red-500' : 'bg-green-500');
        
        setTimeout(() => {
            toast.classList.add('hidden');
        }, 3000);
    }

    // --- Page: Dashboard ---
    document.getElementById('btn-load-sales').addEventListener('click', async () => {
        try {
            const response = await fetch(`${API_BASE_URL}/reports/sales-by-product`, { headers: getApiHeaders() });
            if (!response.ok) throw new Error((await response.json()).error);
            const data = await response.json();
            renderTable('sales-report-container', data, ['name', 'brand', 'total_units_sold']);
        } catch (error) {
            showToast(`Error: ${error.message}`, true);
        }
    });

    document.getElementById('btn-load-purchases').addEventListener('click', async () => {
        try {
            const response = await fetch(`${API_BASE_URL}/purchases/detailed`, { headers: getApiHeaders() });
            if (!response.ok) throw new Error((await response.json()).error);
            const data = await response.json();
            renderTable('purchases-report-container', data, ['customer_name', 'purchase_date', 'product_name', 'quantity', 'item_total_price']);
        } catch (error) {
            showToast(`Error: ${error.message}`, true);
        }
    });

    // --- Page: Stock Procedure ---
    document.getElementById('form-low-stock').addEventListener('submit', async (e) => {
        e.preventDefault();
        const store_id = document.getElementById('store_id').value;
        const threshold = document.getElementById('threshold').value;
        try {
            const response = await fetch(`${API_BASE_URL}/stock/low?store_id=${store_id}&threshold=${threshold}`, { headers: getApiHeaders() });
            if (!response.ok) throw new Error((await response.json()).error);
            const data = await response.json();
            renderTable('low-stock-container', data);
        } catch (error) {
            showToast(`Error: ${error.message}`, true);
        }
    });

    // --- Page: Customer Function ---
    document.getElementById('form-customer-spent').addEventListener('submit', async (e) => {
        e.preventDefault();
        const customer_id = document.getElementById('customer_id').value;
        const container = document.getElementById('customer-spent-container');
        try {
            const response = await fetch(`${API_BASE_URL}/customers/${customer_id}/total-spent`, { headers: getApiHeaders() });
            if (!response.ok) throw new Error((await response.json()).error);
            const data = await response.json();
            container.innerHTML = `Total spent by customer ${customer_id}: <strong class="text-blue-600">$${data.total_spent || 0}</strong>`;
        } catch (error) {
            showToast(`Error: ${error.message}`, true);
            container.innerHTML = '';
        }
    });

    // --- Page: City Nested Query ---
    document.getElementById('form-city-query').addEventListener('submit', async (e) => {
        e.preventDefault();
        const city = document.getElementById('city').value;
        try {
            const response = await fetch(`${API_BASE_URL}/products/by-city?city=${city}`, { headers: getApiHeaders() });
            if (!response.ok) throw new Error((await response.json()).error);
            const data = await response.json();
            renderTable('city-query-container', data);
        } catch (error) {
            showToast(`Error: ${error.message}`, true);
        }
    });

    // --- Page: Employee Trigger ---
    document.getElementById('form-add-employee').addEventListener('submit', async (e) => {
        e.preventDefault();
        const body = {
            employee_id: document.getElementById('emp_id').value,
            first_name: document.getElementById('emp_fname').value,
            last_name: document.getElementById('emp_lname').value,
            role: document.getElementById('emp_role').value,
            salary: document.getElementById('emp_salary').value,
            dob: document.getElementById('emp_dob').value,
            store_id: document.getElementById('emp_store_id').value,
        };
        try {
            const response = await fetch(`${API_BASE_URL}/employees`, {
                method: 'POST',
                headers: getApiHeaders(),
                body: JSON.stringify(body)
            });
            const data = await response.json();
            if (!response.ok) throw new Error(data.error);
            
            showToast(data.message); // Success
            e.target.reset(); // Reset form
        } catch (error) {
            // This will show the trigger error!
            showToast(`Error: ${error.message}`, true);
        }
    });

    // --- Page: Product CRUD ---
    const productsCrudContainer = document.getElementById('products-crud-container');
    
    async function loadProducts() {
        try {
            const response = await fetch(`${API_BASE_URL}/products`, { headers: getApiHeaders() });
            if (!response.ok) throw new Error((await response.json()).error);
            const products = await response.json();
            
            // Custom render function for CRUD buttons
            renderCrudTable('products-crud-container', products);

        } catch (error) {
            showToast(`Error: ${error.message}`, true);
        }
    }
    
    document.getElementById('btn-load-products').addEventListener('click', loadProducts);

    function renderCrudTable(containerId, data) {
        const container = document.getElementById(containerId);
        let table = '<table class="min-w-full divide-y divide-gray-200"><thead></thead><tbody>';
        table += `<tr>
                    <td class="px-6 py-4">ID</td>
                    <td class="px-6 py-4">Name</td>
                    <td class="px-6 py-4">Price</td>
                    <td class="px-6 py-4">Brand</td>
                    <td class="px-6 py-4">Actions</td>
                </tr>`
        // (Same table header code as renderTable)
        
        data.forEach(row => {
            table += `
                <tr data-id="${row.product_id}">
                    <td class="px-6 py-4 text-sm text-gray-700">${row.product_id}</td>
                    <td class="px-6 py-4 text-sm text-gray-700">${row.name}</td>
                    <td class="px-6 py-4 text-sm text-gray-700">₹${row.price}</td>
                    <td class="px-6 py-4 text-sm text-gray-700">${row.brand}</td>
                    <td class="px-6 py-4 text-sm space-x-2">
                        <button class="btn-update-price text-blue-600 hover:text-blue-800" data-id="${row.product_id}" data-price="${row.price}">Update Price</button>
                        <button class="btn-delete-product text-red-600 hover:text-red-800" data-id="${row.product_id}">Delete</button>
                    </td>
                </tr>
            `;
        });
        table += '</tbody></table>';
        container.innerHTML = table;
    }

    // Event listener for UPDATE and DELETE buttons (uses event delegation)
    productsCrudContainer.addEventListener('click', async (e) => {
        const target = e.target;
        
        // --- UPDATE ---
        if (target.classList.contains('btn-update-price')) {
            const id = target.dataset.id;
            const currentPrice = target.dataset.price;
            const newPrice = prompt(`Enter new price for product ${id}:`, currentPrice);
            
            if (newPrice && newPrice !== currentPrice) {
                try {
                    const response = await fetch(`${API_BASE_URL}/products/${id}/price`, {
                        method: 'PUT',
                        headers: getApiHeaders(),
                        body: JSON.stringify({ price: newPrice })
                    });
                    const data = await response.json();
                    if (!response.ok) throw new Error(data.error);
                    showToast(data.message);
                    loadProducts(); // Refresh table
                } catch (error) {
                    showToast(`Error: ${error.message}`, true);
                }
            }
        }

        // --- DELETE ---
        if (target.classList.contains('btn-delete-product')) {
            const id = target.dataset.id;
            if (confirm(`Are you sure you want to delete product ${id}?`)) {
                try {
                    const response = await fetch(`${API_BASE_URL}/products/${id}`, {
                        method: 'DELETE',
                        headers: getApiHeaders()
                    });
                    const data = await response.json();
                    if (!response.ok) throw new Error(data.error);
                    showToast(data.message);
                    loadProducts(); // Refresh table
                } catch (error) {
                    showToast(`Error: ${error.message}`, true);
                }
            }
        }
    });

    document.getElementById('form-create-user').addEventListener('submit', async (e) => {
        e.preventDefault();
        const body = {
            username: document.getElementById('new_username').value,
            password: document.getElementById('new_password').value,
            role: document.getElementById('new_role').value
        };
        console.log(body)

        try {
            const response = await fetch(`${API_BASE_URL}/users/create`, {
                method: 'POST',
                headers: getApiHeaders(), // This sends the 'X-User-Role' header
                body: JSON.stringify(body)
            });
            
            const data = await response.json();
            
            if (!response.ok) {
                // This will catch the '403 Forbidden' error from the backend
                throw new Error(data.error); 
            }
            
            showToast(data.message); // Success
            e.target.reset(); // Reset form
        } catch (error) {
            showToast(`Error: ${error.message}`, true);
        }
    });

});