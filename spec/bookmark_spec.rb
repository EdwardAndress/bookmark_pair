# frozen_string_literal: true

require 'bookmark'
require 'database_helpers'

RSpec.describe Bookmark do
  describe 'class method #all' do
    it 'returns all bookmarks' do
      connection = PG.connect(dbname: 'bookmark_manager_test')

      # Add the test data
      connection.exec("INSERT INTO bookmarks (id, title, url)
        VALUES (1, 'Makers Academy', 'http://www.makersacademy.com');")
      connection.exec("INSERT INTO bookmarks (id, title, url)
        VALUES(2, 'Symantec US', 'http://www.symantec.com');")
      connection.exec("INSERT INTO bookmarks (id, title, url)
        VALUES(3, 'Google UK', 'http://www.google.co.uk');")

      bookmarks = Bookmark.all

      expect(bookmarks.first).to be_an_instance_of(Bookmark)
      expect(bookmarks.first.title).to eq('Makers Academy')
      expect(bookmarks.first.url).to eq('http://www.makersacademy.com')
      expect(bookmarks.first.id).to eq '1'
    end
  end

  describe '#create - using database to verify' do
    it '- adds a bookmark to the database' do
      bookmark = Bookmark.create(url: 'http://www.testbookmark.com', title: 'Test Bookmark')
      persisted_data = persisted_data(id: bookmark.id)

      expect(bookmark).to be_a Bookmark
      expect(bookmark.id).to eq persisted_data['id']
      expect(bookmark.title).to eq 'Test Bookmark'
      expect(bookmark.url).to eq 'http://www.testbookmark.com'
    end
  end
end
