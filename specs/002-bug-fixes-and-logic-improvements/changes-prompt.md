We are going to develop a new feature for our app. Create principles focused on code quality, testing standards, user experience consistency, and performance requirements



The new feature should: 

Solve current bugs:
- The settings page is not responsive. I have vibe coded a lot with the AI to fix this and it keeps on producing wrong results. It is important to come up with an effective, well thought solution. Also check if some code should be refactored or cleaned since the vibe coding might have produced some wrong stuff.

New features: 
- If the timer is running and you select a new mode, it should pop up a window asking if you want to switch mode and lose the current running timer
- Persistance when closing and opening the application. When a user tries to quit the application while a timer is active, they must be presented with a confirmation dialog asking how to handle the running timer. This ensures users don't accidentally lose their timer progress:

**Acceptance Scenarios**:

1. **Given** a timer is running, **When** user attempts to quit the application, **Then** a confirmation dialog appears with the message "Timer is active now. Are you sure you want to quit the app?"
2. **Given** the confirmation dialog is displayed, **When** user selects "Stop timer and Quit", **Then** the timer stops and the application quits
3. **Given** the confirmation dialog is displayed, **When** user selects "Quit and leave timer running", **Then** the application quits but timer state is preserved for next launch
4. **Given** the confirmation dialog is displayed, **When** user selects "Cancel", **Then** the dialog closes and the application continues running with the timer active


- Enhanced alarm sound. I have uploaded a new alarm sound in @/Sharp\ Timer\ App/Sharp\ Timer\ App/sounds/alarm.mp3 
