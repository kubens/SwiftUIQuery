import SwiftUI

private struct QueryClientKey: EnvironmentKey {
  static let defaultValue: any QueryClient = DefaultQueryClient()
}

extension EnvironmentValues {
  public var queryClient: any QueryClient {
    get { self[QueryClientKey.self] }
    set { self[QueryClientKey.self] = newValue }
  }
}
