defmodule App.Commands do
  use App.Router
  use App.Commander

  command ["start", "restart"] do
    # Logger module injected from App.Commander
    Logger.log(:info, "Command /start or /restart")

    State.clear(get_chat_id())

    {:ok, _} =
      send_message("Введите фамилию для поиска:",
        # Nadia.Model is aliased from App.Commander
        #
        # See also: https://hexdocs.pm/nadia/Nadia.Model.InlineKeyboardMarkup.html
        reply_markup: %Model.ForceReply{
          force_reply: true
        }
      )
  end

  # The `message` macro must come at the end since it matches anything.
  # You may use it as a fallback.
  message do
    id = get_chat_id()

    {message, opts} = case State.get(id).stage do
      "started" -> App.Actions.search(id, update.message.text)
      "found" -> App.Actions.wanna_add_new_fields
      "not_found" -> App.Actions.wanna_add_person
      _ -> Logger.log(:error, "Did not match stage"); ""
    end

    Logger.warn(message)
    send_message(message, opts)
  end



end
