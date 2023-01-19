//
//  Resource.swift
//  FitnessTrackerMPV
//
//  Created by macbook on 12.01.2023.
//

import UIKit

enum R {
    
    enum Colors {
        static let active = UIColor(hex: "#437BFE")
        static let inactive = UIColor(hex: "#929DA5")
        
        static let background = UIColor(hex: "#F8F9F9")
        static let separator = UIColor(hex: "#E8ECEF")
        static let secondary = UIColor(hex: "#F0F3FF")
        
        static let titleGray = UIColor(hex: "#545C77")
        static let subtitleGray = UIColor(hex: "#D8D8D8")
    }
    
    enum Strings {
        enum TabBar {
            static func title(for tab: Tabs) -> String {
                switch tab {
                case .view: return "View"
                case .session: return "Session"
                case .progress: return "Progress"
                case .settings: return "Settings"
                }
            }
        }
        
        enum NavBar {
            static let view = "Today"
            static let session = "High Intensity Cardio"
            static let progress = "Workout Progress"
            static let settings = "Settings"
        }
        
        enum View {
            static let allWorkoutsButton = "All Workouts"
        }
        
        enum Session {
            static let navBarStart = "Start"
            static let navBarPause = "Pause"
            static let navBarFinish = "Finish"
            
            static let elapsedTime = "Elapsed Time"
            static let remainingTime = "Remaining Time"
            static let completed = "Completed"
            static let remaining = "Remaining"
            
            static let workoutState = "Workout State"
            static let averagePace = "Average Pace"
            static let heartRate = "Heart Rate"
            static let totalDistance = "Total Distance"
            static let totalSteps = "Total Steps"
            
            static let stepsCounter = "Steps Counter"
        }
        
        enum Progress {
            static let navBarLeft = "Export"
            static let navBarRight = "Detaile"
            
            static let dailyPerformance = "Daily Performance"
            static let lastWeak = "Last Weak"
            
            static let monthlyPerformance = "Monthly Performance"
            static let lastYear = "Last Year"
        }
        
        enum Settings {}
    }
    
    enum Images {
        enum TabBar {
            static func icon(for tab: Tabs) -> UIImage? {
                switch tab {
                case .view: return UIImage(systemName: "house")
                case .session: return UIImage(systemName: "alarm")
                case .progress: return UIImage(systemName: "chart.bar.xaxis")
                case .settings: return UIImage(systemName: "gearshape")
                }
            }
        }
        
        enum Common {
            static let downArrow = UIImage(systemName: "chevron.down")
            static let add = UIImage(systemName: "plus.circle")
        }
        
        enum Session {
            static let heartRate = UIImage(systemName: "speedometer")
            static let averagePace = UIImage(systemName: "bolt.heart")
            static let totalSteps = UIImage(systemName: "map")
            static let totalDistance = UIImage(systemName: "figure.walk")
        }
    }
    
    enum Fonts {
        static func helvelicaRegular(with size: CGFloat) -> UIFont {
            UIFont(name: "Helvetica", size: size) ?? UIFont()
        }
    }
}
