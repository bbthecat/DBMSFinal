// ============================================================
// แอปพลิเคชัน SPA หลัก - ระบบจัดการร้านยา
// จัดการ Router, Auth, และ API Helper
// ============================================================

// ===================== ตัวแปร Global =====================
let currentUser = null;  // ข้อมูลผู้ใช้ที่ Login อยู่
let currentPage = 'dashboard';  // หน้าปัจจุบัน
let cart = [];  // ตะกร้าสินค้า POS

// ===================== ตรวจสอบสิทธิ์ =====================
// เช็คว่าผู้ใช้เป็นผู้จัดการ/Owner หรือไม่
function isManager() {
    if (!currentUser) return false;
    const pos = (currentUser.POSITION || '').trim();
    return ['Manager', 'Owner', 'ผู้จัดการ'].includes(pos);
}
// เมนูที่เฉพาะ Manager/Owner เห็น
const managerOnlyPages = ['employees'];
// เมนูที่ Emp ธรรมดาไม่ควรเห็น
const managerPages = ['employees', 'suppliers', 'categories', 'purchases'];

// ===================== API Helper (AJAX) =====================
// ฟังก์ชันช่วยเรียก API: ใช้หลักการ Fetch API คุยกับ Backend (Node.js) แบบไม่รีเฟรชหน้า (Asynchronous)
async function api(url, options = {}) {
    try {
        const res = await fetch(url, {
            headers: { 'Content-Type': 'application/json' },
            credentials: 'same-origin',
            ...options
        });
        const data = await res.json();
        if (!res.ok) throw new Error(data.error || 'เกิดข้อผิดพลาด');
        return data;
    } catch (err) {
        throw err;
    }
}

// ===================== Toast แจ้งเตือน =====================
function showToast(message, type = 'success') {
    const container = document.getElementById('toast-container');
    const icons = { success: 'check_circle', error: 'error', warning: 'warning' };
    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    toast.innerHTML = `
        <span class="material-symbols-rounded">${icons[type]}</span>
        <span class="toast-message">${message}</span>
    `;
    container.appendChild(toast);
    setTimeout(() => toast.remove(), 3000);
}

// ===================== Modal =====================
function openModal(title, bodyHtml) {
    document.getElementById('modal-title').textContent = title;
    document.getElementById('modal-body').innerHTML = bodyHtml;
    document.getElementById('modal-overlay').style.display = 'flex';
}
function closeModal() {
    document.getElementById('modal-overlay').style.display = 'none';
}

// ===================== Format =====================
function formatNumber(n) {
    return Number(n || 0).toLocaleString('th-TH', { minimumFractionDigits: 0 });
}
function formatCurrency(n) {
    return '฿' + Number(n || 0).toLocaleString('th-TH', { minimumFractionDigits: 2 });
}
function generateId(prefix, len = 13) {
    const num = Date.now().toString().slice(-10) + Math.floor(Math.random() * 100).toString().padStart(2, '0');
    return (prefix + num).slice(0, len);
}

// ===================== วันที่ปัจจุบัน =====================
function updateCurrentDate() {
    const now = new Date();
    const opts = { year: 'numeric', month: 'long', day: 'numeric', weekday: 'long' };
    document.getElementById('current-date').textContent = now.toLocaleDateString('th-TH', opts);
}

// ============================================================
// ระบบ Login / Logout
// ============================================================
document.getElementById('login-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    const errEl = document.getElementById('login-error');
    errEl.style.display = 'none';

    const username = document.getElementById('login-username').value.trim();
    const password = document.getElementById('login-password').value;

    try {
        const data = await api('/api/login', {
            method: 'POST',
            body: JSON.stringify({ username, password })
        });
        currentUser = data.user;
        showApp();
    } catch (err) {
        errEl.textContent = err.message;
        errEl.style.display = 'block';
    }
});

document.getElementById('btn-logout').addEventListener('click', async () => {
    try {
        await api('/api/logout', { method: 'POST' });
    } catch (e) { }
    currentUser = null;
    document.getElementById('app').style.display = 'none';
    document.getElementById('login-page').style.display = 'flex';
    document.getElementById('login-username').value = '';
    document.getElementById('login-password').value = '';
});

// ตรวจสอบ Session เดิม
async function checkSession() {
    try {
        const data = await api('/api/me');
        currentUser = data.user;
        showApp();
    } catch (e) {
        document.getElementById('login-page').style.display = 'flex';
    }
}

// แสดงแอปหลัก
function showApp() {
    document.getElementById('login-page').style.display = 'none';
    document.getElementById('app').style.display = 'flex';
    document.getElementById('user-display-name').textContent = currentUser.FIRST_NAME + ' ' + currentUser.LAST_NAME;
    document.getElementById('user-position').textContent = currentUser.POSITION;
    updateCurrentDate();

    // ===================== ซ่อน/แสดงเมนูตามสิทธิ์ =====================
    // Emp ธรรมดา → ซ่อนเมนูจัดการพนักงาน, Supplier, หมวดหมู่, ใบสั่งซื้อ
    document.querySelectorAll('.nav-item').forEach(item => {
        const page = item.dataset.page;
        if (managerPages.includes(page)) {
            item.style.display = isManager() ? '' : 'none';
        }
    });

    navigateTo('dashboard');
}

// ============================================================
// Router - นำทางระหว่างหน้า
// ============================================================
document.querySelectorAll('.nav-item').forEach(item => {
    item.addEventListener('click', (e) => {
        e.preventDefault();
        navigateTo(item.dataset.page);
        // ปิด sidebar บน mobile
        document.getElementById('sidebar').classList.remove('open');
    });
});

// ปุ่ม Menu (mobile)
document.getElementById('btn-menu').addEventListener('click', () => {
    document.getElementById('sidebar').classList.toggle('open');
});

// ปิด Modal
document.getElementById('modal-close').addEventListener('click', closeModal);
document.getElementById('modal-overlay').addEventListener('click', (e) => {
    if (e.target === document.getElementById('modal-overlay')) closeModal();
});

// ชื่อหน้าภาษาไทย
const pageTitles = {
    dashboard: 'แดชบอร์ด', pos: 'ขายยา (POS)', products: 'สินค้า/ยา',
    batches: 'ล็อตสินค้า', purchases: 'ใบสั่งซื้อ', sales: 'ประวัติขาย',
    employees: 'พนักงาน', suppliers: 'Supplier', categories: 'หมวดหมู่ยา',
    reports: 'รายงาน'
};

function navigateTo(page) {
    currentPage = page;
    document.getElementById('page-title').textContent = pageTitles[page] || page;

    // อัพเดท Active Nav
    document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
    const navItem = document.querySelector(`.nav-item[data-page="${page}"]`);
    if (navItem) navItem.classList.add('active');

    // โหลดเนื้อหาหน้า
    const content = document.getElementById('content-area');
    content.innerHTML = '<div class="loading"><div class="spinner"></div></div>';

    // เรียกฟังก์ชันโหลดหน้า
    const pages = {
        dashboard: loadDashboard, pos: loadPOS, products: loadProducts,
        batches: loadBatches, purchases: loadPurchases, sales: loadSales,
        employees: loadEmployees, suppliers: loadSuppliers, categories: loadCategories,
        reports: loadReports
    };
    if (pages[page]) pages[page]();
}

// ============================================================
// หน้า Dashboard
// ============================================================
async function loadDashboard() {
    try {
        const data = await api('/api/dashboard');
        const content = document.getElementById('content-area');
        content.innerHTML = `
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">💰</div>
                    <div class="stat-value">${formatCurrency(data.todaySales.TOTAL_REVENUE)}</div>
                    <div class="stat-label">ยอดขายวันนี้</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">🧾</div>
                    <div class="stat-value">${formatNumber(data.todaySales.SALE_COUNT)}</div>
                    <div class="stat-label">จำนวนบิลวันนี้</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">💊</div>
                    <div class="stat-value">${formatNumber(data.productCount)}</div>
                    <div class="stat-label">สินค้าทั้งหมด</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">⚠️</div>
                    <div class="stat-value">${formatNumber(data.lowStock.length)}</div>
                    <div class="stat-label">สินค้าสต็อกต่ำ</div>
                </div>
            </div>
            <div class="dashboard-grid">
                <div class="data-section">
                    <div class="data-header"><h2><span class="material-symbols-rounded">warning</span> สินค้าสต็อกต่ำ</h2></div>
                    <table class="data-table"><thead><tr>
                        <th>ชื่อสินค้า</th><th>คงเหลือ</th><th>จุดสั่งซื้อ</th>
                    </tr></thead><tbody>
                    ${data.lowStock.length === 0 ? '<tr><td colspan="3" class="table-empty">ไม่มีสินค้าสต็อกต่ำ ✅</td></tr>' :
                data.lowStock.map(i => `<tr>
                        <td>${i.PRODUCT_NAME}</td>
                        <td><span class="badge badge-danger">${formatNumber(i.CURRENT_STOCK)}</span></td>
                        <td>${formatNumber(i.REORDER_POINT)}</td>
                    </tr>`).join('')}
                    </tbody></table>
                </div>
                <div class="data-section">
                    <div class="data-header"><h2><span class="material-symbols-rounded">schedule</span> ยาใกล้หมดอายุ (90 วัน)</h2></div>
                    <table class="data-table"><thead><tr>
                        <th>สินค้า</th><th>Lot</th><th>หมดอายุ</th><th>เหลือ</th>
                    </tr></thead><tbody>
                    ${data.expiringSoon.length === 0 ? '<tr><td colspan="4" class="table-empty">ไม่มียาใกล้หมดอายุ ✅</td></tr>' :
                data.expiringSoon.map(i => `<tr>
                        <td>${i.PRODUCT_NAME}</td>
                        <td>${(i.LOT_NUMBER || '').trim()}</td>
                        <td><span class="badge badge-warning">${i.EXP_DATE}</span></td>
                        <td>${i.DAYS_LEFT} วัน</td>
                    </tr>`).join('')}
                    </tbody></table>
                </div>
            </div>
            <div class="data-section" style="margin-top:20px;">
                <div class="data-header"><h2><span class="material-symbols-rounded">receipt_long</span> รายการขายล่าสุด</h2></div>
                <table class="data-table"><thead><tr>
                    <th>รหัสบิล</th><th>วันที่</th><th>ยอดรวม</th><th>พนักงาน</th>
                </tr></thead><tbody>
                ${data.recentSales.length === 0 ? '<tr><td colspan="4" class="table-empty">ยังไม่มีรายการขาย</td></tr>' :
                data.recentSales.map(s => `<tr>
                    <td>${(s.SALE_ID || '').trim()}</td>
                    <td>${s.SALE_DATE}</td>
                    <td style="color:var(--accent);font-weight:600">${formatCurrency(s.TOTAL_AMOUNT)}</td>
                    <td>${s.EMP_NAME}</td>
                </tr>`).join('')}
                </tbody></table>
            </div>
            <div class="data-section" style="margin-top:20px;">
                <div class="data-header"><h2><span class="material-symbols-rounded">bar_chart</span> ยอดขายรายเดือน</h2></div>
                <div style="padding:15px;max-height:350px;"><canvas id="chart-monthly"></canvas></div>
            </div>
        `;
        // โหลดกราฟยอดขายรายเดือน
        try {
            const monthly = await api('/api/reports/monthly-sales');
            if (monthly.length > 0 && document.getElementById('chart-monthly')) {
                new Chart(document.getElementById('chart-monthly'), {
                    type: 'bar',
                    data: {
                        labels: monthly.map(m => m.SALE_MONTH),
                        datasets: [{
                            label: 'ยอดขาย (บาท)',
                            data: monthly.map(m => m.TOTAL_REVENUE),
                            backgroundColor: 'rgba(0,212,170,0.6)',
                            borderColor: '#00d4aa',
                            borderWidth: 2,
                            borderRadius: 8
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: { legend: { labels: { color: '#b8c5d6' } } },
                        scales: {
                            x: { ticks: { color: '#8696a8' }, grid: { color: 'rgba(255,255,255,0.05)' } },
                            y: { ticks: { color: '#8696a8' }, grid: { color: 'rgba(255,255,255,0.05)' } }
                        }
                    }
                });
            }
        } catch (e) { }
    } catch (err) {
        document.getElementById('content-area').innerHTML = `<p style="color:var(--danger)">❌ ${err.message}</p>`;
    }
}

// ============================================================
// หน้า POS (ขายยา)
// ============================================================
let posProducts = [];

async function loadPOS() {
    try {
        posProducts = await api('/api/batches/available');
        cart = [];
        renderPOS();
    } catch (err) {
        document.getElementById('content-area').innerHTML = `<p style="color:var(--danger)">❌ ${err.message}</p>`;
    }
}

let posCategory = 'all'; // หมวดหมู่ที่เลือกอยู่

function renderPOS() {
    const content = document.getElementById('content-area');
    const grouped = {};
    posProducts.forEach(b => {
        const pid = (b.PRODUCT_ID || '').trim();
        if (!grouped[pid]) {
            grouped[pid] = { ...b, batches: [] };
        }
        grouped[pid].batches.push(b);
    });
    const products = Object.values(grouped);

    // สร้าง list หมวดหมู่จากสินค้าที่มี
    const catMap = {};
    products.forEach(p => {
        const cid = (p.CATEGORY_ID || '').trim();
        if (cid && !catMap[cid]) {
            let catName = p.CATEGORY_NAME || cid;
            // ดึงเฉพาะภาษาไทยในวงเล็บ เช่น "Analgesics And Antipyretics (ยาแก้ปวดลดไข้)" -> "ยาแก้ปวดลดไข้"
            const match = catName.match(/\((.*?)\)/);
            if (match) catName = match[1];

            catMap[cid] = { id: cid, name: catName, count: 0 };
        }
        if (cid) catMap[cid].count++;
    });
    const categories = Object.values(catMap);

    content.innerHTML = `
        <div class="pos-layout">
            <div class="pos-products">
                <div class="data-header" style="background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius) var(--radius) 0 0;">
                    <h2><span class="material-symbols-rounded">medication</span> เลือกสินค้า</h2>
                    <div class="search-box">
                        <span class="material-symbols-rounded">search</span>
                        <input type="text" id="pos-search" placeholder="ค้นหายา..." oninput="filterPOSProducts()">
                    </div>
                </div>
                <div class="pos-category-tabs" id="pos-category-tabs">
                    <button class="cat-tab ${posCategory === 'all' ? 'active' : ''}" onclick="selectPOSCategory('all')">
                        <span class="material-symbols-rounded" style="font-size:16px">apps</span> ทั้งหมด
                        <span class="cat-count">${products.length}</span>
                    </button>
                    ${categories.map(c => `
                        <button class="cat-tab ${posCategory === c.id ? 'active' : ''}" onclick="selectPOSCategory('${c.id}')">
                            ${c.name}
                            <span class="cat-count">${c.count}</span>
                        </button>
                    `).join('')}
                </div>
                <div class="pos-product-grid" id="pos-product-grid">
                    ${products.map(p => `
                        <div class="pos-product-card" data-category="${(p.CATEGORY_ID || '').trim()}" onclick='addToCart(${JSON.stringify(p.batches).replace(/'/g, "\\\\'")})'> 
                            <div class="prod-name">${p.PRODUCT_NAME}</div>
                            <div class="prod-generic">${p.GENERIC_NAME || ''}</div>
                            <div class="prod-price">${formatCurrency(p.UNIT_PRICE)}</div>
                            <div class="prod-stock">คงเหลือ: ${p.batches.reduce((s, b) => s + b.REMAINING_QTY, 0)} ชิ้น</div>
                        </div>
                    `).join('')}
                </div>
            </div>
            <div class="pos-cart">
                <div class="pos-cart-header">
                    <span class="material-symbols-rounded" style="color:var(--accent)">shopping_cart</span>
                    <h3>ตะกร้าสินค้า</h3>
                    <span class="badge badge-primary" id="cart-count">${cart.length} รายการ</span>
                </div>
                <div class="pos-cart-items" id="pos-cart-items">
                    ${cart.length === 0 ? '<div class="cart-empty"><span class="material-symbols-rounded">add_shopping_cart</span>คลิกสินค้าเพื่อเพิ่มลงตะกร้า</div>' : ''}
                </div>
                <div class="pos-cart-footer">
                    <div class="cart-total-row grand-total">
                        <span>ยอดรวมทั้งหมด</span>
                        <span class="total-value" id="cart-total">${formatCurrency(0)}</span>
                    </div>
                    <button class="btn btn-success btn-checkout" onclick="checkout()" ${cart.length === 0 ? 'disabled' : ''}>
                        <span class="material-symbols-rounded">payments</span> ชำระเงิน
                    </button>
                </div>
            </div>
        </div>
    `;
    renderCartItems();
    filterPOSProducts(); // apply current filter
}

function selectPOSCategory(catId) {
    posCategory = catId;
    // update active tab
    document.querySelectorAll('.cat-tab').forEach(tab => tab.classList.remove('active'));
    event.currentTarget.classList.add('active');
    filterPOSProducts();
}

function addToCart(batches) {
    // เลือก batch ที่หมดอายุก่อน (FEFO)
    const batch = batches.find(b => b.REMAINING_QTY > 0);
    if (!batch) { showToast('สินค้าหมด', 'warning'); return; }

    const existing = cart.find(c => c.BATCH_ID === batch.BATCH_ID);
    if (existing) {
        if (existing.Quantity >= batch.REMAINING_QTY) {
            showToast('สินค้าในสต็อกไม่พอ', 'warning');
            return;
        }
        existing.Quantity++;
    } else {
        cart.push({
            BATCH_ID: batch.BATCH_ID,
            PRODUCT_NAME: batch.PRODUCT_NAME,
            Unit_Price: batch.UNIT_PRICE,
            Quantity: 1,
            Discount: 0,
            maxQty: batch.REMAINING_QTY
        });
    }
    renderCartItems();
}

function renderCartItems() {
    const container = document.getElementById('pos-cart-items');
    if (!container) return;
    if (cart.length === 0) {
        container.innerHTML = '<div class="cart-empty"><span class="material-symbols-rounded">add_shopping_cart</span>คลิกสินค้าเพื่อเพิ่มลงตะกร้า</div>';
    } else {
        container.innerHTML = cart.map((item, i) => `
            <div class="cart-item">
                <div class="cart-item-info">
                    <div class="cart-item-name">${item.PRODUCT_NAME}</div>
                    <div class="cart-item-price">${formatCurrency(item.Unit_Price)} / ชิ้น</div>
                </div>
                <div class="cart-item-qty">
                    <button onclick="changeQty(${i},-1)">−</button>
                    <span>${item.Quantity}</span>
                    <button onclick="changeQty(${i},1)">+</button>
                </div>
                <div class="cart-item-subtotal">${formatCurrency(item.Unit_Price * item.Quantity)}</div>
                <button class="cart-item-remove" onclick="removeFromCart(${i})">
                    <span class="material-symbols-rounded" style="font-size:18px">close</span>
                </button>
            </div>
        `).join('');
    }
    // อัพเดทยอดรวม
    const total = cart.reduce((s, i) => s + (i.Unit_Price * i.Quantity - i.Discount), 0);
    const totalEl = document.getElementById('cart-total');
    if (totalEl) totalEl.textContent = formatCurrency(total);
    const countEl = document.getElementById('cart-count');
    if (countEl) countEl.textContent = cart.length + ' รายการ';
    const checkoutBtn = document.querySelector('.btn-checkout');
    if (checkoutBtn) checkoutBtn.disabled = cart.length === 0;
}

function changeQty(index, delta) {
    cart[index].Quantity += delta;
    if (cart[index].Quantity <= 0) { cart.splice(index, 1); }
    else if (cart[index].Quantity > cart[index].maxQty) {
        cart[index].Quantity = cart[index].maxQty;
        showToast('สินค้าในสต็อกไม่พอ', 'warning');
    }
    renderCartItems();
}
function removeFromCart(index) { cart.splice(index, 1); renderCartItems(); }

function filterPOSProducts() {
    const searchEl = document.getElementById('pos-search');
    const query = searchEl ? searchEl.value.toLowerCase() : '';
    const cards = document.querySelectorAll('.pos-product-card');
    cards.forEach(card => {
        const name = card.querySelector('.prod-name').textContent.toLowerCase();
        const generic = card.querySelector('.prod-generic').textContent.toLowerCase();
        const cat = card.dataset.category || '';
        const matchSearch = !query || name.includes(query) || generic.includes(query);
        const matchCat = posCategory === 'all' || cat === posCategory;
        card.style.display = (matchSearch && matchCat) ? '' : 'none';
    });
}

async function checkout() {
    if (cart.length === 0) return;
    // ID สร้างจาก Sequence อัตโนมัติใน DB ไม่ต้องส่งจาก Frontend
    const items = cart.map(item => ({
        Batch_ID: item.BATCH_ID,
        Quantity: item.Quantity,
        Unit_Price: item.Unit_Price,
        Discount: item.Discount
    }));
    try {
        await api('/api/sales', {
            method: 'POST',
            body: JSON.stringify({ items })
        });
        showToast('บันทึกการขายสำเร็จ!', 'success');
        cart = [];
        loadPOS();
    } catch (err) {
        showToast(err.message, 'error');
    }
}

// ============================================================
// หน้าสินค้า/ยา (Products)
// ============================================================
async function loadProducts() {
    try {
        const products = await api('/api/products');
        const categories = await api('/api/categories');
        const content = document.getElementById('content-area');
        content.innerHTML = `
            <div class="data-section">
                <div class="data-header">
                    <h2><span class="material-symbols-rounded">medication</span> รายการสินค้า/ยา</h2>
                    <div class="data-actions">
                        <div class="search-box">
                            <span class="material-symbols-rounded">search</span>
                            <input type="text" id="product-search" placeholder="ค้นหายา..." oninput="filterTable('product-table',this.value)">
                        </div>
                        ${isManager() ? `<button class="btn btn-primary" onclick="showProductModal(null, ${JSON.stringify(categories).replace(/"/g, '&quot;')})">
                            <span class="material-symbols-rounded">add</span> เพิ่มสินค้า
                        </button>` : ''}
                    </div>
                </div>
                <div style="overflow-x:auto">
                <table class="data-table" id="product-table"><thead><tr>
                    <th>รหัส</th><th>ชื่อยา</th><th>ชื่อสามัญ</th><th>หมวดหมู่</th>
                    <th>ประเภท</th><th>ราคา</th><th>สต็อก</th>${isManager() ? '<th>จัดการ</th>' : ''}
                </tr></thead><tbody>
                ${products.length === 0 ? '<tr><td colspan="8" class="table-empty">ยังไม่มีสินค้า</td></tr>' :
                products.map(p => `<tr>
                    <td style="font-size:0.78rem;color:var(--text-muted)">${(p.PRODUCT_ID || '').trim()}</td>
                    <td><strong>${p.PRODUCT_NAME}</strong></td>
                    <td style="color:var(--text-secondary)">${p.GENERIC_NAME || '-'}</td>
                    <td><span class="badge badge-info">${p.CATEGORY_NAME || '-'}</span></td>
                    <td>${p.DRUG_TYPE || '-'}</td>
                    <td style="color:var(--accent);font-weight:600">${formatCurrency(p.UNIT_PRICE)}</td>
                    <td>${p.TOTAL_STOCK < p.REORDER_POINT ? `<span class="badge badge-danger">${formatNumber(p.TOTAL_STOCK)}</span>` : `<span class="badge badge-success">${formatNumber(p.TOTAL_STOCK)}</span>`}</td>
                    ${isManager() ? `<td>
                        <button class="btn btn-outline btn-sm" onclick='showProductModal(${JSON.stringify(p).replace(/'/g, "&#39;")}, ${JSON.stringify(categories).replace(/'/g, "&#39;")})'>
                            <span class="material-symbols-rounded">edit</span>
                        </button>
                        <button class="btn btn-danger btn-sm" onclick="deleteProduct('${(p.PRODUCT_ID || '').trim()}')">
                            <span class="material-symbols-rounded">delete</span>
                        </button>
                    </td>` : ''}
                </tr>`).join('')}
                </tbody></table>
                </div>
            </div>
        `;
    } catch (err) {
        document.getElementById('content-area').innerHTML = `<p style="color:var(--danger)">❌ ${err.message}</p>`;
    }
}

function showProductModal(product, categories) {
    const isEdit = !!product;
    openModal(isEdit ? 'แก้ไขสินค้า' : 'เพิ่มสินค้าใหม่', `
        <form id="product-form">
            <div class="form-group">
                <label>รหัสสินค้า</label>
                <input type="text" id="pf-id" value="${isEdit ? (product.PRODUCT_ID || '').trim() : generateId('PRD')}" ${isEdit ? 'readonly' : ''} required maxlength="13">
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>ชื่อยา</label>
                    <input type="text" id="pf-name" value="${isEdit ? product.PRODUCT_NAME || '' : ''}" required>
                </div>
                <div class="form-group">
                    <label>ชื่อสามัญ (Generic)</label>
                    <input type="text" id="pf-generic" value="${isEdit ? product.GENERIC_NAME || '' : ''}">
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>ประเภทยา</label>
                    <select id="pf-type">
                        <option value="ยาสามัญ" ${isEdit && product.DRUG_TYPE === 'ยาสามัญ' ? 'selected' : ''}>ยาสามัญ</option>
                        <option value="ยาอันตราย" ${isEdit && product.DRUG_TYPE === 'ยาอันตราย' ? 'selected' : ''}>ยาอันตราย</option>
                        <option value="อาหารเสริม" ${isEdit && product.DRUG_TYPE === 'อาหารเสริม' ? 'selected' : ''}>อาหารเสริม</option>
                        <option value="ยาทาภายนอก" ${isEdit && product.DRUG_TYPE === 'ยาทาภายนอก' ? 'selected' : ''}>ยาทาภายนอก</option>
                        <option value="เวชภัณฑ์" ${isEdit && product.DRUG_TYPE === 'เวชภัณฑ์' ? 'selected' : ''}>เวชภัณฑ์</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>หมวดหมู่</label>
                    <select id="pf-cat">
                        ${categories.map(c => `<option value="${c.CATEGORY_ID}" ${isEdit && (product.CATEGORY_ID || '').trim() === c.CATEGORY_ID.trim() ? 'selected' : ''}>${c.CATEGORY_NAME}</option>`).join('')}
                    </select>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>ราคาขาย (บาท)</label>
                    <input type="number" id="pf-price" value="${isEdit ? product.UNIT_PRICE || '' : ''}" required min="0" step="0.01">
                </div>
                <div class="form-group">
                    <label>จำนวน/แพ็ค</label>
                    <input type="number" id="pf-pack" value="${isEdit ? product.UNIT_PER_PACK || '' : ''}" required min="1">
                </div>
            </div>
            <div class="form-group">
                <label>จุดสั่งซื้อ (Reorder Point)</label>
                <input type="number" id="pf-reorder" value="${isEdit ? product.REORDER_POINT || '' : ''}" required min="0">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeModal()">ยกเลิก</button>
                <button type="submit" class="btn btn-primary">${isEdit ? 'บันทึกการแก้ไข' : 'เพิ่มสินค้า'}</button>
            </div>
        </form>
    `);
    document.getElementById('product-form').onsubmit = async (e) => {
        e.preventDefault();
        const body = {
            Product_ID: document.getElementById('pf-id').value.trim(),
            Product_Name: document.getElementById('pf-name').value,
            Generic_Name: document.getElementById('pf-generic').value,
            Drug_type: document.getElementById('pf-type').value,
            Category_ID: document.getElementById('pf-cat').value,
            Unit_Price: Number(document.getElementById('pf-price').value),
            Unit_per_pack: Number(document.getElementById('pf-pack').value),
            Reorder_Point: Number(document.getElementById('pf-reorder').value)
        };
        try {
            if (isEdit) {
                await api(`/api/products/${body.Product_ID}`, { method: 'PUT', body: JSON.stringify(body) });
                showToast('แก้ไขสินค้าสำเร็จ');
            } else {
                await api('/api/products', { method: 'POST', body: JSON.stringify(body) });
                showToast('เพิ่มสินค้าสำเร็จ');
            }
            closeModal();
            loadProducts();
        } catch (err) { showToast(err.message, 'error'); }
    };
}

async function deleteProduct(id) {
    if (!confirm('ต้องการลบสินค้านี้หรือไม่?')) return;
    try {
        await api(`/api/products/${id}`, { method: 'DELETE' });
        showToast('ลบสินค้าสำเร็จ');
        loadProducts();
    } catch (err) { showToast(err.message, 'error'); }
}

// ============================================================
// หน้า Batch (ล็อตสินค้า)
// ============================================================
let allBatchesData = [];

async function loadBatches() {
    try {
        allBatchesData = await api('/api/batches');
        renderBatchesView();
    } catch (err) {
        document.getElementById('content-area').innerHTML = `<p style="color:var(--danger)">❌ ${err.message}</p>`;
    }
}

function renderBatchesView() {
    const content = document.getElementById('content-area');

    // 1. Render Framework & Filters if they don't exist
    if (!document.getElementById('batch-filter-status')) {
        content.innerHTML = `
            <div class="data-section" style="padding-bottom: 30px;">
                <div class="data-header" style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:10px;">
                    <h2><span class="material-symbols-rounded">inventory_2</span> ล็อตสินค้า (Batch & Expiry)</h2>
                    <div style="display:flex; gap:10px; align-items:center; background:#f8f9fc; padding:8px 15px; border-radius:8px; border:1px solid var(--border);">
                        <span class="material-symbols-rounded" style="color:var(--text-secondary); font-size:1.2rem;">filter_list</span>
                        <input type="text" id="batch-search" placeholder="ค้นหาชื่อยา หรือเลข Lot..." class="form-input" oninput="renderBatchesView()" style="width:200px; padding:6px 10px; border-radius:6px; border:1px solid #ccc;">
                        <select id="batch-filter-status" onchange="renderBatchesView()" style="padding:6px 10px; border-radius:6px; border:1px solid #ccc; outline:none; cursor:pointer;">
                            <option value="active" selected>📦 ซ่อนล็อตที่ขายหมดแล้ว (เหลือ > 0)</option>
                            <option value="all">📝 แสดงประวัติทุกล็อตทั้งหมด</option>
                            <option value="expiring">⚠️ เฉพาะยาใกล้หมดอายุ / หมดอายุ</option>
                        </select>
                    </div>
                </div>
                <div id="batches-container" style="margin-top:20px; display:flex; flex-direction:column; gap:12px;"></div>
            </div>
            <style>
                details.batch-group {
                    border: 1px solid var(--border);
                    border-radius: 8px;
                    background: #fff;
                    overflow: hidden;
                    box-shadow: 0 2px 6px rgba(0,0,0,0.02);
                    transition: all 0.2s ease;
                }
                details.batch-group[open] {
                    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
                    border-color: var(--primary);
                }
                details.batch-group summary {
                    background: #fdfdfd;
                    padding: 14px 18px;
                    cursor: pointer;
                    font-weight: 600;
                    font-size: 1.05rem;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    border-bottom: 1px solid transparent; /* default hidden */
                    list-style: none; /* hide arrow */
                    user-select: none;
                }
                details.batch-group[open] summary {
                    background: #f0f4ff;
                    border-bottom: 1px solid var(--border);
                }
                details.batch-group summary::-webkit-details-marker { display: none; }
                .batch-group-content { padding: 0; }
            </style>
        `;
    }

    // 2. Filter the Data
    const searchQuery = document.getElementById('batch-search') ? document.getElementById('batch-search').value.toLowerCase().trim() : '';
    const statusFilter = document.getElementById('batch-filter-status') ? document.getElementById('batch-filter-status').value : 'active';

    let filtered = allBatchesData.filter(b => {
        // Search text
        if (searchQuery) {
            const matchName = (b.PRODUCT_NAME || '').toLowerCase().includes(searchQuery);
            const matchLot = (b.LOT_NUMBER || '').toLowerCase().includes(searchQuery);
            if (!matchName && !matchLot) return false;
        }
        // Filters
        if (statusFilter === 'active' && b.REMAINING_QTY <= 0) return false;
        if (statusFilter === 'expiring' && b.STATUS !== 'ใกล้หมดอายุ' && b.STATUS !== 'หมดอายุแล้ว') return false;
        return true;
    });

    // ขั้นตอนที่ 3: Group by Product Name (จับกลุ่มตามชื่อยาจัดเป็นหมวดหมู่)
    // การทำ Grouping ด้วย JavaScript (เหมือน GROUP BY ใน SQL)
    const groups = {};
    filtered.forEach(b => {
        const pName = b.PRODUCT_NAME || 'ไม่ระบุชื่อสินค้า';
        if (!groups[pName]) groups[pName] = { batches: [], totalRemaining: 0 };
        groups[pName].batches.push(b);
        groups[pName].totalRemaining += b.REMAINING_QTY;
    });

    const container = document.getElementById('batches-container');
    if (Object.keys(groups).length === 0) {
        container.innerHTML = '<div style="padding:40px; text-align:center; color:var(--text-secondary); background:#fafafa; border-radius:8px; border:1px dashed #ddd;"><span class="material-symbols-rounded" style="font-size:3rem; opacity:0.5; margin-bottom:10px; display:block;">search_off</span> ไม่พบข้อมูลล็อตสินค้าตามเงื่อนไขที่เลือก</div>';
        return;
    }

    // 4. Generate HTML
    let html = '';
    // Sort products alphabetically
    Object.keys(groups).sort().forEach(pName => {
        const group = groups[pName];

        // Auto-open if searching or viewing expiring, otherwise keep closed if lots of data
        const shouldBeOpen = (statusFilter !== 'all' || searchQuery.length > 0) ? 'open' : '';

        html += `
            <details class="batch-group" ${shouldBeOpen}>
                <summary>
                    <div style="display:flex; align-items:center; gap:8px;">
                        <span class="material-symbols-rounded" style="color:var(--primary); font-size:1.4rem;">medication</span>
                        <span style="font-size:1.1rem; color:var(--dark);">${pName}</span>
                    </div>
                    <div style="font-size:0.95rem; color:var(--text-secondary); font-weight:normal; display:flex; gap:15px; align-items:center;">
                        <span>ทั้งหมด <b style="color:#555">${group.batches.length}</b> ล็อต</span>
                        <span style="background:#fff; padding:2px 8px; border-radius:4px; border:1px solid #ddd;">
                            คงเหลือรวม: <b style="color:var(--accent); font-size:1.1rem; margin-left:4px;">${formatNumber(group.totalRemaining)}</b>
                        </span>
                    </div>
                </summary>
                <div class="batch-group-content">
                    <table class="data-table" style="margin-bottom:0; box-shadow:none; border-radius:0; border:none;">
                        <thead style="background:#fff;"><tr>
                            <th style="padding:10px 16px; border-bottom:1px solid #eee;">Lot No.</th>
                            <th style="padding:10px 16px; border-bottom:1px solid #eee;">วันผลิต</th>
                            <th style="padding:10px 16px; border-bottom:1px solid #eee;">วันหมดอายุ</th>
                            <th style="padding:10px 16px; border-bottom:1px solid #eee; text-align:right;">รับเข้า (ตอนสั่ง)</th>
                            <th style="padding:10px 16px; border-bottom:1px solid #eee; text-align:right;">คงเหลือตอนนี้</th>
                            <th style="padding:10px 16px; border-bottom:1px solid #eee;">สถานะความสดใหม่</th>
                        </tr></thead>
                        <tbody>
                            ${group.batches.map(b => {
            let badgeClass = b.STATUS === 'หมดอายุแล้ว' ? 'badge-danger' : b.STATUS === 'ใกล้หมดอายุ' ? 'badge-warning' : 'badge-success';
            let statusText = b.STATUS;
            // ถ้ายาหมดเกลี้ยงแล้วแต่ค้างในระบบ
            if (b.REMAINING_QTY === 0 && b.STATUS === 'ปกติ') {
                badgeClass = 'badge-danger';
                statusText = 'ขายหมดแล้ว';
            }
            return `
                                <tr style="${b.REMAINING_QTY === 0 ? 'background-color:#fafafa; opacity:0.7;' : ''}">
                                    <td style="padding:8px 16px; font-size:0.85rem; font-family:monospace; color:#555;">${(b.LOT_NUMBER || '').trim()}</td>
                                    <td style="padding:8px 16px; font-size:0.85rem;">${b.MFG_DATE}</td>
                                    <td style="padding:8px 16px; font-size:0.85rem; font-weight:500;">${b.EXP_DATE}</td>
                                    <td style="padding:8px 16px; font-size:0.9rem; text-align:right; color:#888;">${formatNumber(b.RECEIVED_QTY)}</td>
                                    <td style="padding:8px 16px; font-size:0.95rem; text-align:right; font-weight:600; color:${b.REMAINING_QTY > 0 ? 'var(--dark)' : 'var(--danger)'};">${formatNumber(b.REMAINING_QTY)}</td>
                                    <td style="padding:8px 16px;">
                                        <span class="badge ${badgeClass}">${statusText}</span>
                                    </td>
                                </tr>
                                `
        }).join('')}
                        </tbody>
                    </table>
                </div>
            </details>
        `;
    });

    container.innerHTML = html;
}

// ============================================================
// หน้าประวัติขาย (Sales)
// ============================================================
async function loadSales() {
    try {
        const sales = await api('/api/sales');
        const content = document.getElementById('content-area');
        content.innerHTML = `
            <div class="data-section">
                <div class="data-header">
                    <h2><span class="material-symbols-rounded">receipt_long</span> ประวัติการขาย</h2>
                </div>
                <div style="overflow-x:auto">
                <table class="data-table"><thead><tr>
                    <th>รหัสบิล</th><th>วันที่-เวลา</th><th>ยอดรวม</th><th>พนักงาน</th><th>ดูรายละเอียด</th>
                </tr></thead><tbody>
                ${sales.length === 0 ? '<tr><td colspan="5" class="table-empty">ยังไม่มีประวัติขาย</td></tr>' :
                sales.map(s => `<tr>
                    <td>${(s.SALE_ID || '').trim()}</td>
                    <td>${s.SALE_DATE}</td>
                    <td style="color:var(--accent);font-weight:600">${formatCurrency(s.TOTAL_AMOUNT)}</td>
                    <td>${s.EMP_NAME || '-'}</td>
                    <td><button class="btn btn-outline btn-sm" onclick="viewSaleDetail('${(s.SALE_ID || '').trim()}')">
                        <span class="material-symbols-rounded">visibility</span> ดู
                    </button>
                    <button class="btn btn-primary btn-sm" onclick="printReceipt('${(s.SALE_ID || '').trim()}')" style="margin-left:4px">
                        <span class="material-symbols-rounded">print</span> พิมพ์
                    </button></td>
                </tr>`).join('')}
                </tbody></table>
                </div>
            </div>
        `;
    } catch (err) { document.getElementById('content-area').innerHTML = `<p style="color:var(--danger)">❌ ${err.message}</p>`; }
}

async function viewSaleDetail(id) {
    try {
        const data = await api(`/api/sales/${id}`);
        openModal(`รายละเอียดบิล: ${id}`, `
            <p style="margin-bottom:12px;color:var(--text-secondary)">วันที่: ${data.header.SALE_DATE_STR} | พนักงาน: ${data.header.EMP_NAME}</p>
            <table class="data-table"><thead><tr>
                <th>สินค้า</th><th>จำนวน</th><th>ราคา</th><th>ส่วนลด</th><th>รวม</th>
            </tr></thead><tbody>
            ${data.details.map(d => `<tr>
                <td>${d.PRODUCT_NAME || '-'}</td><td>${d.QUANTITY}</td>
                <td>${formatCurrency(d.UNIT_PRICE)}</td><td>${formatCurrency(d.DISCOUNT)}</td>
                <td style="color:var(--accent);font-weight:600">${formatCurrency(d.SUBTOTAL)}</td>
            </tr>`).join('')}
            </tbody></table>
            <div style="text-align:right;margin-top:16px;font-size:1.2rem;font-weight:700;color:var(--accent)">
                ยอดรวม: ${formatCurrency(data.header.TOTAL_AMOUNT)}
            </div>
        `);
    } catch (err) { showToast(err.message, 'error'); }
}

// ============================================================
// หน้าใบสั่งซื้อ (Purchases)
// ============================================================
async function loadPurchases() {
    try {
        const purchases = await api('/api/purchases');
        const content = document.getElementById('content-area');
        content.innerHTML = `
            <div class="data-section">
                <div class="data-header" style="display:flex; justify-content:space-between; align-items:center;">
                    <h2><span class="material-symbols-rounded">shopping_cart</span> ใบสั่งซื้อทั้งหมด</h2>
                    <button class="btn btn-primary" onclick="showCreatePurchaseModal()">
                        <span class="material-symbols-rounded">add</span> สร้างใบสั่งซื้อใหม่
                    </button>
                </div>
                <div style="overflow-x:auto">
                <table class="data-table"><thead><tr>
                    <th>รหัส PO</th><th>Invoice</th><th>วันที่</th><th>Supplier</th>
                    <th>ยอดรวม</th><th>สถานะ</th><th>จัดการ</th>
                </tr></thead><tbody>
                ${purchases.length === 0 ? '<tr><td colspan="7" class="table-empty">ยังไม่มีใบสั่งซื้อ</td></tr>' :
                purchases.map(p => {
                    let actions = `
                        <button class="btn btn-outline btn-sm" onclick="viewPurchaseDetail('${(p.PURCHASE_ID || '').trim()}')" title="ดูรายละเอียด">
                            <span class="material-symbols-rounded">visibility</span>
                        </button>
                    `;
                    // ถ้ายังไม่ได้รับสินค้า ให้มีปุ่มรับ
                    if (p.STATUS === 'Pending' || p.STATUS === 'รอรับสินค้า') {
                        actions += `
                            <button class="btn btn-success btn-sm" style="margin-left:4px;" onclick="receivePurchase('${(p.PURCHASE_ID || '').trim()}')" title="รับสินค้าเข้าสต็อก">
                                <span class="material-symbols-rounded">inventory</span>
                            </button>
                        `;
                    }
                    return `<tr>
                    <td style="font-size:0.78rem">${(p.PURCHASE_ID || '').trim()}</td>
                    <td>${(p.INVOICE_NUMBER || '').trim()}</td>
                    <td>${p.PURCHASE_DATE}</td>
                    <td>${p.SUPPLIER_NAME || '-'}</td>
                    <td style="color:var(--accent);font-weight:600">${formatCurrency(p.TOTAL_COST)}</td>
                    <td><span class="badge ${p.STATUS === 'Received' || p.STATUS === 'รับสินค้าแล้ว' ? 'badge-success' : 'badge-warning'}">${p.STATUS}</span></td>
                    <td>${actions}</td>
                </tr>`}).join('')}
                </tbody></table>
                </div>
            </div>
        `;
    } catch (err) { document.getElementById('content-area').innerHTML = `<p style="color:var(--danger)">❌ ${err.message}</p>`; }
}

let poCart = [];

async function showCreatePurchaseModal() {
    try {
        const suppliers = await api('/api/suppliers');
        const products = await api('/api/products');

        let supOptions = suppliers.map(s => `<option value="${s.SUPPLIER_ID}">${s.SUPPLIER_NAME}</option>`).join('');
        let prodOptions = products.map(p => `<option value="${p.PRODUCT_ID}">${p.PRODUCT_NAME}</option>`).join('');

        poCart = [];

        openModal('สร้างใบสั่งซื้อใหม่ (PO)', `
            <form id="create-po-form" class="form-grid">
                <div class="form-group">
                    <label>เลขที่ Invoice <span style="color:red">*</span></label>
                    <input type="text" id="po-invoice" required placeholder="เช่น INV-2025-001">
                </div>
                <div class="form-group">
                    <label>บริษัทคู่ค้า (Supplier) <span style="color:red">*</span></label>
                    <select id="po-supplier" required>
                        <option value="">-- เลือก Supplier --</option>
                        ${supOptions}
                    </select>
                </div>
                
                <h3 style="grid-column: 1 / -1; margin-top: 10px; border-bottom: 2px solid var(--border); padding-bottom: 5px;">เพิ่มรายการยา</h3>
                
                <div class="form-group" style="grid-column: 1 / -1; display:flex; gap:10px; align-items:flex-end;">
                    <div style="flex:2">
                        <label style="font-size:0.8rem">ชื่อยา</label>
                        <select id="po-product">
                            <option value="">-- เลือกยา --</option>
                            ${prodOptions}
                        </select>
                    </div>
                    <div style="flex:1">
                        <label style="font-size:0.8rem">จำนวนกล่อง</label>
                        <input type="number" id="po-qty" placeholder="จำนวน" min="1">
                    </div>
                    <div style="flex:1">
                        <label style="font-size:0.8rem">ต้นทุน/หน่วย (฿)</label>
                        <input type="number" id="po-cost" placeholder="ราคาต้นทุน" min="0" step="0.01">
                    </div>
                    <button type="button" class="btn btn-primary" onclick="addPoItem()" style="height:42px; padding:0 15px;">
                        <span class="material-symbols-rounded">add_circle</span> เพิ่ม
                    </button>
                </div>

                <div style="grid-column: 1 / -1;">
                    <table class="data-table" id="po-items-table" style="margin-top:0;">
                        <thead><tr><th>สินค้า</th><th style="text-align:right">จำนวน</th><th style="text-align:right">ต้นทุน/หน่วย</th><th style="text-align:right">รวม</th><th style="text-align:center">ลบ</th></tr></thead>
                        <tbody id="po-cart-body"><tr><td colspan="5" class="table-empty">ยังไม่มีรายการ</td></tr></tbody>
                    </table>
                    <div style="text-align:right; font-size:1.2rem; font-weight:bold; margin-top:10px; color:var(--accent);">
                        ยอดรวมสุทธิ: <span id="po-total">฿0.00</span>
                    </div>
                </div>

                <div class="form-actions" style="grid-column: 1 / -1; margin-top:15px; justify-content:flex-end; gap:10px;">
                    <button type="button" class="btn btn-outline" onclick="closeModal()">ยกเลิก</button>
                    <button type="submit" class="btn btn-primary">
                        <span class="material-symbols-rounded">save</span> บันทึกใบสั่งซื้อ
                    </button>
                </div>
            </form>
        `);

        // ผูก Event Submit
        document.getElementById('create-po-form').onsubmit = async (e) => {
            e.preventDefault();
            if (poCart.length === 0) {
                return showToast('กรุณาเพิ่มรายการสินค้าอย่างน้อย 1 รายการ ค่อยบันทึกครับ', 'warning');
            }

            try {
                const Invoice_Number = document.getElementById('po-invoice').value.trim();
                const Supplier_ID = document.getElementById('po-supplier').value;

                // ปุ่ม loading
                const submitBtn = e.target.querySelector('button[type="submit"]');
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<span class="material-symbols-rounded" style="animation: spin 1s linear infinite;">sync</span> กำลังบันทึก...';

                const res = await api('/api/purchases', {
                    method: 'POST',
                    body: JSON.stringify({ Invoice_Number, Supplier_ID, items: poCart })
                });
                showToast('สร้างใบสั่งซื้อสำเร็จ!', 'success');
                closeModal();
                loadPurchases(); // รีเฟรชตาราง
            } catch (err) {
                showToast(err.message, 'error');
                const submitBtn = e.target.querySelector('button[type="submit"]');
                submitBtn.disabled = false;
                submitBtn.innerHTML = '<span class="material-symbols-rounded">save</span> บันทึกใบสั่งซื้อ';
            }
        };

    } catch (err) {
        showToast(err.message, 'error');
    }
}

// ฟังก์ชันเสริมสำหรับ Modal (ประกาศ global ข้าม modal ได้)
window.addPoItem = function () {
    const sel = document.getElementById('po-product');
    const qty = parseInt(document.getElementById('po-qty').value);
    const cost = parseFloat(document.getElementById('po-cost').value);

    if (!sel.value || isNaN(qty) || isNaN(cost) || qty <= 0 || cost < 0) {
        return showToast('กรุณาระบุ สินค้า, จำนวน, และต้นทุน ให้ถูกต้อง', 'warning');
    }

    const prodName = sel.options[sel.selectedIndex].text;

    poCart.push({
        Product_ID: sel.value,
        Product_Name: prodName,
        Order_Qty: qty,
        Cost_Price: cost
    });

    // เคลียร์ช่อง input
    sel.value = '';
    document.getElementById('po-qty').value = '';
    document.getElementById('po-cost').value = '';

    renderPoCart();
};

window.removePoItem = function (index) {
    poCart.splice(index, 1);
    renderPoCart();
};

window.renderPoCart = function () {
    const tbody = document.getElementById('po-cart-body');
    const totalEl = document.getElementById('po-total');
    if (poCart.length === 0) {
        tbody.innerHTML = '<tr><td colspan="5" class="table-empty">ยังไม่มีรายการ</td></tr>';
        totalEl.innerText = '฿0.00';
        return;
    }

    let total = 0;
    tbody.innerHTML = poCart.map((item, idx) => {
        let sub = item.Order_Qty * item.Cost_Price;
        total += sub;
        return `<tr>
            <td>${item.Product_Name}</td>
            <td style="text-align:right">${formatNumber(item.Order_Qty)}</td>
            <td style="text-align:right">${formatCurrency(item.Cost_Price)}</td>
            <td style="text-align:right; font-weight:600;">${formatCurrency(sub)}</td>
            <td style="text-align:center"><button type="button" class="btn btn-danger btn-sm" onclick="removePoItem(${idx})" title="ลบ">&times;</button></td>
        </tr>`;
    }).join('');
    totalEl.innerText = formatCurrency(total);
};

// ฟังก์ชันรับสินค้าเข้าคลัง
async function receivePurchase(purchaseId) {
    if (!confirm(`✅ ยืนยันการรับสินค้าเข้าคลัง? (ออเดอร์: ${purchaseId})\n\nระบบจะทำการอัปเดตสถานะบิล สร้างล็อตสินค้า (Product_Batches) และเพิ่มสต็อกคงเหลือในร้านให้อัตโนมัติ`)) return;

    try {
        const res = await api(`/api/purchases/${purchaseId}/receive`, { method: 'PUT' });
        showToast(res.message || 'รับสินค้าเข้าสต็อกสำเร็จ!', 'success');
        loadPurchases(); // รีเฟรชตารางดูสถานะ Received
    } catch (err) {
        showToast(err.message, 'error');
    }
}

async function viewPurchaseDetail(id) {
    try {
        const data = await api(`/api/purchases/${id}`);
        openModal(`รายละเอียดใบสั่งซื้อ: ${id}`, `
            <p style="margin-bottom:8px;color:var(--text-secondary)">Supplier: ${data.header.SUPPLIER_NAME} | พนักงาน: ${data.header.EMP_NAME}</p>
            <p style="margin-bottom:12px;color:var(--text-secondary)">วันที่: ${data.header.PURCHASE_DATE_STR} | สถานะ: ${data.header.STATUS}</p>
            <table class="data-table"><thead><tr>
                <th>สินค้า</th><th>จำนวนสั่ง</th><th>ราคาทุน</th><th>รวม</th>
            </tr></thead><tbody>
            ${data.details.map(d => `<tr>
                <td>${d.PRODUCT_NAME || '-'}</td><td>${formatNumber(d.ORDER_QTY)}</td>
                <td>${formatCurrency(d.COST_PRICE)}</td>
                <td style="color:var(--accent)">${formatCurrency(d.ORDER_QTY * d.COST_PRICE)}</td>
            </tr>`).join('')}
            </tbody></table>
            <div style="text-align:right;margin-top:16px;font-size:1.1rem;font-weight:700;color:var(--accent)">
                ยอดรวม: ${formatCurrency(data.header.TOTAL_COST)}
            </div>
        `);
    } catch (err) { showToast(err.message, 'error'); }
}

// ============================================================
// หน้าพนักงาน (Employees)
// ============================================================
async function loadEmployees() {
    try {
        const employees = await api('/api/employees');
        const content = document.getElementById('content-area');
        content.innerHTML = `
            <div class="data-section">
                <div class="data-header">
                    <h2><span class="material-symbols-rounded">group</span> พนักงานทั้งหมด</h2>
                    <button class="btn btn-primary" onclick="showEmployeeModal()">
                        <span class="material-symbols-rounded">person_add</span> เพิ่มพนักงาน
                    </button>
                </div>
                <table class="data-table"><thead><tr>
                    <th>รหัส</th><th>ชื่อ-นามสกุล</th><th>Username</th><th>ตำแหน่ง</th><th>จัดการ</th>
                </tr></thead><tbody>
                ${employees.map(e => `<tr>
                    <td style="font-size:0.78rem">${(e.EMP_ID || '').trim()}</td>
                    <td><strong>${e.FIRST_NAME} ${e.LAST_NAME}</strong></td>
                    <td>${e.USERNAME}</td>
                    <td><span class="badge badge-primary">${e.POSITION}</span></td>
                    <td>
                        <button class="btn btn-outline btn-sm" onclick='showEmployeeModal(${JSON.stringify(e).replace(/'/g, "&#39;")})'>
                            <span class="material-symbols-rounded">edit</span>
                        </button>
                        <button class="btn btn-danger btn-sm" onclick="deleteEmployee('${(e.EMP_ID || '').trim()}')">
                            <span class="material-symbols-rounded">delete</span>
                        </button>
                    </td>
                </tr>`).join('')}
                </tbody></table>
            </div>
        `;
    } catch (err) { document.getElementById('content-area').innerHTML = `<p style="color:var(--danger)">❌ ${err.message}</p>`; }
}

function showEmployeeModal(emp) {
    const isEdit = !!emp;
    openModal(isEdit ? 'แก้ไขพนักงาน' : 'เพิ่มพนักงานใหม่', `
        <form id="emp-form">
            <div class="form-group">
                <label>รหัสพนักงาน</label>
                <input type="text" id="ef-id" value="${isEdit ? (emp.EMP_ID || '').trim() : generateId('EMP', 10)}" ${isEdit ? 'readonly' : ''} required maxlength="10">
            </div>
            <div class="form-row">
                <div class="form-group"><label>ชื่อ</label><input type="text" id="ef-fname" value="${isEdit ? emp.FIRST_NAME || '' : ''}" required></div>
                <div class="form-group"><label>นามสกุล</label><input type="text" id="ef-lname" value="${isEdit ? emp.LAST_NAME || '' : ''}" required></div>
            </div>
            <div class="form-row">
                <div class="form-group"><label>Username</label><input type="text" id="ef-user" value="${isEdit ? emp.USERNAME || '' : ''}" required></div>
                <div class="form-group">
                    <label>ตำแหน่ง</label>
                    <select id="ef-pos">
                        <option value="Owner" ${isEdit && emp.POSITION === 'Owner' ? 'selected' : ''}>Owner</option>
                        <option value="Manager" ${isEdit && emp.POSITION === 'Manager' ? 'selected' : ''}>Manager</option>
                        <option value="Emp" ${isEdit && emp.POSITION === 'Emp' ? 'selected' : ''}>Emp</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label>${isEdit ? 'รหัสผ่านใหม่ (เว้นว่างถ้าไม่เปลี่ยน)' : 'รหัสผ่าน'}</label>
                <input type="password" id="ef-pass" ${isEdit ? '' : 'required'} placeholder="${isEdit ? 'เว้นว่างถ้าไม่เปลี่ยน' : 'กรอกรหัสผ่าน'}">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeModal()">ยกเลิก</button>
                <button type="submit" class="btn btn-primary">${isEdit ? 'บันทึก' : 'เพิ่มพนักงาน'}</button>
            </div>
        </form>
    `);
    document.getElementById('emp-form').onsubmit = async (e) => {
        e.preventDefault();
        const body = {
            EMP_ID: document.getElementById('ef-id').value.trim(),
            First_Name: document.getElementById('ef-fname').value,
            Last_Name: document.getElementById('ef-lname').value,
            Username: document.getElementById('ef-user').value,
            Position: document.getElementById('ef-pos').value
        };
        const pass = document.getElementById('ef-pass').value;
        if (pass) body.Password_Hash = pass;
        try {
            if (isEdit) {
                await api(`/api/employees/${body.EMP_ID}`, { method: 'PUT', body: JSON.stringify(body) });
                showToast('แก้ไขพนักงานสำเร็จ');
            } else {
                await api('/api/employees', { method: 'POST', body: JSON.stringify(body) });
                showToast('เพิ่มพนักงานสำเร็จ');
            }
            closeModal(); loadEmployees();
        } catch (err) { showToast(err.message, 'error'); }
    };
}

async function deleteEmployee(id) {
    if (!confirm('ต้องการลบพนักงานนี้?')) return;
    try { await api(`/api/employees/${id}`, { method: 'DELETE' }); showToast('ลบพนักงานสำเร็จ'); loadEmployees(); }
    catch (err) { showToast(err.message, 'error'); }
}

// ============================================================
// หน้า Supplier
// ============================================================
async function loadSuppliers() {
    try {
        const suppliers = await api('/api/suppliers');
        const content = document.getElementById('content-area');
        content.innerHTML = `
            <div class="data-section">
                <div class="data-header">
                    <h2><span class="material-symbols-rounded">local_shipping</span> ผู้จัดจำหน่ายทั้งหมด</h2>
                    <button class="btn btn-primary" onclick="showSupplierModal()">
                        <span class="material-symbols-rounded">add</span> เพิ่ม Supplier
                    </button>
                </div>
                <table class="data-table"><thead><tr>
                    <th>รหัส</th><th>ชื่อ Supplier</th><th>เบอร์โทร</th><th>จัดการ</th>
                </tr></thead><tbody>
                ${suppliers.map(s => `<tr>
                    <td>${(s.SUPPLIER_ID || '').trim()}</td>
                    <td><strong>${s.SUPPLIER_NAME}</strong></td>
                    <td>${s.CONTRACT || '-'}</td>
                    <td>
                        <button class="btn btn-outline btn-sm" onclick='showSupplierModal(${JSON.stringify(s).replace(/'/g, "&#39;")})'>
                            <span class="material-symbols-rounded">edit</span>
                        </button>
                        <button class="btn btn-danger btn-sm" onclick="deleteSupplier('${(s.SUPPLIER_ID || '').trim()}')">
                            <span class="material-symbols-rounded">delete</span>
                        </button>
                    </td>
                </tr>`).join('')}
                </tbody></table>
            </div>
        `;
    } catch (err) { document.getElementById('content-area').innerHTML = `<p style="color:var(--danger)">❌ ${err.message}</p>`; }
}

function showSupplierModal(sup) {
    const isEdit = !!sup;
    openModal(isEdit ? 'แก้ไข Supplier' : 'เพิ่ม Supplier ใหม่', `
        <form id="sup-form">
            <div class="form-group"><label>รหัส Supplier</label>
                <input type="text" id="sf-id" value="${isEdit ? (sup.SUPPLIER_ID || '').trim() : ''}" ${isEdit ? 'readonly' : ''} required maxlength="3" placeholder="เช่น S04">
            </div>
            <div class="form-group"><label>ชื่อ Supplier</label>
                <input type="text" id="sf-name" value="${isEdit ? sup.SUPPLIER_NAME || '' : ''}" required>
            </div>
            <div class="form-group"><label>เบอร์โทร / ข้อมูลติดต่อ</label>
                <input type="text" id="sf-contract" value="${isEdit ? sup.CONTRACT || '' : ''}" required>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeModal()">ยกเลิก</button>
                <button type="submit" class="btn btn-primary">${isEdit ? 'บันทึก' : 'เพิ่ม Supplier'}</button>
            </div>
        </form>
    `);
    document.getElementById('sup-form').onsubmit = async (e) => {
        e.preventDefault();
        const body = { Supplier_ID: document.getElementById('sf-id').value.trim(), Supplier_Name: document.getElementById('sf-name').value, Contract: document.getElementById('sf-contract').value };
        try {
            if (isEdit) { await api(`/api/suppliers/${body.Supplier_ID}`, { method: 'PUT', body: JSON.stringify(body) }); showToast('แก้ไข Supplier สำเร็จ'); }
            else { await api('/api/suppliers', { method: 'POST', body: JSON.stringify(body) }); showToast('เพิ่ม Supplier สำเร็จ'); }
            closeModal(); loadSuppliers();
        } catch (err) { showToast(err.message, 'error'); }
    };
}

async function deleteSupplier(id) {
    if (!confirm('ต้องการลบ Supplier นี้?')) return;
    try { await api(`/api/suppliers/${id}`, { method: 'DELETE' }); showToast('ลบ Supplier สำเร็จ'); loadSuppliers(); }
    catch (err) { showToast(err.message, 'error'); }
}

// ============================================================
// หน้าหมวดหมู่ยา (Categories)
// ============================================================
async function loadCategories() {
    try {
        const categories = await api('/api/categories');
        const content = document.getElementById('content-area');
        content.innerHTML = `
            <div class="data-section">
                <div class="data-header">
                    <h2><span class="material-symbols-rounded">category</span> หมวดหมู่ยาทั้งหมด</h2>
                    <button class="btn btn-primary" onclick="showCategoryModal()">
                        <span class="material-symbols-rounded">add</span> เพิ่มหมวดหมู่
                    </button>
                </div>
                <table class="data-table"><thead><tr>
                    <th>รหัส</th><th>ชื่อหมวดหมู่</th><th>จัดการ</th>
                </tr></thead><tbody>
                ${categories.map(c => `<tr>
                    <td><span class="badge badge-info">${(c.CATEGORY_ID || '').trim()}</span></td>
                    <td><strong>${c.CATEGORY_NAME}</strong></td>
                    <td>
                        <button class="btn btn-outline btn-sm" onclick='showCategoryModal(${JSON.stringify(c).replace(/'/g, "&#39;")})'>
                            <span class="material-symbols-rounded">edit</span>
                        </button>
                        <button class="btn btn-danger btn-sm" onclick="deleteCategory('${(c.CATEGORY_ID || '').trim()}')">
                            <span class="material-symbols-rounded">delete</span>
                        </button>
                    </td>
                </tr>`).join('')}
                </tbody></table>
            </div>
        `;
    } catch (err) { document.getElementById('content-area').innerHTML = `<p style="color:var(--danger)">❌ ${err.message}</p>`; }
}

function showCategoryModal(cat) {
    const isEdit = !!cat;
    openModal(isEdit ? 'แก้ไขหมวดหมู่' : 'เพิ่มหมวดหมู่ใหม่', `
        <form id="cat-form">
            <div class="form-group"><label>รหัสหมวดหมู่</label>
                <input type="text" id="cf-id" value="${isEdit ? (cat.CATEGORY_ID || '').trim() : ''}" ${isEdit ? 'readonly' : ''} required maxlength="3" placeholder="เช่น C09">
            </div>
            <div class="form-group"><label>ชื่อหมวดหมู่</label>
                <input type="text" id="cf-name" value="${isEdit ? cat.CATEGORY_NAME || '' : ''}" required>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeModal()">ยกเลิก</button>
                <button type="submit" class="btn btn-primary">${isEdit ? 'บันทึก' : 'เพิ่ม'}</button>
            </div>
        </form>
    `);
    document.getElementById('cat-form').onsubmit = async (e) => {
        e.preventDefault();
        const body = { Category_ID: document.getElementById('cf-id').value.trim(), Category_Name: document.getElementById('cf-name').value };
        try {
            if (isEdit) { await api(`/api/categories/${body.Category_ID}`, { method: 'PUT', body: JSON.stringify(body) }); showToast('แก้ไขหมวดหมู่สำเร็จ'); }
            else { await api('/api/categories', { method: 'POST', body: JSON.stringify(body) }); showToast('เพิ่มหมวดหมู่สำเร็จ'); }
            closeModal(); loadCategories();
        } catch (err) { showToast(err.message, 'error'); }
    };
}

async function deleteCategory(id) {
    if (!confirm('ต้องการลบหมวดหมู่นี้?')) return;
    try { await api(`/api/categories/${id}`, { method: 'DELETE' }); showToast('ลบหมวดหมู่สำเร็จ'); loadCategories(); }
    catch (err) { showToast(err.message, 'error'); }
}

// ============================================================
// หน้ารายงาน (Reports)
// ============================================================
async function loadReports() {
    try {
        const [monthly, topProducts, stockAlerts, auditLog] = await Promise.all([
            api('/api/reports/monthly-sales'),
            api('/api/reports/top-products'),
            api('/api/reports/stock-alerts').catch(() => []),
            api('/api/reports/audit-log').catch(() => [])
        ]);
        const content = document.getElementById('content-area');
        content.innerHTML = `
            <div class="dashboard-grid">
                <div class="data-section">
                    <div class="data-header"><h2><span class="material-symbols-rounded">bar_chart</span> ยอดขายรายเดือน</h2></div>
                    <div style="padding:15px;height:280px;"><canvas id="rpt-chart-monthly"></canvas></div>
                </div>
                <div class="data-section">
                    <div class="data-header"><h2><span class="material-symbols-rounded">trending_up</span> สินค้าขายดี Top 10</h2></div>
                    <div style="padding:15px;height:280px;"><canvas id="rpt-chart-top"></canvas></div>
                </div>
            </div>
            <div class="data-section" style="margin-top:20px;">
                <div class="data-header"><h2><span class="material-symbols-rounded">history</span> Audit Log (ประวัติเปลี่ยนแปลงสินค้า)</h2></div>
                <table class="data-table"><thead><tr>
                    <th>เวลา</th><th>ประเภท</th><th>สินค้า</th><th>ราคาเดิม</th><th>ราคาใหม่</th><th>รายละเอียด</th>
                </tr></thead><tbody>
                ${auditLog.length === 0 ? '<tr><td colspan="6" class="table-empty">ยังไม่มี Log</td></tr>' :
                auditLog.map(a => `<tr>
                    <td style="font-size:0.78rem">${a.CHANGED_AT}</td>
                    <td><span class="badge ${a.ACTION_TYPE === 'INSERT' ? 'badge-success' : a.ACTION_TYPE === 'UPDATE' ? 'badge-info' : 'badge-danger'}">${a.ACTION_TYPE}</span></td>
                    <td>${a.PRODUCT_NAME || '-'}</td>
                    <td>${a.OLD_PRICE != null ? formatCurrency(a.OLD_PRICE) : '-'}</td>
                    <td>${a.NEW_PRICE != null ? formatCurrency(a.NEW_PRICE) : '-'}</td>
                    <td style="font-size:0.8rem">${a.DETAILS || '-'}</td>
                </tr>`).join('')}
                </tbody></table>
            </div>
            <div class="data-section" style="margin-top:20px;">
                <div class="data-header"><h2><span class="material-symbols-rounded">notification_important</span> แจ้งเตือนสต็อกต่ำ</h2></div>
                <table class="data-table"><thead><tr>
                    <th>วันที่</th><th>สินค้า</th><th>สต็อกเหลือ</th><th>จุดสั่งซื้อ</th>
                </tr></thead><tbody>
                ${stockAlerts.length === 0 ? '<tr><td colspan="4" class="table-empty">ไม่มี Alert</td></tr>' :
                stockAlerts.map(a => `<tr>
                    <td style="font-size:0.78rem">${a.ALERT_DATE}</td>
                    <td>${a.PRODUCT_NAME}</td>
                    <td><span class="badge badge-danger">${a.CURRENT_STOCK}</span></td>
                    <td>${a.REORDER_POINT}</td>
                </tr>`).join('')}
                </tbody></table>
            </div>
        `;
        // กราฟยอดขายรายเดือน
        if (monthly.length > 0 && document.getElementById('rpt-chart-monthly')) {
            new Chart(document.getElementById('rpt-chart-monthly'), {
                type: 'line',
                data: {
                    labels: monthly.map(m => m.SALE_MONTH),
                    datasets: [{
                        label: 'ยอดขาย (บาท)', data: monthly.map(m => m.TOTAL_REVENUE),
                        borderColor: '#00d4aa', backgroundColor: 'rgba(0,212,170,0.15)',
                        fill: true, tension: 0.4, borderWidth: 3, pointRadius: 5, pointBackgroundColor: '#00d4aa'
                    }]
                },
                options: {
                    responsive: true, maintainAspectRatio: false,
                    plugins: { legend: { labels: { color: '#b8c5d6' } } },
                    scales: {
                        x: { ticks: { color: '#8696a8' }, grid: { color: 'rgba(255,255,255,0.05)' } },
                        y: { ticks: { color: '#8696a8' }, grid: { color: 'rgba(255,255,255,0.05)' } }
                    }
                }
            });
        }
        // กราฟสินค้าขายดี
        if (topProducts.length > 0 && document.getElementById('rpt-chart-top')) {
            const colors = ['#00d4aa', '#667eea', '#764ba2', '#f093fb', '#4facfe', '#43e97b', '#fa709a', '#fee140', '#30cfd0', '#a18cd1'];
            new Chart(document.getElementById('rpt-chart-top'), {
                type: 'doughnut',
                data: {
                    labels: topProducts.map(p => p.PRODUCT_NAME),
                    datasets: [{ data: topProducts.map(p => p.TOTAL_SOLD), backgroundColor: colors.slice(0, topProducts.length), borderWidth: 0 }]
                },
                options: {
                    responsive: true, maintainAspectRatio: false,
                    plugins: { legend: { position: 'right', labels: { color: '#b8c5d6', padding: 10, font: { size: 11 } } } }
                }
            });
        }
    } catch (err) { document.getElementById('content-area').innerHTML = `<p style="color:var(--danger)">❌ ${err.message}</p>`; }
}

// ============================================================
// พิมพ์ใบเสร็จ (Receipt)
// ============================================================
async function printReceipt(saleId) {
    try {
        const data = await api(`/api/sales/${saleId}`);
        const h = data.header;
        const d = data.details;
        const win = window.open('', '_blank', 'width=400,height=600');
        win.document.write(`<html><head><title>ใบเสร็จ ${saleId}</title>
            <style>
                body { font-family: 'Courier New', monospace; font-size: 12px; padding: 15px; max-width: 350px; margin: auto; }
                .center { text-align: center; } .right { text-align: right; }
                hr { border: 1px dashed #000; }
                table { width: 100%; border-collapse: collapse; }
                td { padding: 2px 0; }
                .total { font-size: 16px; font-weight: bold; }
                @media print { body { margin: 0; } }
            </style></head><body>
            <div class="center"><h2>💊 ร้านยา</h2><p>Pharmacy Management System</p></div>
            <hr>
            <p>บิล: ${(h.SALE_ID || '').trim()}<br>
            วันที่: ${h.SALE_DATE_STR || ''}<br>
            พนักงาน: ${h.EMP_NAME || ''}</p>
            <hr>
            <table>
                <tr><td><b>รายการ</b></td><td class="right"><b>จำนวน</b></td><td class="right"><b>รวม</b></td></tr>
                ${d.map(item => `<tr>
                    <td>${item.PRODUCT_NAME || 'สินค้า'}</td>
                    <td class="right">${item.QUANTITY}</td>
                    <td class="right">${Number(item.SUBTOTAL).toFixed(2)}</td>
                </tr>`).join('')}
            </table>
            <hr>
            <table><tr><td class="total">รวมทั้งสิ้น</td><td class="right total">${Number(h.TOTAL_AMOUNT).toFixed(2)} บาท</td></tr></table>
            <hr>
            <div class="center"><p>ขอบคุณที่ใช้บริการ<br>Thank you!</p></div>
            <script>window.onload=function(){window.print();}</script>
        </body></html>`);
        win.document.close();
    } catch (err) {
        showToast('ไม่สามารถพิมพ์ใบเสร็จได้: ' + err.message, 'error');
    }
}

// ===================== ค้นหาในตาราง =====================
function filterTable(tableId, query) {
    const table = document.getElementById(tableId);
    if (!table) return;
    const rows = table.querySelectorAll('tbody tr');
    query = query.toLowerCase();
    rows.forEach(row => {
        const text = row.textContent.toLowerCase();
        row.style.display = text.includes(query) ? '' : 'none';
    });
}

// ===================== เริ่มต้นแอป =====================
checkSession();
