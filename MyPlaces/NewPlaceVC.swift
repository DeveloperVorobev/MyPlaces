//
//  NewPlaceVC.swift
//  MyPlaces
//
//  Created by Владислав Воробьев on 22.04.2022.
//

import UIKit

class NewPlaceVC: UITableViewController {
    @IBOutlet weak var imageOfPlace: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    // MARK: - TabelViewDelegare
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let actonSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Camers", style: .default) { _ in
                self.chooseImagePicker(sourse: .camera)
            }
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(sourse: .photoLibrary)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            actonSheet.addAction(camera)
            actonSheet.addAction(photo)
            actonSheet.addAction(cancel)
            present(actonSheet, animated: true, completion: nil)
            
        } else {
            view.endEditing(true)
        }
    }
}

// MARK: - TextFieldDelegare
extension NewPlaceVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        imageOfPlace.image = info[.editedImage] as? UIImage
        imageOfPlace.contentMode = .scaleAspectFill
        imageOfPlace.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
}
