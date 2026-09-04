# StudentManagementApp

## Tech Stack
- **Language:** Swift 5
- **UI:** UIKit + Storyboard (Auto Layout, pageSheet, navigation)
- **Architecture:** MVVM (Model - View - ViewModel)
- **Persistence:** Core Data (Student, Admin, GalleryImageName)
- **Auth:** CoreDataManager + AuthManager (UserDefaults for session)
- **Theme:** ThemeManager (window.overrideUserInterfaceStyle, whole-app light/dark)

## Flow
1. **Launch** `SceneDelegate` checks `AuthManager.isLoggedIn`
   - Logged in → `Students` list (inside `UINavigationController`)
   - Not logged in → `LoginViewController` (inside `UINavigationController`)

2. **CreateAccount** → validates name/email/password → `CoreDataManager.registerAdmin` → `AuthManager.login` → goes to `Students`. Button `Already have an account? Log In` goes back to `Login`.

3. **Login** → validates email/password via `CoreDataManager.fetchAdmin` → `AuthManager.login` → goes to `Students`. Button `Don't have an account? Sign Up` goes to `CreateAccount`.

4. **Students** → `StudentListViewModel` loads from Core Data → table with `StudentTableViewCell`. Tap row → `StudentGalleryViewController` (3-column gallery). `+` button → `AddStudentViewController` sheet. Swipe row → Edit/Delete.

5. **AddStudent** → enters name/email/course + avatar → `AddStudentViewModel.validate` → `CoreDataManager.saveStudent` → dismiss → `Students` reloads.

6. **Theme** → button in `Students` nav bar → `ThemeManager.toggle()` changes all windows between light/dark and persists.
