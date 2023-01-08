import SwiftUI
import SwiftUIQuery

struct ContentView: View {
  @Query(request: Todo.get(userId: 1)) private var result: QueryResult<[Todo]>
  @State private var selectedUserID: Int = 1

  var body: some View {
    NavigationStack {
      List {
        if let todos = result.data {
          ForEach(todos) { todo in
            TodoView(todo: todo)
          }
        }
      }
      .onChange(of: selectedUserID, perform: { newValue in
        result.request = Todo.get(userId: newValue)
      })
      .overlay(alignment: .top) {
        if let error = result.error {
          Text(error.localizedDescription)
        }
      }
      .refreshable {
        await result.refetch()
      }
      .toolbar {
        ToolbarItem {
          Picker("Pick a UserID", selection: $selectedUserID) {
            Text("UserID: 1").tag(1)
            Text("UserID: 2").tag(2)
          }
        }

        ToolbarItem {
          Menu("Set user") {
            Button("Set User 1") { result.request = Todo.get(userId: 1) }
            Button("Set User 2") { result.request = Todo.get(userId: 2) }
          }
        }

        #if canImport(UIKit)
        ToolbarItemGroup(placement: .bottomBar) {
          Button {
            Task { await result.refetch() }
          } label: {
            Label("Refresh", systemImage: "arrow.clockwise")
          }

          Spacer()

          Group {
            if result.isLoading {
              Text("Refreshing...")
            } else if let count = result.data?.count {
              Text("Total: \(count)")
            }
          }
          .font(.caption)

          Spacer()
        }
        #endif
      }
      .navigationTitle("Todos")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environment(\.queryClient, TodosPreviewQueryClient())
      .previewDisplayName("Succesfull")

    ContentView()
      .environment(\.queryClient, ThrowingPreviewQueryClient())
      .previewDisplayName("Failing")
  }
}
