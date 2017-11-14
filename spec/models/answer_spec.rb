require 'rails_helper'

describe Answer do
  it { should belong_to(:question).inverse_of(:answers) }
  it { should belong_to(:user).inverse_of(:answers) }
  it { should validate_presence_of(:body) }

  it 'if set best answer reset old best' do
    user = create(:user)
    question = create(:question, user: user)
    answer1 = create(:answer, question: question, user: user)
    answer2 = create(:answer, question: question, user: user, best: true)
    answer3 = create(:answer, question: question, user: user)

    expect(answer2.best).to be true
    answer1.update(best: true)
    expect(answer2.reload.best).to be false
    expect(answer1.reload.best).to be true
  end
end
