//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Сергей Прокопьев on 22.09.2018.
//  Copyright © 2018 Tinkoff Fintech. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var mpcManager : MultipeerCommunicator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("Application moved from Not running to inactive :\(#function)")
        //mpcManager = MultipeerCommunicator()
        mpcManager = MultipeerCommunicator()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print("Application moved from active to inactive :\(#function)")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Application moved from inactive to background :\(#function)")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("Application moved from background to inactive:\(#function)")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("Application moved from inactive to active :\(#function)")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("Application moved from Any to Not running :\(#function)")
    }


}

