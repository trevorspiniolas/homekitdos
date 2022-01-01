/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The accessory delegate for the accessory view controller.
*/

import HomeKit

extension AccessoryView: HMAccessoryDelegate {
    func accessoryDidUpdateName(_ accessory: HMAccessory) {
        guard accessory.uniqueIdentifier == self.accessory?.uniqueIdentifier else { return }
        reloadDisplayData()
        
        tableView.reloadSections(IndexSet([Sections.properties.rawValue]), with: .fade)
    }
    
    func accessoryDidUpdateReachability(_ accessory: HMAccessory) {
        guard accessory.uniqueIdentifier == self.accessory?.uniqueIdentifier else { return }
        reloadDisplayData()
        
        identifyButton.isEnabled = accessory.isReachable && accessory.supportsIdentify
        tableView.reloadSections(IndexSet([Sections.properties.rawValue]), with: .fade)
    }
    
    func accessoryDidUpdateServices(_ accessory: HMAccessory) {
        guard accessory.uniqueIdentifier == self.accessory?.uniqueIdentifier else { return }
        reloadDisplayData()
        
        tableView.reloadSections(IndexSet([Sections.hiddenServices.rawValue,
                                           Sections.interactiveServices.rawValue]), with: .fade)
    }
    
    func accessory(_ accessory: HMAccessory, didUpdateNameFor service: HMService) {
        guard accessory.uniqueIdentifier == self.accessory?.uniqueIdentifier else { return }
        
        reloadDisplayData()
        
        var index = hiddenServices.firstIndex(of: service)
        var section = Sections.hiddenServices
        if index == nil {
            index = interactiveServices.firstIndex(of: service)
            section = Sections.interactiveServices
        }
        
        guard let row = index else { return }
        tableView.reloadRows(at: [IndexPath(row: row, section: section.rawValue)], with: .fade)
    }
}
