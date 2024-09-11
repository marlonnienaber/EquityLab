
import CoreData

public class ObservingFetchRequest<ResultType>: NSFetchRequest<NSFetchRequestResult> where ResultType: NSFetchRequestResult {
    
    public var observedRelationships: Set<String> = []
    
}
