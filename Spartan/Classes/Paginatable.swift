
import ObjectMapper

public protocol Paginatable: Mappable {
    static var pluralRoot: String { get }
}
