//
//  MapBootleg.swift
//  SwiftfulBootlegSeries
//
//  Created by jatin foujdar on 31/08/24.
//
import MapKit

import SwiftUI

struct MapBootleg: View {
    var body: some View {
        Map(initialPosition: .region(region))
    }
    private var region : MKCoordinateRegion{
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868),

                        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    }
}


#Preview {
    MapBootleg()
}
