/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/

#import "BBMappings.h"

@implementation BBMappings

+(void)mappingsForRKManager:(RKObjectManager*)manager
{
    //RKObjectMapping *originalMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    //[imageMapping mapKeyPath:@"Original" toAttribute:@"original"];
    //[manager.mappingProvider setMapping:imageMapping forKeyPath:@"Image"];
    
    // Image mapping *********************************************************************************
    
    //RKObjectMapping *imageMapping = [RKObjectMapping mappingForClass:[BBImage class]];
    //[imageMapping mapKeyPath:@"Original" toRelationship:@"original" withMapping:originalMapping];
    //[manager.mappingProvider setMapping:imageMapping forKeyPath:@"Image"];
    
    RKObjectMapping *imageMapping = [RKObjectMapping mappingForClass:[BBImage class]];
    imageMapping.forceCollectionMapping = YES;
    [imageMapping mapKeyOfNestedDictionaryToAttribute:@"dimensionName"];
    [imageMapping mapKeyPath:@"(dimensionName).Uri" toAttribute:@"uri"];
    [imageMapping mapKeyPath:@"(dimensionName).Width" toAttribute:@"width"];
    [imageMapping mapKeyPath:@"(dimensionName).Height" toAttribute:@"height"];
    [imageMapping mapKeyPath:@"(dimensionName).MimeType" toAttribute:@"mimeType"];
    [manager.mappingProvider setMapping:imageMapping forKeyPath:@"Image"];


    // MediaResource mapping *************************************************************************
    RKObjectMapping *mediaResourceMapping = [RKObjectMapping mappingForClass:[BBMediaResource class]];
    [mediaResourceMapping mapKeyPath:@"MediaResourceType" toAttribute:@"mediaType"];
    [mediaResourceMapping mapKeyPath:@"UploadedOn" toAttribute:@"uploadedOn"];
    [mediaResourceMapping mapKeyPath:@"Metadata" toAttribute:@"metaData"];
    [mediaResourceMapping mapKeyPath:@"Key" toAttribute:@"key"];
    [mediaResourceMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [mediaResourceMapping mapKeyPath:@"Image" toRelationship:@"imageMedia" withMapping:imageMapping];
    //[mediaResourceMapping mapKeyPath:@"Audio" toRelationship:@"audioMedia" withMapping:audioMapping];
    //[manager.mappingProvider setMapping:mediaResourceMapping forKeyPath:@"Avatar"];
    
    
    // Media Mapping (container of MediaResource) ****************************************************
    RKObjectMapping *mediaMapping = [RKObjectMapping mappingForClass:[BBMedia class]];
    [mediaMapping mapKeyPath:@"Description" toAttribute:@"description"];
    [mediaMapping mapKeyPath:@"IsPrimaryMedia" toAttribute:@"isPrimaryMedia"];
    [mediaMapping mapKeyPath:@"Licence" toAttribute:@"licence"];
    [mediaMapping mapKeyPath:@"MediaResource" toRelationship:@"mediaResource" withMapping:mediaResourceMapping];
    [manager.mappingProvider setMapping:mediaMapping forKeyPath:@"Media"];
    
    
    // User Mapping **********************************************************************************
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[BBUser class]];
    [userMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [userMapping mapKeyPath:@"Name" toAttribute:@"name"];
    [userMapping mapKeyPath:@"LatestActivity" toAttribute:@"latestActivity"];
    [userMapping mapKeyPath:@"LatestHeartbeat" toAttribute:@"latestHeartbeat"];
    [userMapping mapKeyPath:@"Avatar" toRelationship:@"avatar" withMapping:mediaResourceMapping];
    [manager.mappingProvider setMapping:userMapping forKeyPath:@"User"];
    
    
    // Membership Mapping ****************************************************************************
    RKObjectMapping *membershipMapping = [RKObjectMapping mappingForClass:[BBMembership class]];
    [membershipMapping mapKeyPath:@"GroupId" toAttribute:@"groupId"];
    [membershipMapping mapKeyPath:@"GroupType" toAttribute:@"groupType"];
    [membershipMapping mapKeyPath:@"PermissionIds" toAttribute:@"permissions"];
    [membershipMapping mapKeyPath:@"RoleIds" toAttribute:@"roleIds"];
    [manager.mappingProvider setMapping:membershipMapping forKeyPath:@"Memberships"];
    
    
    // Category Mapping ****************************************************************************
    RKObjectMapping *categoryMapping = [RKObjectMapping mappingForClass:[BBCategory class]];
    [categoryMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [categoryMapping mapKeyPath:@"Name" toAttribute:@"name"];
    [categoryMapping mapKeyPath:@"Taxonomy" toAttribute:@"taxonomy"];
    [manager.mappingProvider setMapping:categoryMapping forKeyPath:@"Categories"];
    
    
    // Project Mapping *******************************************************************************
    RKObjectMapping *projectMapping = [RKObjectMapping mappingForClass:[BBProject class]];
    [projectMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [projectMapping mapKeyPath:@"Name" toAttribute:@"name"];
    [projectMapping mapKeyPath:@"GroupType" toAttribute:@"groupType"];
    [projectMapping mapKeyPath:@"MemberCount" toAttribute:@"memberCount"];
    [projectMapping mapKeyPath:@"ObservationCount" toAttribute:@"observationCount"];
    [projectMapping mapKeyPath:@"PostCount" toAttribute:@"postCount"];
    [projectMapping mapKeyPath:@"Description" toAttribute:@"description"];
    [projectMapping mapKeyPath:@"Avatar" toRelationship:@"avatar" withMapping:mediaResourceMapping];
    [manager.mappingProvider setMapping:projectMapping forKeyPath:@"Project"];


    // Authenticated User Mapping ********************************************************************
    RKObjectMapping *authenticatedUser = [RKObjectMapping mappingForClass:[BBAuthenticatedUser class]];
    authenticatedUser.rootKeyPath = @"Model";
    [authenticatedUser mapKeyPath:@"User" toRelationship:@"user" withMapping:userMapping];
    [authenticatedUser mapKeyPath:@"AppRoot.Categories" toRelationship:@"categories" withMapping:categoryMapping];
    [authenticatedUser mapKeyPath:@"Projects" toRelationship:@"projects" withMapping:projectMapping];
    [authenticatedUser mapKeyPath:@"Memberships" toRelationship:@"memberships" withMapping:membershipMapping];
    [authenticatedUser mapKeyPath:@"DefaultLicence" toAttribute:@"defaultLicence"];
    [manager.mappingProvider setMapping:authenticatedUser forKeyPath:@"Model.AuthenticatedUser"];
    //[manager.mappingProvider setSerializationMapping:authenticatedUser forClass:[BBAuthenticatedUser class]];
    
    
    // Observation Mapping ***************************************************************************
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
    [observation mapKeyPath:@"Media" toRelationship:@"media" withMapping:mediaMapping];
    [observation mapKeyPath:@"PrimaryMedia" toRelationship:@"primaryMedia" withMapping:mediaMapping];
    // Need to map with Media, PrimaryMedia, Projects, User, Comments
    [manager.mappingProvider setSerializationMapping:observation forClass:[BBObservation class]];
    
    
    // Authentication Response Mapping ***************************************************************
    RKObjectMapping *authentication = [RKObjectMapping mappingForClass:[BBAuthentication class]];
    authentication.rootKeyPath = @"Model";
    [authentication mapKeyPath:@"User" toRelationship:@"authenticatedUser" withMapping:userMapping];
    [manager.mappingProvider setMapping:authentication forKeyPath:@"Model.User"];
    [manager.mappingProvider setSerializationMapping:authentication forClass:[BBAuthentication class]];
    
    
    // Activity Mapping ******************************************************************************
    RKObjectMapping *activityMapping = [RKObjectMapping mappingForClass:[BBActivity class]];
    [activityMapping mapKeyPath:@"Id" toAttribute:@"identifier"];
    [activityMapping mapKeyPath:@"CreatedDateTime" toAttribute:@"createdOn"];
    [activityMapping mapKeyPath:@"Description" toAttribute:@"description"];
    [activityMapping mapKeyPath:@"CreatedDateTimeOrder" toAttribute:@"order"];
    [activityMapping mapKeyPath:@"Type" toAttribute:@"type"];
    [activityMapping mapKeyPath:@"User" toRelationship:@"user" withMapping:userMapping];
    [activityMapping mapKeyPath:@"ObservationAdded.Observation" toRelationship:@"observation" withMapping:observation];
    [manager.mappingProvider setSerializationMapping:activityMapping forClass:[BBActivity class]];
    
    
    // Project Pagination Mapping ********************************************************************
    RKObjectMapping *projectPagination = [RKObjectMapping mappingForClass:[BBProjectPaginator class]];
    projectPagination.rootKeyPath = @"Model.Projects";
    [projectPagination mapKeyPath:@"Page" toAttribute:@"currentPage"];
    [projectPagination mapKeyPath:@"PageSize" toAttribute:@"perPage"];
    [projectPagination mapKeyPath:@"TotalResultCount" toAttribute:@"objectCount"];
    [projectPagination mapKeyPath:@"PagedListItems" toRelationship:@"projects" withMapping:projectMapping];
    [manager.mappingProvider setMapping:projectPagination forKeyPath:@"Model.Projects"];
    
        
    // Map the Activity paginator ********************************************************************
    RKObjectMapping *activityPagination = [RKObjectMapping mappingForClass:[BBActivityPaginator class]];
    activityPagination.rootKeyPath = @"Model.Activities";
    [activityPagination mapKeyPath:@"Page" toAttribute:@"currentPage"];
    [activityPagination mapKeyPath:@"PageSize" toAttribute:@"perPage"];
    [activityPagination mapKeyPath:@"TotalResultCount" toAttribute:@"objectCount"];
    [activityPagination mapKeyPath:@"PagedListItems" toRelationship:@"activities" withMapping:activityMapping];
    [manager.mappingProvider setMapping:activityPagination forKeyPath:@"Model.Activities"];
    [manager.mappingProvider setSerializationMapping:activityPagination forClass:[BBActivityPaginator class]];

    
    // Map the Sightings Paginator *******************************************************************
    RKObjectMapping *sightingPagination = [RKObjectMapping mappingForClass:[BBSightingPaginator class]];
    //sightingPagination.rootKeyPath = @"Model.Sightings";
    [sightingPagination mapKeyPath:@"Page" toAttribute:@"currentPage"];
    [sightingPagination mapKeyPath:@"PageSize" toAttribute:@"perPage"];
    [sightingPagination mapKeyPath:@"TotalResultCount" toAttribute:@"objectCount"];
    // TODO: make this a dynamic mapping to map to either observation or record depending on id
    [sightingPagination mapKeyPath:@"Model.PagedListItems" toRelationship:@"activities" withMapping:activityMapping];
    //[manager.mappingProvider setMapping:sightingPagination forKeyPath:@"Model"];

    
    RKObjectMapping *jsonResponseMapping = [RKObjectMapping mappingForClass:[BBJsonResponse class]];
    //sightingPagination.rootKeyPath = @"Model.Sightings";
    [jsonResponseMapping mapKeyPath:@"Success" toAttribute:@"success"];
    [manager.mappingProvider setMapping:jsonResponseMapping forKeyPath:@"Success"];
    
    
    RKObjectMapping *mediaResourceCreateMapping = [RKObjectMapping mappingForClass:[BBMediaResourceCreate class]];
    [mediaResourceCreateMapping mapKeyPath:@"Key" toAttribute:@"key"];
    [mediaResourceCreateMapping mapKeyPath:@"Type" toAttribute:@"type"];
    [mediaResourceCreateMapping mapKeyPath:@"Usage" toAttribute:@"usage"];
    [mediaResourceCreateMapping mapKeyPath:@"File" toAttribute:@"file"];
    [mediaResourceCreateMapping mapKeyPath:@"FileName" toAttribute:@"fileName"];
    [manager.mappingProvider addObjectMapping:mediaResourceCreateMapping];
    [manager.mappingProvider setSerializationMapping:[mediaResourceCreateMapping inverseMapping] forClass:[BBMediaResourceCreate class]];
    
    
    RKObjectMapping *observationMediaCreateMapping = [RKObjectMapping mappingForClass:[BBObservationMediaCreate class]];
    observationMediaCreateMapping.rootKeyPath = @"Media";
    [observationMediaCreateMapping mapKeyPath:@"MediaResourceId" toAttribute:@"mediaResourceId"];
    [observationMediaCreateMapping mapKeyPath:@"Description" toAttribute:@"description"];
    [observationMediaCreateMapping mapKeyPath:@"Licence" toAttribute:@"licence"];
    [observationMediaCreateMapping mapKeyPath:@"IsPrimaryMedia" toAttribute:@"isPrimaryMedia"];
    [manager.mappingProvider addObjectMapping:observationMediaCreateMapping];
    [manager.mappingProvider setSerializationMapping:observationMediaCreateMapping forClass:[BBObservationMediaCreate class]];
    
    
    RKObjectMapping *observationCreateMapping = [RKObjectMapping mappingForClass:[BBObservationCreate class]];
    [observationCreateMapping mapKeyPath:@"Title" toAttribute:@"title"];
    [observationCreateMapping mapKeyPath:@"ObservedOn" toAttribute:@"observedOn"];
    [observationCreateMapping mapKeyPath:@"Latitude" toAttribute:@"latitude"];
    [observationCreateMapping mapKeyPath:@"Longitude" toAttribute:@"longitude"];
    [observationCreateMapping mapKeyPath:@"Address" toAttribute:@"address"];
    [observationCreateMapping mapKeyPath:@"IsIdentificationRequired" toAttribute:@"isIdentificationRequired"];
    [observationCreateMapping mapKeyPath:@"AnonymiseLocation" toAttribute:@"anonymiseLocation"];
    [observationCreateMapping mapKeyPath:@"Category" toAttribute:@"category"];
    [observationCreateMapping mapKeyPath:@"Media" toRelationship:@"media" withMapping:observationMediaCreateMapping];
    [observationCreateMapping mapKeyPath:@"ProjectIds" toAttribute:@"projectIds"];
    [manager.mappingProvider addObjectMapping:observationCreateMapping];
    [manager.mappingProvider setSerializationMapping:[observationCreateMapping inverseMapping] forClass:[BBObservationCreate class]];
}

@end