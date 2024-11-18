//
//  GenerateCurvedText.swift
//  VisionTextArc
//
//  Created by Davide Castaldi on 15/11/24.
//

import SwiftUI
import RealityKit

public final class TextCurver: Sendable {
    
    public init () {}
    
    /// A configuration object for customizing 3D curved text.
    ///
    /// This structure contains parameters that control the appearance and layout of the text
    /// when displayed along a curve.
    ///
    /// - Properties:
    ///   - `fontSize`: The size of the font used for the text.
    ///   - `extrusionDepth`: The depth of the 3D extrusion for each character.
    ///   - `color`: The color of the text.
    ///   - `roughness`: The roughness of the material applied to the text surface.
    ///   - `isMetallic`: A boolean indicating if the text material is metallic.
    ///   - `radius`: The radius of the curve. Larger values make the text appear farther from the center.
    ///   - `offset`: The position of the text along the curve, in radians.
    ///   - `letterPadding`: The spacing between letters, allowing control over text density.
    ///
    /// - See also: `curveText(_:configuration:)` for how this configuration is applied.
    public struct Configuration {
        public var fontSize: CGFloat
        public var extrusionDepth: Float
        public var color: UIColor
        public var roughness: MaterialScalarParameter
        public var isMetallic: Bool
        public var radius: Float
        public var offset: Float
        public var letterPadding: Float
        
        public init(fontSize: CGFloat = 0.12, extrusionDepth: Float = 0.03, color: UIColor = .white, roughness: MaterialScalarParameter = 0, isMetallic: Bool = false, radius: Float = 3.0, offset: Float = 0.0, letterPadding: Float = 0.02) {
            self.fontSize = fontSize
            self.extrusionDepth = extrusionDepth
            self.color = color
            self.roughness = roughness
            self.isMetallic = isMetallic
            self.radius = radius
            self.offset = offset
            self.letterPadding = letterPadding
        }
    }
    
    /// Generates 3D curved text with customizable parameters.
    ///
    /// This function creates a 3D text effect by arranging the text along a curve.
    /// You can adjust the radius, offset, and letter spacing to control the appearance
    /// of the text in 3D space.
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
    ///     let foo = TextCurver()
    ///
    ///     let text = foo.curveText(string1)
    ///     let text2 = foo.curveText(string2, configuration: .init(color: .green, roughness: 1.0, isMetallic: true))
    ///     let text3 = foo.curveText(string3, configuration: .init(offset: -.pi / 8))
    ///     let text4 = foo.curveText(string4, configuration: .init(extrusionDepth: 0.15, radius: 4.0))
    ///     let text5 = foo.curveText(string5, configuration: .init(fontSize: 0.15, letterPadding: 0.05))
    ///
    public func curveText(_ text: String, configuration: Configuration = .init()) -> Entity {
        
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
                font: .systemFont(ofSize: configuration.fontSize),
                containerFrame: .zero,
                alignment: .center,
                lineBreakMode: .byCharWrapping
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
