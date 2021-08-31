//
//  ChatView.swift
//  Coconut
//
//  Created by sh on 8/17/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatView: View {

    @State var text : String = ""
    @State var shouldHaveExteraButtonPadding = false
    @State var testing : CGFloat = 0
    @State var bottomPadding : CGFloat = 0
    @StateObject var viewModel = ChatViewModel()
    @Binding var converastionId :String?
    @Binding var user :UserModel?


    var body: some View {
        VStack(alignment :  .leading , spacing: 0){
            ZStack{
            ChatHeaderView(user: $user)
                .background(Color.background.opacity(0.95))
                
                .padding(0)
                
            }
            .background(BlurView().ignoresSafeArea(.container, edges: .top))
            .zIndex(2)
            Divider()
                .zIndex(2)
            Spacer()
            ScrollViewReader { scrollViewReader in
            List{
                ForEach(viewModel.messages) { item in
                    if item.senderEmail == UserDefaults.standard.string(forKey: "Email")!{
                        SentMessageView(messsage: item.text)
                            .id(item.id)

                    }else{
                        RecivedTextMessage(messsage: item.text)
                            .id(item.id)
                            .listRowBackground(Color.background)
                        
                    }
                }


            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .listRowBackground(Color.background)
            .listRowInsets(EdgeInsets())
            .background(Color.background)
            .listStyle(InsetListStyle())
            .background(Color.background)
            .listRowInsets(EdgeInsets())
            .offset(CGSize(width: 0, height: -testing + 10 ))
            .background(Color.background)
            .onChange(of: testing, perform: { value in
                withAnimation {
                    if viewModel.messages.count > 0 {
                    scrollViewReader.scrollTo(viewModel.messages[viewModel.messages.count - 1].id,anchor: .bottom)
                    }
                }
            })
            .onChange(of: viewModel.messages.count, perform: { value in
                withAnimation{
                if viewModel.messages.count > 0 {
                    print("onchange viewmodel message \(viewModel.messages.count)")
                    print("ID \(viewModel.messages[viewModel.messages.count - 1 ].id)")
                    scrollViewReader.scrollTo(viewModel.messages[viewModel.messages.count - 1 ].id, anchor: .bottom)
                }
                }
            })

            }
            SendMessageView(viewModel: viewModel,text: $text)
                .background(Color.background, alignment: .bottom)
                .offset(x: 0 , y: -testing)
                .padding(.bottom , shouldHaveExteraButtonPadding ? bottomPadding : 0)
                .background(Color.background, alignment: .bottom)
                .ignoresSafeArea(.all, edges: .bottom)
                .padding(.top,8)
        }
        .background(Color.background.ignoresSafeArea())
        .ignoresSafeArea(.all, edges: .bottom)
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear(perform: {
            UITextView.appearance().backgroundColor = .clear

            if let window = UIApplication.shared.windows.first{
                let tempBottomPadding = window.safeAreaInsets.bottom
                print(tempBottomPadding)
                if tempBottomPadding > 0 {
                    bottomPadding = 34
                    shouldHaveExteraButtonPadding = true
                }
            }
        })
        .onAppear(perform: {
            print("CHAT VIEW ON APPEAR CONVERSATIONID IS  : \(converastionId)")
            viewModel.setConverationId(convesationId: converastionId)
            viewModel.setUser(user : user)
            
        })
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)) { notifictation in
            let keyboardSize = notifictation.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            let keyboardheight = keyboardSize.height
            let duration = notifictation.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
            shouldHaveExteraButtonPadding = false
            withAnimation(.easeOut(duration: (duration - 0.05)) ) {
                testing  = keyboardheight
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)) { notifictation in
            let duration = notifictation.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
            withAnimation(.easeOut(duration: (duration + 0.03)).delay(0.03) ) {
                testing  = 0
                if bottomPadding > 0 {
                    shouldHaveExteraButtonPadding = true
                }
            }
        
        }
        .onDisappear(perform: {
            print("HI IM HERE ")
            viewModel.setConverationId(convesationId: nil)
            viewModel.messages.removeAll()
            

        })
        .ignoresSafeArea(.keyboard)

    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
//            ChatView(converastionId: nil)
        }
    }
}

struct ChatHeaderView : View {
    @Binding var user : UserModel?
    
    var body: some View {
        HStack(alignment : .top){
            WebImage(url: URL(string: user?.picture ?? ""))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 90, alignment: .center)
                .cornerRadius(12)
                .clipped()
                .aspectRatio(contentMode: .fit)
                .padding([.all],16)
                .hiddenTabBar()
            VStack (alignment: .leading, spacing: 8, content: {
                
                Text(user?.name ?? "")
                    .foregroundColor(.white)
                    .font(.title3.weight(.medium))
                HStack{
                    
                    Circle()
                        .frame(width: 10, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color.primery)
                    Text("Typing")
                        .foregroundColor(.gray)
                        .font(.caption)
                        .lineLimit(2)
                }
                Spacer()
            })
            .padding(.top,32)
            Spacer()
            
        }.frame(height : 100)
    }
}
struct SendMessageView : View {
    @ObservedObject var viewModel : ChatViewModel
    @Binding var text :String
    var body: some View {
        VStack(spacing : 8){
            Divider()
            
            HStack (alignment : .bottom, spacing : 0){
                TextEditor(text: $text)
                    .background(Color.white)
                    .cornerRadius(8, antialiased: true)
                    .frame(minHeight: 40, alignment: .leading)
                    .foregroundColor(.black)
                    .padding(.horizontal,16)
                    .padding(.bottom,8)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                    .placeholder(when: true, alignment: .leading) {
                        Text("Start typing ...")
                            .zIndex(text.isEmpty ? 2: 0)
                            .padding(.leading , 22)
                            .padding(.bottom , 10)
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                Image(systemName: "arrow.up")
                    .frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(Color.primery)
                    .cornerRadius(20)
                    .padding([.trailing], 16)
                    .padding([.bottom],8)
                    .foregroundColor(.white)
                    .onTapGesture {
                        
                        viewModel.sendMessage(message: text)
                        text = ""
                    }
                
            }
            
        }
    }
}
struct RecivedTextMessage : View {
    var messsage : String

    var body: some View {
        HStack(alignment :.center) {
            Text(messsage)
                .foregroundColor(.white)
                .padding(8)
                .padding([.horizontal],12)
                .background(Color.primery)
                .cornerRadius(30)
                .font(.subheadline)
        }
        .padding(16)
        .padding(.bottom , 0)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .listRowBackground(Color.background)
        .listRowInsets(EdgeInsets(.zero))
        .background(Color.background)
        .listStyle(InsetListStyle())
        
    }
}
struct SentMessageView : View {
    var messsage : String
    var body: some View {
        HStack(alignment :.center) {
            Spacer()
            Text(messsage)
                .foregroundColor(.black)
                .padding(8)
                .padding([.horizontal],12)
                .font(.subheadline)
                .background(Color.white)
                .cornerRadius(30, antialiased: false)
        }
        .padding(8)
        .padding(.top , 0)
        .padding(.leading , 64)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .listRowBackground(Color.background)
        .listRowInsets(EdgeInsets())
        .background(Color.background)
    }
}
struct BlurView: UIViewRepresentable {
    typealias UIViewType = UIVisualEffectView
    
    let style: UIBlurEffect.Style
    
    init(style: UIBlurEffect.Style = .dark) {
        self.style = style
    }
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: self.style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: .dark)
    }
}
