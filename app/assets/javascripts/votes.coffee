$ ->
  $('.voting').on 'ajax:success', (e) ->
    response = e.detail[0]

    votable = $("#{response.selector}")
    votable.find(".vote-count").html(response.rating)
