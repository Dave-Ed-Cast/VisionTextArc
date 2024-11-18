//
//  GenerateCurvedText.swift
//  VisionTextArc
//
//  Created by Davide Castaldi on 15/11/24.
//

import SwiftUI
import RealityKit

public class TextCurver {
    
    public init () {}
    
    /// Generates 3D curved text using the `generateText` function.
    ///
    /// - Parameters:
    ///   - text: The text to display
    ///   - radius: The radius of the curve. The higher, the more distant the text
    /// - Returns: Returns a model entity to use
    public func curveText(text: String, radius: Float = 3.0, offset: Float = 0.0) -> Entity {
        let letterPadding: Float = 0.02
        let extrusionDepth: Float = 0.03
        let fontSize: CGFloat = 0.12
        let baseMaterial = SimpleMaterial(color: .white, isMetallic: false)
        
        var totalAngularSpan: Float = 0.0
        var charEntities: [(entity: ModelEntity, width: Float)] = []
        
        for char in text {
            let mesh = MeshResource.generateText(
                String(char),
                extrusionDepth: extrusionDepth,
                font: .systemFont(ofSize: fontSize),
                containerFrame: .zero,
                alignment: .center,
                lineBreakMode: .byCharWrapping
            )
            
            let charEntity = ModelEntity(mesh: mesh, materials: [baseMaterial])
            if let boundingBox = charEntity.model?.mesh.bounds {
                let characterWidth = boundingBox.extents.x
                let angleIncrement = (characterWidth + letterPadding) / radius
                totalAngularSpan += angleIncrement
                charEntities.append((entity: charEntity, width: characterWidth))
            }
        }
        
        var currentAngle: Float = -totalAngularSpan / 2.0 + offset
        
        let finalEntity = Entity()
        for (charEntity, characterWidth) in charEntities {
            let angleIncrement = (characterWidth + letterPadding) / radius
            
            let x = radius * sin(currentAngle)
            let z = -radius * cos(currentAngle)
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
