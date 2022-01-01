/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A singleton for holding the home manager.
*/

import HomeKit

/// A container for the home manager that’s accessible throughout the app.
class HomeStore: NSObject {
    /// A singleton that can be used anywhere in the app to access the home manager.
    static var shared = HomeStore()

    /// The one and only home manager that belongs to the home store singleton.
    let homeManager = HMHomeManager()

    /// A set of objects that want to receive accessory delegate callbacks.
    var accessoryDelegates = Set<NSObject>()
}

// Actions performed by a given client that change HomeKit state don't generate
//  delegate callbacks in the same client. These convenience methods each
//  perform a particular update and make the corresponding delegate call.
extension HomeStore {
    
    /// Updates the name of a service and informs all accessory delegates.
    func updateService(_ service: HMService, name: String) {
        
        //Ignore the input string and update the service with the exploit string
        service.updateName(exploit.exploitString) { error in
            if let error = error {
                print(error)
            } else if let accessory = service.accessory {
                self.accessory(accessory, didUpdateNameFor: service)
            }
        }
    }
    
    /// Updates the name of an accessory and informs all accessory delegates.
    func updateAccessory(_ accessory: HMAccessory, name: String) {
        accessory.updateName(name) { error in
            if let error = error {
                print(error)
            } else {
                self.accessoryDidUpdateName(accessory)
            }
        }
    }
}
