//
//  HomeView.swift
//  +Zelo
//
//  Created by Turma01-7 on 18/05/26.
//

import SwiftUI

struct HomeView: View {
    let CorPrimaria     = Color("CorPrimaria")
    let CorSecundaria   = Color("CorSecundaria")
    let CorTerciaria    = Color("CorTerciaria")
    let CorAlerta       = Color("CorAlerta")
    let CorNotificacao  = Color("CorNotificacao")
    
    @StateObject private var viewModel = ViewModel()
    
    private var usuario: User? {
        viewModel.usuarios.first
    }

    private var nomeUsuario: String {
        usuario?.nomeU ?? "Usuário"
    }
    
    @State private var nomeRemedio: String = ""
    @State private var dataSelecionada = Date()
    
    var proximosDias: [Date] {
        let calendar = Calendar.current
        return (0..<31).map { offset in
            calendar.date(byAdding: .day, value: offset, to: Date())!
        }
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 25) {
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Olá, \(nomeUsuario)!")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("Como você está se sentindo hoje?")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(.top, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(proximosDias, id: \.self) { data in
                            CalendarioView(data: data, dataSelecionada: $dataSelecionada)
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Medicamentos")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            let medicamentos = viewModel.usuarios.first?.medicament ?? []
                            
                            ForEach(medicamentos, id: \.self) { item in
                                MedicamentoCardView(medicamento: item)
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Alimentação")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                    }
                    if let routine = viewModel.usuarios.first?.routine {
                        let listaRefeicoes = [
                            ItemRefeicao(nome: "Café da Manhã", horario: routine.cafeManha.horario, cardapio: routine.cafeManha.cardapio),
                            ItemRefeicao(nome: "Lanche da Manhã", horario: routine.lancheM.horario, cardapio: routine.lancheM.cardapio),
                            ItemRefeicao(nome: "Almoço", horario: routine.almoco.horario, cardapio: routine.almoco.cardapio),
                            ItemRefeicao(nome: "Lanche da Tarde", horario: routine.lancheT.horario, cardapio: routine.lancheT.cardapio),
                            ItemRefeicao(nome: "Jantar", horario: routine.jantar.horario, cardapio: routine.jantar.cardapio),
                            ItemRefeicao(nome: "Ceia", horario: routine.ceia.horario, cardapio: routine.ceia.cardapio)
                        ]
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(listaRefeicoes, id: \.self) { refeicao in
                                    RotinaCardView(item: refeicao, corSecundaria: CorSecundaria)
                                }
                            }
                        }
                    }
                    
                    
                }
                .onAppear(){
                    viewModel.fetch()
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    HomeView()
}
