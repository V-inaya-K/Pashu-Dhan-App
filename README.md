# 🐃Pashu Dhan App
 1. Pashu Dhan app is an application that can find cattle breed on basis of it front and side iamges.<br/>
 2. Pashu Dhan app supports multiple language, has simple Ui and work on slow internet speed too as user can click and run later.<br/>
 3. Pashu Dhan app is trained on india bovine dataset using YOLOv8 and running in flutter app using tflite.

## ✨Demo Images

## 🧲Tech Stack

 - Flutter – Cross-platform frontend for mobile and web; handles camera input, file uploading, and user interaction.
 - TensorFlow Lite – Runs the trained YOLOv8 model on-device for fast, offline cattle & buffalo breed recognition.
 - YOLO v8 – Model used for image analysis and breed classification.
 - ImagePicker – Captures photos or selects images from the device gallery.
 - Supabase – Backend database and authentication; Stores cattle logs and user data.
 - AWS S3 – Stores uploaded cattle images into S3 bucket and images accessed from there.

## 🌀Workflow
 1. User Logins with provided credentials, to maintaing data security and mishandling.
 2. User can select/capture front and side images of same cattle.
 3. tflite model analyzes image and give result.
 4. Logs are created for every cattle that is visible on user activity tab.

## 🌊APK Link

## 🚀Future Ambitions

 1. Transition to complete multilingual Whisper model for native Hindi/Hinglish transcription.
 2. Train an LLM from scratch on Indian YouTube title/descriptions that go viral to optimize cultural relevance.
 3. Enable authors to upload pre-existing videos and compare generated versus original metadata.
 4. Implement login/signup to store history, previous uploads, and create content in bulk.


