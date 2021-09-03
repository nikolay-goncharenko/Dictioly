//
//  ModalViewController.swift
//  Dictioly
//
//  Created by Nikolay Goncharenko on 14.04.2021.
//

import UIKit

class ModalViewController: UIViewController {
	
	@IBOutlet weak var modalWindow: UIView!
	@IBOutlet weak var modalHeadingLabel: UILabel!
	@IBOutlet weak var modalTextField: UITextField!
	@IBOutlet weak var modalCreateButton: UIButton!
	@IBOutlet weak var modalCloseButton: UIButton!
	
//	@IBOutlet weak var flagFromLeftSide: UIImageView!
//	@IBOutlet weak var flagFromRightSide: UIImageView!
//	@IBOutlet weak var languageLabelFromLeftSide: UILabel!
//	@IBOutlet weak var languageRightFromLeftSide: UILabel!
	
	@IBOutlet weak var flagFromLeftSide: UIButton!
	@IBOutlet weak var flagFromRightSide: UIButton!
	@IBOutlet weak var languageButtonFromLeftSide: UIButton!
	@IBOutlet weak var languageButtonFromRightSide: UIButton!
	
	@IBOutlet weak var reverseButton: UIButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()
//		view.isOpaque = false
//		view.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
//		modalWindow.backgroundColor = .white
//		view.backgroundColor = UIBlurEffect(style: .prominent)
//		view.layer.backgroundColor = CGColor(gray: 1, alpha: 0.4)
		modalWindow.layer.cornerRadius = 8
		modalTextField.layer.cornerRadius = 8
		modalCreateButton.layer.cornerRadius = 8
		modalCloseButton.layer.cornerRadius = 8
		
		modalTextField.becomeFirstResponder()
		modalTextField.clearButtonMode = .whileEditing
		modalTextField.layer.borderWidth = 0.1
		modalTextField.layer.cornerRadius = 8
//		modalTextField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//		modalTextField.tintColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8274509804, alpha: 1)
		modalTextField.layer.masksToBounds = true
		
		flagFromLeftSide.layer.borderWidth = 0.1
		flagFromLeftSide.layer.cornerRadius = 12.5
		flagFromLeftSide.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8274509804, alpha: 1)
		flagFromLeftSide.layer.masksToBounds = true
		
		flagFromRightSide.layer.borderWidth = 0.1
		flagFromRightSide.layer.cornerRadius = 12.5
		flagFromRightSide.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8274509804, alpha: 1)
		flagFromRightSide.layer.masksToBounds = true
		
		modalTextField.delegate = self
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
	
	// MARK: - Actions of ModalViewContoller
	
	@IBAction func createNewElement(_ sender: Any) {
		let newElement = modalTextField.text!
		addItem(nameItem: newElement)
		dismiss(animated: true, completion: nil)
	}
	
	
	@IBAction func closeCurrentView(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
}

extension ModalViewController: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		modalTextField.resignFirstResponder()
	}

	@objc func keyboardWillShow(_ notification: Notification) {
		let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
		if modalWindow.frame.maxY != keyboardSize!.origin.y {
			modalWindow.frame.origin.y -= keyboardSize!.height / 4
		}
	}

	@objc func keyboardWillHide(_ notification: Notification) {
		let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
		modalWindow.frame.origin.y += keyboardSize!.height / 4
	}
	
}
