import UIKit
import Parse

class TabBarController: UITabBarController {

    var name:String?
    var assignedTo:PFUser?
    var createdBy:PFUser?
    var dueDate:Date?
    var isCompleted:Bool?
    var status:String?
    var desc:String?
    var jobId:String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let viewControllers = viewControllers else {
            return
        }
        
        //Passes data from tab bar controller to view controller
        for viewController in viewControllers {
            if let nc = viewController as? JobDetailsNavigationController {
                if let vc = nc.viewControllers.first as? JobDetailsViewController {
                    vc.name = name
                    vc.assignedTo = assignedTo
                    vc.createdBy = createdBy
                    vc.desc = desc
                    vc.dueDate = dueDate
                    vc.status = status
                    vc.isCompleted = isCompleted        
                    vc.jobId = jobId


                }
                
            } else if let nc = viewController as? JobActivityNavigationController {
                if let vc = nc.viewControllers.first as? JobActivityViewController {
                    vc.name = name
                    vc.jobId = jobId
                }
            } else if let nc = viewController as? CommentNavigationController {
                if let vc = nc.viewControllers.first as? CommentsViewController {
                    vc.jobName = name
                    vc.jobId = jobId

                }
            }
        }
    }

}
