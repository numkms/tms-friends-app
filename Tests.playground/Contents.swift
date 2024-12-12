import UIKit

struct Order {
    let id: String
    let items: [String]
}

func createOrder(
    items: [String]
) -> Order {
    var items = items
    items.append("Free macbook pro")
    return Order(
        id: UUID().uuidString,
        items: items
    )
}

