//
//  MapViewController.swift
//  RED360
//
//  Created by Argo Solucoes on 20/11/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class MapViewController: SlideViewController {
    
    @IBOutlet weak var map: MKMapView!
    var location: GeoPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTitle("Local")
        let doneItem = UIBarButtonItem(image: #imageLiteral(resourceName: "closeIcon"), style: .done, target: nil, action: #selector(closeAction))
        doneItem.tintColor = UIColor.white
        self.navItem?.leftBarButtonItem = doneItem;
        
        set(location: location)
    }
    
    @objc func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func set(location: GeoPoint?){
        guard let loc = location else {return}
        self.location = loc
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)
        map.addAnnotation(annotation)
        
        let pinToZoomOn = annotation
        let span = MKCoordinateSpanMake(0.03, 0.03)
        
        let region = MKCoordinateRegion(center: pinToZoomOn.coordinate, span: span)
        map.setRegion(region, animated: true)
        
    }
}
