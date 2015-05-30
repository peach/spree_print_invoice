data = []
bold_rows = []

@column_widths = { 0 => 100, 1 => 190, 2 => 75, 3 => 50, 4 => 125 }
@align = { 0 => :left, 1 => :left, 2 => :right, 3 => :right , 4 => :center}
if @order.shipments.count > 1
  bold_rows << data.size
end
bold_rows << data.size

rows_visit = 0

line_items = @order.shipments.map {|ship| ship.manifest }.flatten
li_in_this_ship =  @shipment.manifest.select { |m| !m.line_item.tbd? }
li_others =  line_items - li_in_this_ship

order_line_items = li_in_this_ship + li_others

data << [Spree.t(:sku), 'Item', "Size and Color", 'Quantity', "Return Code \n (Please circle code) \n See back for explanation" ]  
data << ["Included in this shipment", nil, nil, nil, nil]

header_others = false

i = 0 
while i < line_items.size
  move_down(100) unless i == 0
  for index in (i...line_items.size)
    if i >= li_in_this_ship.size && !header_others
      data << ["Other Items ordered (not included in this shipment)", nil, nil, nil, nil]
      header_others = true
    end
    m = order_line_items[index]
    row = [m.variant.sku, m.variant.product.name]
    row << m.variant.options_text
    row << m.line_item.single_display_amount.to_s unless @hide_prices
    row << m.quantity
    row << 'A   B   C   D   E   F   G   H   I'
    break if (i = index + 1) && i % 10 == 0
    data << row
  end
end

extra_row_count = 0

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
