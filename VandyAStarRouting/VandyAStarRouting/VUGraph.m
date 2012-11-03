//
//  VUGraph.m
//  VandyAStarRouting
//
//  Created by Robby Cohen on 11/2/12.
//  Copyright (c) 2012 Robby Cohen. All rights reserved.
//

#import "VUGraph.h"
#import "VUGraphNode.h"
@implementation VUGraph
@synthesize nodes = _nodes, paths = _paths;

-(id)init {
    self = [super init];
    if(self){
        _nodes = [NSMutableSet new];
        _paths = [NSMutableSet new];
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

-(NSSet *)getListOfPlaceNames {
    return [[_nodes objectsPassingTest:^BOOL(id obj, BOOL *stop) {
        VUGraphNode *tempNode = (VUGraphNode*)obj;
        return ![tempNode.title isEqualToString:@""];
    }] valueForKey:@"title"];
}

@end
