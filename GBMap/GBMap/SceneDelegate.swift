//
//  SceneDelegate.swift
//  GBMap
//
//  Created by Dmitry Zasenko on 13.06.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateInitialViewController()
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
    
    //MARK: Protection
    func sceneDidBecomeActive(_ scene: UIScene) {
        if let protectLable: UILabel = UIApplication.shared.keyWindow?.subviews.last?.viewWithTag(1001) as? UILabel {
            protectLable.removeFromSuperview()
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        UIApplication.shared.keyWindow?.subviews.last?.addSubview(label)
    }

    var label: UILabel {
        let label = UILabel(frame: self.window!.bounds)
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.backgroundColor = .darkGray
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.text = "Content hidden\nto protect\nyour privacy"
        label.tag = 1001
        return label
    }
}

