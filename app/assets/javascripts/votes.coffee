$ ->
  $('.voting').on 'ajax:success', (e) ->
    response = e.detail[0]

    if response.type == 'Question'
      votable = $("#question-info")
    else if response.type == 'Answer'
      votable = $("#answer#{response.id}")

    votable.find(".vote-count").html(response.rating)
