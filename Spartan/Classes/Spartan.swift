/*
 
 The MIT License (MIT)
 Copyright (c) 2017 Dalton Hinterscher
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
 to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
 ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import Alamofire

public class Spartan: NSObject {

    /* Token that is included with each request that requires OAuth authentication. If the request you 
       make requries OAuth and this is nil, the response status code will be a 401 Unauthorized
     */
    public static var authorizationToken: String?
    
    /* When enabled, will log each network request and its response in the console */
    public static var loggingEnabled: Bool = true
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-album */
    
    public class func getAlbum(id: String, market: CountryCode? = nil, success: @escaping ((Album) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        
        var parameters: [String : Any] = [:]
        checkOptionalParamAddition(paramName: "market", param: market?.rawValue, parameters: &parameters)
        return Album.find(id, parameters: parameters, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-several-albums */
    
    public class func getAlbums(ids: [String], market: CountryCode? = nil, success: @escaping (([Album]) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        
        var parameters: [String : Any] = ["ids" : ids.joined(separator: ",")]
        checkOptionalParamAddition(paramName: "market", param: market?.rawValue, parameters: &parameters)
        return Album.all(parameters: parameters, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-albums-tracks */
    
    public class func getTracks(albumId:String, limit:Int = 20, offset:Int = 0, market: CountryCode? = nil, success: @escaping ((PagingObject<SimplifiedTrack>) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("\(SimplifiedAlbum.pluralRoot)/\(albumId)/\(Track.pluralRoot)")
        var parameters: [String : Any] = ["limit" : limit, "offset" : offset]
        checkOptionalParamAddition(paramName: "market", param: market?.rawValue, parameters: &parameters)
        return SpartanRequestManager.mapObject(.get, urlString: url.stringValue, parameters: parameters, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-artist */
    
    public class func getArtist(id:String, success: @escaping ((Artist) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        return Artist.find(id, success: success, failure: failure)
    }
   
    
    /* API Documentation: https://developer.spotify.com/web-api/get-several-artists */
    
    public class func getArtists(ids: [String], success: @escaping (([Album]) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        
        let parameters = ["ids" : ids.joined(separator: ",")]
        return Artist.all(parameters: parameters, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-artists-albums */
    
    public class func getArtistAlbums(artistId: String, limit:Int = 20, offset:Int = 0, albumTypes: [AlbumType] = [.album, .single, .appearsOn, .compilation], market: CountryCode? = nil, success: @escaping ((PagingObject<SimplifiedAlbum>) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        
        var albumTypesString: [String] = []
        for type in albumTypes {
            albumTypesString.append(type.rawValue)
        }
        let url = SpartanURL("\(Artist.pluralRoot)/\(artistId)/\(Album.pluralRoot)")
        var parameters = ["limit" : limit, "offset" : offset, "album_type" : albumTypesString.joined(separator: ",")] as [String : Any]
        checkOptionalParamAddition(paramName: "market", param: market?.rawValue, parameters: &parameters)
        return SpartanRequestManager.mapObject(.get, urlString: url.stringValue, parameters: parameters, success: success, failure: failure)
    }
   
    
    /* API Documentation: https://developer.spotify.com/web-api/get-artists-top-tracks */
    
    public class func getArtistsTopTracks(artistId: String, country: CountryCode, success: @escaping (([Track]) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("\(Artist.pluralRoot)/\(artistId)/top-tracks")
        let parameters = ["country" : country.rawValue]
        return SpartanRequestManager.mapObjects(.get, urlString: url.stringValue, keyPath: Track.pluralRoot, parameters: parameters, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-related-artists */
    
    public class func getArtistsRelatedArtists(artistId: String, success: @escaping (([Artist]) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("\(Artist.pluralRoot)/\(artistId)/related-artists")
        return SpartanRequestManager.mapObjects(.get, urlString: url.stringValue, keyPath: Artist.pluralRoot, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/search-item */
    
    public class func search<T: SpartanBaseObject>(query: String, type: ItemSearchType, market: CountryCode? = nil, limit: Int = 20, offset: Int = 0, success: @escaping ((PagingObject<T>) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("search")
        var parameters: [String : Any] = ["q" : query, "type" : type.rawValue, "limit" : limit, "offset" : offset]
        checkOptionalParamAddition(paramName: "market", param: market?.rawValue, parameters: &parameters)
        return SpartanRequestManager.mapObject(.get, urlString: url.stringValue, keyPath: ItemSearchType.pluralRoot(for: type), parameters: parameters, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-track */
    
    public class func getTrack(id: String, market: CountryCode? = nil, success: @escaping ((Track) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        
        var parameters: [String : Any] = [:]
        checkOptionalParamAddition(paramName: "market", param: market?.rawValue, parameters: &parameters)
        return Track.find(id, parameters: parameters, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-several-tracks */
    
    public class func getTracks(ids: [String], market: CountryCode? = nil, success: @escaping (([Track]) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        
        var parameters: [String : Any] = ["ids" : ids.joined(separator: ",")]
        checkOptionalParamAddition(paramName: "market", param: market?.rawValue, parameters: &parameters)
        return Track.all(parameters: parameters, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-users-profile */
    
    public class func getUser(id: String, success: @escaping ((PublicUser) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        return PublicUser.find(id, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-audio-analysis */

    public class func getAudioAnaylsis(trackId: String, success: @escaping ((AudioAnalysis) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("\(AudioAnalysis.root)/\(trackId)")
        return SpartanRequestManager.mapObject(.get, urlString: url.stringValue, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-audio-features */
    
    public class func getAudioFeatures(trackId: String, success: @escaping ((AudioFeaturesObject) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("\(AudioFeaturesObject.pluralRoot)/\(trackId)")
        return SpartanRequestManager.mapObject(.get, urlString: url.stringValue, success: success, failure: failure)
    }
    
    /* API Documentation: https://developer.spotify.com/web-api/get-several-audio-features */
    
    public class func getAudioFeatures(trackIds: [String], success: @escaping (([AudioFeaturesObject]) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("\(AudioFeaturesObject.pluralRoot)")
        let parameters = ["ids" : trackIds.joined(separator: ",")]
        return SpartanRequestManager.mapObjects(.get, urlString: url.stringValue, keyPath: "audio_features", parameters: parameters, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-list-featured-playlists */
    
    public class func getFeaturedPlaylists(locale: String? = nil, country: CountryCode? = nil, timestamp: String? = nil, limit: Int = 20, offset: Int = 0, success: @escaping ((FeaturedPlaylistsObject) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("browse/featured-playlists")
        var parameters: [String : Any] = ["limit" : limit, "offset" : offset]
        checkOptionalParamAddition(paramName: "locale", param: locale, parameters: &parameters)
        checkOptionalParamAddition(paramName: "country", param: country, parameters: &parameters)
        checkOptionalParamAddition(paramName: "timestamp", param: timestamp, parameters: &parameters)
        return SpartanRequestManager.mapObject(.get, urlString: url.stringValue, parameters: parameters, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-list-new-releases */
    
    public class func getNewReleases(country: CountryCode? = nil, limit: Int = 20, offset: Int = 0, success: @escaping ((PagingObject<SimplifiedAlbum>) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("browse/new-releases")
        var parameters: [String : Any] = ["limit" : limit, "offset" : offset]
        checkOptionalParamAddition(paramName: "country", param: country, parameters: &parameters)
        return SpartanRequestManager.mapObject(.get, urlString: url.stringValue, keyPath: Album.pluralRoot, parameters: parameters, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-list-categories */
    
    public class func getCategories(locale: String? = nil, country: CountryCode? = nil, limit: Int = 20, offset: Int = 0, success: @escaping ((PagingObject<CategoryObject>) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("browse/\(CategoryObject.pluralRoot)")
        var parameters: [String : Any] = ["limit" : limit, "offset" : offset]
        checkOptionalParamAddition(paramName: "locale", param: locale, parameters: &parameters)
        checkOptionalParamAddition(paramName: "country", param: country, parameters: &parameters)
        return SpartanRequestManager.mapObject(.get, urlString: url.stringValue, keyPath: CategoryObject.pluralRoot, parameters: parameters, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-category */
    
    public class func getCategory(id: String, locale: String? = nil, country: CountryCode? = nil, success: @escaping ((CategoryObject) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("browse/\(CategoryObject.pluralRoot)/\(id)")
        var parameters: [String : Any] = [:]
        checkOptionalParamAddition(paramName: "locale", param: locale, parameters: &parameters)
        checkOptionalParamAddition(paramName: "country", param: country, parameters: &parameters)
        return SpartanRequestManager.mapObject(.get, urlString: url.stringValue, parameters: parameters, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-categorys-playlists */
    
    public class func getCategorysPlaylists(categoryId: String, locale: String? = nil, country: CountryCode? = nil, limit: Int = 20, offset: Int = 0, success: @escaping ((PagingObject<SimplifiedPlaylist>) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("browse/\(CategoryObject.pluralRoot)/\(categoryId)/\(Playlist.pluralRoot)")
        var parameters: [String : Any] = ["limit" : limit, "offset" : offset]
        checkOptionalParamAddition(paramName: "locale", param: locale, parameters: &parameters)
        checkOptionalParamAddition(paramName: "country", param: country, parameters: &parameters)
        return SpartanRequestManager.mapObject(.get, urlString: url.stringValue, keyPath: Playlist.pluralRoot, parameters: parameters, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-current-users-profile */
    
    public class func getMe(success: @escaping ((PrivateUser) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("me")
        return SpartanRequestManager.mapObject(.get, urlString: url.stringValue, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-followed-artists */
    
    public class func getMyFollowedArtists(limit: Int = 20, after: String? = nil, success: @escaping ((PagingObject<Artist>) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
       
        let url = SpartanURL("me/following?type=artist")
        var parameters: [String : Any] = ["limit" : limit]
        checkOptionalParamAddition(paramName: "after", param: after, parameters: &parameters)
        return SpartanRequestManager.mapObject(.get, urlString: url.stringValue, keyPath: Artist.pluralRoot, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/follow-artists-users */
    
    public class func follow(ids: [String], type: FollowType, success: (() -> Void)?, failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("me/following?type=\(type.rawValue)&ids=\(ids.joined(separator: ","))")
        return SpartanRequestManager.makeRequest(.put, urlString: url.stringValue, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/follow-artists-users */
    
    public class func unfollow(ids: [String], type: FollowType, success: (() -> Void)?, failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("me/following?type=\(type.rawValue)&ids=\(ids.joined(separator: ","))")
        return SpartanRequestManager.makeRequest(.delete, urlString: url.stringValue, success: success, failure: failure)
    }
    
    /* API Documentation: https://developer.spotify.com/web-api/check-current-user-follows */
    
    public class func getIsFollowing(ids: [String], type: FollowType, success: @escaping (([Bool]) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
       
        let url = SpartanURL("me/following/contains?type=\(type.rawValue)&ids=\(ids.joined(separator: ","))")
        return SpartanRequestManager.mapBoolArray(.get, urlString: url.stringValue, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/follow-playlist */
    
    public class func followPlaylist(ownerId: String, playlistId: String, isPublic: Bool = true, success: (() -> Void)?, failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("users/\(ownerId)/\(Playlist.pluralRoot)/\(playlistId)/followers")
        let parameters: [String : Any] = ["public" : isPublic]
        return SpartanRequestManager.makeRequest(.put, urlString: url.stringValue, parameters: parameters, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/unfollow-playlist */
    
    public class func unfollowPlaylist(ownerId: String, playlistId: String, success: (() -> Void)?, failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("users/\(ownerId)/\(Playlist.pluralRoot)/\(playlistId)/followers")
        return SpartanRequestManager.makeRequest(.delete, urlString: url.stringValue, success: success, failure: failure)
    }
    
    /* API Documentation: https://developer.spotify.com/web-api/save-tracks-user */
    
    public class func saveTracks(trackIds: [String], success: (() -> Void)?, failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("me/\(Track.pluralRoot)?ids=\(trackIds.joined(separator: ","))")
        return SpartanRequestManager.makeRequest(.put, urlString: url.stringValue, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-users-saved-tracks */
    
    public class func getSavedTracks(limit: Int = 20, offset: Int = 0, market: CountryCode? = nil, success: @escaping ((PagingObject<SavedTrack>) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
       
        let url = SpartanURL("me/\(Track.pluralRoot)")
        var parameters: [String : Any] = ["limit" : limit, "offset" : offset]
        checkOptionalParamAddition(paramName: "market", param: market?.rawValue, parameters: &parameters)
        return SpartanRequestManager.mapObject(.get, urlString: url.stringValue, parameters: parameters, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/remove-tracks-user */
    
    public class func removeSavedTracks(trackIds: [String], success: (() -> Void)?, failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("me/\(Track.pluralRoot)?ids=\(trackIds.joined(separator: ","))")
        return SpartanRequestManager.makeRequest(.delete, urlString: url.stringValue, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/check-users-saved-tracks */
    
    public class func tracksAreSaved(trackIds: [String],  success: @escaping (([Bool]) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("me/\(Track.pluralRoot)/contains?ids=\(trackIds.joined(separator: ","))")
        return SpartanRequestManager.mapBoolArray(.get, urlString: url.stringValue, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/save-albums-user */
    
    public class func saveAlbums(albumIds: [String], success: (() -> Void)?, failure: ((SpartanError) -> Void)?) -> Request {
       
        let url = SpartanURL("me/\(Album.pluralRoot)?ids=\(albumIds.joined(separator: ","))")
        return SpartanRequestManager.makeRequest(.put, urlString: url.stringValue, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-users-saved-albums */
    
    public class func getSavedAlbums(limit: Int = 20, offset: Int = 0, market: CountryCode? = nil, success: @escaping ((PagingObject<SavedAlbum>) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("me/\(Album.pluralRoot)")
        var parameters: [String : Any] = ["limit" : limit, "offset" : offset]
        checkOptionalParamAddition(paramName: "market", param: market?.rawValue, parameters: &parameters)
        return SpartanRequestManager.mapObject(.get, urlString: url.stringValue, parameters: parameters, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/remove-albums-user */
    
    public class func removeSavedAlbums(albumIds: [String], success: (() -> Void)?, failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("me/\(Album.pluralRoot)?ids=\(albumIds.joined(separator: ","))")
        return SpartanRequestManager.makeRequest(.delete, urlString: url.stringValue, success: success, failure: failure)
    }

    
    /* API Documentation: https://developer.spotify.com/web-api/check-users-saved-albums */
    
    public class func albumsAreSaved(albumIds: [String], success: @escaping (([Bool]) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
       
        let url = SpartanURL("me/\(Album.pluralRoot)/contains?ids=\(albumIds.joined(separator: ","))")
        return SpartanRequestManager.mapBoolArray(.get, urlString: url.stringValue, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-users-top-artists-and-tracks/ */
    
    public class func getMyTopArtists(limit: Int = 20, offset: Int = 0, timeRange: TimeRange = .mediumTerm, success: @escaping ((PagingObject<Artist>) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        let url = SpartanURL("me/top/\(Artist.pluralRoot)")
        let parameters: [String : Any] = ["limit" : limit, "offset" : offset, "time_range" : timeRange.rawValue]
        return SpartanRequestManager.mapObject(.get, urlString: url.stringValue, parameters: parameters, success: success, failure: failure)
    }

    
    /* API Documentation: https://developer.spotify.com/web-api/get-users-top-artists-and-tracks/ */
    
    public class func getMyTopTracks(limit: Int = 20, offset: Int = 0, timeRange: TimeRange = .mediumTerm, success: @escaping ((PagingObject<Track>) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        let url = SpartanURL("me/top/\(Track.pluralRoot)")
        let parameters: [String : Any] = ["limit" : limit, "offset" : offset, "time_range" : timeRange.rawValue]
        return SpartanRequestManager.mapObject(.get, urlString: url.stringValue, parameters: parameters, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-recommendations */
    
    public class func getRecommendations(limit: Int = 20, market: CountryCode? = nil, minAttributes: [(TuneableTrackAttribute, Float)]? = nil, maxAttributes: [(TuneableTrackAttribute, Float)]? = nil, targetAttributes: [(TuneableTrackAttribute, Float)]? = nil, seedArtists: [String]? = nil, seedGenres: [String]? = nil, seedTracks: [String]? = nil, success: @escaping ((RecommendationsObject) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("recommendations")
        var parameters: [String : Any] = ["limit" : limit]
        
        checkOptionalParamAddition(paramName: "market", param: market?.rawValue, parameters: &parameters)
        checkOptionalTuneableTrackAttributeTupleParamAddition(prefix: "max", attributes: maxAttributes, parameters: &parameters)
        checkOptionalTuneableTrackAttributeTupleParamAddition(prefix: "min", attributes: minAttributes, parameters: &parameters)
        checkOptionalTuneableTrackAttributeTupleParamAddition(prefix: "target", attributes: targetAttributes, parameters: &parameters)
        checkOptionalArrayParamAddition(paramName: "seed_artists", param: seedArtists, parameters: &parameters)
        checkOptionalArrayParamAddition(paramName: "seed_genres", param: seedGenres, parameters: &parameters)
        checkOptionalArrayParamAddition(paramName: "seed_tracks", param: seedTracks, parameters: &parameters)
        
        return SpartanRequestManager.mapObject(.get, urlString: url.stringValue, parameters: parameters, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-list-users-playlists */
    
    public class func getUsersPlaylists(userId: String, limit: Int = 20, offset: Int = 0, success: @escaping ((PagingObject<SimplifiedPlaylist>) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("\(PublicUser.pluralRoot)/\(userId)/\(Playlist.pluralRoot)")
        let parameters: [String : Any] = ["limit" : limit, "offset" : offset]
        return SpartanRequestManager.mapObject(.get, urlString: url.stringValue, parameters: parameters, success: success, failure: failure)
    }

    
    /* API Documentation: https://developer.spotify.com/web-api/get-list-users-playlists */
    
    public class func getMyPlaylists(limit: Int = 20, offset: Int = 0, success: @escaping ((PagingObject<SimplifiedPlaylist>) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("me/\(Playlist.pluralRoot)")
        let parameters: [String : Any] = ["limit" : limit, "offset" : offset]
        return SpartanRequestManager.mapObject(.get, urlString: url.stringValue, parameters: parameters, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-playlist */

    public class func getUsersPlaylist(userId: String, playlistId: String, fields: [String]? = nil, market: CountryCode? = nil, success: @escaping ((Playlist) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("\(PublicUser.pluralRoot)/\(userId)/\(Playlist.pluralRoot)/\(playlistId)")
        var parameters: [String : Any] = [:]
        checkOptionalParamAddition(paramName: "fields", param: fields?.joined(separator: ","), parameters: &parameters)
        checkOptionalParamAddition(paramName: "market", param: market?.rawValue, parameters: &parameters)
        return SpartanRequestManager.mapObject(.get, urlString: url.stringValue, parameters: parameters, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/get-playlists-tracks */
    
    public class func getPlaylistTracks(userId: String, playlistId: String, limit: Int = 20, offset: Int = 0, fields: [String]? = nil, market: CountryCode? = nil, success: @escaping ((PagingObject<PlaylistTrack>) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("\(PublicUser.pluralRoot)/\(userId)/\(Playlist.pluralRoot)/\(playlistId)/\(Track.pluralRoot)")
        var parameters: [String : Any] = ["limit" : limit, "offset" : offset]
        checkOptionalParamAddition(paramName: "fields", param: fields?.joined(separator: ","), parameters: &parameters)
        checkOptionalParamAddition(paramName: "market", param: market?.rawValue, parameters: &parameters)
        return SpartanRequestManager.mapObject(.get, urlString: url.stringValue, parameters: parameters, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/create-playlist */
    
    public class func createPlaylist(userId: String, name: String, isPublic: Bool = true, isCollaborative: Bool = false, success: @escaping ((Playlist) -> Void), failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("\(PublicUser.pluralRoot)/\(userId)/\(Playlist.pluralRoot)")
        let parameters: [String : Any] = ["name" : name, "public" : isPublic, "collaborative" : isCollaborative]
        return SpartanRequestManager.mapObject(.post, urlString: url.stringValue, parameters: parameters, encoding: JSONEncoding.default, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/change-playlist-details */
    
    public class func changePlaylistDetails(userId: String, playlistId: String, name: String, isPublic: Bool, isCollaborative: Bool, success: (() -> Void)?, failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("\(PublicUser.pluralRoot)/\(userId)/\(Playlist.pluralRoot)/\(playlistId)")
        let parameters: [String : Any] = ["name" : name, "public" : isPublic, "collaborative" : isCollaborative]
        return SpartanRequestManager.makeRequest(.put, urlString: url.stringValue, parameters: parameters, encoding: JSONEncoding.default, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/add-tracks-to-playlist */
    
    public class func addTracksToPlaylist(userId: String, playlistId: String, trackUris: [String], position: Int? = nil, success: ((SnapshotResponse) -> Void)?, failure: ((SpartanError) -> Void)?) -> Request {
        
        var urlString = "\(PublicUser.pluralRoot)/\(userId)/\(Playlist.pluralRoot)/\(playlistId)/\(Track.pluralRoot)?uris=\(trackUris.joined(separator: ","))"
        if let position = position {
            urlString += "&position=\(position)"
        }
        let url = SpartanURL(urlString)
        
        return SpartanRequestManager.mapObject(.post, urlString: url.stringValue, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/remove-tracks-playlist */
    
    public class func removeTracksFromPlaylist(userId: String, playlistId: String, trackUris: [String], success: ((SnapshotResponse) -> Void)?, failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("\(PublicUser.pluralRoot)/\(userId)/\(Playlist.pluralRoot)/\(playlistId)/\(Track.pluralRoot)")
        var trackUrisArray: [[String : String]] = []
        for trackUri in trackUris {
            trackUrisArray.append(["uri" : trackUri])
        }
        let parameters: [String : Any] = ["tracks" : trackUrisArray]
        return SpartanRequestManager.mapObject(.delete, urlString: url.stringValue, parameters: parameters, encoding: JSONEncoding.default, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/reorder-playlists-tracks */
    
    public class func reorderPlaylistsTracks(userId: String, playlistId: String, rangeStart: Int, rangeLength: Int = 1, insertBefore: Int, snapshotId: String? = nil, success: ((SnapshotResponse) -> Void)?, failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("\(PublicUser.pluralRoot)/\(userId)/\(Playlist.pluralRoot)/\(playlistId)/\(Track.pluralRoot)")
        var parameters: [String : Any] = ["range_start" : rangeStart, "range_length" : rangeLength, "insert_before" : insertBefore]
        checkOptionalParamAddition(paramName: "snapshot_id", param: snapshotId, parameters: &parameters)
        return SpartanRequestManager.mapObject(.put, urlString: url.stringValue, parameters: parameters, encoding: JSONEncoding.default, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/replace-playlists-tracks */
    
    public class func replacePlaylistsTracks(userId: String, playlistId: String, trackUris: [String], success: (() -> Void)?, failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("\(PublicUser.pluralRoot)/\(userId)/\(Playlist.pluralRoot)/\(playlistId)/\(Track.pluralRoot)?uris=\(trackUris.joined(separator: ","))")
        return SpartanRequestManager.makeRequest(.put, urlString: url.stringValue, success: success, failure: failure)
    }
    
    
    /* API Documentation: https://developer.spotify.com/web-api/check-user-following-playlist */
    
    public class func getUsersAreFollowingPlaylists(ownerId: String, playlistId: String, userIds: [String], success: (([Bool]) -> Void)?, failure: ((SpartanError) -> Void)?) -> Request {
        
        let url = SpartanURL("\(PublicUser.pluralRoot)/\(ownerId)/\(Playlist.pluralRoot)/\(playlistId)/followers/contains?ids=\(userIds.joined(separator: ","))")
        return SpartanRequestManager.mapBoolArray(.get, urlString: url.stringValue, success: success, failure: failure)
    }

    
    private class func checkOptionalParamAddition(paramName: String, param: Any?, parameters: inout [String : Any]) {
        if let param = param {
            parameters[paramName] = param
        }
    }
    
    private class func checkOptionalArrayParamAddition(paramName: String, param: [String]?, parameters: inout [String : Any]) {
        if let param = param {
            parameters[paramName] = param.joined(separator: ",")
        }
    }
    
    private class func checkOptionalTuneableTrackAttributeTupleParamAddition(prefix: String, attributes: [(TuneableTrackAttribute, Float)]?, parameters: inout [String : Any]) {
        
        guard let attributes = attributes else {
            return
        }
        
        for (attribute, value) in attributes {
            parameters["\(prefix)_\(attribute.rawValue)"] = value
        }
    }
    
}
