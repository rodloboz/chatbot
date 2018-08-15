include Facebook::Messenger

APP_URL = 'https://1b3136f7.ngrok.io'

Bot.on :message do |message|
  message.typing_on

  user = User.find_by_sender_id message.sender["id"]
  if user
    event = user.events.active.first

    if event
      message.typing_off

      # are there attachments?
      # message.attachments.any?
      # save attachments

      Log.create(content: message.text, event: event) if event
    else
      message.reply(text: "Could not find any active event. Please visit our website!")
    end

  else
    message.reply(text: "We have not been able to locate you in our system")
    message.reply(text: "In order to get started, please login first")
    send_account_link_button
  end
end

Bot.on :account_linking do |account_link|
  user = User.find_by_authentication_token account_link.authorization_code
  if user
    user.sender_id = account_link.messaging["sender"]["id"]
    user.save
  end
end

Bot.on :postback do |postback|
  regex = /(?<action>START|CANCEL)_(?<type>EVENT)_(?<id>\d+)/
  lookup = postback.payload.match(regex)

  if lookup[:type] == 'EVENT'
    event = Event.find(lookup[:id])

    if lookup[:action] == 'START'
      event.update_attributes(state: :active)
    elsif lookup[:action] == 'CANCEL'
      event.update_attributes(state: :cancelled)
    end
  end
end

def send_account_link_button
  message.reply(
    attachment: {
      type: 'template',
      payload: {
        template_type: 'button',
        text: 'Login!',
        buttons: [
          {
            type: 'account_link',
            url: APP_URL
          },
        ]
      }
    }
  )
end

