import Foundation
import UIKit

extension UINavigationController {

  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    navigationBar.topItem?.backButtonDisplayMode = .minimal
  }
}

extension Location {
    static var loadingItem: Location {
        let location = Location (id: -1,
                                 name: "Loading",
                                 type: "Loading",
                                 dimension: "Loading",
                                 residentsUrl: [],
                                 url: URL(string: "https://rickandmortyapi.com/api/location")!,
                                 created: Date(timeIntervalSinceNow: -10000))
        return location
    }
}
