class Status < ActiveHash::Base
  self.data = [
    { id: 1 , name: "契約中"},
    { id: 2 , name: "契約終了"},
    { id: 3 , name: "契約予定"}
  ]
end
