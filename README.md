# To-Do List Application

A  Flutter project made by Nguyen Van Hung.
- Email: nguyenvhung@live.fr or van_hung_nguyen@yahoo.com
- Phone number: +84 911 911 320
- Main skill set: Flutter Dart and iOS Swift and Objective-C

## Instructions

Features:
- View to-dos
- Add, remove and update a to-do

Run the application:
- Step 1: run `flutter pub get` to get all dependencies of the app.
- Step 2: connect a mobile device to your computer or start a Simulator (iOS) or Emulator (Android),
- Step 3: run `flutter run --no-sound-null-safety` to start compiling the app onto the mobile device.

Main technical instructions and characteristics:
- Press (+) Plus button on the main screen to add a new to-do item.
    - Sembast databse as No-SQL local database will save the new to-do.
    - The app is using Provider to state managing, replacing setState in each view.
- Each to-do item has properties: creation date, last updated date, content as text, and done/not-done as boolean.
- Press the checkbox at the trailing of each to-do item to mark it done/undone:
    - Marking an item done/undone will not update its last updated date
- Press on the title of each to-do to see its details.
- Change the content of a to-do in its 'Details' screen:
    - When the content is changed, the app will prompt if user want to save it.
    - User can delete the to-do item as well. 

