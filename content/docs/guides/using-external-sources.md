---
title: "Using external sources"
up_to_date_with_nanoc_4: true
---

One of nanoc’s strengths is the ability to pull in data from external systems. In this guide, we’ll show how to do this, and what you can achieve with it.

As an example, assume you work for a company that has a SQL database containing a employee directory, and you want to extract that information into a nice-looking web site. nanoc to the rescue!

## Setting up the database

This example will use the following SQLite 3 schema:

	#!sql
	CREATE TABLE employees (
	    id         INTEGER PRIMARY KEY NOT NULL,
	    first_name TEXT NOT NULL,
	    last_name  TEXT NOT NULL,
	    photo_url  TEXT NOT NULL
	)

To pull in this data into nanoc, we can generate an item for every employee. Such an item would not have any content (except perhaps the employee’s bio, if any), but the item would store the employee details as attributes.

TIP: It helps to not think of nanoc items as just pages or assets. Items can represent much more varied data, such as recipes, reviews, teams, people (with a team identifier), projects (with a team identifier), etc.

In this example, we’ll use [Sequel](http://sequel.jeremyevans.net/) in combination with [SQLite3](https://sqlite.org/). To install the dependencies:

<pre>
<span class="prompt">%</span> <kbd>gem install sequel</kbd>
<span class="prompt">%</span> <kbd>gem install sqlite3</kbd>
</pre>

Create a sample database with sample data:

	#!ruby
	require 'sequel'

	DB = Sequel.sqlite('test.db')

	sql = <<EOS
	CREATE TABLE employees (
	    id         INTEGER PRIMARY KEY NOT NULL,
	    first_name TEXT NOT NULL,
	    last_name  TEXT NOT NULL,
	    photo_url  TEXT NOT NULL
	)
	EOS

	DB[:employees].insert(
	  id: 1,
	  first_name: 'Denis',
	  last_name: 'Defreyne',
	  photo_url: 'http://employees.test/photos/1.png'
	)

At this point, we have a database set up, with some sample data to be used.

## Writing the data source

Create the file <span class="filename">lib/data_sources/employee_db.rb</span> and put in the following:

	#!ruby
	require 'sequel'

	class HRDataSource < ::Nanoc::DataSource
	end

A data source is responsible for loading data, and is represented by the `Nanoc::DataSource` class. Each data source has a unique identifier, which is a Ruby symbol. Add the line `identifier :hr` inside the newly created data source class:

	#!ruby
	class HRDataSource < ::Nanoc::DataSource
	  identifier :hr
	end

Data sources have an `#up` method, which can be overriden to perform actions to establish a connection with the remote data source. In this example, implement it so that it connects to the database:

	#!ruby
	class HRDataSource < ::Nanoc::DataSource
	  identifier :hr

	  def up
	    @db = Sequel.sqlite('test.db')
	  end
	end

Then we can generate items. For every employee, represented by a row from the `employees` table in the database, we create an item:

	#!ruby
	class HRDataSource < ::Nanoc::DataSource
	  identifier :hr

	  def up
	    @db = Sequel.sqlite('test.db')
	  end

	  def down
	    @db.disconnect
	  end

	  def items
	    @db[:employees].map do |employee|
	      new_item(
	        '',
	        employee,
	        "/employees/#{employee[:id]}/"
	      )
	    end
	  end
	end

The first argument to the `#new_item` is the content (empty in this case), the second is the attributes hash (which will have the keys `first_name`, `last_name`, and `photo_url`) and the third argument is the identifier.

The data source implementation is now ready to be used.

## Using the data source

Configure the data source in <span class="filename">nanoc.yaml</span>:

	#!yaml
	data_sources:
	  -
	    type:         hr
	    items_root:   /external/hr

The `type` is the same as the identifier of the data source, and `items_root` is a string that will be prefixed to all item identifiers coming from that data source. For example, employees will have identifiers like `"/external/hr/employees/1"`.

Create the file <span class="filename">lib/helpers.rb</span> and put in one function that will make it easier to find employees:

	#!ruby
	def sorted_employees
	  employees = @items.select do |i|
	    i.identifier =~ '/external/hr/employees/*'
	  end
	  employees.sort_by do |e|
	    [ e[:last_name], e[:first_name] ]
	  end
	end

Now it’s time to create the employee directory page. Create the file <span class="filename">content/employees.erb</span> and put in the following code, which will find all employees and print them:

	#!html
	<h1>Employees</h1>

	<table>
	  <thead>
	    <tr>
	      <th>Photo</th>
	      <th>First name</th>
	      <th>Last name</th>
	    </tr>
	  </thead>
	  <tbody>
	    <% sorted_employees.each do |e| %>
	      <tr>
	        <td><%= e[:photo_url] %></td>
	        <td><%= e[:first_name] %></td>
	        <td><%= e[:last_name] %></td>
	      </tr>
	    <% end %>
	  </tbody>
	</table>

Finally you have to stop nanoc from writing out pages for every employee item provided by the data source. For this, the `#ignore` rule comes in handy. Add this at the top of your <span class="filename">Rules</span> file:

	#!ruby
	ignore '/external/*'

Now compile, and you will see the employee directory!
