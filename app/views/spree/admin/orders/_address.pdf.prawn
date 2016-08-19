# Address Stuff

bill_address = @order.bill_address
ship_address = @order.ship_address
shipping_method = (@shipment || @order.shipments.first).try(:shipping_method)
shipping_speed = @shipment.try(:shipping_speed)
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

header_row = []
address_row = []
if bill_address.present?
   header_row.push(Spree.t(:billing_address))
   address_row.push(address_info(bill_address))
end
if ship_address.present?
  header_row.push(Spree.t(:shipping_address))
  via = ''
  if shipping_method.present?
    via = "\n\nvia #{shipping_method.name}"
    if shipping_speed.present?
      color_rgb = shipping_speed.try(:rgb)
      via += "<color rgb='#{color_rgb}'>" if color_rgb.present?
      via += " #{shipping_speed.to_s.titleize}"
      via += '</color>' if color_rgb.present?
    end
  end
  address_row.push(address_info(ship_address) + via)
end
if header_row.present? && header_row.size < 2
  # add an empty address table column for the missing address
  header_row.push('')
  address_row.push('')
end
data = [
  header_row,
  address_row
]

font @font_face, :size => 9

if header_row.present?
 table(data, :width => 540, :cell_style => { :inline_format => true }) do
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
end
