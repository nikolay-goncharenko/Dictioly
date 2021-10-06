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
		
		modalWindow.center = view.center
		modalWindow.layer.cornerRadius = 8
		modalTextField.layer.cornerRadius = 8
		modalEditButton.layer.cornerRadius = 8
		modalCloseButton.layer.cornerRadius = 8
		
		modalTextField.delegate = self
		modalTextField.becomeFirstResponder()
		modalTextField.clearButtonMode = .whileEditing
		modalTextField.layer.borderWidth = 0.1
		modalTextField.layer.cornerRadius = 8
		modalTextField.layer.masksToBounds = true
		
		modalEditButton.isEnabled = false
		modalEditButton.backgroundColor = #colorLiteral(red: 0.9490322471, green: 0.9485961795, blue: 0.9704589248, alpha: 1)
		modalEditButton.setTitleColor(#colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1), for: .disabled)
		modalTextField.addTarget(self, action: #selector(blockingModalEditButton), for: .editingChanged)
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	// MARK: - Actions of ModalViewContoller
	
	@IBAction func editCurrentElement(_ sender: UIButton) {
		if modalTextField.text?.isEmpty == false && filtredItem.isEmpty == false {
			changeFiltredItem(at: indexOfCell, newNameItem: modalTextField.text!)
			changeVocabularyItem(at: indexOfComparisonValue, newNameItem: modalTextField.text!)
		}
		if modalTextField.text?.isEmpty == false && filtredItem.isEmpty == true {
			changeVocabularyItem(at: indexOfCell, newNameItem: modalTextField.text!)
		}
		
		dismiss(animated: true, completion: nil)
	}
	
	@objc func blockingModalEditButton() {
		if modalTextField.text!.isEmpty == true {
			modalEditButton.isEnabled = false
			modalEditButton.backgroundColor = #colorLiteral(red: 0.9490322471, green: 0.9485961795, blue: 0.9704589248, alpha: 1)
			modalEditButton.setTitleColor(#colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1), for: .disabled)
		} else {
			modalEditButton.isEnabled = true
			modalEditButton.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.8431372549, blue: 0.2941176471, alpha: 1)
			modalEditButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
		}
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
		let myModalViewMaxY = (modalWindow.frame.maxY - modalWindow.frame.origin.y) + modalWindow.frame.origin.y
		if modalWindow.frame.maxY != keyboardSize!.origin.y {
			modalWindow.frame.origin.y -= ((myModalViewMaxY - keyboardSize!.origin.y) + 50.0)
		}
	}

	@objc func keyboardWillHide(_ notification: Notification) {
		modalWindow.center = view.center
	}
	
}
