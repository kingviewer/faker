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

  def level1
    gen_result(1)
  end

  def level2
    gen_result(2)
  end

  def level3
    gen_result(3)
  end

  def level4
    gen_result(4)
  end

  def level5
    gen_result(5)
  end

  def level6
    gen_result(6)
  end

  private

  def gen_result(i)
    render json: HEROES[i - 1], status: :ok
  end
end
