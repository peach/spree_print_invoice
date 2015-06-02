data = []

bold_rows = []

if @hide_prices
  @column_widths = { 0 => 100, 1 => 190, 2 => 75, 3 => 50, 4 => 125 }
  @align = { 0 => :left, 1 => :left, 2 => :right, 3 => :right , 4 => :center}
  if @order.shipments.count > 1
    bold_rows << data.size
    data << ["Included in this shipment", nil, nil, nil, nil]
  end
  bold_rows << data.size
  data << [Spree.t(:sku), 'Item', "Size and Color", 'Quantity', "Return Code \n (Please circle code) \n See back for explanation" ]
else
  @column_widths = { 0 => 75, 1 => 205, 2 => 75, 3 => 50, 4 => 75, 5 => 60 }
  @align = { 0 => :left, 1 => :left, 2 => :left, 3 => :right, 4 => :right, 5 => :right}
  bold_rows << data.size
  data << [Spree.t(:sku), 'Item', "Size and Color", Spree.t(:price), 'Quantity', Spree.t(:total)]
end

@shipment.manifest.each do |m|
  next if @hide_prices and m.line_item.tbd?
  row = [m.variant.sku, m.variant.product.name]
  row << m.variant.options_text
  row << m.line_item.single_display_amount.to_s unless @hide_prices
  row << m.quantity
  row << Spree::Money.new(m.line_item.price * m.quantity, { currency: m.line_item.currency }).to_s unless @hide_prices
  row << 'A   B   C   D   E   F   G   H   I'    
  data << row
end

extra_row_count = 0  

if @hide_prices and @order.shipments.count > 1
  bold_rows << data.size
  data << ["Other Items ordered (not included in this shipment)", nil, nil, nil, nil]
  @order.shipments.each do |shipment|
    if (shipment.number != @shipment.number)
      shipment.manifest.each do |m|
        row = [m.variant.sku, m.variant.product.name]
        row << m.variant.options_text
        row << m.line_item.single_display_amount.to_s unless @hide_prices
        row << m.quantity
        row << Spree::Money.new(m.line_item.price * m.quantity, { currency: m.line_item.currency }).to_s unless @hide_prices
        row << 'A   B   C   D   E   F   G   H   I'
        data << row
      end
    end

  end  
end

unless @hide_prices
  data << [""] * 5

  extra_row_count += 1
  data << [nil, nil, nil, nil,Spree.t(:subtotal), @shipment.display_item_cost.to_s ] 
  
  @shipment.adjustments_by_promotion_display.each do |promo, total_adj|
    extra_row_count += 1  
    data << [nil, nil, nil, nil, "Promotion #{promo.name}", total_adj.to_s ]
  end
  
  if rate = @shipment.selected_shipping_rate
    extra_row_count += 1
    data << [nil, nil, nil, nil, rate.name, @shipment.display_cost.to_s ]
  end  

  data << [nil, nil, nil, nil, Spree.t(:total), @shipment.display_final_price_with_items.to_s ]

end


move_down(260)
table(data, :width => @column_widths.values.compact.sum, :column_widths => @column_widths) do
  cells.border_width = 0.5

  bold_rows.each do |row_num|
    row(row_num).font_style = :bold
  end

  row(0).borders = [:bottom]

  last_column = data[0].length - 1
  row(0).columns(0..last_column).borders = [:top, :right, :bottom, :left]
  row(0).columns(0..last_column).border_widths = [0.5, 0, 0.5, 0.5]

  row(0).column(last_column).border_widths = [0.5, 0.5, 0.5, 0.5]

  if extra_row_count > 0
    
    extra_rows = row((-2-extra_row_count)..-2)
    
    extra_rows.columns(0..5).borders = []
    extra_rows.column(4).font_style = :bold

    row(-1).columns(0..5).borders = []
    row(-1).column(4).font_style = :bold
  end
end
