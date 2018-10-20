//
//  MapViewController.swift
//  CitySearch
//
//  Created by Usman Siddiqui on 10/20/18.
//  Copyright © 2018 Usman_Siddiqui. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    var city : City?
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let city = city else {return}
        showAnnotation(city: city)
        self.title = "\(String(describing: city.name)), \(String(describing: city.country))"
        
        // Do any additional setup after loading the view.
    }
    
    func showAnnotation(city: City) {
        
        if let lat =  city.coord["lat"], let lon = city.coord["lon"] {
            let location = CLLocationCoordinate2D(latitude: lat,
                                                  longitude: lon)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            mapView.addAnnotation(annotation)
            
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
