//
//  ImageSourcePicker.swift
//  TinkoffChat
//
//  Created by Сергей Прокопьев on 06/11/2018.
//  Copyright © 2018 Tinkoff Fintech. All rights reserved.
//

import Foundation
import UIKit

class ImageSourcePicker: ImagePicker {
    
    
    weak var hostViewController: UIViewController?
    var pickerFactory: (UIImagePickerController.SourceType) -> ImagePicker
    var currentPicker: ImagePicker?

    init(hostViewController: UIViewController?, pickerFactory: @escaping (UIImagePickerController.SourceType) -> ImagePicker) {
    self.hostViewController = hostViewController
    self.pickerFactory = pickerFactory
}

    func pick(completion: @escaping (UIImage?) -> Void) {
        let actionSheetController = UIAlertController(title: "Изменить фото", message: nil, preferredStyle: .actionSheet)

        actionSheetController.addAction(UIAlertAction(title: "Galery", style: .default){_ in
            self.currentPicker = self.pickerFactory(.photoLibrary)
            self.currentPicker?.pick(completion: completion)
        })
        
        actionSheetController.addAction(UIAlertAction(title: "Camera", style: .default){_ in
            self.currentPicker = self.pickerFactory(.camera)
            self.currentPicker?.pick(completion: completion)
        })
        
        actionSheetController.addAction(UIAlertAction(title: "Cancel", style: .cancel){_ in
            completion(nil)
        })
        self.hostViewController?.present(actionSheetController, animated: true, completion: nil)
}
}
