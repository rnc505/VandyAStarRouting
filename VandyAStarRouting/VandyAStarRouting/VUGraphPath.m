//
//  VUGraphPath.m
//  VandyAStarRouting
//
//  Created by Robby Cohen on 11/2/12.
//  Copyright (c) 2012 Robby Cohen. All rights reserved.
//

#import "VUGraphPath.h"
#import "VUGraphNode.h"
@implementation VUGraphPath
@synthesize nodes = _nodes, isWheelchairAccessable = _isWheelchairAccessable, identifier = _identifier, steps = _steps, length = _length;

+(VUGraphPath *)pathWithNodes:(NSSet *)theNodes IsWheelchairAccessable:(BOOL)wheelchair Steps:(NSArray *)theSteps {
    VUGraphPath *newPath = [[VUGraphPath alloc] init];
    [newPath setNodes:theNodes];
    [newPath setIsWheelchairAccessable:wheelchair];
    [newPath setIdentifier:[self determineIdentifer:theNodes]];
    [newPath setSteps:theSteps];
    [newPath setLength:[self determineLength:theSteps]];
    return newPath;
}

-(void)setNodes:(NSSet *)nodes {
    NSArray *array = [nodes allObjects];
    VUGraphNode *node1 = [array objectAtIndex:0];
    VUGraphNode *node2 = [array objectAtIndex:1];
    [node1 addNeighborNode:node2];
    [node2 addNeighborNode:node1];
    _nodes = nodes;
}

+(NSString*)determineIdentifer:(NSSet*)nodes {
    NSArray *theNodes = [nodes allObjects];
    NSString *node0ID = ((VUGraphNode*)[theNodes objectAtIndex:0]).identifer;
    NSString *node1ID = ((VUGraphNode*)[theNodes objectAtIndex:1]).identifer;
    NSComparisonResult res = [node0ID caseInsensitiveCompare:node1ID];
    if(res == NSOrderedAscending)
        return [NSString stringWithFormat:@"%@%@",node0ID,node1ID];
    else if(res == NSOrderedDescending)
        return [NSString stringWithFormat:@"%@%@",node1ID,node0ID];
  
    [NSException raise:@"Path name could not be determined." format:@"Nodes name were equal: %@, %@",node0ID, node1ID];
    return nil;
    
}

+(CLLocationDistance)determineLength:(NSArray*)steps {
    CLLocationDistance totalDistance = 0.0;
    for (int i = 0; i < steps.count-1; i++) {
        NSDictionary *oneD = (NSDictionary*)[steps objectAtIndex:i];
        NSDictionary *twoD = (NSDictionary*)[steps objectAtIndex:(i+1)];
        CLLocation *one = [[CLLocation alloc] initWithLatitude:[[oneD objectForKey:@"latitude"] doubleValue] longitude:[[oneD objectForKey:@"longitude"]doubleValue]];
        CLLocation *two = [[CLLocation alloc] initWithLatitude:[[twoD objectForKey:@"latitude"] doubleValue] longitude:[[twoD objectForKey:@"longitude"]doubleValue]];
        
        totalDistance = totalDistance + [one distanceFromLocation:two];
        
    }
    return totalDistance;
}

@end
