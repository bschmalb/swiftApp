//
//  ContentView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 25.03.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

let apiUrl = "http://192.168.2.128:9000"

struct Tipp: Identifiable, Decodable, Hashable{
    let id = UUID()
    let title: String
    let description: String
}

class TippViewModel : ObservableObject {
    
    @Published var tipps: [Tipp] = [
        .init(title: "Server Error", description: "Stellen Sie sicher, dass Sie mit dem Internet verbunden sind"),
        .init(title: "Server Error", description: "Stellen Sie sicher, dass Sie mit dem Internet verbunden sind")
    ]
    
    
    func fetchTipps() {
        guard let url = URL(string: apiUrl) else {
            print("Invalid Url")
            return
            
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Tipp].self, from: data) {
                    DispatchQueue.main.async {
                        self.tipps = decodedResponse
                    }
                    return
                }
            }
            print("Fetch failed:  \(error?.localizedDescription ?? "Unknown Error")")
            
            
            //            DispatchQueue.main.async {
            //                self.tipps = try! JSONDecoder().decode([Tipp].self, from: data!)
            //            }
        }.resume()
    }
    
}


struct ContentView: View {
    //    @State var apiManager = ApiManager()
    
    @ObservedObject var tippVM = TippViewModel()
    
    //    var items = [Color.red, Color.orange, Color.yellow, Color.green,                 Color.blue, Color.purple]
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    print("Reload fetchTipps()")
                    // Call func in SomeView()
                    self.tippVM.fetchTipps()
                }) {
                    Text("Reload")
                }
                .padding(.trailing)
            }
            ScrollView(Axis.Set.horizontal, showsIndicators: false){
                HStack {
                    ForEach(tippVM.tipps) { tipp in
                        GeometryReader { geometry in
                            VStack{
                                Text(tipp.title)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.all)
                                Text(tipp.description)
                                    .foregroundColor(Color.white)
                                    .padding(.horizontal)
                            }
                            .frame(width: UIScreen.main.bounds.width - 60, height:
                                UIScreen.main.bounds.height - 240)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color(hue: 0.332, saturation: 1.0, brightness: 0.516)]), startPoint: .topLeading, endPoint: .bottom))
                                .cornerRadius(15)
                                .padding(5)
                                .rotation3DEffect(Angle(degrees:
                                    (Double(geometry.frame(in: .global).minX) - 20 ) / -20), axis: (x: 0, y: 10.0, z:0))
                        }.frame(width: UIScreen.main.bounds.width - 60, height:
                            UIScreen.main.bounds.height - 200)
                    }
                }.padding(20)
            }.onAppear { self.tippVM.fetchTipps() }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
