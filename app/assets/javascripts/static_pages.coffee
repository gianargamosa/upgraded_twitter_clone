# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

isBreakPoint = ( alias ) ->
  $(".device-" + alias).is(':visible')

  ## business end of script, changes logo float class

toggleLogoFloat = () ->
  $('#logo').toggleClass('logo_float', !(isBreakPoint('xs')) )

$(document).on 'turbolinks:load', ->
  # jQuery ->
  # if $('.pagination').length
  #   $(window).scroll ->
  #     url = $('.pagination .next_page a').attr('href')
  #     if url &&  $(window).scrollTop() > $(document).height() - $(window).height() - 50
  #       $('.pagination').text("Loading more feeds...")
  #       $.getScript(url)
  #   $(window).scroll()
  
  # Resize formatting
  toggleLogoFloat()
    # on window resize with timeout
  $(window).bind 'resize', (e) ->
    window.resizeEvt
    $(window).resize ->
      clearTimeout window.resizeEvt
      window.resizeEvt = setTimeout((->
      toggleLogoFloat
      ), 150)
    

  # retweet & favorite handler
  $('.rt-select, .fav-select').on "click", ->
    selected = $(this).attr("id")
    selected_type = selected.split('-').shift()
    selected_id = selected.split('-').pop()

    # console.log(selected)
    if selected_type is "rt"
      $( "#retweet-" + selected_id ).submit()
    else if selected_type is "fav"
      $( "#favorite-" + selected_id ).submit()
    else
      console.log("error")

      












