const mongoose = require('mongoose');

const GameSchema = new mongoose.Schema({
    name: { type: String, required: true },
    date: { type: Date, required: true }
}, { _id: false });

const FavoritesSchema = new mongoose.Schema({
    uid: {
        type: String,
        required: true,
        unique: true,
    },
    games: [GameSchema]
}, {
    collection: 'user_games_data',
    _id: false
});

module.exports = mongoose.model('Favorited', FavoritesSchema);
