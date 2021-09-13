//
//  LiveChatSummaryViewModel.swift
//  Coconut
//
//  Created by Keyvan Yaghoubian on 8/14/21.
//

import Foundation

/// - Description : This View Model Is Responsible for **LiveChatSessionView** and is broken down to Sub ViewModel of **LiveChatSummaryViewModel** to avoid vary Large ViewModel Class
/**
- parameters :
 -  summaryViewModel: This View Model is Responsible for handling dependent models accessed by  LiveChatSessionViewModel
*/
//class LiveChatSessionViewModel : ObservableObject  {
//
//    /// - sub ViewModels :
//    @Published private(set) var summaryViewModel : LiveChatSummaryViewModel
//    @Published private(set) var personImageNameStatusViewModel : PersonImageNameStatusViewModel
////    @Published private(set) var liveChatSessionModel : LiveChatSessionModel
//
//    init() {
//        self.summaryViewModel = LiveChatSummaryViewModel()
//        self.liveChatSessionModel = LiveChatSessionModel()
//        self.personImageNameStatusViewModel = PersonImageNameStatusViewModel()
//        fetch()
//
//    }
//
//    func fetch() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//           let model = LiveChatSessionModel(name: "Keyv", lastMessage: "JOON Mame hato bokhoram", startTime: 10)
//            self.liveChatSessionModel = model
//            self.summaryViewModel.setStartTime(startTime: model.startTime)
//            self.personImageNameStatusViewModel.setName(name: model.name)
//            self.personImageNameStatusViewModel.setProfileImage(image: "profile")
//            self.personImageNameStatusViewModel.setStatusMessage(statusMessage: model.lastMessage)
//
//        }
//    }
//
//
//}
