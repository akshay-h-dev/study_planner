# Study Planner User Stories

## Project Overview

- **Project name:** Study Planner
- **Framework:** Flutter
- **Language:** Dart
- **Target platforms:** Android and Web
- **Document purpose:** Define the intended user needs and app behavior before implementing the application.

These user stories describe planned functionality. They do not claim that screens or features have already been implemented.

## User Story Format

> As a [user/persona], I want [a feature or action], so that [a benefit].

## 1. Login and Registration

### US-01 — Register an account
**As a** new student, **I want** to register with my name, email address, and password, **so that** I can create an account for my study plan.

**Acceptance criteria**
- The registration form provides fields for the required details.
- Required fields are validated before submission.
- The app displays a clear message if registration fails.
- On successful registration, the user receives confirmation and can proceed to the app.

### US-02 — Log in
**As a** registered student, **I want** to log in with my email address and password, **so that** I can access my study planner.

**Acceptance criteria**
- The login form accepts an email address and password.
- Missing or invalid details produce a clear error message.
- A successful login opens the appropriate app screen.

### US-03 — Keep account state between sessions
**As a** registered student, **I want** my authenticated state to be handled appropriately between app sessions, **so that** I do not have to repeat setup unnecessarily.

**Acceptance criteria**
- The app follows its chosen authentication approach when reopening.
- Logging out ends the authenticated session.
- Private account information is not exposed to another user.

## 2. Home Screen

### US-04 — View a study overview
**As a** student, **I want** to see an overview of my study tasks and upcoming deadlines on the home screen, **so that** I can understand what needs my attention.

**Acceptance criteria**
- The home screen presents the available study-task summary.
- Upcoming tasks and deadlines are easy to identify.
- An appropriate empty state appears when no tasks have been added.

### US-05 — Understand how to get started
**As a** new student, **I want** a short introduction or helpful empty-state guidance, **so that** I can learn how to start using the planner.

**Acceptance criteria**
- Guidance explains the main next step when the planner has no tasks.
- The guidance does not obstruct normal navigation.

### US-06 — Reach common features quickly
**As a** student, **I want** quick access to common actions such as viewing tasks, adding a task, and opening settings, **so that** I can navigate efficiently.

**Acceptance criteria**
- Common actions are clearly labelled or represented by understandable icons.
- Each available action opens the appropriate destination.

## 3. Study Task Detail Screen

### US-07 — View task details
**As a** student, **I want** to view a selected study task's title, subject, due date, and description, **so that** I understand what I need to complete.

**Acceptance criteria**
- Selecting a task opens its detail view.
- The details shown correspond to the selected task.
- The user can return to the previous screen.

### US-08 — Create and edit a study task
**As a** student, **I want** to add and update study tasks, **so that** my plan stays accurate as my workload changes.

**Acceptance criteria**
- The task form collects the planned task information.
- Required fields are validated.
- Saving a task updates the task list.
- Editing a task preserves the changes after saving.

### US-09 — Mark a task complete
**As a** student, **I want** to mark a study task as completed, **so that** I can track my progress.

**Acceptance criteria**
- A task can be marked complete and, where supported, reopened.
- The completion state is reflected in the task list and detail view.

### US-10 — Delete a task
**As a** student, **I want** to remove a task I no longer need, **so that** my plan remains relevant.

**Acceptance criteria**
- The app makes the delete action clear.
- The task is removed from the list after deletion.
- The app prevents accidental deletion where confirmation is appropriate.

### US-11 — Save or share study information
**As a** student, **I want** to save or share useful study-task information when supported, **so that** I can refer to it later or share it with someone.

**Acceptance criteria**
- Any save or share action is clearly identified.
- The app gives feedback when the action succeeds or fails.
- If sharing is outside the first implementation scope, this story remains a planned enhancement.

### US-12 — Explore related study resources
**As a** student, **I want** to find relevant study resources related to a task or subject, **so that** I can explore material that helps me prepare.

**Acceptance criteria**
- Related resources are relevant to the selected task or subject.
- Resource links or details are identifiable.
- If this depends on an external API, loading and error states are handled.

## 4. Persistent Data

### US-13 — Keep study tasks after reopening
**As a** student, **I want** my saved tasks and completion states to persist between sessions, **so that** I do not lose my study plan when I close the app.

**Acceptance criteria**
- Saved task data is restored when the app is reopened.
- Creating, editing, completing, or deleting a task updates the stored data.

### US-14 — Remember preferences
**As a** student, **I want** my selected preferences to be saved, **so that** the app uses my preferred settings next time.

**Acceptance criteria**
- Supported preferences are stored.
- Stored preferences are restored when the app is reopened.

### US-15 — Handle an empty or unavailable saved state
**As a** student, **I want** the app to handle missing or unavailable saved data gracefully, **so that** I can understand the state of my planner and continue using it.

**Acceptance criteria**
- The app shows a useful empty state when no tasks exist.
- Storage errors do not cause confusing or silent failures.
- Any recovery or retry action is explained clearly.

## 5. External API Integration

### US-16 — Access external study resources
**As a** student, **I want** the app to retrieve relevant study resources from a selected external API, **so that** I can discover material to support my learning.

**Acceptance criteria**
- The API and the data to be displayed are selected before implementation.
- The app displays useful results from a successful response.
- The interface indicates when data is loading.
- The app handles network errors, empty results, and invalid responses.

**Implementation note:** The supplied lab gives weather, currency conversion, and nearby restaurants as general examples of API use. For Study Planner, choose an API that fits study resources and document the choice before implementing this story.

## 6. Settings Menu

### US-17 — Open settings
**As a** student, **I want** to find the settings menu from the main app navigation, **so that** I can adjust my preferences when needed.

**Acceptance criteria**
- A clearly identified route to settings is available from the main navigation.
- Selecting it opens the settings area.
- Navigation back to the previous screen works as expected.

### US-18 — Find settings by category
**As a** student, **I want** settings to be grouped into understandable categories, **so that** I can find the option I need quickly.

**Acceptance criteria**
- Relevant options are grouped under labels such as Appearance, Notifications, and Account where those options are implemented.
- Category labels are clear and consistent.

## 7. Settings Screen

### US-19 — Enable dark mode
**As a** student, **I want** to enable or disable dark mode, **so that** I can use the app comfortably in different lighting conditions.

**Acceptance criteria**
- A theme preference control is available.
- The selected theme is applied consistently across implemented screens.
- The preference is retained between sessions if persistence is implemented.

### US-20 — Configure notification preferences
**As a** student, **I want** to control study reminder notifications, **so that** I receive reminders that suit my study routine.

**Acceptance criteria**
- Notification preferences are clearly presented.
- The app respects the saved preference where notifications are supported.
- The app explains when operating-system permission is required.

### US-21 — Manage account details
**As a** registered student, **I want** to manage my account details, such as my email address or password where supported, **so that** I can keep my account information up to date.

**Acceptance criteria**
- Account actions are clearly identified.
- Required fields are validated.
- Success and failure outcomes are communicated.
- If account editing is not part of the initial scope, it is recorded as a future enhancement.

## 8. Notifications

### US-22 — Receive a study reminder
**As a** student, **I want** to receive a reminder about a planned study task, **so that** I am less likely to forget it.

**Acceptance criteria**
- The reminder is associated with a relevant task or schedule.
- The app requests permission where required by the platform.
- The user can configure or disable supported reminders.
- Reminder behavior is tested on each intended target platform.

### US-23 — Control non-essential notifications
**As a** student, **I want** to control non-essential notifications separately from study reminders, **so that** I can focus on useful alerts.

**Acceptance criteria**
- Any implemented notification categories are described clearly.
- The user can disable optional categories where supported.
- The app does not claim to send notifications that have not been implemented.

### US-24 — Handle notification limitations
**As a** student, **I want** the app to explain when notifications are unavailable or permission is denied, **so that** I understand why a reminder may not appear.

**Acceptance criteria**
- Permission denial and unsupported-platform cases are handled gracefully.
- The app gives an understandable explanation or next step.

## 9. Usability and Platform Support

### US-25 — Use the app on different screen sizes
**As a** student, **I want** the interface to adapt to supported Android and Web screen sizes, **so that** I can use the planner on my available device.

**Acceptance criteria**
- Main content remains readable at supported screen sizes.
- Controls do not overlap or become inaccessible.
- Navigation remains understandable on each target platform.

### US-26 — Receive clear validation and error messages
**As a** student, **I want** clear feedback when I enter invalid information or an action fails, **so that** I know how to correct the problem.

**Acceptance criteria**
- Validation messages identify the problem.
- Error states provide a useful next step where possible.
- Successful actions provide appropriate feedback.

### US-27 — Use accessible controls
**As a** student, **I want** text, labels, and controls to be understandable and accessible, **so that** I can navigate the app comfortably.

**Acceptance criteria**
- Important controls have understandable labels.
- Text has readable contrast and sizing.
- Interactive controls have usable touch or pointer targets.

## Suggested Priority

Priorities are planning recommendations for the Study Planner, not priorities stated by the supplied lab.

| Priority | Stories |
|---|---|
| **High — initial core** | US-01, US-02, US-04, US-07, US-08, US-09, US-13, US-17 |
| **Medium — supporting features** | US-03, US-05, US-06, US-10, US-14, US-18, US-19, US-20, US-22, US-25, US-26 |
| **Later / confirm scope** | US-11, US-12, US-15, US-16, US-21, US-23, US-24, US-27 |

## Validation Checklist

Mark each item complete only after reviewing or testing it.

- [ ] The stories identify a user/persona, a need, and a benefit.
- [ ] The stories align with the planned Study Planner scope.
- [ ] Login and registration requirements include error feedback.
- [ ] Home and detail screen requirements are documented.
- [ ] Data persistence and external API behavior are documented.
- [ ] Settings menu, settings screen, and notifications are documented.
- [ ] Stories have been reviewed and prioritized.
- [ ] Acceptance criteria are clear enough to guide later implementation.
- [ ] Any features outside the initial scope are identified as planned enhancements.

## Evidence and GitHub Submission

The supplied lab specifies the following evidence filenames for its user-story exercises:

| Exercise | Evidence filename |
|---|---|
| Login/Registration | `userstories-login-registartion-evidence.png` |
| Home Screen | `userStories-homeScreen-evidence.png` |
| Detail Screen | `userStories-detailScreen-evidence.png` |
| Persistent Data | `userStories-persistent-evidence.png` |
| External API | `userStories-externalAPI-evidence.png` |
| Settings Menu | `userStories-settingMenu-evidence.png` |
| Settings Screen | `userStories-menuSettings-evidence.png` |
| Notifications | `userStories-notifications-evidence.png` |
