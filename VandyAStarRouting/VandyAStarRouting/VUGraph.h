//
//  VUGraph.h
//  VandyAStarRouting
//
//  Created by Robby Cohen on 11/2/12.
//  Copyright (c) 2012 Robby Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@class VUGraphNode, VUGraphPath;
@interface VUGraph : NSObject

@property (nonatomic, retain) NSMutableSet *nodes;
@property (nonatomic, retain) NSMutableSet *paths;
@property (nonatomic, retain) MKMapView *mapView;

-(void)addNode:(VUGraphNode*)node;
-(void)addPath:(VUGraphPath*)path;

-(id)initWithMapView:(MKMapView*)mapView;

-(VUGraphNode*)getNodeByIdentifier:(NSString*)identifer;
-(NSSet*)getListOfPlaceNames;
-(void)findShortestPathFrom:(VUGraphNode*)startingNode to:(VUGraphNode*)endingNode;

-(void)graphPaths:(NSMutableArray*)paths ontoMapview:(MKMapView *)map;
@end
