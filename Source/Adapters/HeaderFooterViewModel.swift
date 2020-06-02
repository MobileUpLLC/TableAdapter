//
//  HeaderFooterViewModel.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 03.06.2020.
//

import Foundation

public struct HeaderFooterViewModel {

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


    var defaultItem: String? {

        switch type {

        case .default:
            return item as? String

        case .custom:
            return nil
        }
    }

    var customItem: Any? {

        switch type {

        case .default:
            return nil

        case .custom:
            return item
        }
    }

    // MARK: Public methods

    public static func `default`(item: String) -> Self {

        return Self(type: .default, item: item, reuseIdentifier: nil)
    }

    public static func custom(item: Any, reuseId: String? = nil) -> Self {

        return Self(type:.custom, item: item, reuseIdentifier: reuseId)
    }
}
