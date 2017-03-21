//
//  OAuthTests.swift
//  Spartan
//
//  Created by Dalton Hinterscher on 1/21/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Spartan

class OAuthTests: BaseTests {
    
    private let CATEGORY_ID = "party"
    private let ARTIST_TO_FOLLOW_ID = "74ASZWbe4lXaubB36ztrGX"
    private let USER_TO_FOLLOW_ID = "onehintwonder"
    private let SPARTAN_USER_ID = "spartangithub"
    private let SPARTAN_PLAYLIST_ID = "53DijuDdXcYn54z0OUr8FY"
    
    private let TRACK_IDS_TO_SAVE = ["3TwtrR1yNLY1PMPsrGQpOp", "0B5KeB25moPkcQUnbDvj3t", "5OVofGV3opkR1hq0C9RSCu"]
    private let TRACK_IDS_TO_REMOVE = ["3TwtrR1yNLY1PMPsrGQpOp", "0B5KeB25moPkcQUnbDvj3t"]
    private let TRACK_ID_TO_NEVER_REMOVE = "5OVofGV3opkR1hq0C9RSCu"
    private let TRACK_URIS_TO_SAVE = ["spotify:track:3TwtrR1yNLY1PMPsrGQpOp", "spotify:track:0B5KeB25moPkcQUnbDvj3t", "spotify:track:5OVofGV3opkR1hq0C9RSCu"]
    private let TRACK_URIS_TO_REMOVE = ["spotify:track:3TwtrR1yNLY1PMPsrGQpOp", "spotify:track:0B5KeB25moPkcQUnbDvj3t"]
    
    private let ALBUM_IDS_TO_SAVE = ["5MqEXYwwyJYjOb3g7vJ9ZY", "3o03nl4jDQYUDuX9d8lylY", "1wPbjuINyeQRPPGdLeE4ZH"]
    private let ALBUM_IDS_TO_REMOVE = ["5MqEXYwwyJYjOb3g7vJ9ZY", "3o03nl4jDQYUDuX9d8lylY"]
    private let ALBUM_ID_TO_NEVER_REMOVE = "1wPbjuINyeQRPPGdLeE4ZH"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Spartan.loggingEnabled = true
        Spartan.authorizationToken = "BQBPg6KM06ty__6Oe6CY-Om5Zc7HOfBeLAcM-v-dZ50vLuHzoWxolGbfGyyJog3Yxd4F1hapoGhnGKm3PV8wtA43s794kBlOhkqE2dKs6hmHu1HVNG5k7_DDBMvKi1e668sUvNU4D-YHj25RrkFpdWXKFOabbXNFM46LVu7PrtHsy4yjG5dARl8xxKcgPTfzlI2UVPfgAyMBZbdF5BKwlP2Zcn4rV_OtJ0m95-LApp2l56TqH5GT20_gApppje9T5zCkGIPC6MLHPJEFK3SvtTw9516f30xHxk2KNaZKDQlMPx77P4fFVDBi"
    }
    
    func testThatGetAudioAnalysisRequestCorrectlyMapsAudioAnalysisForGivenTrackIdWithAuthorizationToken() {
        
        _ = Spartan.getAudioAnaylsis(trackId: TRACK_ID, success: { (audioAnalysis) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetMeRequestCorrectlyMapsUserAssociatedWithAuthorizationToken() {
        
        _ = Spartan.getMe(success: { (user) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetAudioFeaturesRequestCorrectlyMapsAudioFeaturesObjectForGivenTrackWithIdWithAuthorizationToken() {
        
        _ = Spartan.getAudioFeatures(trackId: TRACK_ID, success: { (audioFeaturesObject) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
         }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
         })
        
        waitForRequestToFinish()
    }
    
    func testThatGetAudioFeaturesRequestCorrectlyMapsAudioFeaturesObjectsForGivenTracksWithIdsWithAuthorizationToken() {
        
        _ = Spartan.getAudioFeatures(trackIds: [TRACK_ID, TRACK_ID, TRACK_ID], success: { (audioFeaturesObjects) in
            self.validationExpectation.fulfill()
            XCTAssert(audioFeaturesObjects.count == 3)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetFeaturedPlaylistsRequestsCorrectlyMapsFeaturedPlaylistsObjectWithAuthorizationToken() {
        
        _ = Spartan.getFeaturedPlaylists(success: { (featuredPlaylistsObject) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetNewReleasesRequestsCorrectlyMapsAlbumObjectsWithAuthorizationToken() {
        
        _ = Spartan.getNewReleases(success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.count > 0)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetCategoriesRequestsCorrectlyMapsCategoryObjectsWithAuthorizationToken() {
        
        _ = Spartan.getCategories(success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.count > 0)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }

    func testThatGetCategoryRequestCorrectlyMapsCategoryObjectWithAuthorizationToken() {
        
        _ = Spartan.getCategory(id: CATEGORY_ID, success: { (category) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetCategorysPlaylistsRequestsCorrectlyMapsCategoryObjectsWithAuthorizationToken() {
        
        _ = Spartan.getCategorysPlaylists(categoryId: CATEGORY_ID, success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.count > 0)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetMeRequestCorrectlyMapsUserObjectWithAuthorizationToken() {
        
        _ = Spartan.getMe(success: { (user) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetMyFollowedArtistsRequestCorrectlyMapsArtistObjectsWithAuthorizationToken() {
        
        _ = Spartan.getMyFollowedArtists(success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.count > 0)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatFollowRequestCorrectlyWorksForArtistTypeWithAuthorizationToken() {
        
        _ = Spartan.follow(ids: [ARTIST_TO_FOLLOW_ID], type: .artist, success: { 
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatFollowRequestCorrectlyWorksForUserTypeWithAuthorizationToken() {
        
        _ = Spartan.follow(ids: [USER_TO_FOLLOW_ID], type: .user, success: {
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatUnfollowRequestCorrectlyWorksForArtistTypeWithAuthorizationToken() {
        
        _ = Spartan.unfollow(ids: [ARTIST_TO_FOLLOW_ID], type: .artist, success: {
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatUnfollowRequestCorrectlyWorksForUserTypeWithAuthorizationToken() {
        
        _ = Spartan.unfollow(ids: [USER_TO_FOLLOW_ID], type: .user, success: {
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }

    func testThatFollowContainsRequestCorrectlyWorksForArtistTypeWithAuthorizationToken() {
        
        _ = Spartan.getIsFollowing(ids: [ARTIST_TO_FOLLOW_ID, ARTIST_TO_FOLLOW_ID, ARTIST_TO_FOLLOW_ID], type: .artist, success: { (followingBools) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatFollowContainsRequestCorrectlyWorksForUserTypeWithAuthorizationToken() {
        
        _ = Spartan.getIsFollowing(ids: [USER_TO_FOLLOW_ID, USER_TO_FOLLOW_ID, USER_TO_FOLLOW_ID], type: .user, success: { (followingBools) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatFollowPlaylistRequestCorrectlyFollowsPlaylistForGivenIdWithAuthorizationToken() {
        
        _ = Spartan.followPlaylist(ownerId: SPARTAN_USER_ID, playlistId: SPARTAN_PLAYLIST_ID, success: {
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatUnfollowPlaylistRequestCorrectlyUnfollowsPlaylistForGivenIdWithAuthorizationToken() {
        
        let playlistName = UUID.init().uuidString
        _ = Spartan.createPlaylist(userId: SPARTAN_USER_ID, name: playlistName, success: { (playlist) in
            
            _ = Spartan.unfollowPlaylist(ownerId: self.SPARTAN_USER_ID, playlistId: playlist.id!, success: {
                self.validationExpectation.fulfill()
                XCTAssert(true)
            }, failure: { (error) in
                self.validationExpectation.fulfill()
                XCTFail(error.errorMessage)
            })
        
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatSaveTracksRequestCorrectlySavesTracksForUserWithAuthorizationToken() {
        
        _ = Spartan.saveTracks(trackIds: TRACK_IDS_TO_SAVE, success: {
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetSavedTracksRequestCorrectlyGetsSavedTracksForUserWithAuthorizationToken() {
        
        _ = Spartan.getSavedTracks(success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.count > 0)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatRemoveSavedTracksRequestCorrectlyRemovesTracksForUserWithAuthorizationToken() {
        
        _ = Spartan.removeSavedTracks(trackIds: TRACK_IDS_TO_REMOVE, success: {
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatSavedTracksContainCorrectlyReturnsBoolArrayForUserWithAuthorizationToken() {
        
        _ = Spartan.tracksAreSaved(trackIds: [TRACK_ID_TO_NEVER_REMOVE, TRACK_ID], success: { (savedBools) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatSaveAlbumsRequestCorrectlySavesAlbumsForUserWithAuthorizationToken() {
        
        _ = Spartan.saveAlbums(albumIds: ALBUM_IDS_TO_SAVE, success: {
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetSavedAlbumsRequestCorrectlyGetsSavedAlbumsForUserWithAuthorizationToken() {
        
        _ = Spartan.getSavedAlbums(success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.count > 0)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatRemoveSavedAlbumsRequestCorrectlyRemovesAlbumsForUserWithAuthorizationToken() {
        
        _ = Spartan.removeSavedAlbums(albumIds: ALBUM_IDS_TO_REMOVE, success: {
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatSavedAlbumsContainCorrectlyReturnsBoolArrayForUserWithAuthorizationToken() {
        
        _ = Spartan.albumsAreSaved(albumIds: [ALBUM_ID_TO_NEVER_REMOVE, ALBUM_ID], success: { (savedBools) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetMyTopArtistsRequestCorrectlyMapsTopArtistsWithAuthorizationToken() {
        
        _ = Spartan.getMyTopArtists(success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetMyTopTracksRequestCorrectlyMapsTopTracksWithAuthorizationToken() {
        
        _ = Spartan.getMyTopArtists(success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }

    
    func testThatGetRecommendationsRequestCorrectlyMapsReccomendationsObjectWithAuthorizationToken() {
        
        let minAttributes: [(TuneableTrackAttribute, Float)] = [(.energy, 0.4)]
        let maxAttributes: [(TuneableTrackAttribute, Float)] = [(.energy, 0.6)]
        
        _ = Spartan.getRecommendations(minAttributes: minAttributes, maxAttributes: maxAttributes, seedArtists: ["4NHQUGzhtTLFvgF5SZesLK"], success: { (recomendationsObject) in
            self.validationExpectation.fulfill()
            XCTAssert(recomendationsObject.tracks.count > 0)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
        
    }
    
    func testThatGetUsersPlaylistsRequestCorrectlyGetsUsersPlaylistsWithAuthorizationToken() {
        
        _ = Spartan.getUsersPlaylists(userId: SPARTAN_USER_ID, success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.count > 0)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetMyPlaylistsRequestCorrectlyGetsMyPlaylistsWithAuthorizationToken() {
        
        _ = Spartan.getMyPlaylists(success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.count > 0)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetUsersPlaylistRequestCorrectlyGetsUserPlaylistWithIdWithAuthorizationToken() {
        
        _ = Spartan.getUsersPlaylist(userId: SPARTAN_USER_ID, playlistId: SPARTAN_PLAYLIST_ID, success: { (playlist) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }

    func testThatGetPlaylistTracksRequestCorrectlyGetsPlaylistTracksWithAuthorizationToken() {
        
        _ = Spartan.getPlaylistTracks(userId: SPARTAN_USER_ID, playlistId: SPARTAN_PLAYLIST_ID, success: { (pagingObject) in
            self.validationExpectation.fulfill()
            XCTAssert(pagingObject.items.count > 0)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatCreatePlaylistRequestCorrectlyCreatesPlaylistWithAuthorizationToken() {
        
        let playlistName = UUID.init().uuidString
        _ = Spartan.createPlaylist(userId: SPARTAN_USER_ID, name: playlistName, success: { (playlist) in
            
            _ = Spartan.unfollowPlaylist(ownerId: self.SPARTAN_USER_ID, playlistId: playlist.id, success: nil, failure: nil)
            
            self.validationExpectation.fulfill()
            XCTAssert(playlist.name == playlistName)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }

    func testThatChangePlaylistDetailsCorrectlyChangesPlaylistDetailsWithAuthorizationToken() {
        
        let originalPlaylistName = UUID.init().uuidString
        let changedPlaylistName = UUID.init().uuidString
        _ = Spartan.createPlaylist(userId: SPARTAN_USER_ID, name: originalPlaylistName, success: { (playlist) in
            
            _ = Spartan.changePlaylistDetails(userId: self.SPARTAN_USER_ID, playlistId: playlist.id!, name: changedPlaylistName, isPublic: false, isCollaborative: false, success: { () in
                
                self.validationExpectation.fulfill()
                XCTAssert(true)
                
            }, failure: { (error) in
                self.validationExpectation.fulfill()
                XCTFail(error.errorMessage)
            })
            
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }

    func testThatAddTracksToPlaylistRequestCorrectlyAddsTracksToPlaylistWithAuthorizationToken() {
        
        _ = Spartan.addTracksToPlaylist(userId: SPARTAN_USER_ID, playlistId: SPARTAN_PLAYLIST_ID, trackUris: TRACK_URIS_TO_SAVE, success: { (snapshotResponse) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatRemoveTracksFromPlaylistRequestCorrectlyRemovesTracksFromPlaylistWithAuthorizationToken() {
        
        _ = Spartan.removeTracksFromPlaylist(userId: SPARTAN_USER_ID, playlistId: SPARTAN_PLAYLIST_ID, trackUris: TRACK_URIS_TO_REMOVE, success: { (snapshotResponse) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatReorderPlaylistsTracksRequestCorrectlyReordersPlaylistTracksWithAuthorizationToken() {
        
        _ = Spartan.reorderPlaylistsTracks(userId: SPARTAN_USER_ID, playlistId: SPARTAN_PLAYLIST_ID, rangeStart: 0, insertBefore: 1, success: { (snapshotResponse) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatReplacePlaylistsTracksRequestCorrectlyReplacesPlaylistTracksWithAuthorizationToken() {
        
        _ = Spartan.replacePlaylistsTracks(userId: SPARTAN_USER_ID, playlistId: SPARTAN_PLAYLIST_ID, trackUris: [TRACK_URIS_TO_REMOVE.first!], success: {
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetUsersAreFollowingPlaylistsRequestCorrectlyWorksWithAuthorizationToken() {
        
        _ = Spartan.getUsersAreFollowingPlaylists(ownerId: SPARTAN_USER_ID, playlistId: SPARTAN_PLAYLIST_ID, userIds: [SPARTAN_USER_ID, "onehintwonder"], success: { (followings) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }

    
}
