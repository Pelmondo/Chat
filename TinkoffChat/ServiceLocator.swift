//
//  ServiceLocator.swift
//  TinkoffChat
//
//  Created by Сергей Прокопьев on 06/11/2018.
//  Copyright © 2018 Tinkoff Fintech. All rights reserved.
//

import Foundation
import UIKit

protocol ImagePicker {
func pick(completion: @escaping (UIImage?) -> Void)
}

protocol IServiceLocator {
    func imagePicker(hostViewController: UIViewController) -> ImagePicker
}

/*class ServiceLocator: IServiceLocator {
    static var `default`: IServiceLocator = ServiceLocator()
    func imagePicker(hostViewController: UIViewController) -> ImagePicker {
        return ImageSourcePicker( hostViewController: hostViewController, pickerFactory: { sourceType in DefaultImagePicker ( hostViewController: hostViewController, sourceType: sourceType)
})
}
}
*/
