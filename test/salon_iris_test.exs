defmodule SalonIrisTest do
  use ExUnit.Case
  doctest SalonIris
  alias SalonIris
  alias SalonIris.{Customer}

  test "parse_table_row/1" do
    html = ~S"""
<tr class="trItemsTableRow" id="5636" title="Lacey">
  <td class=" ">1117320</td>
  <td class=" ">Lacey</td>
  <td class=" "></td>
  <td class=" "></td>
  <td class=" "></td>
  <td class=" "></td>
  <td class=" "></td>
  <td class=" ">3234831396</td>
  <td class=" "></td>
  <td class=" "></td>
  <td class=" "></td>
  <td class=" "></td>
  <td class=" "></td>
</tr>
<tr class="trItemsTableRow even" id="4072" title="Mary">
  <td class=" ">1115628</td>
  <td class=" ">Mary</td>
  <td class=" "></td>
  <td class=" "></td>
  <td class=" "></td>
  <td class=" "></td>
  <td class=" "></td>
  <td class=" ">(818) 749-3154</td>
  <td class=" "></td>
  <td class=" "></td>
  <td class=" ">alido.mary@gmail.com</td>
  <td class=" ">San Gabriel</td>
  <td class=" ">YELP</td>
</tr>
<tr class="trItemsTableRow" id="3209" title="Marisela Zuniga">
  <td class=" ">1112966</td>
  <td class=" ">Marisela</td>
  <td class=" ">Zuniga</td>
  <td class=" "></td>
  <td class=" "></td>
  <td class=" "></td>
  <td class=" "></td>
  <td class=" "></td>
  <td class=" ">(626) 716-7523</td>
  <td class=" "></td>
  <td class=" ">zunigamarisela5@usc.edu</td>
  <td class=" ">San Gabriel</td>
  <td class=" ">GROUPON</td>
</tr>
    """
    [%Customer{} = cus_1,
     %Customer{} = cus_2,
     %Customer{} = cus_3] = customers =
      html
      |> SalonIris.parse

    assert cus_1.id == "1117320"
    assert cus_1.first_name == "Lacey"
    assert cus_1.last_name == ""
    assert cus_1.phone_number == "3234831396"
    assert cus_1.email == ""

    assert cus_2.id == "1115628"
    assert cus_2.first_name == "Mary"
    assert cus_2.last_name == ""
    assert cus_2.phone_number == "(818) 749-3154"
    assert cus_2.email == "alido.mary@gmail.com"

    assert cus_3.id == "1112966"
    assert cus_3.first_name == "Marisela"
    assert cus_3.last_name == "Zuniga"
    assert cus_3.phone_number == "(626) 716-7523"
    assert cus_3.email == "zunigamarisela5@usc.edu"

    csv =
      customers
      |> SalonIris.to_csv

    assert csv == """
first_name,last_name,phone_number,email
Lacey,,3234831396,
Mary,,(818) 749-3154,alido.mary@gmail.com
Marisela,Zuniga,(626) 716-7523,zunigamarisela5@usc.edu
    """
  end
end
