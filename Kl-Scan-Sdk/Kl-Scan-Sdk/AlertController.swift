//
//  AlertController.swift
//  Kl-Scan-Sdk
//
//  Created by Aditya Chauhan on 07/01/20.
//  Copyright © 2020 Khosla Labs. All rights reserved.
//

import UIKit

internal protocol AlertControllerProtocol{
    func showAlertController(title: String?, message: String?, actions: [UIAlertAction])
}

internal extension AlertControllerProtocol where Self: UIViewController{
    func showAlertController(title: String?, message: String?, actions: [UIAlertAction]){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for alertAction in actions{
            alertController.addAction(alertAction)
        }
        present(alertController, animated: true, completion: nil)
    }
}
