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
	@IBOutlet weak var rightArrow: UILabel!
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
	
	var textOfNavigationTitle: String = ""
	var refreshData = UIRefreshControl()
	let backgroundColorView = UIView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.largeTitleDisplayMode = .never
		
		myNavigTitle()
		
		searchItemBar.delegate = self
		searchItemBar.isHidden = true
		searchItemBar.searchBarStyle = .minimal
		searchItemBar.placeholder = "Найти слово или фразу"
		
		flagFromLeftSide.layer.borderWidth = 0.1
		flagFromLeftSide.layer.cornerRadius = 15
		flagFromLeftSide.tintColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8274509804, alpha: 1)
		
		flagFromRightSide.layer.borderWidth = 0.1
		flagFromRightSide.layer.cornerRadius = 15
		flagFromRightSide.tintColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8274509804, alpha: 1)
		
		countItemsLabel.text = "Фраз в списке: \(filtredListItem.count)"
		countItemsLabel.adjustsFontSizeToFitWidth = true
		
		listTableView.delegate = self
		listTableView.dataSource = self
		listTableView.tableFooterView = UIView()
		listItemView.frame.origin.y = (view.frame.height - listItemView.frame.height)
		
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
		
		addItemToList.isHidden = true
		addItemToList.isEnabled = false
		addItemToList.tintColor = #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1)
		
		subtitleItemField.isHidden = true
		flagButtonFromRightSide.isEnabled = false
		
		flagButtonFromLeftSide.addTarget(self, action: #selector(changeLanguage), for: .touchUpInside)
		flagButtonFromRightSide.addTarget(self, action: #selector(changeLanguage), for: .touchUpInside)
		addSubtitleToList.addTarget(self, action: #selector(changeLanguage), for: .touchUpInside)
		
		listItemField.addTarget(self, action: #selector(blockingAdditionItemToList), for: .editingChanged)
		subtitleItemField.addTarget(self, action: #selector(blockingAdditionItemToList), for: .editingChanged)
		
		refreshData.addTarget(self, action: #selector(manualRefreshData), for: .valueChanged)
		
	}
	
	@IBAction func switchSearchBar(_ sender: UIBarButtonItem) {
		if searchItemBar.isHidden == true {
			searchItemBar.isHidden = false
			searchItemBar.becomeFirstResponder()
			flagFromLeftSide.isHidden = true
			rightArrow.isHidden = true
			flagFromRightSide.isHidden = true
			countItemsLabel.isHidden = true
		} else {
			searchItemBar.isHidden = true
			flagFromLeftSide.isHidden = false
			rightArrow.isHidden = false
			flagFromRightSide.isHidden = false
			countItemsLabel.isHidden = false
			searchBarCancelButtonClicked(searchItemBar)
		}
	}
	
	@objc func manualRefreshData() {
		let forTranslationData = filtredListItem.count
		let translationData = filtredSubtitleItem.count
		_ = filteredListItems(currentItem: navigationItem.title!)
		_ = filteredSubtitleItems(currentItem: navigationItem.title!)
		refreshData.endRefreshing()
		if forTranslationData != filtredListItem.count && translationData != filtredSubtitleItem.count {
			let indexPathNewRow = IndexPath(row: filtredListItem.count - 1, section: 0)
			listTableView.insertRows(at: [indexPathNewRow], with: .bottom)
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
			manualRefreshData()
			countItemsLabel.text = "Фраз в списке: \(filtredListItem.count)"
		}
		listItemField.resignFirstResponder()
		subtitleItemField.resignFirstResponder()
		listItemField.text = .none
		subtitleItemField.text = .none
	}
}

extension WordsViewController: UINavigationControllerDelegate {
	
	func myNavigTitle() {
		navigationItem.title = textOfNavigationTitle
	}
}

extension WordsViewController: UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
	
	func searchBarIsEmpty() -> Bool {
		return true
	}
	
	func searchBarIsActive() -> Bool {
		return true
	}
	
	func updateSearchResults(for searchController: UISearchController) {
		print("!")
	}
	
	
	func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
		searchItemBar.setShowsCancelButton(true, animated: true)
		return true
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchItemBar.setShowsCancelButton(false, animated: true)
		searchItemBar.resignFirstResponder()
	}
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		let cancelSearchButton = searchItemBar.value(forKey: "cancelButton") as? UIButton
		cancelSearchButton?.setTitle("Отмена", for: .normal)
	}
}

extension WordsViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if filtredListItem.count > 0 && filtredSubtitleItem.count > 0 {
			backgroundColorView.backgroundColor = UIColor.systemBackground
			tableView.backgroundView = backgroundColorView
			return filtredListItem.count
		} else {
			tableView.backgroundView = UIImageView.init(image: UIImage.init(named: "backroundImage"))
			return 0
		}
		
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CellWords", for: indexPath)
		
		cell.textLabel?.text = filtredListItem[indexPath.row]
		cell.detailTextLabel?.text = filtredSubtitleItem[indexPath.row]
		
//		print(listItem.count)
//		print(subtitleItem.count)
//		print(filtredListItem[indexPath.row])
//		print(filtredSubtitleItem[indexPath.row])
		return cell
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		
		_ = indexOfFiltredListItems(incomingIndex: indexPath.row)
		_ = indexOfFiltredSubtitleItems(incomingIndex: indexPath.row)
		
		let swipeDelete = UIContextualAction(style: .normal, title: "Удалить") { (action, view, success) in
			removeFiltredWordListItem(indexPath.row)
			removeMainWordListItem(indexOfFiltredListItem)
			
			tableView.deleteRows(at: [indexPath], with: .middle)
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
				self.countItemsLabel.text = "Фраз в списке: \(filtredListItem.count)"
			}
		}
		swipeDelete.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
		swipeDelete.image = .init(systemName: "trash.fill")
		
		let blockingLongSwipe = UISwipeActionsConfiguration(actions: [swipeDelete])
		blockingLongSwipe.performsFirstActionWithFullSwipe = false
		
		return blockingLongSwipe
	}
	
}

extension WordsViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		listItemField.resignFirstResponder()
		return subtitleItemField.resignFirstResponder()
	}
	
	@objc func keyboardWillShow(_ notification: Notification) {
		let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
		let myFieldViewMaxY = (listItemView.frame.maxY - listItemView.frame.origin.y) + listItemView.frame.origin.y
		if listItemView.frame.maxY != keyboardSize!.origin.y {
			listItemView.frame.origin.y -= (myFieldViewMaxY - keyboardSize!.origin.y)
		}
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
