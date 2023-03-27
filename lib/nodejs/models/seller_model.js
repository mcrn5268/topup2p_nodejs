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
        unique: true,
        required: true
    },
    status: {
        type: String,
        required: true
    }
}, {_id: false});


const gameSchema = new mongoose.Schema({
    game_name: {
        type: String,
        required: true
    },
    status: {
        type: String,
        default: 'enabled'
    }
}, { _id: false });

const sellerSchema = new mongoose.Schema({
    MoP: {
        type: Map,
        of: paymentMethodSchema,
        default: {}
    },
    games: {
        type: [gameSchema],
        default: []
    },
    name: {
        type: String,
        required: true,
        unique: true
    }
}, { collection: 'sellers' });

module.exports = mongoose.model('Seller', sellerSchema);
