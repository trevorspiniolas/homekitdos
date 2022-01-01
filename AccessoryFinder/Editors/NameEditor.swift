/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Enables editing a name field.
*/

import UIKit

protocol NameEditDelegate: AnyObject {
    func updateName(_ name: String)
}

class NameEditor: UITableViewController {
    
    @IBOutlet weak var nameField: UITextField!

    var name: String?
    weak var delegate: NameEditDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.text = name
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let name = nameField.text {
            delegate?.updateName(name)
        }
    }
}
