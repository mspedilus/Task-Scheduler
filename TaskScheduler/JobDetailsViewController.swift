import UIKit
import Parse
import AlamofireImage

class JobDetailsViewController: UIViewController {
    
    public var completionHandler: ((Bool?) -> Void)?
    @IBOutlet weak var jobName: UILabel!
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var managerNameLabel: UILabel!
    @IBOutlet weak var JobStatusImage: UIImageView!
    @IBOutlet weak var AssignedToProfileImage: UIImageView!
    @IBOutlet weak var AssignedByProfileImage: UIImageView!
    @IBOutlet weak var JobDescriptionLabel: UILabel!
    @IBOutlet weak var DueDateLabel: UILabel!
    @IBOutlet weak var showButton: UIButton!
    @IBAction func editButton(_ sender: Any) {
        
    let vc = storyboard?.instantiateViewController(withIdentifier: "newJobScreen") as! NewJobViewController
        vc.showEditButton = true
        vc.jobName = name
        vc.desc = desc
        vc.dueDate = dueDate
        vc.assignedTo = assignedTo
        vc.jobId = jobId
        vc.status = status
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    
    var name:String?
    var assignedTo:PFUser? //was String?
    var createdBy:PFUser? //was String?
    var dueDate:Date? //was String?
    var isCompleted:Bool?
    var status:String?
    var desc:String?
    var jobId:String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //formatting date value
        let dueDate = dueDate!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy h:mm a"

        jobName.text = name
        jobName.sizeToFit()
        employeeNameLabel.text = assignedTo?.username
        managerNameLabel.text = createdBy?.username
        JobDescriptionLabel.text = desc
        DueDateLabel.text = dateFormatter.string(from: dueDate)
        
        if status == "Not started" {
            //not started = red
            JobStatusImage.image = UIImage(named: "not_started_status_image")
        } else if status == "In progress" {
            //in progress = yellow
            JobStatusImage.image = UIImage(named: "in_progress_status_image")
        } else if status == "Completed" {
            //completed = green
            JobStatusImage.image = UIImage(named: "completed_status_image")
        }
        
        //Shows or hides the edit button
        let user = PFUser.current()
        let isManager = user?["manager"] as? Bool

        if(isManager == true){
            self.showButton.isHidden = false
        }
        else{
            self.showButton.isHidden = true
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let query = PFQuery(className:"Job")
        query.includeKeys(["assigned_to", "created_by", "activity"])
        query.getObjectInBackground(withId: jobId!) { (job, error) in
            if error == nil {
                let employee = job?["assigned_to"] as? PFUser
                let manager = job?["created_by"] as? PFUser
                let date = job?["due_date"] as? Date
                let dueDate = date!
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE, MMM d, yyyy h:mm a"
                let x = (job?["activity"] as? [PFObject]) ?? []
                let i = x.count
                self.JobDescriptionLabel.text = job?["description"] as? String
                self.jobName.text = job?["name"] as? String
                self.employeeNameLabel.text = employee?.username
                self.managerNameLabel.text = manager?.username
                self.DueDateLabel.text = dateFormatter.string(from: dueDate)
                
                self.name = job?["name"] as? String
                self.desc = job?["description"] as? String
                self.assignedTo = employee
                self.dueDate = date
                
                if(i > 0){
                    let y = x[i - 1]
                    self.status = y["status"] as? String
                }

                if self.status == "Not started" {
                    //not started = red
                    self.JobStatusImage.image = UIImage(named: "not_started_status_image")
                } else if self.status == "In progress" {
                    //in progress = yellow
                    self.JobStatusImage.image = UIImage(named: "in_progress_status_image")
                } else if self.status == "Completed" {
                    //completed = green
                    self.JobStatusImage.image = UIImage(named: "completed_status_image")
                }
            }
        }
    }

}
