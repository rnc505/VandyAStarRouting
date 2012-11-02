//
//  VUGraph.h
//  VandyAStarRouting
//
//  Created by Robby Cohen on 11/2/12.
//  Copyright (c) 2012 Robby Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VUGraphNode, VUGraphPath;
@interface VUGraph : NSObject

@property (nonatomic, retain) NSMutableSet *nodes;
@property (nonatomic, retain) NSMutableSet *paths;

-(void)addNode:(VUGraphNode*)node;
-(void)addPath:(VUGraphPath*)path;


@end
