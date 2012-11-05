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

@end

@implementation VUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    VUGraph *graph = [[VUGraph alloc] init];
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
    [graph findShortestPath];
    NSLog(@"");
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
