class User < ApplicationRecord
  has_many :asset_flows

  def sync_usdt
    update(usdt_balance: block_usdt_balance)
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
end
