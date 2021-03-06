# TableAdapter

<p align="left">
    <a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/language-Swift_4.2-green" alt="Swift5" /></a>
 <img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
 <a href="https://cocoapods.org/pods/tablekit"><img src="https://img.shields.io/badge/pod-1.0.0-blue.svg" alt="CocoaPods compatible" /></a>
    <a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage compatible" /></a>
 <a href="https://github.com/MobileUpLLC/TableAdapter/blob/develop/LICENSE"><img src="https://img.shields.io/badge/license-MIT-green" alt="License: MIT" /></a>
</p>

A data-driven library for building complex table views. Easy updating table view items with animations using automatic diffing algorithm under the hood. Our goal is to think in terms of data instead of index paths while building tables. High-level yet flexible api allows to setup sectioned lists in a few lines of code and take more control over the table where it’s needed. And reusable views configuring helps to keep code clean and stable in a type-safe manner.

<div align="center">
    <img src="https://user-images.githubusercontent.com/26662065/71070139-31544b00-218b-11ea-9512-5b2c519c0382.gif" width="" height="400" />
    <img src="https://user-images.githubusercontent.com/26662065/71070318-96a83c00-218b-11ea-9c0f-9015b63225e7.gif" width="" height="400" />
    <img src="https://user-images.githubusercontent.com/16690973/82672960-bf0bf900-9c49-11ea-9d86-56ba4711d1ae.gif" width="" height="400" />
</div>

## Features

- Animated table updates based on auto diffing
- Liner time diffing algorithm
- Type-safe cell, header/footer setup via protocol implementation
- No more `dequeReusable...`
- No need to subclass either cell, table or model
- Cell initialization from xib, storyboard or code
- Simple yet flexible sections constructing
- Easy to extend

## Usage

### 1. Setup models and reusable views

#### 1.1 Model setup

Item for cells must adopt `Hashable` protocol.

#### 1.2 Cells setup

Table view cell should conform to `Configurable` protocol in order to receive cell item for setup.

```swift
extension Cell: Configurable {

    public func setup(with item: User) {

        textLabel?.text = item.name
    }
}
```

#### 1.3 Header/Footer view setup

Header/Footer view also should adopt `Configurable` protocol to receive config item provided by `Section`.

```swift
extension Header: Configurable {

    public func setup(with item: String) {

        textLabel?.text = item
    }
}
```

### 2. Create sections

Section `Section<Item, SectionId>` is generic type and developer should provide cell models type (`Item`) and section id type (`SectionId`). It contains information about items, header/footer config (optionally) and must have unique `id`.

`HeaderFooterConfig` contains all information for section header/footer setup. There are two types of it: for default and custom header/footer view type.

#### 2.1 Default title for header/footer

```swift
let section = Section<User, Int>(
    id: 0,
    items: [...],
    header: .default(title: "Section Begin")
)
```

#### 2.2 Custom header/footer view

```swift
let section = Section<User, Int>(
    id: 0,
    items: [...],
    header: .custom(item: "Section Begin", reuseId: "FooterId")
)
```

**Node:** any type of item can be used for header/footer setup.

### 3. Create adapter and fill it with section

Create `TableAdapter<Item, SectionId>`. Item and section id are associated types, like in `Section`.

Then update adapter with sections.

```swift
class ViewController: UIViewController {

    let tableView = ...

    let users: [User] = [...]

    private lazy var adapter = TableAdapter<User, Int>(
        tableView: tableView,
        cellIdentifierProvider: { (indexPath, item) -> String? in
            return "Cell"
        },
        cellDidSelectHandler: { (table, indexPath, item) in
            // Handle cell selection for item at indexPath
        }
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTable()

        let section = Section<User, Int>(
            id: 0,
            items: users,
            header: .custom(item: "Begin", reuseId: "HeaderId"),
            footer: .custom(item: "End", reuseId: "FooterId"),
        )

        adapter.update(with: [section], animated: true)
    }

    func setupTable() {
        tableView.register(Cell.self, forCellReuseIdentifier: "Cell")

        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier identifier: "HeaderId")
        tableView.register(Footer.self, forHeaderFooterViewReuseIdentifier identifier: "FooterId")
    }
}
```

**Note**: this adapter type sets table view delegate to itself. To handle other table view delegate methods, you must inherit `TableAdapter` and implement them.

You can also obtain current adapter sections unisng `currentSections: [Section]` variable.

## Sender

Sometimes you need to set delegate for cell, header or footer. For that purpose table adapter has `sender` property, which will be passed to configurable view, that adopts `SenderConfigurable` protocol.

```swift
extension Cell: SenderConfigurable {

    func setup(with item: Item, sender: ViewController) {

        textLabel?.text = object.name
        delegate = sender
    }
}
```

## One cell type

To use only one cell type, create adapter **without** `CellReuserIdentifierProvider`

```swift
lazy var adapter = TableAdapter<User, Int>(tableView: tableView)
 ```

and register cell via storyboard or code for default cell reuse identifier, which is "Cell" under the hood

 ```swift
tableView.register(Cell.self, forCellReuseIdentifier: adapter.defaultCellIdentifier)
 ```

## Requirements

- Swift 4.2+
- iOS 9.0+

## Installation

### CocoaPods

Add the following to `Podfile`:

```ruby
pod 'TableAdapter'
```

### Carthage

Add the following to `Cartfile`:

```ruby
github "MobileUpLLC/TableAdapter"
```

### Manual

Download and drag files from Source folder into your Xcode project.

## License

TableAdapter is distributed under the [MIT License](https://github.com/MobileUpLLC/TableAdapter/blob/develop/LICENSE).
