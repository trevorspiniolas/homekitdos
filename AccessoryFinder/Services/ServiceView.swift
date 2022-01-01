/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Details about a given service.
*/

import UIKit
import HomeKit

/// A view presenting all the details of a single service.
/// - Tag: ServiceView
class ServiceView: UITableViewController {
    
    /// The service to display.
    var service: HMService? {
        willSet {
            // Disable notifications on the previous service characteristics.
            service?.enableNotifications(false)
        }
        didSet {
            // Enable notifications on the new service characteristics.
            service?.enableNotifications(true)
            reloadDisplayData()
        }
    }

    /// The list of service characteristics for display.
    var characteristics = [HMCharacteristic]()
    
    /// The list of service properties and values for display.
    var properties = [(String, String?)]()

    /// Refreshes the display data from the service.
    func reloadDisplayData() {
        // Start with a blank slate.
        title = "Service"
        characteristics = []
        properties = []
        
        // Bail out if service is nil.
        guard let service = service else { return }
        
        title = service.displayName
        
        // Sort characteristics by the type.
        characteristics = service.characteristics.sorted { $0.characteristicType < $1.characteristicType }
        
        // Prepare the property tuples in the order the should appear in the UI.
        properties = [
            ("User Assigned Name", service.name),
            ("Identifier", service.uniqueIdentifier.uuidString),
            ("Type", service.displayName),
            ("Type ID", service.serviceType),
            ("Is Primary", service.isPrimaryService.string),
            ("Is User Interactive", service.isUserInteractive.string)
        ]
        
        // For certain kinds of services, also show the associated type.
        if service.serviceType == HMServiceTypeOutlet || service.serviceType == HMServiceTypeSwitch {
            properties.append(("Associated Type", service.associatedServiceType))
        }
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCharacteristic",
            let indexPath = tableView.indexPathForSelectedRow,
            let cell = tableView.cellForRow(at: indexPath) as? CharacteristicCell,
            let controller = segue.destination as? CharacteristicView {
            
            controller.characteristic = cell.characteristic
            
        } else if segue.identifier == "showServiceName",
            let controller = segue.destination as? NameEditor {

            controller.name = service?.name
            controller.delegate = self
        }
    }
    
    // MARK: - Table View

    /// The table sections we support. Reorder here to control the order in the UI.
    enum Sections: Int, CaseIterable {
        case properties, characteristics
    }
    
    /// Returns the number of services that this accessory has.
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard service != nil else { return 0 }
        return Sections.allCases.count
    }
    
    /// Returns the number of characteristics for a given service.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionName = Sections(rawValue: section) else { return 0 }
        
        switch sectionName {
        case .properties:       return properties.count
        case .characteristics:  return characteristics.count
        }
    }
    
     override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionName = Sections(rawValue: section) else { return nil }
        
        switch sectionName {
        case .properties:       return "Service Properties"
        case .characteristics:  return "Service Characteristics"
        }
    }
    
    /// Returns the configured cell for the given row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionName = Sections(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch sectionName {
        case .properties:
            // Use a specially formatted cell for the first row which holds the editable name.
            let identifier = indexPath.row == 0 ? "NameCell" : "PropertyCell"
            
            // Populate a property cell.
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            let (item, value) = properties[indexPath.row]
            cell.textLabel?.text = item
            cell.detailTextLabel?.text = value
            return cell

        case .characteristics:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CharacteristicCell", for: indexPath)
            if let characteristicCell = cell as? CharacteristicCell {
                characteristicCell.characteristic = characteristics[indexPath.row]
            }
            return cell
        }
    }
}

extension ServiceView: NameEditDelegate {
    func updateName(_ name: String) {
        guard let service = service else { return }
        HomeStore.shared.updateService(service, name: name)
    }
}
