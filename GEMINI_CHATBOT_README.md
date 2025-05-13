# Gemini Chatbot Integration

This document provides instructions on setting up and using the Gemini-powered chatbot in the Jamaican Scholarship Application System.

## Overview

The chatbot provides assistance to users by answering questions about Jamaican scholarships and how to use the application. It uses Google's Gemini AI to generate contextually relevant responses.

## Setup Instructions

1. **Get a Gemini API Key**:

   - Go to [Google AI Studio](https://makersuite.google.com/app/apikey) and create an account if you don't have one.
   - Generate a new API key.

2. **Add the API Key to the application**:

   - Open the file `lib/utils/constants/api_keys.dart`
   - Replace the placeholder `YOUR_GEMINI_API_KEY` with your actual API key:
     ```dart
     static const String geminiApiKey = 'YOUR_ACTUAL_API_KEY';
     ```

3. **Install Dependencies**:
   - Ensure the required dependencies are installed by running:
     ```bash
     flutter pub get
     ```

## Features

- **Floating Chat Button**: Accessible from any screen in the student dashboard.
- **Contextual Responses**: The chatbot has been trained with information about Jamaican scholarships.
- **Simple Interface**: Easy-to-use chat interface with a text input and response area.

## Customizing the Chatbot

### Modifying the Prompt Template

The chatbot uses a predefined prompt template to provide context to the Gemini AI. You can modify this template in:
`lib/utils/constants/chatbot_prompts.dart`

### Changing the UI

The chatbot UI is defined in:
`lib/shared_components/gemini_chatbot.dart`

## Best Practices

- **API Key Security**: Never commit your API key to version control.
- **Rate Limiting**: Be aware of Gemini API usage limits.
- **Error Handling**: The chatbot is designed to handle API errors gracefully.

## Troubleshooting

- **ChatBot Not Responding**: Check your internet connection and ensure the API key is correctly set.
- **Error Messages**: If you see error messages, check the console for more details.
