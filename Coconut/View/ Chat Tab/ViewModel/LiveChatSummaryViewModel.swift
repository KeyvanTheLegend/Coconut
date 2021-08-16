//
//  LiveChatSummaryViewModel.swift
//  Coconut
//
//  Created by sh on 8/14/21.
//

import Foundation

class LiveChatSummaryViewModel : ObservableObject{
    
    /// - Parameter duration : Chat duration text
    @Published var duration : String = ""
    /// - Parameter messagesCount : How many messages sent or received since the beginning of the chat
    @Published var messagesCount : Int = 0
    /// - Parameter smilesCount : How many smiles sent or received since the beginning of the chat
    @Published var smilesCount : Int = 0
    private var startTime = 0
    /// - Parameter durationInSeconds : Helper value to count project
    private var durationInSeconds : Int = 0
    /// - Parameter durationInSeconds : Formatted duration value in hh:mm format
    private var durationFormattedText : String{
        let min = durationInSeconds/60
        let sec = durationInSeconds%60
        return "\(String(format: "%02d", min)):\(String(format: "%02d", sec))"
    }
    
    init(){
        duration = durationFormattedText
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ [weak self] timer in
            self?.durationInSeconds += 1
            self?.duration = self?.durationFormattedText ?? ""
        }
        fetchPrivateData()
    }
    func setStartTime(startTime: Int = 0 ){
        durationInSeconds += startTime
        self.startTime = startTime
    }
    func fetchPrivateData(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
        }
    }
}
