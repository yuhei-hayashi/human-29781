class Genre < ActiveHash::Base
  self.data = [
    { id: 1, name: '機械' },
    { id: 2, name: '電気' },
    { id: 3, name: 'IT' },
    { id: 4, name: '化学' }
  ]
  end
