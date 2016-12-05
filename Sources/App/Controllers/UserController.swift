import Vapor
import HTTP
import Fluent
import Foundation

final class UserController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        return JSON(try User.all().map {try $0.makeJSON() })
    }
    func create(request: Request) throws -> ResponseRepresentable {
        if let username = request.data["username"]?.string, let _ = try User.query().filter("username", username).first() {
            throw Abort.custom(status: .badRequest, message: "A user with name \(username) already exists")
        }
        var user = try request.user()
        try user.save()
        return user
    }
    
    func show(request: Request, user: User) throws -> ResponseRepresentable {
        return user
    }
    
    func delete(request: Request, user: User) throws -> ResponseRepresentable {
        try user.delete()
        return JSON([:])
    }
    
    func clear(request: Request) throws -> ResponseRepresentable {
        try User.query().delete()
        return JSON([])
    }
    
    func update(request: Request, user: User) throws -> ResponseRepresentable {
        let newUser = try request.user()
        var user = user
        user.username = newUser.username
        user.updatedAt = Date().current()
        try user.save()
        return user
    }
    
    func replace(request: Request, user: User) throws -> ResponseRepresentable {
        try user.delete()
        return try create(request: request)
    }
    
    func makeResource() -> Resource<User> {
        return Resource(
            index: index,
            store: create,
            show: show,
            replace: replace,
            modify: update,
            destroy: delete,
            clear: clear
        )
    }
}

extension Request {
    func user() throws -> User {
        guard let json = json else { throw Abort.badRequest }
        return try User(node: json)
    }
}
