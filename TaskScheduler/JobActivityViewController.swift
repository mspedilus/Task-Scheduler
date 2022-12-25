import UIKit
import Parse

class JobActivityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var activities = [PFObject]() //an array to hold job activities
    var name:String?
    var jobId:String?
    var job: PFObject?


    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //tells the tab bar controller which tab to show first
        self.tabBarController?.selectedIndex = 1
        
        let query = PFQuery(className:"Job")
        query.includeKeys(["activity", "created_by.username", "username"])
        query.getObjectInBackground(withId: jobId!) { (job, error) in
            if error == nil {
                let x = (job?["activity"] as? [PFObject]) ?? []
                let i = x.count
                if i == 0 {
                    let activity = PFObject(className: "Activity")
                    activity["status"] = "Not started"
                    activity["job"] = job
                    activity["username"] = job?["created_by"] as? PFUser
                    job?.add(activity, forKey: "activity")

                    job?.saveInBackground{(success, error) in
                        if success{
                            print("Status added")
                    } else {
                            print("Error adding status")
                    }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        let query = PFQuery(className:"Job")
        query.includeKeys(["activity", "activity.username"])
        query.getObjectInBackground(withId: jobId!) { (job, error) in
            if error == nil {
                self.job = job!
                self.tableView.reloadData()
            }
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let activites = (job?["activity"] as? [PFObject]) ?? []
        return activites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let activities = (job?["activity"] as? [PFObject]) ?? []
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobActivityCell") as! JobActivityCell
        let activity = activities[indexPath.row]
        let user = activity["username"] as! PFUser
        let dateFormatter = DateFormatter()
        let createdDate = activity.createdAt!
        
        
        if activity["status"] as! String  == "Not started" {
            //not started. make color red
            cell.statusImage.image = UIImage(named: "not_started_status_image")
        } else if activity["status"] as! String == "In progress" {
            //in progress. make color yellow
            cell.statusImage.image = UIImage(named: "in_progress_status_image")
        } else if activity["status"] as! String == "Completed" {
            //completed. make color green
            cell.statusImage.image = UIImage(named: "completed_status_image")
        }

        dateFormatter.dateFormat = "EEEE, MMM d, yyyy h:mm a"
        cell.userLabel.text = user.username
        cell.dateLabel.text = dateFormatter.string(from: createdDate)
        return cell

    }

}
