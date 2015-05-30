require 'prawn/layout'



@font_face = Spree::PrintInvoice::Config[:print_invoice_font_face]

font @font_face

# im = Rails.application.assets.find_asset(Spree::PrintInvoice::Config[:print_invoice_logo_path])
# image im , :at => [0,720], :scale => logo_scale

#fill_color "E99323"
if @hide_prices
  text Spree.t(:packaging_slip), :align => :right, :style => :bold, :size => 18
else
  text Spree.t(:customer_invoice), :align => :right, :style => :bold, :size => 18
end
fill_color "000000"

move_down 2

if Spree::PrintInvoice::Config.use_sequential_number? && @order.invoice_number.present? && !@hide_prices

  font @font_face, :size => 9, :style => :bold
  text "#{Spree.t(:invoice_number)} #{@order.invoice_number}", :align => :right

  move_down 2
  font @font_face, :size => 9
 # text "#{Spree.t(:invoice_date)} #{I18n.l @order.invoice_date}", :align => :right
  text "#{Spree.t(:invoice_date)} #{I18n.l Date.today.strftime("%m/%d/%Y")}", :align => :right

else

  move_down 2
  font @font_face, :size => 9, :style => :bold
  text "#{Spree.t(:order_number, :number => @order.number)}", :align => :right

  move_down 2
  font @font_face, :size => 9
  text "Placed: #{@order.completed_at.to_date}", :align => :right
  move_down 2
  text "Shipped: #{I18n.l Date.today}", :align => :right

  require 'barby'
  require 'barby/barcode/code_39'
  require 'barby/outputter/prawn_outputter'

  if @shipment.present?
    move_down 2
    font @font_face, :size => 9
    text "#{Spree.t(:shipment)}: #{@shipment.number}", align: :right

    if @order.stylist.present?
      move_down 2
      text "Stylist: #{@order.stylist.name}", align: :right
    end

    barcode = Barby::Code39.new @shipment.number
    barcode.annotate_pdf(self, x: 358, y: 577)
  end
end


render :partial => "address"

move_down 10

render :partial => "line_items_box"

move_down 8

# Footer
render :partial => "footer"

move_down 665

text "If you wish to return one of your peach products, please refer to our return policy on the back of this slip first to determine if your product is eligible for a return. If it is, please pop it back into the box it was sent in and use the pre-paid return label found in your box. Once we receive and process the return, we will refund you accordingly. Please allow two weeks for return processing.", :style => :italic 

move_down 4

text("If you would like to exchange an item, please #{@order.has_personal_stylist? ? "connect with your personal stylist, <b>#{@order.stylist.name}</b> at <b>#{@order.stylist.email}</b>" : "email us at <b>returns@peach.company</b>"}", style: :italic, inline_format: true )
