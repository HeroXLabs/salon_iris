defmodule SalonIris.Customer do
  defstruct [:id, :first_name, :last_name, :address, :city, :state, :zipcode,
             :phone_number, :email, :referral]
end
