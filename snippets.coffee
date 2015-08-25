#---
app.title 'Hello World!'
#---
app.header.menu menu [
  command 'command1', -> print 'Hello from command1'
  command 'command2', -> print 'Hello from command2'
]
#---
add app.footer.buttons, button icon: 'search', -> print 'Search for...?'
#---
clear activePage
#---
# Given x, compute Math.log(x)
add activePage, block [
  text 'x ='
  x = textfield 1
  text 'log(x) = '
  text from x.value, Math.log
]
#---
add activePage, display4 'Display 4: Light 112px'
#---
add activePage, display3 'Display 3: Regular 56px'
#---
add activePage, display2 'Display 2: Regular 45px'
#---
add activePage, display1 'Display 1: Regular 34px'
#---
add activePage, display1 'Display 1: Color Contrast', alt: on
#---
add activePage, headline 'Headline: Regular 24px'
#---
add activePage, title 'Title: Medium 20px'
#---
add activePage, title 'Title: Color Contrast', alt: on
#---
add activePage, subhead 'Subhead: Regular 16px (Device), Regular 15px (Desktop)'
#---
add activePage, subhead 'Subhead: Color Contrast', alt: on
#---
add activePage, body2 'Body 2: Medium 14px (Device), Medium 13px (Desktop)'
#---
add activePage, body2 'Body 2 Color Contrast', alt: on
#---
add activePage, body1 'Body 1: Regular 14px (Device), Regular 13px (Desktop)'
#---
add activePage, caption 'Caption: Regular 12px'
#---
add activePage, caption 'Caption: Color Contrast', alt: on
#---
add activePage, body1 'Body 1: capitalize', capitalize: on
#---
add activePage, body1 'Body 1: lowercase', lowercase: on
#---
add activePage, body1 'Body 1: uppercase', uppercase: on
#---
add activePage, body1 'Body 1: center align', center: on
#---
add activePage, body1 'Body 1: justify', justify: on
#---
add activePage, body1 'Body 1: left align', left: on
#---
add activePage, body1 'Body 1: right align', right: on
#---
add activePage, body1 'Body 1: no wrap', wrap: off
#---
# Flat Button
button1 = button()
add activePage, button1
#---
# Flat (Disabled) Button
button1 = button disabled: yes
add activePage, button1
#---
# Flat Color Button
button1 = button color: 'primary'
add activePage, button1
#---
# Flat Color (Disabled) Button
button1 = button color: 'primary', disabled: yes
add activePage, button1
#---
# Flat Accent Button
button1 = button color: 'accent'
add activePage, button1
#---
# Flat Accent (Disabled) Button
button1 = button color: 'accent', disabled: yes
add activePage, button1
#---
# Raised Button
button1 = button type: 'raised'
add activePage, button1
#---
# Raised (Disabled) Button
button1 = button type: 'raised', disabled: yes
add activePage, button1
#---
# Raised Color Button
button1 = button type: 'raised', color: 'primary'
add activePage, button1
#---
# Raised Color (Disabled) Button
button1 = button type: 'raised', color: 'primary', disabled: yes
add activePage, button1
#---
# Raised Accent Button
button1 = button type: 'raised', color: 'accent'
add activePage, button1
#---
# Raised Accent (Disabled) Button
button1 = button type: 'raised', color: 'accent', disabled: yes
add activePage, button1
#---
# Icon Button
button1 = button icon: 'mood'
add activePage, button1
#---
# Icon (Disabled) Button
button1 = button icon: 'mood', disabled: yes
add activePage, button1
#---
# Icon Color Button
button1 = button icon: 'mood', color: 'primary'
add activePage, button1
#---
# Icon Color (Disabled) Button
button1 = button icon: 'mood', color: 'primary', disabled: yes
add activePage, button1
#---
# Icon Accent Button
button1 = button icon: 'mood', color: 'accent'
add activePage, button1
#---
# Icon Accent (Disabled) Button
button1 = button icon: 'mood', color: 'accent', disabled: yes
add activePage, button1
#---
# Plain FAB
button1 = button type: 'floating'
add activePage, button1
#---
# Plain (Disabled) FAB
button1 = button type: 'floating', disabled: yes
add activePage, button1
#---
# Color FAB
button1 = button type: 'floating', color: 'primary'
add activePage, button1
#---
# Color (Disabled) FAB
button1 = button type: 'floating', color: 'primary', disabled: yes
add activePage, button1
#---
# Plain Mini FAB
button1 = button size: 'small', type: 'floating'
add activePage, button1
#---
# Plain Mini (Disabled) FAB
button1 = button size: 'small', type: 'floating', disabled: yes
add activePage, button1
#---
# Color Mini FAB
button1 = button size: 'small', type: 'floating', color: 'primary'
add activePage, button1
#---
# Color Mini (Disabled) FAB
button1 = button size: 'small', type: 'floating', color: 'primary', disabled: yes
add activePage, button1
#---
# Plain with icon FAB
button1 = button type: 'floating', icon: 'camera'
add activePage, button1
#---
# Color with icon FAB
button1 = button type: 'floating', color: 'primary', icon: 'camera'
add activePage, button1
#---
# Plain Mini with icon FAB
button1 = button size: 'small', type: 'floating', icon: 'camera'
add activePage, button1
#---
# Color Mini with icon FAB
button1 = button size: 'small', type: 'floating', color: 'primary', icon: 'camera'
add activePage, button1
#---
# Checkbox
checkbox1 = checkbox()
add activePage, checkbox1
#---
# Checkbox with value
checkbox1 = checkbox value: on
add activePage, checkbox1
#---
# Checkbox (Off)
checkbox1 = checkbox off
add activePage, checkbox1
#---
# Checkbox (On)
checkbox1 = checkbox on
add activePage, checkbox1
#---
# Checkbox with title (On)
checkbox1 = checkbox on, title: 'Check on'
add activePage, checkbox1
#---
# Checkbox with title (Off)
checkbox1 = checkbox off, title: 'Check off'
add activePage, checkbox1
#---
# Switch (Off)
checkbox1 = checkbox off, icon: 'switch'
add activePage, checkbox1
#---
# Switch (On)
checkbox1 = checkbox on, icon: 'switch'
add activePage, checkbox1
#---
# Checkbox without title
checkbox1 = checkbox title: ' '
add activePage, checkbox1
#---
# Icon Toggle
checkbox1 = checkbox icon: 'wifi'
add activePage, checkbox1
#---
# Icon Toggle (On)
checkbox1 = checkbox on, icon: 'bluetooth'
add activePage, checkbox1
#---
# Icon Toggle (Off)
checkbox1 = checkbox off, icon: 'favorite'
add activePage, checkbox1
#---
# Radio buttons
radioOptions = atom 'option1'
radio1 = radio radioOptions, item: 'option1', title: 'Option 1'
radio2 = radio radioOptions, item: 'option2', title: 'Option 2'
radio3 = radio radioOptions, item: 'option3', title: 'Option 3'
radio4 = radio radioOptions, item: 'option4', title: 'Option 4'
add activePage, radio1, radio2, radio3, radio4
#---
# Slider
slider1 = slider()
add activePage, slider1
#---
# Slider (custom range)
slider1 = slider 150, min: 100, max: 200
add activePage, slider1
#---
# Textfield
textfield1 = textfield()
add activePage, textfield1
#---
# Textfield With Value
textfield1 = textfield 'Hello!'
add activePage, textfield1
#---
# Textfield With Title
textfield1 = textfield title: 'Message'
add activePage, textfield1
#---
# Textfield With Value and Title
textfield1 = textfield 'Hello!', title: 'Message'
add activePage, textfield1
#---
# Textfield Validation / Patterns
textfield1 = textfield title: 'Zip Code', pattern: '[0-9]{5}', error: 'Invalid zip code'
add activePage, textfield1
#---
# Textfield Validation / Patterns
textfield1 = textfield '55555', title: 'Zip Code', pattern: '[0-9]{5}', error: 'Invalid zip code'
add activePage, textfield1
#---
# Textfield - Expandable
textfield1 = textfield icon:'search'
add activePage, textfield1
#---
# Textfield - Expandable with Title
textfield1 = textfield icon:'search', title:'Cat pictures'
add activePage, textfield1
#---
# Textarea
textarea1 = textarea()
add activePage, textarea1
#---
# Textarea With Value
textarea1 = textarea 'Hello World!'
add activePage, textarea1
#---
# Textarea With Title
textarea1 = textarea title: 'Message'
add activePage, textarea1
#---
# Textarea With Rows
textarea1 = textarea 'Hello World!', rows: 5
add activePage, textarea1
#---
# Badge
badge1 = badge()
add activePage, badge1
#---
# Badge With Title
badge1 = badge title: 'Inbox'
add activePage, badge1
#---
# Badge With Value
badge1 = badge 5, title: 'Inbox'
add activePage, badge1
#---
# Badge With Icon
badge1 = badge 3, icon: 'account_box'
add activePage, badge1
#---
# Tabs
add activePage, tabset [
  tab faker.lorem.paragraph(), title: 'Acrylic'
  tab faker.lorem.paragraph(), title: 'Plywood'
  tab faker.lorem.paragraph(), title: 'Laminate'
]
#---
# Grid: 3 columns
add activePage, grid [
  cell4 faker.lorem.paragraph()
  cell4 faker.lorem.paragraph()
  cell4 faker.lorem.paragraph()
]
#---
# Grid: 4 columns
add activePage, grid [
  cell3 faker.lorem.paragraph()
  cell3 faker.lorem.paragraph()
  cell3 faker.lorem.paragraph()
  cell3 faker.lorem.paragraph()
]
#---
# Grid: 3 columns, sized 6, 4, 2
add activePage, grid [
  cell6 faker.lorem.paragraph()
  cell4 faker.lorem.paragraph()
  cell2 faker.lorem.paragraph()
]
#---
# Card
card1 = card faker.lorem.paragraph(),
  title: 'Card'
  buttons: [ button -> print 'Hello' ]
#---
# Card - with menu
card1 = card faker.lorem.paragraph(),
  title: 'Card'
  menu: menu [
    command 'command1', -> print 'command1'
    command 'command2', -> print 'command2'
  ]
  buttons: [ button 'Button', color: 'primary', -> print 'Hello' ]
#---
# Card - Auto width
card1 = card faker.lorem.paragraph(),
  title: 'Card'
  width: 'auto'
  buttons: [ button -> print 'Hello' ]
#---
# Card - Custom width
card1 = card 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris sagittis pellentesque lacus eleifend lacinia...',
  title: 'Welcome'
  height: 300
  width: 512
  color: 'white'
  image: 'sample.jpg'
  buttons: [ button 'Get Started', color: 'primary', -> print 'Welcome!' ]
#---
# Square Card
card1 = card 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenan convallis.',
  title: 'Updates'
  width: 320
  height: 320
  color: 'white'
  image: 'sample.jpg'
  buttons: [ button 'Get Updates', color: 'primary', -> print 'Welcome!' ]
#---
# Thumbnail
thumbnail1 = thumbnail 'sample.jpg', title: 'Spaceman'
add activePage, thumnail1
#---
# Table
table1 = table [
  tr [
    th 'Material'
    th 'Quantity'
    th 'Unit Price'
  ]
  tr [
    td 'Acrylic (Transparent)'
    td 25
    td '$2.90'
  ]
  tr [
    td 'Plywood (Birch)'
    td 50
    td '$1.25'
  ]
  tr [
    td 'Laminate (Gold on Blue)'
    td 10
    td '$2.35'
  ]
]
add activePage, table1
#---
# Selectable table
table1 = table selectable: yes, [
  tr [
    th 'Material'
    th 'Quantity'
    th 'Unit Price'
  ]
  tr [
    td 'Acrylic (Transparent)'
    td 25
    td '$2.90'
  ]
  tr [
    td 'Plywood (Birch)'
    td 50
    td '$1.25'
  ]
  tr [
    td 'Laminate (Gold on Blue)'
    td 10
    td '$2.35'
  ]
]
add activePage, table1
#---
# Indeterminate Progress Bar
progress1 = progress()
add activePage, progress1
#---
# Updatable Progress Bar
progress11 = progress1 = progress()
add activePage, progress11
add activePage, button 'Update', ->
  progress1.progress Math.floor Math.random() * 100
#---
# Spinner
spinner1 = spinner()
add activePage, spinner1
#---
# See https://www.google.com/design/icons/
add activePage, icon 'face', size: 'small'
#---
# See https://www.google.com/design/icons/
add activePage, icon 'face', size: 'medium'
#---
# See https://www.google.com/design/icons/
add activePage, icon 'face', size: 'large'
#---
# See https://www.google.com/design/icons/
add activePage, icon 'face', size: 'x-large'
#---
# See https://www.google.com/design/icons/
add activePage, icon 'face', disabled: yes
#---
# Markup / Mark up / Custom HTML
add activePage, markup "<div style='background:blue; color:white; padding:5px;'>I am blue</div>"
#---
# Inline styles
greenish = style background: 'green', color: 'white', padding: '5px'
greenishDiv = tags "div style='#{greenish}'"
add activePage, markup greenishDiv 'I am green'
#---
# CSS rules
reddish = css background: 'red', color: 'white', padding: '5px'
reddishDiv = tags ".#{reddish}"
add activePage, markup reddishDiv 'I am red'
#---
# Generate a fake zip code
faker.address.zipCode()
#---
# Generate a fake city
faker.address.city()
#---
# Generate a fake city prefix
faker.address.cityPrefix()
#---
# Generate a fake city suffix
faker.address.citySuffix()
#---
# Generate a fake street name
faker.address.streetName()
#---
# Generate a fake street address
faker.address.streetAddress()
#---
# Generate a fake street suffix
faker.address.streetSuffix()
#---
# Generate a fake street prefix
faker.address.streetPrefix()
#---
# Generate a fake secondary address
faker.address.secondaryAddress()
#---
# Generate a fake county
faker.address.county()
#---
# Generate a fake country
faker.address.country()
#---
# Generate a fake country code
faker.address.countryCode()
#---
# Generate a fake state
faker.address.state()
#---
# Generate a fake state abbr
faker.address.stateAbbr()
#---
# Generate a fake latitude
faker.address.latitude()
#---
# Generate a fake longitude
faker.address.longitude()
#---
# Generate a fake color
faker.commerce.color()
#---
# Generate a fake department
faker.commerce.department()
#---
# Generate a fake product name
faker.commerce.productName()
#---
# Generate a fake price
faker.commerce.price()
#---
# Generate a fake product adjective
faker.commerce.productAdjective()
#---
# Generate a fake product material
faker.commerce.productMaterial()
#---
# Generate a fake product
faker.commerce.product()
#---
# Generate fake company suffixes
faker.company.suffixes()
#---
# Generate a fake company name
faker.company.companyName()
#---
# Generate a fake company suffix
faker.company.companySuffix()
#---
# Generate a fake company catch phrase
faker.company.catchPhrase()
#---
# Generate some fake company bs
faker.company.bs()
#---
# Generate a fake company catch phrase adjective
faker.company.catchPhraseAdjective()
#---
# Generate a fake company catch phrase descriptor
faker.company.catchPhraseDescriptor()
#---
# Generate a fake company catch phrase noun
faker.company.catchPhraseNoun()
#---
# Generate a fake company bs adjective
faker.company.bsAdjective()
#---
# Generate a fake company bs buzz
faker.company.bsBuzz()
#---
# Generate a fake company bs noun
faker.company.bsNoun()
#---
# Generate a fake past date
faker.date.past()
#---
# Generate a fake future date
faker.date.future()
#---
# Generate a fake date between
faker.date.between()
#---
# Generate a fake recent date
faker.date.recent()
#---
# Generate a fake month
faker.date.month()
#---
# Generate a fake weekday
faker.date.weekday()
#---
# Generate a fake account
faker.finance.account()
#---
# Generate a fake account name
faker.finance.accountName()
#---
# Generate a fake mask
faker.finance.mask()
#---
# Generate a fake amount
faker.finance.amount()
#---
# Generate a fake transaction type
faker.finance.transactionType()
#---
# Generate a fake currency code
faker.finance.currencyCode()
#---
# Generate a fake currency name
faker.finance.currencyName()
#---
# Generate a fake currency symbol
faker.finance.currencySymbol()
#---
# Generate a fake abbreviation
faker.hacker.abbreviation()
#---
# Generate a fake adjective
faker.hacker.adjective()
#---
# Generate a fake noun
faker.hacker.noun()
#---
# Generate a fake verb
faker.hacker.verb()
#---
# Generate a fake ingverb
faker.hacker.ingverb()
#---
# Generate a fake phrase
faker.hacker.phrase()
#---
# Randomize
faker.helpers.randomize()
#---
# Slugify
faker.helpers.slugify()
#---
# Replace symbol with number
faker.helpers.replaceSymbolWithNumber()
#---
# Replace symbols
faker.helpers.replaceSymbols()
#---
# Shuffle
faker.helpers.shuffle()
#---
# Generate a fake image
faker.image.image()
#---
# Generate a fake avatar
faker.image.avatar()
#---
# Generate a fake image URL
faker.image.imageUrl()
#---
# Generate a fake image abstract
faker.image.abstract()
#---
# Generate a fake animal image
faker.image.animals()
#---
# Generate a fake business image
faker.image.business()
#---
# Generate a fake cat image
faker.image.cats()
#---
# Generate a fake city image
faker.image.city()
#---
# Generate a fake food image
faker.image.food()
#---
# Generate a fake nightlife image
faker.image.nightlife()
#---
# Generate a fake fashion image
faker.image.fashion()
#---
# Generate a fake people image
faker.image.people()
#---
# Generate a fake nature image
faker.image.nature()
#---
# Generate a fake sports image
faker.image.sports()
#---
# Generate a fake technics image
faker.image.technics()
#---
# Generate a fake transport image
faker.image.transport()
#---
# Generate a fake avatar
faker.internet.avatar()
#---
# Generate a fake email
faker.internet.email()
#---
# Generate a fake user name
faker.internet.userName()
#---
# Generate a fake protocol
faker.internet.protocol()
#---
# Generate a fake url
faker.internet.url()
#---
# Generate a fake domain name
faker.internet.domainName()
#---
# Generate a fake domain suffix
faker.internet.domainSuffix()
#---
# Generate a fake domain word
faker.internet.domainWord()
#---
# Generate a fake IP address
faker.internet.ip()
#---
# Generate a fake user agent
faker.internet.userAgent()
#---
# Generate a fake color
faker.internet.color()
#---
# Generate a fake mac address
faker.internet.mac()
#---
# Generate a fake password
faker.internet.password()
#---
# Generate fake words
faker.lorem.words()
#---
# Generate a fake sentence
faker.lorem.sentence()
#---
# Generate fake sentences
faker.lorem.sentences()
#---
# Generate a fake paragraph
faker.lorem.paragraph()
#---
# Generate fake paragraphs
faker.lorem.paragraphs()
#---
# Generate a fake first name
faker.name.firstName()
#---
# Generate a fake last name
faker.name.lastName()
#---
# Generate a fake find name
faker.name.findName()
#---
# Generate a fake job title
faker.name.jobTitle()
#---
# Generate a fake name prefix
faker.name.prefix()
#---
# Generate a fake name suffix
faker.name.suffix()
#---
# Generate a fake name title
faker.name.title()
#---
# Generate a fake job descriptor
faker.name.jobDescriptor()
#---
# Generate a fake job area
faker.name.jobArea()
#---
# Generate a fake job type
faker.name.jobType()
#---
# Generate a fake phone number
faker.phone.phoneNumber()
#---
# Generate a fake phone number format
faker.phone.phoneNumberFormat()
#---
# Generate fake phone formats
faker.phone.phoneFormats()
#---
# Generate a random number
faker.random.number()
#---
# Generate a fake array element
faker.random.arrayElement()
#---
# Generate a fake object element
faker.random.objectElement()
#---
# Generate a fake UUID
faker.random.uuid()
#---
# Generate a random boolean
faker.random.boolean()
