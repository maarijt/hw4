# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  pos_e1 = page.body.index(e1)
  pos_e2 = page.body.index(e2)
  pos_e1.should < pos_e2
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  split = rating_list.split(",")
  split.each do |rating|
    ele_rating = "ratings_#{rating}"
    if uncheck == true
      uncheck(ele_rating)
    else
      check(ele_rating)
    end
  end
  end


Then /I should (not )?see the following ratings: (.*)/ do |sho, rating_list|
  split = rating_list.split(",")
  split.each do |rating|
    if sho 
      if page.respond_to? :should
        page.should have_content(rating)
      else
        assert page.has_content?(rating)
      end
    else
      if page.respond_to? :should
        page.should have_xpath('//*', :text => "#{rating}")
      else
        assert page.has_xpath?('//*', :text => "#{rating}")
      end
    end

  end

end

Then /I should see all the movies/ do
  rows = page.all('table#movies tr').count
  rows.should == 11
  
end
