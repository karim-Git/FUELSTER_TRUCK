//
//  GoogleMapView.h
//  GoogleMapsSample
//
//  Created by Sandeep Kumar Rachha on 10/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "O1LocationManager.h"

extern  NSString * const GoogleMap_API_Key;

@interface GoogleMapView : NSObject <GMSMapViewDelegate>
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic,strong) GMSMapView *mapView;
@property (nonatomic,strong) GMSMarker *myLocationMarker;
@property (nonnull, strong)NSString *myLocationAddress;
+(nonnull GoogleMapView *)sharedInsatnce;
- (void)addMapViewWithFrame:(CGRect)frame superView:(nonnull UIView *)superView;
- (void)addMyLocationMarker;
- (void)addMarkers:(NSArray *)markers;
- (GMSMapView *)setupMapWithLocation:(NSString *)latitude andLongitude:(NSString *)longitude;
NS_ASSUME_NONNULL_END
@end
