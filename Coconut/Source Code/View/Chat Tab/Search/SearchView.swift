//
//  SearchView.swift
//  Coconut
//
//  Created by sh on 8/29/21.
//

import SwiftUI

struct SearchView: View {
    
    // MARK: - UI STATES
    @State var searchText : String = ""
    @State var navigateToChatView = false
    @State var selectedUser : UserModel? = nil
    
    // MARK: - VIEWMODEL
    @ObservedObject var viewModel = SearchViewModel()
    
    var body: some View {
        VStack{
            /// search bar
            SearchBar(searchText: $searchText)
                .onChange(of: searchText, perform: { value in
                    if searchText.isEmpty {
                        viewModel.clearList(delay: viewModel.SHORT_DELAY)
                    }else{viewModel.search(with : searchText)}
                })
            
            /// found useres based on serach text
            List {
                ForEach(viewModel.searchResult) { user in
                    ZStack{
                        MessageViewContentView(
                            profileImage: user.picture,
                            name: user.name,
                            isOnline: true
                        )
                        .frame(height: 88, alignment: .center)
                        .frame(maxWidth: .infinity)
                        .background(Color.background)
                        .onTapGesture {
                            selectedUser = user
                            navigateToChatView = true
                        }
                        .background(Color.background)
                        .listRowBackground(Color.background)
                        NavigationLink(
                            destination:
                                ChatView(withUser : $selectedUser)
                                .navigationBarTitleDisplayMode(.inline),
                            isActive: $navigateToChatView
                        ){EmptyView()}
                        .buttonStyle(PlainButtonStyle())
                        .frame(width:0)
                        .opacity(0)
                    }
                    .listRowBackground(Color.background)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .listRowBackground(Color.background)
            .listRowInsets(EdgeInsets())
            .background(Color.background)
            .listStyle(InsetListStyle())
        }
        .padding(.top , 16)
        .background(Color.background)
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

