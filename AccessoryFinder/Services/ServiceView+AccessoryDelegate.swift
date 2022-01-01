/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The accessory delegate for the service view controller.
*/

import HomeKit

extension ServiceView: HMAccessoryDelegate {
    /// Registers as being interested in receiving accessory delegate callbacks.
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
            HomeStore.shared.removeAccessoryDelegate(self)
        } else {
            HomeStore.shared.addAccessoryDelegate(self)
        }
    }
    
    /// Handles service name changes.
    func accessory(_ accessory: HMAccessory, didUpdateNameFor service: HMService) {
        guard service == self.service else { return }
        
        reloadDisplayData()
        tableView.reloadSections([Sections.properties.rawValue], with: .fade)
    }
    
    /// Handles characteristic updates.
    func accessory(_ accessory: HMAccessory, service: HMService, didUpdateValueFor characteristic: HMCharacteristic) {
        guard service == self.service else { return }

        // Find the cell that displays this characteristic.
        guard let row = characteristics.firstIndex(of: characteristic),
            let cell = tableView.cellForRow(at: IndexPath(row: row, section: Sections.characteristics.rawValue)) as? CharacteristicCell
            else { return }
        
        // Tell the cell to refresh. It already has a handle on the characteristic.
        cell.redrawValueLabel()
        cell.redrawControls(animated: true)
    }
}
