importScripts("https://www.gstatic.com/firebasejs/7.5.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/7.5.0/firebase-messaging.js");



firebase.initializeApp({
 apiKey: "AIzaSyCBvWZ_KJBIJVZdUSPf3M4Ictce06PrwHI",
    authDomain: "signplus-295808.firebaseapp.com",
    databaseURL: "https://signplus-295808.firebaseio.com",
    projectId: "signplus-295808",
    storageBucket: "signplus-295808.appspot.com",
    messagingSenderId: "844058502646",
    appId: "1:844058502646:web:e22bdc4d8a360f939a53d7",
    measurementId: "G-RBSDKXGKV2"
/*
    apiKey: "API_KEY",
    authDomain: "AUTH_DOMAIN",
    databaseURL: "DATABASE_URL",
    projectId: "PROJECT_ID",
    storageBucket: "STORAGE_BUCKET",
    messagingSenderId: "MESSAGING_SENDER_ID",
    appId: "APP_ID",
    measurementId: "MEASUREMENT_ID"
    */
});
const messaging = firebase.messaging();
messaging.setBackgroundMessageHandler(function (payload) {
 const notificationTitle = 'SignNow';
  const notificationOptions = {
    body: 'בקשת תרגום',
    icon: '/logo/logo_blue192.png'
  };

  return self.registration.showNotification(notificationTitle,
    notificationOptions);
});
//    const promiseChain = clients
//        .matchAll({
//            type: "window",
//            includeUncontrolled: true
//        })
//        .then(windowClients => {
//            for (let i = 0; i < windowClients.length; i++) {
//                const windowClient = windowClients[i];
//                windowClient.postMessage(payload);
//            }
//        })
//        .then(() => {
//            return registration.showNotification("New Message");
//        });
//    return promiseChain;

//self.addEventListener('notificationclick', function (event) {
//    console.log('notification received: ', event)
//});