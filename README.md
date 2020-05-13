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

- Animated table updates based on auto diffing
- Liner time diffing algorithm
- Type-safe cell, header/footer setup via protocol implementation
- No more `dequeReusable...`
- No need to subclass either cell, table or model
- Cell initialization from xib, storyboard or code
- Simple yet flexible sections constructing
- Easy to extend

## Usage

### 1. Setup items and reusable views

Item for cells must adopt `Hashable` protocol.

Table view cell should conform to `Configurable` protocol in order to receive cell item for setup.

```swift
extension Cell: Configurable {

    public func setup(with item: User) {

        textLabel?.text = item.name
    }
}
```

Header/Footer view also should adopt `Configurable` protocol to receive config item provided by `Section`.

```swift
extension Header: Configurable {

    public func setup(with item: String) {

        textLabel?.text = item
    }
}
```

### 2. Create sections

Section contains information about items, header/footer (optionally) and must be unique by `id: Hashable`.

Section `Section<Item, SectionId>`  is generic type and developer should provide cell items type, section id type and header/footer setup object type.

### 3. Create adapter and fill it with section

Create `TableAdapter<Item, SectionId>` which is generic type to, with item and section id assosiated types, just like in `Section`.

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
        cellDidSelectHandler: { [weak self] (table, indexPath, item) in
            // Handle cell selection for item at indexPath
        }
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTable()

        let section = Section<User, Int>(
            id: 0,
            items: users,
            header: "Begin",
            footer: "End",
            headerIdentifier: "HeaderId",
            footerIdentifier: "FooterId"
        )

        adapter.update(with: [section]], animated: true)
    }

    func setupTable() {
        tableView.register(Cell.self, forCellReuseIdentifier: "Cell")
        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier identifier: "HeaderId")
        tableView.register(Footer.self, forHeaderFooterViewReuseIdentifier identifier: "FooterId")
    }
}
```

**Note**: this type of adapter set table view delegate to itself. To handle other table view delegate methods, you must inherit `TableAdapter` and implement them. Or you can use `BaseTableAdapter`.

Also you can obtain current adapter sections unisng `currentSections: [Section]` variable.

## Sender

Sometimes you need set delegate to cell, header or footer. For that purpose table adapter has `sender` property, which will be passed to configurable view, that adopts `SenderConfigurable` protocol.

```swift
extension Cell: SenderConfigurable {

    func setup(with item: Item, sender: ViewController) {

        textLabel?.text = object.name
        delegate = sender
    }
}
```

## Default Header/Footer

To use default header/footer view in section create `Section` with `String` header/footer object type and **without** reuse identifiers.

```swift
let section = Section<User, Int>(
    id: 0,
    items: [...],
    header: "Begin",
    footer: "End"
)
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
