import Foundation
import SwiftUIQuery

/// Always failing `QueryClient`
final class ThrowingPreviewQueryClient: QueryClient {
  func query<Result>(_ request: URLRequest) async throws -> Result where Result : Decodable {
    throw URLError(.badServerResponse)
  }
}
