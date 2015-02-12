require 'prawn/layout'

@font_face = Spree::PrintInvoice::Config[:print_invoice_font_face]

font @font_face

im = Rails.application.assets.find_asset(Spree::PrintInvoice::Config[:print_invoice_logo_path])
image im , :at => [0,720], :scale => logo_scale

#fill_color "E99323"
if @hide_prices
  text Spree.t(:packaging_slip), :align => :right, :style => :bold, :size => 18
else
  text Spree.t(:customer_invoice), :align => :right, :style => :bold, :size => 18
end
fill_color "000000"

move_down 2

if Spree::PrintInvoice::Config.use_sequential_number? && @order.invoice_number.present? && !@hide_prices

  font @font_face,  :size => 9,  :style => :bold
   text "#{Spree.t(:invoice_number)} #{@order.invoice_number}", :align => :right

  move_down 2
  font @font_face, :size => 9
 # text "#{Spree.t(:invoice_date)} #{I18n.l @order.invoice_date}", :align => :right
  text "#{Spree.t(:invoice_date)} #{I18n.l Date.today.strftime("%m/%d/%Y")}", :align => :right

else

  move_down 2
  font @font_face,  :size => 9
  text "#{Spree.t(:order_number, :number => @order.number)}", :align => :right

  if @shipment.present?
    move_down 2
    font @font_face, :size => 9
    text "#{Spree.t(:shipment)} #{@shipment.number}", :align => :right
  end

  move_down 2
  font @font_face, :size => 9
  text "#{I18n.l Date.today}", :align => :right

end


render :partial => "address"

move_down 10

render :partial => "line_items_box"

move_down 8

# Footer
render :partial => "footer"

move_down 700

text "If you wish to exchange or return one of your peach products, please email returns@peach.company and use the return label included in your package. Please include this original packing slip with your return.", :style => :italic 
