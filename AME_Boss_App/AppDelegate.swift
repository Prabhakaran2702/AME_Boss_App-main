//
//  AppDelegate.swift
//  AME_Boss_App
//
//  Created by mohammed junaid on 14/01/21.
//  Copyright © 2021 amebusinesssolutions.com. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        
        var Storyboard = UIStoryboard()
        Storyboard = UIStoryboard(name: "Main", bundle: nil) 
        
        if  (AMEUserDefaults.userDefaults.string(forKey: "isUserLogIn") == "1") {
            if UserDefaults.standard.string(forKey: "IsRetail") == "1"{
                let DashBoardVC = Storyboard.instantiateViewController(withIdentifier: "TabVC") as! TabVC
                let rootNC = UINavigationController(rootViewController: DashBoardVC)
                self.window?.rootViewController = rootNC
            }else {
                let DashBoardVC = Storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                let rootNC = UINavigationController(rootViewController: DashBoardVC)
                self.window?.rootViewController = rootNC
            }
        }else if (AMEUserDefaults.userDefaults.string(forKey: "isUserLogIn") == "2") {
            let Login = Storyboard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            let rootNC = UINavigationController(rootViewController: Login)
            self.window?.rootViewController = rootNC
        }else{
            let InitalVC = Storyboard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            let rootNC = UINavigationController(rootViewController: InitalVC)
            self.window?.rootViewController = rootNC
        }
        self.window?.makeKeyAndVisible()
        return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "AME_Boss_App")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}




extension UIApplication {
    
    static func topVC() -> UIViewController {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        return topController!
    }
    
    
    static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        var app: AppDelegate!
        DispatchQueue.main.async {
            app = (UIApplication.shared.delegate as! AppDelegate)
        }
        let base1: UIViewController!
        if base != nil {
            base1 = base
        } else {
            base1 = app.window?.rootViewController
        }
        if let nav = base1 as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base1 as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        var flag = false
        var presented1: UIViewController!
        DispatchQueue.main.async {
            if let presented = base1?.presentedViewController {
                flag = true
                presented1 = presented
            }
        }
        if flag {
            return topViewController(base: presented1)
        }
        return base1
    }
}
