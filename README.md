# TableAdapter
A lightweight data-driven library for animated updating UITableView items based on auto diffing.

## Basic Usage
### Models Creating
Elements must be unique in terms of `AnyEquatable` protocol.
```swift
public protocol AnyEquatable {
    
    func equal(any: AnyEquatable?) -> Bool
}
```

There is a default implementation of `AnyEquatable` protocol for types that conform to `Equitable` protocol.
```swift
struct Network: Equatable, AnyEquatable {
    
    let identifier = UUID()
    let name: String

    static func == (lhs: Network, rhs: Network) -> Bool {

        return lhs.identifier == rhs.identifier
    }
}
```

### Cell Setup
Cell should conform to `Configurable` protocol to receive element for config. The element type is generic associated type.

```swift
class Cell: UITableViewCell, Configurable {
    
    public func setup(with object: Network) {
        
        textLabel?.text = object.name
    }
}
```

### Adapter Setup
Create `TableAdapter` and register `Cell` for adapter default cell reuse identifier.
```swift
class ViewController: UIViewController {

    let tableView = ...
    
    lazy var adapter = TableAdapter(tableView: tableView)

    let items: [AnyDifferentiable] = [...]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(Cell.self, forCellReuseIdentifier: adapter.defaultCellIdentifier)

        adapter.update(with: items)
    }
}
```


## Sections
There are two ways of creating sections: on the fly from list of flat objects adopting `TableAdapterDataSource` protocol, or set `Section` objects to `TableAdapter`.

### `Section` objects
Section object itself must conform `Section` protocol, i.e. provide row objects, item for header(footer) setup (optionally) and be unique in terms of `AnyEquatable` protocol. In most cases you can use `ObjectsSection` which is basic adopting section protocol. Header(footer) object can by `Any` type. It's uniqueness based on id.

```swift
let sections = [
    ObjectsSection(id: 0, objects: [...]),
    ObjectsSection(id: 1, objects: [...]),
    ...
]

adapter.update(with: sections, animated: true)
```

### Sections on Fly
Section objects itsemf can be calculated from flat objects on fly. Sometimes it's handy when you don't know section in advance. You should implement corresponding methods from `TableAdapterDataSource`. This methods will be called on each adapter update for `DefaultSection` construnting. For objects belong to same section you must provide same header(footer) object in terms of `AnyEquatable`. Header(footer) object must adopt `AnyEquatable` protocol because, sections uniqueness based on both header and footer object.

```swift
extension ViewController: TableAdapterDataSource {

    func tableAdapter(_ adapter: TableAdapter, headerObjectFor cellObject: AnyEquatable) -> AnyEquatable? {

        switch object {

        case is String:
            return "Strings start"

        default:
            return "Any start"
        }
    }

    func tableAdapter(_ adapter: TableAdapter, footerObjectFor cellObject: AnyEquatable) -> AnyEquatable? {

        switch object {
            
        case is String:
            return "Strings end"

        default:
            return "Any end"
        }
    }
}
```

### UITableViewHeaderFooter
For default table view headers(footers) you should provide string header(footer) object usnig one of ways.

For custom table header or footer view usage at first you should register corresponding class or nib. You can register header(footer) for adapter default header(footer) identifier for all table in case of same header(footer) for all table. In case of different header(footer) for different section you must adopt corresponding methods from `TableAdapterDataSource` protocol.
```swift
extension ViewController: TableAdapterDataSource {
    
    func tableAdapter(_ adapter: TableAdapter, headerIdentifierFor section: Int) -> String? {
        
        return ...
    }
    
    func tableAdapter(_ adapter: TableAdapter, footerIdentifierFor section: Int) -> String? {
        
        return ...
    }
}
```

Header(footer) view must adopt either `Configurable` or `SenderConfigurable` to receive header object for setup.

## Advanced Cell
### Multy-types cell
To provide different cell types for different objects you must register cells:
```swift
tableView.register(StringCell.self, forCellReuseIdentifier: "StringCellId")
tableView.register(NetworkCell.self, forCellReuseIdentifier: "NetworkCellId")
tableView.register(GeneralCell.self, forCellReuseIdentifier: "GeneralCellId")
```

And then implement corresponding method from `TableAdapterDataSource`:
```swift
extension ViewController: TableAdapterDataSource {
    
    func tableAdapter(_ adapter: TableAdapter, cellIdentifierFor object: AnyEquatable) -> String? {
        
        switch object {

        case is String:
            return "StringCellId"
            
        case is Network:
            return "NetworkCellId"
            
        default:
            return "GeneralCellId"
        }
    }
}
```

### Cell Setup with Sender
Sometimes you need to set cell delegate, or for whatever reason provide `sender` object to cell.

At first, create adapter with sender object or provide it later. More often case, that sender role is dedicated to view controller.
```swift
class ViewController: UIViewController {

    lazy var adapter = TableAdapter(tableView: tableView, sender: self)

    ...
}
```
Then adopt `SenderConfigurable` protocol:
```swift
extension Cell: SenderConfigurable {
    
    func setup(with object: Network, sender: ViewController) {
        
        textLabel?.text = object.name
        delegate = sender
    }
}
```


# Requirements

# Istallation

# License
