//
//  CalculatePath.swift
//  MapKitBasics
//
//  Created by Davide Castaldi on 03/05/24.
//

import SwiftUI
import MapKit

struct CalculatePathView: View {
    
    //these are two variables we use for the view
    @State private var selectedResult: MKMapItem?
    @State private var route: MKRoute?
    
    //these are the variables. They are static so they are created first than the others and i can use them to assign. This is not the most optimized way but i am just doing it this way to use the framework
    static var academyCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.83699367967446, longitude: 14.3062324140656)
    
    static var line2Coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.83317053526601, longitude: 14.305272300370984)
    
    static var vesuvianaCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.8441255449396, longitude: 14.314362450669268)
    
    //define the starting point
    private let startingPoint = CLLocationCoordinate2D(
        latitude: line2Coordinates.latitude,
        longitude: line2Coordinates.longitude
    )
    
    //and the end point
    private let destinationPoint = CLLocationCoordinate2D(
        latitude: academyCoordinates.latitude,
        longitude: academyCoordinates.longitude
    )
    
    //let's calculate the path between two points:
    
    var body: some View {
        
        //this we saw in content view
        Map(selection: $selectedResult) {
            
            //define the marker of the starting point
            Marker("Start", coordinate: startingPoint)
            
            //then show a possible route if it exists
            if let route {
                MapPolyline(route)
                    .stroke(.blue, lineWidth: 5)
                
                Marker("Apple Academy", systemImage: "building", coordinate: destinationPoint)
                    .tint(.blue)
                Marker("Line 2", monogram: Text("L2") ,coordinate: startingPoint)
                    .tint(.red)
            }
        }
        //and depending on that, get directions
        .onChange(of: selectedResult){
            getDirections(from: startingPoint, to: destinationPoint)
        }
        .onAppear {
            //so show them when the view appears
            selectedResult = MKMapItem(placemark: MKPlacemark(coordinate: destinationPoint))
        }
    }
        
    func getDirections(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
        
        //this is just a check for understanding if it's possible to locate
        guard selectedResult != nil else { return }
        
        //then configure the request with a MKDirections request
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: startingPoint))
        request.destination = selectedResult
        
        //and simply use it to locate the route
        Task {
            let directions = MKDirections(request: request)
            let response = try? await directions.calculate()
            route = response?.routes.first
        }
    }
    
}

#Preview {
    CalculatePathView()
}
