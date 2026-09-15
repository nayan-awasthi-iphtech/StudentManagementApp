import UIKit

final class ThemeManager {

    static let shared = ThemeManager()
    private init() {}

    private let themeKey = "appThemeStyle"

    enum AppTheme: Int {
        case system = 0   // follow iOS setting (unspecified)
        case light = 1
        case dark = 2

        var userInterfaceStyle: UIUserInterfaceStyle {
            switch self {
            case .system: return .unspecified
            case .light: return .light
            case .dark: return .dark
            }
        }

        var iconName: String {
            switch self {
            case .dark: return "sun.max.fill"
            case .light, .system: return "moon.circle.fill"
            }
        }
    }

    var current: AppTheme {
        get {
            let raw = UserDefaults.standard.integer(forKey: themeKey)
            if UserDefaults.standard.object(forKey: themeKey) == nil {
                return .system
            }
            return AppTheme(rawValue: raw) ?? .system
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: themeKey)
            apply(newValue)
        }
    }

    /// Apply theme to all windows (whole app)
    func apply(_ theme: AppTheme) {
        let style = theme.userInterfaceStyle
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                window.overrideUserInterfaceStyle = style
            }
        }
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let delegate = windowScene.delegate as? SceneDelegate,
           let window = delegate.window {
            window.overrideUserInterfaceStyle = style
        }
    }
    func applyCurrent() {
        apply(current)
    }

    func toggle() {
        let currentStyle: UIUserInterfaceStyle
        // Determine effective style first
        if let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.windows.first }).first {
            currentStyle = window.overrideUserInterfaceStyle
        } else {
            currentStyle = .unspecified
        }

        let isDark: Bool
        if currentStyle == .unspecified {
            isDark = UITraitCollection.current.userInterfaceStyle == .dark
        } else {
            isDark = currentStyle == .dark
        }

        let newTheme: AppTheme = isDark ? .light : .dark
        current = newTheme
    }

    func resolvedStyle(for trait: UITraitCollection, windowStyle: UIUserInterfaceStyle) -> UIUserInterfaceStyle {
        if windowStyle != .unspecified { return windowStyle }
        return trait.userInterfaceStyle
    }
}
