/// an operator which checks whether two arrays are equivalnet in the sense that they contain exactly the same elements regardless of their order
infix operator ≡: ComparisonPrecedence

func ≡ <ElementType:Equatable> (first: Array<ElementType>, second: Array<ElementType>) -> Bool {
    guard first.count == second.count else { return false }
    for element in first {
        guard second.contains(where: { $0 == element }) else { return false }
    }
    return true
}

