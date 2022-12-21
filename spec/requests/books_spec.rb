require 'rails_helper'

describe 'Books API', type: :request do
  let(:first_author) { FactoryBot.create(:author, first_name: 'William', last_name: 'Gibson', age: 70) }
  let(:second_author) { FactoryBot.create(:author, first_name: 'Neal', last_name: 'Stephenson', age: 60) }
  describe 'GET /books' do

    before do
      FactoryBot.create(:book, title: 'Neuromancer', author: first_author)
      FactoryBot.create(:book, title: 'Snow Crash', author: second_author)
    end

    it 'returns all books' do
      get '/api/v1/books'
  
      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(2)
      expect(response_body).to eq([{
        'id' => 1,
        'title' => 'Neuromancer',
        'author_full_name' => 'William Gibson',
        'author_age' => 70,
      },
      {
          'id' => 2,
          'title' => 'Snow Crash',
          'author_full_name' => 'Neal Stephenson',
          'author_age' => 60,
      }])
    end
  end

  describe 'POST /books' do
    it 'creates a book' do
      expect{
        post '/api/v1/books', params: { 
          book: { title: 'The Martian'},
          author: { first_name: 'Andy', last_name: 'Weir', age: 48 }
        }
      }.to change { Book.count }.from(0).to(1)

      expect(response).to have_http_status(:created)
      expect(Author.count).to eq(1)
      expect(response_body).to eq({
        'id' => 1,
        'title' => 'The Martian',
        'author_full_name' => 'Andy Weir',
        'author_age' => 48,
      })
    end
  end

  describe 'DELETE /books/:id' do
    let!(:book) { FactoryBot.create(:book, title: 'The Great Gatsby', author: first_author) }
    
    it 'deletes a book' do

      expect{
        delete "/api/v1/books/#{book.id}"
      }.to change { Book.count }.from(1).to(0)

      expect(response).to have_http_status(:no_content)
    end
  end
end