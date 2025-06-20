# Recycl'Hair MVP

This repository contains the Minimum Viable Product (MVP) for the Recycl'Hair mobile application, a B2B platform to manage hair waste collection from salons for sustainable agriculture. The app connects salons, drivers, and administrators to streamline pickups, track waste, and reward participation.

## Project Structure
- `frontend/`: Flutter codebase for the mobile app (Android/iOS).
- `backend/`: Django codebase for the API and Firebase integration.

## Tech Stack
- **Frontend**: Flutter (Dart)
- **Backend**: Django (Python), Django REST Framework
- **Database**: Firebase Firestore
- **Storage**: Firebase Storage
- **Authentication**: Firebase Authentication
- **Notifications**: Firebase Cloud Messaging

## Setup Instructions
1. Clone the repository: `git clone https://github.com/your-username/recyclhair-mvp.git`
2. Set up the frontend (Flutter):
   - Navigate to `frontend/`
   - Run `flutter pub get` to install dependencies
3. Set up the backend (Django):
   - Navigate to `backend/`
   - Create a virtual environment: `python -m venv venv`
   - Install dependencies: `pip install -r requirements.txt`
4. Configure Firebase:
   - Add Firebase configuration files to `frontend/` and `backend/`
   - Set up Firestore, Storage, and Authentication

## Branches
- `main`: Production-ready code
- `frontend`: Flutter development
- `backend`: Django and Firebase development

## Team
- Developer 1: Frontend (Flutter)
- Developer 2: Backend (Django API)
- Developer 3: Firebase and Notifications

## License
MIT License
