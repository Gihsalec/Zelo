//
//  ContentView.swift
//  +Zelo
//
//  Created by Turma01-7 on 18/05/26.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationStack{
            
            TabView {
                HomeView()
                    .badge(0)
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                        
                    }
                
                VacinasView()
                    .badge(0)
                    .tabItem {
                        Label("Vacinas", systemImage: "syringe.fill")
                    }
                
                RotinasView()
                    .badge(0)
                    .tabItem {
                        Label("Rotinas", systemImage: "book.fill")
                    }
                
                PersonView()
                    .badge(0)
                    .tabItem {
                        Label("Perfil", systemImage: "person")
                    }
                    .environmentObject(ViewModel())
            }
            .navigationTitle("+Zelo")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: NotificationView()) {
                        Image(systemName: "bell")
                    }
                }
            }
        }
        .accentColor(.corSecundaria)
    }
}

#Preview {
    ContentView()
}

