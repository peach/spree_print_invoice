@font_face = Spree::PrintInvoice::Config[:print_invoice_font_face]
repeat :all do
  pigs = Rails.root.join('app','assets','images','peach-logo-horiz.png').to_s
  image pigs, :at => [0, 720],  :scale => 0.75

  if (priority = @shipment.priority).present? && priority > ShipmentPriority::Low
    text_box "*#{priority.letter}", at: [165, 690], width: 45, align: :left, size: 36, style: :bold, color: "F48577"
  end

  bounding_box([215, 690], width: 200, height: 100) do
    font @font_face
    if @order.user.present?
      text "Package for:"
      text @order.user.name, size: 18
    end
  end

  bounding_box([400, 720], width: 540, height: 100) do
   render :partial => "spree/admin/orders/head_info"
  end

  bounding_box([0, 110], width: 305, height: 650) do
    font @font_face

    text "THANK YOU", size: 20

    text("Please see the reverse side for FAQs and return information, and don’t hesitate to contact your stylist <b>#{@order.stylist.name}</b> at <b>#{@order.stylist.email}</b> with any questions at  <b>#{returns_email}</b>", style: :italic, inline_format: true )

    fill_color "000000"

    move_down 4
    if @shipment.present?
      if (priority = @shipment.priority).present? && priority > ShipmentPriority::Low
        text "*#{priority.letter}", align: :center, :size => 26, :style => :bold, color: "F48577"
      end
      barcode = Barby::Code39.new @shipment.number
      barcode.annotate_pdf(self, x: 0, y: 535)
    end
  end

  bounding_box([220, 50], width: 100, height: 650) do
   font @font_face, :size => 11
   text "Ship To:", style: :bold

   font @font_face, :size => 9
   address = @order.ship_address

   info = %Q{ #{address.first_name} #{address.last_name}
              #{address.address1}
   }
   info += "#{address.address2}\n" if address.address2.present?
   state = address.state ? address.state.abbr : ""
   info += "#{address.city} #{state}. #{address.zipcode}\n"
   info += "#{address.country.name}\n"
   info.strip
   text info
  end

  bounding_box([360, 100], width: 340, height: 650) do
   font @font_face, :size => 13
   text "Follow us online:", style: :bold
   font @font_face, :size => 11
   text "@withlovepeach"
  end


end
