//
//  VUGraphPath.h
//  VandyAStarRouting
//
//  Created by Robby Cohen on 11/2/12.
//  Copyright (c) 2012 Robby Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VUGraphPath : NSObject
@property (nonatomic, retain) NSSet *nodes;
@property (nonatomic, assign) BOOL isWheelchairAccessable;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSArray *steps;
@property (nonatomic, assign) CLLocationDistance length;

+(VUGraphPath*)pathWithNodes:(NSSet*)theNodes IsWheelchairAccessable:(BOOL)wheelchair Steps:(NSArray*)theSteps;

@end
