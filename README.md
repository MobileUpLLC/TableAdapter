# TableAdapter
<p align="left">
    <a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/language-Swift_4.0-green" alt="Swift5" /></a>
	<a href="https://cocoapods.org/pods/tablekit"><img src="https://img.shields.io/badge/pod-2.10.0-blue.svg" alt="CocoaPods compatible" /></a>
    <a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage compatible" /></a>
	<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
	<a href="https://mobileup.ru/"><img src="https://img.shields.io/badge/license-MIT-green" alt="License: MIT" /></a>
</p>

<img src="https://user-images.githubusercontent.com/26662065/71070476-eb4bb700-218b-11ea-9239-db6d822d327d.gif" width="" height="400" align="right" />
<img src="https://user-images.githubusercontent.com/26662065/71070318-96a83c00-218b-11ea-9c0f-9015b63225e7.gif" width="" height="400" align="right" />
<img src="https://user-images.githubusercontent.com/26662065/71070139-31544b00-218b-11ea-9512-5b2c519c0382.gif" width="" height="400" align="right" />

A lightweight data-driven library for animated updating UITableView.

<br clear="all">


## Features
- [x] Animated updates based on auto diffing
- [x] Type-safe cell, header and footer setup
- [x] No more `dequeReusable...`
- [x] No need to subclass either cell, table or model
- [x] Cell initialization from xib, storyboard or code
- [x] Flexible sections constructing
- [x] Heterogeneous items in section

## Basic Usage

Cell items must be unique in terms of `AnyEquatable` protocol.
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

Table cell should conform to `Configurable` protocol to receive cell item for config. The item type is generic associated type.
```swift
class Cell: UITableViewCell, Configurable {
    
    public func setup(with object: Network) {
        
        textLabel?.text = object.name
    }
}
```

Create `TableAdapter` and register `Cell` for adapter default cell reuse identifier.
```swift
class ViewController: UIViewController {

    let tableView = ...
    
    lazy var adapter = TableAdapter(tableView: tableView)

    let networks: [AnyDifferentiable] = [...]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(Cell.self, forCellReuseIdentifier: adapter.defaultCellIdentifier)

        adapter.update(with: networks)
    }
}
```


## Sections
There are two ways of creating sections: 
- Provide `Section` objects to `TableAdapter`
- Automatically construct sections from flat items

### Section objects
Section object itself must conform `Section` protocol, i.e. 
- be unique in terms of `AnyEquatable` protocol
- provide cell objects,
- privide items for header and footer views setup (optionally) 

For the most cases you can use `ObjectsSection` struct as basic adoptiong `Section` protocol. It's uniqueness based on `id`.

```swift
let sections = [
    ObjectsSection(id: 0, objects: [...], header: "Section One",),
    ObjectsSection(id: 1, objects: [...], header: "Section Two",),
    ...
]

adapter.update(with: sections, animated: true)
```

### Construct Autamatically
Set adapter `dataSource` and implement corresponding methods from `TableAdapterDataSource` protocol. For cell objects belong to same section provide same header(footer) object in terms of `AnyEquatable`. The uniqueness of that sections is based on uniqueness both header and footer items. The set flat `AnyEquatable` cell items to adapter.

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

### Header(Footer) View
For default table view headers(footers) you should only provide string header(footer) object usnig either corresponding varibles in `Section` model or implementing methods from `TableAdapterDataSource` protocol.

Custom header(footer) view must adopt `Configurable` to receive header object for setup. Then you should register class or nib.

 In case of similar header(footer) view for all sections you can use default header(footer) reuse identifier propertie in table adapter.
```swift
tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: adpter.defaultHeaderIdentifier)
tableView.register(FooterView.self, forHeaderFooterViewReuseIdentifier: adpter.defaultFooterIdentifier)
```

In case of different header(footer) views for different sections you must implement corresponding methods from `TableAdapterDataSource` protocol:
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


## Cells

### Multiple cell types

To provide different cell types for different objects you must register cells:
```swift
tableView.register(StringCell.self, forCellReuseIdentifier: "StringCellId")
tableView.register(NetworkCell.self, forCellReuseIdentifier: "NetworkCellId")
tableView.register(GeneralCell.self, forCellReuseIdentifier: "GeneralCellId")
```

Set table adapter data source and implement corresponding method from `TableAdapterDataSource` protocol.
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

### Handle Cell Selection
For handling cell selection set table adapter delegate and implement `TableAdapterDelegate` protocol.
```swift
extension ViewController: TableAdapterDelegate {
    
    func tableAdapter(_ adapter: TableAdapter, didSelect object: AnyEquatable) {
        
        ...
    }
}
```

## Sender
Sometimes you need set delegate to cell, header or footer. For that purpose table adapter has `sender` property, which can be passed to configurable view. At first, init table adapter with sender parameter. Also you can set it later. In case of nill `sender`, table adapter itself will be passed to view setup method.
```swift
class ViewController: UIViewController {

    lazy var adapter = TableAdapter(tableView: tableView, sender: self)

    ...
}
```
Then adopt `SenderConfigurable` protocol. The item and sender types are generic associated types.
```swift
extension Cell: SenderConfigurable {
    
    func setup(with object: Network, sender: ViewController) {
        
        textLabel?.text = object.name
        delegate = sender
    }
}
```


## Requirements
- Swift 4.0+
- iOS 9.0+


## Istallation

### CocoaPods
Add the following to `Podfile`:
```ruby
pod 'TableAdapter'
```

### Manual
Download and drag files from Source folder into your Xcode project.


## License
TableAdapter is distributed under the [MIT License](https://mobileup.ru/).
