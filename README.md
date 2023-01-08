# SwiftUIQuery

**Under heavy development!**

A SwiftUI way to fetch remote data - inspired by CoreData `@FetchRequest` property wrapper

### Platforms

```swift
  [.iOS(.v14), .macOS(.v11), .macCatalyst(.v14), .tvOS(.v14), .watchOS(.v7)]
```

## Usage

```swift
import SwiftUI
import SwiftUIQuery

struct ExampleView: View {
  @Query(request: URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/todos")!))
  private var result: QueryResult<[Todo]>

  var body: some View {
    List {
      if let todos = result.data {
        ForEach(todos) { todo in
          Text(todo.title)
        }
      }
    }
    .refreshable {
      // Integrate with .refreshable modifier easily
      await result.refetch()
    }
  }
}
```

### Stub/Mock Query for SwiftUI Preview

In `Preview Content` group, create new file e.g. `PreviewQueryClient` and confirm to a `QueryClient` protocol:

```swift
import SwiftUIQuery

final class PreviewQueryClient: QueryClient {
  // QueryClient required only one method
  func query<Result>(_ request: URLRequest) async throws -> Result where Result: Decodable {
    return [
      Todo(userId: 1, id: 1, title: "First todo", completed: false),
      Todo(userId: 1, id: 2, title: "Second todo", completed: true)
    ]
  }
}

```

In preview section of your view, modify `queryClient` EnvironmentKey:

```swift
struct ExampleView_Previews: PreviewProvider {
  static var previews: some View {
    ExampleView()
      .environment(\.queryClient, PreviewQueryClient())
}
```

...and now previews don't call network!

### Custom QueryClient

You can change default implementation for `QueryClient` for whole View Hierarchy:

```swift
import SwiftUI

@main
struct SwiftUIQueryExampleApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.queryClient, CustomQueryClient())
    }
  }
}
```

... or a specific view:

```swift
struct ExampleView: View {
  var body: some View {
    TodosView()
      .environment(\.queryClient, TodosQueryClient())
  }
}
```

### Using QueryClient in View

You can access to Environment QueryClient and process URLRequest outside of `@Query` property e.g. mutations

```swift
import SwiftUI
import SwiftUIQuery

struct ExampleView: View {
  @Environment(\.queryClient) private var queryClient

  @Query(request: URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/todos")!))
  private var result: QueryResult<[Todo]>

  @State private var successed = false

  var body: some View {
    List {
      // ...
    }.toolbar {
      ToolbarItem {
        Button("New Todo", action: createTodo)
      }
    }
  }

  private func createTodo() {
    let request: URLRequest = {
      // Create and configure request to send mutation e.g. change httpMethod etc.
    }()

    Task {
      do {
        try await queryClient.query(request)
        successed = true
        
        // You can refresh query here:
        // await result.refetch()
        
      } catch {
        // ... handle request error
      }
    }
  }
}
``` 

## Installation

### Swift Package Manager

To integrate using Apple's [Swift Package Manager](https://swift.org/package-manager/), add the following as a dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/kubens/SwiftUIQuery.git", from: "0.1.0")
]
```

Or navigate to your Xcode project then select `Swift Packages`, click the “+” icon and search for `SwiftUIQuery`.

## Todo

- [ ] Tests!
- [ ] Better documentation
- [ ] Mutation property wrapper
