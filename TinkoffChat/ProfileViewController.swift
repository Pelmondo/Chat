//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Сергей Прокопьев on 26.09.2018.
//  Copyright © 2018 Tinkoff Fintech. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, DataManager {
    
    
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var picthureButton: UIButton!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var nameTextField: UITextField!    
    
    @IBOutlet weak var gcdDataManager: UIButton!
    @IBOutlet weak var optionsDataManager: UIButton!
    @IBAction func canselTap(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // в init не получится распечатать, потому что view еще не загруженно/создано
    
    var nameData: String = "name.txt"
    
    var infoData: String = "info.txt"
    
    var imageData: String = "image.png"
    
    
    
    
    
    var imagePicker = UIImagePickerController()
    
    override func loadView() {
        super.loadView()
        print(changeButton.frame)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeUI()
        print(changeButton.frame)
        nameTextField.delegate = self
        descriptionTextView.delegate = self
        nameTextField.isUserInteractionEnabled = false
        descriptionTextView.isUserInteractionEnabled = false
        gcdDataManager.isUserInteractionEnabled = false
        optionsDataManager.isUserInteractionEnabled = false
        requestInfo()
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)  {
        let mainViewHeight = self.view.bounds.size.height
        let mainViewWidth = self.view.bounds.size.width
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: { () -> Void in
            self.view.center = CGPoint(x: mainViewWidth / 2, y: mainViewHeight / 2 - 60)
            
        }, completion: nil)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let mainViewHeight = self.view.bounds.size.height
        let mainViewWidth = self.view.bounds.size.width
        
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: { () -> Void in
            self.view.center = CGPoint(x: mainViewWidth / 2, y: mainViewHeight / 2 )
            
        }, completion: nil)
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(changeButton.frame)
        
        /* Отличие возникает потому что в методе ViewDidLoad frame имеет данные те, которые соответсвуют устройству, которое выбрано при создании приложения, в нашем случае IphoneSE. А когда мы выводим тот же frame, но уже в методе viewDidAppear frame имеет данные подходящие под Iphone Х или 8+. */
    }
    
    private func changeUI(){
        changeButton.layer.cornerRadius = 8
        picthureButton.layer.cornerRadius = 8
        descriptionTextView.layer.cornerRadius = 8
        gcdDataManager.layer.cornerRadius = 8
        optionsDataManager.layer.cornerRadius = 8
    }
    
    // When touch up into button - action Edit informations about yourself
    
    @IBAction func touchChangeButtom(_ sender: UIButton) {
        print("//TODO: iт near future")
        picthureButton.isHidden = false
        changeButton.isHidden = true
        gcdDataManager.isHidden = false
        optionsDataManager.isHidden = false
        nameTextField.isUserInteractionEnabled = true
        descriptionTextView.isUserInteractionEnabled = true
    }
    
    
    
    @IBAction func nameDidChange(_ sender: Any) {
       gcdDataManager.isUserInteractionEnabled = true
       optionsDataManager.isUserInteractionEnabled = true
        
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        gcdDataManager.isUserInteractionEnabled = true
        optionsDataManager.isUserInteractionEnabled = true
    }
  //  private func fillTest(){
        //let gcdTest = GCDDataManager()
        //gcdTest.asyncWriteFile(fileForName: "file.txt", handler: { (text: String) in
      //      self.nameTextField.text = text} )
        
  //  }
    
      private func requestInfo(){
         let gcdTest = GCDDataManager()
        nameTextField.text = gcdTest.asyncReadFile(fileForRead: nameData)
        descriptionTextView.text = gcdTest.asyncReadFile(fileForRead: infoData)
         let url = self.getDocumentsDirectory().appendingPathComponent("copy.png")
            let data = try! Data(contentsOf: url)
            let image = UIImage(data: data)
         photoImageView.image = image
    }
 

    
    @IBAction func touchOptionsButtom(_ sender: UIButton) {
         let gcdTest = OperationDataManager()
        nameTextField.text = gcdTest.asyncReadFile(fileForRead: nameData)
        descriptionTextView.text = gcdTest.asyncReadFile(fileForRead: infoData)
        let alert = UIAlertController(title: nil, message: "Saved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.changeButton.isHidden = false
            self.gcdDataManager.isHidden = true
            self.picthureButton.isHidden = true
            self.optionsDataManager.isHidden = true
            self.gcdDataManager.isUserInteractionEnabled = false
            self.optionsDataManager.isUserInteractionEnabled = false
            print("asd")}))
        self.present(alert,animated: true, completion: nil)
    }
        
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
   
    
    @IBAction func touchGcdButtom(_ sender: UIButton) {
        // todo rebild name!
    //    fillTest()
        
        
        
        if let name = nameTextField.text {
        SaveTrue(data: name , fileData: nameData)
       }
        
        if let info = descriptionTextView.text {
            SaveTrue(data: info, fileData: infoData)
        }
        
        DispatchQueue.global(qos: .default).async {
        if let image = self.photoImageView.image {
            if let data = image.pngData() {
                let filename = self.getDocumentsDirectory().appendingPathComponent("copy.png")
                try? data.write(to: filename)
                print(data)
            }
            }
        }
        
        let alert = UIAlertController(title: nil, message: "Saved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.changeButton.isHidden = false
            self.gcdDataManager.isHidden = true
            self.picthureButton.isHidden = true
            self.optionsDataManager.isHidden = true
            self.gcdDataManager.isUserInteractionEnabled = false
            self.optionsDataManager.isUserInteractionEnabled = false
            }))
        self.present(alert,animated: true, completion: nil)
    }
        
    private func SaveTrue (data: String, fileData: String ) {
      let gcdTest = GCDDataManager()
        gcdTest.writeData(data: data, fileForWrite: fileData)
    }
    
    
    
     // When touch up into button - action chose picture
    
    @IBAction func touchPictureButtom(_ sender: UIButton) {
        print("//TODO: iт near future")
        let alert = UIAlertController(title: "Изменить фото", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Отмена", comment: "Default action"), style: .cancel, handler: { _ in
            NSLog("The \"Отмена\" alert occured.")
            
           // Here something do
           /* self.changeButton.isHidden = false
            self.picthureButton.isHidden = true */
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        //If you dont want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension ProfileViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let editedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage{
            self.photoImageView.image = editedImage
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}

