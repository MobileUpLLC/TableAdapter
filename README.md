## Basic usage

Type of the element must conform to `AnyDifferentiable` protocol.

```swift
public typealias AnyDifferentiable = AnyIdentifiable & AnyEquatable

public protocol AnyIdentifiable {
    
    var id: AnyEquatable { get }
}

public protocol AnyEquatable {
    
    func equal(any: AnyEquatable?) -> Bool
}
```

Default implementation of `AnyEquatable`  for types that conforms to `Equitable` protocol:
```swift
public extension AnyEquatable where Self: Equatable {

    func equal(any: AnyEquatable?) -> Bool {

        if let any = any as? Self {
            
            return any == self
        }

        return false
    }
}
```

Example of conformance:
```swift
struct Network {
    
    let name: String
    
    let identifier = UUID()
}

extension Network: Equatable, AnyDifferentiable {
    
    var id: AnyEquatable {
        
        return identifier.uuidString
    }
    
    static func == (lhs: Network, rhs: Network) -> Bool {
        
        return lhs.identifier == rhs.identifier
    }
}
```

Usage example:
```swift
class ViewController: UIViewController {

    let tableView = ...
    
    lazy var adapter = TableAdapter(tableView: tableView)

    let items: [AnyDifferentiable] = [...]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        adapter.update(with: items)
    }
}
```

## Cell setup
Cell shuold conform to `Configurable` protocol to receive item for config. It's type-safe.

```swift
public protocol Configurable: AnyConfigurable {
    
    associatedtype T: Any
    
    func setup(with object: T)
}
```

Example:
```swift
class Cell: UITableViewCell, Configurable {
    
    public func setup(with object: Int) {
        
        textLabel?.text = "\(object)"
    }
}
```