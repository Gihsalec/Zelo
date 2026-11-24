//
//  StructModel.swift
//  +Zelo
//
//  Created by Turma01-7 on 18/05/26.
//

import Foundation


import Foundation

struct Specialties: Codable, Hashable {
    let _id: String
    let _rev: String
    let doc_id: String
    let nome: String
}

struct Vaccine: Codable, Hashable {
    let _id: String
    let _rev: String
    let nome: String
    let vacID: String
    let descricao: String
    
}

struct Medicament: Codable, Hashable {
    let _id: String
    let _rev: String
    let med_id: String
    let nome: String
    let tipo: [String]
}



struct User: Codable, Hashable {
    let id: String
    let rev: String
    let nomeU: String
    let sobrenome: String
    let idade: Int
    let sexo: String
    let tipoSanguineo: String
    let alergia: String
    let problemaDeSaude: String
    let telefone: String
    
    let altura: Double
    let peso: Double
    
    let email: String
    let dataNasc: String
    
    let routine: Routine
    let consulta: [Consulta]
    let exames: [Exame]
    let medicament: [MedicamentoUsuario]
    let vaccine: [VacinaUsuario]
    let familia: [Familia]
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case rev = "_rev"
        case nomeU
        case sobrenome
        case idade
        case sexo
        case tipoSanguineo
        case alergia
        case problemaDeSaude
        case telefone
        case altura
        case peso
        case email
        case dataNasc
        case routine
        case consulta
        case exames
        case medicament
        case vaccine
        case familia
    }
}

struct ItemRefeicao: Hashable {
    let nome: String
    let horario: String
    let cardapio: String
}

// MARK: - ROUTINE

struct Routine: Codable, Hashable {
    let descricao: String
    
    let cafeManha: Refeicao
    let lancheM: Refeicao
    let almoco: Refeicao
    let lancheT: Refeicao
    let jantar: Refeicao
    let ceia: Refeicao
    
}

// MARK: - REFEIÇÃO

struct Refeicao: Codable, Hashable,Identifiable {
    let horario: String
    let cardapio: String
    var id: Self { self }
}

// MARK: - CONSULTA

struct Consulta: Codable, Hashable, Identifiable {
    
    let docID: String
    let especialidade: String
    let medico: String
    let dataC: String
    let local: String
    let dRetorno: String
    var id: Self { self }
    
    enum CodingKeys: String, CodingKey {
        case docID = "doc_id"
        case especialidade
        case medico
        case dataC
        case local
        case dRetorno
    }
}

// MARK: - EXAME

struct Exame: Codable, Hashable {
    
    let tipo: String
    let dataExame: String
    let laboratorio: String
    
    enum CodingKeys: String, CodingKey {
        case tipo
        case dataExame = "data_exame"
        case laboratorio
    }
}

// MARK: - MEDICAMENTO

struct MedicamentoUsuario: Codable, Hashable, Identifiable {
    
    let medID: String
    let nome: String
    let tipoSelecionado: String
    
    let dataInicio: String
    let horarioInicio: String
    
    let diasDuracao: Int
    let frequenciaHoras: Int
    let dosagem: String
    
    var id: Self { self }
    
    enum CodingKeys: String, CodingKey {
        case medID = "med_id"
        case nome
        case tipoSelecionado = "tipo_selecionado"
        case dataInicio = "data_inicio"
        case horarioInicio = "horario_inicio"
        case diasDuracao = "dias_duracao"
        case frequenciaHoras = "frequencia_horas"
        case dosagem = "dosagem"
    }
    var proximasDoses: [Date] {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            let dataStringCompleta = "\(dataInicio) \(horarioInicio)"
            
            guard let dataInicial = formatter.date(from: dataStringCompleta) else {
                return []
            }
            
            let totalSegundosDuracao = TimeInterval(diasDuracao * 24 * 60 * 60)
            let dataLimite = dataInicial.addingTimeInterval(totalSegundosDuracao)
            
            var listaDoses: [Date] = []
            var dataDoseAtual = dataInicial
            let intervaloSegundos = TimeInterval(frequenciaHoras * 60 * 60)
            
            while dataDoseAtual <= dataLimite {
                listaDoses.append(dataDoseAtual)
                dataDoseAtual = dataDoseAtual.addingTimeInterval(intervaloSegundos)
            }
            
            return listaDoses
        }
}

// MARK: - VACINA

struct VacinaUsuario: Codable, Hashable {
    
    let vacID: String
    let nome: String
    let dataAplicacao: String
    let dose: String
    
    enum CodingKeys: String, CodingKey {
        case vacID = "vac_id"
        case nome
        case dataAplicacao = "data_aplicacao"
        case dose
    }
}

// MARK: - FAMÍLIA

struct Familia: Codable, Hashable {
    
    let parentesco: String
    
    let nomeU: String
    let sobrenome: String
    let idade: Int
    
    let sexo: String
    let tipoSanguineo: String
    
    let alergia: String
    let problemaDeSaude: String
    
    let telefone: String
    let email: String
}

// MARK: - DOUTOR

struct Doutor: Codable, Identifiable, Hashable {
    let docID: String
    let nome: String
    
    var id: String { docID }
    
    enum CodingKeys: String, CodingKey {
        case docID = "doc_id"
        case nome
    }
}

// MARK: - CATÁLOGO DE MEDICAMENTOS

struct MedicamentoCatalogo: Codable, Identifiable {
    let medID: String
    let nome: String
    let tipo: [String]
    
    var id: String { medID }
    
    enum CodingKeys: String, CodingKey {
        case medID = "med_id"
        case nome
        case tipo
    }
}


