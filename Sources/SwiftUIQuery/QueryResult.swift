import Foundation

@available(iOS 14.0, macOS 11.0, macCatalyst 14.0, tvOS 14.0, watchOS 7.0, *)
@MainActor public struct QueryResult<T: Decodable> {

  public var isLoading: Bool {
    obserable.isLoading
  }

  public var data: T? {
    obserable.data
  }

  public var error: Error? {
    get {
      obserable.error
    }
    nonmutating set {
      obserable.error = newValue
    }
  }

  public var request: URLRequest {
    get {
      obserable.request
    }
    nonmutating set {
      obserable.request = newValue
    }
  }

  internal let obserable: QueryObservable<T>

  internal init(obserable: QueryObservable<T>) {
    self.obserable = obserable
  }

  public func refetch() async {
    obserable.shouldPerformRequest = true
    await obserable.performRequest()
  }
}
