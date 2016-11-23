//
//  NewPinMapViewViewController.swift
//  On the Map
//
//  Created by Dr GJK Marais on 2016/11/22.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import UIKit
import MapKit

class NewPinMapViewViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var postPin: UIBarButtonItem!
    @IBOutlet weak var mediaLinkTextfield: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    var replace = false
    var appDelegate: AppDelegate!
    var keyboardOnScreen = false
    var alert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        configureUI()
        subscribeKeyboardNotifications()
        self.resignFirstResponderWhenTapped()
        
        alert = UIAlertController(title: Constants.PostingAlerts.noLinkTitle , message: Constants.PostingAlerts.noLinkPrompt, preferredStyle: .alert)
        
        let continueNoLink = UIAlertAction(title: Constants.PostingAlerts.continueNoLink, style: .default){(parameter) in
            self.appDelegate.student?.mediaUrl = ""
            self.postPinNetwork()
        }
        let addLink = UIAlertAction(title: Constants.PostingAlerts.addLink, style: .cancel, handler: nil)
        
        alert?.addAction(continueNoLink)
        alert?.addAction(addLink)
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        var region: MKCoordinateRegion = self.mapView.region
        region.center = (appDelegate.placemark?.coordinate)!
        region.span.longitudeDelta /= 8.0
        region.span.latitudeDelta /= 8.0
        self.mapView.setRegion(region, animated: true)
        self.mapView.addAnnotation(appDelegate.placemark!)
    }

    @IBAction func cancelPin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postPin(_ sender: Any) {
        
        userDidTapView(sender: self)
        postPin.isEnabled = false
        
        if mediaLinkTextfield.text!.isEmpty {
            
            self.present(self.alert!, animated: true, completion: nil)
        } else {
            
            appDelegate.student?.mediaUrl = mediaLinkTextfield.text
            postPinNetwork()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

}

extension NewPinMapViewViewController: UITextFieldDelegate {
    
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
        resignIfFirstResponder(textField: mediaLinkTextfield )
    }
    
}

extension NewPinMapViewViewController {
    
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

extension NewPinMapViewViewController {
    
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
        configureTextField(textField: mediaLinkTextfield)
        
    }
    
    func postPinNetwork() {
        ParseClient.sharedInstance().postPin(replace: replace, student: appDelegate.student!){(success, error) in
            performUIUpdatesOnMain {
                if success {
                    self.presentMapController()
                    print("success")
                } else {
                    self.postPin.isEnabled = true
                }
            }
        
        }
    }
    
    func presentMapController() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        self.present(controller, animated: true, completion: nil)
    }

}

