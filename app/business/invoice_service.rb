class InvoiceService

  def list_all_invoices()
    Invoice.order('created_at DESC')
  end

  def list_invoices_by_date(date:)
    Invoice.where(date: date).order('created_at DESC')
  end

  def find_by_id(id:)
    Invoice.find_by(id:id)
  end

  def new_invoice(user_id:, params:)
    invoice = Invoice.new(params)
    invoice.user_id = user_id
    if invoice.save
      InvoiceMailer.new.send_mail_invoice(invoice: invoice)
      return true;
    end
    return false;
  end

  def update(invoice:, params:)
    invoice.update(params)
  end

  def delete(invoice:)
    invoice.destroy.present?
  end

end
