Given /^In DataBase we have table named "(.*?)" with such rows:$/ do |name, table|
  if ActiveRecord::Base.connection.table_exists? name
    table.cell_matrix.each do |cell|
      unless ActiveRecord::Base.connection.column_exists?(name.to_sym, cell[0].value.to_sym)
        raise OnlineTestingError, "Can't find column with name \"#{cell[0].value}\""
      end
    end
  else
    raise OnlineTestingError, "Can't find table with name \"#{name}\""
  end
end

Then /^In table "(.*?)" should be rows with such types:$/ do |name, table|
  rows = ActiveRecord::Base.connection.columns(name).collect{|r| {r.name.to_sym => r.type}}
  table.cell_matrix.each do |cell|
    unless rows.include?({cell[0].value.to_sym => cell[1].value.to_sym})
      raise OnlineTestingError, "The column \"#{cell[0].value}\" must be \"#{cell[1].value}\""
    end
  end
end
