const Seller = require('../models/seller_model');
const Game = require('../models/seller_games_model');

exports.readSellerData = async (req, res, next) => {
    try {
        const shopName = req.params.shopName;
        const data = await Seller.findOne({ shopName });
        if (!data) {
            return res.status(404).json({ message: 'There is no document for this shop' });
        }
        return res.status(200).json(data);
    } catch (e) {
        console.log('readSellerData: ' + e);
        next(e);
    }
};

exports.initialDocument = async (req, res, next) => {
    const { name } = req.body;
    if (!name) {
        return res.status(400).json({
            message: 'Missing required input'
        });
    }
    try {
        console.log('try initialDocument: ' + name);
        await Seller.create({ name: name });

        return res.status(200).json({
            message: 'Success'
        });
    } catch (e) {
        console.log('initialDocument: ' + e);
        next(e);
    }
};

//also reused for toggling game status 
//enabled or disabled
exports.addGame = async (req, res, next) => {
    const { sellerName, gameName, gameData } = req.body;

    if (!sellerName || !gameName || !gameData) {
        return res.status(400).json({
            message: 'Missing required input'
        });
    }
    try {
        let setData = {storeInfo: gameData};
        if (!gameData.mop || !gameData.rates) {
            setData = {'storeInfo.info': gameData.info};
        }
        await Game.findOneAndUpdate(
            { storeName: sellerName, gameName: gameName },
            { $set: setData },
            { upsert: true }
        );
        await Seller.findOneAndUpdate({ name: sellerName },
            {
                $set: {
                    'games': {
                        [gameName]: gameData.info.status
                    },
                }
            },
            { upsert: true });


        return res.status(200).json({
            message: 'Game added/updated successfully'
        });
    } catch (e) {
        next(e);
    }
};

exports.readGameData = async (req, res, next) => {
    try {
        const gameName = req.params.gameName;
        let query = { gameName };

        if (req.params.shopName !== 'null') {
            query.shopName = req.params.shopName;
        }
        const data = await Game.find(query);

        if (!data) {
            return res.status(404).json({ message: 'There is no document for this shop' });
        }
        return res.status(200).json(data);
    } catch (e) {
        console.log('readSellerData: ' + e);
        next(e);
    }
};


exports.addPaymentMethod = async (req, res, next) => {
    const { sellerName, paymentMethods } = req.body;
    if (!sellerName || !paymentMethods) {
        return res.status(400).json({
            message: 'Missing required input'
        });
    }
    try {
        // Find the Seller document with the specified name
        await Seller.findOneAndUpdate({ name: sellerName },
            { $set: { 'mop': paymentMethods } }, { upsert: true });

        return res.status(200).json({
            message: 'Payment methods added/updated successfully'
        });
    } catch (e) {
        next(e);
    }
};

// exports.addPaymentMethod = async (req, res, next) => {
//     const { sellerName, paymentMethods} = req.body;

//     try {
//         // Find the Seller document with the specified name
//         const seller = await Seller.findOne({ name: sellerName });

//         // If the Seller is not found, return a 404 Not Found error
//         if (!seller) {
//             return res.status(404).json({
//                 message: 'Seller not found'
//             });
//         }

//         // Loop through each payment method in the paymentMethods Map

//         for (const [key, value] of Object.entries(paymentMethods)) {
//             const { name, account_name, account_number, status } = value;

//             // Check if the payment method with the specified name already exists in the Mop field
//             const existingPayment = seller.MoP.get(name);

//             // If the payment method already exists, update its values
//             if (existingPayment) {
//                 existingPayment.account_name = account_name;
//                 existingPayment.account_number = account_number;
//                 existingPayment.status = status;
//             } else {
//                 // If the payment method doesn't exist, create a new payment method object and add it to the Mop field

//                 const newPayment = {
//                     account_name: account_name,
//                     account_number: account_number,
//                     status: status
//                 };
//                 seller.MoP.set(name, newPayment);

//             }
//         }

//         // Save the updated Seller document
//         await seller.save();

//         return res.status(200).json({
//             message: 'Payment methods added/updated successfully'
//         });
//     } catch (e) {
//         next(e);
//     }
// };
