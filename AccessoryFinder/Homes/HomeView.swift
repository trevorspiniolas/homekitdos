/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The list of accessories found in the home.
*/

import UIKit
import HomeKit

/// - Tag: HomeView
class HomeView: UITableViewController {

    /// The home with the accessories to display.
    var home: HMHome? {
        didSet {
            // Handle any changes in the home.
            home?.delegate = self
            
            // Make the home store, acting as a central hub, the delegate for all accessories.
            home?.accessories.forEach { $0.delegate = HomeStore.shared }

            // Update the display with the new home data.
            resetDisplay(for: home)
        }
    }
    
    // MARK: - Grouping

    /// The types of groupings by which the accessories can be displayed.
    enum GroupKey {
        case room, category
    }
    
    /// A key to indicate how accessories should be grouped in the table right now.
    var groupKey = GroupKey.room {
        didSet {
            // Refreshes the view without reloading the display data from HomeKit.
            accessoryView?.accessory = nil
            tableView.reloadData()
        }
    }

    /// The rooms in the primary home.
    var rooms = [HMRoom]()
    
    /// The categories of all the known accessories.
    var categories = [Category]()
    
    /// The accessory grouping being displayed, given the current groupKey setting.
    var grouping: [AccessoryGroup] {
        return groupKey == .room ? rooms : categories
    }
    
    /// Sets the group key based on the new value of the segmented controller.
    @objc
    func changeSeg(_ sender: UISegmentedControl) {
        groupKey = sender.selectedSegmentIndex == 0 ? .room : .category
    }

    /// Repopulates the display data for the given home.
    /// - Tag: reloadDisplayData
    func reloadDisplayData(for home: HMHome?) {
        rooms = []
        categories = []
        
        if let home = home {
            
            // Store the accessories by room, omitting empty rooms, but including the default room.
            rooms = ([home.roomForEntireHome()] + home.rooms)
                .filter { !$0.accessories.isEmpty }
                .sorted { $0.name < $1.name }

            // Store the accessories by category.
            //Update the name of all services for all devices.
            for n in home.accessories {
                let name = n.displayName
                if let index = categories.firstIndex(where: { _ in n.name == name }) {
                    categories[index].accessories.append(n)
                } else {
                    categories.append(Category(name: name, accessories: [n]))
                }
              
                for m in n.services {
                    HomeStore.shared.updateService(m, name: "ThisWillBeOverWritten")
                    
                }
                
            }
            
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Volunteer to handle any changes detected in the HomeKit database's list of homes.
        HomeStore.shared.homeManager.delegate = self

        // Sign up for accessory delegate callbacks.
        HomeStore.shared.addAccessoryDelegate(self)
        
        // Add a segmented control to view by room or by category.
        let segment = UISegmentedControl(items: ["Rooms", "Categories"])
        segment.tintColor = .orange
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(changeSeg(_:)), for: .valueChanged)
        toolbarItems = [UIBarButtonItem(customView: segment)]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    /// The accessory detail view.
    var accessoryView: AccessoryView? {
        let nav = splitViewController?.viewControllers.last as? UINavigationController
        return nav?.topViewController as? AccessoryView
    }
    
    /// Reloads data from HomeKit and refreshes the display.
    /// - Tag: resetDisplay
    func resetDisplay(for home: HMHome?) {
        reloadDisplayData(for: home)
        accessoryView?.accessory = nil
        tableView.reloadData()
    }
    
    // MARK: - Segues
    
    /// Begins the search for new accessories.
    @IBAction func tapAddAccessory(_ sender: UIBarButtonItem) {
        home?.addAndSetupAccessories { error in
            if let error = error {
                print(error)
            } else {
                // Make no assumption about changes; just reload everything.
                self.resetDisplay(for: self.home)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",
            let indexPath = tableView.indexPathForSelectedRow,
            let nav = segue.destination as? UINavigationController,
            let controller = nav.topViewController as? AccessoryView {
            
            let accessory = grouping[indexPath.section].accessories[indexPath.row]
            controller.accessory = accessory

            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true

            // Reset the list delegates to be informed about accessory changes.
            HomeStore.shared.removeAllAccessoryDelegates()
            HomeStore.shared.addAccessoryDelegate(self)
            HomeStore.shared.addAccessoryDelegate(controller)
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return grouping[section].name
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccessoryCell", for: indexPath)
        if let accessoryCell = cell as? AccessoryCell {
            accessoryCell.accessory = grouping[indexPath.section].accessories[indexPath.row]
            accessoryCell.subtitleProperty = groupKey == .room ? .category : .room
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let accessory = grouping[indexPath.section].accessories[indexPath.row]
            home?.removeAccessory(accessory) { error in
                if let error = error {
                    print(error)
                } else {
                    self.reloadDisplayData(for: self.home)
                    self.tableView.reloadData()
                    
                    // Clear the accessory view if it's showing the deleted accessory.
                    guard let accessoryView = self.accessoryView else { return }
                    if accessoryView.accessory == accessory {
                        accessoryView.accessory = nil
                    }
                }
            }
        }
    }
}

// MARK: - Supporting Types

/// An interface for storing groups of accessories.
/// - Tag: AccessoryGroup
protocol AccessoryGroup {
    var name: String { get }
    var accessories: [HMAccessory] { get }
}

// Assert that HMRoom already adopts the AccessoryGroup protocol.
extension HMRoom: AccessoryGroup {}

/// A per-category accessory grouping.
/// - Tag: Category
struct Category: AccessoryGroup {
    var name: String
    var accessories: [HMAccessory]
}
