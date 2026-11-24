//
//  RotinasCardView.swift
//  +Zelo
//
//  Created by Turma01-7 on 20/05/26.
//

import SwiftUI

struct RotinaCardView: View {
    let item: ItemRefeicao 
    let corSecundaria: Color
    
    var body: some View {
        VStack {
            Text(item.nome)
                .font(.system(size: 16, weight: .bold))
                .padding(.top, 15)
            
            Spacer()
            
            VStack(spacing: 4) {
                Text(item.horario)
                    .font(.system(size: 13, weight: .bold))
                
                Text(item.cardapio)
                    .font(.system(size: 11, weight: .regular))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 12)
        }
        .foregroundColor(.white)
        .frame(width: 160, height: 115)
        .background(corSecundaria)
        .cornerRadius(12)
    }
}
