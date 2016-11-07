import Vapor
import Fluent
import Foundation

// MARK: - Model

struct Post: Model {
    var id: Node?
    var content: String?
    var imagePath: String?
    var userId: Node?
    var createdAt: String?
    var updatedAt: String?
    
    // used by fluent internally
    var exists: Bool = false
    
}

// MARK: - NodeConvertible

extension Post: NodeConvertible {
    
    init(node: Node, in context: Context) throws {
        id = node["id"]
        content = node["content"]?.string
        userId = node["user_id"]
        imagePath = node["image_path"]?.string ?? ""
        createdAt = Date().current()
        updatedAt = Date().current()
    }
    
    init(content inContent: String?, userId inUserId: Node?) {
        content = inContent
        userId = inUserId
        imagePath = ""
        createdAt = Date().current()
        updatedAt = Date().current()
    }
    func makeNode(context: Context) throws -> Node {
        return try Node.init(node: [
            "id": id,
            "content": content,
            "user_id": userId,
            "image_path": imagePath,
            "created_at": createdAt,
            "updated_at": updatedAt
            ]
        )
    }
    
    func makeJSON() throws -> JSON {
        let user = try self.user().first()
        return try JSON(node: [
            "id": id,
            "content": content,
            "created_at": createdAt,
            "updated_at": updatedAt,
            "image_path": imagePath,
            "user": Node(node: user)
            ]
        )
        
    }
}

// MARK: - Database Preparations

extension Post: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create("posts") { posts in
            posts.id()
            posts.string("content")
            posts.string("created_at")
            posts.string("updated_at")
            posts.string("image_path")
            posts.parent(User.self, optional: false)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("posts")
    }
}


// MARK: - Relation

extension Post {
    func user() throws -> Parent<User> {
        return try parent(userId)
    }
}
