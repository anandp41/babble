// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
apiKey: "AIzaSyCvyR5rx84n-_eDImC9hKUQk3od3fEqRLk",
authDomain: "babble-23d3e.firebaseapp.com",
projectId: "babble-23d3e",
storageBucket: "babble-23d3e.appspot.com",
messagingSenderId: "953387577807",
appId: "1:953387577807:web:9822a4702c0fca029fe2ba",
measurementId: "G-02N225WXE8"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);