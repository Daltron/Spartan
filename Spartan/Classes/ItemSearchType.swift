
public enum ItemSearchType: String {
    case album = "album"
    case artist = "artist"
    case playlist = "playlist"
    case track = "track"
    
    static func pluralRoot(for type: ItemSearchType) -> String {
        switch type {
            case album: return Album.pluralRoot
            case artist: return Artist.pluralRoot
            case playlist: return SimplifiedPlaylist.pluralRoot
            case track: return Track.pluralRoot
        }
    }
}
