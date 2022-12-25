import UIKit
import Parse

class TasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var jobs = [PFObject]() //an array to hold jobs
    var rowNum:Int? //an array to hold jobs

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
     
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className:"Job")
        query.includeKeys(["assigned_to", "created_by", "activity"])
        
        let currentUser = PFUser.current()
        
        // if the current user is not a manager, we only fetch jobs assigned to the current user
        if (currentUser?["manager"] as! Int != 1) {
            query.whereKey("assigned_to", equalTo: currentUser)
        }
        
        query.findObjectsInBackground { (jobs, error) in
            if jobs != nil {
                self.jobs = jobs!
                self.tableView.reloadData()
            }
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobTableViewCell") as! JobTableViewCell
        let job = jobs[indexPath.row]
        let jobName = job["name"] as! String
        let assignedTo = job["assigned_to"] as! PFUser
        let assignedUsername = assignedTo["username"] as! String
        
        var dueDate = job["due_date"] as! Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY"

        
        //now we can set information in each cell
        cell.JobNameLabel.text = jobName
        cell.JobNameLabel.sizeToFit()
        cell.AssignedNameLabel.text = assignedUsername
        cell.DateLabel.text = dateFormatter.string(from: dueDate)
        var status = ""
        
        let x = (job["activity"] as? [PFObject]) ?? []
        let i = x.count
        if(i > 0){
            let x = (job["activity"] as? [PFObject]) ?? []
            let i = x.count
            let y = x[i-1]
            status = y["status"] as! String
        }
        else{
            status = "Not started"
        }

        if status == "Not started" {
            //not started = red
            cell.StatusImage.image = UIImage(named: "not_started_status_image")
        } else if status == "In progress" {
            //in progress = yellow
            cell.StatusImage.image = UIImage(named: "in_progress_status_image")
        } else if status == "Completed" {
            //completed = green
            cell.StatusImage.image = UIImage(named: "completed_status_image")
        }

        return cell
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else { return }
        
        delegate.window?.rootViewController = loginViewController
    
    }
    
    
    //Performs segue when a job is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowNum = indexPath.row
        performSegue(withIdentifier: "jobDetails", sender: self)
   }
    
   //Passes data from task view controller to tab bar controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if(segue.identifier == "jobDetails"){
            let job = jobs[rowNum!]
            let x = (job["activity"] as? [PFObject]) ?? []
            let i = x.count
            let vc = segue.destination as! TabBarController
            vc.name = job["name"] as? String
            vc.assignedTo = job["assigned_to"] as? PFUser //was String
            vc.createdBy = job["created_by"] as? PFUser //was String
            vc.desc = job["description"] as? String
            vc.dueDate = job["due_date"] as? Date //was String
            vc.status = job["status"] as? String
            vc.isCompleted = job["is_completed"] as? Bool
            vc.jobId = job.objectId
            if i > 0{
                let y = x[i - 1]
                vc.status = y["status"] as? String
            }
            else{
                vc.status = job["status"] as? String
            }

        }

    }
    

}
