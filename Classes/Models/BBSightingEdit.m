/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Hamish Crittenden : hamish.crittenden@gmail.com, Frank Radocaj : frank@radocaj.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBSightingEdit.h"
#import "BBHelpers.h"


@implementation BBSightingEdit


#pragma mark -
#pragma mark - Member Accessors


@synthesize category = _category,
            createdOn = _createdOn,
            isHidden = _isHidden,
            location = _location,
            address = _address,
            media = _media,
            mediaResourceIds = _mediaResourceIds,
            projects = _projects,
            projectsObservationIsIn = _projectsObservationIsIn,
            projectsObservationIsNotIn = _projectsObservationIsNotIn,
            title = _title;


-(NSString*)category { return _category; }
-(void)setCategory:(NSString *)category { _category = category; }
-(NSDate*)createdOn { return _createdOn; }
-(void)setCreatedOn:(NSDate *)createdOn { _createdOn = createdOn; }
-(BOOL)isHidden { return _isHidden; }
-(void)setIsHidden:(BOOL)isHidden { _isHidden = isHidden; }
-(CGPoint)location { return _location; }
-(void)setLocation:(CGPoint)location { _location = location; }
-(NSString*)address { return _address; }
-(void)setAddress:(NSString *)address { _address = address; }
-(NSString*)title { return _title; }
-(void)setTitle:(NSString *)title { _title = title; }
-(NSMutableArray*)media {
    if(!_media) _media = [[NSMutableArray alloc]init];
    return _media;
}
-(void)setMedia:(NSMutableArray *)media { _media = media; }
-(void)addMedia:(BBMediaEdit*)media { [self.media addObject:media]; }
-(void)removeMedia:(BBMediaEdit*)media { [self.media removeObject:media]; }
-(NSMutableArray*)mediaResourceIds {
    if(!_mediaResourceIds) _mediaResourceIds = [[NSMutableArray alloc]init];
    return _mediaResourceIds;
}
-(void)setMediaResourceIds:(NSMutableArray *)media { _mediaResourceIds = media; }
-(void)addMediaResourceId:(NSString*)mediaResourceId { [_mediaResourceIds addObject:mediaResourceId]; }
-(void)removeMediaResourceId:(NSString*)mediaResourceId { [_mediaResourceIds removeObject:mediaResourceId]; }
-(NSArray*)projects { return _projects; }
-(void)setProjects:(NSArray *)projects {
    if(!_projects)_projects = [[NSArray alloc]init];
    _projects = projects;
}
-(void)addProject:(BBProject *)project {
    if(!_projectsObservationIsIn) _projectsObservationIsIn = [[NSMutableSet alloc]init];
    [_projectsObservationIsIn addObject:project];
    
    if(!_projectsObservationIsNotIn) _projectsObservationIsNotIn = [[NSMutableSet alloc]init];
    [_projectsObservationIsNotIn removeObject:project];
    
    _projects = [NSArray arrayWithArray:[_projectsObservationIsIn allObjects]];
}
-(void)removeProject:(BBProject *)project {
    if(!_projectsObservationIsIn) _projectsObservationIsIn = [[NSMutableSet alloc]init];
    [_projectsObservationIsIn removeObject:project];
    
    if(!_projectsObservationIsNotIn) _projectsObservationIsNotIn = [[NSMutableSet alloc]init];
    [_projectsObservationIsNotIn addObject:project];
    
    _projects = [NSArray arrayWithArray:[_projectsObservationIsIn allObjects]];
}


#pragma mark -
#pragma mark - Utilities


-(NSDictionary*)buildPostModel {
    [BBLog Log:@"BBSightingEdit.buildPostModel"];
    
    NSMutableDictionary *sightingDictionary = [[NSMutableDictionary alloc]init];
    
    [sightingDictionary setObject:_title forKey:@"Title"];
    [sightingDictionary setObject:_createdOn forKey:@"ObservedOn"];
    [sightingDictionary setObject:_category forKey:@"Category"];
    [sightingDictionary setObject:[NSString stringWithFormat:@"%f",_location.x] forKey:@"Latitude"];
    [sightingDictionary setObject:[NSString stringWithFormat:@"%f",_location.y] forKey:@"Longitude"];
    [sightingDictionary setObject:_address forKey:@"Address"];
    [sightingDictionary setObject:@"true" forKey:@"IsIdentificationRequired"];
    [sightingDictionary setObject:@"false" forKey:@"AnonymiseLocation"];
    
    __block NSMutableArray* projectIds = [[NSMutableArray alloc]init];
    [_projects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [projectIds addObject:((BBProject*)obj).identifier];
    }];
    
    [sightingDictionary setObject:projectIds forKey:@"ProjectIds"];
    NSMutableDictionary *observationMediaDictionary = [[NSMutableDictionary alloc]init];
    
    for (BBMediaEdit* media in _media) {
        NSMutableDictionary *mediaResourceDictionary = [[NSMutableDictionary alloc]init];
        [mediaResourceDictionary setObject:[BBGuidGenerator generateGuid] forKey:@"Key"];
        [mediaResourceDictionary setObject:@"image" forKey:@"Type"];
        [mediaResourceDictionary setObject:@"contribution" forKey:@"Usage"];
        [mediaResourceDictionary setObject:media.image forKey:@"File"];
        
        [observationMediaDictionary setObject:mediaResourceDictionary forKey:@"MediaResource"];
    }
    
    [sightingDictionary setObject:observationMediaDictionary forKey:@"Media"];
    
    return sightingDictionary;
}


@end