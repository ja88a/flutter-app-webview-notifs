importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");
// import { initializeApp } from "firebase/app";
// import { getAnalytics } from "firebase/analytics";

const firebaseConfig = {
    databaseURL: "https://fapp-shell.firebaseio.com",
    apiKey: "AIzaSyBKSXAoy3j9dz1Le_8NhJhG-4Nr_oF2bp8",
    authDomain: "fapp-shell.firebaseapp.com",
    projectId: "fapp-shell",
    storageBucket: "fapp-shell.appspot.com",
    messagingSenderId: "723908084224",
    appId: "1:723908084224:web:51d01f68762d82ecddcee5",
    //measurementId: "G-4T8EK4P28F",
};

// Initialize Firebase
const app = firebase.initializeApp(firebaseConfig);
//const analytics = getAnalytics(app);

// Receive background messages:
const messaging = firebase.messaging();

messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});

