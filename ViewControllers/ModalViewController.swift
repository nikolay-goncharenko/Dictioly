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
		modalWindow.center = view.center
		modalWindow.layer.cornerRadius = 8
		modalTextField.layer.cornerRadius = 8
		modalCreateButton.layer.cornerRadius = 8
		modalCloseButton.layer.cornerRadius = 8
		
		modalTextField.delegate = self
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
		
		modalCreateButton.isEnabled = false
		modalCreateButton.backgroundColor = #colorLiteral(red: 0.9490322471, green: 0.9485961795, blue: 0.9704589248, alpha: 1)
		modalCreateButton.setTitleColor(#colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1), for: .disabled)
		modalTextField.addTarget(self, action: #selector(blockingModalCreateButton), for: .editingChanged)
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
	
	// MARK: - Actions of ModalViewContoller
	
	@IBAction func createNewElement(_ sender: Any) {
		if modalTextField.text?.isEmpty == false {
			addItem(nameItem: modalTextField.text!)
		}
		dismiss(animated: true, completion: nil)
	}
	
	@objc func blockingModalCreateButton() {
		if modalTextField.text!.isEmpty == true {
			modalCreateButton.isEnabled = false
			modalCreateButton.backgroundColor = #colorLiteral(red: 0.9490322471, green: 0.9485961795, blue: 0.9704589248, alpha: 1)
			modalCreateButton.setTitleColor(#colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1), for: .disabled)
		} else {
			modalCreateButton.isEnabled = true
			modalCreateButton.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.8431372549, blue: 0.2941176471, alpha: 1)
			modalCreateButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
		}
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
		let myModalViewMaxY = (modalWindow.frame.maxY - modalWindow.frame.origin.y) + modalWindow.frame.origin.y
		if modalWindow.frame.maxY != keyboardSize!.origin.y {
			modalWindow.frame.origin.y -= ((myModalViewMaxY - keyboardSize!.origin.y) + 50.0)
		}
		
//		let viewY = view.frame.origin.y
//		let viewH = view.frame.height
//		let modalViewY = modalWindow.frame.origin.y
//		let modalViewMaxY = modalWindow.frame.maxY
//		let y = keyboardSize?.origin.y
//		let h = keyboardSize?.height
//
//		print("Origin экрана по Y : \(viewY)")
//		print("Высота экрана : \(viewH)")
//		print("Origin моего вью по Y : \(modalViewY)")
//		print("MaxY моего вью по Y : \(modalViewMaxY)")
//		print("Origin клавиатуры по Y : \(y as Any)")
//		print("Высота клавиатуры : \(h as Any)")
		
	}

	@objc func keyboardWillHide(_ notification: Notification) {
		modalWindow.center = view.center
	}
}
