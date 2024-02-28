//
//  BookRowView.swift
//  LibraryManager
//
//  Created by Nata Khurtsidze on 29.02.24.
//

import ComposableArchitecture
import SwiftUI


// MARK: - Book Row View
struct BookRowView: View {
    let store: StoreOf<BookRowReducer>
    @State var isShowingDetailsView: Bool = false
    var fromSegment: BookSegment
    
    // MARK: Book Row View
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Color.white
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        isShowingDetailsView.toggle()
                    }
                HStack(spacing: 4) {
                    VStack(alignment: .leading) {
                        Text(viewStore.title)
                            .font(.headline)
                        Text(viewStore.author)
                            .font(.subheadline)
                    }
                    Spacer()
                    if viewStore.isRead {
                        VStack {
                            Image(systemName: "checkmark")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.green.opacity(0.8))
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18)
                        }
                        .frame(alignment: .trailing)
                    }
                    NavigationLink("", value: "")
                        .navigationDestination(isPresented: $isShowingDetailsView) {
                            BookDetailsView(
                                viewStore: ViewStore(
                                    store.scope(
                                        state: \.bookDetails,
                                        action: BookRowReducer.Action.bookDetails
                                    )
                                ),
                                fromSegment: fromSegment
                            )
                        }
                        .frame(width: 0, height: 0)
                        .hidden()
                }
            }
            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                switch fromSegment {
                case .library:
                    librarySwipeActions(viewStore: viewStore)
                case .wishlist:
                    wishlistSwipeActions(viewStore: viewStore)
                case .queue:
                    queueSwipeActions(viewStore: viewStore)
                }
            }
            .onTapGesture {
                isShowingDetailsView.toggle()
            }
            .background(.clear)
            .listRowSeparator(.hidden)
        }
    }
    
    // MARK: Swipe Actions Views
    private struct librarySwipeActions: View {
        @ObservedObject var viewStore: ViewStoreOf<BookRowReducer>
        
        var body: some View {
            Button("📖") {
                viewStore.send(.didTapQueueSwipe)
            }.tint(viewStore.wantsToRead ? .red : .green)
            Button("📚") {
                viewStore.send(.didTapRemoveFromLibrary)
            }.tint(.red)
        }
    }
    
    private struct wishlistSwipeActions: View {
        @ObservedObject var viewStore: ViewStoreOf<BookRowReducer>
        
        var body: some View {
            Button("📚") {
                viewStore.send(.didTapAddToLibrarySwipe)
            }.tint(.green)
            Button("🛍") {
                viewStore.send(.didTapRemoveFromWishlist)
            }.tint(.red)
        }
    }
    
    private struct queueSwipeActions: View {
        @ObservedObject var viewStore: ViewStoreOf<BookRowReducer>
        
        var body: some View {
            Button("✔️") {
                viewStore.send(.didTapHaveReadSwipe)
            }.tint(.green)
            Button("📖") {
                viewStore.send(.didTapRemoveFromQueue)
            }.tint(.red)
        }
    }
}

// MARK: - Preview
struct BookRowView_Previews: PreviewProvider {
    static var previews: some View {
        BookRowView(store: Store(initialState: BookRowReducer.State.mock(), reducer: BookRowReducer()), fromSegment: .library)
    }
}
