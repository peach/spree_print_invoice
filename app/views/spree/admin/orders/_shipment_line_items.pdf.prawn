shipment.manifest.each do |m|

  next if m.line_item.virtual?
  unless included
    next if m.line_item.sample_bra? && !shipment.shipped?
    next if m.line_item.subscription?
  end

  if need_title
    need_title = false
    style_row(row_styles, data.size)
    data << ["--> Other Items ordered (not included in this shipment)", nil, nil]
  end

  row = []
  style_row(row_styles, data.size)

  product = "<color rgb='#000000'>"
  product += "<b>#{m.variant.product.name.upcase}#{"  |  #{shipment.order.display_money(m.line_item.price, no_cents_if_zero: true)}" if shipment.order.bento?}</b>\n"
  product += m.variant.product.short_description if m.variant.product.short_description.present?
  product += "</color>"

  row << product
  style_row(row_styles, data.size, text_color: "e73a22") if m.quantity > 1
  row << display_options_quantity(m.variant.option_values_to_s("\n", :presentation), m.quantity)
  row << m.variant.sku
  row << m.line_item.stock_items.map {|si| si.stock_item_location.try(:name) }.compact.uniq.first
  data << row
end
