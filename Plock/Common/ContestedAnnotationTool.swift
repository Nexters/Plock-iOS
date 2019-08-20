//
//  ContestedAnnotationTool.swift
//  Plock
//
//  Created by Haehyeon Jeong on 2019/08/20.
//  Copyright © 2019 Zedd. All rights reserved.
//

import Foundation
import MapKit

struct ContestedAnnotationTool {
    
    private static let radiusOfEarth = Double(6378100)
    typealias annotationRelocator = ((_ oldAnnotation: MemoryAnnotation, _ newCoordinate: CLLocationCoordinate2D) -> (MemoryAnnotation))
    
    static func annotationsByDistributingAnnotations(annotations: [MemoryAnnotation], constructNewAnnotationWithClosure ctor: annotationRelocator) -> [MemoryAnnotation] {
        
        // 1. group the annotations by coordinate
        
        let coordinateToAnnotations = groupAnnotationsByCoordinate(annotations: annotations)
        
        // 2. go through the groups and redistribute
        
        var newAnnotations = [MemoryAnnotation]()
        
        for (_, annotationsAtCoordinate) in coordinateToAnnotations {
            
            let newAnnotationsAtCoordinate = ContestedAnnotationTool.annotationsByDistributingAnnotationsContestingACoordinate(annotations: annotationsAtCoordinate, constructNewAnnotationWithClosure: ctor)
            
            newAnnotations.append(contentsOf: newAnnotationsAtCoordinate)
        }
        
        return newAnnotations
    }
    
    private static func groupAnnotationsByCoordinate(annotations: [MemoryAnnotation]) -> [CLLocationCoordinate2D: [MemoryAnnotation]] {
        var coordinateToAnnotations = [CLLocationCoordinate2D: [MemoryAnnotation]]()
        for annotation in annotations {
            let coordinate = annotation.coordinate
            let annotationsAtCoordinate = coordinateToAnnotations[coordinate] ?? [MemoryAnnotation]()
            coordinateToAnnotations[coordinate] = annotationsAtCoordinate + [annotation]
        }
        return coordinateToAnnotations
    }
    
    private static func annotationsByDistributingAnnotationsContestingACoordinate(annotations: [MemoryAnnotation], constructNewAnnotationWithClosure ctor: annotationRelocator) -> [MemoryAnnotation] {
        
        var newAnnotations = [MemoryAnnotation]()
        
        let contestedCoordinates = annotations.map { $0.coordinate }
        
        let newCoordinates = coordinatesByDistributingCoordinates(coordinates: contestedCoordinates)
        
        for (i, annotation) in annotations.enumerated() {
            
            let newCoordinate = newCoordinates[i]
            
            let newAnnotation = ctor(annotation, newCoordinate)
            
            newAnnotations.append(newAnnotation)
        }
        
        return newAnnotations
    }
    
    private static func coordinatesByDistributingCoordinates(coordinates: [CLLocationCoordinate2D]) -> [CLLocationCoordinate2D] {
        
        if coordinates.count == 1 {
            return coordinates
        }
        
        var result = [CLLocationCoordinate2D]()
        
        let distanceFromContestedLocation: Double = 3.0 * Double(coordinates.count) / 2.0
        let radiansBetweenAnnotations = (M_PI * 2) / Double(coordinates.count)
        
        for (i, coordinate) in coordinates.enumerated() {
            
            let bearing = radiansBetweenAnnotations * Double(i)
            let newCoordinate = calculateCoordinateFromCoordinate(coordinate: coordinate, onBearingInRadians: bearing, atDistanceInMetres: distanceFromContestedLocation)
            
            result.append(newCoordinate)
        }
        
        return result
    }
    
    private static func calculateCoordinateFromCoordinate(coordinate: CLLocationCoordinate2D, onBearingInRadians bearing: Double, atDistanceInMetres distance: Double) -> CLLocationCoordinate2D {
        
        let coordinateLatitudeInRadians = coordinate.latitude * M_PI / 180
        let coordinateLongitudeInRadians = coordinate.longitude * M_PI / 180
        
        let distanceComparedToEarth = distance / radiusOfEarth
        
        let resultLatitudeInRadians = asin(sin(coordinateLatitudeInRadians) * cos(distanceComparedToEarth) + cos(coordinateLatitudeInRadians) * sin(distanceComparedToEarth) * cos(bearing))
        let resultLongitudeInRadians = coordinateLongitudeInRadians + atan2(sin(bearing) * sin(distanceComparedToEarth) * cos(coordinateLatitudeInRadians), cos(distanceComparedToEarth) - sin(coordinateLatitudeInRadians) * sin(resultLatitudeInRadians))
        
        let latitude = resultLatitudeInRadians * 180 / M_PI
        let longitude = resultLongitudeInRadians * 180 / M_PI
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

// To use CLLocationCoordinate2D as a key in a dictionary, it needs to comply with the Hashable protocol
extension CLLocationCoordinate2D: Hashable {
    public var hashValue: Int {
        return (latitude.hashValue &* 397) &+ longitude.hashValue;
    }
}

// To be Hashable, you need to be Equatable too
public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}
