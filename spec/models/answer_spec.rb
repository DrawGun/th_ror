require 'rails_helper'

describe Answer do
  it { should belong_to(:question).inverse_of(:answers) }

  it { should validate_presence_of(:body) }
end
