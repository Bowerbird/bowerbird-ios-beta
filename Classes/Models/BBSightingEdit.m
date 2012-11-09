//
//  BBSightingCreate.m
//  BowerBird
//
//  Created by Hamish Crittenden on 22/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

#import "BBSightingEdit.h"

@implementation BBSightingEdit

@synthesize           category = _category,
                     createdOn = _createdOn,
                      isHidden = _isHidden,
                      location = _location,
                       address = _address,
                         media = _media,
                      projects = _projects,
       projectsObservationIsIn = _projectsObservationIsIn,
    projectsObservationIsNotIn = _projectsObservationIsNotIn,
                         title = _title;


-(NSString*)category {
    return _category;
}

-(void)setCategory:(NSString *)category {
    _category = category;
}


-(NSDate*)createdOn {
    return _createdOn;
}

-(void)setCreatedOn:(NSDate *)createdOn {
    _createdOn = createdOn;
}


-(BOOL)isHidden {
    return _isHidden;
}

-(void)setIsHidden:(BOOL)isHidden {
    _isHidden = isHidden;
}


-(CGPoint)location {
    return _location;
}

-(void)setLocation:(CGPoint)location {
    _location = location;
}


-(NSString*)address {
    return _address;
}

-(void)setAddress:(NSString *)address {
    _address = address;
}


-(NSString*)title {
    return _title;
}

-(void)setTitle:(NSString *)title {
    _title = title;
}


-(NSMutableArray*)media {
    if(!_media) _media = [[NSMutableArray alloc]init];
    return _media;
}

-(void)setMedia:(NSMutableArray *)media {
    _media = media;
}

-(void)addMedia:(BBMediaEdit*)media {
    [self.media addObject:media];
}

-(void)removeMedia:(BBMediaEdit*)media {
    [self.media removeObject:media];
}


-(NSArray*)projects {
    return _projects;
}

-(void)setProjects:(NSArray *)projects {
    _projects = projects;
}

-(void)addProject:(BBProject *)project {
    [_projectsObservationIsIn addObject:project];
    [_projectsObservationIsNotIn removeObject:project];
}

-(void)removeProject:(BBProject *)project {
    [_projectsObservationIsIn removeObject:project];
    [_projectsObservationIsNotIn addObject:project];
}

@end