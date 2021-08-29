//
//  ImageView.swift
//  Coconut
//
//  Created Keyvan Yaghoubian on 8/29/21.
//

import SwiftUI
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
    @State var isImageLoaded = true

    init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
    }

    var body: some View {
        ZStack{
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:80, height:80)
                .onAppear {
                    if isImageLoaded {
                    DispatchQueue.main.asyncAfter(deadline: .now() , execute: {
                        isImageLoaded = false
                    })
                    }
                }
                .onReceive(imageLoader.didChange) { data in
                    withAnimation(.easeIn(duration: 1).repeatForever(autoreverses: false)) {
                        print("HI IM HRE")
                        self.isImageLoaded = true
                        print(isImageLoaded)

                    }
                    self.image = UIImage(data: data) ?? UIImage()
        }
            if image == UIImage() {
                Image(systemName: "circle.dashed")
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .center)
                    .foregroundColor(.white)
                    .rotationEffect(isImageLoaded ? Angle(degrees: -360) : .zero)
                    .animation(!isImageLoaded ? .easeIn(duration: 1).repeatForever(autoreverses: false) : .linear(duration: 0))
            }
        }
    }
}
