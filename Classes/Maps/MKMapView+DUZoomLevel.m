//
//  MKMapView_DUZoomLevel.h
//  DevedUp
//
//  Created by Casserlys on 11/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MKMapView+DUZoomLevel.h"

#define MERCATOR_OFFSET 268435456
#define MERCATOR_RADIUS 85445659.44705395

@implementation MKMapView (DUZoomLevel)

#pragma mark -
#pragma mark Map conversion methods

- (double)longitudeToPixelSpaceX:(double)longitude{
    return round(MERCATOR_OFFSET + MERCATOR_RADIUS * longitude * M_PI / 180.0);
}

- (double)latitudeToPixelSpaceY:(double)latitude{
    return round(MERCATOR_OFFSET - MERCATOR_RADIUS * logf((1 + sinf(latitude * M_PI / 180.0)) / (1 - sinf(latitude * M_PI / 180.0))) / 2.0);
}

- (double)pixelSpaceXToLongitude:(double)pixelX{
    return ((round(pixelX) - MERCATOR_OFFSET) / MERCATOR_RADIUS) * 180.0 / M_PI;
}

- (double)pixelSpaceYToLatitude:(double)pixelY{
    return (M_PI / 2.0 - 2.0 * atan(exp((round(pixelY) - MERCATOR_OFFSET) / MERCATOR_RADIUS))) * 180.0 / M_PI;
}

#pragma mark -
#pragma mark Helper methods

- (MKCoordinateSpan)coordinateSpanWithMapView:(MKMapView *)mapView
                             centerCoordinate:(CLLocationCoordinate2D)centerCoordinate
                                 andZoomLevel:(NSUInteger)zoomLevel{
    // convert center coordiate to pixel space
    double centerPixelX = [self longitudeToPixelSpaceX:centerCoordinate.longitude];
    double centerPixelY = [self latitudeToPixelSpaceY:centerCoordinate.latitude];
    
    // determine the scale value from the zoom level
    NSInteger zoomExponent = 20 - zoomLevel;
    double zoomScale = pow(2, zoomExponent);
    
    // scale the map’s size in pixel space
    CGSize mapSizeInPixels = mapView.bounds.size;
    double scaledMapWidth = mapSizeInPixels.width * zoomScale;
    double scaledMapHeight = mapSizeInPixels.height * zoomScale;
    
    // figure out the position of the top-left pixel
    double topLeftPixelX = centerPixelX - (scaledMapWidth / 2);
    double topLeftPixelY = centerPixelY - (scaledMapHeight / 2);
    
    // find delta between left and right longitudes
    CLLocationDegrees minLng = [self pixelSpaceXToLongitude:topLeftPixelX];
    CLLocationDegrees maxLng = [self pixelSpaceXToLongitude:topLeftPixelX + scaledMapWidth];
    CLLocationDegrees longitudeDelta = maxLng - minLng;
    
    // find delta between top and bottom latitudes
    CLLocationDegrees minLat = [self pixelSpaceYToLatitude:topLeftPixelY];
    CLLocationDegrees maxLat = [self pixelSpaceYToLatitude:topLeftPixelY + scaledMapHeight];
    CLLocationDegrees latitudeDelta = -1 * (maxLat - minLat);
    
    // create and return the lat/lng span
    MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
    return span;
}

#pragma mark -
#pragma mark Public methods


- (DUMapBoundingBox) boundingBox {
    MKCoordinateRegion region = [self region];
    
    /*
     
     A brief example. Here's a toy MKCoordinateRegion:
     
     center:
     latitude: 0
     longitude: 0
     span:
     latitudeDelta: 8
     longitudeDelta: 6
     The region could be described using its min and max coordinates as follows:
     
     min coordinate (lower left-hand point):
     latitude: -4
     longitude: -3
     max coordinate (upper right-hand point):
     latitude: 4
     longitude: 3
     
     */
    
    double minLat = region.center.latitude - (region.span.latitudeDelta / 2);
    minLat = MAX(minLat, -90.0);
    
    double maxLat = region.center.latitude + (region.span.latitudeDelta / 2);
    maxLat = MIN(maxLat, 90.0);
    
    //Long is -180 to 180
    double minLong = region.center.longitude - (region.span.longitudeDelta / 2);
    minLong = MAX(minLong, -180.0);
    
    double maxLong = region.center.longitude + (region.span.longitudeDelta / 2);
    maxLong = MIN(maxLong, 180.0);
    
    //Because the bounding box is long,lat,long,lat - where long ranges from -180 to 180, and lat from -90 to 90. 
    
    CLLocationCoordinate2D bottomLeft = CLLocationCoordinate2DMake(minLat, minLong);
    CLLocationCoordinate2D topRight = CLLocationCoordinate2DMake(maxLat, maxLong);
    
    DUMapBoundingBox boundingBox = {bottomLeft, topRight};
    return boundingBox;
}

+ (CLLocationCoordinate2D) centerCoordinateFromDUMapBoundingBox:(DUMapBoundingBox)boundingBox {
    
    ////The 4 values represent the bottom-left corner of the box and the top-right corner, minimum_longitude, minimum_latitude, maximum_longitude, //maximum_latitude. 
    
    double minLat = boundingBox.bottomLeft.latitude;
    double maxLat = boundingBox.topRight.latitude;
    double minLong = boundingBox.bottomLeft.longitude;
    double maxLong = boundingBox.topRight.longitude;
    
    
    double longitude = ((fabs(maxLong) + fabs(minLong)) / 2) - fabs(minLong);
    double latitude = ((fabs(maxLat) + fabs(minLat)) / 2) - fabs(minLat);
    
    
    return CLLocationCoordinate2DMake(latitude, longitude);
}

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated{
    // clamp large numbers to 28
    zoomLevel = MIN(zoomLevel, 28);
    
    // use the zoom level to compute the region
    MKCoordinateSpan span = [self coordinateSpanWithMapView:self centerCoordinate:centerCoordinate andZoomLevel:zoomLevel];
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
    
    // set the region like normal
    [self setRegion:region animated:animated];
}

@end
