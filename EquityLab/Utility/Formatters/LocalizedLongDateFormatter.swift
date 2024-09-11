
import UIKit

class LocalizedLongDateFormatter: DateFormatter {
    static let shared = LocalizedLongDateFormatter()
    
    private override init() {
        super.init()
        self.locale = Locale.current
        self.dateStyle = .long
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
