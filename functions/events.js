//
//const functions = require('firebase-functions');
//const admin = require('firebase-admin');
//
//exports.uploadRequest = functions.https.onRequest((req, res) => {
//                console.log('eventInfo' + req['eventInfo']);
//                res.send(req['eventInfo']);
//     admin
//                    .firestore()
//                    .collection('events')
//                    .doc(functions.auth.user.uid).collection("unOccupied events").doc(req['eventInfo']['id'])
//                    .set(req['eventInfo']);
//                    return admin
//                    .firestore()
//                    .collection('all Events')
//                    .doc(req['all Events']['id'])
//                    .set(req['eventInfo']);
//
//
//});