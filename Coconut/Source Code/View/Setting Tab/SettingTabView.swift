//
//  SettingTabView.swift
//  Coconut
//
//  Created by sh on 8/22/21.
//

import SwiftUI

struct SettingTabView: View {
    var body: some View {
        NavigationView{
            ScrollView {
                VStack {
                    SettingTabHeaderView()
                    Divider()
                    
                    HStack(alignment : .center){
                        VStack (alignment : .center){
                        Image("memoji1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.primery)
                            .frame(width: 45, height: 45, alignment: .center)
                        }
                        .frame(width: 50, height: 50, alignment: .center)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .padding(.horizontal , 16)
                        .padding(.vertical , 4)

                        Text("Avatar")
                            .font(.title3)
                            .foregroundColor(.whiteColor)
                        Spacer()
                    }
                    Divider()
                    HStack(alignment : .center){
                        VStack (alignment : .center){
                        Image(systemName: "person.2.fill")
                            .resizable()
                            .foregroundColor(.primery)
                            .imageScale(/*@START_MENU_TOKEN@*/.medium/*@END_MENU_TOKEN@*/)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30, alignment: .center)
                        }
                        .frame(width: 50, height: 50, alignment: .center)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .padding(.horizontal , 16)
                        .padding(.vertical , 4)

                        Text("Friends")
                            .font(.title3)
                            .foregroundColor(.whiteColor)
                        Spacer()
                    }
                    Divider()
                    HStack(alignment : .center){
                        VStack (alignment : .center){
                        Image(systemName: "hand.thumbsup.fill")
                            .resizable()
                            .foregroundColor(.primery)
                            .imageScale(/*@START_MENU_TOKEN@*/.medium/*@END_MENU_TOKEN@*/)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22, height: 22, alignment: .center)
                        }
                        .frame(width: 50, height: 50, alignment: .center)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .padding(.horizontal , 16)
                        .padding(.vertical , 4)

                        Text("Interests")
                            .font(.title3)
                            .foregroundColor(.whiteColor)
                        Spacer()
                    }
                    Divider()
                    HStack(alignment : .center){
                        VStack (alignment : .center){
                        Image(systemName: "info")
                            .resizable()
                            .foregroundColor(.primery)
                            .imageScale(/*@START_MENU_TOKEN@*/.medium/*@END_MENU_TOKEN@*/)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22, height: 22, alignment: .center)
                        }
                        .frame(width: 50, height: 50, alignment: .center)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .padding(.horizontal , 16)
                        .padding(.vertical , 4)
                        
                        Text("Bio")
                            .font(.title3)
                            .foregroundColor(.whiteColor)
                        Spacer()
                    }
                    Divider()

                }
                .frame(maxWidth : .infinity)
                .padding(.top,16)
            }
            .fixFlickering()
            .background(Color.background
                            .ignoresSafeArea())
            .navigationBarTitle("Setting")
        }
    }
}

struct SettingTabView_Previews: PreviewProvider {
    static var previews: some View {
        SettingTabView()
    }
}
struct SettingTabHeaderView : View {
    var body: some View{
        HStack(alignment : .top){
            ImageView(withURL: UserDefaults.standard.string(forKey: "ProfilePictureUrl") ?? "" )
                .frame(width: 80, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(Color.primery)
                .cornerRadius(12)
                .font(.title)
                .padding(.horizontal ,16)
            VStack(alignment : .leading){
                Text(UserDefaults.standard.string(forKey: "Name") ?? "")
                    .foregroundColor(.white)
                    .padding(.top , 10)
                    .font(.title3)
                Text(UserDefaults.standard.string(forKey: "Email") ?? "")
                    .foregroundColor(.gray)
                    .padding(.vertical , 4)
                    .font(.body)
                
            }
            Spacer()
        }
    }
}
//struct RemoteImage : Image {
//
//    init(withUrl : String) {
//        fetchImage(with: withUrl)
//    }
//    private func fetchImage(with url : String){
//        guard let url = URL(string: url) else {
//            return
//        }
//        let task = URLSession.shared.dataTask(
//            with: url,
//            completionHandler: { (data, response, error) in
//                guard let data = data,
//                      let image = UIImage(data: data) else { return }
//                DispatchQueue.main.async {
//
//                }
//        })
//    }
//}
import Combine
class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}
struct ImageView: View {
    @ObservedObject var imageLoader:ImageLoader
    @State var image:UIImage = UIImage()

    init(withURL url:String) {
        print(url)
        print("HI")
        print("ASD \(UserDefaults.standard.string(forKey: "ProfilePictureUrl"))")
        imageLoader = ImageLoader(urlString:url)
    }

    var body: some View {
        
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:80, height:80)
                .onReceive(imageLoader.didChange) { data in
                self.image = UIImage(data: data) ?? UIImage()
        }
    }
}
