//
//  VUGraph.m
//  VandyAStarRouting
//
//  Created by Robby Cohen on 11/2/12.
//  Copyright (c) 2012 Robby Cohen. All rights reserved.
//

#import "VUGraph.h"
#import "VUGraphNode.h"
#import "VUGraphPath.h"
@implementation VUGraph
@synthesize nodes = _nodes, paths = _paths, mapView = _mapView;

-(id)init {
    self = [super init];
    if(self){
        _nodes = [NSMutableSet new];
        _paths = [NSMutableSet new];
    }
    return self;
}

-(id)initWithMapView:(MKMapView *)mapView {
    self = [self init];
    if(self) {
        _mapView = mapView;
    }
    return self;
    
}

-(void)addNode:(VUGraphNode *)node {
    [_nodes addObject:node];
}
-(void)addPath:(VUGraphPath *)path {
    [_paths addObject:path];
}

-(VUGraphNode *)getNodeByIdentifier:(NSString *)identifer {
    NSSet *tempSet = [_nodes objectsPassingTest:^BOOL(id obj, BOOL *stop) {
        VUGraphNode *tempNode = (VUGraphNode*)obj;
        if ([tempNode.identifer isEqualToString:identifer]) {
            *stop = YES;
            return YES;
        } else {
            return NO;
        }
    }];
    if(tempSet.count == 0){
        [NSException raise:@"getNodeByIdentifer found NO node" format:@"TempSet is blank, id = %@",identifer];
        return nil;
    } else if(tempSet.count > 1){
        [NSException raise:@"getNodeByIdentifer found more than one" format:@"TempSet is too large - %@",tempSet];
        return nil;
    } else {
        return [tempSet anyObject];
    }
}

-(NSDictionary*)createNodeInformation:(VUGraphNode*)node parent:(VUGraphNode*)parentNode andFValue:(double)value {
    return @{@"node" : node, @"parentNode" : (parentNode == nil ? [NSNull null] : parentNode), @"fVal" : [NSNumber numberWithDouble:value]};
}

-(void)update:(NSMutableArray*)openSet withCurrentNode:(NSDictionary*)current toTheEndingNode:(VUGraphNode*)final excludeClosedSet:(NSMutableSet*)closedSet{
    NSArray *neighbors = [((VUGraphNode*)current[@"node"]).neighbors allObjects];
//    [openNeighborsSet intersectSet:[NSSet setWithArray:openSet]];
//    NSArray *openNeighbors = [openNeighborsSet allObjects];
    
    CLLocationDistance gScores[neighbors.count];
    CLLocationDistance hScores[neighbors.count];
    CLLocationDistance fScores[neighbors.count];
    for(int i = 0; i < neighbors.count; i++){
        if([[closedSet valueForKey:@"node"] containsObject:neighbors[i]]){
            continue;
        }
        VUGraphNode *neighborNode = neighbors[i];
        CLLocationDistance tentativeGScore = ((VUGraphNode*)current[@"node"]).gScore + [neighborNode.locationObj distanceFromLocation:((VUGraphNode*)current[@"node"]).locationObj];
        BOOL inOpenSet = [[openSet valueForKey:@"node" ] containsObject:neighborNode];
        if((!inOpenSet) || (tentativeGScore <= neighborNode.gScore)){
            [neighborNode setParentNode:current[@"node"]];
            gScores[i] = neighborNode.gScore = tentativeGScore;
            hScores[i] = [neighborNode.locationObj distanceFromLocation:final.locationObj];
            fScores[i] = gScores[i] + hScores[i];
            if(!inOpenSet){
                [openSet addObject:[self createNodeInformation:neighborNode parent:current[@"node"] andFValue:fScores[i]]];
            }
        }
    }
    
    
}

-(NSDictionary*)getLowestFScore:(NSMutableArray*)openSet {
    NSNumber* lowestFScore = [openSet valueForKeyPath:@"@min.fVal"];
    return (NSDictionary*)[openSet objectAtIndex:[[openSet valueForKey:@"fVal"] indexOfObject:lowestFScore]];
}

-(void)printNodesNames:(VUGraphNode*)node withArray:(NSMutableArray*)finalPaths{
//    NSLog(@"Node name: %@",node.identifer);
    
    // check out VUCast for publicity
    // gotta finish this
    for (VUGraphPath *path in self.paths) {
        if (([path.nodes containsObject:node])&&([path.nodes containsObject:node.parentNode])) {
            [finalPaths insertObject:path atIndex:0];
            [self printNodesNames:node.parentNode withArray:finalPaths];
            break;
        }
    }
    
}

-(void)graphPaths:(NSMutableArray*)paths ontoMapview:(MKMapView *)map {
    NSNumber *tempLength = @0;
    for (VUGraphPath *path in paths) {
        tempLength = [NSNumber numberWithInt:([tempLength integerValue] + path.steps.count)];
    }
    CLLocationCoordinate2D* coords = malloc([tempLength integerValue] * sizeof(CLLocationCoordinate2D));
    for (VUGraphPath *path in paths) {
        
        for (int i = 0; i < path.steps.count; i++)
        {
            coords[i] = CLLocationCoordinate2DMake([path.steps[i][@"latitude"] doubleValue], [path.steps[i][@"longitude"] doubleValue]);
        }
        MKPolyline *pathLine = [MKPolyline polylineWithCoordinates:coords count:path.steps.count];
        [map addOverlay:pathLine];
    }
}



-(void)findShortestPathFrom:(VUGraphNode*)startingNode to:(VUGraphNode*)endingNode{
// ABA to AAM
    
    // create the openSet array and closeSet set
    NSMutableArray *openSet = [NSMutableArray new];
    NSMutableSet *closedSet = [NSMutableSet new];
    
    // chose starting node, add its info to the array
    
    NSDictionary *nodeInformation = [self createNodeInformation:startingNode parent:nil andFValue:0.0];
    [openSet addObject:nodeInformation];
    
    // add adjacent nodes to the array -- NO
//    for (VUGraphNode *node in startingNode.neighbors) {
//        NSDictionary *adjNode = [self createNodeInformation:node parent:startingNode andFValue:0.0];
//        [openSet addObject:adjNode];
//    }
    
    // drop starting node from open array and add it to the closed array
    [openSet removeObject:nodeInformation];
    [closedSet addObject:nodeInformation];
    
    // update openSet via f-scoring
    [self update:openSet withCurrentNode:nodeInformation toTheEndingNode:endingNode excludeClosedSet:closedSet];
    NSDate *startTime = [NSDate date];
    while (![openSet isEqualToArray:[NSMutableArray array]]) {
        NSDictionary *currentNode = [self getLowestFScore:openSet];
        if ([currentNode[@"node"] isEqual:endingNode]) {
            NSLog(@"time for h = FULL, %f",[[NSDate date] timeIntervalSinceDate:startTime]);
            NSMutableArray *finalPaths = [NSMutableArray new];
            [self printNodesNames:endingNode withArray:finalPaths];
            [self graphPaths:finalPaths ontoMapview:self.mapView];
            break;
        }
        [openSet removeObject:currentNode];
        [closedSet addObject:currentNode];
        [self update:openSet withCurrentNode:currentNode toTheEndingNode:endingNode excludeClosedSet:closedSet];
    }
                            
}



-(NSSet *)getListOfPlaceNames {
    return [[_nodes objectsPassingTest:^BOOL(id obj, BOOL *stop) {
        VUGraphNode *tempNode = (VUGraphNode*)obj;
        return ![tempNode.title isEqualToString:@""];
    }] valueForKey:@"title"];
}

@end
