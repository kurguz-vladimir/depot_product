And /^On the page must be textarea with name (".*") and height (\d+) rows$/ do |name, num|
  textarea = find('form textarea[name='+name+']')
  if textarea.nil?
    raise OnlineTestingError, "Can't find \"textarea\" with name #{name}."
  elsif textarea[:rows].to_i < num.to_i
    raise OnlineTestingError, "The \"textarea\" with name #{name} must have height #{num} rows or more."
  end
end

When /^I create product with name "(.*)"$/ do |name|
  steps %Q{
    And I fill in "product[title]" with "#{name}"
    And I fill in "product[description]" with "test description"
    And I press "Create Product"
  }
end

Then /^I should be redirected on the product page with name "(.*)"$/ do |name|
  product = Product.find_by_title(name)
  if current_path != product_path(product)
    raise OnlineTestingError, "No redirect on product page."
  end
end

Then /^I should be redirected on the products page$/ do
  if current_path != products_path
    raise OnlineTestingError, "No redirect on products page."
  end
end

Then /^I should see product title "(.+)"$/ do |title|
   steps %Q{
     And I should see text "#{title}" or error "Product was not saved."
   }
end

Then /^I should not see product with name "(.*)"$/ do |name|
  if page.has_xpath?('//td[@class="list_description"]', :text => name)
    raise OnlineTestingError, "Error destroying product. Product was not destroyed."
  end
end

When /^I update product with new name "(.*)"$/ do |name|
  steps %Q{
    And I fill in "product[title]" with "#{name}"
    And I press "Update Product"
  }
end

When /^I destroy product with name "(.*)"$/ do |name|
  steps %Q{
    And Product "#{name}" must have link "Destroy"
    And Destroy link for product "#{name}" must have confirmation
  }
end

And /^Product "(.*)" must have link "(.*)"$/ do |name, link|
  begin
    prod = find('table tr', :text => name)
    prod.find('a[data-method="delete"]', :text => link)
  rescue
    raise OnlineTestingError, "Can't find \"Destroy\" link for product."
  end
end

And /^Destroy link for product "(.*)" must have confirmation$/ do |name|
  link = find('table tr', :text => name).find('a[data-method="delete"]', :text => 'Destroy')
  if link["data-confirm".to_sym].nil?
    raise OnlineTestingError, "Link \"Destroy\" has not confirmation."
  else
    link.click
  end
end

And /^I should see header "(.*)"$/ do |tag|
  begin
    find(tag)
  rescue
    raise OnlineTestingError, "Can't find header #{tag} on listing products page."
  end
end

And /^I should see table with (\d+) columns$/ do |cols|
  table = all('table').first
  if table.nil?
    raise OnlineTestingError, "Can't find table on listing products page."
  elsif table.all('tr').first.all('td').count != cols.to_i
    raise OnlineTestingError, "The table listing products do not have \"#{cols}\" columns."
  end
end

And /^The first column should have image with class "(.*)"$/ do |class_name|
  img = all('table tr').last.all('td').first.find('img')
  if img.nil?
    raise OnlineTestingError, "Can't find img tag in first column of table."
  elsif img[:class] != class_name
    raise OnlineTestingError, "Img tag must have class \"#{class_name}\"."
  end
end

And /^The second column should have title and description of product$/ do
  desc = all('table tr').last.all('td')[1]
  if desc.find('dt').text != 'prod1'
    raise OnlineTestingError, "Can't find column with title of product."
  elsif desc.find('dd').text != 'test description'
    raise OnlineTestingError, "Can't find column with description of product."
  end
end

And /^The last column should have links:$/ do |links|
  actions = all('table tr').last.all('td').last.all('a').collect{|a| a.text}
  links.cell_matrix.each do |link|
    unless actions.include?(link[0].value)
      raise OnlineTestingError, "Can't find link \"#{link[0].value}\" in the products table."
    end
  end
end
