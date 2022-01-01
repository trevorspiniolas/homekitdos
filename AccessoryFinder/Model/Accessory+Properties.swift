/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Computed accessory properties.
*/

import HomeKit

extension HMAccessory {
    
    /// A description for presentation in the UI.
    var displayName: String {
        let string = category.categoryType == HMAccessoryCategoryTypeOther ? "Accessory" : category.localizedDescription
        return (isBridged ? "Bridged " : "") + string
    }
}
