/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A table cell that summarizes one accessory.
*/

import UIKit
import HomeKit

class AccessoryCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var unresponsiveLabel: UILabel!
    
    /// The characteristic that this cell displays.
    var accessory: HMAccessory? {
        
        // Updates the UI to correspond to the new accessory.
        didSet {
            
            // A cell with no characteristic shows as empty.
            guard let accessory = accessory else {
                nameLabel.text = nil
                typeLabel.text = nil
                unresponsiveLabel.isHidden = true
                return
            }
            
            nameLabel.text = accessory.name
            typeLabel.text = accessory.displayName
            unresponsiveLabel.layer.cornerRadius = 10
            unresponsiveLabel.isHidden = accessory.isReachable
        }
    }
    
    /// The property to display as the subtitle in the cell.
    var subtitleProperty: HomeView.GroupKey = .category {
        didSet {
            typeLabel.text = subtitleProperty == .room ? accessory?.room?.name : accessory?.displayName
        }
    }
}
