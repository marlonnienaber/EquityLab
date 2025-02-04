/// a Hashable tuple
struct Pair<FirstType:Hashable, SecondType:Hashable>: Hashable {
    let first: FirstType
    let second: SecondType
    
    init(_ first: FirstType, _ second: SecondType) {
        self.first = first
        self.second = second
    }
}
