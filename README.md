# VisionTextArc

![Swift](https://img.shields.io/badge/Swift-6-blu) ![Platform](https://img.shields.io/badge/Platform-visionOS-red) ![License](https://img.shields.io/badge/License-GNU-green)

`VisionTextArc` is a Swift framework that generates 3D curved text with customizable parameters for creative visualizations in visionOS apps. Built on **RealityKit**, it provides an intuitive API for creating stunning, curved text effects.

---

## Features

- 🖋️ **Customizable 3D Text**: Adjust font size, extrusion depth, color, and more.
- 🔄 **Flexible Curvature**: Control radius, offset, and letter spacing.
- ✨ **Material Customization**: Fine-tune roughness and metallic properties.
- 📐 **Easy-to-Use API**: Minimal configuration for powerful results.

---

## Installation

### Swift Package Manager

Add `VisionTextArc` to your project using the Swift Package Manager:

1. Open your project in Xcode.
2. Navigate to **File > Add Packages...**.
3. Enter the repository URL: https://github.com/yourusername/VisionTextArc
4. Select the latest version and add the package.

---

## Getting Started

### Importing the Framework

```swift
import VisionTextArc

let textCurver = TextCurver.self

//Optional custom cnfiguration. More in the documentation
let configuration = TextCurver.Configuration(
    fontSize: 0.15,
    extrusionDepth: 0.1,
    color: .red,
    roughness: 0.5,
    isMetallic: true,
    radius: 4.0,
    offset: .pi / 4,
    letterPadding: 0.05
)

let curvedTextEntity = textCurver.curveText("Custom Text", configuration: configuration)
```

Here is a screenshot of what can be done:

![Simulator Screenshot - Apple Vision Pro - 2024-11-18 at 17 18 37](https://github.com/user-attachments/assets/157bc3ce-d082-4e95-ab96-40981d6bcb0a)

