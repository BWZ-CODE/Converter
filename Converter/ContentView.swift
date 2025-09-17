//
//  ContentView.swift
//  Converter
//
//  Created by Miguel Angel Bohorquez on 15/09/25.
//

import SwiftUI
import Combine

class KeyboardObserver: ObservableObject {
    @Published var isKeyboardVisible: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        let willShow = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .map { _ in true }
        
        let willHide = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in false }
        
        Publishers.Merge(willShow, willHide)
            .assign(to: &$isKeyboardVisible)
    }
}

struct ContentView: View {
    @State private var valor1: String = ""
    @State private var valor2: String = ""
    @State private var valor3: String = ""
    @State private var valor4: String = "Dolar"
    @State private var animation = false
    @StateObject private var keyboard = KeyboardObserver()
    
    
    
    let monedas  = ["Dolar","Euro","COP"]
    var body: some View {
        NavigationStack{
            ZStack{
                Color.beige.ignoresSafeArea(.all)
                
                VStack(spacing: 26){
                    //Valor para US
                    HStack{
                        VStack {
                            Image("usFlag").resizable().modifier(imageViewMod())
                            Text("USD").font(.footnote)
                        }
                        TextField("",text: $valor1)
                            .multilineTextAlignment(.trailing)
                            .onSubmit {
                                print("Funciono")
                                Task{
                                    do {
                                        let response = try await APINetwork().getMoney()
                                        if let USDrate = response.conversion_rates["USD"],//en estas lineas basicamente lo que hace es traer el valor que tiene USD
//                                           let COPrate = response.conversion_rates["COP"],//esta es innecesaria porque el link que traemos es el de COP
                                           let EURrate = response.conversion_rates["EUR"]//Lo mismo que US pero con EUR
                                        {
                                            if let valorIngresado = Double(self.valor1){
                                                self.valor2 = String(format: "%.2f", valorIngresado / USDrate)
                                                self.valor3 = String(format: "%.2f", (valorIngresado * USDrate)/EURrate)
                                            }
                                        }
                                        
                                    } catch {
                                        print ("Error al obtener datos")
                                    }
                                }
                            }
                            
                    }.modifier(Textsfields())
                    
                    //Valor para Col
                    HStack{
                        VStack {
                            Image("colFlag").resizable().modifier(imageViewMod())
                            Text("COP").font(.footnote)
                        }
                        TextField("",text: $valor2).multilineTextAlignment(.trailing)
                            .onSubmit {
                                print("Funciono")
                                Task{
                                    do {
                                        let response = try await APINetwork().getMoney()
                                        if let USDrate = response.conversion_rates["USD"],//en estas lineas basicamente lo que hace es traer el valor que tiene USD
//                                           let COPrate = response.conversion_rates["COP"],//esta es innecesaria porque el link que traemos es el de COP
                                           let EURrate = response.conversion_rates["EUR"]//Lo mismo que US pero con EUR
                                        {
                                            if let valorIngresado = Double(self.valor2){
                                                self.valor1 = String(format: "%.2f", valorIngresado * USDrate)
                                                self.valor3 = String(format: "%.2f", valorIngresado * EURrate)
                                            }
                                        }
                                        
                                    } catch {
                                        print ("Error al obtener datos")
                                    }
                                }
                            }
                        
                    }.modifier(Textsfields())
                    //Valor para UE
                    HStack{
                        VStack {
                            Image("ueFlag").resizable().modifier(imageViewMod())
                            Text("EUR").font(.footnote)
                        }
                        TextField("",text: $valor3).multilineTextAlignment(.trailing)
                            .onSubmit {
                                print("Funciono")
                                Task{
                                    do {
                                        let response = try await APINetwork().getMoney()
                                        if let USDrate = response.conversion_rates["USD"],//en estas lineas basicamente lo que hace es traer el valor que tiene USD
//                                           let COPrate = response.conversion_rates["COP"],//esta es innecesaria porque el link que traemos es el de COP
                                           let EURrate = response.conversion_rates["EUR"]//Lo mismo que US pero con EUR
                                        {
                                            if let valorIngresado = Double(self.valor3){
                                                self.valor1 = String(format: "%.2f", (valorIngresado * USDrate)/EURrate)
                                                self.valor2 = String(format: "%.2f", valorIngresado / EURrate)
                                            }
                                        }
                                        
                                    } catch {
                                        print ("Error al obtener datos")
                                    }
                                }
                            }
                    }.modifier(Textsfields())
                    //prueba de picker
                    
                    Section{
                        Button(action: {
                           valor1 = "0"
                            valor2 = "0"
                            valor3 = "0"
                            animation.toggle()
                        }){
                            Label("", systemImage:"arrow.trianglehead.counterclockwise")
                                .font(.title)
                                
                                .foregroundStyle(Color.azulOsc)
                                .fontWeight(.bold)
                                .symbolEffect(.rotate, value: animation)
                        }
                        
//                        Image(systemName: "arrow.trianglehead.counterclockwise").resizable().frame(width:50,height:50)
                    }
                    
                }.padding()
                    .background(Color.beigeOsc.opacity(0.4))
                    .cornerRadius(20)
                    .toolbar{
                        ToolbarItem(placement: .topBarLeading) {
                            VStack(alignment: .leading){
                                Text("Currency")
                                    .font(.system(size: keyboard.isKeyboardVisible ? 16 : 32))
                                    .animation(.easeInOut, value: keyboard.isKeyboardVisible)
                                    .fontWeight(.bold)
                                    .fontDesign(.rounded)
                                
                                Text("Converter")
                                    .font(.system(size: keyboard.isKeyboardVisible ? 16 : 32))
                                    .animation(.easeInOut, value: keyboard.isKeyboardVisible)
                                    .fontWeight(.bold)
                                    .fontDesign(.rounded)
                            }.padding(.top, keyboard.isKeyboardVisible ?  0 : 100)
                        }
                    }
                
            }
            
            
        }
    }
}

#Preview {
    ContentView()
}

struct Textsfields: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
                .background(.white)
                .cornerRadius(10)
                .shadow(radius: 9, x: 0, y: 10)
    }
    
}
struct imageViewMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 50, height: 40)
            .clipShape(.buttonBorder)
    }
}

