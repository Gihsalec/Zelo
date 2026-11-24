//
//  CalendarioView.swift
//  +Zelo
//
//  Created by Turma01-7 on 20/05/26.
//

import SwiftUI

struct CalendarioView: View {
    let data: Date
    @Binding var dataSelecionada: Date

    private var isSelected: Bool {
        Calendar.current.isDate(dataSelecionada, inSameDayAs: data)
    }

    var body: some View {
        VStack(spacing: 8) {
            Text(formatarDia(data: data))
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(isSelected ? .white : .primary)

            Text(formatarDiaSemana(data: data))
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white.opacity(0.85) : .secondary)
        }
        .frame(width: 70)
        .padding(.vertical, 16)
        .background(isSelected ? Color("CorTerciaria") : Color(.systemGray6))
        .cornerRadius(16)
        .onTapGesture {
            dataSelecionada = data
        }
    }

    private func formatarDia( data: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: data)
    }

    private func formatarDiaSemana( data: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "EEE"
        return formatter.string(from: data)
    }
}
 
