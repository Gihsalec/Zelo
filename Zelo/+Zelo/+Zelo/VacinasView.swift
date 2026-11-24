//
//  VacinasView.swift
//  ProjetoFinal
//
//  Created by Turma01-5 on 19/05/26.
//

import SwiftUI

// MARK: - Tela Principal (Home)
struct VacinasView: View {
    let CorPrimaria     = Color("CorPrimaria")
    let CorSecundaria   = Color("CorSecundaria")
    let CorTerciaria    = Color("CorTerciaria")
    let CorAlerta       = Color("CorAlerta")
    let CorNotificacao  = Color("CorNotificacao")

    @StateObject private var viewModel = ViewModel()

    // Variáveis de estado atualizadas para o tipo do banco de dados
    @State private var vacinaSelecionada: VacinaUsuario? = nil
    @State private var vacinaAtrasadaSelecionada: VacinaUsuario? = nil

    // MARK: - Dados derivados do ViewModel

    /// Primeiro usuário retornado pelo banco (ajuste o índice se necessário)
    private var usuario: User? {
        viewModel.usuarios.first
    }

    /// Nome de exibição do usuário
    private var nomeUsuario: String {
        usuario?.nomeU ?? "Usuário"
    }

    /// Vacinas com data de aplicação válida (não atrasadas)
    private var historicoVacinas: [VacinaUsuario] {
        usuario?.vaccine.filter { $0.dataAplicacao.lowercased() != "atrasada" } ?? []
    }

    /// Vacinas marcadas como atrasadas
    private var historicoVacinasAtrasadas: [VacinaUsuario] {
        usuario?.vaccine.filter { $0.dataAplicacao.lowercased() == "atrasada" } ?? []
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    HStack {
                        Text("Olá, \(nomeUsuario)!")
                            .font(.system(size: 28, weight: .bold))
                    }
                    .padding(.top, 10)

                    // 2. Barra de Busca / Mapa de Postos
                    HStack {
                        NavigationLink(destination: PostosDeSaudeView()) {
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(.gray)
                                Text("Mapa de Postos")
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(25)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        }
                    }

                    // 3. Seção de Alerta
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Alerta")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)

                        if historicoVacinasAtrasadas.isEmpty {
                            HStack {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(CorSecundaria)
                                Text("Sem nenhuma vacina pendente")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        } else {
                            ForEach(historicoVacinasAtrasadas) { vacinatrasada in
                                Button(action: {
                                    vacinaAtrasadaSelecionada = vacinatrasada
                                }) {
                                    staticHStackAlerta(vacinatrasada: vacinatrasada)
                                }
                                .foregroundColor(.white)
                                .padding(16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(CorAlerta)
                                .cornerRadius(12)
                                .contentShape(Rectangle())
                            }
                        }
                    }

                    // 4. Seção Histórico e Campanha
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Histórico e Campanha")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)

                        if viewModel.usuarios.isEmpty {
                            // Estado de carregamento
                            HStack {
                                Spacer()
                                ProgressView("Carregando vacinas...")
                                    .padding()
                                Spacer()
                            }
                        } else if historicoVacinas.isEmpty {
                            Text("Nenhuma vacina registrada.")
                                .foregroundColor(.secondary)
                                .padding(.top, 8)
                        } else {
                            VStack(spacing: 12) {
                                ForEach(historicoVacinas) { vacina in
                                    Button(action: {
                                        vacinaSelecionada = vacina
                                    }) {
                                        HStack {
                                            Text(vacina.nome)
                                                .font(.system(size: 18, weight: .bold))
                                                .foregroundColor(.white)
                                                .padding(.leading, 16)
                                            Spacer()
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 55)
                                        .background(CorSecundaria)
                                        .cornerRadius(12)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .onAppear {
                viewModel.fetch()
            }
            // Sheet da Vacina Aplicada
            .sheet(item: $vacinaSelecionada) { vacina in
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 25) {
                        Capsule()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 40, height: 5)
                            .padding(.top, 10)

                        Image(systemName: "shield.checkerboard")
                            .font(.system(size: 60))
                            .foregroundColor(CorSecundaria)

                        VStack(spacing: 8) {
                            Text(vacina.nome)
                                .font(.title2)
                                .fontWeight(.bold)
                        }

                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Dose aplicada:")
                                    .fontWeight(.semibold)
                                Spacer()
                                Text(vacina.dose)
                                    .foregroundColor(.secondary)
                            }

                            Divider()

                            HStack {
                                Text("Data da aplicação:")
                                    .fontWeight(.semibold)
                                Spacer()
                                Text(vacina.dataAplicacao)
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                            }

                            Divider()

                            HStack {
                                Text("Status:")
                                    .fontWeight(.semibold)
                                Spacer()
                                Text("Imunizado")
                                    .foregroundColor(CorSecundaria)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)

                        Button(action: {
                            vacinaSelecionada = nil
                        }) {
                            Text("Fechar")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(CorSecundaria)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)
                }
                .presentationDetents([.medium])
            }
            // Sheet da Vacina Atrasada
            .sheet(item: $vacinaAtrasadaSelecionada) { vacinatrasada in
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 25) {
                        Capsule()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 40, height: 5)
                            .padding(.top, 10)

                        Image(systemName: "light.beacon.max.fill")
                            .font(.system(size: 60))
                            .foregroundColor(CorAlerta)

                        VStack(spacing: 8) {
                            Text(vacinatrasada.nome)
                                .font(.title2)
                                .fontWeight(.bold)
                        }

                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Dose pendente:")
                                    .fontWeight(.semibold)
                                Spacer()
                                Text(vacinatrasada.dose)
                                    .foregroundColor(.secondary)
                            }

                            Divider()

                            HStack {
                                Text("Status:")
                                    .fontWeight(.semibold)
                                Spacer()
                                Text("Atrasada")
                                    .foregroundColor(CorAlerta)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)

                        Button(action: {
                            vacinaAtrasadaSelecionada = nil
                        }) {
                            Text("Fechar")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(CorSecundaria)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)
                }
                .presentationDetents([.medium])
            }
        }
    }

    @ViewBuilder
    private func staticHStackAlerta(vacinatrasada: VacinaUsuario) -> some View {
        HStack {
            Text("Vacina atrasada: \(vacinatrasada.nome) (\(vacinatrasada.dose))")
                .font(.system(size: 18, weight: .bold))
                .padding(20)
        }
    }
}

// MARK: - Extensão de Conformidade
extension VacinaUsuario: Identifiable {
    public var id: String { vacID }
}

#Preview {
    VacinasView()
}
