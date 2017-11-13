FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "My Title#{n}" }
    sequence(:body) { |n| "My Body#{n}" }
    best_answer_id nil
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
