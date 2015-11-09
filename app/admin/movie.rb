ActiveAdmin.register Movie do
  active_admin_importable
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
  permit_params :list, :of, :attributes, :on, :model, :title, :description,
    :link_trailer, :publish_date, :link_cover
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end

  scope :all, default: true
end
