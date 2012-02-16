# encoding: UTF-8

ActiveRecord::Schema.define do 
  self.verbose = false

  create_table :purchases, :force => true do |t|
    t.string :name
    t.decimal :amount
    t.timestamps
  end
end
