
@font_face = Spree::PrintInvoice::Config[:print_invoice_font_face]
font @font_face
fill_color "000000"

move_down 4
font @font_face, :size => 9, :style => :bold
text "#{Spree.t(:order_number, :number => @order.number)}", :align => :left

move_down 2
font @font_face, :size => 9
text "Placed: #{@order.completed_at.to_date}", :align => :left
move_down 2
text "Shipped: #{I18n.l Date.today}", :align => :left

if @shipment.present?
 move_down 2
 font @font_face, :size => 9
 text "#{Spree.t(:shipment)}: #{@shipment.number}", align: :left

 if @order.stylist.present? && !@order.stylist.corporate?
   move_down 2
   text "Stylist: #{@order.stylist.name}", align: :left
 end

 barcode = Barby::Code39.new @shipment.number
 barcode.annotate_pdf(self, x: 358, y: 507)
end
