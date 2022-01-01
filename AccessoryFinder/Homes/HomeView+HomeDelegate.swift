/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The home delegate for the home view controller.
*/

import HomeKit

/// Handle the home delegate callbacks.
extension HomeView: HMHomeDelegate {
    
    // For all of these, make sure the home sending the message is the currently
    // displayed home. If so, refresh the display data and redraw the table.
    // Omit delegate methods that tell us about items that don't affect
    // our particular user interface.
    
    func home(_ home: HMHome, didAdd room: HMRoom) {
        guard home == self.home else { return }
        resetDisplay(for: home)
    }

    func home(_ home: HMHome, didRemove room: HMRoom) {
        guard home == self.home else { return }
        resetDisplay(for: home)
    }
    
    func home(_ home: HMHome, didAdd accessory: HMAccessory) {
        guard home == self.home else { return }
        resetDisplay(for: home)
        
        // Make sure the new accessory generates callbacks to the home store.
        accessory.delegate = HomeStore.shared
    }

    func home(_ home: HMHome, didUpdateNameFor room: HMRoom) {
        guard home == self.home else { return }
        resetDisplay(for: home)
    }
    
    func home(_ home: HMHome, didRemove accessory: HMAccessory) {
        guard home == self.home else { return }
        resetDisplay(for: home)
    }
    
    func home(_ home: HMHome, didUpdate room: HMRoom, for accessory: HMAccessory) {
        guard home == self.home else { return }
        resetDisplay(for: home)
    }
    
    func home(_ home: HMHome, didEncounterError error: Error, for accessory: HMAccessory) {
        print(error.localizedDescription)
        guard home == self.home else { return }
        resetDisplay(for: home)
    }
}
