![Spartan](https://raw.githubusercontent.com/Daltron/Spartan/master/Spartan/Assets/spartan.png)

[![CI Status](http://img.shields.io/travis/Daltron/Spartan.svg?style=flat)](https://travis-ci.org/Daltron/Spartan)
[![Version](https://img.shields.io/cocoapods/v/Spartan.svg?style=flat)](http://cocoapods.org/pods/Spartan)
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/swift-3.0-4BC51D.svg?style=flat" alt="Language: Swift" /></a>
[![License](https://img.shields.io/cocoapods/l/Spartan.svg?style=flat)](http://cocoapods.org/pods/Spartan)
[![Platform](https://img.shields.io/cocoapods/p/Spartan.svg?style=flat)](http://cocoapods.org/pods/Spartan)

## Written in Swift 3
Spartan is a lightweight, elegant, and easy to use Spotify Web API wrapper library for iOS and macOS written in Swift 3. Under the hood, Spartan makes request to the Spotify Web API. Those requests are then turned into clean, friendly, and easy to use objects.

### What this library allows you to do:
- ✅ Make any request that the Spotify Web API allows.

### What this library doesn't do:
- ❌ Authorization flows that help provide you with an authorization token. The [Spotify iOS SDK](https://github.com/spotify/ios-sdk) can help assist you with that.

## Requirements

 - iOS 9.0+ / macOS 10.11+
 - xCode 8.1+

## Installation

### CocoaPods

To integrate Spartan into your xCode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'   # If you targeting iOS
platform :osx, '10.11' # If you targeting macOS
use_frameworks!

pod 'Spartan'
```

Then, run the following command:

```bash
$ pod install
```

This will download any library dependencies you do not already have in your project.

## Usage

### Spartan Properties

#### Authorization Token
```swift
public static var authorizationToken: String?
```
This is the token that is included with each request that requires OAuth authentication. If the request you make requires OAuth and this in nil, invalid, or expired, the request will fail. This can be left `nil` if you do not plan on making any requests that require OAuth authentication.

Each time your token is refreshed, simply update it:

```swift
Spartan.authorizationToken = newToken
```

#### Logging
```swift
public static var loggingEnabled: Bool = true
```

When enabled, before each request starts and after each request finishes, helpful statements will be printed to the console.

A successful request will look something like this:

```swift
🔵 [SpartanRequestLogger] GET https://api.spotify.com/v1/me
⚪️ [SpartanRequestLogger] GET https://api.spotify.com/v1/me (200 OK) 0.140969038009644 seconds
```

While a failed/invalid request will look something like this:

```swift
🔵 [SpartanRequestLogger] GET https://api.spotify.com/v1/me
🔴 [SpartanRequestLogger] GET https://api.spotify.com/v1/me (401 Unauthorized) 0.81086003780365 seconds
```

This can be enabled/disabled at any time anywhere in your code simply by:

```swift
Spartan.loggingEnabled = true/false
```

## Core

For more information on each request, please click the link associated with it. Spotify provides excellent documentation for each api request that they support. Spartan supports almost all query parameter fields that Spotify allows.

### PagingObject

Quite a few requests return a `PagingObject`. This is an offset based paging object that is a container for a set of objects. It contains a key called items whose value is an array of the requested objects. It can be used to get the previous set of items or the next set of items for a future call.

For example:

```swift
_ = Spartan.search(query: "Five for Fighting", type: .track, success: { (pagingObject: PagingObject<Track>) in
	self.pagingObject = pagingObject
}, failure: { (error) in
	print(error)
})
```

Then later, if you need to load more data (scrolled to bottom of UITableView/UICollectionView, etc...) more data can be loaded/reloaded with these two methods:

#### Get Next

```swift
if pagingObject.canMakeNextRequest {

	pagingObject.getNext(success: { (pagingObject) in
   		// Update the paging object
   		self.pagingObject = pagingObject            
	}, failure: { (error) in
		print(error)
	})
}
```

#### Get Previous

```swift
if pagingObject.canMakePreviousRequest {

	pagingObject.getPrevious(success: { (pagingObject) in
   		// Update the paging object
   		self.pagingObject = pagingObject            
	}, failure: { (error) in
		print(error)
	})
}
```

### Requests

#### [Get an Album](https://developer.spotify.com/web-api/get-album/)

```swift
_ = Spartan.getAlbum(id: albumId, market: .us, success: { (album) in
	// Do something with the album    
}, failure: { (error) in
	print(error)      
})
```

#### [Get Several Albums](https://developer.spotify.com/web-api/get-several-albums/)

```swift
_ = Spartan.getAlbums(ids: albumIds, market: .us, success: { (albums) in
	// Do something with the albums
}, failure: { (error) in
	print(error)
})
```

#### [Get an Album's Tracks](https://developer.spotify.com/web-api/get-albums-tracks/)

```swift
_ = Spartan.getTracks(albumId: albumId, limit: 20, offset: 0, market: .us, success: { (pagingObject) in
	// Get the tracks via pagingObject.items
}, failure: { (error) in
	print(error)
})
```

#### [Get an Artist](https://developer.spotify.com/web-api/get-artist/)

```swift
_ = Spartan.getArtist(id: artistId, success: { (artist) in
	// Do something with the artist
}, failure: { (error) in
	print(error)
})
```

#### [Get Several Artists](https://developer.spotify.com/web-api/get-several-artists/)

```swift
_ = Spartan.getArtists(ids: artistIds, success: { (artists) in
	// Do something with the artists
}, failure: { (error) in
	print(error)
})
```

#### [Get a Track](https://developer.spotify.com/web-api/search-item/)

```swift
_ = Spartan.getTrack(id: track, market: .us, success: { (track) in
	// Do something with the track
}, failure: { (error) in
	print(error)
})
```

#### [Get Several Tracks](https://developer.spotify.com/web-api/get-several-tracks/)

```swift
_ = Spartan.getTracks(ids: trackIds, market: .us, success: { (tracks) in
	// Do something with the tracks
}, failure: { (error) in
	print(error)
})
```

#### [Get an Artist's Albums](https://developer.spotify.com/web-api/get-artists-albums/)

```swift
_ = Spartan.getArtistAlbums(artistId: artistId, limit: 20, offset: 0, albumTypes: [.album, .single, .appearsOn, .compilation], market: .us, success: { (pagingObject) in
	// Get the albums via pagingObject.items
}, failure: { (error) in
	print(error)
})
```

#### [Get an Artist's Top Tracks](https://developer.spotify.com/web-api/get-artists-top-tracks/)

```swift
 _ = Spartan.getArtistsTopTracks(artistId: artistId, country: .us, success: { (tracks) in
	// Do something with the tracks
}, failure: { (error) in
	print(error)
})
```

#### [Get an Artist's Related Artists](https://developer.spotify.com/web-api/get-artists-top-tracks/)

```swift
_ = Spartan.getArtistsRelatedArtists(artistId: artistId, success: { (artists) in
	// Do something with the artists
}, failure: { (error) in
	print(error)
})
```

#### [Search for Albums](https://developer.spotify.com/web-api/search-item/)

```swift
_ = Spartan.search(query: query, type: .album, success: { (pagingObject: PagingObject<SimplifiedAlbum>) in
	// Get the albums via pagingObject.items     
}, failure: { (error) in
	print(error)
})
```

#### [Search for Artists](https://developer.spotify.com/web-api/search-item/)

```swift
_ = Spartan.search(query: query, type: .artist, success: { (pagingObject: PagingObject<SimplifiedArtist>) in
	// Get the artists via pagingObject.items     
}, failure: { (error) in
	print(error)
})
```

#### [Search for Playlists](https://developer.spotify.com/web-api/search-item/)

```swift
_ = Spartan.search(query: query, type: .playlist, success: { (pagingObject: PagingObject<SimplifiedPlaylist>) in
	// Get the playlists via pagingObject.items     
}, failure: { (error) in
	print(error)
})
```

#### [Search for Tracks](https://developer.spotify.com/web-api/search-item/)

```swift
_ = Spartan.search(query: query, type: .track, success: { (pagingObject: PagingObject<SimplifiedTrack>) in
	// Get the tracks via pagingObject.items     
}, failure: { (error) in
	print(error)
})
```

#### [Get a User’s Profile](https://developer.spotify.com/web-api/get-users-profile/)

```swift
_ = Spartan.getUser(id: userId, success: { (user) in
	// Do something with the user
}, failure: { (error) in
	print(error)
})
```

#### [Get Audio Analysis for a Track](https://developer.spotify.com/web-api/get-audio-analysis/)

```swift
_ = Spartan.getAudioAnaylsis(trackId: trackId, success: { (audiAnalysis) in
	// Do something with the audio analysis
}, failure: { (error) in
	print(error)
})
```

#### [Get Audio Features for a Track](https://developer.spotify.com/web-api/get-audio-analysis/)

```swift
_ = Spartan.getAudioFeatures(trackId: trackId, success: { (audioFeaturesObject) in
	// Do something with the audio features object  
}, failure: { (error) in
	print(error)
})
```

#### [Get Audio Features for a Track](https://developer.spotify.com/web-api/get-audio-features/)

```swift
_ = Spartan.getAudioFeatures(trackId: trackId, success: { (audioFeaturesObject) in
	// Do something with the audio features object  
}, failure: { (error) in
	print(error)
})
```

#### [Get Audio Features for Several Tracks](https://developer.spotify.com/web-api/get-several-audio-features/)

```swift
_ = Spartan.getAudioFeatures(trackIds: trackIds, success: { (audioFeaturesObject) in
	// Do something with the audio features objects
}, failure: { (error) in
	print(error)
})
```

#### [Get a List of Featured Playlists](https://developer.spotify.com/web-api/get-list-featured-playlists/)

```swift
_ = Spartan.getFeaturedPlaylists(locale: locale, country: .us, timestamp: timestamp, limit: 20, offset: 0, success: { (featuredPlaylistsObject) in
	// Do something with the featured playlists object        
}, failure: { (error) in
	print(error)        
})
```

#### [Get a List of New Releases](https://developer.spotify.com/web-api/get-list-new-releases/)

```swift
_ = Spartan.getNewReleases(country: .us, limit: 20, offset: 0, success: { (pagingObject) in
	// Get the albums via pagingObject.items
}, failure: { (error) in
	print(error)
})
```

#### [Get a List of Categories](https://developer.spotify.com/web-api/get-list-categories/)

```swift
_ = Spartan.getCategories(success: { (pagingObject) in
	// Get the categories via pagingObject.items
}, failure: { (error) in
	print(error)
})
```

#### [Get a Category’s Playlists](https://developer.spotify.com/web-api/get-categorys-playlists/)

```swift
_ = Spartan.getCategorysPlaylists(categoryId: categoryId, locale: locale, country: .us, limit: 20, offset: 0, success: { (pagingObject) in
	// Get the playlists via pagingObject.items
}, failure: { (error) in
	print(error)
})
```

#### [Get Current User’s Profile](https://developer.spotify.com/web-api/get-current-users-profile/)

```swift
_ = Spartan.getMe(success: { (user) in
	// Do something with the user object
}, failure: { (error) in
	print(error)
})
```

#### [Get User’s Followed Artists](https://developer.spotify.com/web-api/get-followed-artists/)

```swift
_ = Spartan.getMyFollowedArtists(success: { (pagingObject) in
	// Get artists via pagingObject.items
}, failure: { (error) in
	print(error)
})
```

#### [Follow Artists](https://developer.spotify.com/web-api/follow-artists-users/)

```swift
_ = Spartan.follow(ids: artistIds, type: .artist, success: {
	// Artists are now followed   
}, failure: { (error) in
	print(error)
})
```

#### [Follow Users](https://developer.spotify.com/web-api/follow-artists-users/)

```swift
_ = Spartan.follow(ids: userIds, type: .user, success: {
	// Users are now followed   
}, failure: { (error) in
	print(error)
})
```

#### [Unfollow Artists](https://developer.spotify.com/web-api/unfollow-artists-users/)

```swift
_ = Spartan.unfollow(ids: artistIds, type: .artist, success: {
	// Artists are now unfollowed   
}, failure: { (error) in
	print(error)
})
```

#### [Unfollow Users](https://developer.spotify.com/web-api/unfollow-artists-users/)

```swift
_ = Spartan.unfollow(ids: userIds, type: .user, success: {
	// Users are now unfollowed   
}, failure: { (error) in
	print(error)
})
```

#### [Check if Current User Follows Artists](https://developer.spotify.com/web-api/check-current-user-follows/)

```swift
_ = Spartan.getIsFollowing(ids: artistIds, type: .artist, success: { (followingBools) in
	// Do something with the followingBools
}, failure: { (error) in
	print(error)        
})
```

#### [Check if Current User Follows Users](https://developer.spotify.com/web-api/check-current-user-follows/)

```swift
_ = Spartan.getIsFollowing(ids: userIds, type: .user, success: { (followingBools) in
	// Do something with the followingBools
}, failure: { (error) in
	print(error)        
})
```

#### [Follow a Playlist](https://developer.spotify.com/web-api/follow-playlist/)

```swift
_ = Spartan.followPlaylist(ownerId: ownerId, playlistId: playlistId, isPublic: true, success: {
   // Playlist is now followed
}, failure: { (error) in
	print(error)           
})
```

#### [Unfollow a Playlist](https://developer.spotify.com/web-api/unfollow-playlist/)

```swift
_ = Spartan.unfollowPlaylist(ownerId: ownerId, playlistId: playlistId, success: {
	// Playlist is now unfollowed     
}, failure: { (error) in
	print(error)
})
```

#### [Get a User’s Saved Tracks](https://developer.spotify.com/web-api/save-tracks-user/)

```swift
 _ = Spartan.getSavedTracks(limit: 20, offset: 0, market: .us, success: { (pagingObject) in
	// Get the saved tracks via pagingObject.items     
}, failure: { (error) in
	print(error)   
})
```

#### [Save Tracks for User](https://developer.spotify.com/web-api/save-tracks-user/)

```swift
_ = Spartan.saveTracks(trackIds: trackIds, success: {
	// Tracks are now saved    
}, failure: { (error) in
	print(error)    
})
```

#### [Remove User’s Saved Tracks](https://developer.spotify.com/web-api/remove-tracks-user/)

```swift
_ = Spartan.removeSavedTracks(trackIds: trackIds, success: {
	// Tracks are now removed
}, failure: { (error) in
    print(error)
})
```

#### [Check User’s Saved Tracks](https://developer.spotify.com/web-api/check-users-saved-tracks/)

```swift
_ = Spartan.tracksAreSaved(trackIds: trackIds, success: { (savedBools) in
    // Do something with the savedBools    
}, failure: { (error) in
    print(error)    
})
```

#### [Get Current User’s Saved Albums](https://developer.spotify.com/web-api/get-users-saved-albums/)

```swift
 _ = Spartan.getSavedAlbums(limit: 20, offset: 0, market: .us, success: { (pagingObject) in
    // Get the saved albums via pagingObject.items    
}, failure: { (error) in
 	print(error)      
})        
```

#### [Save Albums for User](https://developer.spotify.com/web-api/save-albums-user/)

```swift
_ = Spartan.saveAlbums(albumIds: albumIds, success: {
	// Albums are now saved    
}, failure: { (error) in
	print(error)    
})
```

#### [Remove User’s Saved Albums](https://developer.spotify.com/web-api/remove-albums-user/)

```swift
_ = Spartan.removeSavedAlbums(albumIds: albumIds, success: {
	// Albums are now removed
}, failure: { (error) in
    print(error)
})
```

#### [Check User’s Saved Albums](https://developer.spotify.com/web-api/check-users-saved-albums/)

```swift
_ = Spartan.albumsAreSaved(albumIds: albumIds, success: { (savedBools) in
    // Do something with the savedBools    
}, failure: { (error) in
    print(error)    
})
```

#### [Get a User’s Top Artists and Tracks](https://developer.spotify.com/web-api/get-users-top-artists-and-tracks/)

```swift
_ = Spartan.albumsAreSaved(albumIds: albumIds, success: { (savedBools) in
    // Do something with the savedBools    
}, failure: { (error) in
    print(error)    
})
```

#### [Check User’s Saved Albums](https://developer.spotify.com/web-api/check-users-saved-albums/)

```swift
_ = Spartan.albumsAreSaved(albumIds: albumIds, success: { (savedBools) in
    // Do something with the savedBools    
}, failure: { (error) in
    print(error)    
})
```

#### [Get a User’s Top Artists](https://developer.spotify.com/web-api/get-users-top-artists-and-tracks/)

```swift
_ = Spartan.getMyTopArtists(limit: 20, offset: 0, timeRange: .mediumTerm, success: { (pagingObject) in
	// Get the artists via pagingObject.items
}, failure: { (error) in
	print(error)
})
```

#### [Get a User’s Top Tracks](https://developer.spotify.com/web-api/get-users-top-artists-and-tracks/)

```swift
_ = Spartan.getMyTopTracks(limit: 20, offset: 0, timeRange: .mediumTerm, success: { (pagingObject) in
	// Get the tracks via pagingObject.items
}, failure: { (error) in
	print(error)
})
```

#### [Get a List of a User’s Playlists](https://developer.spotify.com/web-api/get-list-users-playlists/)

```swift
_ = Spartan.getUsersPlaylists(userId: userId, limit: 20, offset: 0, success: { (pagingObject) in
	// Get the playlists via pagingObject.playlists
}, failure: { (error) in
	print(error)
})
```

#### [Get a List of Current User’s Playlists](https://developer.spotify.com/web-api/get-a-list-of-current-users-playlists/)

```swift
_ = Spartan.getMyPlaylists(limit: 20, offset: 0, success: { (pagingObject) in
	// Get the playlists via pagingObject.items
}, failure: { (error) in
	print(error)
})
```

#### [Get a Playlist](https://developer.spotify.com/web-api/get-playlist/)

```swift
_ = Spartan.getUsersPlaylist(userId: userId, playlistId: playlistId, fields: fields, market: .us, success: { (playlist) in
	// Do something with the playlist
}, failure: { (error) in
	print(error)
})
```

#### [Get a Playlist's Tracks](https://developer.spotify.com/web-api/get-playlists-tracks/)

```swift
_ = Spartan.getPlaylistTracks(userId: userId, playlistId: playlistId, limit: 20, offset: 0, fields: fields, market: .us, success: { (pagingObject) in
	// Get the playlist tracks via pagingObject.items
}, failure: { (error) in
	print(error)
})
```

#### [Create a Playlist](https://developer.spotify.com/web-api/create-playlist/)

```swift
_ = Spartan.createPlaylist(userId: userId, name: name, isPublic: true, isCollaborative: true, success: { (playlist) in
	// Do something with the playlist
}, failure: { (error) in
	print(error)
})
```

#### [Change a Playlist’s Details](https://developer.spotify.com/web-api/change-playlist-details/)

```swift
_ = Spartan.changePlaylistDetails(userId: userId, playlistId: playlistId, name: name, isPublic: false, isCollaborative: false, success: {
	// The playlist details are now changed
}, failure: { (error) in
	print(error)
})
```

#### [Add Tracks to a Playlist](https://developer.spotify.com/web-api/add-tracks-to-playlist/)

```swift
_ = Spartan.addTracksToPlaylist(userId: userId, playlistId: playlistId, trackUris: trackUris, success: { (snapshot) in
	// Do something with the snapshot
}, failure: { (error) in
	print(error)
})
```

#### [Remove Tracks from a Playlist](https://developer.spotify.com/web-api/remove-tracks-playlist/)

```swift
_ = Spartan.removeTracksFromPlaylist(userId: userId, playlistId: playlistId, trackUris: trackUris, success: { (snapshot) in
	// Do something with the snapshot
}, failure: { (error) in
	print(error)
})
```

#### [Reorder a Playlist’s Tracks](https://developer.spotify.com/web-api/reorder-playlists-tracks/)

```swift
_ = Spartan.reorderPlaylistsTracks(userId: userId, playlistId: playlistId, rangeStart: rangeStart, rangeLength: rangeLength, insertBefore: insertBefore, snapshotId: snapshotId, success: { (snapshot) in
	// Tracks are now reordered
}, failure: { (error) in
	print(error)
})
```

#### [Replace a Playlist’s Tracks](https://developer.spotify.com/web-api/replace-playlists-tracks/)

```swift
_ = Spartan.replacePlaylistsTracks(userId: userId, playlistId: playlistId, trackUris: trackUris, success: {
	// Tracks are now replaced in playlist
}, failure: { (error) in
	print(error)
})
```

#### [Check if Users Follow a Playlist](https://developer.spotify.com/web-api/check-user-following-playlist/)

```swift
_ = Spartan.getUsersAreFollowingPlaylists(ownerId: ownerId, playlistId: playlistId, userIds: userIds, success: { (followings) in
	// Do something with the followings
}) { (error) in
	print(error)
}
```







## Handling Errors

SpartanError objects have a type and error message to help determine what kind of error occurred.

```swift
public class SpartanError: NSObject, Mappable {
    private(set) open var type: SpartanErrorType!
    private(set) open var errorMessage:String!
}
```

If a request suceeds but is invalid, the erorrMessage will be the error message returned directly from Spotify.

For example, if the Spotify error response is:

```swift
{
  "error": {
    "status": 401,
    "message": "Invalid access token"
  }
}
```

The SpartanError object within a failure callback will be:

```swift
_ = Spartan.getMe(success: { (user) in

}, failure: { (error) in
	print(error.errorType)     // .unauthorized
	print(error.errorMessage)  // "Invalid access token"
})
```

So if your access token is expired, you could do something like this:

```swift
_ = Spartan.getMe(success: { (user) in

}, failure: { (error) in
	if error.errorType == .unauthorized {
		// Refresh your access token and try again
	}
})
```

## Library Dependencies

 - [Alamofire](https://github.com/Alamofire/Alamofire): Elegant HTTP Networking in Swift
 - [AlamofireObjectMapper](https://github.com/tristanhimmelman/AlamofireObjectMapper): An Alamofire extension which converts JSON into Swift objects

## Usage Information and Limits

Since Spartan is built on top of the Spotify Web API, [click here for more information](https://developer.spotify.com/web-api/user-guide/#rate-limiting)

## Author

Dalton Hinterscher, daltonhint4@gmail.com

## License

Spartan is available under the MIT license. See the LICENSE file for more info.
