//
//  View+extension.swift
//  Coconut
//
//  Created by sh on 8/9/21.
//

import SwiftUI

enum NavigationBarStyle {
    case defualt
    case light
    case dark
}
enum TabBarStyle {
    case defualt
}

extension View {
    
    func setNavBarAppearence(to style : NavigationBarStyle){
        let appearence = UINavigationBarAppearance()
        
        switch style {
        case .defualt:
            appearence.configureWithTransparentBackground()
            appearence.backgroundEffect = UIBlurEffect(style: .dark)
            appearence.backgroundColor = UIColor(named: "NavigationBackgroundColor")?.withAlphaComponent(0.8)
            /// Title Text Color
            appearence.titleTextAttributes = [.foregroundColor: UIColor(named : "WhiteColor") ?? .white]
            appearence.largeTitleTextAttributes = [.foregroundColor: UIColor(named : "WhiteColor") ?? .white]
            
        case .light:
            /// TODO - add light style
            break
        case .dark:
            /// TODO - add dark style
            break
        }
        
        UINavigationBar.appearance().standardAppearance = appearence
        UINavigationBar.appearance().scrollEdgeAppearance = appearence
        UINavigationBar.appearance().compactAppearance = appearence
        UINavigationBar.appearance().isTranslucent = true
    }
    func setTabBarAppearence(to style : TabBarStyle) {
        switch style {
        case .defualt:
            UITabBar.appearance().backgroundImage = UIImage()
            UITabBar.appearance().barTintColor = UIColor(named: "BackgroundColor")
            UITabBar.appearance().backgroundColor = UIColor(named: "BackgroundColor")
            break
        default:
            break
        }
    }
    
}
