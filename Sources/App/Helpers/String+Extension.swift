import Foundation

extension String {
    func replace(string:String, replacement:String) -> String {
        return String(characters.filter {$0 != " "})
    }
    
    func removeWhitespace() -> String {
        return replace(string: " ", replacement: "")
    }
}
