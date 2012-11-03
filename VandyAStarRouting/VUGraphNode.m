//
//  VUGraphNode.m
//  VandyAStarRouting
//
//  Created by Robby Cohen on 11/2/12.
//  Copyright (c) 2012 Robby Cohen. All rights reserved.
//

#import "VUGraphNode.h"

@implementation VUGraphNode
@synthesize location = _location, neighbors = _neighbors, identifer = _identifer, title = _title, isSpecialLocation = _isSpecialLocation;

+(VUGraphNode *)nodeWithLocation:(CLLocationCoordinate2D)loc Idenitifier:(NSString *)ident Title:(NSString *)tit {
    
    VUGraphNode *newNode = [[VUGraphNode alloc] init];
    [newNode setLocation:loc];
    [newNode setNeighbors:[NSSet set]];
    [newNode setIdentifer:ident];
    [newNode setTitle:tit];
    [newNode setIsSpecialLocation:(![tit isEqualToString:@""])];
    return newNode;
}

-(void)addNeighborNode:(VUGraphNode *)neighbor {
    _neighbors = [_neighbors setByAddingObject:neighbor];
}
@end
