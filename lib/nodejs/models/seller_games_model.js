const mongoose = require('mongoose');

const MOPSchema = new mongoose.Schema({
  account_name: {
    type: String,
    required: true,
  },
  account_number: {
    type: String,
    required: true,
  },
  name: {
    type: String,
    required: true,
  },
  status: {
    type: String,
    required: true,
  },
});

const RateSchema = new mongoose.Schema({
  digGoods: {
    type: String,
    required: true,
  },
  php: {
    type: String,
    required: true,
  },
});

const StoreSchema = new mongoose.Schema({
  info: {
    image: {
      type: String,
    },
    name: {
      type: String,
    },
    status: {
      type: String,
      required: true,
    },
    uid: {
      type: String,
    },
  },
  mop: {
    type: Map,
    of: MOPSchema,
    default: {},
  },
  rates: {
    type: Map,
    of: RateSchema,
    default: {},
  },
}, {_id: false});

const SellerGameSchema = new mongoose.Schema({
  gameName: {
    type: String,
    required: true,
  },
  storeName: {
    type: String,
    required: true,
  },
  storeInfo: {
    type: StoreSchema,
    required: true,
  },
}, { collection: 'seller_games_data' });

module.exports = mongoose.model('SellerGame', SellerGameSchema);




// collection name: seller_games_data
// document name: gameName
// fields:{
//     storeName:{
//         info:{
//             image: String,
//             name: String,
//             status: String,
//             uid: String
//         },
//         mop:{
//             //this is dynamic
//             mop0:{
//                 account_name: String,
//                 account_number: String,
//                 name: String,
//                 status: String
//             },
//             mop1:{
//                 account_name: String,
//                 account_number: String,
//                 name: String,
//                 status: String
//             }
//         },
//         rates:{
//             //this is dynamic
//             rate0:{
//                 digGoods: String,
//                 php: String
//             },
//             rate1:{
//                 digGoods: String,
//                 php: String
//             }
//         }
//     }
// }