//
//  MapViewController.swift
//  On the Map
//
//  Created by Dr GJK Marais on 2016/11/21.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import MapKit
import UIKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapOutlet: MKMapView!
    var annotations = [MKPointAnnotation]()
    
    var alert: UIAlertController?
    var alertNetwork: UIAlertController?
    var alertLogout: UIAlertController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertNetwork = UIAlertController(title: Constants.AlertNetwork.failed, message: Constants.AlertNetwork.connection, preferredStyle: .alert)
        alert = UIAlertController(title: Constants.AlertStrings.title, message: Constants.AlertStrings.body, preferredStyle: .alert)
        alertLogout = UIAlertController(title: Constants.AlertNetwork.failedLogout, message: Constants.AlertNetwork.connection, preferredStyle: .alert)
        
        let networkFail = UIAlertAction(title: Constants.AlertNetwork.accept, style: .cancel, handler: nil)
        let replaceAction = UIAlertAction(title: Constants.AlertStrings.replace, style: .default){(parameter) in
            self.presentPinInputController(pinReplace: true)
        }
        let noReplaceAction = UIAlertAction(title: Constants.AlertStrings.noReplace, style: .default){(parameter) in
            self.presentPinInputController(pinReplace: false)
        }
        let logoutFail = UIAlertAction(title: Constants.AlertNetwork.accept, style: .cancel, handler: nil)
        
        alert?.addAction(replaceAction)
        alert?.addAction(noReplaceAction)
        alertNetwork?.addAction(networkFail)
        alertLogout?.addAction(logoutFail)
        
        populateMap()
        
    }
    
    // shows the annotation just placed
    override func viewWillAppear(_ animated: Bool) {
        
        if let placemarkPin = DataStorage.sharedInstance.placemark {
            var region: MKCoordinateRegion = self.mapOutlet.region
            region.center = (placemarkPin.coordinate)
            region.span.longitudeDelta /= 8.0
            region.span.latitudeDelta /= 8.0
            self.mapOutlet.setRegion(region, animated: true)
            
            if (DataStorage.sharedInstance.ownStudent.studentLocationInfo["objectId"] != nil) {
                let annotation = MKPointAnnotation()
                var firstName = ""
                var lastName = ""
                if let name = DataStorage.sharedInstance.ownStudent.studentLocationInfo["firstName"] {
                    firstName = name as! String
                }
                if let name = DataStorage.sharedInstance.ownStudent.studentLocationInfo["lastName"] {
                    lastName = name as! String
                }
                annotation.coordinate = (placemarkPin.coordinate)
                annotation.title = "\(firstName) \(lastName)"
                if let link = DataStorage.sharedInstance.ownStudent.studentLocationInfo["mediaURL"] {
                    annotation.subtitle = link as! String
                } else {
                    annotation.subtitle = ""
                }
                self.mapOutlet.addAnnotation(annotation)
            }
        }
        
    }
    
    @IBAction func refreshMap(_ sender: Any) {
        populateMap()
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
    
    @IBAction func newPin(_ sender: Any) {
        
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

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            var url: URL?
            let options = [String: Any]()
            
            if let toOpen = view.annotation?.subtitle {
                if (toOpen?.contains("http"))! {
                    url = URL(string: toOpen!)
                } else {
                    url = URL(string: "https://" + toOpen!)
                }
            }
            
            if let urlFound = url {
                performUIUpdatesOnMain {
                    app.open(urlFound, options: options , completionHandler: nil)
                }
            }
        }
    }
    
    func populateMap() {
        
        ParseClient.sharedInstance.populateStudentLocationStructArray(limitResults: Constants.ParseApiQueryValues.limitNumber){(success, error) in
            performUIUpdatesOnMain {
                if success {
                    for student in DataStorage.sharedInstance.studentLocationDataStructArray {
                        
                        var studentLatitude: CLLocationDegrees
                        var studentLongitude: CLLocationDegrees
                        var first: String
                        var last: String
                        var mediaURL: String
                        
                        if let lat = student.studentLocationInfo["latitude"] {
                            studentLatitude = CLLocationDegrees(lat as! Float)
                        } else {
                            continue
                        }
                        
                        if let long = student.studentLocationInfo["longitude"] {
                            studentLongitude = CLLocationDegrees(long as! Float)
                        } else {
                            continue
                        }
                        
                        if let firstName = student.studentLocationInfo["firstName"] {
                            first = firstName as! String
                        } else {
                            continue
                        }
                        
                        if let lastName = student.studentLocationInfo["lastName"] {
                            last = lastName as! String
                        } else {
                            continue
                        }
                        
                        if let media = student.studentLocationInfo["mediaURL"] {
                            mediaURL = media as! String
                        } else {
                            continue
                        }
                        
                        // The lat and long are used to create a CLLocationCoordinates2D instance.
                        let coordinate = CLLocationCoordinate2D(latitude: studentLatitude, longitude: studentLongitude)
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = coordinate
                        annotation.title = "\(first) \(last)"
                        annotation.subtitle = mediaURL
                        
                        self.annotations.append(annotation)
                    }
                    
                    self.mapOutlet.addAnnotations(self.annotations)
                    
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


