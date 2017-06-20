data = []
row_styles = {}

def style_row(styles, row_num, opts={})
  styles[row_num] ||= {}
  styles[row_num].merge!(opts)
end

@column_widths = { 0 => 377, 1 => 80, 2 => 80}
@align = { 0 => :left, 1 => :left, 2 => :right }
if @order.shipments.count > 1
  style_row(row_styles, data.size, font_style: :bold)
  data << ["Included in this shipment", nil, nil]
end

@shipment.cards_for_packing_slip.each do |card|
  data << [card.sku, card.name, card.options_text, card.quantity]
end

@shipment.manifest.each do |m|
  next if m.line_item.virtual?
  row = []
  style_row(row_styles, data.size)

  product = "<color rgb='#000000'>"
  product += "<b>#{m.variant.product.name.upcase}</b>\n"
  product += m.variant.product.short_description if m.variant.product.short_description.present?
  product += "</color>"

  row << product
  style_row(row_styles, data.size, text_color: "e73a22") if m.quantity > 1
  row << "#{m.variant.option_values_to_s("\n", :presentation)} \n #{m.quantity}"
  row << m.variant.sku
  data << row
end

if @order.shipments.count > 1
  need_title = true
  @order.shipments.each do |shipment|
    if (shipment.number != @shipment.number)
      shipment.manifest.each do |m|
        next if m.line_item.sample_bra? && !shipment.shipped?
        next if m.line_item.subscription?
        if need_title
          need_title = false
          style_row(row_styles, data.size, font_style: :bold)
          data << ["Other Items ordered (not included in this shipment)", nil, nil]
        end
        row = []
        style_row(row_styles, data.size)

        product = "<color rgb='#000000'>"
        product += "<b>#{m.variant.product.name.upcase}</b>\n"
        product += "todo: descrition for #{m.variant.product.name}"
        product += "</color>"

        row << product
        style_row(row_styles, data.size, text_color: "e73a22") if m.quantity > 1
        row << "#{m.variant.option_values_to_s("\n", :presentation)} \n #{m.quantity}"
        row << m.variant.sku
        data << row
      end
    end
  end
end


move_down 120
table(data,:width => @column_widths.values.compact.sum, :column_widths => @column_widths, cell_style: {padding: [8, 5, 8, 5], inline_format: true}, row_colors: [nil,'eff0f1']) do
  cells.border_width = 0.5
  last_row = data.length - 1
  last_column = data[0].length - 1
  row_styles.each do |row_num, styles|
    row(row_num).font_style = styles[:font_style] if styles[:font_style].present?
    row(row_num).text_color = styles[:text_color] if styles[:text_color].present?
    row(row_num).columns(0..last_column).borders = [:top, :bottom]
  end

  row(0).borders = [:bottom]

  row(0).columns(0..last_column).borders = [:top, :bottom]
  row(0).columns(0..last_column).border_widths = [1.5, 0, 0.5, 0]

  row(0).column(last_column).border_widths = [1.5, 0, 0.5, 0]

  row(last_row).columns(0..last_column).borders = [:top, :bottom]
  row(last_row).columns(0..last_column).border_widths = [0.5, 0, 1.5, 0]
  row(last_row).column(last_column).border_widths = [0.5, 0, 1.5, 0]
end
