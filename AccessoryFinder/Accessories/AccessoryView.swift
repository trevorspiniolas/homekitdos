/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The list of services and their characteristics for a given accessory.
*/

import UIKit
import HomeKit

/// A view presenting all the details of a single accessory.
/// - Tag: AccessoryView
class AccessoryView: UITableViewController {
    
    var interactiveServices = [HMService]()
    var hiddenServices = [HMService]()
    var properties = [(String, String?)]()
    var bridgedAccessories = [HMAccessory]()

    var accessory: HMAccessory? {
        didSet {
            reloadDisplayData()
        }
    }
    
    func reloadDisplayData() {
        interactiveServices = []
        hiddenServices = []
        bridgedAccessories = []
        
        if let accessory = accessory {
            title = accessory.displayName
            identifyButton.isEnabled = accessory.isReachable && accessory.supportsIdentify
            interactiveServices = accessory.services.filter { $0.isUserInteractive }
            hiddenServices = accessory.services.filter { !$0.isUserInteractive }
          
            properties = [
                ("Name", accessory.name),
                ("Identifier", accessory.uniqueIdentifier.uuidString),
                ("Manufacturer", accessory.manufacturer),
                ("Model", accessory.model),
                ("Firmware Version", accessory.firmwareVersion),
                ("Is Reachable", accessory.isReachable.string),
                ("Is Blocked", accessory.isBlocked.string)
            ]
            
            if let brigedIds = accessory.uniqueIdentifiersForBridgedAccessories {
                
                HomeStore.shared.homeManager.homes.forEach { home in
                    home.accessories.forEach { accessory in
                        if brigedIds.contains(accessory.uniqueIdentifier) {
                            bridgedAccessories.append(accessory)
                        }
                    }
                }
            }
        } else {
            title = "Accessory"
            identifyButton.isEnabled = false
            
            navigationController?.popToRootViewController(animated: true)
            tableView.reloadData()
        }
    }

    /// A bar button that the user can tap to ask an accessory to identify itself.
    @IBOutlet weak var identifyButton: UIBarButtonItem!
    
    /// Asks the accessory to identify itself, for example by flashing a light briefly.
    @IBAction func tapIdentify(_ sender: UIBarButtonItem) {
        accessory?.identify { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "showService",
            let indexPath = tableView.indexPathForSelectedRow,
            let cell = tableView.cellForRow(at: indexPath) as? ServiceCell,
            let controller = (segue.destination as? ServiceView) {
            
            controller.service = cell.service
            
        } else if segue.identifier == "showBridgedAccessory",
            let indexPath = tableView.indexPathForSelectedRow,
            let cell = tableView.cellForRow(at: indexPath) as? BridgedAccessoryCell,
            let controller = (segue.destination as? AccessoryView) {
            
            controller.accessory = cell.accessory
            
        } else if segue.identifier == "showAccessoryName",
            let controller = (segue.destination as? NameEditor) {
            
            controller.name = accessory?.name
            controller.delegate = self
        }
    }

    // MARK: - Table View

    /// The table sections we support. Reorder here to control the order in the UI.
    enum Sections: Int, CaseIterable {
        case properties, interactiveServices, hiddenServices, bridgedAccessories
    }
    
    /// Returns the number of services that this accessory has.
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard accessory != nil else { return 0 }
        return Sections.allCases.count - (bridgedAccessories.isEmpty ? 1 : 0)
    }
    
    /// Returns the number of characteristics for a given service.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionName = Sections(rawValue: section) else { return 0 }
        
        switch sectionName {
        case .interactiveServices:  return interactiveServices.count
        case .hiddenServices:       return hiddenServices.count
        case .properties:           return properties.count
        case .bridgedAccessories:   return bridgedAccessories.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionName = Sections(rawValue: section) else { return nil }
        
        switch sectionName {
        case .interactiveServices:  return "User Interactive Services"
        case .hiddenServices:       return "Hidden Services"
        case .properties:           return "Accessory Properties"
        case .bridgedAccessories:   return "Bridged Accessories"
        }
    }
    
    /// Returns the configured characteristic cell for the given row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionName = Sections(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch sectionName {
        case .interactiveServices, .hiddenServices:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath)
            if let serviceCell = cell as? ServiceCell {
                serviceCell.service = sectionName == .interactiveServices ? interactiveServices[indexPath.row] : hiddenServices[indexPath.row]
            }
            return cell

        case .properties:
            let identifier = indexPath.row == 0 ? "NameCell" : "PropertyCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            let (item, value) = properties[indexPath.row]
            cell.textLabel?.text = item
            cell.detailTextLabel?.text = value
            return cell

        case .bridgedAccessories:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BridgedAccessoryCell", for: indexPath)
            if let accessoryCell = cell as? BridgedAccessoryCell {
                accessoryCell.accessory = bridgedAccessories[indexPath.row]
            }
            return cell
        }
    }
}

extension AccessoryView: NameEditDelegate {
    func updateName(_ name: String) {
        guard let accessory = accessory else { return }
        HomeStore.shared.updateAccessory(accessory, name: name)
    }
}
