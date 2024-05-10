# Utilities Swift Library

> Offers utility functions to convert, encode, decode, and parse data structures.

This utility library provides various functionalities to handle tasks such as conversion from one data structure to another, parse tlv structures, etc. Examples include conversion of UInt16 to data bytes, conversion of data bytes to hexadecimal string, concatenation of data bytes, etc. 

The list of supported utility methods can be found in the API document. Please use `swift package generate-documentation` to generate API document of this library.  

## Example

The below example illustrates the usage for getting subdata bytes from a byte array based on offset and length. 

1. Include headers

``` swift
import InfineonUtils
```

2. Sample usage of Utils method

```swift
do {
    let offset = 2 // Index of data byte
    let length = 4 // Required length of byte array.
    let data = Data([0xd2, 0x76, 0x00, 0x00, 0x85, 0x01, 0x01])
    // Gets the sub data from the stream of source data based on length and offset.
    let subData = try Utils.getSubData(offset: offset, data: data, length: length)
} catch {}
```
