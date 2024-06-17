//
//  SceneDelegate.swift
//  Todo
//
//  Created by lll on 6/15/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            guard let windowScene = (scene as? UIWindowScene) else { return }

            window = UIWindow(windowScene: windowScene)
            let initialViewController = LoginViewController() // 초기 뷰 컨트롤러를 로그인 화면으로 설정
            let navigationController = UINavigationController(rootViewController: initialViewController)
            
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
        
        func switchToMainScreen() {
            let tabBarController = UITabBarController()
            
            let calendarVC = TodoListViewController()
            calendarVC.view.backgroundColor = .white
            calendarVC.tabBarItem = UITabBarItem(title: "Calendar", image: UIImage(systemName: "calendar"), tag: 0)
            
            let allTasksVC = UIViewController()
            allTasksVC.view.backgroundColor = .white
            allTasksVC.tabBarItem = UITabBarItem(title: "All Tasks", image: UIImage(systemName: "checkmark.circle"), tag: 1)
            
            let myPageVC = UIViewController()
            myPageVC.view.backgroundColor = .white
            myPageVC.tabBarItem = UITabBarItem(title: "MyPage", image: UIImage(systemName: "person.circle"), tag: 2)
            
            tabBarController.viewControllers = [calendarVC, allTasksVC, myPageVC]
            
            window?.rootViewController = tabBarController
            window?.makeKeyAndVisible()
            
            // Optional: 애니메이션 효과를 추가하여 부드러운 전환을 만듭니다.
            UIView.transition(with: window!,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session was discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
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
