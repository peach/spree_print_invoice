repeat :all do
  bounding_box([0, 720], width: 540, height: 650) do
  
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

      if @shipment.present?
        move_down 2
        font @font_face, :size => 9
        text "#{Spree.t(:shipment)}: #{@shipment.number}", align: :right

        if @order.stylist.present? && !@order.stylist.corporate?
          move_down 2
          text "Stylist: #{@order.stylist.name}", align: :right
        end
        
        fill_color "F48577"
        if @order.stylist.present? && (priority = @shipment.priority).present?  
          if true or %w(high medium).include? priority.to_s
            text "*#{priority.letter}", align: :center, :size => 26, :style => :bold
          end
        end
        fill_color "000000"

        barcode = Barby::Code39.new @shipment.number
        barcode.annotate_pdf(self, x: 358, y: 507)
      end
    end
    
    if @order.user.present?
      move_down 50
      font @font_face, :size => 11, :style => :bold
      text "Packing Slip for #{@order.user.name}", :align => :left
      move_down 5
    else
      move_down 65
    end
  
  end
  
end
