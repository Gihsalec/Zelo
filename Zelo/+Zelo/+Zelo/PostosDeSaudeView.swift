import SwiftUI
import MapKit

struct PostosDeSaudeView: View {
    let coordenadaCentral = CLLocationCoordinate2D(
        latitude: -3.7464538416338544,
        longitude: -38.578133257753954
    )
    
    @State private var position: MapCameraPosition = .automatic

    @State private var locais: [MKMapItem] = []

    @State private var showingSheet = false
    
    @State private var locationItem: MKMapItem? = nil

    @State private var selectedPosition: String? = nil
    
    var body: some View {
        ZStack(alignment: .top) {
            Map(position: $position) {
                // Centro da busca
                Marker(
                    "Centro",
                    coordinate: coordenadaCentral
                )
                .tint(Color.corPrimaria)
                
                // Postos encontrados
                ForEach(locais, id: \.self) { local in
                    Annotation(local.name ?? "", coordinate: local.placemark.coordinate) {
                        Button(action: {
                            showingSheet.toggle()
                            locationItem = local
                            
                        }) {
                            Image(systemName: "staroflife.circle.fill")
                                .tint(Color.corPrimaria)
                                .padding(4)
                                .font(.system(size: 35))
                        }
                        .sheet(isPresented: $showingSheet){
                            MapView(localizacao: $locationItem)
                        }
                    }
                }
            }
            .mapStyle(.standard)
            
            Picker("",selection: $selectedPosition) {
                Text("Selecione um posto")
                    .tag(nil as String?)
                ForEach(locais, id: \.self) { local in
                    Text(local.name ?? "").tag(local.name)
                }
            }.tint(.white)
            .pickerStyle(.menu)
            .background(Color.corPrimaria)
            .cornerRadius(8)
            .onChange(of: selectedPosition) { _, novoValor in
                if let nome = novoValor,
                   let local = locais.first(where: { $0.name == nome }) {
                    position = .region(MKCoordinateRegion(
                        center: local.placemark.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                    ))
                }
            }
            
        }
        .onAppear {
            let region = MKCoordinateRegion(
                center: coordenadaCentral,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.0125,
                    longitudeDelta: 0.0125
                )
            )

            position = .region(region)
            
            buscarPostos(region: region)
        }
    }

    func buscarPostos(region: MKCoordinateRegion) {
        let request = MKLocalSearch.Request()

        request.naturalLanguageQuery = "posto de saude"
        request.resultTypes = .pointOfInterest
        
        let region1 = MKCoordinateRegion(
            center: coordenadaCentral,
            span: MKCoordinateSpan(
                latitudeDelta: 0.0125,
                longitudeDelta: 0.0125
            )
        )

        request.region = region1

        let search = MKLocalSearch(request: request)

        search.start { response, error in

            if let error = error {
                print("Erro:", error.localizedDescription)
                return
            }

            guard let response = response else {
                print("Nenhum resultado")
                return
            }
            
            let centro = CLLocation(
                latitude: region.center.latitude,
                longitude: region.center.longitude
            )

            let ordenados = response.mapItems.sorted { item1, item2 in

                let local1 = CLLocation(
                    latitude: item1.placemark.coordinate.latitude,
                    longitude: item1.placemark.coordinate.longitude
                )

                let local2 = CLLocation(
                    latitude: item2.placemark.coordinate.latitude,
                    longitude: item2.placemark.coordinate.longitude
                )

                return local1.distance(from: centro)
                <
                local2.distance(from: centro)
            }

            DispatchQueue.main.async {
                locais = ordenados
          
                print("teste")
                print(locais[1])
                
                
                for item in locais {
                    print(item.name ?? "")
                }
            }
        }
    }
}

#Preview {
    PostosDeSaudeView()
}
