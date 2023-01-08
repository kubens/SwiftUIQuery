import SwiftUI

@available(iOS 14.0, macOS 11.0, macCatalyst 14.0, tvOS 14.0, watchOS 7.0, *)
@propertyWrapper @MainActor public struct Query<Result: Decodable> {
  @Environment(\.queryClient) private var client
  @StateObject private var queryObservable: QueryObservable<Result>

  /// The results of the query.
  ///
  /// This property returns QueryResult struct
  public var wrappedValue: QueryResult<Result> {
    QueryResult(obserable: queryObservable)
  }

  public init(request: URLRequest) {
    _queryObservable = StateObject(wrappedValue: .init(request: request))
  }
}

extension Query: DynamicProperty {
  public func update() {
    if queryObservable.client == nil {
      queryObservable.client = client
    }

    queryObservable.update()
  }
}
