import Foundation

struct Todo: Identifiable, Decodable {
  let userId: Int
  let id: Int
  let title: String
  let completed: Bool
}

extension Todo {

  static var all: URLRequest {
    let url = URL(string: "https://jsonplaceholder.typicode.com/todos")!
    let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
    return request
  }

  static func get(id: Todo.ID) -> URLRequest {
    let url = URL(string: "https://jsonplaceholder.typicode.com/todos/\(id)")!
    let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
    return request
  }

  static func get(userId: Int) -> URLRequest {
    let url = URL(string: "https://jsonplaceholder.typicode.com/users/\(userId)/todos")!
    let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
    return request
  }
}
