# Address Stuff

ship_address = @order.ship_address
shipment = (@shipment || @order.shipments.first)
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
  info.strip
end

# text address_info(ship_address)
font @font_face, :size => 9
text "Ship To:"
