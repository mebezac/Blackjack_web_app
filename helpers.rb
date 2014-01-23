helpers do
  def if_user(erb_name)
    if session[:player_name]
      erb :"#{erb_name}"
    else
      redirect '/new_player'
    end
  end

  def deck_builder
      suits = ["Clubs", "Spades", "Diamonds", "Hearts"]
      cards = ["Ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King"]
      deck = cards.product(suits).shuffle!
      deck
  end

  def deal(deck, num)
    deck.pop(num)
  end

  def card_value (card)
    card_values_hash = {"Ace" => 1, "2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, "7" => 7, "8" => 8, "9" => 9, "10" => 10, "Jack" => 10, "Queen" => 10, "King" => 10}
    card_values_hash[card[0]]
  end

  def hand_value (hand)
    value = 0
    hand.each do |card| 
    value += card_value card
    end

    cards = []
    hand_has_ace = false
    hand.each do |card|
      cards.push card[0]
    end
    if cards.include? "Ace"
      hand_has_ace = true
    else
      hand_has_ace = false
    end

    if hand_has_ace && (value + 10) <= 21
      value += 10
      return value
    else
      return value
    end
  end

  def player_bust_or_blackjack
    if hand_value(session[:player_hand]) == 21
      session[:reason] = "You got a Blackjack!"
      session[:winner] = "player"
      win_or_lose
    elsif hand_value(session[:player_hand]) > 21
      session[:reason] = "You Busted"
      session[:winner] = "dealer"
      win_or_lose
    else
      session[:show_hit_or_stay] = true
      erb :game
    end
  end

  def player_hit
    session[:player_hand] += deal(session[:deck], 1)
    player_bust_or_blackjack
  end

  def dealer_choice
    if hand_value(session[:dealer_hand]) == 21
      session[:winner] = "dealer"
      session[:reason] = "The Dealer hit Blackjack"
      session[:show_dealer_options] = false
      win_or_lose
    elsif hand_value(session[:dealer_hand]) > 21
      session[:winner] = "player"
      session[:reason] = "The Dealer busted!"
      session[:show_dealer_options] = false
      win_or_lose
    elsif hand_value(session[:dealer_hand]) < 21 && hand_value(session[:dealer_hand]) >= 17
      @show_dealer_options = false
      compare
    elsif hand_value(session[:dealer_hand]) < 17
      @show_dealer_options = true
      erb :game
    end
    
  end

  def dealer_hit
    session[:dealer_hand] += deal(session[:deck], 1)
    dealer_choice
  end

  def card_image(card)
    value = card[0].downcase
    suit = card[1].downcase
    "<img class='card' src='/images/cards/#{suit}_#{value}.jpg' />"
  end

  def hand_image(hand)
    hand.each do |card|
      card_image(card)
    end
  end

  def compare
    if hand_value(session[:player_hand]) > hand_value(session[:dealer_hand])
      session[:winner] = "player"
    else
      session[:winner] = "dealer"
    end
    session[:reason] = "You had #{hand_value(session[:player_hand])} and the dealer had #{hand_value(session[:dealer_hand])}"
    win_or_lose
  end

  def win_or_lose
    session[:show_hit_or_stay] = false
    if session[:winner] == 'player'
      session[:player_money] = session[:player_money].to_i + session[:bet].to_i
      session[:win_lose_message] = "<p class='winmsg pull-left'>Congratulations #{session[:player_name]}! #{session[:reason]} You won!</p>"
    elsif session[:winner] == 'dealer'
      session[:player_money] = session[:player_money].to_i - session[:bet].to_i
      session[:win_lose_message] = "<p class='winmsg pull-left'>Sorry #{session[:player_name]}. #{session[:reason]} You lost.</p>"
    end
    session[:bet] = 0
    session[:round_over] = true
    erb :game
  end

end