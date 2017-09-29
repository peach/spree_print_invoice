@font_face = Spree::PrintInvoice::Config[:print_invoice_font_face]
repeat :all do

  bounding_box([0, 725], width: 540, height: 85) do
    bounding_box([380, 85], width: 160) do
     render :partial => "spree/admin/orders/head_info"
    end

    if (priority = @shipment.priority).present? && priority > ShipmentPriority::Low
      bounding_box([170, 75], width: 200) do
        text "*#{priority.letter}", align: :center, size: 36, style: :bold, color: "F48577"
      end
    end

    bounding_box([0, 20], width: 540, height: 20) do
      font @font_face
      float do
        text "Item count: #{@shipment.inventory_units.reject(&:virtual?).size + @shipment.cards_for_packing_slip.sum(&:quantity)}", size: 14, align: :right
      end
      text @order.name, size: 16
    end
  end

  bounding_box([0, 110], width: 540, height: 100) do
    font @font_face

    bounding_box([0, 100], width: 360) do
      text "THANK YOU", size: 16, style: :bold

      stylist = @order.support_stylist
      text("Please see the reverse side for FAQs and return information, and don’t hesitate to contact #{stylist.present? ? "your stylist <b>#{stylist.name}</b> at <b>#{stylist.email}</b>" : "peach support at <b>#{client_support_email}</b>"} with any questions.", inline_format: true )
    end

    bounding_box([380, 100], width: 160) do
     font @font_face
     text "Follow us online:", style: :bold, size: 13
     text "@withlovepeach", size: 11

      pigs = Rails.root.join('app','assets','images','pinterest_black.png').to_s
      image pigs, :at => [0, 0],  :scale => 0.30

      pigs = Rails.root.join('app','assets','images','facebook_black.png').to_s
      image pigs, :at => [25, 0],  :scale => 0.30

      pigs = Rails.root.join('app','assets','images','instagram_black.png').to_s
      image pigs, :at => [50, 0],  :scale => 0.30
    end

    barcode = Barby::Code39.new @shipment.number
    barcode.annotate_pdf(self, x: 0, y: -10)

    bounding_box([220, 47], width: 320) do
      font @font_face, size: 8
      text "Ship To:", style: :bold, size: 9

      address = @order.ship_address
      shipping_method = @shipment.shipping_method
      shipping_speed = @shipment.shipping_speed

      text address.address_label
      via = ''
      via += "via #{shipping_method.name}" if shipping_method.present?
      opts = {}
      if shipping_speed.present?
        if (color_rgb = shipping_speed.try(:rgb)).present?
          opts.merge!(color: color_rgb.split('#')[1])
        end
        via += ' ' if via.present?
        via += shipping_speed.to_s.titleize
      end

      if via.present?
        text via, opts
      end
    end

  end

end
