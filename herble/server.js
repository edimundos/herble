const express = require('express');
const app = express();
const schedule = require('node-schedule');
const axios = require('axios');

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

// Endpoint to schedule a notification
app.get('/schedule', (req, res) => {
  const { deviceToken, plantName, notificationDateTime } = req.query;
  
  if (!deviceToken || !plantName || !notificationDateTime) {
    return res.status(400).send('Missing required parameters');
  }
  
  // Schedule the notification here
  scheduleNotification(DateTime.parse(notificationDateTime), deviceToken, plantName);

  res.send('Notification scheduled successfully');
});

// Function to send FCM notification
function sendFCMNotification(deviceToken, plantName) {
  // Make an API request to FCM
  // Replace 'SERVER_KEY' with your Firebase Server Key
  const fcmServerKey = 'AAAAsoSq2yQ:APA91bHVvU2JU3xOj9hmrWoFOcvoFbNev16xKqsqDbOMGyFsHtOw7dIR2hFiTVdCIA_FNo9mGvKCp7443D1f92BEoW5StkQvW1jeJznT3sSTnwA4MixKhFl1Xsf6qlfxQFU6dIZRdkTF	';
  
  axios.post(
    'https://fcm.googleapis.com/fcm/send',
    {
      to: deviceToken,
      notification: {
        title: 'Scheduled Notification Title',
        body: `Reminder for your ${plantName}`,
      },
    },
    {
      headers: {
        Authorization: `key=${fcmServerKey}`,
      },
    }
  )
  .then(response => {
    console.log('Notification sent:', response.data);
  })
  .catch(error => {
    console.error('Error sending notification:', error);
  });
}

// Function to schedule the notification
function scheduleNotification(scheduledDateTime, deviceToken, plantName) {
  const job = schedule.scheduleJob(scheduledDateTime, () => {
    sendFCMNotification(deviceToken, plantName);
  });

  console.log(`Notification scheduled for ${scheduledDateTime}`);
}
