import Vapor
import Fluent

extension Model {
    static func paginated(count inCount: Int = 10, offset inOffset: Int = 0) -> [Self] {
        guard let query = try? self.query().makeQuery() else { fatalError() }
        query.limit = Limit(count: inCount, offset: inOffset)
        guard let result = try? query.all() else { fatalError() }
        //        guard let count = try? self.all().count else { fatalError() }
        
        
        return result
    }
    
    
}
