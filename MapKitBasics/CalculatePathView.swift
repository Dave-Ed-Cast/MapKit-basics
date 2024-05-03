//
//  CalculatePath.swift
//  MapKitBasics
//
//  Created by Davide Castaldi on 03/05/24.
//

import SwiftUI
import MapKit

struct CalculatePathView: View {
    @State private var selectedResult: MKMapItem?
    @State private var route: MKRoute?
    
    static var academyCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.83699367967446, longitude: 14.3062324140656)
    
    static var line2Coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.83317053526601, longitude: 14.305272300370984)
    
    static var vesuvianaCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.8441255449396, longitude: 14.314362450669268)
    
    private let startingPoint = CLLocationCoordinate2D(
        latitude: line2Coordinates.latitude,
        longitude: line2Coordinates.longitude
    )
    
    private let destinationCoordinates = CLLocationCoordinate2D(
        latitude: academyCoordinates.latitude,
        longitude: academyCoordinates.longitude
    )
    
    //using what we learned in contentview, let's calculate the path between two points:
    var body: some View {
        Map(selection: $selectedResult) {
            //first we define the starting point
            Marker("Start", coordinate: self.startingPoint)
            
            //then show a possible route
            if let route {
                MapPolyline(route)
                    .stroke(.blue, lineWidth: 5)
            }
        }
        .onChange(of: selectedResult){
            getDirections()
        }
        .onAppear {
            self.selectedResult = MKMapItem(placemark: MKPlacemark(coordinate: self.destinationCoordinates))
        }
    }
    
    //TODO: make so that this function uses input parameters
    func getDirections() {
        self.route = nil
        
        //this is just a check for understanding if it's possible to locate
        guard selectedResult != nil else { return }
        
        //then configure the request with a MKDirections request
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: self.startingPoint))
        request.destination = self.selectedResult
        
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
