class CreateSupplierPaymentMethods < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_supplier_payment_methods do |t|
      t.belongs_to :supplier, index: true
      t.belongs_to :payment_method, index: true
      t.string :connected_account

      t.timestamps
    end
  end
end
