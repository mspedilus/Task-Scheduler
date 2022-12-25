# Job Scheduler
IOS app created in swift made to help keep track of tasks that needs to be completed

### Video Walkthrough

![](https://i.imgur.com/qvWj1ZT.gif)


## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
The job scheduler app is designed to track, organize, and manage the different jobs assigned to employees. Managers are able to create and assign jobs/tasks to their subordinates, track the status, and view comments about the job. Subordinates are able to view their list of assigned jobs, change the status (assigned, in-progress, completed), and add comments to the job. This app could be used as a means to manage grievances made to companies or as a way to manage software bugs.

### App Evaluation
- **Category:** Business / Productivity
- **Mobile:** This app would be primarily developed for iOS devices.
- **Story:** Create jobs/tasks and assign them to employees. Manage the progress of the job and view any comments made.
- **Market:** Any sized company or group could choose to use this app. People would be organized into roles, either a manager or employee, to better handle job assignments and completion.
- **Habit:** This app could be used on a daily basis to manage the jobs assigned and ensure jobs are being completed in a timely manner.
- **Scope:** First we would start with the job scheduling features and then perhaps expand the app to include communication between other employees and departments. This app is intended for small companies or groups of people not wanting to use bigger solutions like Jira, Clickup, etc, looking to better manage and organize job assignments.

## Product Spec

### 1. User Stories 
- [x] User registers as a manager

- [x] User registers as an employee

- [x] User manager logs in and sees the list of jobs.

- [x] User manager clicks on the create job button and creates a job from the create job view. Manager must be able to select a job name, add tasks, and add an assignee. Adding an assignee at this point is optional. The status of the job will be assigned automatically when selecting an assignee. The possible status of a job are: “created”, “assigned”, “in-progress”, and “completed”. 

- [x] User manager clicks on a job from the job listing and gets redirected to the job details view. User is able to see the detailed information about a job

- [x] User clicks on the comments icon from the job detail view, and gets redirected to the comments view. As a manager, I want to be able to add comments to a job after the time of creating it, so that I can keep up to date on the job and ask for progress reports. As an employee, they need to be able to reply to these comments and provide feedback to newly posted comments on the job.

- [x] User clicks on the activity icon from the job detail view, and gets redirected to the activity view. User is able to see the list of status activities for that job.

- [x] User employee logs in and sees the list of jobs assigned to him/her. An employee can only see jobs assigned to him/her.

- [x] User can edit a job

- [x] User can change status of a job to in progress or complete from the job details view

- [x] overall UI enhancements to all screens in preparation for demo day


**Optional Nice-to-have Stories**

* User can request for more jobs to be assigned
* User can request for a job reassignment
* User can view their profile
* User manager can cancel a job
* As an employee, I want to be able to add photos to a completed job to show proof of completion so that the manager can see the completed job

### 2. Screen Archetypes

* Login Screen - User logs in
    * User is forced to login upon opening the app unless he/she is already logged in. The user is presented with a username and password text fields, and two buttons: login and sign up 

* Register Screen - User signs up
   * Upon clicking the sign up button in the login screen, the user will be redirected to the register view, where he/she will be presented with a username and password text fields, and a dropdown to select their access level: manager or employee, and a register button.

* Job List Screen - Chat for users to communicate (direct 1-on-1)
   * A view where we can filter the jobs on the screen based on id, status, employees, and timestamps. Each job in this table would just show the job name, and who it is assigned to (maybe more). From here, if we click on a job, we should be directed to Job details view.

* Job Creation Screen 
   * Only accessible to managers. Allows manager to create a job

* Job Details Screen 
   * The default view when clicking on a job in the jobs view. It presents information about a job
like name, date assigned, tasks list. Users can complete a task and or a job from this view. This screen contains icons for comments, activity, and photos.

* Job Comments Screen
   * A view to show and add comments on a specific job. Can be reached from JobView. Allows users to see the list of comments for a particular job. Users have the ability to add a new comment as well.

* Job Activity Screen
   * READ ONLY VIEW. Allows users to see the status activity for a particular job. For example, when the job was assigned, set as in-progress, and completed.

* Job Photos Screen
   * Allows users to see the list of photos for a particular job. Users have the ability to upload a new photo for said job.

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Jobs (Home)
* Logout

Optional:
* Instead of having a logout link in the tab navigation, if time allows we could have a profile link
  where the user can can logout but also have a link to see their profile view

**Flow Navigation** (Screen to Screen)

Manager
* Forced Log-in -> Account creation if no login is available
* User Registration Screen -> Home (Jobs view)
* Jobs View -> Job Creation Screen
* Jobs View -> Job Details view
* Job Details View -> Job Comments view
* Job Details View -> Job Activity View
* Job Details View -> Job Photos View
Employee
* Forced Log-in -> Account creation if no login is available
* User Registration Screen -> Home (Jobs view)
* Jobs View -> Job Creation Screen
* Jobs View -> Job Details view
* Job Details View -> Job Comments view
* Job Details View -> Job Activity View
* Job Details View -> Job Photos View


## Wireframes
<img src="https://i.imgur.com/b9r5YGN.png" width=600>

## Schema 
### Models
#### User

   | Property   | Type     | Description |
   | ---------- | ---------| ------------|
   | objectId   | String   | unique id for the user (default field) |
   | createdAt  | DateTime | date when user is created (default field) |
   | updatedAt  | DateTime | date when user is last updated (default field) |   
   | username   | String   | the user’s username (required)  |
   | password   | String   | the user’s password (required) |
   | first_name | String   | the user’s first name (required) |
   | last_name  | String   | the user’s last name (required) |
   | manager    | Boolean  | true is the user is a manager. Default is False (required) |
   | email      | String   | the email associated with the user |

#### Job

   | Property     | Type         | Description |
   | -------------| ------------ | ------------|
   | objectId     | String       | unique id for the job entry (default field) |
   | createdAt    | DateTime     | date when user is created (default field) |
   | updatedAt    | DateTime     | date when user is last updated (default field) |   
   | name         | String       | the job’s name (required)  |
   | description  | String       | the job’s description |
   | status       | String       | created, assigned, in-progress, completed (required) |
   | due_date     | DateTime     | date when job should be completed |
   | is_completed | Boolean      | true is the job is completed. Default is False (required) |
   | assigned_to  | Pointer to User| to which user this job is assigned to |
   | created_by   | Pointer to User| which user created this job|

#### Task

   | Property     | Type     | Description |
   | -------------| ---------| ------------|
   | objectId     | String   | unique id for the task entry (default field) |
   | createdAt    | DateTime | date when user is created (default field) |
   | updatedAt    | DateTime | date when user is last updated (default field) |   
   | name         | String   | the task’s name (required)  |
   | job_id       | Pointer to Job | the job associated with this task (required) |
   | status       | String   | created, assigned, in-progress, completed (required) |
   | is_completed | Boolean  | true is the task is completed. Default is False (required) |


#### JobComment

   | Property  | Type           | Description |
   | ----------| ------------   | ----------------|
   | objectId  | String         | unique id for the comment entry (default field) |
   | createdAt | DateTime       | date when user is created (default field) |
   | updatedAt | DateTime       | date when user is last updated (default field) |   
   | comment   | String         | the comment (required)  |
   | job_id    | Pointer to Job | the job associated with this task (required) |
   | user_id   | Pointer to User| user that created the comment|


#### JobPhoto

   | Property  | Type           | Description |
   | ----------| -------------- | ----------------|
   | objectId  | String         | unique id for the job photo entry (default field) |
   | createdAt | DateTime       | date when user is created (default field) |
   | updatedAt | DateTime       | date when user is last updated (default field) |   
   | photo     | File           | the photo that the user uploads  |
   | job_id    | Pointer to Job | the job associated with this task (required) |
   | user_id   | Pointer to User| user that created the comment|


#### JobActivity

   | Property   | Type           | Description |
   | -----------| -------------- | ----------------|
   | objectId   | String         | unique id for the activity entry (default field) |
   | createdAt  | DateTime       | date when activity is created (default field) |
   | type       | String         | the type of activity. Same as job status options  |
   | job_id     | Pointer to Job | the job associated with this activity (required) |
   | user_id    | Pointer to User| user that created the activity|



### Networking
#### List of network requests by screen
   - Login Screen
      - (POST) The username and password will be pass as part of the request body
        ```swift
        let username = username.Field.text!
        let password = passwordField.text!

        PFUser.logInWithUsername(inBackground: username, password: password){ 
        (user, error) in
            if user =! nil {
                self.performSegue(withIdentifier: “loginSegue”, sender: nil)
            } else {
                print(“Error: \(String(describing: error))”)
            }
        }
        ```

   - Signup Screen
       - (POST) The user details information will be pass as part of the request body.
                    This information includes: first name, last name, username, email, password, confirm password, and account type (manager or employee)
            ```swift
            let date = Date()
            let df = DateFormatter() df.dateFormat = "MM/dd/yyyy HH:mm:ss" 
            let dateTime = df.string(from: date)

            let user = PFObject()
            user.firstName = firstNameField.text
            user.lastName = lastNameField.text
            user.username = username.Field.text
            user.password = passwordField.text
            user.confirmPassword = confirmPasswordField.text
            user.email = emailField.text
            user.accountType = accountType.text
                user.objectId = NSUUID().uuidString
                user.createdAt = dateTime
                user.updatedAt = dateTime


            user.signUpInBackground{(success, error) in
                if success {
                    self.performSegue(withIdentifier: “loginSegue”, sender: nil)
                } else {
                    print(“Error: \(String(describing: error))”)
                }
            }
            ```

   - Job List Screen
      - (Read/GET) Query all jobs if user is manager
         ```swift
         let query = PFQuery(className:"Jobs")
         query.order(byDescending: "createdAt")
         query.findObjectsInBackground { (jobs: [PFObject]?, error: Error?) in
            if let error = error { 
               print(error.localizedDescription)
            } else if let jobs = jobs {
               print("Successfully retrieved \(jobs.count) jobs.")
           // TODO: Show the list of jobs in the view...
            }
         }
         ```
         
      - (Read/GET) Query only the jobs assigned to the user if the user is an employee
         ```swift
         let query = PFQuery(className:"Jobs")
         query.whereKey("assigned_to", equalTo: currentUser)
         query.order(byDescending: "createdAt")
         query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let error = error { 
               print(error.localizedDescription)
            } else if let jobs = jobs {
               print("Successfully retrieved \(jobs.count) jobs.")
           // TODO: Show the list of jobs in the view...
            }
         }
         ```
         
      - (Read/GET) Search by filter (name)
        ```swift
        let query = PFQuery(className:"Jobs")
        query.whereKey("name", equalTo: searchField.text!)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let objects = objects {
                print("Successfully retrieved \(objects.count) scores.")
                for object in objects {
                    print(object.objectId as Any)
                }
            }
        }
        ```
      
   - Create Job Screen
      - (Create/POST) Create a new job object. We will pass the following as part of the request body: name, description, due date, assigned to, list of tasks
        ```swift
        let job = PFObject(className: “Jobs”)
        job[“name”] = nameField.text!
        job[“description”] = descriptionField.text!
        job[“status”] = statusField.text!
        job[“due_date”] = dueDateField.text!
        job[“tasks”] = tasksField.text!

        job.saveInBackground {(success, error) in
            If success {
                print(“Successful”)
            } else {
                print(“Error”)
        }
        ```

   - Job Activity Screen
      - (Read/GET) Fetches the activity for a specific job id=
        ```swift
        let query = PFQuery(className:"JobActivity ")
        query.whereKey("objectId", equalTo: objectIdField.text!)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print(object)
        }
        ```

   - Job Details Screen
      - (Read/GET) Fetches the details for a specific job id
        ```swift
        let query = PFQuery(className: “Jobs”)
        query.whereKey(“objectId”, equalTo: objectIdField.text!)
        query.findObjectsInBackground{ (objects: [PFObject]?, error: Error?) in
            If let error = error {
                print(error.localizedDescription)
            } else {
                print(object)
            }
        }
        ```

      - (Update/PATCH) Manager users can manually update the status of a job
        ```swift
        let query = PFQuery(className:"Jobs")
        query.getObjectInBackground(withId: objectIdField.text!) { (job: PFObject?,     error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let job = job {
                job[“status”] = statusField.text!
                job["updatedAt"] = descriptionField.text!
                job.saveInBackground()
            }
        }
        ```

      - (Update/PATCH) Manager users can update the description field
        ```swift
        let date = Date()
        let df = DateFormatter() df.dateFormat = "MM/dd/yyyy HH:mm:ss" 
        let dateTime = df.string(from: date)
        let query = PFQuery(className:"Jobs")

        query.getObjectInBackground(withId: objectIdField.text!) { (job: PFObject?,     error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let job = job {
                job["description"] = descriptionField.text!
                job["updatedAt"] = dateTime
                job.saveInBackground()
            }
        }
        ```


      - (Update/ PATCH) Users assigned to this job can update the status of a task 
         ```swift
         let date = Date()
         let df = DateFormatter() df.dateFormat = "MM/dd/yyyy HH:mm:ss" 
         let dateTime = df.string(from: date)
         let query = PFQuery(className:"Jobs")

        query.getObjectInBackground(withId: objectIdField.text!) { (job: PFObject?,     error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let job = job {
                job[“status”] = statusField.text!
                job["updatedAt"] = dateTime
                job.saveInBackground()
            }
        }
        ```


   - Job Comments Screen
      - (Read/GET) Get all the job comments for the selected job id
        ```swift
        let query = PFQuery(className: “JobComment”)
        query.whereKey(“job_id” equalTo: Job.objectId)
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground{ (objects: [PFObject]?, error: Error?) in
            If let error = error {
                print(error.localizedDescription)
            } else {
                print(object)
            }
        }
        ```

      - (Create/POST) Create a new comment for the selected job id
        ```swift
        let date = Date()
        let df = DateFormatter() df.dateFormat = "MM/dd/yyyy HH:mm:ss" 
        let dateTime = df.string(from: date)

        let comment = PFObject(className: “JobComment”)
        comment [“objectId ”] = NSUUID().uuidString
        comment [“createdAt  ”] = dateTime 
        comment [“job_id ”] = job.job_id
        comment [“user_id ”] = job.user_id
        comment [“comment”] = commentField.text!

        commment.saveInBackground {(success, error) in
            If success {
                print(“Successful”)
            } else {
                print(“Error”)
        }
        ```
