/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotificationOnPendingItem = functions.firestore
  .document('pending_items/{itemId}')
  .onCreate(async (snap, context) => {
    const newItem = snap.data();

    // Define the message
    const message = {
      notification: {
        title: 'New Item Pending Approval',
        body: `Item ${newItem.Title} is pending for approval.`,
      },
      topic: 'admin_notifications', // Topic to send notification to all admins
    };

    // Send the notification
    try {
      await admin.messaging().send(message);
      console.log('Notification sent successfully');
    } catch (error) {
      console.error('Error sending notification:', error);
    }
  });
