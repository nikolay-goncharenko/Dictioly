//
//  EditModalViewController.swift
//  Dictioly
//
//  Created by Nikolay Goncharenko on 03.06.2021.
//

import UIKit

class EditModalViewController: UIViewController {

	@IBOutlet weak var modalWindow: UIView!
	@IBOutlet weak var modalHeadingLabel: UILabel!
	@IBOutlet weak var modalTextField: UITextField!
	@IBOutlet weak var modalEditButton: UIButton!
	@IBOutlet weak var modalCloseButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
//		view.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
//		modalWindow.backgroundColor = .white
		modalWindow.layer.cornerRadius = 8
		modalTextField.layer.cornerRadius = 8
		modalEditButton.layer.cornerRadius = 8
		modalCloseButton.layer.cornerRadius = 8
		
		modalTextField.becomeFirstResponder()
		modalTextField.clearButtonMode = .whileEditing
		modalTextField.layer.borderWidth = 0.1
		modalTextField.layer.cornerRadius = 8
		modalTextField.layer.masksToBounds = true
		
		modalTextField.delegate = self
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	// MARK: - Actions of ModalViewContoller
	
	@IBAction func editCurrentElement(_ sender: UIButton) {

		let editedElement = modalTextField.text!
		changeItem(at: saveIndex(at: indexOfCell), newNameItem: editedElement)
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func closeCurrentView(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	

	/*
	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
	}
	*/

}

extension EditModalViewController: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		modalTextField.resignFirstResponder()
	}

	@objc func keyboardWillShow(_ notification: Notification) {
		let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
		if modalWindow.frame.maxY != keyboardSize!.origin.y && modalTextField.becomeFirstResponder() {
			modalWindow.frame.origin.y -= keyboardSize!.height / 4
		}
	}

	@objc func keyboardWillHide(_ notification: Notification) {
		let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
		modalWindow.frame.origin.y += keyboardSize!.height / 4
	}
	
}
