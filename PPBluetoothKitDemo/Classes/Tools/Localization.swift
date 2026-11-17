//
//  Localization.swift
//  PPBluetoothKitDemo
//
//
//

import Foundation

/// Demo 支持的语言
enum DemoLanguage {
    case chinese
    case english
}

enum Localization {

    static let language: DemoLanguage = {

        for preferred in Locale.preferredLanguages {

            let code = preferred.lowercased()

            if code.hasPrefix("zh") {
                return .chinese
            }

            if code.hasPrefix("en") {
                return .english
            }
        }

        return .english
    }()

    private static let bundle: Bundle = {

        let identifier = language == .chinese ? "zh-Hans" : "en"

        if let path = Bundle.main.path(forResource: identifier, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return bundle
        }

        return Bundle.main
    }()


    static func string(_ key: String) -> String {

        return bundle.localizedString(forKey: key, value: key, table: "Localizable")
    }

    static func string(_ key: String, _ arguments: CVarArg...) -> String {

        return String(format: string(key), arguments: arguments)
    }
}
