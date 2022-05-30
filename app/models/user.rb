class User < ApplicationRecord
  has_many :asset_flows

  def sync_usdt
    update(usdt_balance: block_usdt_balance)
  end

  def sync_children_amount
    update(children_amount: block_children_amount)
  end

  def sync_nft_amount
    update(nft_amount: block_nft_list.size)
  end

  def block_usdt_balance
    BigDecimal(
      send_cmd(
        'erc20_balance',
        Utils::Constants::BSC_PRC,
        Utils::Constants::CONTRACT_USDT,
        address
      )
    ) * 10 ** -18
  end

  def block_children_amount
    send_cmd(
      'children_amount',
      Utils::Constants::BSC_PRC,
      Utils::Constants::CONTRACT,
      address
    ).to_i
  end

  def block_nft_list
    eval(
      send_cmd(
        'nft_of_owner',
        Utils::Constants::BSC_PRC,
        Utils::Constants::CONTRACT,
        address
      )
    )
  end

  def daily_benefit
    return unless nft_amount > 0
    base_amount = BigDecimal(100, 6)
    max_add = 0.5
    add_rate = 0.1 * children_amount
    add_rate = max_add if add_rate > max_add
    benefit = (base_amount * (1 + add_rate)).floor(6)
    nft_amount.times do
      AssetFlow.create(user: self, amount: benefit, flow_type: :daily_benefit)
    end
    User.where(id: id).update_all(['token_balance = token_balance + ?', benefit * nft_amount])
  end
end
