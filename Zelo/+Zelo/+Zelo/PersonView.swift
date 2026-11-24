//
//  PersonView.swift
//  +Zelo
//
//  Created by Turma01-7 on 18/05/26.
//

import SwiftUI
import QuickLook
import UniformTypeIdentifiers

enum SecaoSaude: String, CaseIterable {
    case familia = "Família", dados = "Dados", historico = "Histórico", exames = "Exames"
}

struct ExameLocal: Identifiable {
    let id = UUID()
    let tipo: String
    let dataExame: String
    let laboratorio: String = "Arquivo Local"
    let urlArquivo: URL
}


struct PersonView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var secao: SecaoSaude = .familia
    @State private var urlPDF: URL? = nil
    @State private var exibirSeletor = false
    @State private var examesLocais: [ExameLocal] = []
    
    private var usuario: User? { viewModel.usuarios.first }
    
    private var cabecalhoPerfil: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .resizable().scaledToFit().frame(width: 130, height: 130)
                .foregroundColor(.gray.opacity(0.6))
            if let u = usuario {
                Text("\(u.nomeU) \(u.sobrenome)").font(.title2).fontWeight(.medium)
            } else {
                Text("Carregando...").font(.title2).fontWeight(.medium).foregroundColor(.gray)
            }
        }
        .padding(.top, 25).padding(.bottom, 20)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            cabecalhoPerfil
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 25) {
                    ForEach(SecaoSaude.allCases, id: \.self) { s in
                        Button { withAnimation(.spring()) { secao = s } } label: {
                            VStack(spacing: 8) {
                                Text(s.rawValue).font(.headline)
                                    .foregroundColor(secao == s ? Color(hex: "17BEBB") : .gray)
                                Rectangle().frame(height: 3)
                                    .foregroundColor(secao == s ? Color(hex: "17BEBB") : .clear)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 15)
            
            Divider()
            
            if usuario == nil {
                Spacer(); ProgressView("Carregando dados..."); Spacer()
            } else if let u = usuario {
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        switch secao {
                        case .familia:
                            SecaoTitulo("Membros da Família")
                            ForEach(u.familia, id: \.email) { CartaoMembroFamiliaView(membro: $0) }
                            
                        case .dados:
                            SecaoTitulo("Ficha de Dados Médicos")
                            InterfaceDadosMedicosView(dados: u)
                            
                        case .historico:
                            SecaoTitulo("Histórico de Consultas")
                            ForEach(u.consulta, id: \.docID) { CartaoHistoricoView(consulta: $0) }
                            
                        case .exames:
                            HStack {
                                SecaoTitulo("Lista de Exames")
                                Spacer()
                                Button { exibirSeletor = true } label: {
                                    Label("Adicionar", systemImage: "doc.badge.plus")
                                        .font(.footnote).foregroundColor(.white)
                                        .padding(.vertical, 8).padding(.horizontal, 12)
                                        .background(Color(hex: "17BEBB")).cornerRadius(8)
                                }
                            }
                            ForEach(examesLocais) { CartaoExameLocalView(exame: $0, urlPDF: $urlPDF) }
                            ForEach(u.exames, id: \.dataExame) { CartaoExameView(exame: $0) }
                        }
                    }
                    .padding()
                }
                .background(Color(.systemGroupedBackground))
            } else {
                Spacer(); Text("Nenhum dado encontrado.").foregroundColor(.gray); Spacer()
            }
        }
        .quickLookPreview($urlPDF)
        .fileImporter(isPresented: $exibirSeletor, allowedContentTypes: [.pdf], allowsMultipleSelection: false) {
            if case .success(let urls) = $0, let url = urls.first {
                examesLocais.insert(ExameLocal(
                    tipo: url.deletingPathExtension().lastPathComponent,
                    dataExame: { let f = DateFormatter(); f.dateFormat = "yyyy-MM-dd"; return f.string(from: .now) }(),
                    urlArquivo: url
                ), at: 0)
            }
        }
        .onAppear { viewModel.fetch() }
    }
}


private func SecaoTitulo(_ texto: String) -> some View {
    Text(texto).font(.title3).fontWeight(.bold)
}

private struct Cartao<Conteudo: View>: View {
    let conteudo: Conteudo
    init(@ViewBuilder _ conteudo: () -> Conteudo) { self.conteudo = conteudo() }
    var body: some View {
        conteudo
            .background(Color.white).cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}

private struct LinhaInfo: View {
    let label: String; let valor: String
    var body: some View {
        HStack { Text("\(label):").fontWeight(.semibold); Text(valor) }
    }
}

private struct CabecalhoExpandivel: View {
    let icone: String; let titulo: String; let subtitulo: String
    let cor: Color; let expandido: Bool
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icone).resizable().scaledToFit().frame(width: 35, height: 35).foregroundColor(cor)
            VStack(alignment: .leading, spacing: 4) {
                Text(titulo).font(.body).fontWeight(.bold).foregroundColor(.primary)
                if !subtitulo.isEmpty { Text(subtitulo).font(.subheadline).foregroundColor(.gray) }
            }
            Spacer()
            Image(systemName: "chevron.right").font(.system(size: 14, weight: .bold)).foregroundColor(.gray)
                .rotationEffect(.degrees(expandido ? 90 : 0))
        }
        .padding(.vertical, 20).padding(.horizontal).background(Color.white)
    }
}


struct InterfaceDadosMedicosView: View {
    let dados: User
    var body: some View {
        VStack(spacing: 14) {
            HStack {
                Image(systemName: "drop.fill").font(.title2)
                Text("TIPO SANGUÍNEO:").fontWeight(.bold)
                Text(dados.tipoSanguineo).font(.title2).fontWeight(.black)
                Spacer()
            }
            .padding().background(Color(hex: "17BEBB")).foregroundColor(.white).cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack { Image(systemName: "exclamationmark.triangle.fill"); Text("ALERTA: ALERGIA").fontWeight(.bold); Spacer() }.font(.caption)
                Text(dados.alergia).font(.title2).fontWeight(.bold)
            }
            .padding().background(Color(hex: "D62246")).foregroundColor(.white).cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack { Image(systemName: "exclamationmark.circle.fill"); Text("NOTIFICAÇÃO MÉDICA").fontWeight(.bold); Spacer() }.font(.caption)
                Text(dados.problemaDeSaude).font(.title3).fontWeight(.bold)
            }
            .padding()
            .background(Color(hex: "D62246").opacity(0.12)).foregroundColor(Color(hex: "D62246")).cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "D62246").opacity(0.35), lineWidth: 1))
            
            VStack(alignment: .leading, spacing: 12) {
                HStack { Image(systemName: "person.text.rectangle.fill"); Text("Dados Pessoais").fontWeight(.bold) }
                    .font(.subheadline).foregroundColor(Color(hex: "17BEBB"))
                Divider()
                VStack(alignment: .leading, spacing: 8) {
                    LinhaInfo(label: "Idade",      valor: "\(dados.idade) anos")
                    LinhaInfo(label: "Sexo",       valor: dados.sexo)
                    LinhaInfo(label: "Nascimento", valor: dados.dataNasc)
                    LinhaInfo(label: "Altura",     valor: String(format: "%.2f m", dados.altura))
                    LinhaInfo(label: "Peso",       valor: String(format: "%.0f kg", dados.peso))
                    LinhaInfo(label: "Telefone",   valor: dados.telefone)
                    LinhaInfo(label: "E-mail",     valor: dados.email)
                }.font(.subheadline)
            }
            .padding().frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(hex: "17BEBB").opacity(0.1)).cornerRadius(12)
        }
    }
}

struct CartaoMembroFamiliaView: View {
    let membro: Familia
    @State private var expandido = false
    var body: some View {
        Cartao {
            VStack(spacing: 0) {
                Button { withAnimation(.easeInOut(duration: 0.25)) { expandido.toggle() } } label: {
                    HStack(spacing: 15) {
                        Image(systemName: "person.circle.fill").resizable().frame(width: 40, height: 40).foregroundColor(.gray.opacity(0.7))
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(membro.nomeU) \(membro.sobrenome)").font(.body).fontWeight(.medium).foregroundColor(.primary)
                            Text(membro.parentesco.uppercased()).font(.caption2).fontWeight(.bold).foregroundColor(Color(hex: "17BEBB"))
                        }
                        Spacer()
                        Image(systemName: "chevron.right").font(.system(size: 14, weight: .bold)).foregroundColor(.gray)
                            .rotationEffect(.degrees(expandido ? 90 : 0))
                    }
                    .padding(.vertical, 20).padding(.horizontal).background(Color.white)
                }
                if expandido {
                    Divider().padding(.horizontal)
                    VStack(alignment: .leading, spacing: 10) {
                        LinhaInfo(label: "Idade",             valor: "\(membro.idade) anos")
                        LinhaInfo(label: "Sexo",              valor: membro.sexo)
                        LinhaInfo(label: "Tipo Sanguíneo",    valor: membro.tipoSanguineo)
                        LinhaInfo(label: "Alergias",          valor: membro.alergia)
                        LinhaInfo(label: "Problema de Saúde", valor: membro.problemaDeSaude)
                        LinhaInfo(label: "Telefone",          valor: membro.telefone)
                        LinhaInfo(label: "E-mail",            valor: membro.email)
                    }
                    .font(.subheadline).padding().frame(maxWidth: .infinity, alignment: .leading).background(Color(.systemBackground))
                }
            }
        }
    }
}

struct CartaoHistoricoView: View {
    let consulta: Consulta
    @State private var expandido = false
    var body: some View {
        Cartao {
            VStack(spacing: 0) {
                Button { withAnimation(.easeInOut(duration: 0.25)) { expandido.toggle() } } label: {
                    CabecalhoExpandivel(icone: "calendar.badge.clock", titulo: consulta.especialidade, subtitulo: consulta.medico, cor: Color(hex: "17BEBB"), expandido: expandido)
                }
                if expandido {
                    Divider().padding(.horizontal)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack { Image(systemName: "calendar");            Text("Data da Consulta:").fontWeight(.semibold); Text(consulta.dataC) }
                        HStack { Image(systemName: "mappin.and.ellipse");  Text("Local:").fontWeight(.semibold); Text(consulta.local) }
                        HStack { Image(systemName: "arrow.clockwise");     Text("Data de Retorno:").fontWeight(.semibold); Text(consulta.dRetorno).foregroundColor(Color(hex: "17BEBB")) }
                    }
                    .font(.subheadline).padding().frame(maxWidth: .infinity, alignment: .leading).background(Color(.systemBackground))
                }
            }
        }
    }
}

struct CartaoExameView: View {
    let exame: Exame
    @State private var expandido = false
    var body: some View {
        Cartao {
            VStack(spacing: 0) {
                Button { withAnimation(.easeInOut(duration: 0.25)) { expandido.toggle() } } label: {
                    CabecalhoExpandivel(icone: "doc.text.image.fill", titulo: exame.tipo, subtitulo: exame.dataExame, cor: Color(hex: "17BEBB").opacity(0.8), expandido: expandido)
                }
                if expandido {
                    Divider().padding(.horizontal)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack { Image(systemName: "waveform.path.ecg"); Text("Laboratório:").fontWeight(.semibold); Text(exame.laboratorio) }
                        HStack { Image(systemName: "calendar");          Text("Realizado em:").fontWeight(.semibold); Text(exame.dataExame) }
                    }
                    .font(.subheadline).padding().frame(maxWidth: .infinity, alignment: .leading).background(Color(.systemBackground))
                }
            }
        }
    }
}

struct CartaoExameLocalView: View {
    let exame: ExameLocal
    @State private var expandido = false
    @Binding var urlPDF: URL?
    var body: some View {
        Cartao {
            VStack(spacing: 0) {
                Button { withAnimation(.easeInOut(duration: 0.25)) { expandido.toggle() } } label: {
                    CabecalhoExpandivel(icone: "doc.text.image.fill", titulo: exame.tipo, subtitulo: exame.dataExame, cor: Color(hex: "17BEBB").opacity(0.8), expandido: expandido)
                }
                if expandido {
                    Divider().padding(.horizontal)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack { Image(systemName: "waveform.path.ecg"); Text("Laboratório:").fontWeight(.semibold); Text(exame.laboratorio) }
                        HStack { Image(systemName: "calendar");          Text("Realizado em:").fontWeight(.semibold); Text(exame.dataExame) }
                        Divider().padding(.vertical, 4)
                        Button { urlPDF = exame.urlArquivo } label: {
                            Label("Visualizar PDF do Laudo", systemImage: "eye.fill")
                                .font(.subheadline).fontWeight(.medium).foregroundColor(.white)
                                .padding().frame(maxWidth: .infinity)
                                .background(Color(hex: "17BEBB")).cornerRadius(8)
                        }
                    }
                    .font(.subheadline).padding().frame(maxWidth: .infinity, alignment: .leading).background(Color(.systemBackground))
                }
            }
        }
    }
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (1, 1, 1, 1)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

#Preview {
    PersonView().environmentObject(ViewModel())
}
