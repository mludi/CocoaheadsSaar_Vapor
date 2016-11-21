import Vapor
import VaporMySQL

let drop = Droplet()

try drop.addProvider(VaporMySQL.Provider)
drop.preparations += User.self
drop.preparations += Post.self
drop.group("api") { api in
    api.group("v1") { v1 in
        v1.resource("posts", PostController())
        v1.resource("users", UserController())
    }
}
drop.get("paginated") { request in
    guard let page = request.data["page"]?.int else {
        return try JSON(Post.all().makeNode())
    }
    let limit = request.data["limit"]?.int ?? 10
    guard let json = Post.paginated(limit: limit, page: page, description: "posts") else {
        throw Abort.badRequest
    }
    return try JSON(node: json)
}

drop.run()
