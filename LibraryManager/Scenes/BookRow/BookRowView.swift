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
                Color.clear
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        isShowingDetailsView.toggle()
                    }
                HStack(spacing: 4) {
                    VStack(alignment: .leading) {
                        Text(viewStore.title)
                            .foregroundStyle(ColorBook.primary9)
                            .font(.system(size: 16, weight: .bold))
                        Text(viewStore.author)
                            .foregroundStyle(ColorBook.primary9)
                            .font(.system(size: 16, weight: .regular))
                    }
                    Spacer()
                    if viewStore.isRead {
                        VStack {
                            Image(systemName: "checkmark.circle")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(ColorBook.primary9)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 22, height: 22)
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
            .contentShape(Rectangle())
            .onTapGesture {
                isShowingDetailsView.toggle()
            }
            .listRowSeparator(.hidden)
            .listRowBackground(ColorBook.primary3)
        }
    }
    
    // MARK: Swipe Actions Views
    private struct librarySwipeActions: View {
        @ObservedObject var viewStore: ViewStoreOf<BookRowReducer>
        
        var body: some View {
            Button(
                action: { viewStore.send(.didTapQueueSwipe) },
                label: {
                    Image(systemName: "book")
                }
            )
                .tint(ColorBook.primary5)
            Button(
                action: { viewStore.send(.didTapRemoveFromLibrary) },
                label: {
                    Image(systemName: "books.vertical")
                }
            )
                .tint(ColorBook.primary7)
        }
    }
    
    private struct wishlistSwipeActions: View {
        @ObservedObject var viewStore: ViewStoreOf<BookRowReducer>
        
        var body: some View {
            Button(
                action: { viewStore.send(.didTapAddToLibrarySwipe) },
                label: {
                    Image(systemName: "books.vertical")
                }
            )
                .tint(ColorBook.primary5)
            Button(
                action: { viewStore.send(.didTapRemoveFromWishlist) },
                label: {
                    Image(systemName: "suit.heart")
                }
            )
                .tint(ColorBook.primary7)
        }
    }
    
    private struct queueSwipeActions: View {
        @ObservedObject var viewStore: ViewStoreOf<BookRowReducer>
        
        var body: some View {
            Button(
                action: { viewStore.send(.didTapHaveReadSwipe) },
                label: {
                    Image(systemName: "checkmark.circle")
                }
            )
                .tint(ColorBook.primary5)
            Button(
                action: { viewStore.send(.didTapRemoveFromQueue) },
                label: {
                    Image(systemName: "book.closed")
                }
            )
                .tint(ColorBook.primary7)
        }
    }
}

// MARK: - Preview
struct BookRowView_Previews: PreviewProvider {
    static var previews: some View {
        BookRowView(store: Store(initialState: BookRowReducer.State.mock(), reducer: BookRowReducer()), fromSegment: .library)
    }
}
