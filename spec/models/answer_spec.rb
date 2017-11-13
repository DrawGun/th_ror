require 'rails_helper'

describe Answer do
  it { should belong_to(:question).inverse_of(:answers) }
  it { should belong_to(:user).inverse_of(:answers) }
  it { should have_one(:resolved_question).inverse_of(:best_answer).class_name('Question').with_foreign_key('best_answer_id') }

  it { should validate_presence_of(:body) }
end
