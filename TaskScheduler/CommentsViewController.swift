import UIKit
import Parse

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var comments = [String]()
    var jobId:String?
    var jobName:String?
    var user = PFUser.current()
    var job: PFObject?

    @IBOutlet weak var AddCommentField: UITextField!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var jobNameLabel: UILabel!
    
    @IBAction func SendButton(_ sender: Any) {
        
        //Post the comment
        let comment = PFObject(className: "Comment")
        comment["text"] = AddCommentField.text
        comment["post"] = job
        comment["author"] = PFUser.current()!
        job?.add(comment, forKey: "comments")

        job?.saveInBackground{(success, error) in
            if success{
                print("Comment saved")
        } else {
                print("Error saving comment")
        }
        }
        
        table.reloadData()
        self.AddCommentField.text = ""

    }
        
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let comments = (job?["comments"] as? [PFObject]) ?? []
        return comments.count
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        let query = PFQuery(className:"Job")
        query.includeKeys(["author", "comments", "comments.author"])
        query.getObjectInBackground(withId: jobId!) { (job, error) in
            if error == nil {
                self.job = job!
                self.table.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let post = posts[indexPath.section]
        let comments = (job?["comments"] as? [PFObject]) ?? []
        
        let cell = table.dequeueReusableCell(withIdentifier: "commentCell") as! CommentCell
        let comment = comments[indexPath.row]
        cell.commentLabel.text = comment["text"] as? String
        let user = comment["author"] as! PFUser
        cell.userNameLabel.text = user.username
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let query = PFQuery(className:"Job")
        query.getObjectInBackground(withId: jobId!) { (job, error) in
            if error == nil {
                self.jobNameLabel.text = job?["name"] as? String
                print("This is the name in comment: ", self.jobNameLabel)
            }
        }
    }

}
    

