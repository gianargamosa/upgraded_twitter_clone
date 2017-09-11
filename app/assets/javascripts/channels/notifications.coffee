App.notifications = App.cable.subscriptions.create "NotificationsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
  	# debugger
  	console.log(data)
    # Called when there's incoming data on the websocket for this channel
  speak: (message) ->
  	debugger
  	@perform 'speak', content: message
  	# $('#current-user-')

# $(document).on 'keypress', '[data-behavior~=room_speaker]', (event) ->
# 	if event.keyCode is 13 # return/enter = send

# 		App.notifications.speak event.target.value
# 		event.target.value = ''
# 		event.preventDefault()
$(document).on 'submit', '.create-form', (e) ->
  e.preventDefault()
  values = $(this).serializeArray()
  # debugger;
  console.log(values)
  App.notifications.speak values[0]
  $(this).trigger 'reset'
  return