require 'prawn/layout'
require 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/prawn_outputter'

render partial: 'repeat'

bounding_box([0, 540], width: 540, height: 460) do
  render :partial => "address"
  render :partial => "line_items_box"
end

move_down 8

# Footer
render :partial => "footer"

move_down 665

text "If you wish to return one of your peach products, please refer to our return policy on the back of this slip first to determine if your product is eligible for a return. If it is, please pop it back into the box it was sent in and use the pre-paid return label found in your box. Once we receive and process the return, we will refund you accordingly. Please allow two weeks for return processing.", :style => :italic 

move_down 4

text("If you would like to exchange an item, please #{@order.has_personal_stylist? ? "connect with your personal stylist, <b>#{@order.stylist.name}</b> at <b>#{@order.stylist.email}</b>" : "email us at <b>returns@peach.company</b>"}", style: :italic, inline_format: true )
