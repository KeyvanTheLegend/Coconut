//
//  SearchView.swift
//  Coconut
//
//  Created by sh on 8/29/21.
//

import SwiftUI

struct FindFriendsView: View {
    @State var text : String = ""
    @State var navigateToChatView = false
    @State var selectedConversationId : String? = nil
    @State var selectedUser : UserModel? = nil

    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        VStack{
            SearchBar(text: $text)
                .onChange(of: text, perform: { value in
                    //mode this to viewmodel
                    if text.isEmpty{
                        viewModel.users = []
                    }else{
                    DatabaseManager.shared.searchUser(withText: text) { users in
                        self.viewModel.users = users
                        
                    }
                    }
                })
            List {
                ForEach(viewModel.users) { user in
                    ZStack{
                    MessageViewContentView(profileImage: user.picture, name: user.name, isOnline: true)
                        .frame(height: 88, alignment: .center)
                        .frame(maxWidth: .infinity)
                        .background(Color.background)
                        .onTapGesture {
                                print("TAPPED ON A PERSON ")
                                for conversation in user.conversation {
                                    print(conversation.email)
                                    if conversation.email == UserDefaults.standard.string(forKey: "Email"){
                                        print("COVERSATION FOUND \(conversation.conversationId)")
                                        selectedConversationId = conversation.conversationId
                                        selectedUser = user
                                        navigateToChatView = true
                                        break
                                    }
                                    selectedConversationId = nil

                                }
                            selectedUser = user
                            navigateToChatView = true

	
                                
                            
                        }
                        .background(Color.background)
                        .listRowBackground(Color.background)
                        NavigationLink(
                            destination:
                                ChatView(converastionId:$selectedConversationId,user : $selectedUser)
                                .navigationBarTitleDisplayMode(.inline),
                            isActive: $navigateToChatView
                            ){
                                EmptyView()
                            }
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
            .background(Color.background)
        }
        .padding(.top , 16)
        .background(Color.background)
    }
}
class ViewModel : ObservableObject {
    @Published var users : [UserModel] = []
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        FindFriendsView()
    }
}
struct SearchBar: View {
    @Binding var text: String
 
    @State private var isEditing = false
 
    var body: some View {
        HStack {
 
            TextField("Search ...", text: $text)
                .padding(8)
                .padding(.horizontal, 4)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 16)
                .onTapGesture {
                    self.isEditing = true
                }
 
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
 
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 16)
                .transition(.move(edge: .trailing))
            }
        }
        .animation(.default)

    }
}
