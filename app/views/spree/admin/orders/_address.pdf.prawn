# Address Stuff

bill_address = @order.bill_address
ship_address = @order.ship_address
shipping_method = (@shipment || @order.shipments.first).try(:shipping_method)
anonymous = @order.email =~ /@example.net$/


def address_info(address)
  info = %Q{
    #{address.first_name} #{address.last_name}
    #{address.address1}
  }
  info += "#{address.address2}\n" if address.address2.present?
  state = address.state ? address.state.abbr : ""
  info += "#{address.zipcode} #{address.city} #{state}\n"
  info += "#{address.country.name}\n"
  # info += "#{address.phone}\n"
  info.strip
end


data = [
  [Spree.t(:billing_address), Spree.t(:shipping_address)], 
  [address_info(bill_address), address_info(ship_address) + (shipping_method.present? ? "\n\nvia #{shipping_method.name}" : '')]
]

if @order.user.present?
  move_down 60
  font @font_face, :size => 11, :style => :bold
  text "Packing Slip for #{@order.user.name}", :align => :left
  move_down 5
else
  move_down 75
end

font @font_face, :size => 9

table(data, :width => 495) do
  row(0).font_style = :bold

  # Billing address header
  row(0).column(0).borders = [:top, :right, :bottom, :left]
  row(0).column(0).border_widths = [0.5, 0, 0.5, 0.5]

  # Shipping address header
  row(0).column(1).borders = [:top, :right, :bottom, :left]
  row(0).column(1).border_widths = [0.5, 0.5, 0.5, 0]

  # Bill address information
  row(1).column(0).borders = [:top, :right, :bottom, :left]
  row(1).column(0).border_widths = [0.5, 0, 0.5, 0.5]

  # Ship address information
  row(1).column(1).borders = [:top, :right, :bottom, :left]
  row(1).column(1).border_widths = [0.5, 0.5, 0.5, 0]

end
