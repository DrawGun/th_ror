require 'rails_helper'

describe Question do
  it { should have_many(:answers).inverse_of(:question).dependent(:destroy) }
  it { should belong_to(:best_answer).inverse_of(:resolved_question).class_name('Answer').with_foreign_key('best_answer_id') }
  it { should belong_to(:user).inverse_of(:questions) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
end
