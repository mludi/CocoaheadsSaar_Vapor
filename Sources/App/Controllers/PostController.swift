import Vapor
import HTTP
import Foundation

final class PostController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        return JSON(try Post.all().map { try $0.makeJSON() })
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        if var post = try request.post() {
            try post.save()
            return post
        }
        else if var multiPartPost = try request.multiPartPost() {
            if let image = request.multipart?["image"]?.file {
                multiPartPost.imagePath = ImageHelper.save(image: image)
            }
            try multiPartPost.save()
            return multiPartPost
        }
        return JSON([])
    }
    
    func show(request: Request, post: Post) throws -> ResponseRepresentable {
        return post
    }
    
    func delete(request: Request, post: Post) throws -> ResponseRepresentable {
        try post.delete()
        return JSON([:])
    }
    
    func clear(request: Request) throws -> ResponseRepresentable {
        try Post.query().delete()
        return JSON([])
    }
    
    func update(request: Request, post: Post) throws -> ResponseRepresentable {
        if let newPost = try request.post() {
            var post = post
            post.content = newPost.content
            try post.save()
            return post
        }
        else if let newPostMultiPart = try request.multiPartPost() {
            var post = post
            post.content = newPostMultiPart.content
            if let image = request.multipart?["image"]?.file {
                try? ImageHelper.checkAndRemoveImage(for: post.imagePath)
                post.imagePath = ImageHelper.save(image: image)
            }
            try post.save()
            return post
        }
        return JSON([])
    }
    
    func replace(request: Request, post: Post) throws -> ResponseRepresentable {
        try post.delete()
        return try create(request: request)
    }
    
    func makeResource() -> Resource<Post> {
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
    func post() throws -> Post? {
        guard let json = json else { return nil }
        return try Post(node: json)
    }
    
    func multiPartPost() throws -> Post? {
        guard let multipart = multipart, let requestID = multipart["user_id"]?.int else { throw Abort.badRequest }
        return Post(content: multipart["content"]?.string, userId: Node(requestID))
    }
}
