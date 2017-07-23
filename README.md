# NOTE: THIS IS NOT FINISHED. STAY TUNED!

# Ruby on Rails: Creating Custom Routes, Ajax, and a few other goodies

The purpose of this tutorial is to help new Rails developers (or anyone) to develop the end to end functionality needed to create a new controller action beyond the standard Rails RESTFUL actions, this is the tutorial for you. Much of what we'll go into in this topic is covered in Rails documentation, but I wanted to present my a specific use case that I applied on one of my projects in hopes that it might help people. In case the developer is really new, we'll introduce a few other goodies too, such as AJAX, and even Agile practices like user stories and how to formulate a plan to tackle a problem as a developer.

# Part 1: Introduction to Application: 'Employee Project Manager'

As an example case, let's make our application a glorified 'Todo' list manager. Let's imagine we have two models, employees and projects. The user of this application (your client!) is the manager of the business, whom uses the application to keep track of the different projects his employees are assigned to. 

The relationships between the employee and project models are as follows: 

app/models/project.rb

```
class Project < ActiveRecord::Base
  has_many :employees
end
```

app/models/employee.rb

```
class Employee < ActiveRecord::Base
  belongs_to :project
end
```

TODO: Add a screenshot of the employees page and some markup here 

Now, time to address the problem from a business needs standpoint. The user would like the ability to change the projects their employees are assigned to in a more efficient manner. Essentially, they find it time consuming to visit the /employeesindex view, clicking the 'edit' link to view an individual employee's edit page, changing the project they are assigned to, hitting save, and then going back and repeating the process. That's a few clicks too many! 

After some discussion with your client, they decide that it would have business value if they could instead visit the /projectsindex page and change the project they are assigned to from that page. It makes sense right? You've already designed the projects page to show employees assigned to a project in a pop up modal (ADD A SCREENSHOT BELOW HERE), so now you would be taking things one step further.

Your first thought is to just display the employees, and then a link to their edit view. BUT, your client specified that having to visit each individual employee edit form page is time consuming... ain't nobody got time for that! Plus, you're a programmer, remember? It's your job to make people's lives simpler!

Your project manager creates the following acceptance criteria for you to address as the developer: 

Given that I am an admin user, and I visit the projects index page, then I can change the reassign the employee to a different project without leaving the projects index page. 

Well, it's not the BEST acceptance criteria, but it tells you, as the developer, what you need to know to meet the business need: That the user wants to be able to update employee records in their database without having to go to each individual edit page. That means need to send data to the server for a specific attribute of the user (defining what project they're defined to), without reloading the page. Given that the user is requesting a quick, 'instantaneous' experience, it sounds like there might be a little AJAX involved, and since we're sending data to the server, we know we'll need a POST route. 

# Part III: Routes and the Controller

Let's take a look at our config/routes.rb file. It looks something like this:

```
Rails.application.routes.draw do
  resources :employees
  resources :projects
end
```

Let's define our new action as a member route. It's pretty simple to do. And since the user wants to 'reassign' an employee to a new project, why not call it, reassign_project?

```
Rails.application.routes.draw do
  resources :employees do
    member do
      post :reassign_project
    end
  end
  resources :projects
end
```

Save the file, head over to your command line, and type in rake routes. You should see the new route you added there!

Now let's head over to our controller and begin defining the new action. Before solving the problem, let's write out some comments to remind ourselves what a controller action will need.

```
class EmployeesController < ApplicationController
  def reassign_project
    # 1. We will need to access the individual employee project we'll modify as a variable
    # 2. We'll need to access the individual project that the employee will be updated with as a variable
    # 3. We'll need to update the attribute of the employee with the new project.
    # 4. We'll need a response to let the user know their action was successful. However...
    #    The user requested that they stay on the same page. That means, the response to the user's
    #    action shouldn't redirect us to a new page, because they want to keep going after this one!
  end
end
```

In case you're a beginner who's only used the standard RESTFUL routes and are kind of sketchy with understanding parameters and such, let's take things step by step to get all the data we need.

TODO: Go to the view, talk a little bit about console logging, how to get params, how to create an erb js partial as a response, etc.

Final controller action:
```
class EmployeesController < ApplicationController
  def reassign_project
    employee = Employee.find(params[:id])
    project_params = params[:project_id]
    project_id = project_params[:id]
    employee.update_attribute(:project_id, project_id)
    respond_to do |format|
      format.js { render layout: false, locals: { project: project } }
    end
  end
end
```

TODO: Now talk about creating a feature test with rspec, capybara, and capybara webkit to simulate the action of visiting the page, reassigning a project, and inspecting the objects for updated attributes.

Final feature spec can look something like this:

```
Rspec.feature 'Projects - Index Page' do
  describe 'Reassigning employees to new project' do
    it 'allows user to reassign employee' do
      Project.delete_all
      # This will create an employee with a default project
      employee = FactoryGirl.create(:employee)
      new_project = FactoryGirl.create(:project)
      sign_in(user)
      visit projects_path
      # Click modal to open list of employees
      # Select the new project from the dropdown
      # Maybe make expectation for employee project
      # click the reassign project button
      # reload the employee
      # make expectation for the employee project now
      # Maybe check the page to make sure the JS worked and
      # got rid of the div where the employee information was located
      
    end
  end
end
```


## Getting Started 

After you have cloned this repo, run this setup script to set up your machine
with the necessary dependencies to run and test this app:

    % ./bin/setup

It assumes you have a machine equipped with Ruby, Postgres, etc. If not, set up
your machine with [this script].

[this script]: https://github.com/thoughtbot/laptop

After setting up, you can run the application using [Heroku Local]:

    % heroku local

[Heroku Local]: https://devcenter.heroku.com/articles/heroku-local

## Guidelines

Use the following guides for getting things done, programming well, and
programming in style.

* [Protocol](http://github.com/thoughtbot/guides/blob/master/protocol)
* [Best Practices](http://github.com/thoughtbot/guides/blob/master/best-practices)
* [Style](http://github.com/thoughtbot/guides/blob/master/style)

## Deploying

If you have previously run the `./bin/setup` script,
you can deploy to staging and production with:

    $ ./bin/deploy staging
    $ ./bin/deploy production
