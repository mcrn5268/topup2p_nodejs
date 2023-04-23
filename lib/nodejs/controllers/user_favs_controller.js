const UserFavorited = require('../models/user_favorites_model');
exports.toggle = async (req, res, next) => {
    try {
        const { type, gameName, uid, date } = req.body;

        if (!type || !gameName || !uid || !date) {
            return res.status(400).json({
                message: 'Missing required data'
            });
        }
        const parsedDate = new Date(date); // parse ISO 8601 string to Date object

        const updateObj = type === 'add'
            ? { $push: { games: { name: gameName, date: parsedDate } } }
            : { $pull: { games: { name: gameName } } };

        await UserFavorited.updateOne({ uid }, updateObj, { upsert: true });

        res.status(200).json({ message: 'Field updated successfully' });
    } catch (e) {
        console.log('Error: ', e);
        res.status(500).json({ message: 'Internal Server Error' });
    }
};
exports.readFavs = async (req, res, next) => {
    try {
        const userId = req.params.uid;
        const favorites = await UserFavorited.findOne({ uid: userId }).select('games');

        //no favorited items
        if (!favorites) {
            return res.status(404).json({ message: 'No favorited items for this user' });
        }

        const gameData = favorites.games.reduce((acc, game) => {
            acc[game.name] = game.date;
            return acc;
        }, {});

        res.status(200).json(gameData);
    } catch (e) {
        console.log("Error: ", e);
        res.status(500).json({ message: "Internal Server Error" });
    }
};

