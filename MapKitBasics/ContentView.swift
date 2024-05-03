//
//  ContentView.swift
//  MapKitBasics
//
//  Created by Davide Castaldi on 03/05/24.
//

import SwiftUI
import MapKit

//mapkit is fairly easy. You just type Map() and that's the map view
struct ContentView: View {
    
    //now like every good map, we work with coordinates such as latitue and longitude. Provided them, we can always locate every spot on the planet. Let's say we want to locate the apple academy
    var academyCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.83699367967446, longitude: 14.3062324140656)
    
    //vesuviana that doesnt work:
    var vesuvianaCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.8441255449396, longitude: 14.314362450669268)
    
    var line2Coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.83317053526601, longitude: 14.305272300370984)
    
    //the moment we create the command Map(), what happens is that it automatically detects our location. But sometimes we want it to spawn to a default value
    @State var cameraPosition: MapCameraPosition = .automatic
    var body: some View {
        
        
        
        Map(position: $cameraPosition) {
            
            //after declaring our coordinates of interest, we call Map() and put everything inside the curly brackets. We have the coordinates, let's locate them on the map
            
            //given multiple markers, MapKit will always frame them to be all of them visible on the screen. Also you can choose the image of the pin, its color and its monogram (3 letters max)
        
            /*MARK: if you want to zoom out hold shift and hold the screen, up for zoom+, down for zoom-
             also if you hold option you can move on Z axis
             */
            Marker("Apple Academy", systemImage: "building", coordinate: academyCoordinates)
                .tint(.blue)
            
            //but say that for vesuviana we want to use a different pin icon, we can do so by using Annotation
            Annotation("Vesuviana", coordinate: vesuvianaCoordinates) {
                Image(systemName: "train.side.front.car")
            }
            Marker("Line 2", monogram: Text("L2") ,coordinate: line2Coordinates)
                .tint(.red)
        }
        
        //in Map() we passed something. That is how we can do display a default value. Of course we can automatize this, but let's do it with a button
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                Button {
                    //with this value we can modify it to set it somewhere, show some area or even track the user movement (think if he is driving)
                    withAnimation() {
                        //so we set it to some coordinates, and we frame it
                        cameraPosition = .region(MKCoordinateRegion(
                            center: academyCoordinates, latitudinalMeters: 250, longitudinalMeters: 250))
                    }
                } label: {
                    Text("Academy")
                }
                Spacer()
            }
            .padding(.top)
            .background(.thinMaterial)
        }
        
        //suppose that for some reason we want to show another map. This is achieved through the modifier //MARK: .mapstyle
        
//        .mapStyle(.imagery) //more of a realistic type
//        .mapStyle(.hybrid) // both together
//        .mapStyle(.standard) //well, can you guess?
    }
}

#Preview {
    ContentView()
}
