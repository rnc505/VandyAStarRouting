//
//  VUGraph.m
//  VandyAStarRouting
//
//  Created by Robby Cohen on 11/2/12.
//  Copyright (c) 2012 Robby Cohen. All rights reserved.
//

#import "VUGraph.h"

@implementation VUGraph
@synthesize nodes = _nodes, paths = _paths;

-(void)addNode:(VUGraphNode *)node {
    [_nodes addObject:node];
}
-(void)addPath:(VUGraphPath *)path {
    [_paths addObject:path];
}

@end
