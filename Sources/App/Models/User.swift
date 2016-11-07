import Vapor
import Fluent
import Foundation

// MARK: Model

struct User: Model {
    var id: Node?
    var username: String?
    var createdAt: String?
    var updatedAt: String?
    
    // used by fluent internally
    var exists: Bool = false
}

// MARK: NodeConvertible

extension User: NodeConvertible {
    init(node: Node, in context: Context) throws {
        id = node["id"]
        username = node["username"]?.string
        createdAt = Date().current()
        updatedAt = Date().current()
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node.init(node:
            [
                "id": id,
                "username": username,
                "created_at": createdAt,
                "updated_at": updatedAt
            ]
        )
    }
    
    func makeJSON() throws -> JSON {
        let posts = try self.posts().all()
        return try JSON(node: [
            "id": id,
            "username": username,
            "created_at": createdAt,
            "updated_at": updatedAt,
            "posts": Node(node: posts)
            ]
        )
    }
    
}


// MARK: Database Preparations

extension User: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create("users", closure: { users in
            users.id()
            users.string("username")
            users.string("created_at")
            users.string("updated_at")
        })
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("users")
    }
}

// MARK: Relation

extension User {
    func posts() throws -> Children<Post> {
        return children()
    }
}

