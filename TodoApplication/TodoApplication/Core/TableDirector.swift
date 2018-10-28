import Foundation
import UIKit

protocol TableDirector: class, UITableViewDelegate, UITableViewDataSource {
    func reload()
}