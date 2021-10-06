//
//  Model.swift
//  Dictioly
//
//  Created by Nikolay Goncharenko on 14.04.2021.
//

import Foundation

// MARK: - Storages for data
// Вычисляемые перменные формата массив-словарей для хранения данных

var vocabularyItem: [[String: Any]] {
	set {
		UserDefaults.standard.setValue(newValue, forKey: "ItemDataKey")
		UserDefaults.standard.synchronize()
	}
	
	get {
		if let array = UserDefaults.standard.array(forKey: "ItemDataKey") as? [[String: Any]] {
			return array
		} else {
			return []
		}
	}
}

var listItem: [[String: Any]] {
	set {
		UserDefaults.standard.setValue(newValue, forKey: "ListDataKey")
		UserDefaults.standard.synchronize()
	}
	
	get {
		if let array = UserDefaults.standard.array(forKey: "ListDataKey") as? [[String: Any]] {
			return array
		} else {
			return []
		}
	}
}

var subtitleItem: [[String: Any]] {
	set {
		UserDefaults.standard.setValue(newValue, forKey: "SubtitleDataKey")
		UserDefaults.standard.synchronize()
	}

	get {
		if let array = UserDefaults.standard.array(forKey: "SubtitleDataKey") as? [[String: Any]] {
			return array
		} else {
			return []
		}
	}
}

var listOfFlagsAndLanguages: [String] = ["Английский (США)", "Английский (Великобритания)", "Русский", "Украинский"]

// MARK: - Service Methods and Variables

var indexOfCell: Int = 0

func saveIndex(at index: Int) -> Int {
	indexOfCell = index
	return indexOfCell
}

var vocabularyItemValue: String = ""

func saveValue(at value: String) -> String {
	vocabularyItemValue = value
	return vocabularyItemValue
}

// MARK: - Methods & Variables for filtering data

var indexOfComparisonValue: Int = 0

func indexOfComperisonValues(incomingIndex: Int) -> Int {
	for (index, dictionary) in vocabularyItem.enumerated() {
		for (_, value) in dictionary {
			let vocabularyValue = value as! String
			if vocabularyValue.lowercased() == filtredItem[incomingIndex].lowercased() {
				indexOfComparisonValue = index
			}
		}
	}
	return indexOfComparisonValue
}

var filtredItem: [String] = []

func filteredItems(currentItem: String) -> Array<String> {
	filtredItem.removeAll()
	for itemIndex in vocabularyItem {
		for (_, itemValue) in itemIndex {
			let item = itemValue as! String
			filtredItem.append(item.filter { vocabularyItem in
				return item.lowercased().contains(currentItem.lowercased())
			})
			filtredItem.removeAll{$0 == ""}
		}
	}
	return filtredItem
}

var indexOfFiltredListItem: Int = 0
var indexOfFiltredSubtitleItem: Int = 0

func indexOfFiltredListItems(incomingIndex: Int) -> Int {
	for (index, dictionary) in listItem.enumerated() {
		for (_, value) in dictionary {
			let listItemValue = value as! String
			if listItemValue.lowercased() == filtredListItem[incomingIndex].lowercased() {
				indexOfFiltredListItem = index
			}
		}
	}
	return indexOfFiltredListItem
}

func indexOfFiltredSubtitleItems(incomingIndex: Int) -> Int {
	for (index, dictionary) in subtitleItem.enumerated() {
		for (_, value) in dictionary {
			let subtitleItemValue = value as! String
			if subtitleItemValue.lowercased() == filtredSubtitleItem[incomingIndex].lowercased() {
				indexOfFiltredSubtitleItem = index
			}
		}
	}
	return indexOfFiltredSubtitleItem
}

var filtredListItem: [String] = []
var filtredSubtitleItem: [String] = []

func filteredListItems(currentItem: String) -> Array<String> {
	filtredListItem.removeAll()
	for itemIndex in listItem {
		for (itemKey, itemValue) in itemIndex {
			let listItemValue = itemValue as! String
			filtredListItem.append(listItemValue.filter {_ in
				return itemKey.lowercased().contains(currentItem.lowercased())
			})
			filtredListItem.removeAll{$0 == ""}
		}
	}
	return filtredListItem
}

func filteredSubtitleItems(currentItem: String) -> Array<String> {
	filtredSubtitleItem.removeAll()
	for itemIndex in subtitleItem {
		for (itemKey, itemValue) in itemIndex {
			let listItemValue = itemValue as! String
			filtredSubtitleItem.append(listItemValue.filter {_ in
				return itemKey.lowercased().contains(currentItem.lowercased())
			})
			filtredSubtitleItem.removeAll{$0 == ""}
		}
	}
	return filtredSubtitleItem
}

func mainPhraseCounter(incomingIndex: Int) -> Int {
	var mainPhraseInArray: [String] = []
	let vocabularyPhraseValue = vocabularyItem[incomingIndex]["Name"] as! String
	
	for mainWordListDictionary in listItem {
		for (key, _) in mainWordListDictionary {
			if vocabularyPhraseValue.lowercased() == key.lowercased() {
				mainPhraseInArray.append(key)
			}
		}
	}
	return mainPhraseInArray.count
}

func filtredPhraseCounter(incomingIndex: Int) -> Int {
	var filtredPhraseInArray: [String] = []
	let filtredPhraseValue = filtredItem[incomingIndex]
	
	for filtredWordListDictionary in listItem {
		for (key, _) in filtredWordListDictionary {
			if filtredPhraseValue.lowercased() == key.lowercased() {
				filtredPhraseInArray.append(key)
			}
		}
	}
	return filtredPhraseInArray.count
}

// MARK: - Methods for saving data to storege

func addItem(nameItem: String) {
	vocabularyItem.append(["Name": nameItem])
}

func addListItem(nameItem: String) {
	listItem.append([vocabularyItemValue: nameItem])
}

func addSubtitleItem(nameItem: String) {
	subtitleItem.append([vocabularyItemValue: nameItem])
}

// MARK: - Methods for removing data from storege

func removeMainItem(_ index: Int) {
	vocabularyItem.remove(at: index)
}

func removeFiltredItem(_ index: Int) {
	filtredItem.remove(at: index)
}

func removeMainWordListItem(_ index: Int) {
	listItem.remove(at: index)
	subtitleItem.remove(at: index)
}

func removeFiltredWordListItem(_ index: Int) {
	filtredListItem.remove(at: index)
	filtredSubtitleItem.remove(at: index)
}

// MARK: - Methods for chenging data in storage

func changeVocabularyItem(at index: Int, newNameItem: String) {
	vocabularyItem[index].updateValue(newNameItem, forKey: "Name")
}

func changeFiltredItem(at index: Int, newNameItem: String) {
	filtredItem[index] = newNameItem
}

// MARK: - Methods for moving rows in tableView

func moveItem(fromInex: Int, toIndex: Int) {
	let from = vocabularyItem[fromInex]
	vocabularyItem.remove(at: fromInex)
	vocabularyItem.insert(from, at: toIndex)
}
