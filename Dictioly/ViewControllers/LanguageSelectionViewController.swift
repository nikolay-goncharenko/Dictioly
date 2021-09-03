//
//  LanguageSelectionViewController.swift
//  Dictioly
//
//  Created by Nikolay Goncharenko on 04.08.2021.
//

import UIKit

class LanguageSelectionViewController: UIViewController {
	
	@IBOutlet weak var searchLanguageBar: UISearchBar!
	@IBOutlet weak var tableView: UITableView!
	let tableCell = "LanguageCell"
	
    override func viewDidLoad() {
        super.viewDidLoad()

		searchLanguageBar.delegate = self
		searchLanguageBar.placeholder = "Найти язык"
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
    }
	
	@IBAction func closeCurrentView(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
}

extension LanguageSelectionViewController: UISearchBarDelegate {
	
	func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
		searchLanguageBar.setShowsCancelButton(true, animated: true)
		return true
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchLanguageBar.setShowsCancelButton(false, animated: true)
		searchLanguageBar.resignFirstResponder()
	}
	
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		let cancelSearchButton = searchLanguageBar.value(forKey: "cancelButton") as! UIButton
		cancelSearchButton.setTitle("Отмена", for: .normal)
	}
}

extension LanguageSelectionViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return listOfFlagsAndLanguages.count
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Все языки (\(listOfFlagsAndLanguages.count))"
	}
	
	func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		view.tintColor = .white
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: tableCell, for: indexPath) as? ListOfLanguagesCell {
			cell.countryFlag.image = UIImage(named: listOfFlagsAndLanguages.sorted()[indexPath.row])
			cell.countryLanguage?.text = listOfFlagsAndLanguages.sorted()[indexPath.row]
			return cell
		} else {
			return ListOfLanguagesCell()
		}
	}
}
