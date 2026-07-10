async function loadProducts() {
    const res = await fetch('/api/products');
    const products = await res.json();
    document.getElementById('products-grid').innerHTML = products.map(p => `
        <div class="bg-slate-900 border border-slate-800 rounded-2xl p-5 flex flex-col justify-between hover:border-slate-700 transition shadow-lg group">
            <div>
                <div class="text-5xl my-4 transform group-hover:scale-110 transition duration-300">${p.image}</div>
                <span class="text-xs font-mono text-cyan-400 uppercase tracking-widest">${p.category}</span>
                <h3 class="text-lg font-bold text-slate-100 mt-1 mb-2">${p.name}</h3>
                <p class="text-xs text-slate-500 font-mono">In Stock: ${p.stock} units</p>
            </div>
            <div class="flex justify-between items-center mt-6 pt-4 border-t border-slate-800/50">
                <span class="text-xl font-black text-emerald-400">$${p.price}</span>
                <button onclick="addToCart(${p.id})" class="bg-slate-800 hover:bg-indigo-600 text-slate-200 hover:text-white text-xs font-bold px-4 py-2 rounded-lg transition duration-200">
                    + Add To Cart
                </button>
            </div>
        </div>
    `).join('');
}

async function loadCart() {
    const res = await fetch('/api/cart');
    const data = await res.json();
    
    document.getElementById('cart-count').innerText = data.items.reduce((s, i) => s + i.quantity, 0);
    document.getElementById('cart-total').innerText = `$${data.total}`;

    if(data.items.length === 0) {
        document.getElementById('cart-items').innerHTML = `<p class="text-sm text-slate-500 text-center py-6">Your cart is empty. Add some cloud swag!</p>`;
        return;
    }

    document.getElementById('cart-items').innerHTML = data.items.map(item => `
        <div class="flex justify-between items-center pt-3 first:pt-0">
            <div>
                <h4 class="text-sm font-semibold text-slate-200">${item.name}</h4>
                <p class="text-xs text-slate-400 font-mono">$${item.price} x ${item.quantity}</p>
            </div>
            <span class="text-sm font-bold text-indigo-400">$${(item.price * item.quantity).toFixed(2)}</span>
        </div>
    `).join('');
}

async function addToCart(id) {
    await fetch('/api/cart', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ productId: id })
    });
    loadCart();
}

async function checkout() {
    const res = await fetch('/api/checkout', { method: 'POST' });
    const data = await res.json();
    if(res.ok) {
        alert("🎉 " + data.message);
        loadCart();
    } else {
        alert("❌ " + data.error);
    }
}

loadProducts();
loadCart();
