//
//  NewPinInputViewController.swift
//  On the Map
//
//  Created by Dr GJK Marais on 2016/11/22.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import UIKit
import MapKit

class NewPinInputViewController: UIViewController {
   
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var showMapButton: UIButton!
    @IBOutlet weak var pinInputLabel: UILabel!
    @IBOutlet weak var pinInputTextfield: UITextField!
    
    @IBOutlet weak var navBar: UINavigationBar!
    var replace: Bool = false
    var keyboardOnScreen = false
   
    var alert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alert = UIAlertController(title: Constants.AlertNetwork.failedGeocode, message: Constants.AlertNetwork.failedGeocode, preferredStyle: .alert)
        let networkFail = UIAlertAction(title: Constants.AlertNetwork.accept, style: .cancel){(parameter) in
            self.setUIEnabled(enabled: true)
        }
        
        alert?.addAction(networkFail)
        
        configureUI()
        subscribeKeyboardNotifications()
        resignFirstResponderWhenTapped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setUIEnabled(enabled: true)
    }
    
    @IBAction func cancelInputPin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showPinOnMap(_ sender: Any) {
        
        self.setUIEnabled(enabled: false)
        showActivity()
        userDidTapView(sender: self)
        
        if (!pinInputTextfield.text!.isEmpty) {
            geoCodeDataAndSegue(locationString: pinInputTextfield.text!)
        } else {
            self.setUIEnabled(enabled: true)
        }
    }
}

extension NewPinInputViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Show/Hide Keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification: notification)
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
        resignIfFirstResponder(textField: pinInputTextfield)
    }
    
}

extension NewPinInputViewController {
    
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

extension NewPinInputViewController {
    
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
        
        textField.delegate = self
    }
    
    func configureUI() {
        configureBackground()
        configureTextField(textField: pinInputTextfield)
        pinInputLabel.textColor = UIColor.white
        navBar.barTintColor = Constants.UIValues.ColorLight
        
    }
    
    func presentPinMapController(pinReplace: Bool) {
        self.dismiss(animated: true, completion: nil)
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "newPinMap") as! NewPinMapViewViewController
        controller.replace = pinReplace
        self.present(controller, animated: true, completion: nil)
    }
    
    func setUIEnabled(enabled: Bool) {
        pinInputTextfield.isEnabled = enabled
        showMapButton.isEnabled = enabled
        activity.stopAnimating()
        activity.isHidden = enabled
        
        if enabled {
            showMapButton.alpha = 1.0
        } else {
            showMapButton.alpha = 0.5
        }
    }
    
    func showActivity() {
        self.activity.isHidden = false
        self.activity.startAnimating()
    }
 
    func geoCodeDataAndSegue (locationString: String) {
        
        showActivity()
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationString) {(placemarks, error) in
            performUIUpdatesOnMain {
                guard (error == nil) else {
                    self.present(self.alert!, animated: true, completion: nil)
                    return
                }
                
                if ((placemarks?.count)! > 0) {
                    let top: CLPlacemark = (placemarks?[0])!
                    let placemark: MKPlacemark = MKPlacemark(placemark: top)
                    
                    DataStorage.sharedInstance.placemark = placemark
                    DataStorage.sharedInstance.ownStudent.studentLocationInfo["mapString"] = locationString as AnyObject?
                    DataStorage.sharedInstance.ownStudent.studentLocationInfo["latitude"] = placemark.coordinate.latitude.binade as AnyObject?
                    DataStorage.sharedInstance.ownStudent.studentLocationInfo["longitude"] = placemark.coordinate.longitude.binade as AnyObject?

                    self.presentPinMapController(pinReplace: self.replace)
                    
                } else {
                    self.present(self.alert!, animated: true, completion: nil)
                }

            }
        }
    }

}


