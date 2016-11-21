import Vapor
import Fluent

extension Model {
    static func paginated(limit inLimit: Int = 10, page inPage: Int = 1, description inDescription: String = "data") -> [JSON]? {
        guard let total = try? self.all().count else { return nil }
        let offset = inLimit * (inPage - 1)
        guard let query = try? self.query().makeQuery() else { return nil }
        query.limit = Limit(count: inLimit, offset: offset)
        guard let allItems = try? query.all() else { return nil }
        let totalPages = (total + inLimit - 1) / inLimit
        guard let theJsonObject = try? JSON(node:[
            inDescription: Node(node: allItems.map { try $0.makeJSON() }),
            "current_page": inPage,
            "total_pages": totalPages,
            "per_page": inLimit,
            "total": total
        ]) else { return nil }
        return [theJsonObject]
    }
}
