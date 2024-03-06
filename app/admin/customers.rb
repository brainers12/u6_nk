ActiveAdmin.register Customer do
  permit_params :full_name, :phone_number, :email_address, :notes, :image

  # Define the index action with the columns you want to display
  index do
    column :full_name
    column :phone_number
    column :email_address
    column :notes
    # If you want to show the image as a thumbnail
    column "Image" do |customer|
      if customer.image.attached?
        image_tag customer.image.variant(resize: "100x100").processed
      else
        "No image"
      end
    end
    actions
  end

  # Form for creating and updating customers
  form do |f|
    f.inputs do
      f.input :full_name
      f.input :phone_number
      f.input :email_address
      f.input :notes
      f.input :image, as: :file
    end
    f.actions
  end

  # Define the filterable attributes
  filter :full_name
  filter :phone_number
  filter :email_address
  # Exclude the image from the filters, Ransack can't filter by attached files

  # Define which attributes should be searchable in the index action
  controller do
    def scoped_collection
      super.includes :image_attachment # ensures you're not doing N+1 queries for the images
    end
  end

  # Customize the show page
  show do
    attributes_table do
      row :full_name
      row :phone_number
      row :email_address
      row :notes
      row :image do |customer|
        if customer.image.attached?
          image_tag customer.image.variant(resize: "300x300").processed
        end
      end
    end
    active_admin_comments
  end
end

