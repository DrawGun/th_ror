# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('body').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault()

    $(this).hide()
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).removeClass('d-none')
    $('#answer' + answer_id + ' .answer-body').addClass('d-none')
