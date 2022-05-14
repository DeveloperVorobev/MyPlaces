//
//  MapVC.swift
//  MyPlaces
//
//  Created by Владислав Воробьев on 08.05.2022.
//

import UIKit
import MapKit
import CoreLocation

protocol MapVCDelegate{
    func getAddress(_ address: String?)
}

class MapVC: UIViewController {
    
    var mapVCDelegate: MapVCDelegate?
    var place = Place()
    var placeCoordinate: CLLocationCoordinate2D?
    let alternateRoutes = false
    var previousLocation: CLLocation?{
        didSet {
            startTrackingUserLocation()
        }
    }
    var directionsArray: [MKDirections] = []
    let annotationIdentifire = "annotationIdentifire"
    let locationManager = CLLocationManager()
    let regionInMeters = 1_000.00
    var incomeSegueIdentifer = ""
    var debugGCDBoolValue = true
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var mapPinImage: UIImageView!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var goButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupMapView()
        checLocationServices()
        addressLabel.text = ""
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checLocationServices()
    }
    @IBAction func clouseVC() {
        dismiss(animated: true)
    }
    @IBAction func centerViewInUserLocation() {
        showUserLocation()
    }
    @IBAction func goButtonPresed() {
       getDirections(isNotTracking: true)
    }
    @IBAction func doneButtonPressed() {
        mapVCDelegate?.getAddress(addressLabel.text)
        dismiss(animated: true)
    }
    private func setupMapView(){
        
        goButton.isHidden = true
        
        if incomeSegueIdentifer == "showPlace" {
            setupPlaceMark()
            mapPinImage.isHidden = true
            addressLabel.isHidden = true
            doneButton.isHidden = true
            goButton.isHidden = false
        }
    }
    
    private func resetMapView(withNew directions: MKDirections){
        
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel() }
        directionsArray.removeAll()
        
    }
    
    private func setupPlaceMark(){
        guard let location = place.location else {return}
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { placeMarks, error in
            if let error = error{
                print(error)
                return
            }
            guard let placeMarks = placeMarks else {return}
            let placemark = placeMarks.first
            let annotation = MKPointAnnotation()
            annotation.title = self.place.name
            annotation.subtitle = self.place.type
            guard let placemarkLocation = placemark?.location else {return}
            annotation.coordinate = placemarkLocation.coordinate
            self.placeCoordinate = placemarkLocation.coordinate
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
            
        }
    }
    private func checLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            chekLocationAutorization()
        } else{
            showAlert()
        }
    }
    private func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    private func chekLocationAutorization(){
        let recallLocationManager = CLLocationManager()
        switch recallLocationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            showAlert()
            break
        case .denied:
            showAlert()
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if incomeSegueIdentifer == "getAddress" { showUserLocation()}
            break
        @unknown default:
            print("New authorizationStatus")
        }
    }
    private func showAlert(){
        let alertController = UIAlertController(title: "Ошибка доступа к геолокации", message: "Для корректной работы служб геолокации необходимо разрешить доступ приложения в слуббам геолокации через настройки или попробуйте позже", preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(actionOK)
        present(alertController, animated: true, completion: nil)
    }
    
    private func getCenterLocation (for mapView: MKMapView) -> CLLocation {
        
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    private func showUserLocation(){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func getDirections(isNotTracking: Bool){
        
        guard let location = locationManager.location?.coordinate else {
            showAlert()
            return
        }
        
       
        if isNotTracking {
            locationManager.startUpdatingLocation()
            previousLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        }
        
        guard let request = createDirectionRequest(from: location) else {return}
        
        let directions = MKDirections(request: request)
        resetMapView(withNew: directions)
        
        directions.calculate { response, error in
            if let error = error {
                print(error)
                return
            }
            guard let response = response else {return}
            
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                
                if isNotTracking{
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                }
                
                let distance = String(format: "%.1f", route.distance / 1000)
                let timeInterval = route.expectedTravelTime / 60
                
                print("Distanse: \(distance) km.")
                print("Time interval: \(timeInterval) min.")
                
            }
        }
    }
    
    private func createDirectionRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request?{
    
        guard let destinatonCordinate = placeCoordinate else {return nil}
        let source = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinatonCordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: source)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        request.requestsAlternateRoutes = alternateRoutes
        
        return request
    }
    
    private func startTrackingUserLocation(){
        self.getDirections(isNotTracking: false)
    }
}

extension MapVC: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {return nil}
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifire) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifire)
            annotationView?.canShowCallout = true
        }
        if let imageData = place.imageData {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: imageData)
            annotationView?.rightCalloutAccessoryView = imageView
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        if incomeSegueIdentifer == "showPlace" && previousLocation != nil && debugGCDBoolValue{

            debugGCDBoolValue = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.showUserLocation()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    self.debugGCDBoolValue = true
                }
                
            }
            
        }
        
        geoCoder.cancelGeocode()
        
        geoCoder.reverseGeocodeLocation(center){ (placemarks, error) in
            
            if let error = error{
                print(error)
                return
            }
            
            guard let placemarks = placemarks else {return}
            
            let placeMark = placemarks.first
            let streetName = placeMark?.thoroughfare
            let buildNumber = placeMark?.subThoroughfare
            
            DispatchQueue.main.async {
                
                if streetName != nil && buildNumber != nil{
                    self.addressLabel.text = "\(streetName!), \(buildNumber!)"
                } else if streetName != nil{
                    self.addressLabel.text = "\(streetName!)"
                } else{
                    self.addressLabel.text = ""
                }
            }
        }
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue.withAlphaComponent(0.2)
        
        return renderer
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let previousLocation = previousLocation else {return}
        let curentLoction = locations.last
        if let distanceToCurentLocation = curentLoction?.distance(from: previousLocation){
            guard distanceToCurentLocation > 15 else {return}
            self.previousLocation = curentLoction
            print("didUpdate")
        }
    }
}
extension MapVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        chekLocationAutorization()
    }
}
