//
//  RotinasView.swift
//  +Zelo
//

import SwiftUI

struct RotinasView: View {
    @StateObject private var viewModel = ViewModel()
    
    let CorPrimaria    = Color("CorPrimaria")
    let CorSecundaria  = Color("CorSecundaria")
    let CorTerciaria   = Color("CorTerciaria")
    let CorAlerta      = Color("CorAlerta")
    let CorNotificacao = Color("CorNotificacao")
    
    enum TipoFormulario: Identifiable {
        case medicamento, rotina, consulta
        var id: Self { self }
    }
    
    @State private var formularioAtivo: TipoFormulario? = nil
    @State private var medicamentoSelecionado: MedicamentoUsuario? = nil
    @State private var rotinaSelecionada: Refeicao? = nil
    @State private var rotinaTexto: String = ""
    @State private var consultaSelecionada: Consulta? = nil
    
    private var usuarioAtual: User? { viewModel.usuarios.first }
    private var medicamentosUsuario: [MedicamentoUsuario] { usuarioAtual?.medicament ?? [] }
    private var consultasUsuario: [Consulta] { usuarioAtual?.consulta ?? [] }
    private var rotinaUsuario: Routine? { usuarioAtual?.routine }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 25) {
                
                // MARK: Header
                HStack {
                    Text("Olá, \(usuarioAtual?.nomeU ?? "Usuário")!")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding(.top, 20)
                
                // MARK: Medicamentos
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Medicamentos")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                        Button(action: { formularioAtivo = .medicamento }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.gray.opacity(0.4))
                                .font(.title3)
                        }
                    }
                    
                    if medicamentosUsuario.isEmpty {
                        Text("Nenhum medicamento cadastrado")
                            .font(.caption).foregroundColor(.gray).padding(.vertical, 8)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(medicamentosUsuario, id: \.medID) { remedio in
                                    Button(action: { medicamentoSelecionado = remedio }) {
                                        VStack(alignment: .leading, spacing: 8) {
                                            HStack {
                                                Text(remedio.nome)
                                                    .font(.system(size: 18, weight: .bold))
                                                    .lineLimit(1)
                                                Spacer()
                                                Image(systemName: "pill.fill")
                                            }
                                            Text("\(remedio.dosagem) - \(remedio.tipoSelecionado)")
                                                .font(.system(size: 12)).opacity(0.9).lineLimit(2)
                                            Spacer(minLength: 12)
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text("Próxima dose:")
                                                    .font(.system(size: 11, weight: .semibold))
                                                HStack(spacing: 4) {
                                                    Image(systemName: "clock.fill").font(.system(size: 11))
                                                    if let dose = remedio.proximasDoses.first(where: { $0 > Date() }) {
                                                        Text(formatarData(dose))
                                                            .font(.system(size: 13, weight: .bold))
                                                    } else {
                                                        Text("Tratamento finalizado")
                                                            .font(.system(size: 11))
                                                    }
                                                }
                                            }
                                        }
                                        .foregroundColor(.white)
                                        .padding(14)
                                        .frame(width: 170, height: 130, alignment: .topLeading)
                                        .background(CorPrimaria)
                                        .cornerRadius(12)
                                    }
                                }
                            }
                        }
                    }
                }
                
                // MARK: Alimentação
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Alimentação")
                            .font(.system(size: 20, weight: .bold)).foregroundColor(.black)
                        Button(action: { formularioAtivo = .rotina }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.gray.opacity(0.4)).font(.title3)
                        }
                    }
                    
                    if rotinaUsuario == nil {
                        Text("Nenhuma rotina alimentar cadastrada")
                            .font(.caption).foregroundColor(.gray).padding(.vertical, 8)
                    } else if let rotina = rotinaUsuario {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                CardRefeicao(titulo: "Café da manhã", refeicao: rotina.cafeManha, cor: CorSecundaria) {
                                    rotinaSelecionada = rotina.cafeManha; rotinaTexto = "Café da manhã"
                                }
                                CardRefeicao(titulo: "Lanche (M)", refeicao: rotina.lancheM, cor: CorSecundaria) {
                                    rotinaSelecionada = rotina.lancheM; rotinaTexto = "Lanche da Manhã"
                                }
                                CardRefeicao(titulo: "Almoço", refeicao: rotina.almoco, cor: CorSecundaria) {
                                    rotinaSelecionada = rotina.almoco; rotinaTexto = "Almoço"
                                }
                                CardRefeicao(titulo: "Lanche (T)", refeicao: rotina.lancheT, cor: CorSecundaria) {
                                    rotinaSelecionada = rotina.lancheT; rotinaTexto = "Lanche da Tarde"
                                }
                                CardRefeicao(titulo: "Jantar", refeicao: rotina.jantar, cor: CorSecundaria) {
                                    rotinaSelecionada = rotina.jantar; rotinaTexto = "Jantar"
                                }
                                CardRefeicao(titulo: "Ceia", refeicao: rotina.ceia, cor: CorSecundaria) {
                                    rotinaSelecionada = rotina.ceia; rotinaTexto = "Ceia"
                                }
                            }
                        }
                    }
                }
                
                // MARK: Consultas
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Consultas")
                            .font(.system(size: 20, weight: .bold)).foregroundColor(.black)
                        Button(action: { formularioAtivo = .consulta }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.gray.opacity(0.4)).font(.title3)
                        }
                    }
                    
                    if consultasUsuario.isEmpty {
                        Text("Nenhuma consulta agendada")
                            .font(.caption).foregroundColor(.gray).padding(.vertical, 8)
                    } else {
                        VStack(spacing: 12) {
                            ForEach(consultasUsuario, id: \.docID) { consulta in
                                Button(action: { consultaSelecionada = consulta }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(consulta.especialidade)
                                                .font(.system(size: 18, weight: .bold)).foregroundColor(.white)
                                            Text(consulta.medico)
                                                .font(.system(size: 14)).foregroundColor(.white.opacity(0.9))
                                        }
                                        .padding(.leading, 16)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.white.opacity(0.7)).padding(.trailing, 16)
                                    }
                                    .frame(maxWidth: .infinity).frame(height: 65)
                                    .background(CorSecundaria).cornerRadius(12)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear { viewModel.fetch() }
        
        // MARK: Sheet — Formulário (medicamento / rotina / consulta)
        .sheet(item: $formularioAtivo) { tipo in
            switch tipo {
            case .medicamento:
                FormularioMedicamento(viewModel: viewModel, corPrimaria: CorPrimaria) {
                    formularioAtivo = nil
                }
            case .rotina:
                FormularioRotina(viewModel: viewModel, corPrimaria: CorPrimaria) {
                    formularioAtivo = nil
                }
            case .consulta:
                FormularioConsulta(viewModel: viewModel, corPrimaria: CorPrimaria) {
                    formularioAtivo = nil
                }
            }
        }
        
        // MARK: Sheet — Detalhe Medicamento
        .sheet(item: $medicamentoSelecionado) { remedio in
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 24) {
                    Capsule().fill(Color.gray.opacity(0.3)).frame(width: 40, height: 5).padding(.top, 10)
                    Image(systemName: "pill.circle.fill").resizable()
                        .frame(width: 60, height: 60).foregroundColor(CorPrimaria)
                    Text("Detalhes do Medicamento").font(.title2).fontWeight(.bold).foregroundColor(.black)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        DetalheCampo(titulo: "Nome", valor: remedio.nome); Divider()
                        DetalheCampo(titulo: "Dosagem", valor: remedio.dosagem); Divider()
                        DetalheCampo(titulo: "Tipo", valor: remedio.tipoSelecionado); Divider()
                        DetalheCampo(titulo: "Data de Início", valor: "\(remedio.dataInicio) às \(remedio.horarioInicio)"); Divider()
                        DetalheCampo(titulo: "Duração", valor: "\(remedio.diasDuracao) dias"); Divider()
                        DetalheCampo(titulo: "Frequência", valor: "A cada \(remedio.frequenciaHoras) horas"); Divider()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Próximas Doses:").font(.caption).foregroundColor(.gray).fontWeight(.semibold)
                            let doses = remedio.proximasDoses.filter { $0 > Date() }.prefix(5)
                            if doses.isEmpty {
                                Text("Tratamento finalizado").font(.body).foregroundColor(.orange)
                            } else {
                                ForEach(Array(doses.enumerated()), id: \.offset) { _, dose in
                                    HStack {
                                        Image(systemName: "clock.fill").font(.caption).foregroundColor(CorPrimaria)
                                        Text(formatarDataCompleta(dose)).font(.caption).foregroundColor(.black)
                                    }
                                }
                            }
                        }
                    }
                    .padding().frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6)).cornerRadius(12)
                    
                    Button(action: { medicamentoSelecionado = nil }) {
                        Text("Fechar").font(.headline).foregroundColor(.white)
                            .padding().frame(maxWidth: .infinity).background(CorPrimaria).cornerRadius(12)
                    }.padding(.top, 10)
                }
                .padding(.horizontal, 24).padding(.bottom, 30)
            }
            .presentationDetents([.medium, .large])
        }
        
        // MARK: Sheet — Detalhe Refeição
        .sheet(item: $rotinaSelecionada) { refeicao in
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 24) {
                    Capsule().fill(Color.gray.opacity(0.3)).frame(width: 40, height: 5).padding(.top, 10)
                    Image(systemName: "fork.knife").resizable()
                        .frame(width: 60, height: 60).foregroundColor(CorPrimaria)
                    Text("Detalhes da Alimentação").font(.title2).fontWeight(.bold).foregroundColor(.black)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        DetalheCampo(titulo: "Refeição", valor: rotinaTexto); Divider()
                        DetalheCampo(titulo: "Horário", valor: refeicao.horario); Divider()
                        DetalheCampo(titulo: "Cardápio", valor: refeicao.cardapio)
                    }
                    .padding().frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6)).cornerRadius(12)
                    
                    Button(action: { rotinaSelecionada = nil }) {
                        Text("Fechar").font(.headline).foregroundColor(.white)
                            .padding().frame(maxWidth: .infinity).background(CorPrimaria).cornerRadius(12)
                    }.padding(.top, 10)
                }
                .padding(.horizontal, 24).padding(.bottom, 30)
            }
            .presentationDetents([.medium])
        }
        
        // MARK: Sheet — Detalhe Consulta
        .sheet(item: $consultaSelecionada) { consulta in
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 24) {
                    Capsule().fill(Color.gray.opacity(0.3)).frame(width: 40, height: 5).padding(.top, 10)
                    Image(systemName: "heart.text.clipboard").resizable()
                        .frame(width: 60, height: 60).foregroundColor(CorPrimaria)
                    Text("Detalhes da Consulta").font(.title2).fontWeight(.bold).foregroundColor(.black)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        DetalheCampo(titulo: "Especialidade", valor: consulta.especialidade); Divider()
                        DetalheCampo(titulo: "Médico", valor: consulta.medico); Divider()
                        DetalheCampo(titulo: "Data da Consulta", valor: consulta.dataC); Divider()
                        DetalheCampo(titulo: "Local", valor: consulta.local); Divider()
                        DetalheCampo(titulo: "Data de Retorno", valor: consulta.dRetorno)
                    }
                    .padding().frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6)).cornerRadius(12)
                    
                    Button(action: { consultaSelecionada = nil }) {
                        Text("Fechar").font(.headline).foregroundColor(.white)
                            .padding().frame(maxWidth: .infinity).background(CorPrimaria).cornerRadius(12)
                    }.padding(.top, 10)
                }
                .padding(.horizontal, 24).padding(.bottom, 30)
            }
            .presentationDetents([.medium])
        }
    }
    
    private func formatarData(_ data: Date) -> String {
        let f = DateFormatter(); f.dateFormat = "dd/MM, HH:mm"; f.locale = Locale(identifier: "pt_BR")
        return f.string(from: data)
    }
    private func formatarDataCompleta(_ data: Date) -> String {
        let f = DateFormatter(); f.dateFormat = "dd/MM/yyyy às HH:mm"; f.locale = Locale(identifier: "pt_BR")
        return f.string(from: data)
    }
}

// MARK: - Formulário Medicamento

struct FormularioMedicamento: View {
    @ObservedObject var viewModel: ViewModel
    let corPrimaria: Color
    let aoSalvar: () -> Void
    
    @State private var medicamentoSelecionado: Medicament? = nil
    @State private var tipoSelecionado: String = ""
    @State private var dosagem: String = ""
    @State private var dataInicio: Date = Date()
    @State private var horarioInicio: Date = Date()
    @State private var frequenciaHoras: Int = 8
    @State private var diasDuracao: Int = 7
    @State private var salvando = false
    @State private var erro: String? = nil
    
    private let opcoesFrequencia = [4, 6, 8, 12, 24]
    
    var body: some View {
        NavigationView {
            Form {
                // Seleção do medicamento (dropdown)
                Section(header: Text("Medicamento")) {
                    Picker("Nome", selection: $medicamentoSelecionado) {
                        Text("Selecione...").tag(Optional<Medicament>(nil))
                        ForEach(viewModel.medicamentos, id: \.med_id) { med in
                            Text(med.nome).tag(Optional(med))
                        }
                    }
                    .onChange(of: medicamentoSelecionado) { novo in
                        tipoSelecionado = novo?.tipo.first ?? ""
                    }
                    
                    if let tipos = medicamentoSelecionado?.tipo, tipos.count > 1 {
                        Picker("Tipo / Forma", selection: $tipoSelecionado) {
                            ForEach(tipos, id: \.self) { t in
                                Text(t).tag(t)
                            }
                        }
                    }
                    
                    TextField("Dosagem (ex: 500mg)", text: $dosagem)
                        .keyboardType(.default)
                }
                
                // Datas
                Section(header: Text("Início")) {
                    DatePicker("Data de início", selection: $dataInicio, displayedComponents: .date)
                        .environment(\.locale, Locale(identifier: "pt_BR"))
                    DatePicker("Hora de início", selection: $horarioInicio, displayedComponents: .hourAndMinute)
                        .environment(\.locale, Locale(identifier: "pt_BR"))
                }
                
                // Frequência e duração
                Section(header: Text("Posologia")) {
                    Picker("Frequência", selection: $frequenciaHoras) {
                        ForEach(opcoesFrequencia, id: \.self) { h in
                            Text("A cada \(h)h").tag(h)
                        }
                    }
                    Stepper("Duração: \(diasDuracao) dia(s)", value: $diasDuracao, in: 1...365)
                }
                
                if let e = erro {
                    Section {
                        Text(e).foregroundColor(.red).font(.caption)
                    }
                }
            }
            .navigationTitle("Novo Medicamento")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { aoSalvar() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(salvando ? "Salvando..." : "Salvar") {
                        salvarMedicamento()
                    }
                    .disabled(medicamentoSelecionado == nil || dosagem.isEmpty || salvando)
                }
            }
        }
    }
    
    private func salvarMedicamento() {
        guard let med = medicamentoSelecionado else { return }
        
        let dateF = DateFormatter(); dateF.dateFormat = "dd/MM/yyyy"
        let timeF = DateFormatter(); timeF.dateFormat = "HH:mm"
        guard let usuarioAtual = viewModel.usuarios.first else { return }
        
        
        let novoMedicamento = MedicamentoUsuario(medID: med.med_id, nome: med.nome, tipoSelecionado: tipoSelecionado.isEmpty ? (med.tipo.first ?? "") : tipoSelecionado, dataInicio: dateF.string(from: dataInicio), horarioInicio: timeF.string(from: horarioInicio), diasDuracao: diasDuracao, frequenciaHoras: frequenciaHoras, dosagem: dosagem)
        
        var medicamento: [MedicamentoUsuario] = usuarioAtual.medicament
        medicamento.append(novoMedicamento)
        
        let payload: [String: Any] = [
            "_id": usuarioAtual.id,
            "_rev": usuarioAtual.rev,
            "nomeU": usuarioAtual.nomeU,
            "sobrenome": usuarioAtual.sobrenome,
            "idade": usuarioAtual.idade,
            "sexo": usuarioAtual.sexo,
            "tipoSanguineo": usuarioAtual.tipoSanguineo,
            "alergia": usuarioAtual.alergia,
            "problemaDeSaude": usuarioAtual.problemaDeSaude,
            "telefone": usuarioAtual.telefone,
            "altura": usuarioAtual.altura,
            "peso": usuarioAtual.peso,
            "email": usuarioAtual.email,
            "dataNasc": usuarioAtual.dataNasc,
            
            "routine": usuarioAtual.routine,
            "consulta": usuarioAtual.consulta,
            "exames": usuarioAtual.exames,
            "medicament": medicamento,
            "vaccine": usuarioAtual.vaccine,
            "familia": usuarioAtual.familia
        ]
        
        guard let url = URL(string: "http://192.168.128.122:1880/atualizarUser"),
              let body = try? JSONSerialization.data(withJSONObject: payload) else { return }
        
        salvando = true
        var req = URLRequest(url: url)
        req.httpMethod = "PUT"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = body
        
        URLSession.shared.dataTask(with: req) { _, response, error in
            DispatchQueue.main.async {
                salvando = false
                if let error = error { erro = error.localizedDescription; return }
                viewModel.fetch()
                aoSalvar()
            }
        }.resume()
    }
}

// MARK: - Formulário Rotina

struct FormularioRotina: View {
    @ObservedObject var viewModel: ViewModel
    let corPrimaria: Color
    let aoSalvar: () -> Void
    
    private let refeicoes = ["Café da manhã", "Lanche da Manhã", "Almoço", "Lanche da Tarde", "Jantar", "Ceia"]
    private let chavesRefeicao = ["cafeManha", "lancheM", "almoco", "lancheT", "jantar", "ceia"]
    
    @State private var refeicaoSelecionada: String = "Café da manhã"
    @State private var alimentos: String = ""
    @State private var horario: Date = Date()
    @State private var salvando = false
    @State private var erro: String? = nil
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Refeição")) {
                    Picker("Refeição", selection: $refeicaoSelecionada) {
                        ForEach(refeicoes, id: \.self) { r in
                            Text(r).tag(r)
                        }
                    }
                    DatePicker("Horário", selection: $horario, displayedComponents: .hourAndMinute)
                        .environment(\.locale, Locale(identifier: "pt_BR"))
                }
                
                Section(header: Text("Cardápio")) {
                    TextField("Alimentos (ex: arroz, feijão, frango)", text: $alimentos)
                }
                
                if let e = erro {
                    Section { Text(e).foregroundColor(.red).font(.caption) }
                }
            }
            .navigationTitle("Nova Refeição")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { aoSalvar() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(salvando ? "Salvando..." : "Salvar") {
                        salvarRotina()
                    }
                    .disabled(alimentos.isEmpty || salvando)
                }
            }
        }
    }
    
    private func salvarRotina() {
        let timeF = DateFormatter(); timeF.dateFormat = "HH:mm"
        let idx = refeicoes.firstIndex(of: refeicaoSelecionada) ?? 0
        guard let usuarioAtual = viewModel.usuarios.first else { return }
        
        let novaRefeicao = Refeicao(horario: timeF.string(from: horario), cardapio: alimentos)
        var novaRotina: Routine?
        switch refeicaoSelecionada {
        case "Cafe da Manha":
            novaRotina = Routine(
                descricao: "",
                cafeManha: novaRefeicao,
                lancheM: usuarioAtual.routine.lancheM,
                almoco: usuarioAtual.routine.almoco,
                lancheT: usuarioAtual.routine.lancheT,
                jantar: usuarioAtual.routine.jantar,
                ceia: usuarioAtual.routine.ceia)
        case "Lanche da Manhã":
            novaRotina = Routine(
                descricao: "",
                cafeManha: usuarioAtual.routine.cafeManha,
                lancheM: novaRefeicao,
                almoco: usuarioAtual.routine.almoco,
                lancheT: usuarioAtual.routine.lancheT,
                jantar: usuarioAtual.routine.jantar,
                ceia: usuarioAtual.routine.ceia)
        case "Almoço":
            novaRotina = Routine(
                descricao: "",
                cafeManha: usuarioAtual.routine.cafeManha,
                lancheM: usuarioAtual.routine.lancheM,
                almoco: novaRefeicao,
                lancheT: usuarioAtual.routine.lancheT,
                jantar: usuarioAtual.routine.jantar,
                ceia: usuarioAtual.routine.ceia)
        case "Lanche da Tarde":
            novaRotina = Routine(
                descricao: "",
                cafeManha: usuarioAtual.routine.cafeManha,
                lancheM: usuarioAtual.routine.lancheM,
                almoco: usuarioAtual.routine.almoco,
                lancheT: novaRefeicao,
                jantar: usuarioAtual.routine.jantar,
                ceia: usuarioAtual.routine.ceia)
        case "Jantar":
            novaRotina = Routine(
                descricao: "",
                cafeManha: usuarioAtual.routine.cafeManha,
                lancheM: usuarioAtual.routine.lancheM,
                almoco: usuarioAtual.routine.almoco,
                lancheT: usuarioAtual.routine.lancheT,
                jantar: novaRefeicao,
                ceia: usuarioAtual.routine.ceia)
        case "Ceia":
            novaRotina = Routine(
                descricao: "",
                cafeManha: usuarioAtual.routine.cafeManha,
                lancheM: usuarioAtual.routine.lancheM,
                almoco: usuarioAtual.routine.almoco,
                lancheT: usuarioAtual.routine.lancheT,
                jantar: usuarioAtual.routine.jantar,
                ceia: novaRefeicao)
        default:
            break
        }
        
        
        let payload: [String: Any] = [
            "_id": usuarioAtual.id,
            "_rev": usuarioAtual.rev,
            "nomeU": usuarioAtual.nomeU,
            "sobrenome": usuarioAtual.sobrenome,
            "idade": usuarioAtual.idade,
            "sexo": usuarioAtual.sexo,
            "tipoSanguineo": usuarioAtual.tipoSanguineo,
            "alergia": usuarioAtual.alergia,
            "problemaDeSaude": usuarioAtual.problemaDeSaude,
            "telefone": usuarioAtual.telefone,
            "altura": usuarioAtual.altura,
            "peso": usuarioAtual.peso,
            "email": usuarioAtual.email,
            "dataNasc": usuarioAtual.dataNasc,
            
            "Routine": novaRotina,
            "consulta": usuarioAtual.consulta,
            "exames": usuarioAtual.exames,
            "medicament": usuarioAtual.medicament,
            "vaccine": usuarioAtual.vaccine,
            "familia": usuarioAtual.familia
        ]
        
        guard let url = URL(string: "http://192.168.128.122:1880/atualizarUser"),
              let body = try? JSONSerialization.data(withJSONObject: payload) else { return }
        
        salvando = true
        var req = URLRequest(url: url)
        req.httpMethod = "PUT"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = body
        
        URLSession.shared.dataTask(with: req) { _, _, error in
            DispatchQueue.main.async {
                salvando = false
                if let error = error { erro = error.localizedDescription; return }
                viewModel.fetch()
                aoSalvar()
            }
        }.resume()
    }
}

// MARK: - Formulário Consulta

struct FormularioConsulta: View {
    @ObservedObject var viewModel: ViewModel
    let corPrimaria: Color
    let aoSalvar: () -> Void
    
    @State private var especialidadeSelecionada: Specialties? = nil
    @State private var nomeMedico: String = ""
    @State private var local: String = ""
    @State private var dataConsulta: Date = Date()
    @State private var dataRetorno: Date = Date()
    @State private var descricao: String = ""
    @State private var salvando = false
    @State private var erro: String? = nil
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Especialidade")) {
                    Picker("Especialidade", selection: $especialidadeSelecionada) {
                        Text("Selecione...").tag(Optional<Specialties>(nil))
                        ForEach(viewModel.especialidades, id: \.doc_id) { esp in
                            Text(esp.nome).tag(Optional(esp))
                        }
                    }
                    TextField("Nome do médico", text: $nomeMedico)
                }
                
                Section(header: Text("Local e Data")) {
                    TextField("Local (clínica, hospital...)", text: $local)
                    DatePicker("Data da consulta", selection: $dataConsulta, displayedComponents: .date)
                        .environment(\.locale, Locale(identifier: "pt_BR"))
                    DatePicker("Data de retorno", selection: $dataRetorno, displayedComponents: .date)
                        .environment(\.locale, Locale(identifier: "pt_BR"))
                }
                
            }
            
            if let e = erro {
                Section { Text(e).foregroundColor(.red).font(.caption) }
            }
        }
        .navigationTitle("Agendar Consulta")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancelar") { aoSalvar() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(salvando ? "Salvando..." : "Salvar") {
                    salvarConsulta()
                }
                .disabled(especialidadeSelecionada == nil || nomeMedico.isEmpty || local.isEmpty || salvando)
            }
        }
    }
    
    
    private func salvarConsulta() {
        guard let esp = especialidadeSelecionada else { return }
        guard let usuarioAtual = viewModel.usuarios.first else { return }
        
        let dateF = DateFormatter(); dateF.dateFormat = "dd/MM/yyyy"
        
        let novaConsulta = Consulta(docID: "", especialidade: esp.nome, medico: nomeMedico, dataC: dateF.string(from: dataConsulta), local: local, dRetorno: dateF.string(from: dataRetorno))
        
        var consultas: [Consulta] = usuarioAtual.consulta
        consultas.append(novaConsulta)
        
        let payload: [String: Any] = [
            "_id": usuarioAtual.id,
            "_rev": usuarioAtual.rev,
            "nomeU": usuarioAtual.nomeU,
            "sobrenome": usuarioAtual.sobrenome,
            "idade": usuarioAtual.idade,
            "sexo": usuarioAtual.sexo,
            "tipoSanguineo": usuarioAtual.tipoSanguineo,
            "alergia": usuarioAtual.alergia,
            "problemaDeSaude": usuarioAtual.problemaDeSaude,
            "telefone": usuarioAtual.telefone,
            "altura": usuarioAtual.altura,
            "peso": usuarioAtual.peso,
            "email": usuarioAtual.email,
            "dataNasc": usuarioAtual.dataNasc,
            
            "routine": usuarioAtual.routine,
            "consulta": consultas,
            "exames": usuarioAtual.exames,
            "medicament": usuarioAtual.medicament,
            "vaccine": usuarioAtual.vaccine,
            "familia": usuarioAtual.familia
        ]
        
        guard let url = URL(string: "http://192.168.128.122:1880/atualizarUser") else { return }
        guard let body = try? JSONSerialization.data(withJSONObject: payload) else { return }
        
        salvando = true
        var req = URLRequest(url: url)
        req.httpMethod = "PUT"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = body
        
        URLSession.shared.dataTask(with: req) { _, _, error in
            DispatchQueue.main.async {
                salvando = false
                if let error = error { erro = error.localizedDescription; return }
                viewModel.fetch()
                aoSalvar()
            }
        }.resume()
    }
}


// MARK: - Componentes auxiliares

struct CardRefeicao: View {
    let titulo: String
    let refeicao: Refeicao
    let cor: Color
    let acao: () -> Void
    
    var body: some View {
        Button(action: acao) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(titulo)
                        .font(.system(size: 16, weight: .bold)).lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
                Text(refeicao.cardapio)
                    .font(.system(size: 12)).opacity(0.9).lineLimit(2)
                Spacer()
                Text(refeicao.horario)
                    .font(.system(size: 11, weight: .semibold))
            }
            .foregroundColor(.white).padding(14)
            .frame(width: 140, height: 110, alignment: .topLeading)
            .background(cor).cornerRadius(12)
        }
    }
}

struct DetalheCampo: View {
    let titulo: String
    let valor: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(titulo).font(.caption).foregroundColor(.gray).fontWeight(.semibold)
            Text(valor).font(.body).fontWeight(.medium).foregroundColor(.black)
        }
    }
}

#Preview {
    RotinasView()
}
