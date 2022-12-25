import UIKit
import Parse

class SignupViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Capture the picker view selection
   func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       // This method is triggered whenever the user makes a change to the picker selection.
       // The parameter named row and component represents what was selected.
   }

    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect data:
        self.picker.delegate = self
        self.picker.dataSource = self
        pickerData = ["Manager", "Employee"]
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
        
        let selectedRoleIndex = picker.selectedRow(inComponent: 0)
        
        let isManager = selectedRoleIndex == 0 ? true : false

        user["manager"] = isManager
        
       user.signUpInBackground { (success, error) in
            if success {
                self.performSegue(withIdentifier: "jobListSegue", sender: nil)
                
            } else {
                // TODO: show an actual message in the view
                print("Error: \(error?.localizedDescription)")
            }
            
        }
    }
    
    @IBOutlet weak var picker: UIPickerView!

}
