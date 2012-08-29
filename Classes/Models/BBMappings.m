/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBMappings.h"

@implementation BBMappings

-(void)mappingsForRKManager:(RKObjectManager*)manager
{
    
    // Image mapping
    RKObjectMapping *imageMapping = [RKObjectMapping mappingForClass:[BBImage class]];
    [imageMapping mapKeyOfNestedDictionaryToAttribute:@"dimensionName"];
    [imageMapping mapKeyPath:@"(dimensionName).Uri" toAttribute:@"uri"];
    [imageMapping mapKeyPath:@"(dimensionName).Width" toAttribute:@"width"];
    [imageMapping mapKeyPath:@"(dimensionName).Height" toAttribute:@"height"];
    [imageMapping mapKeyPath:@"(dimensionName).MimeType" toAttribute:@"mimeType"];
    [manager.mappingProvider setMapping:imageMapping forKeyPath:@"Image"];

    
    // Audio mapping
    RKObjectMapping *audioMapping = [RKObjectMapping mappingForClass:[BBAudio class]];
    [audioMapping mapKeyOfNestedDictionaryToAttribute:@"dimensionName"];
    [audioMapping mapKeyPath:@"(dimensionName).Uri" toAttribute:@"uri"];
    [audioMapping mapKeyPath:@"(dimensionName).Width" toAttribute:@"width"];
    [audioMapping mapKeyPath:@"(dimensionName).Height" toAttribute:@"height"];
    [audioMapping mapKeyPath:@"(dimensionName).MimeType" toAttribute:@"mimeType"];
    [manager.mappingProvider setMapping:audioMapping forKeyPath:@"Audio"];
 

    // MediaResource mapping
    RKObjectMapping *mediaResourceMapping = [RKObjectMapping mappingForClass:[BBMediaResource class]];
    [mediaResourceMapping mapKeyPath:@"MediaResourceType" toAttribute:@"mediaType"];
    [mediaResourceMapping mapKeyPath:@"UploadedOn" toAttribute:@"uploadedOn"];
    [mediaResourceMapping mapKeyPath:@"Metadata" toAttribute:@"metaData"];
    [mediaResourceMapping mapKeyPath:@"Key" toAttribute:@"key"];
    [mediaResourceMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [mediaResourceMapping mapKeyPath:@"Image" toRelationship:@"imageMedia" withMapping:imageMapping];
    [mediaResourceMapping mapKeyPath:@"Audio" toRelationship:@"audioMedia" withMapping:audioMapping];
    [manager.mappingProvider setMapping:mediaResourceMapping forKeyPath:@"Avatar"];
    
    
    // Media Mapping (container of MediaResource)
    RKObjectMapping *mediaMapping = [RKObjectMapping mappingForClass:[BBMedia class]];
    [mediaMapping mapKeyPath:@"Description" toAttribute:@"description"];
    [mediaMapping mapKeyPath:@"IsPrimaryMedia" toAttribute:@"isPrimaryMedia"];
    [mediaMapping mapKeyPath:@"Licence" toAttribute:@"licence"];
    [mediaMapping mapKeyPath:@"MediaResource" toRelationship:@"mediaResource" withMapping:mediaResourceMapping];
    [manager.mappingProvider setMapping:mediaMapping forKeyPath:@"Media"];
    
    
    // User Mapping
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[BBUser class]];
    [userMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [userMapping mapKeyPath:@"FirstName" toAttribute:@"firstName"];
    [userMapping mapKeyPath:@"LastName" toAttribute:@"lastName"];
    [userMapping mapKeyPath:@"Name" toAttribute:@"name"];
    [userMapping mapKeyPath:@"Avatar" toRelationship:@"avatar" withMapping:mediaResourceMapping];
    [manager.mappingProvider setMapping:userMapping forKeyPath:@"User"];
    
    
    // Membership Mapping
    RKObjectMapping *membership = [RKObjectMapping mappingForClass:[BBMembership class]];
    [membership mapKeyPath:@"GroupId" toAttribute:@"groupId"];
    [membership mapKeyPath:@"GroupType" toAttribute:@"groupType"];
    [membership mapKeyPath:@"PermissionIds" toAttribute:@"permissions"];
    [membership mapKeyPath:@"RoleIds" toAttribute:@"roleIds"];
    [manager.mappingProvider setMapping:membership forKeyPath:@"Memberships"];
    
    
    // Project Mapping
    RKObjectMapping *projectMapping = [RKObjectMapping mappingForClass:[BBProject class]];
    [projectMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [projectMapping mapKeyPath:@"Name" toAttribute:@"name"];
    [projectMapping mapKeyPath:@"Description" toAttribute:@"description"];
    [projectMapping mapKeyPath:@"MemberCount" toAttribute:@"memberCount"];
    [projectMapping mapKeyPath:@"PostCount" toAttribute:@"postCount"];
    [projectMapping mapKeyPath:@"Avatar" toRelationship:@"avatar" withMapping:mediaResourceMapping];
    [manager.mappingProvider setMapping:projectMapping forKeyPath:@"Project"];


    // Authenticated User Mapping
    RKObjectMapping *authenticatedUser = [RKObjectMapping mappingForClass:[BBAuthenticatedUser class]];
    authenticatedUser.rootKeyPath = @"Model";
    [authenticatedUser mapKeyPath:@"User" toRelationship:@"user" withMapping:userMapping];
    [authenticatedUser mapKeyPath:@"AppRoot.Categories" toAttribute:@"categories"];
    [authenticatedUser mapKeyPath:@"Projects" toRelationship:@"projects" withMapping:projectMapping];
    [authenticatedUser mapKeyPath:@"Memberships" toRelationship:@"memberships" withMapping:membership];
    [authenticatedUser mapKeyPath:@"DefaultLicence" toAttribute:@"defaultLicence"];
    [manager.mappingProvider setMapping:authenticatedUser forKeyPath:@"Model.AuthenticatedUser"];
    [manager.mappingProvider setSerializationMapping:authenticatedUser forClass:[BBAuthenticatedUser class]];
    
    
    // Observation Mapping
    RKObjectMapping *observation = [RKObjectMapping mappingForClass:[BBObservation class]];
    [manager.mappingProvider setMapping:observation forKeyPath:@"Observation"];
    [observation mapKeyPath:@"ObservedOn" toAttribute:@"observedOnDate"]; // will need parsing
    [observation mapKeyPath:@"Title" toAttribute:@"title"];
    [observation mapKeyPath:@"Address" toAttribute:@"address"];
    [observation mapKeyPath:@"AnonymiseLocation" toAttribute:@"anonymiseLocation"];
    [observation mapKeyPath:@"Id" toAttribute:@"identifier"];
    [observation mapKeyPath:@"IsIdentificationRequired" toAttribute:@"isIdentificationRequired"];
    [observation mapKeyPath:@"Latitude" toAttribute:@"latitude"];
    [observation mapKeyPath:@"Longitude" toAttribute:@"longitude"];
    [observation mapKeyPath:@"Category" toAttribute:@"category"];
    [manager.mappingProvider setSerializationMapping:observation forClass:[BBObservation class]];
    
    
    // Authentication Response Mapping
    RKObjectMapping *authentication = [RKObjectMapping mappingForClass:[BBAuthentication class]];
    authentication.rootKeyPath = @"Model";
    [authentication mapKeyPath:@"User" toRelationship:@"authenticatedUser" withMapping:userMapping];
    [manager.mappingProvider setMapping:authentication forKeyPath:@"Model.User"];
    [manager.mappingProvider setSerializationMapping:authentication forClass:[BBAuthentication class]];
    
    
    // Login Request Mapping (this may be obsolete)
    RKObjectMapping *loginRequest = [RKObjectMapping mappingForClass:[BBLoginRequest class]];
    [loginRequest mapKeyPath:@"email" toAttribute:@"email"];
    [loginRequest mapKeyPath:@"password" toAttribute:@"password"];
    [manager.mappingProvider setMapping:loginRequest forKeyPath:@"Login"];
    
    
    // Activity Mapping
    RKObjectMapping *activityMapping = [RKObjectMapping mappingForClass:[BBActivity class]];
    [activityMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [activityMapping mapKeyPath:@"CreatedDateTime" toAttribute:@"createdOn"];
    [activityMapping mapKeyPath:@"Description" toAttribute:@"description"];
    [activityMapping mapKeyPath:@"CreatedDateTimeOrder" toAttribute:@"order"];
    [activityMapping mapKeyPath:@"Type" toAttribute:@"type"];
    [activityMapping mapKeyPath:@"User" toRelationship:@"user" withMapping:userMapping];
    [activityMapping mapKeyPath:@"ObservationAdded.Observation" toRelationship:@"observation" withMapping:observation];
    [manager.mappingProvider setSerializationMapping:activityMapping forClass:[BBActivity class]];
    
    
    // Project Pagination Mapping
    RKObjectMapping *projectPagination = [RKObjectMapping mappingForClass:[BBProjectPaginator class]];
    projectPagination.rootKeyPath = @"Model.Projects";
    [projectPagination mapKeyPath:@"Page" toAttribute:@"currentPage"];
    [projectPagination mapKeyPath:@"PageSize" toAttribute:@"perPage"];
    [projectPagination mapKeyPath:@"TotalResultCount" toAttribute:@"objectCount"];
    [projectPagination mapKeyPath:@"PagedListItems" toRelationship:@"projects" withMapping:projectMapping];
    [manager.mappingProvider setMapping:projectPagination forKeyPath:@"Model.Projects"];
    
        
    // Map the Activity paginator
    RKObjectMapping *activityPagination = [RKObjectMapping mappingForClass:[BBActivityPaginator class]];
    activityPagination.rootKeyPath = @"Model.Activities";
    [activityPagination mapKeyPath:@"Page" toAttribute:@"currentPage"];
    [activityPagination mapKeyPath:@"PageSize" toAttribute:@"perPage"];
    [activityPagination mapKeyPath:@"TotalResultCount" toAttribute:@"objectCount"];
    [activityPagination mapKeyPath:@"PagedListItems" toRelationship:@"activities" withMapping:activityMapping];
    [manager.mappingProvider setMapping:activityPagination forKeyPath:@"Model.Activities"];
    [manager.mappingProvider setSerializationMapping:activityPagination forClass:[BBActivityPaginator class]];

    
    // Map the Sightings Paginator
    RKObjectMapping *sightingPagination = [RKObjectMapping mappingForClass:[BBSightingPaginator class]];
    sightingPagination.rootKeyPath = @"Model.Sightings";
    [sightingPagination mapKeyPath:@"Page" toAttribute:@"currentPage"];
    [sightingPagination mapKeyPath:@"PageSize" toAttribute:@"perPage"];
    [sightingPagination mapKeyPath:@"TotalResultCount" toAttribute:@"objectCount"];
    // TODO: make this a dynamic mapping to map to either observation or record depending on id
    [sightingPagination mapKeyPath:@"PagedListItems" toRelationship:@"sightings" withMapping:observation];

}

@end