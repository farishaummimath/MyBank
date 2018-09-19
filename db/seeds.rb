# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
    Employee.create(:first_name =>"admin" ,:last_name =>"user", :date_of_birth=>"1991-12-25", :address => "SOME", :contact_number=>434554654113, :manager => "1")
    
#=begin
    country_list = ["Afghanistan", "Albania", "Algeria", "Andorra", "Angola",
  
  "Antigua & Deps", "Argentina", "Armenia", "Australia",
  "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh",
  "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bhutan",
  "Bolivia", "Bosnia Herzegovina", "Botswana", "Brazil", "Brunei",
  "Bulgaria", "Burkina", "Burma", "Burundi", "Caicos", "Cambodia",
  "Cameroon", "Canada", "Cape Verde", "Central African Rep", "Chad",
  "Chile", "China", "Colombia", "Comoros", "Congo", "Congo {Democratic Rep}",
  "Cook Islands", "Costa Rica", "Croatia", "Cuba", "Cyprus", "Czech Republic",
  "Côte d'Ivoire", "Democratic People's Republic of Korea",
  "Democratic Republic of the Congo", "Denmark", "Djibouti",
  "Dominica", "Dominican Republic", "East Timor", "Ecuador", "Egypt",
  "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia",
  "Federation of Saint Kitts and Nevis", "Fiji", "Finland", "France",
  "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Greece", "Grenada",
  "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Honduras",
  "Hungary", "Iceland", "India", "Indonesia", "Iran", "Iraq", "Ireland {Republic}",
  "Israel", "Italy", "Ivory Coast", "Jamaica", "Japan", "Jordan", "Kazakhstan",
  "Kenya", "Kiribati", "Korea North", "Korea South", "Kosovo", "Kuwait", "Kyrgyzstan",
  "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Liechtenstein",
  "Lithuania", "Luxembourg", "Macedonia", "Madagascar", "Malawi", "Malaysia",
  "Maldives", "Mali", "Malta", "Marshall Islands", "Mauritania", "Mauritius", "Mexico",
  "Micronesia", "Moldova", "Monaco", "Mongolia", "Montenegro", "Morocco", "Mozambique",
  "Myanmar, {Burma}", "Nagorno-Karabakh", "Namibia", "Nauru", "Nepal", "Netherlands",
  "New Zealand", "Nicaragua", "Niger", "Nigeria", "Norway", "Oman", "Pakistan", "Palau",
  "Palestine", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Poland",
  "Portugal", "Qatar", "Republic of Korea", "Republic of the Congo", "Romania",
  "Russian Federation", "Rwanda", "Sahrawi Arab Democratic Republic", "Saint Lucia",
  "Saint Vincent & the Grenadines", "Samoa", "San Marino", "Sao Tome & Principe",
  "Saudi Arabia", "Senegal", "Serbia", "Seychelles", "Sierra Leone", "Singapore",
  "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "Spain",
  "Sri Lanka", "St Kitts & Nevis", "St Lucia", "Sudan", "Sudan, South", "Suriname",
  "Swaziland", "Sweden", "Switzerland", "Syria", "Taiwan", "Tajikistan", "Tanzania",
  "Thailand", "Timor-Leste", "Togo", "Tonga", "Transnistria", "Trinidad & Tobago",
  "Tunisia", "Turkey", "Turkmenistan", "Turks", "Tuvalu", "Uganda", "Ukraine",
  "United Arab Emirates", "United Kingdom", "United States", "Uruguay", "Uzbekistan",
  "Vanuatu", "Vatican City", "Venezuela", "Vietnam", "Yemen", "Zambia", "Zimbabwe"]
country_list.each do |name|
  Nationality.create( :name => name)
end
#=end
