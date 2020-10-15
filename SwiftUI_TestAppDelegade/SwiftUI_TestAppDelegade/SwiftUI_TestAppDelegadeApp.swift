//
//  SwiftUI_TestAppDelegadeApp.swift
//  SwiftUI_TestAppDelegade
//
//  Created by 古賀貴伍 on 2020/10/15.
//

import SwiftUI

@main
struct SwiftUI_TestAppDelegadeApp: App {
    
    // アプリケーションデリゲーを使用できるようにする
    @UIApplicationDelegateAdaptor private var appdelegate:AppDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// AppDelegateを使用してデバイストークンを取得する
class AppDelegate:NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let center = UNUserNotificationCenter.current()
        // Push通知の取得可否のポップアップ表示、一度許可したらずっと許可される
        center.requestAuthorization(options: [.alert,.badge,.sound]){granted,error in
            if error != nil {
                // このエラー発生要因がわからんのでとりあえずリターン
                return
            }
            if granted {
                // デバイストークン取得処理はメインスレッドで行う
                // registerForRemoteNotifications()が描画処理と被ってしまうと落ちる警告が表示されるので鬱陶しい
                DispatchQueue.main.async {
                  UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        return true
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // デバイストークンを文字列に変換
        let token = deviceToken.map { String(format: "%.2hhx", $0) }.joined()
        print(token)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
}
