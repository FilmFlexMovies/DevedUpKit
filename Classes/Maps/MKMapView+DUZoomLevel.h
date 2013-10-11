//
//  MKMapView_DUZoomLevel.h
//  DevedUp
//
//  Created by Casserlys on 11/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>

typedef struct {
    CLLocationCoordinate2D bottomLeft;
    CLLocationCoordinate2D topRight;
} DUMapBoundingBox;

@interface MKMapView (DUZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

- (DUMapBoundingBox) boundingBox;

+ (CLLocationCoordinate2D) centerCoordinateFromDUMapBoundingBox:(DUMapBoundingBox)boundingBox;

@end
