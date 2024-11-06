/// an operator which checks whether two arrays are equivalnet in the sense that they contain exactly the same elements regardless of their order
infix operator ≡: ComparisonPrecedence

func ≡ <ElementType:Equatable> (first: Array<ElementType>, second: Array<ElementType>) -> Bool {
    guard first.count == second.count else { return false }
    for element in first {
        guard second.contains(where: { $0 == element }) else { return false }
    }
    return true
}

func ≡ <FirstElementType: Equatable, SecondElementType: Equatable>(first: [(FirstElementType, SecondElementType)], second: [(FirstElementType, SecondElementType)]) -> Bool {
    guard first.count == second.count else { return false }
    for element in first {
        guard second.contains(where: { $0 == element }) else { return false }
    }
    return true
}

/// a function which checks whether two arrays are equivalent in the sense that they contain equivalent elements regardless of their order. Equivalence of elements is defined
/// by equality of the properties passed via the KeyPath array
func checkEquivalence<ElementType, PropertyType: Equatable>(
    of first: [ElementType],
    and second: [ElementType],
    by keyPaths: [KeyPath<ElementType, PropertyType>]
) -> Bool {
    guard first.count == second.count else { return false }
    for element in first {
        if !second.containsEquivalentElement(to: element, by: keyPaths) {
            return false
        }
    }
    return true
}

fileprivate extension Array {
    func containsEquivalentElement<PropertyType: Equatable>(to element: Element, by keyPaths: [KeyPath<Element, PropertyType>]) -> Bool {
        self.contains(where: { otherElement in
            for keyPath in keyPaths {
                if element[keyPath: keyPath] != otherElement[keyPath: keyPath] {
                    return false
                }
            }
            return true
        })
    }
}



extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

