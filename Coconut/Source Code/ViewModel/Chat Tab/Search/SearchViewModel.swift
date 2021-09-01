//
//  SearchViewModel.swift
//  Coconut
//
//  Created by Keyvan Yaghoubian on 8/31/21.
//

import Foundation

class SearchViewModel : ObservableObject {
    
    typealias SearchResult = [UserModel]
    
    let SHORT_DELAY : Double = 0.2
    
    @Published var searchResult : SearchResult = []
    
    /// serach for user by name
    /// - Parameter searchText: user serach text
    func search(with searchText : String) {
            DatabaseManager.shared.searchUser(withText: searchText) { searchResult in
                DispatchQueue.main.async {self.searchResult = searchResult}
            }
        
    }
    /// clear serach list
    /// - Parameter delay: delay in mllisecond, defaul is 0
    func clearList(delay : Double = 0){
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.searchResult.removeAll()
        }
    }
}
