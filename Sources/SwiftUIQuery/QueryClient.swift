import Foundation

public protocol QueryClient {
  func query<Result>(_ request: URLRequest) async throws -> Result where Result: Decodable
}

public class DefaultQueryClient: QueryClient {
  open var session = URLSession.shared

  open func query<Result>(_ request: URLRequest) async throws -> Result where Result: Decodable {
    let (data, _) = try await session.data(for: request)
    return try JSONDecoder().decode(Result.self, from: data)
  }
}
