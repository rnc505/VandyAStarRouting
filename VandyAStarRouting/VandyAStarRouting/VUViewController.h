//
//  VUViewController.h
//  VandyAStarRouting
//
//  Created by Robby Cohen on 11/2/12.
//  Copyright (c) 2012 Robby Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VUGraph.h"
@interface VUViewController : UIViewController <MKMapViewDelegate>
@property (nonatomic, retain) MKMapView *mapView;
@end
