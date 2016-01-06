require 'spec_helper'
require 'rails_helper'

describe "Editing todo items" do
  let!(:todo_list) { TodoList.create(title: "Grocery List", description: "Groceries") }
  let!(:todo_item) { todo_list.todo_items.create(content: "Almond Milk") }

  # ALL 3 of these are failing: Unable to find css "todo_item_1"
  # Video: Editing Todo items - 3min mark

  it "is successful with valid content" do
    visit_todo_list(todo_list)
    within("todo_item_#{todo_item.id}") do
      click_link "Edit"
    end
    fill_in "Content", with: "Lots of Almond Milk"
    click_button "Save"
    expect(page).to have_content("Saved todo list item.")
    todo_item.reload
    expect(todo_item.content).to eq("Lots of Almond Milk")
  end

  it "is unsuccessful with no content" do
    visit_todo_list(todo_list)
    within("todo_item_#{todo_item.id}") do
      click_link "Edit"
    end
    fill_in "Content", with: ""
    click_button "Save"
    expect(page).to_not have_content("Saved todo list item.")
    expect(page).to have_content("Content can't be blank.")
    todo_item.reload
    expect(todo_item.content).to eq("Almond Milk")
  end

  it "is unsuccessful with not enough content" do
    visit_todo_list(todo_list)
    within("todo_item_#{todo_item.id}") do
      click_link "Edit"
    end
    fill_in "Content", with: "1"
    click_button "Save"
    expect(page).to_not have_content("Saved todo list item.")
    expect(page).to have_content("Content is too short.")
    todo_item.reload
    expect(todo_item.content).to eq("Almond Milk")
  end

end
