class CreateShareValues < ActiveRecord::Migration
  def change
    create_table :share_values do |t|
      t.string :Date
      t.decimal :AdjustedClosingPrice ,:precision => 30, :scale => 10
      t.decimal :ClosingPrice ,:precision => 30, :scale => 10
      t.string :Change
      t.decimal :OpeningPrice,:precision => 30, :scale => 10
      t.decimal :BasePrice,:precision => 30, :scale => 10
      t.decimal :High,:precision => 30, :scale => 10
      t.decimal :Low,:precision => 30, :scale => 10
      t.decimal :CapitalListedforTrading,:precision => 30, :scale => 10
      t.decimal :MarketCap,:precision => 30, :scale => 10
      t.decimal :Turnover,:precision => 30, :scale => 10
      t.decimal :Volume,:precision => 30, :scale => 10
      t.decimal :Trans,:precision => 30, :scale => 10
      t.string :ExType
      t.string :ExCoefficient
      t.decimal :IndexAdjustedNoofShares,:precision => 30, :scale => 10
      t.decimal :IndexAdjustedFreeFloatRate,:precision => 30, :scale => 10
      t.decimal :LastIANSUpdate,:precision => 30, :scale => 10
      t.belongs_to :share
      t.timestamps null: false
    end
    add_index :share_values, :share_id
  end

end
