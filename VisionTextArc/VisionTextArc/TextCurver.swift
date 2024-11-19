//
//  TextCurver.swift
//  VisionTextArc
//
//  Created by Davide Castaldi on 15/11/24.
//

import SwiftUI
import RealityKit

public enum TextCurver: Sendable {
        
    /// A configuration object for customizing 3D curved text.
    ///
    /// This structure defines parameters for styling and positioning text along a 3D curve.
    /// It provides fine-grained control over text appearance, material properties, and layout.
    ///
    /// - Properties:
    ///   - `fontSize`: The size of the font used for rendering the text.
    ///   - `font`: The font resource used for creating the text geometry.
    ///   - `extrusionDepth`: The depth of the 3D extrusion applied to each character, creating a volumetric effect.
    ///   - `color`: The color applied to the text material.
    ///   - `roughness`: The roughness of the text material's surface, affecting light scattering.
    ///   - `isMetallic`: A boolean value indicating whether the text material exhibits metallic properties.
    ///   - `radius`: The radius of the curve on which the text is laid out. Larger values position the text farther from the center of curvature.
    ///   - `offset`: The angular position of the text along the curve, measured in radians.
    ///   - `letterPadding`: The spacing between consecutive letters, controlling text density along the curve.
    ///   - `containerFrame`: The 2D frame defining the text container size and positioning within the scene.
    ///   - `alignment`: The horizontal alignment of the text within its container (e.g., left, center, right).
    ///   - `lineBreakMode`: The strategy for handling line breaks, defining how text wraps within the container frame.
    ///
    /// - See also: `curveText(_:configuration:)` for how this configuration is applied.
    public struct Configuration {
        public var fontSize: CGFloat
        public var font: MeshResource.Font
        public var extrusionDepth: Float
        public var color: UIColor
        public var roughness: MaterialScalarParameter
        public var isMetallic: Bool
        public var radius: Float
        public var offset: Float
        public var letterPadding: Float
        public var containerFrame: CGRect
        public var alignment: CTTextAlignment
        public var lineBreakMode: CTLineBreakMode
        
        
        public init(
            fontSize: CGFloat = 0.12,
            font: MeshResource.Font? = nil,
            extrusionDepth: Float = 0.03,
            color: UIColor = .white,
            roughness: MaterialScalarParameter = 0,
            isMetallic: Bool = false,
            radius: Float = 3.0,
            offset: Float = 0.0,
            letterPadding: Float = 0.02,
            containerFrame: CGRect? = nil,
            alignment: CTTextAlignment? = nil,
            lineBreakMode: CTLineBreakMode? = nil
        ) {
            
            self.fontSize = fontSize
            self.font = font ?? .systemFont(ofSize: fontSize)
            self.extrusionDepth = extrusionDepth
            self.color = color
            self.roughness = roughness
            self.isMetallic = isMetallic
            self.radius = radius
            self.offset = offset
            self.letterPadding = letterPadding
            self.containerFrame = containerFrame ?? .zero
            self.alignment = alignment ?? .center
            self.lineBreakMode = lineBreakMode ?? .byCharWrapping
        }
    }
    
    /// Generates 3D curved text with customizable parameters.
    ///
    /// This function creates a 3D text effect by arranging the text along a curve.
    /// You can adjust many different parameters of the text in 3D space.
    ///
    /// - Parameters:
    ///   - text: The text to display.
    ///   - configuration: An object specifying the parameters of the text on the curve.
    ///
    /// - Returns:
    ///   An `Entity` instance that represents the generated 3D text, ready for display.
    /// - See also: `Configuration` for detailed control over text appearance and layout.
    ///
    /// The following example is a simple how to use:
    ///
    ///     let foo = TextCurver.self
    ///
    ///     let text1 = foo.curveText(string1)
    ///     let text2 = foo.curveText(string2, configuration: .init(font: UIFont(name: "Marion", size: 0.2)))
    ///     let text3 = foo.curveText(string3, configuration: .init(color: .green, roughness: 1.0, isMetallic: true))
    ///     let text4 = foo.curveText(string4, configuration: .init(offset: -.pi / 8))
    ///     let text5 = foo.curveText(string5, configuration: .init(extrusionDepth: 0.15, radius: 4.0))
    ///     let text6 = foo.curveText(string6, configuration: .init(fontSize: 0.15, letterPadding: 0.05))
    ///
    public static func curveText(_ text: String, configuration: Configuration = .init()) -> Entity {
        
        let baseMaterial = SimpleMaterial(
            color: configuration.color,
            roughness: configuration.roughness,
            isMetallic: configuration.isMetallic
        )
        
        var totalAngularSpan: Float = 0.0
        var charEntities: [(entity: ModelEntity, width: Float)] = []
        
        for char in text {
            let mesh = MeshResource.generateText(
                String(char),
                extrusionDepth: configuration.extrusionDepth,
                font: configuration.font,
                containerFrame: configuration.containerFrame,
                alignment: configuration.alignment,
                lineBreakMode: configuration.lineBreakMode
            )
            
            let charEntity = ModelEntity(mesh: mesh, materials: [baseMaterial])
            
            if let boundingBox = charEntity.model?.mesh.bounds {
                let characterWidth = boundingBox.extents.x
                let angleIncrement = (characterWidth + configuration.letterPadding) / configuration.radius
                totalAngularSpan += angleIncrement
                charEntities.append((entity: charEntity, width: characterWidth))
            }
        }
        
        var currentAngle: Float = -totalAngularSpan / 2.0 + configuration.offset
        
        let finalEntity = Entity()
        for (charEntity, characterWidth) in charEntities {
            let angleIncrement = (characterWidth + configuration.letterPadding) / configuration.radius
            
            let x = configuration.radius * sin(currentAngle)
            let z = -configuration.radius * cos(currentAngle)
            
            let lookAtUser = SIMD3(x, 0, z)
            let lookAtUserNormalized = normalize(lookAtUser)
            
            charEntity.orientation = simd_quatf(from: SIMD3(0, 0, -1), to: lookAtUserNormalized)
            
            charEntity.position = SIMD3(x, 0, z)
            
            finalEntity.addChild(charEntity)
            currentAngle += angleIncrement
        }
        
        return finalEntity
    }
}
