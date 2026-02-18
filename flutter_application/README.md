# MerchantAI - Customer Feedback Analysis System

### 💡 Project Concept
MerchantAI is a comprehensive application designed to help merchants and business owners automatically understand customer sentiments. The system analyzes Arabic comments using Natural Language Processing (NLP) to classify them as Positive, Negative, or Neutral.

### Why this project?
1. Automated Monitoring: Instead of manually reading thousands of comments, the system processes them in seconds.
2. Improved Decision Making: Identifying pain points (negative comments) to address them immediately.
3. Arabic Language Support: Utilizing the AraBERT model, which is specialized in understanding complex Arabic dialects and contexts.

### How it works?
The project consists of three core layers:
1. Frontend: Built with Flutter, providing a seamless user experience for login, real-time analysis, and history viewing.
2. Backend & AI: Powered by Flask (Python), it receives text inputs and processes them through a pre-trained AraBERT model.
3. Database: An SQLite system is integrated to store user profiles and analysis history, ensuring data persistence.

### How to use it?
To run this project on your local machine, follow these steps:

#### 1. Setup the Backend:
* Navigate to the model_train folder.
* Ensure the model files are placed in the my_model_archive directory.
* Run the server using: python app.py.

#### 2. Setup the Mobile App:
* Open the Flutter project in VS Code.
* Ensure your device or emulator is connected.
* Run the app using: flutter run.

---
*Developed as a smart solution for modern merchants.*
