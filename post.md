Hello! 😄 

It's been [a while](https://github.com/rrousselGit/riverpod/issues/3285) since I've tried to tackle this problem, and since then [I've recently updated](https://github.com/rrousselGit/riverpod/issues/3285#issuecomment-2415173986) with the same question as you guys.
**I want to share a workaround that doesn't involve using a repository**, if it can help anyone.
It revolves around a few reasonable assumptions, so, here's the problem statement again:

> _An app shows a list of `Book`s in its home page, but also allows me to search for a `Book` in a search page. Then again, each book has its detail page. Finally, there's a Library page, showing different libraries, each with their list view of `Book`s. Every list mentioned above is paginated._

> Here's the twist: **every book is likeable**, aka all entities here share this common property.
How can I properly keep track of a book's `bool isFavorite` property, in every different page?
A typical user flow is, e.g., a book is liked in the library page; pressing "back", the home shows this book's favorite state updated accordingly.

> **Here's an additional twist**, regarding our source of truth: While the user navigates the app, _state changes might occur in other places_ as the navigation occurs (e.g. in a separate web app). So to optimize for our user's experience we need to implement a "WYSIWYG" approach, in which, the latest state received from our server is "the truth".

First, it's best to recognize that this is quite a hard problem. We're exploring boundaries that most client-side applications get wrong, even popular ones.
My objective is to find a solution that fits Riverpod's one-way data binding model.

Because of this, I'd definitively advise _against_ a repository, because:
1. Clearly, it's just a workaround - or rather, it's a solution to a x-y problem
2. It's a design flaw: don't build a repository just so you can build our state management around it, you'd obtain a quite obvious leaky interface, even if it sounds nice on paper
3. We're re-implementing what Riverpod is supposed to do  (the caching part especially, considering Riverpod is on its way to support offline mode), assuming you're suggesting your repository should save a local cache whenever new data is received from our network (e.g. with sqlite)
4. We're adding another layer of indirection, which is usually useless, but it's even harmful in this case: we cannot really afford to hide away the decision of hitting the local db VS hitting a network request, because (again) this eventually collides with what Riverpod tries to do
5. Following this path is totally doable, but it's quite easy to mess it up; it's quite easy to hit the network "too much", i.e. fill our server with useless requests

Ok, so, here's how I'd solve this.

1. We define our "sharing state" family providers, e.g.: `homeBooks(int page)`, `searchBooks(int page)`, `libraryBooks(int libraryId, int page)`, `bookDetails(int bookId)`
2. We define a `FavoritedBooksNotifier`, with `Map<int, Book> build()`and `void override(Book book)`
3. We define `bool isFavorited(int bookId)` as follows:

```dart
```

I'm pretty sure Remi has a smarter solution hiding with Riverpod 3. Anyways, once the solution is clear and shared, I'm all in for submitting a documentation PR about this, whenever.