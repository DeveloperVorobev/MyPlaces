//
//  NewPlaceVC.swift
//  MyPlaces
//
//  Created by Владислав Воробьев on 22.04.2022.
//

import UIKit

class NewPlaceVC: UITableViewController {
    var currentPlace: Place?
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    @IBOutlet var ratingControl: RatingControll!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        saveButton.isEnabled = false
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScrene()
    }
    // MARK: - TabelViewDelegare
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let cameraIcon = UIImage(named: "camera")
            let photoIcon = UIImage(named: "photo")
            let actonSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(sourse: .camera)
            }
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(sourse: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            actonSheet.addAction(camera)
            actonSheet.addAction(photo)
            actonSheet.addAction(cancel)
            present(actonSheet, animated: true, completion: nil)
            
        } else {
            view.endEditing(true)
        }
    }
    func savePlace() {
        let newPlace = Place(name: placeName.text!, location: placeLocation.text, type: placeType.text, imageData: placeImage.image?.pngData(), rating: Double( ratingControl.rating))
        if currentPlace != nil {
            try! realm.write{
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.imageData = newPlace.imageData
                currentPlace?.rating = newPlace.rating
                print("Edit Old")
            }
        } else {
            StorageManager.saveObject(newPlace)
            print("Save New")
        }
        
    }
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "showMap"{return}
        let mapVC = segue.destination as! MapVC
        mapVC.place.name = placeName.text ?? ""
        mapVC.place.location = placeLocation.text
        mapVC.place.type = placeType.text
        mapVC.place.imageData = placeImage.image?.pngData()
    }
}


// MARK: - TextFieldDelegare
extension NewPlaceVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc private func textFieldChanged (){
        if !(placeName.text?.isEmpty ?? true){
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}
// MARK: - Work with image
extension NewPlaceVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker(sourse: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(sourse){
            let imagePicer = UIImagePickerController()
            imagePicer.allowsEditing = true
            imagePicer.sourceType = sourse
            imagePicer.delegate = self
            present(imagePicer, animated: true, completion: nil)
            
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFill
        placeImage.clipsToBounds = false
        dismiss(animated: true, completion: nil)
    }
    private func setupEditScrene(){
        if currentPlace != nil{
            setupNavigationBar()
            guard let data = currentPlace?.imageData, let image = UIImage(data: data) else {return}
            placeImage.image = image
            placeName.text = currentPlace?.name
            placeLocation.text = currentPlace?.location
            placeType.text = currentPlace?.type
            placeImage.contentMode = .scaleAspectFit
            ratingControl.rating = Int(currentPlace?.rating ?? 0)
        }
    }
    private func setupNavigationBar(){
        navigationItem.leftBarButtonItem = nil
        navigationItem.title = currentPlace?.name
        saveButton.isEnabled = true
        if let topItem = navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
}
