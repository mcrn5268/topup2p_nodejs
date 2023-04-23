const User = require('../models/user_model');
const SellerGames = require('../models/seller_games_model');

exports.read = async (req, res, next) => {
    try {
        const userId = req.params.uid;
        const user = await User.findById(userId).select('email name type image image_url');

        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        res.status(200).json({ ...user['_doc'] });
    } catch (e) {
        next(e);
    }
};

exports.update = async (req, res, next) => {
    const { data, uid, updateType } = req.body;

    if (!data || !uid) {
        return res.status(400).json({
            message: 'Missing required data'
        });
    }
    try {
        const updatedUser = await User.findOneAndUpdate(
            { _id: uid },
            { $set: data },
            { new: true }
        );

        if (!updatedUser) {
            return res.status(404).json({ error: 'User not found' });
        }
        if (updateType === 'image') {
            if (data.image_url !== null) {
                await SellerGames.updateMany(
                    { 'storeInfo.info.uid': uid },
                    { $set: { 'storeInfo.info.image': data.image_url } },
                    { upsert: true });
            }
        }
        if (updateType === 'name') {
            await SellerGames.updateMany(
                { 'storeInfo.info.uid': uid },
                { $set: { 'storeName': data.name } },
                { upsert: true });
        }


        //todo add update to messages documents
        res.status(200).json(updatedUser);
    } catch (e) {
        next(e);
    }
};
