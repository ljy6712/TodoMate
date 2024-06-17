//
//  AppDelegate.swift
//  Todo
//
//  Created by lll on 6/15/24.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Thread.sleep(forTimeInterval: 2.0)
        FirebaseApp.configure()
        
        return true
    }
    
    func addSampleData(to db: Firestore) {
            // 첫 번째 문서 추가
            db.collection("events").addDocument(data: [
                "title": "Sample Event 1",
                "details": "This is a sample event 1.",
                "completed": false,
                "date": Date(),
                "time": "10:00 AM"
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document successfully added.")
                }
            }
            
            // 두 번째 문서 추가
            db.collection("events").addDocument(data: [
                "title": "Sample Event 2",
                "details": "This is a sample event 2.",
                "completed": false,
                "date": Date(),
                "time": "2:00 PM"
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document successfully added.")
                }
            }
        }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

