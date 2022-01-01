<p align="center">
    <img src="./Sources/Treesquid/Resources/logo-wide-1200-240.png" width="600" />
</p>

# Treesquid

![build status](https://github.com/Treesquid-Swift/Treesquid/actions/workflows/swift.yml/badge.svg)

Tree data structures and algorithms for Swift.

### Data Structures

- unbalanced tree
  - generic tree
  - m-ary tree
  - binary tree
- balanced tree
  - red-black tree
  - B-tree
  
### Algorithms

- tree and node CRUD operations
- tree balancing
- key search
  - O(log n) for balanced trees
  
### Planned Features

- trie implementation (a.k.a. prefix tree)
- key search
  - O(m), m being the length of the search sequence, for tries
- grafting
- pruning

## Motivation

Treesquid was born out of necessity: I needed a simple but efficient tree implementation for a macOS app, there was no tree package out there, and then I just kept coding.

## Design

Type safety comes first in Treesquid. The goal is to catch silly mistakes right at compile time, so that developers can focus on their own code instead of fighting with this package.

Documentation comes second, because Treesquid would be useless without it. With the upcoming [Xcode 13](https://developer.apple.com/xcode/), it is planned to have all of Treesquid's code annotated with documentation comments for DocC Archive generation.

Last, but not least, Treesquid's class and protocol design aims to have a clean and crisp public interface. That means that Treesquid is designed around a few core-protocols, and otherwise makes use of Swift's [Sequence and Collection Protocols](https://developer.apple.com/documentation/swift/swift_standard_library/collections/sequence_and_collection_protocols).

## License

[MIT License](https://raw.githubusercontent.com/Treesquid-Swift/Treesquid/main/LICENSE.txt)

## Inspiration

The following work was used as an inspiration for Treesquid:

- [Swift Algorithm Club: Swift Tree Data Structure](https://www.raywenderlich.com/1053-swift-algorithm-club-swift-tree-data-structure) by Kelvin Lau. (Accessed: September 4th, 2021)
- [Trees in Hacking with Swift](https://www.hackingwithswift.com/plus/data-structures/trees) by Paul Hudson. (Accessed: September 4th, 2021)

