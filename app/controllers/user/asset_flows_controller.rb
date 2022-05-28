class User::AssetFlowsController < User::BaseController
  def list
    data = []
    if cur_user
      cur_user.asset_flows.limit(params[:limit].to_i).offset(params[:limit].to_i * params[:page].to_i)
              .order(id: :desc).each do |flow|
        data << {
          id: flow.id,
          formatted_amount: "#{'+' if flow.amount >= 0}#{LZUtils.format_number(flow.amount, 8)}",
          flow_type_name: flow.flow_type_name,
          created_at: flow.formatted_created_at,
          color: flow.amount >= 0 ? 'green' : 'red'
        }
      end
    end
    success(data)
  end
end
