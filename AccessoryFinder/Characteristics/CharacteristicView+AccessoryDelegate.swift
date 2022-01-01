/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The accessory delegate for the service view controller.
*/

import HomeKit

extension CharacteristicView: HMAccessoryDelegate {
    /// Registers as being interested in receiving accessory delegate callbacks.
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
            HomeStore.shared.removeAccessoryDelegate(self)
        } else {
            HomeStore.shared.addAccessoryDelegate(self)
        }
    }
    
    /// Handles characteristic value updates.
    func accessory(_ accessory: HMAccessory, service: HMService, didUpdateValueFor characteristic: HMCharacteristic) {
        guard characteristic == self.characteristic else { return }
        
        reloadDisplayData()
        
        // Find the relevant cell.
        let indexPath = IndexPath(row: 1, section: Sections.value.rawValue)
        let cell = tableView.cellForRow(at: indexPath)
        
        // Put in the new value.
        let (_, detail) = value[indexPath.row]
        cell?.detailTextLabel?.text = detail
    }
}
