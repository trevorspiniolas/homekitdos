/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The accessory delegate for the home view controller.
*/

import HomeKit

/// Handle the accessory delegate callbacks.
extension HomeView: HMAccessoryDelegate {
    func accessoryDidUpdateName(_ accessory: HMAccessory) {
        reloadDisplayData(for: home)
        updateCell(with: accessory)
    }
    
    func accessoryDidUpdateReachability(_ accessory: HMAccessory) {
        reloadDisplayData(for: home)
        updateCell(with: accessory)
    }
    
    // Redraws the cell holding the given accessory.
    func updateCell(with accessory: HMAccessory) {
        for section in 0..<grouping.count {
            if let row = grouping[section].accessories.firstIndex(of: accessory) {
                tableView.reloadRows(at: [IndexPath(row: row, section: section)], with: .fade)
                return
            }
        }
    }
}
