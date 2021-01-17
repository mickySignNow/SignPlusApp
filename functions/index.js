//
//const functions = require('firebase-functions');
//const admin = require('firebase-admin');
//admin.initializeApp();
//
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
//
//// TODO: Storage push and pull functions
//
//exports.SignUp = functions.auth.user().onCreate((user) => {
//
//    const data = {
//        "email" : user.email,
//         "uid" : user.uid,
//         "name" : user.name,
//         "timeStamp":
//         {
//         "creation": Date(),
//         "lastLogin": Date(),
//         "lastActivity": Date(),
//
//         },
//         "online": true,
//         "image": user.picture,
//         "role": "user"
//
//    }
//
//    return admin
//        .firestore()
//        .collection('users')
//        .doc(user.uid)
//        .set(JSON.parse(JSON.stringify(data)));
//});
//
//exports.Delete = functions.auth.user().onDelete((user) => {
//    const data = {
//        "name": user.email,
//        "disabled": true,
//        "id": user.uid
//    }
//
//    return admin
//        .firestore()
//        .collection('users')
//        .doc(user.uid)
//        .set(JSON.parse(JSON.stringify(data)));
//});
//
////const events = require('./events.js')
////exports.uploadRequest = events.uploadRequest
//
//
//
//

