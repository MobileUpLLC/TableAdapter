//
//  HeaderFooterConfig.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 03.06.2020.
//

import Foundation

public struct HeaderFooterConfig {

    // MARK: Types

    public enum `Type` {

        case `default`
        case custom

        var isCustom: Bool {

            return self == .custom
        }
    }

    // MARK: Public properties

    public let type: Type
    public let item: Any
    
    public let reuseIdentifier: String?

    // MARK: Internal methods


    public var defaultTitle: String? {

        switch type {

        case .default:
            return item as? String

        case .custom:
            return nil
        }
    }

    public var customItem: Any? {

        switch type {

        case .default:
            return nil

        case .custom:
            return item
        }
    }

    // MARK: Public methods

    /// Default table header/footer view.
    /// - Parameter title: Title for header/footer view.
    /// - Returns: Config for setup.
    public static func `default`(title: String) -> Self {

        return Self(type: .default, item: title, reuseIdentifier: nil)
    }

    /// Custom table header/footer view.
    /// - Parameters:
    ///   - item: Model for header/footer view setup.
    ///   - reuseId: Reuse identifier of registered header/footer view.
    /// - Returns: Config for setup.
    public static func custom(item: Any, reuseId: String? = nil) -> Self {

        return Self(type:.custom, item: item, reuseIdentifier: reuseId)
    }
}
