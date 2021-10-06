//
//  TableViewController.swift
//  Dictioly
//
//  Created by Nikolay Goncharenko on 14.04.2021.
//

import UIKit

class TableViewController: UITableViewController {
	
	var search = UISearchController()
	let backgroundColorView = UIView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.largeTitleDisplayMode = .always
		
		search = UISearchController(searchResultsController: nil)
		search.searchResultsUpdater = self
		navigationItem.searchController = search
//		search.hidesNavigationBarDuringPresentation = false
		search.searchBar.isTranslucent = true
		search.searchBar.delegate = self
		search.obscuresBackgroundDuringPresentation = false
		search.searchBar.placeholder = "Найти список слов"
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
			if self.searchBarIsActive() {
				modalVC.modalTextField.text = filtredItem[indexOfCell]
			} else {
				modalVC.modalTextField.text = vocabularyItem[indexOfCell]["Name"] as? String
			}
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
		
		if searchBarIsActive() && filtredItem.count > 0 {
			backgroundColorView.backgroundColor = UIColor.systemGray6
			tableView.backgroundView = backgroundColorView
			return filtredItem.count
		} else if searchBarIsActive() && filtredItem.count <= 0 {
			tableView.backgroundView = UIImageView.init(image: UIImage.init(named: "backroundImage"))
			return 0
		} else {
			backgroundColorView.backgroundColor = UIColor.systemGray6
			tableView.backgroundView = backgroundColorView
			return vocabularyItem.count
		}
    }
    
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? WordListCell {
			if searchBarIsActive() {
				cell.nameOfWordListLabel.text = filtredItem[indexPath.row]
				cell.flagImageFromLeftSide.image = #imageLiteral(resourceName: "usa")
				cell.flagImageFromRightSide.image = #imageLiteral(resourceName: "russia")
				cell.countItemsLabel.text = "Фраз в списке: \(filtredPhraseCounter(incomingIndex: indexPath.row))"
			} else {
				cell.nameOfWordListLabel.text = vocabularyItem[indexPath.row]["Name"] as? String
				cell.flagImageFromLeftSide.image = #imageLiteral(resourceName: "usa")
				cell.flagImageFromRightSide.image = #imageLiteral(resourceName: "russia")
				cell.countItemsLabel.text = "Фраз в списке: \(mainPhraseCounter(incomingIndex: indexPath.row))"
				
				if tableView.isEditing {
					cell.nameOfWordListLabel.textColor = .systemGray
					cell.flagImageFromLeftSide.alpha = 0.5
					cell.rightArrow.textColor = .systemGray
					cell.flagImageFromRightSide.alpha = 0.5
					cell.countItemsLabel.textColor = .systemGray
				} else {
					cell.nameOfWordListLabel.textColor = .black
					cell.flagImageFromLeftSide.alpha = 1
					cell.rightArrow.textColor = .black
					cell.flagImageFromRightSide.alpha = 1
					cell.countItemsLabel.textColor = .black
				}
			}
			return cell
		} else {
			return WordListCell()
		}
    }
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80
	}
    
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destinationVC: WordsViewController = segue.destination as! WordsViewController
		let indexPathCell = tableView.indexPathForSelectedRow?.row
		let valueOfVocabularyItem = vocabularyItem[indexPathCell!]["Name"] as! String
		_ = saveValue(at: valueOfVocabularyItem)
		_ = filteredListItems(currentItem: valueOfVocabularyItem)
		_ = filteredSubtitleItems(currentItem: valueOfVocabularyItem)
		destinationVC.textOfNavigationTitle = valueOfVocabularyItem
	}
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		
		_ = saveIndex(at: indexPath.row)
		
		if searchBarIsActive() {
			_ = indexOfComperisonValues(incomingIndex: indexPath.row)
		}
		
		let swipeDelete = UIContextualAction(style: .normal, title: "Удалить") { (action, view, success) in

			if	self.searchBarIsActive() {
				removeFiltredItem(indexPath.row)
				removeMainItem(indexOfComparisonValue)
				tableView.deleteRows(at: [indexPath], with: .middle)
			} else {
				removeMainItem(indexPath.row)
				tableView.deleteRows(at: [indexPath], with: .middle)
			}
		}
		swipeDelete.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
		swipeDelete.image = .init(systemName: "trash.fill")
		
		let swipeEdit = UIContextualAction(style: .normal, title: "Изменить") { (action, view, success) in
			self.editCurrentItem(UIButton())
			
		}
		swipeEdit.backgroundColor = #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)
		swipeEdit.image = .init(systemName: "rectangle.and.pencil.and.ellipsis")
		
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

// MARK: - Search Bar settings

extension TableViewController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
	
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		search.searchBar.setValue("Отмена", forKey: "cancelButtonText")
		search.searchBar.tintColor = .black
	}
	
	func searchBarIsEmpty() -> Bool {
		return search.searchBar.text?.isEmpty ?? true
	}
	
	func searchBarIsActive() -> Bool {
		return search.isActive && !searchBarIsEmpty()
	}
	
	func filtredSearch(searchText: String) {
		_ = filteredItems(currentItem: searchText)
		tableView.reloadData()
	}
	
	func updateSearchResults(for searchController: UISearchController) {
		filtredSearch(searchText: search.searchBar.text!)
	}
}
