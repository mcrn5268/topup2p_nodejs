const mongoose = require('mongoose');

const paymentMethodSchema = new mongoose.Schema({
    account_name: {
        type: String,
        required: true
    },
    account_number: {
        type: String,
        required: true
    },
    payment_name: {
        type: String,
        unique: true
    },
    status: {
        type: String,
        required: true
    }
}, { _id: false });

module.exports = paymentMethodSchema;
