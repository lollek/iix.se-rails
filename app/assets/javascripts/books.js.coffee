# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
Book = ($resource) ->
    $resource(
      '/api/books/:id',
      {id: '@_id'},
      {update: {method: 'PUT'}}
    )

Book
    .$inject = ['$resource']

BooksController = (Book) ->

    init = () =>
        @reset_book = reset_book
        @save_book = save_book
        @delete_book = delete_book
        @add_row = add_row

        @books = Book.query()
        return

    reset_book = (index, id) =>
        @books[index] = Book.get({id:id})
        return

    save_book = (index, id) =>
        if id
            @books[index] = Book.update({id: id}, @books[index])
        else
            @books[index] = Book.save(@books[index])
        return

    delete_book = (index, id) =>
        if id
            Book.delete({id: id},
              () => @books.splice(index, 1),
              @show_error)
        else
            @books.splice(index, 1)
        return

    add_row = () =>
        @books.push(new Book())
        return

    init()
    return

BooksController
    .$inject = ['Book']

angular
    .module('mainApp')
    .factory('Book', Book)
    .controller('BooksController', BooksController)
