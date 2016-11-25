//
//  StudentLocationTableViewController.swift
//  On the Map
//
//  Created by Dr GJK Marais on 2016/11/21.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import UIKit

class StudentLocationTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var appDelegate: AppDelegate!
    var studentLocations = [StudentLocation]()
    @IBOutlet weak var studentLocationsTableView: UITableView!
    var alertNetwork: UIAlertController?
    var alertURL: UIAlertController?
    var alert: UIAlertController?
    var alertLogout: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alert = UIAlertController(title: Constants.AlertStrings.title, message: Constants.AlertStrings.body, preferredStyle: .alert)
        alertURL = UIAlertController(title: Constants.AlertUrl.failed, message: Constants.AlertUrl.message, preferredStyle: .alert)
        alertNetwork = UIAlertController(title: Constants.AlertNetwork.failedTable, message: Constants.AlertNetwork.connection, preferredStyle: .alert)
        alertLogout = UIAlertController(title: Constants.AlertNetwork.failedLogout, message: Constants.AlertNetwork.connection, preferredStyle: .alert)
        let networkFail = UIAlertAction(title: Constants.AlertNetwork.accept, style: .cancel, handler: nil)
        let UrlFail = UIAlertAction(title: Constants.AlertNetwork.accept, style: .cancel, handler: nil)
        let replaceAction = UIAlertAction(title: Constants.AlertStrings.replace, style: .default){(parameter) in
            self.presentPinInputController(pinReplace: true)
        }
        let noReplaceAction = UIAlertAction(title: Constants.AlertStrings.noReplace, style: .default){(parameter) in
            self.presentPinInputController(pinReplace: false)
        }
        let logoutFail = UIAlertAction(title: Constants.AlertNetwork.accept, style: .cancel, handler: nil)

        alertNetwork?.addAction(networkFail)
        alertURL?.addAction(UrlFail)
        alert?.addAction(replaceAction)
        alert?.addAction(noReplaceAction)
        alert?.addAction(logoutFail)

        appDelegate = UIApplication.shared.delegate as! AppDelegate
        studentLocations = self.appDelegate.studentLocationDataStructArray
        retrieveDataReloadTable()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.studentLocationsTableView.reloadData()
    }

    @IBAction func refreshTable(_ sender: Any) {
        retrieveDataReloadTable()
    }
    
    @IBAction func logout(_ sender: Any) {
        
        UdacityClient.sharedInstance.attemptLogout(){(success, error) in
            performUIUpdatesOnMain {
                if success {
                    self.presentLoginController()
                } else {
                    self.present(self.alertLogout!, animated: true, completion: nil)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let app = UIApplication.shared
        var url: URL?
        let options = [String: Any]()
        let studentLocationArrayItem = studentLocations[indexPath.row]

        
        if let toOpen = studentLocationArrayItem.mediaUrl {
            if (toOpen.contains("http")) {
                url = URL(string: toOpen)
            } else {
                url = URL(string: "https://" + toOpen)
            }
        } else {
            self.present(self.alertURL!, animated: true, completion: nil)
        }
        
        if let urlFound = url {
            performUIUpdatesOnMain {
                app.open(urlFound, options: options , completionHandler: nil)
            }
        } else {
                self.present(self.alertURL!, animated: true, completion: nil)
        }
    }
    
    @IBAction func postPin(_ sender: Any) {
        
        ParseClient.sharedInstance.checkPinPresent(){(success, error) in
            performUIUpdatesOnMain {
                if success {
                    self.present(self.alert!, animated: true, completion: nil)
                } else {
                    self.presentPinInputController(pinReplace: false)
                }
            }
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.studentLocationDataStructArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellReuseidentifier = "BasicCellLocationPin"
        let studentLocationArrayItem = studentLocations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseidentifier) as UITableViewCell!
        
        var firstName: String
        var lastName: String
        
        if let name = studentLocationArrayItem.firstName {
            firstName = name
        } else {
            firstName = "Unknown"
        }
        
        if let last = studentLocationArrayItem.lastName {
            lastName = last
        } else {
            lastName = "Unknown"
        }
        
        cell?.textLabel?.text = "\(firstName) \(lastName)"
        
        return cell!
    }
    
    func retrieveDataReloadTable() {
        ParseClient.sharedInstance.populateStudentLocationStructArray(limitResults: Constants.ParseApiQueryValues.limitNumber){(success, error) in
            performUIUpdatesOnMain {
                if success {
                    self.studentLocations = self.appDelegate.studentLocationDataStructArray
                    self.studentLocationsTableView!.reloadData()
                } else {
                    self.present(self.alertNetwork!, animated: true, completion: nil)
                    print(error?.userInfo[NSLocalizedDescriptionKey] as! String)
                }
            }
        }
    }
    
    func presentPinInputController(pinReplace: Bool) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "NewPinInput") as! NewPinInputViewController
        controller.replace = pinReplace
        self.present(controller, animated: true, completion: nil)
    }
    
    func presentLoginController() {
        self.dismiss(animated: true, completion: nil)
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "login") as! LoginViewController
        self.present(controller, animated: true, completion: nil)
    }
}
