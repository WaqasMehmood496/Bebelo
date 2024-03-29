//
//  MapViewController.swift
//  Bebelo
//
//  Created by Buzzware Tech on 05/07/2021.
//

import UIKit
import CoreLocation
import GoogleMaps
import SemiModalViewController

class MapViewController: UIViewController {
    
    //IBOUTLET'S
    @IBOutlet weak var MapView: GMSMapView!
    
    //VARIABLE'S
    let markImage = "Group 21"
    let locationIncrement = 0.00000000000000002
    let distanceFilter: CLLocationDistance = 50
    let geocoder = GMSGeocoder()
    let initialLatLng = 0.0
    let controllerXYPosition: CGFloat = 0.0
    var locationManager = CLLocationManager()
    var zoomLevel: Float = 14.0
    var userLocationMarker = GMSMarker()
    var lat = 33.678865546455455
    var lng = 73.00183612438818
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userLocationSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? SelectedBarDetailViewController{
            controller.delegate = self
            controller.isPreviousClose = true
        }
    }
}

//MARK:- DELEGATES METHODS
extension MapViewController{
    
    func showFullView() {
        //This will show Bar detail view controller in full screen.
        self.performSegue(withIdentifier: "ShowDetail", sender: nil)
    }
    
}

//MARK:- Helping Method's
extension MapViewController{
    
    func userLocationSetup() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = distanceFilter
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        locationManager.delegate = self
        let camera = GMSCameraPosition.camera(
            withLatitude: initialLatLng,
            longitude: initialLatLng,
            zoom: zoomLevel
        )
        MapView.camera = camera
        MapView.settings.myLocationButton = false
        MapView.isMyLocationEnabled = true
        MapView.delegate = self
    }
    
    func placeMarkOnGoogleMap(location:CLLocation) {
        lat = location.coordinate.latitude
        lng = location.coordinate.longitude
        
        for _ in 0..<2{
            lng = lng + locationIncrement
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: self.lat, longitude: self.lng))
            marker.map = self.MapView
            marker.icon = UIImage(named: markImage)
        }
    }
    
    //    func RadiansToDegrees(radians: Double) -> Double {
    //        return radians * 190.0/M_PI
    //    }
    //
    //    func DegreesToRadians(degrees: Double) -> Double {
    //        return degrees * M_PI / 180.0
    //    }
    //
    
    func getViewController(identifier:String)-> UIViewController {
        let vc = UIStoryboard.init(name: Constant.mainStoryboard, bundle: Bundle.main).instantiateViewController(identifier: identifier)
        return vc
    }
    
    func showBarDetailInSemiModel() {
        let options: [SemiModalOption : Any] = [
            SemiModalOption.pushParentBack: false
        ]
        let storyboard = UIStoryboard (
            name: Constant.mainStoryboard,
            bundle: nil
        )
        let identifier = String (
            describing: Constant.selectedBarDetailIdentifier
        )
        let controller = storyboard.instantiateViewController (
            withIdentifier: identifier
        ) as! SelectedBarDetailViewController
        
        controller.view.frame = CGRect (
            x: controllerXYPosition, y: controllerXYPosition,
            width: UIScreen.main.bounds.width,
            height: self.view.frame.height / 2
        )
        controller.isBarItemHide = true
        presentSemiViewController(
            controller,
            options: options,
            completion: {
                //Completed
                
                controller.delegate = self
            }, dismissBlock: {
                //Dismissed!
            })
    }
}


// MARK:- LOCATION METHOD'S EXTENSION
extension MapViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        
        let camera = GMSCameraPosition.camera(
            withLatitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            zoom: zoomLevel
        )
        self.MapView.camera = camera
        self.MapView.animate(to: camera)
        
        //Change current/my location icon
        //        userLocationMarker = GMSMarker(position: location.coordinate)
        //        userLocationMarker.icon = UIImage(named: "Me")
        //        userLocationMarker.rotation = CLLocationDegrees(m)
        userLocationMarker.map = self.MapView
        self.placeMarkOnGoogleMap(location: location)
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            PopupHelper.alertWithAppSetting(title: "Alert", message: "Please enable your location", controler: self)
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        @unknown default:
            print("Unknown case found")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    //    //MARK: CHANGE CURRENT LOCATION ICON DEGREE FOR ROUTATION
    //    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    //        let direction = -newHeading.trueHeading as Double
    //        userLocationMarker.icon = self.imageRotatedByDegrees(degrees: CGFloat(direction), image: UIImage(named: "Me")!)
    //    }
    //
    //    func imageRotatedByDegrees(degrees: CGFloat, image: UIImage) -> UIImage{
    //        let size = image.size
    //
    //        UIGraphicsBeginImageContext(size)
    //        let context = UIGraphicsGetCurrentContext()
    //
    //        context!.translateBy(x: 0.5*size.width, y: 0.5*size.height)
    //        context!.rotate(by: CGFloat(DegreesToRadians(degrees: Double(degrees))))
    //
    //        image.draw(in: CGRect(origin: CGPoint(x: -size.width*0.5, y: -size.height*0.5), size: size))
    //        let newImage = UIGraphicsGetImageFromCurrentImageContext()
    //        UIGraphicsEndImageContext()
    //
    //        return newImage!
    //    }
    //
    //    func setLatLonForDistanceAndAngle(userLocation: CLLocation) -> Double {
    //        let lat1 = DegreesToRadians(degrees: userLocation.coordinate.latitude)
    //        let lon1 = DegreesToRadians(degrees: userLocation.coordinate.longitude)
    //
    //        let lat2 = DegreesToRadians(degrees: 37.7833);
    //        let lon2 = DegreesToRadians(degrees: -122.4167);
    //
    //        let dLon = lon2 - lon1;
    //
    //        let y = sin(dLon) * cos(lat2);
    //        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    //        var radiansBearing = atan2(y, x);
    //        if(radiansBearing < 0.0)
    //        {
    //            radiansBearing += 2*M_PI;
    //        }
    //
    //        return radiansBearing;
    //    }
}


extension MapViewController:GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        //mapView.clear()
        
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        //        mapView.selectedMarker = marker
        //        let camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: zoomLevel)
        //        let update = GMSCameraUpdate.setCamera(camera)
        //        mapView.animate(with: update)
        
        //        let vc = self.getViewController(identifier: "SelectedBarDetailViewController") as! SelectedBarDetailViewController
        //        self.performSegue(withIdentifier: "ShowDetail", sender: nil)
        
        self.showBarDetailInSemiModel()
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        //    self.lblAddress.text = marker.title
        //    self.curentPosition = marker.position
        //    self.gotoBack()
        
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        //reverseGeocodeCoordinate(position.target)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        // 1
        let geocoder = GMSGeocoder()
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            // 3
            //    self.lblAddress.text = lines.joined(separator: "\n")
            //    self.curentPosition = address.coordinate
            // 4
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
            self.MapView.animate(toLocation: address.coordinate)
        }
    }
}
