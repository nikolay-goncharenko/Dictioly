//
//  TableViewController.swift
//  Dictioly
//
//  Created by Nikolay Goncharenko on 14.04.2021.
//

import UIKit

class TableViewController: UITableViewController {
	
	var search = UISearchController()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		navigationController?.navigationBar.prefersLargeTitles = true
//		navigationItem.largeTitleDisplayMode = .always
		
		search = UISearchController(searchResultsController: nil)
		search.searchResultsUpdater = self
		navigationItem.searchController = search
		search.hidesNavigationBarDuringPresentation = false
		search.searchBar.isTranslucent = true
		search.searchBar.delegate = self
		search.obscuresBackgroundDuringPresentation = false
		search.searchBar.placeholder = "Найти список слов"
		
		
		
		
		tableView.tableFooterView = UIView()
		tableView.backgroundColor = UIColor.systemGray6
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
			self.tableView.reloadData()
		}
	}
	
	// MARK: - Actions of TableViewController
	
	@IBAction func addNewItem(_ sender: Any) {
		 if let modalVC = storyboard?.instantiateViewController(identifier: "ModalView") as? ModalViewController {
			modalVC.modalTransitionStyle = .crossDissolve
			modalVC.modalPresentationStyle = .fullScreen
			modalVC.view.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
			modalVC.view.isOpaque = false
			present(modalVC, animated: true, completion: nil)
		}
		
	}
	
	func editCurrentItem(_ sender: UIButton) {
		 if let modalVC = storyboard?.instantiateViewController(identifier: "EditModalView") as? EditModalViewController {
			modalVC.modalTransitionStyle = .crossDissolve
			modalVC.modalPresentationStyle = .fullScreen
			modalVC.view.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
			modalVC.view.isOpaque = false
			present(modalVC, animated: true, completion: nil)
		}
		
	}

	@IBAction func editPositionItem(_ sender: Any) {
		tableView.setEditing(!tableView.isEditing, animated: true)
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
			self.tableView.reloadData()
		}
		
	}

	// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		
		if searchBarIsActive() {
			return filtredItem.count
		} else {
			return vocabularyItem.count
		}
    }
    
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? WordListCell {
			if searchBarIsActive() {
				cell.nameOfWordListLabel.text = filtredItem[indexPath.row]
				cell.flagImageFromLeftSide.image = #imageLiteral(resourceName: "usa")
				cell.flagImageFromRightSide.image = #imageLiteral(resourceName: "russia")
				cell.countItemsLabel.text = "\(filtredListItem.count) фраз"
			} else {
				cell.nameOfWordListLabel.text = vocabularyItem[indexPath.row]["Name"] as? String
				cell.flagImageFromLeftSide.image = #imageLiteral(resourceName: "usa")
				cell.flagImageFromRightSide.image = #imageLiteral(resourceName: "russia")
				cell.countItemsLabel.text = "\(filtredListItem.count) фраз"
			}
			return cell
		} else {
			return WordListCell()
//			var error: UITableViewCell = "Not Found"
//			return customCell.error
		}
		
//		cell.nameOfWordListLabel.text = vocabularyItem[indexPath.row]["Name"] as? String
//		cell.flagImageFromLeftSide.image = #imageLiteral(resourceName: "usa")
//		cell.flagImageFromRightSide.image = #imageLiteral(resourceName: "russia")
//		cell.countItemsLabel.text = "\(listItem.count) фраз"
//		return cell
		
//		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//		if searchBarIsActive() {
//			cell.textLabel?.text = filtredItem[indexPath.row]
//		} else {
//			cell.textLabel?.text = vocabularyItem[indexPath.row]["Name"] as? String
//		}
		
		
		// add border and color
//		cell.backgroundColor = UIColor.white
//		cell.layer.borderColor = UIColor.black.cgColor
//		cell.layer.borderWidth = 1
//		cell.layer.cornerRadius = 8
//		cell.clipsToBounds = true
		
//		return cell
    }
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//		if indexPath.row == 0 {
//			return 100
//		} else {
//			return 60
//		}
		return 80
	}
    
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destinationVC: WordsViewController = segue.destination as! WordsViewController
		let indexPathCell = tableView.indexPathForSelectedRow?.row
		let valueOfVocabularyItem = vocabularyItem[indexPathCell!]["Name"] as! String
		saveValue(at: valueOfVocabularyItem)
		filteredListItems(currentItem: valueOfVocabularyItem)
		filteredSubtitleItems(currentItem: valueOfVocabularyItem)
		destinationVC.textOfNavigationTitle = valueOfVocabularyItem
	}
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let swipeDelete = UIContextualAction(style: .normal, title: "Delete") { (action, view, success) in
			removeItem(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .middle)
		}
		swipeDelete.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
		
		let swipeEdit = UIContextualAction(style: .normal, title: "Edit") { (action, view, success) in
			self.editCurrentItem(UIButton())
			saveIndex(at: indexPath.row)
		}
		swipeEdit.backgroundColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
		
		
		let blockingLongSwipe = UISwipeActionsConfiguration(actions: [swipeDelete, swipeEdit])
		blockingLongSwipe.performsFirstActionWithFullSwipe = false
		
		return blockingLongSwipe
	}
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		
		moveItem(fromInex: fromIndexPath.row, toIndex: to.row)
		tableView.reloadData()
    }
	
	override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		if tableView.isEditing {
			return .none
		} else {
			return .delete
		}
	}
	
	override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
		return false
	}
	
//	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//		return 10
//	}
	
//	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//		return 10
//	}


    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TableViewController: UISearchResultsUpdating, UISearchBarDelegate {
	
	func searchBarIsEmpty() -> Bool {
		return search.searchBar.text?.isEmpty ?? true
	}
	
	func searchBarIsActive() -> Bool {
		return search.isActive && !searchBarIsEmpty()
	}
	
	func filtredSearch(searchText: String) {
		filteredItems(currentItem: searchText)
		tableView.reloadData()
	}
	
	func updateSearchResults(for searchController: UISearchController) {
		filtredSearch(searchText: search.searchBar.text!)
	}
	
//	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//		let cancelSearchButton = search.searchBar.value(forKey: "cancelButton") as! UIButton
//		cancelSearchButton.setTitle("Отмена", for: .normal)
//	}

}
