//
//  GenerateCurvedText.swift
//  VisionTextArc
//
//  Created by Davide Castaldi on 15/11/24.
//

import SwiftUI
import RealityKit

public class GenerateCurvedText {
    
    public init () {}
    
    
    
    /// Generates 3D curved text using the `generateText` function.
    ///
    /// - Parameters:
    ///   - text: The text to cut into single characters
    /// - Returns: Returns a model entity to use
    public func curveText(text: String, radius: Float = 4.0) -> Entity {
        
        let letterPadding: Float = 0.02
        let extrusionDepth: Float = 0.03
        let fontSize: CGFloat = 0.12
        let baseMaterial = SimpleMaterial(color: .white, isMetallic: false)
        
        var totalAngularSpan: Float = 0.0
        var entities: [ModelEntity] = []
        var currentAngle: Float = -radius / 1.5
        
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
                
                let x = radius * cos(currentAngle)
                let z = radius * sin(currentAngle)
                let lookAtUser = SIMD3(-x, 0, -z)
                
                charEntity.position = SIMD3(x, 0, z)
                charEntity.orientation = simd_quatf(from: SIMD3(0, 0, 1), to: lookAtUser)
                
                entities.append(charEntity)
                currentAngle += angleIncrement
            }
        }
        
        let finalEntity = Entity()
        for text3D in entities {
            finalEntity.addChild(text3D)
        }
        
        return finalEntity
    }
}
