class ContractStatus < ActiveHash::Base
  self.data = [
    { id: 1, name: '契約中' },
    { id: 2, name: '待機中' },
    { id: 3, name: '入社前' },
    { id: 4, name: '退職済'}
  ]
end
