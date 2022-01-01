/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Details about a given characteristic.
*/

import UIKit
import HomeKit

/// A view presenting all the details of a single characteristic.
/// - Tag: CharacteristicView
class CharacteristicView: UITableViewController {
    
    /// The characteristic to display.
    var characteristic: HMCharacteristic? {
        didSet {
            reloadDisplayData()
        }
    }

    /// The set of value fields.
    var value = [(String, String?)]()
    
    /// The set of properties to display.
    var properties = [(String, String?)]()
    
    /// Gets the display data from HomeKit.
    func reloadDisplayData() {
        title = "Characteristic"
        value = []
        properties = []
        
        guard let characteristic = characteristic else { return }
        
        title = characteristic.displayName
        
        value = [
            ("Format", characteristic.metadata?.format ?? "—"),
            ("Value", characteristic.formattedValueString)
        ]
        if let units = characteristic.metadata?.units {
            value.append(("Units", units))
        }
        if let maximum = characteristic.metadata?.maximumValue {
            value.append(("Maximum", maximum.stringValue))
        }
        if let minimum = characteristic.metadata?.minimumValue {
            value.append(("Minimum", minimum.stringValue))
        }
        if let step = characteristic.metadata?.stepValue {
            value.append(("Step", step.stringValue))
        }

        properties = [
            ("Description", characteristic.metadata?.manufacturerDescription ?? "—"),
            ("Identifier", characteristic.uniqueIdentifier.uuidString),
            ("Type", characteristic.localizedDescription),
            ("Type ID", characteristic.characteristicType),
            ("Readable", characteristic.properties.contains(HMCharacteristicPropertyReadable).string),
            ("Writable", characteristic.properties.contains(HMCharacteristicPropertyWritable).string),
            ("Supports Notifications",
             characteristic.properties.contains(HMCharacteristicPropertySupportsEventNotification).string),
            ("Hidden", characteristic.properties.contains(HMCharacteristicPropertyHidden).string),
            ("Notifications Enabled", characteristic.isNotificationEnabled.string)
        ]
    }
    
    // MARK: - Table View

    /// The table sections we support. Reorder here to control the order in the UI.
    enum Sections: Int, CaseIterable {
        case properties, value
    }
    
    /// Returns the number of services that this accessory has.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    /// Returns the number of characteristics for a given service.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionName = Sections(rawValue: section) else { return 0 }
        
        switch sectionName {
        case .properties:   return properties.count
        case .value:        return value.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionName = Sections(rawValue: section) else { return nil }
        
        switch sectionName {
        case .properties:   return "Characteristic Properties"
        case .value:        return "Current Value"
        }
    }
    
    /// Returns the configured cell for the given row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionName = Sections(rawValue: indexPath.section) else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyCell", for: indexPath)
        switch sectionName {
        case .properties:
            let (item, detail) = properties[indexPath.row]
            cell.textLabel?.text = item
            cell.detailTextLabel?.text = detail

        case .value:
            let (item, detail) = value[indexPath.row]
            cell.textLabel?.text = item
            cell.detailTextLabel?.text = detail
        }

        return cell
    }
}

extension Bool {
    var string: String {
        return self ? "YES" : "NO"
    }
}
