//
//  NotificationManager.swift
//  Coconut
//
//  Created by sh on 9/2/21.
//

import Foundation

class PushNotificationSender {
    static let shared = PushNotificationSender()
    
    func sendPushNotification(to token: String, title: String, body: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body, "sound":"hmmsound.caf"],
                                           "data" : ["user" : "test_id" , "sound" : "defualt"]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAjvGdz04:APA91bHKtjttF9g7D6LD_Mphdp1ta-WF6GqM2JgYHMX_bXlZ5lloFKKhmKnUSdOAxU8PZZpQ4s5lbRXTNp_z2hKU4Ehxt2sJ8JVpdLVzoslRN8gWLW3zvgci-yhAIdn13ZUiEWxeGjPJ", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
