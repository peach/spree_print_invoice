@font_face = Spree::PrintInvoice::Config[:print_invoice_font_face]
repeat :all do

  bounding_box([0, 660], width: 200, height: 100) do
    font @font_face
    text @order.user.name, size: 16 if @order.user.present?
  end

  if (priority = @shipment.priority).present? && priority > ShipmentPriority::Low
    fill_color "f48577"
    text_box "*#{priority.letter}", at: [230, 690], width: 45, align: :left, size: 36, style: :bold
    fill_color "000000"
  end

  bounding_box([380, 720], width: 540, height: 100) do
   render :partial => "spree/admin/orders/head_info"
  end

  bounding_box([0, 110], width: 305, height: 650) do
    font @font_face

    text "THANK YOU", size: 16, style: :bold

    text("Please see the reverse side for FAQs and return information, and don’t hesitate to contact your stylist <b>#{@order.stylist.name}</b> at <b>#{@order.stylist.email}</b> with any questions.", inline_format: true )

    fill_color "000000"

    move_down 4
    if @shipment.present?
      barcode = Barby::Code39.new @shipment.number
      barcode.annotate_pdf(self, x: 0, y: 525)
    end
  end

  bounding_box([220, 40], width: 150, height: 650) do
    font @font_face, :size => 9
    text "Ship To:", style: :bold

    font @font_face, :size => 8
    address = @order.ship_address
    shipping_method = @shipment.try(:shipping_method)
    shipping_speed = @shipment.try(:shipping_speed)

    info = %Q{ #{address.first_name} #{address.last_name}
              #{address.address1}
    }
    info += "#{address.address2}\n" if address.address2.present?
    state = address.state ? address.state.abbr : ""
    info += "#{address.city} #{state}. #{address.zipcode}\n"
    info.strip
    text info
    via = ''
    via = "via #{shipping_method.name}"
    opts = {}
    if shipping_speed.present?
      if (color_rgb = shipping_speed.try(:rgb)).present?
        opts.merge!(color: color_rgb.split('#')[1])
      end
      via += " #{shipping_speed.to_s.titleize}"
    end
    text via, opts
  end

  bounding_box([380, 110], width: 340, height: 650) do
   font @font_face, :size => 13
   text "Follow us online:", style: :bold
   font @font_face, :size => 11
   text "@withlovepeach"
  end

  pigs = Rails.root.join('app','assets','images','pinterest_black.png').to_s
  image pigs, :at => [380, 80],  :scale => 0.30

  pigs = Rails.root.join('app','assets','images','facebook_black.png').to_s
  image pigs, :at => [405, 80],  :scale => 0.30

  pigs = Rails.root.join('app','assets','images','instagram_black.png').to_s
  image pigs, :at => [430, 80],  :scale => 0.30

end
