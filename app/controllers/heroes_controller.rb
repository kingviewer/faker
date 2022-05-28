class HeroesController < ApplicationController
  HEROES = [
    {
      name: 'White Unicorns',
      description: 'White Unicorns',
      image: "#{Utils::Constants::BASE_URI}nft_img/1.jpg"
    }, {
      name: 'Yellow Unicorns',
      description: 'Yellow Unicorns',
      image: "#{Utils::Constants::BASE_URI}nft_img/2.jpg"
    }, {
      name: 'Coffee Unicorns',
      description: 'Coffee Unicorns',
      image: "#{Utils::Constants::BASE_URI}nft_img/3.jpg"
    }, {
      name: 'Pink Unicorns',
      description: 'Pink Unicorns',
      image: "#{Utils::Constants::BASE_URI}nft_img/4.jpg"
    }, {
      name: 'Black Unicorns',
      description: 'Black Unicorns',
      image: "#{Utils::Constants::BASE_URI}nft_img/5.jpg"
    }, {
      name: 'Silver Unicorns',
      description: 'Silver Unicorns',
      image: "#{Utils::Constants::BASE_URI}nft_img/6.jpg"
    }
  ]

  private

  def method_missing(symbol, *args)
    super
    if symbol =~ /^level(\d)$/
      render json: HEROES[$1.to_i - 1], status: :ok
    end
  end
end
