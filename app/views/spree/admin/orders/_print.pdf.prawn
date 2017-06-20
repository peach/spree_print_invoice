require 'prawn/layout'
require 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/prawn_outputter'

render partial: 'spree/admin/orders/repeat'

bounding_box([0, 630], width: 540, height: 470) do
  render :partial => "spree/admin/orders/line_items_box"
end

move_down 8

# Footer
render :partial => "spree/admin/orders/footer"
