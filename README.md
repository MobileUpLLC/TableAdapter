A data-driven ...

## Basic usage
Type of the element must conform to `AnyEquatable` protocol.

```swift
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

extension Network: Equatable, AnyEquatable {
    
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

        tableView.register(Cell.self, forCellReuseIdentifier: "Cell")

        adapter.update(with: items)
    }
}
```


## Sections
There are two ways of creating sections: on the fly from list of objects implementing `TableAdapterDataSource` protocol, or set `Section` objects to TableAdapter.


Create section using `ObjectSection` which is adopt `Section` protocol.
```swift
let sections = [
    ObjectsSection(id: 0, objects: [...]),
    ObjectsSection(id: 1, objects: [...])
]


adapter.update(with: sections, animated: true)
```


## Cell setup
To provide different cell types for different objects you must implement corresponding method from `TableAdapterDataSource`

```swift
extension ViewController: TableAdapterDataSource {
    
    func tableAdapter(_ adapter: TableAdapter, cellIdentifierFor object: Any) -> String? {
        
        switch object {

        case is String:
            return "StringCellIdentifier"
            
        case is Network:
            return "NetworkCellIdentifier"
            
        default:
            return "GeneralCellIdentifier"
        }
    }
}
```


Cell should conform to `Configurable` protocol to receive item for config. It's type-safe.

```swift
public protocol Configurable: AnyConfigurable {
    
    associatedtype T: Any
    
    func setup(with object: T)
}
```

Example:
```swift
class Cell: UITableViewCell, Configurable {
    
    public func setup(with object: Network) {
        
        textLabel?.text = object.name
    }
}
```

Sometimes you need to set cell delegate, so you can provide `sender` to cell. Adopt your cell to `SenderConfigurable` protocol:
```swift
public protocol SenderConfigurable {
    
    associatedtype S: Any
    
    associatedtype T: Any
    
    func setup(with object: T, sender: S)
}
```

Sender type is also type safe. Example:

```swift
class ViewController: UIViewController {

    let tableView = ...
    
    lazy var adapter = TableAdapter(tableView: tableView, sender: self)

    let items: [AnyDifferentiable] = [...]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(Cell.self, forCellReuseIdentifier: "Cell")

        adapter.update(with: items)
    }
}

extension Cell: SenderConfigurable {
    
    func setup(with object: String, sender: ViewController) {
        
        textLabel?.text = object
        delegate = sender
    }
}
```