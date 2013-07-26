# -*- coding: utf-8 -*-
class SetupSimpleCredit < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.integer :user_id
      t.integer :value, default: 0
      t.integer :highest_value, default: 0
      t.timestamps
    end

    create_table :credit_histories do |t|
      t.integer :user_id
      t.integer :delta
      t.string  :scene
      t.integer :to_id
      t.string  :to_type
      t.string  :what
      t.integer :real   #实际增减
      t.integer :before
      t.integer :after
      t.integer :canceled_id
      t.timestamps
    end
  end
end
