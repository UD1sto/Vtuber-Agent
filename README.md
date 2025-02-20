# Backend Server & Godot POC Setup Guide

This document explains how to start the backend server and outlines the steps required within Godot to test the proof-of-concept (POC).

## Backend Server Setup

1. **Start the Backend Server:**
   - Ensure you have your server dependencies installed (e.g., Node.js, Python, etc.) based on your backend implementation.
   - Navigate to the backend server directory.
   - Run the appropriate command to start the server. For example:
     - For a Node.js backend:
       ```bash
       npm install
       npm run start
       ```
     - For a Python backend (e.g., using Flask):
       ```bash
       pip install -r requirements.txt
       python app.py
       ```
   - Make sure the server URL is correctly configured in your client-side scripts. If you run the server locally, you can use `localhost` along with the port number (e.g., `ws://localhost:PORT/move`).

> **Note:** Adjust the commands and configuration based on your backend implementation.

## Godot POC Setup

Follow these steps to test the POC in Godot:

1. **Create a New Godot Project:**
   - Open Godot and create a new project with an appropriate name and location.

2. **Move the Network Folder:**
   - Copy or move the `Network` folder to the root directory of your Godot project.
   - This folder should contain all the network-related scripts (including `test.gd` and any others like `WebSocketManager.gd`).

3. **Import the GLB Asset:**
   - Import your `.glb` 3D asset into Godot (drag and drop it into the Godot file system).
   - Ensure the asset is properly imported and appears in the assets list.

4. **Create a 3D Scene:**
   - Create a new 3D scene by selecting `Scene` -> `New Scene` and choosing `Node3D` as the root node.

5. **Attach the 3D Asset:**
   - Instance the imported 3D asset and attach it as a child to the root node of your scene.
   - This asset will serve as the visual representation in your scene.

6. **Attach the POC Script:**
   - Attach the `Network/test.gd` script to the root node of your 3D scene.
   - This script is responsible for setting up the network manager and handling animation requests.

7. **Configure the Server URL:**
   - In your network scripts (e.g., in `WebSocketManager.gd`), locate the variable where the backend server URL is specified.
   - Update this variable if necessary. For local testing, set it to `localhost` (e.g., `ws://localhost:PORT`).

8. **Run the Scene:**
   - With everything set up, run the scene. Your asset should load, and the network manager should initialize.
   - Trigger events (such as animation requests) to verify that your Godot client communicates as expected with the backend server.

## Troubleshooting

- **poc Node Not Found:**
  - Ensure your scene has a child node named `poc` with an `AnimationPlayer` as its descendant, as expected by the `test.gd` script.

- **AnimationPlayer Issues:**
  - Verify that the `AnimationPlayer` node exists and is properly referenced by your `poc` node.

- **Server Connection Problems:**
  - Check that your backend server is running.
  - Confirm that the server URL in your client code is set correctly (use `localhost` if testing locally).

By following these steps, you should be able to set up your Godot project and connect it to the backend server without any issues. Happy developing! 