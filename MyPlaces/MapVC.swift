//
//  MapVC.swift
//  MyPlaces
//
//  Created by Владислав Воробьев on 08.05.2022.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController {
    
    var place = Place()
    let annotationIdentifire = "annotationIdentifire"
    let locationManager = CLLocationManager()
    let regionInMeters = 5_000.00
    var incomeSegueIdentifer = ""
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var mapPinImage: UIImageView!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var adressLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupMapView()
        checLocationServices()
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
    @IBAction func doneButtonPressed() {
    }
    private func setupMapView(){
        if incomeSegueIdentifer == "showPlace" {
            setupPlaceMark()
            mapPinImage.isHidden = true
            adressLabel.isHidden = true
            doneButton.isHidden = true
        }
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
            if incomeSegueIdentifer == "getAdress" { showUserLocation()}
            break
        @unknown default:
            print("New authorizationStatus")
        }
    }
    private func showAlert(){
        let alertController = UIAlertController(title: "Ошибка доступа к геолокации", message: "Для корректной работы служб геолокации необходимо разрешить доступ приложения в слуббам геолокации через настройки", preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(actionOK)
        present(alertController, animated: true, completion: nil)
    }
private func showUserLocation(){
    if let location = locationManager.location?.coordinate{
        let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
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
}
extension MapVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        chekLocationAutorization()
    }
}
