const mongoose = require('mongoose');

const RevokedTokenSchema = new mongoose.Schema({
    token: {
        type: String,
        required: true,
    },
    createdAt: {
        type: Date,
        default: Date.now,
        expires: 30 * 24 * 60 * 60, // Expire documents after 30 days
    },
}, { collection: 'revoked_tokens'});


module.exports = mongoose.model('RevokedToken', RevokedTokenSchema);
