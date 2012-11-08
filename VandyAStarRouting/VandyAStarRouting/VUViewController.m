//
//  VUViewController.m
//  VandyAStarRouting
//
//  Created by Robby Cohen on 11/2/12.
//  Copyright (c) 2012 Robby Cohen. All rights reserved.
//

#import "VUViewController.h"
#import "VUGraphNode.h"
#import "VUGraph.h"
#import "VUGraphPath.h"
@interface VUViewController ()
{
    int oneTime;
}
@end

@implementation VUViewController
@synthesize mapView = _mapView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mapView = [[MKMapView alloc] init];
    self.view = _mapView;
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    _mapView.mapType = MKMapTypeHybrid;
    [_mapView sizeToFit];
    
    VUGraph *graph = [[VUGraph alloc] initWithMapView:_mapView];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *paths = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"paths" ofType: @"txt"]
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    NSString *points = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"points" ofType: @"txt"]
                                                encoding:NSUTF8StringEncoding
                                                   error:NULL];
    
    NSArray *pathsArray = (NSArray*)[paths objectFromJSONString];
    NSArray *pointsArray = (NSArray*)[points objectFromJSONString];
    for (NSDictionary *point in pointsArray) {
        VUGraphNode *newNode = [VUGraphNode nodeWithLocation:CLLocationCoordinate2DMake([point[@"latitude"] doubleValue], [point[@"longitude"]doubleValue]) Idenitifier:point[@"title"] Title:point[@"subtitle"]];
        [graph addNode:newNode];
    }
    for (NSDictionary *path in pathsArray) {
        NSSet *tempSet = [NSSet setWithObjects:[graph getNodeByIdentifier:path[@"start"]],[graph getNodeByIdentifier:path[@"end"]], nil];
        VUGraphPath *newPath = [VUGraphPath pathWithNodes:tempSet IsWheelchairAccessable:YES Steps:path[@"points"]];
        [graph addPath:newPath];
    }
    NSDate *before = [NSDate date];
    
    VUGraphNode *startingNode = [graph getNodeByIdentifier:@"AAA"];
    [startingNode setGScore:0.0];
    VUGraphNode *endingNode = [graph getNodeByIdentifier:@"ABL"];
    
    [graph findShortestPathFrom:startingNode to:endingNode];
    NSLog(@"%f",[[NSDate date] timeIntervalSinceDate:before]);
    oneTime = 0;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if(userLocation.location.horizontalAccuracy > 80.0 || userLocation.location.verticalAccuracy > 80.0){
        return;
    }
    if (oneTime == 0){
        oneTime = 1;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(_mapView.userLocation.location.coordinate, 100, 100);
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
        [_mapView setRegion:adjustedRegion animated:YES];
        _mapView.showsUserLocation = NO;
    }
    
}

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    if([overlay isKindOfClass:[MKPolyline class]]){
        MKPolylineView *view;
        view = [[MKPolylineView alloc] initWithPolyline:overlay];
        //        view.fillColor = [UIColor redColor];
        view.strokeColor = [UIColor colorWithRed:1.f green:1.f blue:0 alpha:1.f];
        view.lineWidth = 10;
        return view;
    }
    return nil;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
