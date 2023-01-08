import SwiftUI

@MainActor internal final class QueryObservable<T: Decodable>: ObservableObject {
  @Published internal private(set) var isLoading: Bool
  @Published internal private(set) var data: T?
  @Published internal var error: Error?

  /// `QueryClient` from SwiftUI Environment
  internal var client: (any QueryClient)?

  // prevent never-ending update cycle when updating view
  internal var shouldPerformRequest: Bool

  internal var request: URLRequest {
    willSet {
      if newValue != request {
        shouldPerformRequest = true
        objectWillChange.send()
      }
    }
  }

  init(request: URLRequest, isLoading: Bool = true, shouldPerformRequest: Bool = true) {
    self.request = request
    self.isLoading = isLoading
    self.shouldPerformRequest = shouldPerformRequest
  }

  // Handle update from DynamicProperty update cycle
  internal func update() {
    if shouldPerformRequest {
      Task { await performRequest() }
    }
  }

  /// Perform request usign `QueryClient`
  internal func performRequest() async {
    guard shouldPerformRequest, let client = client else { return }

    defer { isLoading = false }
    if !isLoading { isLoading = true }

    shouldPerformRequest = false

    do {
      data = try await client.query(request)
    } catch {
      self.error = error
    }
  }
}
