//
//  MapView.swift
//  maps
//
//  Created by Turma01-6 on 27/04/26.
//

import SwiftUI
import MapKit

struct MapView: View {
    // Initialize to a specific region
    @Binding var localizacao: MKMapItem?


    var body: some View {
        VStack(spacing: 20) {

            Text(localizacao?.name ?? "Sem nome")
                .font(.title)

            Text(
                localizacao?.placemark.title ?? ""
            )

            Button {
                if let telefone = localizacao?.phoneNumber {

                    let numero = telefone
                        .replacingOccurrences(of: " ", with: "")
                        .replacingOccurrences(of: "-", with: "")
                        .replacingOccurrences(of: "(", with: "")
                        .replacingOccurrences(of: ")", with: "")

                    if let url = URL(string: "tel://\(numero)") {

                        UIApplication.shared.open(url)
                    }
                }

            } label: {
                Label(
                    localizacao?.phoneNumber ?? "",
                    systemImage: "phone.fill"
                )
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.corPrimaria)

            Button {

                localizacao?.openInMaps(
                    launchOptions: [
                        MKLaunchOptionsDirectionsModeKey:
                        MKLaunchOptionsDirectionsModeDriving
                    ]
                )

            } label: {
                Label("rota",
                systemImage: "car.fill")
                      
                    
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.corPrimaria)
            
            Button {
                localizacao?.openInMaps()

            } label: {

                Label(
                    "Abrir no Apple Maps",
                    systemImage: "map.fill"
                )
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.corPrimaria)
        }
        .padding()
        .presentationDetents([
            .medium,
            .large
        ])

    }
}

#Preview {
    let placemark = MKPlacemark(
        coordinate: CLLocationCoordinate2D(
            latitude: -3.7319,
            longitude: -38.5269
        )
    )
    
    let item = MKMapItem(placemark: placemark)
    
    item.name = "Fortaleza"
    item.phoneNumber = "85997868140"

    
    return MapView(
        localizacao: .constant(item)
    )
}
