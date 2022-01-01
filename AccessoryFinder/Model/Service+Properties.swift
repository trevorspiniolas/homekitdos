/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Computed service properties.
*/

import HomeKit

extension HMService {
    
    /// The service name with "Service" at the end.
    var displayName: String {
        var name = localizedDescription
        if !name.hasSuffix("Service") {
            name += " Service"
        }
        return name
    }
    
    /// Enables or disables notifications of all the service's characteristics that can be enabled.
    /// - Tag: enableNotifications
    func enableNotifications(_ enabled: Bool) {
        for characteristic in characteristics
            where characteristic.properties.contains(HMCharacteristicPropertySupportsEventNotification) {
            
            characteristic.enableNotification(enabled) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
