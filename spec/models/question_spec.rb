require 'rails_helper'

describe Question do
  it { should have_many(:answers).inverse_of(:question).dependent(:destroy) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
end
