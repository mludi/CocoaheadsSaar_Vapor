import Vapor
import Foundation

struct ImageHelper {
    fileprivate static func imagePath(imageName inImageName: String) -> (imagePath: String, savePath: String) {
        let imagePath = "images/api/\(NSUUID().uuidString).\(inImageName)".removeWhitespace()
        let savePath = drop.workDir + "Public/" + imagePath
        return (imagePath, savePath)
    }
    
    static func checkAndRemoveImage(for inImagePath: String?) throws {
        if let imagePath = inImagePath {
            if imagePath.characters.count > 0 {
                let savePath = drop.workDir + "Public/" + imagePath
                try FileManager.default.removeItem(atPath: savePath)
            }
        }
    }
    
    static func save(image inImage: Multipart.File) -> String {
        guard let imageName = inImage.name else { fatalError("Image MUST have a name") }
        let result =  ImageHelper.imagePath(imageName: imageName)
        FileManager.default.createFile(atPath: result.savePath, contents: Data(bytes: inImage.data), attributes: nil)
        return result.imagePath
    }
}
