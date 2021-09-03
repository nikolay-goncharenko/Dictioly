//
//  Model.swift
//  Dictioly
//
//  Created by Nikolay Goncharenko on 14.04.2021.
//

import Foundation

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

//var listOfFlagsAndLanguages = ["usa":"Английский (США)", "gb":"Английский", "russia":"Русский", "ua":"Украинский"]
var listOfFlagsAndLanguages: [String] = ["Английский (США)", "Английский (Великобритания)", "Русский", "Украинский"]
//var filtredListOfFlagsAndLanguages: [String] = []
//
//func filtredListOfFlagsAndLanguage(currentItem: String) -> Array<String> {
//	filtredListOfFlagsAndLanguages.removeAll()
//	filtredListOfFlagsAndLanguages.append(listOfFlagsAndLanguages.filter { currentItem in
//		return currentItem.lowercased().contains(currentItem.lowercased())
//	})
//	filtredListOfFlagsAndLanguages.removeAll{$0 == ""}
//}

var indexOfCell: Int = 0

func saveIndex(at index: Int) -> Int {
	indexOfCell = index
	return indexOfCell
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

func addItem(nameItem: String) {
	vocabularyItem.append(["Name": nameItem])
}

var vocabularyItemValue: String = ""

func saveValue(at value: String) -> String {
	vocabularyItemValue = value
	return vocabularyItemValue
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


func addListItem(nameItem: String) {
	listItem.append([vocabularyItemValue: nameItem])
}

func addSubtitleItem(nameItem: String) {
	subtitleItem.append([vocabularyItemValue: nameItem])
}

func removeItem(at index: Int) {
	vocabularyItem.remove(at: index)
}

func removeListItem(at index: Int) {
	listItem.remove(at: index)
}

func removeSubtitleItem(at index: Int) {
	subtitleItem.remove(at: index)
}

func changeItem(at index: Int, newNameItem: String) {
	vocabularyItem[index].updateValue(newNameItem, forKey: "Name")
}

func moveItem(fromInex: Int, toIndex: Int) {
	let from = vocabularyItem[fromInex]
	vocabularyItem.remove(at: fromInex)
	vocabularyItem.insert(from, at: toIndex)
}
