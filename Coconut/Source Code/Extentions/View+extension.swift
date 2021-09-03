//
//  View+extension.swift
//  Coconut
//
//  Created by sh on 8/9/21.
//

import SwiftUI

// MARK: - NAVIGATION BAR
enum NavigationBarStyle {
    case defualt
    case light
    case dark
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
            break
            /// TODO - add dark style
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
        }
    }
    
}
// MARK: - ANIMATION
extension View {

    /// Calls the completion handler whenever an animation on the given value completes.
    /// - Parameters:
    ///   - value: The value to observe for animations.
    ///   - completion: The completion callback to call once the animation completes.
    /// - Returns: A modified `View` instance with the observer attached.
    func onAnimationCompleted<Value: VectorArithmetic>(for value: Value, completion: @escaping () -> Void) -> ModifiedContent<Self, AnimationCompletionObserverModifier<Value>> {
        return modifier(AnimationCompletionObserverModifier(observedValue: value, completion: completion))
    }
    
}
/// An animatable modifier that is used for observing animations for a given animatable value.
struct AnimationCompletionObserverModifier<Value>: AnimatableModifier where Value: VectorArithmetic {

    /// While animating, SwiftUI changes the old input value to the new target value using this property. This value is set to the old value until the animation completes.
    var animatableData: Value {
        didSet {
            notifyCompletionIfFinished()
        }
    }

    /// The target value for which we're observing. This value is directly set once the animation starts. During animation, `animatableData` will hold the oldValue and is only updated to the target value once the animation completes.
    private var targetValue: Value

    /// The completion callback which is called once the animation completes.
    private var completion: () -> Void

    init(observedValue: Value, completion: @escaping () -> Void) {
        self.completion = completion
        self.animatableData = observedValue
        targetValue = observedValue
    }

    /// Verifies whether the current animation is finished and calls the completion callback if true.
    private func notifyCompletionIfFinished() {
        guard animatableData == targetValue else { return }

        /// Dispatching is needed to take the next runloop for the completion callback.
        /// This prevents errors like "Modifying state during view update, this will cause undefined behavior."
        DispatchQueue.main.async {
            self.completion()
        }
    }

    func body(content: Content) -> some View {
        /// We're not really modifying the view so we can directly return the original input value.
        return content
    }
}
// MARK: - KEYBOARD
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
// MARK: - TAB BAR
enum TabBarStyle {
    case defualt
}
/// - Description : extenstion for hidding and showing tabbar
extension View {
    func showTabBar() -> some View {
        return self.modifier(ShowTabBar())
    }
    func hiddenTabBar() -> some View {
        return self.modifier(HiddenTabBar())
    }
}
/// - Description : Tool for showing or hidding tabbar
struct Tool {
    static func showTabBar() {
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.allSubviews().forEach({ (v) in
            if let view = v as? UITabBar {
                print("HI IM HERE GOOOz")
                view.alpha = 1
            }
        })
    }
    static func hiddenTabBar() {
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.allSubviews().forEach({ (v) in
            if let view = v as? UITabBar {
                view.alpha = 0
                print(view.bounds)
            }
        })
    }
}

struct ShowTabBar: ViewModifier {
    func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            Tool.showTabBar()
        }
    }
}
struct HiddenTabBar: ViewModifier {
    func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            Tool.hiddenTabBar()
        }
    }
}
/// - Description  : Needed for Tool
extension UIView {
    func allSubviews() -> [UIView] {
        var res = self.subviews
        for subview in self.subviews {
            let riz = subview.allSubviews()
            res.append(contentsOf: riz)
        }
        return res
    }
}
