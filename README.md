# TableAdapter
<p align="left">
    <a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/language-Swift_4.0-green" alt="Swift5" /></a>
	<a href="https://cocoapods.org/pods/tablekit"><img src="https://img.shields.io/badge/pod-2.10.0-blue.svg" alt="CocoaPods compatible" /></a>
    <a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage compatible" /></a>
	<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
	<a href="https://mobileup.ru/"><img src="https://img.shields.io/badge/license-MIT-green" alt="License: MIT" /></a>
</p>

A data-driven library for building complex table views. Easy updating table view items with animations using automatic diffing algorithm under the hood. Our goal is to think in terms of data but not in terms of index paths while building tables. High-level yet flexible api allows to setup sectioned lists in a few lines of code and take more control over the table where it needed. And configuring reusable views in a type-safe manner helps to keep code clean and stable.

<div align="center">
    <img src="https://user-images.githubusercontent.com/26662065/71070139-31544b00-218b-11ea-9512-5b2c519c0382.gif" width="" height="400" />
    <img src="https://user-images.githubusercontent.com/26662065/71070318-96a83c00-218b-11ea-9c0f-9015b63225e7.gif" width="" height="400" />
    <img src="https://user-images.githubusercontent.com/26662065/71070476-eb4bb700-218b-11ea-9239-db6d822d327d.gif" width="" height="400" />
</div>

## Features
- [x] Animated updates based on auto diffing
- [x] Type-safe cell, header and footer setup
- [x] No more `dequeReusable...` 
- [x] No need to subclass either cell, table or model
- [x] Cell initialization from xib, storyboard or code
- [x] Simple yet flexible sections constructing

## Basic Usage

Items must adopt `Hashable` protocol.

Table cell should conform to `Configurable` protocol in oreder to receive cell item for setup. The item type is generic associated type.
```swift
class Cell: UITableViewCell, Configurable {
    
    public func setup(with object: Network) {
        
        textLabel?.text = object.name
    }
}
```


Section contains information about items, header/footer (optionally) and must be unique by `id: Hashable` in order to calculate auto diff between them. Section is generic type and developer should provide cell items type, section id type and header/footer object type.

```swift
let section = Section<Network, Int, String>(id: 0, objects: [...], header: "Begin", footer: "End")
```

Create `ConfigCellTableAdapter` which is also generic type, so developer should provide items type, section id type and header/footer object type, just like in Section. Register `Cell` for adapter default cell reuse identifier. Apply sections to adapter.
```swift
class ViewController: UIViewController {

    let tableView = ...
    
    lazy var adapter = ConfigCellTableAdapter<Network, Int, String>(tableView: tableView)

    let networks: [Network] = [...]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(Cell.self, forCellReuseIdentifier: adapter.defaultCellIdentifier)

        let section = Section<Network, Int, String>(id: 0, objects: networks, header: "Begin", footer: "End")

        adapter.update(with: [section]], animated: true)
    }
}
```


## Multiple Cell Types

In case of multiple cell types, adapter must be crated with `CellReuseIdentifierProvider` closure in order to get cell reuse identifier for cell item.

```swift
lazy var adapter = ConfigCellTableAdapter<Item, Int, String>(
    tableView: tableView,
    cellIdentifierProvider: { (indexPath, item) -> String? in
    
        // Return cell reuse identifier for item at indexPath
    }
)
```

## Handle cell selection
For handling cell selection you should use `SupplementaryTableAdapter` and provide `CellDidSelectHandler` closure. 

```swift
private lazy var adapter = SupplementaryTableAdapter<Item, Int, String>(
    tableView: tableView,
    cellDidSelectHandler: { [weak self] (table, indexPath, item) in

        // Handle item selection at indexPath
})
```

**Note**: this type of adapter set table view delegate to itself. So in order to handle other table delegate methods, you must inherit `SupplementaryTableAdapter` and implement them.




## Custom Header/Footer


#### Default
For default table view headers(footers) you should only provide string header(footer) object usnig either corresponding varibles in `Section` model or implementing methods from `TableAdapterDataSource` protocol.

#### Custom
Custom header(footer) view should adopt `Configurable` protocol in order to receive header(footer) item for setup. Then you should register class or nib. In case of similar header(footer) view for all sections you can use default header(footer) reuse identifier property in table adapter.
```swift
tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: adpter.defaultHeaderIdentifier)
tableView.register(FooterView.self, forHeaderFooterViewReuseIdentifier: adpter.defaultFooterIdentifier)
```

In case of different header(footer) views for different sections you should implement corresponding methods from `TableAdapterDataSource` protocol:
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








## Sender
Sometimes you need set delegate to cell, header or footer. For that purpose table adapter has `sender: AnyObject?` property, which will be passed to configurable view. At first, init table adapter with sender parameter or set it later. In case of nill `sender`, table adapter itself will be passed to view setup method.
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








## Sections
There are two ways of creating sections: 
- Provide `Section` objects to `TableAdapter`
- Automatically construct sections from flat items.

### Section objects
Section object itself must conform `Section` protocol, i.e. 
- be unique in terms of `AnyEquatable` protocol
- provide cell objects
- privide items for header and footer views setup (optionally) 

For the most cases you can use `ObjectsSection` struct as basic adoptiong `Section` protocol. It's uniqueness based on `id`.

```swift
let sections = [
    ObjectsSection(id: 0, objects: [...], header: "Section One"),
    ObjectsSection(id: 1, objects: [...], header: "Section Two"),
    ...
]

adapter.update(with: sections, animated: true)
```

Also you can obtain current adapter sections unisng `currentSections: [Section]` variable.

### Construct automatically
Provide flat `AnyEquatable` cell items to adapter. Set adapter `dataSource: TableAdapterDataSource` and implement corresponding methods from it. For cell items belong to same section provide same header(footer) item in terms of `AnyEquatable`. This data source methods will be called on each adapter update with cell items. As the result we get `DefaultSection` objects under the hood. The uniqueness of that sections is based on uniqueness of both header and footer items. 

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




## Low-level Control
You can set yours `UITableView` delegate for getting more control over row selection, header(footer) configuration, table editing, etc. In that case table adapter won't any called methods from `TableAdapterDelegate` protocol and display custom header and footer views.


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
