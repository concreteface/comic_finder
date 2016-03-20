module Order
  def order(params)
    if params[:issue] == 'on'
      order_by = :title
    elsif params[:publisher] == 'on'
      order_by = :publisher
    end
    order_by
  end
end
