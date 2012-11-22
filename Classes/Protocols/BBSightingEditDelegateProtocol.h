//
//  BBSightingEditDelegate.h
//  BowerBird
//
//  Created by Hamish Crittenden on 29/10/12.
//  Copyright (c) 2012 BowerBird. All rights reserved.
//

/* NOTE:
 
 These are the functions expected of the BBSightingEditView and any controller
 that is a sub-controller of the BBObservationEditController
 
*/

#import <Foundation/Foundation.h>

@protocol BBSightingEditDelegateProtocol <NSObject>

@optional

-(void)updateTitle;

-(void)createdOnStartEdit;

// Usage:
// Query the model to retreive the list of media items
-(NSArray*)media;


-(void)addMedia;
-(void)editMedia;

// Usage:
// Get the projects for this sighting
// Remove a project from the sighting.
-(NSArray*)getSightingProjects;
-(void)removeSightingProject:(NSString*)projectId;
-(void)startAddingProjects;
-(void)stopAddingProjects;

// Usage:
// Needs clarification - not working properly
-(void)editLocation;
-(CGPoint)getLocationLatLon;
-(NSString*)getLocationAddress;
-(void)locationStartEdit;

// Usage:
// Called by the +Camera and +Library buttons on the BBSightingEditView to
// launch an UIImagePickerView from the BBObservationEditController
-(void)showCamera;
-(void)showLibrary;

// Usage:
// Called by clicking the Category table. Asks the controller to add
// the BBCategoryPickerController's BBCategoryPickerView into the BBSightingEditView
-(void)categoryStartEdit;

// Usage:
// Called by clicking on save or cancel in the BBSightingEditView. BBCategoryPickerController
// responds by either submitting the observation to the server, or popping the view controller off
-(void)save;
-(void)cancel;

-(void)setUploadedMediaDisplayBox:(id)box toReferenceMedia:(NSString*)key;

@end