class EventReminderJob < ApplicationJob
  include Facebook::Messenger

  queue_as :bot

  def perform(event_id)
    event = Event.find(event_id)
    user = event.user

    Bot.deliver({
      recipient: {
        id: user.sender_id
      },
      message: {
        attachment: {
          type: 'template',
          payload: {
            template_type: 'button',
            text: "Do you want to start your event #{event.name}?",
            buttons: [
              { type: 'postback', title: 'Start', payload: "START_EVENT_#{event.id}" },
              { type: 'postback', title: 'Cancel', payload: "CANCEL_EVENT_#{event.id}" }
            ]
          }
        }
      },
      message_type: Facebook::Messenger::Bot::MessagingType::MESSAGE_TAG,
      tag: Facebook::Messenger::Bot::Tag::CONFIRMED_EVENT_REMINDER
    }, access_token: ENV['ACCESS_TOKEN'])
  end
end
