//
//  CafeModel.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/3/25.
//

import Foundation
import CoreLocation

struct CafeModel: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let distance: Double
    let imageURL: String? // optional
}
