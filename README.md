# Fake News Detection App 

⚠️ This project consists of a Flask backend and a Flutter mobile app.
The backend must be running for the app to work correctly.

This project is a Fake News Detection system using:
- Machine Learning (Python)
- Flask REST API
- Flutter Mobile Application

Users can paste a news text into the mobile app and get a prediction
showing whether the news is REAL or FAKE with a confidence score.

---

## Mobile App Preview



---

## Model & Backend (Flask API)

The backend is a Flask API that loads a trained ML model and tokenizer
and exposes a `/predict` endpoint.

### Requirements
- Python 3.9+
- pip

### Setup Backend

```bash
cd backend
python -m venv venv
venv\Scripts\activate   # Windows
pip install -r requirements.txt
python app.py
```

API will run on: http://127.0.0.1:5000

## Flutter Mobile App
### Requirements
- Flutter SDK
- Android Studio or Emulator

### Run Mobile App
```bash
cd mobile
flutter pub get
flutter run
```

⚠️ Important
If you are using Android Emulator, the API URL must be:

http://10.0.2.2:5000/predict
