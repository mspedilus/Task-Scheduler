import UIKit
import Parse

class NewJobViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var showEditButton:Bool?
    var jobName:String?
    var desc:String?
    var dueDate:Date?
    var assignedTo:PFUser?
    var jobId:String?
    var job: PFObject?
    var status:String?
    var users = [PFObject]() //array to hold users
    var pickerData: [String] = [String]()
    var statusPickerData = ["Not started", "In progress", "Completed"]

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return pickerData.count
        }
        else {
            return statusPickerData.count
        }
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //print(users[row]["username"] as Any)
        if pickerView.tag == 0 {
            return pickerData[row]
        }
        else {
            return statusPickerData[row]
        }
    }
    
    // Capture the picker view selection
   func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       // This method is triggered whenever the user makes a change to the picker selection.
       // The parameter named row and component represents what was selected.
   }

    //Saves edits made to the job
    @IBAction func saveChanges(_ sender: Any) {
        
        let query = PFQuery(className:"Job")
        query.includeKeys(["activity"])

        query.getObjectInBackground(withId: jobId!) { (job: PFObject?, error: Error?) in

            if let error = error {
                print(error.localizedDescription)
            } else if let job = job {
                job["name"] = self.NameInput.text
                job["description"] = self.DescriptionInput.text
                job["due_date"] = self.DueDatePicker.date
                let userIndex = self.AssignToPicker.selectedRow(inComponent:0)
                job["assigned_to"] = self.users[userIndex]
                job.saveInBackground()
                
                let x = (job["activity"] as? [PFObject]) ?? []
                var i = x.count
                let y = x[i - 1]
                i = self.statusPicker.selectedRow(inComponent:0)
                let z = self.statusPickerData[i]
                
                if (y["status"] as? String != z) {
                    let index = self.statusPicker.selectedRow(inComponent:0)
                    let activity = PFObject(className: "Activity")
                    activity["status"] = self.statusPickerData[index]
                    activity["job"] = job
                    activity["username"] = PFUser.current()!
                    job.add(activity, forKey: "activity")

                    job.saveInBackground{(success, error) in
                        if success{
                            print("Status changed")
                        } else {
                            print("Error changing status comment")
                        }
                    }
                }
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusPicker: UIPickerView!
    @IBOutlet weak var showDismissButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var JobTitle: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var NameInput: UITextField!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var DescriptionInput: UITextView!
    @IBOutlet weak var DueDateLabel: UILabel!
    @IBOutlet weak var DueDatePicker: UIDatePicker!
    @IBOutlet weak var AssignToLabel: UILabel!
    @IBOutlet weak var AssignToPicker: UIPickerView!
    @IBOutlet weak var TaskLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.AssignToPicker.delegate = self
        self.AssignToPicker.dataSource = self
        self.statusPicker.delegate = self
        self.statusPicker.dataSource = self
        
        //create a border for the description textView
        DescriptionInput.layer.borderWidth = 1
        DescriptionInput.layer.borderColor = UIColor.lightGray.cgColor
        NameInput.layer.borderWidth = 1
        NameInput.layer.borderColor = UIColor.lightGray.cgColor
        
        //round the buttons
        saveButton.layer.cornerRadius = 15
        saveButton.layer.masksToBounds = true
        showDismissButton.layer.cornerRadius = 15
        showDismissButton.layer.masksToBounds = true
        editButton.layer.cornerRadius = 15
        editButton.layer.masksToBounds = true
        
        
        let query = PFUser.query()

        query?.findObjectsInBackground(block: { [self] users, error in
            if users != nil{
                self.users = users!
                //print(self.users[0].objectId)
                for user in self.users {
                    //print(user.objectId)
                    self.pickerData.append(user["username"] as! String)
                }
            }
        })
        
        NameInput.text = jobName
        DescriptionInput.text = desc
        if(dueDate != nil){
            DueDatePicker.date = dueDate!
            
        }

        if(showEditButton == nil){
            self.editButton.isHidden = true
            self.statusPicker.isHidden = true
            self.statusLabel.isHidden = true
            self.showDismissButton.isHidden = true
            self.saveButton.isHidden = false
        }
        else{
            self.editButton.isHidden = false
            self.statusPicker.isHidden = false
            self.statusLabel.isHidden = false
            self.showDismissButton.isHidden = false
            self.saveButton.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (assignedTo != nil){
            let username = assignedTo!["username"] as! String
            var index = pickerData.firstIndex(of: username)!
            self.AssignToPicker.reloadAllComponents()
            AssignToPicker.selectRow(index, inComponent:0, animated: true)
            index = statusPickerData.firstIndex(of: status!)!
            self.statusPicker.reloadAllComponents()
            statusPicker.selectRow(index, inComponent:0, animated: true)
        }
        else{
            self.AssignToPicker.reloadAllComponents()
            self.statusPicker.reloadAllComponents()

        }
        
        if(showEditButton != nil){
            let query = PFQuery(className:"Job")
            query.includeKeys(["username", "activity", "activity.username"])
            query.getObjectInBackground(withId: jobId!) { (job, error) in
                if error == nil {
                    self.job = job!
                }
            }
        }

    }

    
    @IBAction func NavLogoutButton(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else { return }
        
        delegate.window?.rootViewController = loginViewController
    }
    
    @IBAction func NavBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //This is where we save information and store it into parse
    @IBAction func SaveButton(_ sender: Any) {
        
        
        let job = PFObject(className: "Job")
        
        //gather date
        job["name"] = NameInput.text
        job["description"] = DescriptionInput.text
        job["due_date"] = DueDatePicker.date
        let userIndex = AssignToPicker.selectedRow(inComponent:0)
        
        job["assigned_to"] = self.users[userIndex]
        job["created_by"] = PFUser.current()!
        job["status"] = "Not started"
        job["is_complete"] = false
        
        //save info into parse
        job.saveInBackground { success, error in
            if success {
                print("Information saved!")
            } else {
                print("Information not saved!")
            }
        }
        
        self.navigationController?.popToRootViewController(animated: true)
    
    }

}
