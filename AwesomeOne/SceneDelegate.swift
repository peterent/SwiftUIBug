//
//  SceneDelegate.swift
//  AwesomeOne
//
//  Created by Peter Ent on 11/1/19.
//  Copyright © 2019 Peter Ent. All rights reserved.
//

import UIKit
import SwiftUI

@UIApplicationMain
class SceneDelegate: UIResponder, UIWindowSceneDelegate, UIApplicationDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            
            let vc = UIHostingController(rootView: AwesomeView())
            window.rootViewController = vc
            
            window.makeKeyAndVisible()
        }
    }

}

