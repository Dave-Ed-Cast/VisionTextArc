# VisionTextArc

![Swift](https://img.shields.io/badge/Swift-6-blue) ![Platform](https://img.shields.io/badge/Platform-visionOS-red) ![License](https://img.shields.io/badge/License-MIT-green)

`VisionTextArc` is a visionOS package library fully open source and free, that enables 3D curved text creation with customizable parameters, perfect for Apple Vision Pro apps. Built on RealityKit, it offers an intuitive API for generating stunning, immersive text effects with ease.

---

## Why is curved text needed in visionOS
Curved text enhances immersion by naturally integrating into 3D spaces. Imagine a mindfulness app where text elegantly follows the contours of a scene, now possible with VisionTextArc.

Designing curved text manually in Reality Composer Pro is tedious, in fact, you would d have to position each letter individually! With VisionTextArc, simply tweak a few parameters and let the package handle the rest.

---

## Features

- 🖋️ **Customizable 3D Text**: Adjust font, size, extrusion depth, color, and more.
- 🔄 **Flexible Curvature**: Control radius, offset, and letter spacing.
- ✨ **Material Customization**: Fine-tune roughness and metallic properties.
- 📐 **Easy-to-Use API**: Minimal configuration for powerful results.

---

## Installation

### Swift Package Manager

Add `VisionTextArc` to your project using the Swift Package Manager:

1. Open your project in Xcode.
2. Navigate to **File > Add Packages...**.
3. Enter the repository URL: [https://github.com/Dave-Ed-Cast/VisionTextArc](https://github.com/Dave-Ed-Cast/VisionTextArc)
4. Select the latest version and add the package.

---

## Getting Started

### Importing the Framework

```swift
import VisionTextArc

let vta = TextCurver.self

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

let curvedTextEntity = vta.curveText("Custom Text", configuration: configuration)
```

Here is a screenshot of what can be done:

![Simulator Screenshot - Apple Vision Pro - 2024-11-18 at 17 18 37](https://github.com/user-attachments/assets/157bc3ce-d082-4e95-ab96-40981d6bcb0a)

