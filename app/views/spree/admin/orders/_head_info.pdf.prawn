font @font_face, :size => 10
fill_color "000000"

text "#{Spree.t(:order_number, :number => @order.number)}", align: :left, style: :bold

text "Placed: #{@order.completed_at.to_date}", :align => :left
text "Shipped: #{I18n.l Date.today}", :align => :left

if @shipment.present?
 text "#{Spree.t(:shipment)}: #{@shipment.number}", align: :left
end

if @order.active_stylist.present? && !@order.active_stylist.corporate?
  text "Stylist: #{@order.active_stylist.name}", align: :left
end
