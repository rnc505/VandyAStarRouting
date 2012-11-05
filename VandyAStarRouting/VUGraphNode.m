//
//  VUGraphNode.m
//  VandyAStarRouting
//
//  Created by Robby Cohen on 11/2/12.
//  Copyright (c) 2012 Robby Cohen. All rights reserved.
//

#import "VUGraphNode.h"

@implementation VUGraphNode
@synthesize location = _location, neighbors = _neighbors, identifer = _identifer, title = _title, isSpecialLocation = _isSpecialLocation, parentNode = _parentNode, locationObj = _locationObj;

+(VUGraphNode *)nodeWithLocation:(CLLocationCoordinate2D)loc Idenitifier:(NSString *)ident Title:(NSString *)tit {
    
    VUGraphNode *newNode = [[VUGraphNode alloc] init];
    [newNode setLocation:loc];
    [newNode setLocationObj:[[CLLocation alloc]initWithLatitude:loc.latitude longitude:loc.longitude]];
    [newNode setNeighbors:[NSSet set]];
    [newNode setIdentifer:ident];
    [newNode setTitle:tit];
    [newNode setIsSpecialLocation:(![tit isEqualToString:@""])];
    [newNode setParentNode:nil];
    [newNode setGScore:-1.0];
    return newNode;
}

-(void)setParentNode:(VUGraphNode *)parentNode {
    _parentNode = parentNode;
}

-(void)addNeighborNode:(VUGraphNode *)neighbor {
    _neighbors = [_neighbors setByAddingObject:neighbor];
}
@end
