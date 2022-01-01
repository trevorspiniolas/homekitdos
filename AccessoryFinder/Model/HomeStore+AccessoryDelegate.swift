/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A central hub for accessory delegates.
*/

import HomeKit

extension HomeStore {
    /// Registers an object as an accessory delegate.
    /// - Tag: addAccessoryDelegate
    func addAccessoryDelegate(_ delegate: NSObject) {
        accessoryDelegates.insert(delegate)
    }
    
    /// Deregisters a particular accessory delegate.
    func removeAccessoryDelegate(_ delegate: NSObject) {
        accessoryDelegates.remove(delegate)
    }
    
    /// Deregisters all accessory delegates.
    func removeAllAccessoryDelegates() {
        accessoryDelegates.removeAll()
    }
}

extension HomeStore: HMAccessoryDelegate {
    
    // The home store's only interest in the accessory updates is distributing them
    //  to the objects that have registered as accessory delegates. Each of these
    //  methods therefore simply passes along the call to all the items in the set,
    //  after first ensuring that the item is in fact an accessory delegate.
    
    func accessory(_ accessory: HMAccessory, didUpdateNameFor service: HMService) {
        accessoryDelegates.forEach {
            guard let delegate = $0 as? HMAccessoryDelegate else { return }
            delegate.accessory?(accessory, didUpdateNameFor: service)
        }
    }
    
    func accessoryDidUpdateReachability(_ accessory: HMAccessory) {
        accessoryDelegates.forEach {
            guard let delegate = $0 as? HMAccessoryDelegate else { return }
            delegate.accessoryDidUpdateReachability?(accessory)
        }
    }
    
    func accessoryDidUpdateName(_ accessory: HMAccessory) {
        accessoryDelegates.forEach {
            guard let delegate = $0 as? HMAccessoryDelegate else { return }
            delegate.accessoryDidUpdateName?(accessory)
        }
    }
    
    func accessoryDidUpdateServices(_ accessory: HMAccessory) {
        accessoryDelegates.forEach {
            guard let delegate = $0 as? HMAccessoryDelegate else { return }
            delegate.accessoryDidUpdateServices?(accessory)
        }
    }
    
    func accessory(_ accessory: HMAccessory, service: HMService, didUpdateValueFor characteristic: HMCharacteristic) {
        accessoryDelegates.forEach {
            guard let delegate = $0 as? HMAccessoryDelegate else { return }
            delegate.accessory?(accessory, service: service, didUpdateValueFor: characteristic)
        }
    }
}

