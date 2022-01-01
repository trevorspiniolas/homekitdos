/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A table cell that summarizes one bridged accessory.
*/

import UIKit
import HomeKit

class BridgedAccessoryCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    
    /// The characteristic that this cell displays.
    var accessory: HMAccessory? {
        
        // Updates the UI when a new characteristic is set.
        didSet {
            
            // A cell with no characteristic shows as empty.
            guard let accessory = accessory else {
                roomLabel.text = nil
                nameLabel.text = nil
                return
            }
            
            roomLabel.text = accessory.room?.name
            nameLabel.text = accessory.name
        }
    }
}
