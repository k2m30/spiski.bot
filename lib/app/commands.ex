defmodule App.Commands do
  use App.Router
  use App.Commander

  command ["start", "restart"] do
    # Logger module injected from App.Commander
    Logger.log(:info, "Command /start or /restart")

    State.clear(get_chat_id())

    {:ok, _} =
      send_message(
        "Введите фамилию для поиска:",
        # Nadia.Model is aliased from App.Commander
        #
        # See also: https://hexdocs.pm/nadia/Nadia.Model.InlineKeyboardMarkup.html
        reply_markup: %Model.ForceReply{
          force_reply: true
        }
      )
  end


  callback_query_command "restart" do
    Logger.log(:info, "Callback Query Command /restart")

    State.clear(get_chat_id())

    {:ok, _} =
      send_message(
        "Введите фамилию для поиска:",
        # Nadia.Model is aliased from App.Commander
        #
        # See also: https://hexdocs.pm/nadia/Nadia.Model.InlineKeyboardMarkup.html
        reply_markup: %Model.ForceReply{
          force_reply: true
        }
      )

  end

  callback_query_command "search" do
    Logger.log(:info, "Callback Query Command /search")
    id = get_chat_id()
    State.update_stage(id, "started")
    state = State.get(id)

    {message, opts} = App.Actions.search(id, state.name)
    send_message(message, opts)
  end




  # The `message` macro must come at the end since it matches anything.
  # You may use it as a fallback.
  message do
    if update.message do
      Logger.warn("New message")
      Logger.warn(update.message.text)

      id = get_chat_id()
      Logger.warn("Chat id")
      Logger.warn(id)

      {message, opts} = case State.get(id).stage do
        "started" -> App.Actions.search(id, update.message.text)
        "found" -> App.Actions.wanna_add_new_fields
        "not_found" -> App.Actions.wanna_add_person
        _ -> Logger.log(:error, "Did not match stage"); {"Выберите доступные варианты", []}
      end

      send_message(message, opts)
    end
  end



end
