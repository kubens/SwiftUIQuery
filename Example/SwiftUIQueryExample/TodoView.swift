import SwiftUI

struct TodoView: View {
  let todo: Todo

  var body: some View {
    Label(todo.title, systemImage: todo.completed ? "checkmark.circle.fill" : "circle")
  }
}

struct TodoView_Previews: PreviewProvider {
  static var previews: some View {
    TodoView(todo: .init(userId: 1, id: 1, title: "Lorem ispum dolor", completed: false))
  }
}
