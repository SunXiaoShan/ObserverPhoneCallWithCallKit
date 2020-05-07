//
//  AppDelegate.swift
//  CallKitDemo
//
//  Created by Phineas.Huang on 2020/5/7.
//  Copyright © 2020 Phineas. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let locationManager: CLLocationManager! = CLLocationManager()
    var bgTask: UIBackgroundTaskIdentifier? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        return true
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
    
    func sendBackgroundLocationToServer(_ location:CLLocation) {
        bgTask = UIApplication.shared.beginBackgroundTask(expirationHandler: { [weak self] in
            guard (self?.bgTask != nil) else {
                return
            }

            UIApplication.shared.endBackgroundTask((self?.bgTask)!)
        })
        
        guard (bgTask != nil) && bgTask != UIBackgroundTaskIdentifier.invalid else {
            return
        }
        
        UIApplication.shared.endBackgroundTask(bgTask!)
        bgTask = UIBackgroundTaskIdentifier.invalid
    }


}

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var isInBackground = false
        if (UIApplication.shared.applicationState == .background) {
            isInBackground = true
        }

        sendBackgroundLocationToServer(locations[0])
    }
}

