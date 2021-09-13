//
//  WordsViewController.swift
//  Dictioly
//
//  Created by Nikolay Goncharenko on 19.04.2021.
//

import UIKit

class WordsViewController: UIViewController {

	@IBOutlet weak var searchItemButton: UIBarButtonItem!
	@IBOutlet weak var flagFromLeftSide: UIImageView!
	@IBOutlet weak var flagFromRightSide: UIImageView!
	@IBOutlet weak var countItemsLabel: UILabel!
	@IBOutlet weak var searchBarView: UIView!
	@IBOutlet weak var searchItemBar: UISearchBar!
	@IBOutlet weak var listTableView: UITableView!
	@IBOutlet weak var listItemView: UIView!
	@IBOutlet weak var listItemField: UITextField!
	@IBOutlet weak var subtitleItemField: UITextField!
	@IBOutlet weak var addItemToList: UIButton!
	@IBOutlet weak var addSubtitleToList: UIButton!
	@IBOutlet weak var secondSearchButton: UIButton!
	@IBOutlet weak var flagButtonFromLeftSide: UIButton!
	@IBOutlet weak var flagButtonFromRightSide: UIButton!
	
	@IBOutlet weak var clearButton: UIButton!
	var textOfNavigationTitle: String = ""
	
	var refreshData = UIRefreshControl()
//	var originOfMyListItemView = (view.frame.height - listItemView.frame.height)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		myNavigTitle()
//		originOfMyListItemView()
//		navigationController?.navigationBar.prefersLargeTitles = false
//		navigationItem.largeTitleDisplayMode = .never
		
//		searchItemBar.isHidden = true
//		searchItemBar.delegate = self
		
		flagFromLeftSide.layer.borderWidth = 0.1
		flagFromLeftSide.layer.cornerRadius = 15
		flagFromLeftSide.tintColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8274509804, alpha: 1)
		
		flagFromRightSide.layer.borderWidth = 0.1
		flagFromRightSide.layer.cornerRadius = 15
		flagFromRightSide.tintColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8274509804, alpha: 1)
		
//		countItemsLabel.text = "\(listItem.count) фраз"
		countItemsLabel.text = "\(filtredListItem.count) фраз"
		countItemsLabel.adjustsFontSizeToFitWidth = true
		
		listTableView.delegate = self
		listTableView.dataSource = self
		listTableView.tableFooterView = UIView()
		listItemView.frame.origin.y = (view.frame.height - listItemView.frame.height)
//		listTableView.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
		
		listItemField.delegate = self
		listItemField.borderStyle = .roundedRect
		listItemField.clearButtonMode = .whileEditing
		listItemField.layer.borderWidth = 1
		listItemField.layer.cornerRadius = 18.5
		listItemField.layer.masksToBounds = true
		listItemField.tintColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8274509804, alpha: 1)
		
		subtitleItemField.delegate = self
		subtitleItemField.borderStyle = .roundedRect
		subtitleItemField.clearButtonMode = .whileEditing
		subtitleItemField.layer.borderWidth = 1
		subtitleItemField.layer.cornerRadius = 18.5
		subtitleItemField.layer.masksToBounds = true
		subtitleItemField.tintColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8274509804, alpha: 1)
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
		
		flagButtonFromLeftSide.layer.borderWidth = 1
		flagButtonFromLeftSide.layer.cornerRadius = 15
		flagButtonFromLeftSide.layer.borderColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
		flagButtonFromLeftSide.layer.masksToBounds = true
		
		flagButtonFromRightSide.layer.borderWidth = 0.1
		flagButtonFromRightSide.layer.cornerRadius = 15
		flagButtonFromRightSide.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8274509804, alpha: 1)
		flagButtonFromRightSide.layer.masksToBounds = true
		
//		filteredListItems(currentItem: vocabularyItemValue)
//		filtredTableItems()
//		listItemField.rightView = addItemToList
//		listItemField.rightViewMode = .always
		
		addItemToList.isHidden = true
		addItemToList.isEnabled = false
		addItemToList.tintColor = #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1)
		
//		addSubtitleToList.isHidden = true
		subtitleItemField.isHidden = true
		flagButtonFromRightSide.isEnabled = false
		
		flagButtonFromLeftSide.addTarget(self, action: #selector(changeLanguage), for: .touchUpInside)
		flagButtonFromRightSide.addTarget(self, action: #selector(changeLanguage), for: .touchUpInside)
		addSubtitleToList.addTarget(self, action: #selector(changeLanguage), for: .touchUpInside)
		
		listItemField.addTarget(self, action: #selector(blockingAdditionItemToList), for: .editingChanged)
		subtitleItemField.addTarget(self, action: #selector(blockingAdditionItemToList), for: .editingChanged)
		
		refreshData.addTarget(self, action: #selector(manualRefreshData), for: .valueChanged)
		listTableView.addSubview(refreshData)
		
		clearButton.addTarget(self, action: #selector(clearButtonAction), for: .touchUpInside)
		
//		let viewY = view.frame.origin.y
//		let viewH = view.frame.height
//		let myViewY = listItemView.frame.origin.y
//		let myViewMaxY = listItemView.frame.maxY
//		let myH = listItemView.frame.height
//
//		print("Origin экрана по Y : \(viewY)")
//		print("Высота экрана : \(viewH)")
//		print("Origin моего вью по Y : \(myViewY)")
//		print("MaxY моего вью по Y : \(myViewMaxY)")
//		print("Высота моего вью : \(myH as Any)")
	}
	
	@objc func clearButtonAction() {
		listItem.removeAll()
		subtitleItem.removeAll()
		listTableView.reloadData()
	}
	
	@objc func manualRefreshData() {
		let forTranslationData = filtredListItem.count
		let translationData = filtredSubtitleItem.count
		filteredListItems(currentItem: navigationItem.title!)
		filteredSubtitleItems(currentItem: navigationItem.title!)
		refreshData.endRefreshing()
		if forTranslationData != filtredListItem.count && translationData != filtredSubtitleItem.count {
			countItemsLabel.text = "\(filtredListItem.count) фраз"
			let indexPathNewRow = IndexPath(row: filtredListItem.count - 1, section: 0)
			print(filtredListItem.count)
			print(indexPathNewRow)
			listTableView.insertRows(at: [indexPathNewRow], with: .bottom)
		} else {
			print("Кол-во ячеек не изменилось")
		}
	}
	
	@objc func changeLanguage() {
		if flagButtonFromRightSide.isEnabled == false && subtitleItemField.isHidden == true && addItemToList.isHidden == true {
			listItemView.insertSubview(flagButtonFromLeftSide, belowSubview: flagButtonFromRightSide)
			
			flagButtonFromLeftSide.layer.borderWidth = 0
			flagButtonFromLeftSide.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8274509804, alpha: 1)
			
			flagButtonFromRightSide.layer.borderWidth = 2
			flagButtonFromRightSide.layer.borderColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
			
			flagButtonFromRightSide.isEnabled = true
			flagButtonFromLeftSide.isEnabled = false
			
			listItemView.insertSubview(listItemField, belowSubview: subtitleItemField)
			listItemField.isHidden = true
			subtitleItemField.isHidden = false
			if subtitleItemField.becomeFirstResponder() == false {
				subtitleItemField.becomeFirstResponder()
			}
			
			listItemView.insertSubview(addSubtitleToList, belowSubview: addItemToList)
			addSubtitleToList.isHidden = true
			addItemToList.isHidden = false
		} else {
			listItemView.insertSubview(flagButtonFromLeftSide, aboveSubview: flagButtonFromRightSide)
			
			flagButtonFromLeftSide.layer.borderWidth = 2
			flagButtonFromLeftSide.layer.borderColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
			
			flagButtonFromRightSide.layer.borderWidth = 0
			flagButtonFromRightSide.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8274509804, alpha: 1)
			
			flagButtonFromRightSide.isEnabled = false
			flagButtonFromLeftSide.isEnabled = true
			
			listItemView.insertSubview(listItemField, aboveSubview: subtitleItemField)
			listItemField.isHidden = false
			subtitleItemField.isHidden = true
			listItemField.becomeFirstResponder()
			
			listItemView.insertSubview(addSubtitleToList, aboveSubview: addItemToList)
			addSubtitleToList.isHidden = false
			addItemToList.isHidden = true
		}
		
	}
	
	@objc func blockingAdditionItemToList() {
		if listItemField.text!.isEmpty == true && subtitleItemField.text!.isEmpty == true {
			addItemToList.isEnabled = false
			addItemToList.tintColor = #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1)
		} else {
			addItemToList.isEnabled = true
			addItemToList.tintColor = #colorLiteral(red: 0.1960784314, green: 0.8431372549, blue: 0.2941176471, alpha: 1)
		}
	}
	
	@IBAction func addNewItemToList(_ sender: UIButton) {
		if listItemField.text?.isEmpty == false && subtitleItemField.text?.isEmpty == false {
			addListItem(nameItem: listItemField.text!)
			addSubtitleItem(nameItem: subtitleItemField.text!)
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
			self.listTableView.reloadData()
//			self.countItemsLabel.text = "\(listItem.count) фраз"
			self.countItemsLabel.text = "\(filtredListItem.count) фраз"
		}
		listItemField.resignFirstResponder()
		subtitleItemField.resignFirstResponder()
		listItemField.text = .none
		subtitleItemField.text = .none
	}
}

//extension UIView {
//	func addBlurEffect() {
//		let blurEffect = UIBlurEffect(style: .prominent)
//		let blurEffectView = UIVisualEffectView(effect: blurEffect)
//		blurEffectView.frame = listItemView.bounds
//	}
//}

extension WordsViewController: UINavigationControllerDelegate {
	
	func myNavigTitle() {
		navigationItem.title = textOfNavigationTitle
	}
}

extension WordsViewController: UISearchBarDelegate {
	
//	func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//		searchItemBar.showsCancelButton = true
//		return true
//	}
//
//	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//		self.searchItemBar.showsCancelButton = false
//		self.searchItemBar.resignFirstResponder()
//	}
}

extension WordsViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
//		filteredListItems(currentItem: vocabularyItemValue)
//		return listItem.count
//		print(listItem)
//		print(filtredListItem)
//		tableView.reloadData()
		return filtredListItem.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CellWords", for: indexPath)
//		let currentItem = vocabularyItem[indexPath.row]
//		cell.textLabel?.text = listItem[indexPath.row]["List"] as? String
//		cell.detailTextLabel?.text = subtitleItem[indexPath.row]["Subtitle"] as? String
		
//		cell.textLabel?.text = listItem[indexPath.row][vocabularyItemValue] as? String
//		cell.detailTextLabel?.text = subtitleItem[indexPath.row][vocabularyItemValue] as? String
//
		cell.textLabel?.text = filtredListItem[indexPath.row]
		cell.detailTextLabel?.text = filtredSubtitleItem[indexPath.row]
		return cell
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let swipeDelete = UIContextualAction(style: .normal, title: "Delete") { (action, view, success) in
			removeListItem(at: indexPath.row)
			removeSubtitleItem(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .middle)
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
				self.countItemsLabel.text = "\(listItem.count) фраз"
			}
		}
		swipeDelete.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
		
		let blockingLongSwipe = UISwipeActionsConfiguration(actions: [swipeDelete])
//		blockingLongSwipe.performsFirstActionWithFullSwipe = false
		
		return blockingLongSwipe
	}
	
}

extension WordsViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		listItemField.resignFirstResponder()
		return subtitleItemField.resignFirstResponder()
	}
	
//	func originOfMyListItemView() {
//		listItemView.frame.origin.y += (listItemView.frame.height - listItemView.frame.height)
		
//		let originOfView = (view.frame.height - listItemView.frame.height)
//		let r: () = (listItemView.frame.origin.y -= view.frame.height)
//		listItemView.frame.origin.y -= view.frame.height
//		let originOfView = ((listItemView.frame.height + listItemView.frame.origin.y) + (view.frame.height - listItemView.frame.height))
//		print("Новый Origin моего вью : \(originOfView)")
//	}
	
	@objc func keyboardWillShow(_ notification: Notification) {
		let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
		let myFieldViewMaxY = (listItemView.frame.maxY - listItemView.frame.origin.y) + listItemView.frame.origin.y
		if listItemView.frame.maxY != keyboardSize!.origin.y {
			listItemView.frame.origin.y -= (myFieldViewMaxY - keyboardSize!.origin.y)
		}
		
//		if listItemView.frame.maxY >= keyboardSize!.origin.y {
//			listItemView.frame.origin.y -= (myFieldViewMaxY - keyboardSize!.origin.y)
//		} else if listItemView.frame.maxY <= keyboardSize!.origin.y {
//			listItemView.frame.origin.y += (keyboardSize!.origin.y - myFieldViewMaxY)
//		}
//		let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
//		if listItemView.frame.maxY != keyboardSize!.origin.y && listItemField.becomeFirstResponder() {
//			listItemView.frame.origin.y -= keyboardSize!.height
//		}
//		let myViewPlusKeyboardSize: () = listItemView.frame.origin.y -= keyboardSize!.height
//		listItemView.frame.origin.y -= keyboardSize!.height
		
//		let viewY = view.frame.origin.y
//		let viewH = view.frame.height
//		let myViewY = listItemView.frame.origin.y
//		let myViewMaxY = listItemView.frame.maxY
//		let y = keyboardSize?.origin.y
//		let h = keyboardSize?.height
//
//
//		print("Origin экрана по Y : \(viewY)")
//		print("Высота экрана : \(viewH)")
//		print("Origin моего вью по Y : \(myViewY)")
//		print("MaxY моего вью по Y : \(myViewMaxY)")
//		print("Origin клавиатуры по Y : \(y as Any)")
//		print("Высота клавиатуры : \(h as Any)")
	}
	
	@objc func keyboardWillHide(_ notification: Notification) {
		listItemView.frame.origin.y = (view.frame.height - listItemView.frame.height)
		
		
//		let viewY = view.frame.origin.y
//		let viewH = view.frame.height
//		let myViewY = listItemView.frame.origin.y
//		let myViewMaxY = listItemView.frame.maxY
//		let myH = listItemView.frame.height
//
//		print("Origin экрана по Y : \(viewY)")
//		print("Высота экрана : \(viewH)")
//		print("Origin моего вью по Y : \(myViewY)")
//		print("MaxY моего вью по Y : \(myViewMaxY)")
//		print("Высота моего вью : \(myH as Any)")
//		print("Новый Origin моего вью : \(originOfView)")
	}
}
