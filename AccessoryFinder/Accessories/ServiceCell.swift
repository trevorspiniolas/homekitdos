/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A table cell that summarizes one service.
*/

import UIKit
import HomeKit

class ServiceCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    
    /// The service that this header view displays.
    var service: HMService? {
        didSet {
            if let service = service {
                nameLabel.text = service.name
                typeLabel.text = service.displayName
                serviceLabel.isHidden = !service.isPrimaryService
            } else {
                nameLabel.text = nil
                typeLabel.text = nil
                serviceLabel.isHidden = true
            }
        }
    }
}
