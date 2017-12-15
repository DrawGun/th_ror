$ ->
  $('.voting').on 'ajax:success', (e) ->
    response = e.detail[0]

    votable = $("##{response.resource}#{response.id}")
    votable.find(".vote-count").html(response.rating)
