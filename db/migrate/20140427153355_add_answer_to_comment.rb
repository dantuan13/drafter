class AddAnswerToComment < ActiveRecord::Migration
  def change
    add_column :comments, :answer, :integer
  end
end
