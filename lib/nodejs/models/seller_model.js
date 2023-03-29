const mongoose = require('mongoose');
const paymentMethodSchema = require('./payment_method_model');


const sellerSchema = new mongoose.Schema({
    mop: {
        type: Map,
        of: paymentMethodSchema,
        default: {}
    },
    games: {
        type: Map,
        of: String,
        default: {}
    },
    name: {
        type: String,
        required: true,
        unique: true
    }
}, { collection: 'sellers' });

module.exports = mongoose.model('Seller', sellerSchema);