const express = require('express');
const path = require('path');
const app = express();
const PORT = 3000;

app.use(express.json());

app.use(express.static(path.join(__dirname, 'public')));

let products = [
    { id: 1, name: "AWS Certified Cloud Hoodie", price: 49.99, image: "🧥", category: "Apparel", stock: 12 },
    { id: 2, name: "Terraform 'Plan & Apply' Mug", price: 14.99, image: "☕", category: "Accessories", stock: 25 },
    { id: 3, name: "Kubernetes Cluster Sticker Pack", price: 5.99, image: "☸️", category: "Stickers", stock: 150 },
    { id: 4, name: "Linux Kernel Mechanical Keyboard", price: 129.99, image: "⌨️", category: "Hardware", stock: 5 }
];

let cart = [];

app.get('/api/products', (req, res) => {
    res.json(products);
});

app.get('/api/cart', (req, res) => {
    const total = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
    res.json({ items: cart, total: parseFloat(total.toFixed(2)) });
});

app.post('/api/cart', (req, res) => {
    const { productId } = req.body;
    const product = products.find(p => p.id === parseInt(productId));
    
    if (!product) {
        return res.status(404).json({ error: "Product not found" });
    }

    const cartItem = cart.find(item => item.id === product.id);
    if (cartItem) {
        cartItem.quantity += 1;
    } else {
        cart.push({ ...product, quantity: 1 });
    }
    res.status(200).json({ message: "Added to cart successfully" });
});

app.post('/api/checkout', (req, res) => {
    if (cart.length === 0) {
        return res.status(400).json({ error: "Cart is empty" });
    }
    cart = [];
    res.status(200).json({ message: "Order placed successfully! Cloud infrastructure provisioning server resources." });
});

app.listen(PORT, () => {
    console.log(`===================================================`);
    console.log(`🛒 Modular E-Commerce App Live On Port ${PORT}`);
    console.log(`===================================================`);
});

