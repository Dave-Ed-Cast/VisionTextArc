/*
 Abstract:
 
 This Swift utility package generates customizable 3D curved text for AR/VR environments using RealityKit. It offers a Configuration struct for detailed styling, including font, material properties, curve radius, and animations. The curveText method arranges text along a curve with optional dynamic effects, enabling rich, immersive text displays in visionOS and iOS applications.
 
 As this has no further development so far, an enum is imperative to improve efficiency given their lightweith overhead, and the absence of depending methods that must be extended. Furthermore, there is no aim to create objects.
 */

import SwiftUI
import RealityKit

@MainActor
@available(visionOS 2.0, *, iOS 13.0, *)
public enum TextCurver: Sendable {
    
    /// A configuration object for customizing 3D curved text.
    ///
    /// This structure defines parameters for styling and positioning text along a 3D curve.
    /// It provides fine-grained control over text appearance, material properties, and layout.
    ///
    /// - ### Properties:
    ///   - `fontSize`: The size of the font used for rendering the text.
    ///   - `font`: The font resource type used for creating the text geometry.
    ///   - `extrusionDepth`: The depth of the 3D extrusion applied to each character, creating a volumetric effect.
    ///   - `color`: The color applied to the text material.
    ///   - `roughness`: The roughness of the text material's surface, affecting light scattering.
    ///   - `isMetallic`: A boolean value indicating whether the text material exhibits metallic properties.
    ///   - `radius`: The radius of the curve on which the text is laid out. Larger values position the text farther from the center of curvature.
    ///   - `offset`: The angular position of the text along the curve, measured in radians.
    ///   - `yPosition`: The Y-axis position of the text entity (vertical head movement axis).
    ///   - `letterPadding`: The spacing between consecutive letters, controlling text density along the curve.
    ///   - `containerFrame`: The 2D frame defining the text container size and positioning within the scene.
    ///   - `alignment`: The horizontal alignment of the text within its container (e.g., left, center, right).
    ///   - `lineBreakMode`: The strategy for handling line breaks, defining how text wraps within the container frame.
    ///   - `animationProvider`: The provider used in Reality Composer Pro, to create animation such as an Orbit
    ///
    /// - See also: `curveText(_:configuration:)` for how this configuration is applied.
    
    @MainActor
    public struct Configuration {
        
        /// Define how big the text should be.
        /// This value should range between 0 and 1 to provide correct sizes
        public var fontSize: CGFloat
        
        /// It allows to select fonts that are supported from Xcode
        /// Custom fonts are allowed as long as correctly imported.
        public var font: MeshResource.Font
        
        /// `extrusionDepth` defines how deep the text must be
        /// It is advised to not go farther than 1
        public var extrusionDepth: Float
        
        public var color: UIColor
        public var roughness: MaterialScalarParameter
        public var isMetallic: Bool
        
        ///`radius` is defined as the flat distance for the user.
        /// the curved text will start generate from this flat distance.
        public var radius: Float
        
        /// Indicates at which position of the curve the text must be
        /// it is advised to use radians or float, as degrees are still not supported.
        public var offset: Float
        
        /// This value define the y offset of the text
        public var yPosition: Float
        
        /// The distance between each character
        public var letterPadding: Float
        
        /// The invisible container of the text, like an invisible rectangle.
        public var containerFrame: CGRect
        
        public var alignment: CTTextAlignment
        public var lineBreakMode: CTLineBreakMode
        
        /// This is the value used for the animation.
        /// As of now onl `AnimationResource` is supported.
        public var animationProvider: ((ModelEntity, Transform) -> AnimationResource?)?
        
        /**
         Initializes a new `Configuration` instance.
         
         - Parameters
            - `fontSize`: Defines the size of the font used for rendering the text. Value should range between 0 and 1.
            - `font`: The font resource type used for creating the text geometry. Custom fonts must be imported.
            - `extrusionDepth`: The depth of the 3D extrusion applied to each character, creating a volumetric effect.
            - `color`: The color applied to the text material.
            - `roughness`: The roughness of the text material's surface, affecting light scattering.
            - `isMetallic`: Indicates whether the text material exhibits metallic properties.
            - `radius`: The radius of the curve on which the text is laid out. Larger values position the text farther from the center.
            - `offset`: The angular position of the text along the curve, measured in radians.
            - `yPosition`: The Y-axis position of the text entity (vertical head movement axis).
            - `letterPadding`: The spacing between consecutive letters, controlling text density along the curve.
            - `containerFrame`: The 2D frame defining the text container size and positioning within the scene.
            - `alignment`: The horizontal alignment of the text within its container (e.g., left, center, right).
            - `lineBreakMode`: The strategy for handling line breaks, defining how text wraps within the container frame.
            - `animationProvider`: A closure to provide animations for the text in Reality Composer Pro.
         **/
        
        public init(
            fontSize: CGFloat = 0.12,
            font: MeshResource.Font? = nil,
            extrusionDepth: Float = 0.03,
            color: UIColor = .white,
            roughness: MaterialScalarParameter = 0,
            isMetallic: Bool = false,
            radius: Float = 3.0,
            offset: Float = 0.0,
            yPosition: Float = .zero,
            letterPadding: Float = 0.02,
            containerFrame: CGRect = .zero,
            alignment: CTTextAlignment = .center,
            lineBreakMode: CTLineBreakMode = .byCharWrapping,
            animationProvider: ((ModelEntity, Transform) -> AnimationResource?)? = nil
        ) {
            
            self.fontSize = fontSize
            self.font = font ?? .systemFont(ofSize: fontSize)
            self.extrusionDepth = extrusionDepth
            self.color = color
            self.roughness = roughness
            self.isMetallic = isMetallic
            self.radius = max(radius, 0.01)
            self.offset = offset
            self.yPosition = yPosition
            self.letterPadding = max(letterPadding, 0)
            self.containerFrame = containerFrame
            self.alignment = alignment
            self.lineBreakMode = lineBreakMode
            self.animationProvider = animationProvider ?? nil
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
    ///     let text3 = foo.curveText(string4, configuration: .init(offset: -.pi / 2, radius: 4.0))
    ///
    /// The usual SwiftUI `withAnimation` is not supported, however, in RealityViews.
    /// For that reason use `AnimationResource`.
    ///
    /// Here is a simple example of how to use such structure:
    ///
    ///     let customOrbitAnimationProvider: (ModelEntity, Transform) -> AnimationResource? = { char, transform in
    ///         let orbit = OrbitAnimation(
    ///             name: "orbit_\(char.name)",
    ///             duration: 300,
    ///             axis: [0, 1, 0],
    ///             startTransform: transform,
    ///             spinClockwise: false,
    ///             orientToPath: true,
    ///             rotationCount: 5,
    ///             bindTarget: .transform
    ///         )
    ///         return try? AnimationResource.generate(with: orbit)
    ///     }
    ///
    ///     let text1 = foo.curveText(string1, configuration: .init(animationProvider: customOrbitAnimationProvider))
    ///
    @MainActor
    public static func curveText(_ text: String, configuration: Configuration = .init()) -> Entity {
        
        let material = configureMat(configuration)
        var characters: [(entity: ModelEntity, width: Float)] = []
        
        for char in text {
            if let charEntity = configureChar(char, config: configuration, mat: material) {
                characters.append(charEntity)
            }
        }
        
        let totalAngularSpan = calculateAngularSpan(
            chars: characters,
            letterPadding: configuration.letterPadding,
            radius: configuration.radius
        )
        
        let finalEntity = charactersPosition(
            characters,
            radius: configuration.radius,
            offset: configuration.offset,
            totalAngularSpan: totalAngularSpan,
            letterPadding: configuration.letterPadding,
            animationProvider: configuration.animationProvider
        )
        
        finalEntity.position.y = configuration.yPosition
        
        return finalEntity
    }
    
    /// Configuration of the material
    /// - Parameter config: The parameters from the user
    /// - Returns: The simple material with the configuration
    fileprivate static func configureMat(_ config: Configuration) -> SimpleMaterial {
        return SimpleMaterial(
            color: config.color,
            roughness: config.roughness,
            isMetallic: config.isMetallic
        )
    }
    
    /// Configuration of the 3D character
    /// - Parameters:
    ///   - char: The next character in line from the string
    ///   - config: The parameters from the user
    ///   - mat: The material built on top of user request
    /// - Returns: A 3D letter entity and its width as a float.
    fileprivate static func configureChar(
        _ char: Character,
        config: Configuration,
        mat: SimpleMaterial
    ) -> (entity: ModelEntity, width: Float)? {
        
        let mesh = MeshResource.generateText(
            String(char),
            extrusionDepth: config.extrusionDepth,
            font: config.font,
            containerFrame: config.containerFrame,
            alignment: config.alignment,
            lineBreakMode: config.lineBreakMode
        )
        
        let charEntity = ModelEntity(mesh: mesh, materials: [mat])
        guard let boundingBox = charEntity.model?.mesh.bounds else { return nil }
        
        let characterWidth = boundingBox.extents.x
        return (entity: charEntity, width: characterWidth)
    }
    
    /// Calculates the angular span between each 3D letter generated
    /// - Parameters:
    ///   - chars: The 3D letter entity and its width as a float.
    ///   - config: The parameters from the user
    ///   - mat: The material built on top of user request
    /// - Returns: Returns the total angular span value
    fileprivate static func calculateAngularSpan(
        chars: [(entity: ModelEntity, width: Float)],
        letterPadding: Float,
        radius: Float
    ) -> Float {
        
        return chars.reduce(0.0) { span, charEntity in
            span + (charEntity.width + letterPadding) / radius
        }
    }
    
    /// Calculates the angular span between each 3D letter generated
    /// - Parameters:
    ///   - chars: The array 3D letters entity and its width as a float.
    ///   - radius: The selected radius from the user
    ///   - offset: The selected offset from the user
    ///   - totalAngularSpan: The angular span derived from the generation of 3D letters
    ///   - letterPadding: The selected padding from the user
    ///   - animationProvider: The selected AnimationResource from the user
    /// - Returns: Returns the 3D string entity with all the parameters applied
    fileprivate static func charactersPosition(
        _ chars: [(entity: ModelEntity, width: Float)],
        radius: Float,
        offset: Float,
        totalAngularSpan: Float,
        letterPadding: Float,
        animationProvider: ((ModelEntity, Transform) -> AnimationResource?)?
    ) -> Entity {
        
        let finalEntity = Entity()
        var currentAngle: Float = -totalAngularSpan / 2.0 + offset
                
        for (char, characterWidth) in chars {
            let angleIncrement = (characterWidth + letterPadding) / radius
            
            let x = radius * sin(currentAngle)
            let z = -radius * cos(currentAngle)
            
            let lookAtUserNormalized = normalize(SIMD3(x, 0, z))
            
            char.orientation = simd_quatf(from: SIMD3(0, 0, -1), to: lookAtUserNormalized)
            char.position = SIMD3(x, 0, z)
            
            let charTransform = Transform(rotation: char.orientation, translation: char.position)
            
            if let animation = animationProvider?(char, charTransform) {
                char.playAnimation(animation)
            }
            
            finalEntity.addChild(char)
            currentAngle += angleIncrement
        }
        
        return finalEntity
    }
}
