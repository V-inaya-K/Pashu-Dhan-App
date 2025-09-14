# 🐃Pashu Dhan App
 1. Pashu Dhan app is an application that can find cattle breed on basis of it front and side iamges.<br/>
 2. Pashu Dhan app supports multiple language, has simple Ui and work on slow internet speed too as user can click and run later.<br/>
 3. Pashu Dhan app is trained on india bovine dataset using YOLOv8 and running in flutter app using tflite.

## ✨Demo Images

## 🧲Tech Stack

 - Flutter – handles backend web routing and file uploading.
 - TensorFlow Lite – For quick and accurate multilingual transcription of uploaded audio/video.
 - YOLO v8 – For quick and accurate multilingual transcription of uploaded audio/video.
 - ImagePicker – Manages prompt chaining and LLM integration for formatted output.
 - Supabase – Extremely fast LLM for title, description, and hashtag creation.
 - AWS S3 – Divides long transcripts into bite-sized chunks for better LLM comprehension.

## 🌀Workflow
 1. User Logins with provided credentials, to maintaing data security and mishandling.
 2. User can select/capture front and side images of same cattle.
 3. tflite model analyzes image and give result.
 4. Logs are created for every cattle that is visible on user activity tab.

## 🌊Run on your System

 **Step1:** git clone https://github.com/V-inaya-K/Hook.ai.git<br />
 **Step2:** cd yt caption<br />
 **Step3:** create .env file with your grop Api key(GROQ_API_KEY=YOUR_KEY)<br />
 **Step4:** pip install -r requirements.txt<br />
 **Step5:** python app.py<br />

## 🚀Future Ambitions

 1. Transition to complete multilingual Whisper model for native Hindi/Hinglish transcription.
 2. Train an LLM from scratch on Indian YouTube title/descriptions that go viral to optimize cultural relevance.
 3. Enable authors to upload pre-existing videos and compare generated versus original metadata.
 4. Implement login/signup to store history, previous uploads, and create content in bulk.


