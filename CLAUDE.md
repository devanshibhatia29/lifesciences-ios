# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Building and Running

To build and run the application, you'll need Xcode. The following commands work from the command line:

```bash
# Open the project in Xcode
open NetflixClone.xcodeproj

# Build the application from the command line
xcodebuild -project NetflixClone.xcodeproj -scheme NetflixClone build

# Test the application from the command line
xcodebuild -project NetflixClone.xcodeproj -scheme NetflixClone test

# Clean the build folder
xcodebuild -project NetflixClone.xcodeproj -scheme NetflixClone clean

# Build for a specific destination (e.g., iPhone simulator)
xcodebuild -project NetflixClone.xcodeproj -scheme NetflixClone -destination 'platform=iOS Simulator,name=iPhone 15' build
```

### Running a Single Test

To run a specific test from the command line:

```bash
xcodebuild -project NetflixClone.xcodeproj -scheme NetflixClone -destination 'platform=iOS Simulator,name=iPhone 15' test -only-testing:NetflixCloneTests/NetflixCloneTests/testExample
```

## Architecture

This is an iOS application built with UIKit that follows a Netflix-like interface and functionality.

### High-Level Structure

The application is structured using the MVC pattern with some MVVM aspects:

1. **App Initialization**:
   - `AppDelegate.swift`: Standard iOS app lifecycle management
   - `SceneDelegate.swift`: Sets up the main window and root controller
   - `MainTabBarViewController.swift`: The root controller with tab navigation

2. **Main Tabs**:
   - Home (`HomeViewController.swift`): Main content browsing screen
   - Upcoming (`UpcomingViewController.swift`): Shows upcoming content
   - Search (`SearchViewController.swift`): Content search functionality
   - Downloads (`DownloadViewController.swift`): User's downloaded content

3. **UI Components**:
   - Custom table view cells using UICollectionViews for horizontal scrolling (Netflix-style rows)
   - `CollectionViewTableViewCell.swift`: Implements a horizontal scrolling collection within a table cell

4. **Project Structure**:
   - `Controllers/`: Contains view controllers for the main screens
   - `Views/`: Custom UI components
   - `ViewModel/`: Contains view model objects (MVVM pattern)
   - `Manager/`: Service classes and managers
   - `Resources/`: Static resources and utilities

### Data Flow

The app appears to use a hierarchical pattern where:
1. The main tab bar contains navigation controllers
2. Each tab has its own view controller
3. HomeViewController uses a table view with custom cells
4. Each cell contains a horizontal-scrolling collection view

### Testing

The project includes basic test setup:
- `NetflixCloneTests.swift`: Unit tests
- `NetflixCloneUITests.swift`: UI tests

Note: Currently, the test files contain only the basic setup without actual test implementations.