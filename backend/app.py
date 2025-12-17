from flask import Flask, request, jsonify
from flask_cors import CORS
import joblib
import numpy as np


app = Flask(__name__)

CORS(app)

model = joblib.load("fake_news_binary_logreg.pkl")
vectorizer = joblib.load("tfidf_vectorizer.pkl")

@app.route("/predict", methods=["POST"])
def predict():
    data = request.get_json()
    text = data.get("text", "")

    if text.strip() == "":
        return jsonify({"error": "Empty text"}), 400

    X = vectorizer.transform([text])
    proba = model.predict_proba(X)[0]

    label = "REAL" if proba[1] > 0.5 else "FAKE"
    confidence = f"%{max(proba)*100:.2f}"

    return jsonify({
        "label": label,
        "confidence_score": confidence
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)