//
//  SceneDelegate.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/9/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import FirebaseAuth
import RESideMenu

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    static let shared = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        
        // guard let windowScene = (scene as? UIWindowScene) else { return }
        // self.window = UIWindow(windowScene: windowScene)
        //self.changeRootViewController()
        //self.checkForCurrentUser()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
}
extension SceneDelegate {
    
    func changeRootViewController(){
        
        if let _ = Auth.auth().currentUser{
            //Logged in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let controller = storyboard.instantiateViewController(identifier: "HomeViewController") as? HomeViewController else {return}
            let leftMenuController = storyboard.instantiateViewController(withIdentifier: "SideMenu")
            let navController = BaseNavigationController(rootViewController: controller)
            let sideMenuController = RESideMenu(contentViewController: navController, leftMenuViewController: leftMenuController, rightMenuViewController: nil)
            
            if let window = self.window {
                window.rootViewController = nil
                UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                    //sideMenuController.leftViewWidth = window.frame.width * 0.75
                    self.window?.rootViewController = sideMenuController
                    self.window?.makeKeyAndVisible()
                }, completion: nil)
            }
            
        } else if SignInViewController.isComingFromWorkerLogin == true && (Auth.auth().currentUser != nil){
            
            let storyboard = UIStoryboard(name: "Vendor", bundle: nil)
            guard let controller = storyboard.instantiateViewController(identifier: "MyJobsController") as? HomeViewController else {return}
            let leftMenuController = storyboard.instantiateViewController(withIdentifier: "VendorSideMenu")
            let navController = BaseNavigationController(rootViewController: controller)
            let sideMenuController = RESideMenu(contentViewController: navController, leftMenuViewController: leftMenuController, rightMenuViewController: nil)
            
            if let window = self.window {
                window.rootViewController = nil
                UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                    //sideMenuController.leftViewWidth = window.frame.width * 0.75
                    self.window?.rootViewController = sideMenuController
                    self.window?.makeKeyAndVisible()
                }, completion: nil)
            }
        } else {
            // User is not logged in
            print ("User Not Logged In")
        }
    }
    
    //    func checkForCurrentUser(){
    //        if let _ = Auth.auth().currentUser{
    //            // User is already Loggedin
    //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //
    //            let initialNavigation = storyboard.instantiateViewController(withIdentifier: "initialNavigation") as! UINavigationController
    //
    //            let ViewController = storyboard.instantiateViewController(withIdentifier: "LocationView") as! UIViewController
    //            initialNavigation.setNavigationBarHidden(true, animated: false)
    //            initialNavigation.pushViewController(ViewController, animated: false)
    //
    //            self.window?.rootViewController = initialNavigation
    //
    //
    //
    //        }else{
    //            // User is not loggedin
    //            print("not logged in")
    //        }
    //    }
}
