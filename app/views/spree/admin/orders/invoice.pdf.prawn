render partial: "print", locals: {type_notes: :internal}
pdf.start_new_page
render partial: "print", locals: {type_notes: :external}

