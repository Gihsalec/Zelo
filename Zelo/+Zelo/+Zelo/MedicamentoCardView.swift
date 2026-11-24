//
//  MedicamentoCardView.swift
//  +Zelo
//
//  Created by Turma01-7 on 20/05/26.
//

import SwiftUI

struct MedicamentoCardView: View {
    let medicamento: MedicamentoUsuario

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(medicamento.nome)
                    .font(.system(size: 18, weight: .bold))
                    .lineLimit(1)
                Spacer()
                Image(systemName: "pill")
            }
            
            Text("\(medicamento.dosagem) - \(medicamento.tipoSelecionado)")
                .font(.system(size: 12))
                .opacity(0.9)
                .lineLimit(2)
            
            Spacer(minLength: 12)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Próxima dose:")
                    .font(.system(size: 11, weight: .semibold))
                
                if let proximaDose = medicamento.proximasDoses.first(where: { $0 > Date() }) {
                    Text(formatarData(proximaDose))
                        .font(.system(size: 13, weight: .bold))
                } else {
                    Text("Tratamento finalizado")
                        .font(.system(size: 11))
                }
            }
        }
        .foregroundColor(.white)
        .padding(14)
        .frame(width: 170, height: 130, alignment: .topLeading)
        .background(Color("CorPrimaria"))
        .cornerRadius(12)
    }

    // MARK: - Pega a próxima dose que ainda não passou
    private func proximaDoseFutura() -> Date? {
        let agora = Date()
        return medicamento.proximasDoses
            .filter { $0 > agora }
            .sorted()
            .first
        ?? medicamento.proximasDoses.sorted().first // fallback: mostra a primeira se todas passaram
    }

    // MARK: - Formata a data em texto amigável
    private func formatarTextoDose(_ dataDose: Date?) -> String {
        guard let dataDose = dataDose else {
            return "Tratamento finalizado"
        }

        let calendar = Calendar.current

        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "pt_BR")
        timeFormatter.dateFormat = "HH:mm"
        let horaTexto = timeFormatter.string(from: dataDose)

        if calendar.isDateInToday(dataDose) {
            return "Hoje, \(horaTexto)"
        } else if calendar.isDateInTomorrow(dataDose) {
            return "Amanhã, \(horaTexto)"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "pt_BR")
            dateFormatter.dateFormat = "dd/MM"
            return "\(dateFormatter.string(from: dataDose)), \(horaTexto)"
        }
    }
    private func formatarData(_ data: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM, HH:mm"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: data)
    }
    
    private func formatarDataCompleta(_ data: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy às HH:mm"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: data)
    }
}
