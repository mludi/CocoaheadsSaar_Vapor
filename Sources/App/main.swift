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



drop.run()
