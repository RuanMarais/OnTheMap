//
//  LoginViewController.swift
//  On the Map
//
//  Created by Dr GJK Marais on 2016/11/13.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Properties UI login
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    var alertConnection: UIAlertController?
    var alertAccountDetails: UIAlertController?
    var keyboardOnScreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        subscribeKeyboardNotifications()
        resignFirstResponderWhenTapped()
        
        //controllers for failed network connection
        
        alertConnection = UIAlertController(title: Constants.AlertLogin.failed , message: Constants.AlertLogin.connectionAbsent, preferredStyle: .alert)
        alertAccountDetails = UIAlertController(title: Constants.AlertLogin.failed, message: Constants.AlertLogin.incorrectDetails, preferredStyle: .alert)
        
        let NoNetwork = UIAlertAction(title: Constants.AlertLogin.retryLogin, style: .cancel){(parameter) in
            self.setUIEnabled(enabled: true)
        }
        let incorrectLogin = UIAlertAction(title: Constants.AlertLogin.retryLogin, style: .cancel){(parameter) in
            self.setUIEnabled(enabled: true)
        }
        
        alertConnection?.addAction(NoNetwork)
        alertAccountDetails?.addAction(incorrectLogin)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUIEnabled(enabled: true)
        usernameTextField.text = ""
        passwordTextField.text = ""
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeToAllNotifications()
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        userDidTapView(sender: self)
        
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            self.present(alertAccountDetails!, animated: true, completion: nil)
        } else {
            setUIEnabled(enabled: false)
            UdacityClient.sharedInstance.getSessionAndUserID(username: usernameTextField.text!, password: passwordTextField.text!){(success, error) in
                performUIUpdatesOnMain {
                    if success {
                        self.completeLogin()
                    } else {
                        
                        if (error?.userInfo[NSLocalizedDescriptionKey] as! String == "Status code not 2xx") {
                            self.present(self.alertAccountDetails!, animated: true, completion: nil)
                        } else {
                            self.present(self.alertConnection!, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
       
    @IBAction func signUpUdacity(_ sender: Any) {
        
        let url = URL(string: Constants.signUp.udacitySignUp)!
        performUIUpdatesOnMain {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func completeLogin() {
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        
        UdacityClient.sharedInstance.getUdacityStudentDetails() {(success, error) in
            performUIUpdatesOnMain {
                if success {
                    self.present(controller, animated: true, completion: nil)
                } else {
                    
                    print(error?.userInfo[NSLocalizedDescriptionKey] as! String)
                }
            }
        }
    }
}

extension LoginViewController {
    
    private func configureBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [Constants.UIValues.loginColorTop, Constants.UIValues.loginColorBottom]
        gradient.locations = [0.0, 1.0]
        gradient.frame = view.frame
        view.layer.insertSublayer(gradient, at: 0)
        
    }
    
    private func configureTextField(textField: UITextField) {
        
        let textFieldPaddingViewFrame = CGRect(x: 0.0, y: 0.0, width: 13.0, height: 0.0)
        let textFieldPaddingView = UIView(frame: textFieldPaddingViewFrame)
        textField.leftView = textFieldPaddingView
        textField.leftViewMode = .always
        
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        textField.autocorrectionType = UITextAutocorrectionType.no
        
        textField.delegate = self
    }
    
    func setUIEnabled(enabled: Bool) {
        usernameTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
        
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    func configureUI() {
        configureBackground()
        configureTextField(textField: usernameTextField)
        configureTextField(textField: passwordTextField)
        titleLabel.textColor = UIColor.white
    }

}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Show/Hide Keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        if !keyboardOnScreen {
            let height = keyboardHeight(notification: notification)
            view.frame.origin.y -= height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification: notification)
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(notification: NSNotification) {
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    private func resignIfFirstResponder(textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    func resignFirstResponderWhenTapped() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userDidTapView(sender:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func userDidTapView(sender: AnyObject) {
        resignIfFirstResponder(textField: usernameTextField)
        resignIfFirstResponder(textField: passwordTextField)
    }
}

// Subscbribe to notifications to allow for keyboard

extension LoginViewController {
    
    func subscribeToNotification(notification: String, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name(rawValue: notification), object: nil)
    }
    
    func unsubscribeToAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func subscribeKeyboardNotifications() {
        
        subscribeToNotification(notification: NSNotification.Name.UIKeyboardWillShow.rawValue, selector: #selector(keyboardWillShow(notification:)) )
        subscribeToNotification(notification: NSNotification.Name.UIKeyboardDidShow.rawValue, selector: #selector(keyboardDidShow(notification:)) )
        subscribeToNotification(notification: NSNotification.Name.UIKeyboardWillHide.rawValue, selector: #selector(keyboardWillHide(notification:)) )
        subscribeToNotification(notification: NSNotification.Name.UIKeyboardDidHide.rawValue, selector: #selector(keyboardDidHide(notification:)) )
    }
    
}


