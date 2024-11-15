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
    public func curveText(text: String) -> Entity {
        
        let radius: Float = 3.0
        let yPosition: Float = 1.35
        let letterPadding: Float = 0.02
        
        var totalAngularSpan: Float = 0.0
        var entities: [ModelEntity] = []
        var currentAngle: Float = -1.93
        
        for char in text {
            let mesh = MeshResource.generateText(
                String(char),
                extrusionDepth: 0.03,
                font: .systemFont(ofSize: 0.1),
                containerFrame: .zero,
                alignment: .center,
                lineBreakMode: .byWordWrapping
            )
            let material = SimpleMaterial(color: UIColor(Color(.white)), isMetallic: false)
            
            let charEntity = ModelEntity(mesh: mesh, materials: [material])
            
            if let boundingBox = charEntity.model?.mesh.bounds {
                let characterWidth = boundingBox.extents.x
                let angleIncrement = (characterWidth + letterPadding) / radius
                totalAngularSpan += angleIncrement
                

                let x = radius * cos(currentAngle)
                let z = radius * sin(currentAngle) - 0.3
                print("x: \(x), z: \(z)")

                let lookAtUser = SIMD3(-x, 0, -z)
                charEntity.position = SIMD3(x, yPosition, z)
                charEntity.orientation = simd_quatf(from: SIMD3(0, 0, 1), to: lookAtUser)
                
                entities.append(charEntity)
                currentAngle += angleIncrement
                print("currentAngle: \(currentAngle)")
            }
        }
        
        let finalEntity = Entity()
        for text3D in entities {
            finalEntity.addChild(text3D)
        }
        
        print(finalEntity.position)
        print("totalAngularSpan: \(totalAngularSpan)")
        return finalEntity
    }
}
