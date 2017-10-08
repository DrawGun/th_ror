require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question).inverse_of(:answers) }

  it { should validate_presence_of(:body) }
end
