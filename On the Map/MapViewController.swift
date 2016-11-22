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
    var appDelegate: AppDelegate!
    var studentLocations = [StudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.retrieveData()
        
        for student in studentLocations {
            
            var studentLatitude: CLLocationDegrees
            var studentLongitude: CLLocationDegrees
            var first: String
            var last: String
            var mediaURL: String
            
            if let lat = student.latitude {
                studentLatitude = CLLocationDegrees(lat)
            } else {
                continue
            }
            
            if let long = student.longitude {
                studentLongitude = CLLocationDegrees(long)
            } else {
                continue
            }
            
            if let firstName = student.firstName {
                first = firstName
            } else {
                continue
            }
            
            if let lastName = student.lastName {
                last = lastName
            } else {
                continue
            }
            
            if let media = student.mediaUrl {
                mediaURL = media
            } else {
                continue
            }
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: studentLatitude, longitude: studentLongitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        self.mapOutlet.addAnnotations(annotations)
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
            if let toOpen = view.annotation?.subtitle! {
                let url = URL(fileURLWithPath: toOpen)
                let options = [String: Any]()
                app.open(url, options: options , completionHandler: nil)
            }
        }
    }

    func retrieveData() {
        
        ParseClient.sharedInstance().populateStudentLocationStructArray(limitResults: Constants.ParseApiQueryValues.limitNumber){(success, error) in
            performUIUpdatesOnMain {
                if success {
                    self.studentLocations = self.appDelegate.studentLocationDataStructArray
                    
                } else {
                    print(error?.userInfo[NSLocalizedDescriptionKey] as! String)
                }
            }
        }
    }

}


