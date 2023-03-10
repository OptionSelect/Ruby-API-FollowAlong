class BookRepresenter
  def initialize(book)
    @book = book
  end

  def as_json 
    {
      id: book.id,
      title: book.title,
      author_full_name: author_full_name(book),
      author_age: book.author.age,
    }
  end

  private 

  attr_reader :book

  def author_full_name(book)
    "#{book.author.first_name} #{book.author.last_name}"
  end
end
