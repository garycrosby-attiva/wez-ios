import Foundation

/// A Spotted post.
///
/// Shape follows the canonical D1 schema (AD-WEZ-post-metadata-store v2), **not** the web
/// substrate's `Post` type — per the cross-substrate rule (graph/AD authoritative over structure;
/// web authoritative over behaviour). What is lifted from the web is *behaviour*: the editorial
/// summary/author pairing invariant (`validate()`).
public struct SpottedPost: Codable, Equatable, Sendable, Identifiable {
    public let id: String
    public let beachId: String
    /// R2 object reference (object pattern `spotted/{id}.jpg`, AD-WEZ-photo-storage v2).
    public let photoUrl: String
    /// Caption affordance is deferred (OpenThread caption-affordance, Change 3): the field exists
    /// per the D1 schema; nothing populates it until that change lands.
    public let caption: String?
    /// Conditions snapshot from `BeachConditionsProvider` at capture time.
    /// (Change 2's capture flow confirms whether the full snapshot or a reduced label set persists.)
    public let captureConditions: BeachConditions
    /// Union of the beach's static tags and condition-derived tags, computed at capture submit.
    public let derivedTags: [String]
    /// Editorial fields — both `nil` (a user post) or both populated (an editorial post).
    public let summary: String?
    public let author: String?
    public let createdAt: Date

    public init(
        id: String,
        beachId: String,
        photoUrl: String,
        caption: String?,
        captureConditions: BeachConditions,
        derivedTags: [String],
        summary: String?,
        author: String?,
        createdAt: Date
    ) {
        self.id = id
        self.beachId = beachId
        self.photoUrl = photoUrl
        self.caption = caption
        self.captureConditions = captureConditions
        self.derivedTags = derivedTags
        self.summary = summary
        self.author = author
        self.createdAt = createdAt
    }

    /// Editorial-pair invariant, lifted from the web substrate's `validatePost`:
    /// `summary` and `author` are both `nil` or both populated, and non-empty when populated.
    ///
    /// (Coordinate-range validation, which the web carried here, moves to the resolver's input
    /// domain — native `SpottedPost` stores no coordinates under the D1 shape.)
    public func validate() throws {
        let summaryNil = summary == nil
        let authorNil = author == nil
        if summaryNil != authorNil {
            throw PostValidationError.editorialPairMismatch
        }
        if summary == "" || author == "" {
            throw PostValidationError.emptyEditorialField
        }
    }
}

public enum PostValidationError: Error, Equatable, Sendable {
    /// One of `summary`/`author` is populated while the other is nil.
    case editorialPairMismatch
    /// `summary` or `author` is populated but empty.
    case emptyEditorialField
}
