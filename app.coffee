#TODO code-gen
{ get, set, fire, add, remove, clear, action, isAction, atom, isAtom, list, isList, length, bind, unbind, to, from, page, grid, cell, cell1, cell2, cell3, cell4, cell5, cell6, cell7, cell8, cell9, cell10, cell11, cell12, table, tr, th, td, div, span, card, thumbnail, tabs, tab, text, markup, markdown, menu, command, button, link, badge, textfield, textarea, checkbox, radio, slider, tags, style, rule } = window.fluid

#TODO code-gen
window.fluid.start (context, app, home) ->
  app.title 'Kitchen Sink'

  add app.footer.buttons, button icon: 'search', -> console.log 'foo'
  add app.pages, formPage = page title: 'Form Elements'

  heading = (string) -> markup "<h4>#{string}</h4>"
  strong = (string) ->  markup "<strong>#{string}</strong>"

  createExampleGrid = (elements) ->
    examples = []
    for element, i in elements when i % 2 is 0
      examples.push cell3 div (strong element), elements[i + 1]
    grid examples

  addSection = (title, examples) ->
    add formPage, grid cell heading title
    add formPage, createExampleGrid examples

  addSection 'Buttons', [

    'Flat'
    button()

    'Flat (Disabled)'
    button disabled: yes

    'Flat Color'
    button color: 'primary'

    'Flat Color (Disabled)'
    button color: 'primary', disabled: yes

    'Flat Accent'
    button color: 'accent'

    'Flat Accent (Disabled)'
    button color: 'accent', disabled: yes

    'Raised'
    button type: 'raised'

    'Raised (Disabled)'
    button type: 'raised', disabled: yes

    'Raised Color'
    button type: 'raised', color: 'primary'

    'Raised Color (Disabled)'
    button type: 'raised', color: 'primary', disabled: yes

    'Raised Accent'
    button type: 'raised', color: 'accent'

    'Raised Accent (Disabled)'
    button type: 'raised', color: 'accent', disabled: yes

    'Icon'
    button icon: 'mood'

    'Icon (Disabled)'
    button icon: 'mood', disabled: yes

    'Icon Color'
    button icon: 'mood', color: 'primary'

    'Icon Color (Disabled)'
    button icon: 'mood', color: 'primary', disabled: yes

    'Icon Accent'
    button icon: 'mood', color: 'accent'

    'Icon Accent (Disabled)'
    button icon: 'mood', color: 'accent', disabled: yes
  ] 

  addSection 'FABs', [

    'Plain'
    button type: 'floating'

    'Plain (Disabled)'
    button type: 'floating', disabled: yes

    'Color'
    button type: 'floating', color: 'primary'

    'Color (Disabled)'
    button type: 'floating', color: 'primary', disabled: yes

    'Plain Mini'
    button size: 'small', type: 'floating'

    'Plain Mini (Disabled)'
    button size: 'small', type: 'floating', disabled: yes

    'Color Mini'
    button size: 'small', type: 'floating', color: 'primary'

    'Color Mini (Disabled)'
    button size: 'small', type: 'floating', color: 'primary', disabled: yes

    'Plain with icon'
    button type: 'floating', icon: 'camera'

    'Color with icon'
    button type: 'floating', color: 'primary', icon: 'camera'

    'Plain Mini with icon'
    button size: 'small', type: 'floating', icon: 'camera'

    'Color Mini with icon'
    button size: 'small', type: 'floating', color: 'primary', icon: 'camera'
  ]

  radioOptions = atom 'option1'

  addSection 'Toggles', [

    'Checkbox'
    checkbox()

    'Checkbox with value'
    checkbox value: on

    'Checkbox (Off)'
    checkbox off

    'Checkbox (On)'
    checkbox on

    'Checkbox with title (On)'
    checkbox on, title: 'Check on'

    'Checkbox with title (Off)'
    checkbox off, title: 'Check off'

    'Switch (Off)'
    checkbox off, icon: 'switch'

    'Switch (On)'
    checkbox on, icon: 'switch'

    'Checkbox without title'
    checkbox title: ' '

    'Icon Toggle'
    checkbox icon: 'wifi'

    'Icon Toggle (On)'
    checkbox on, icon: 'bluetooth'

    'Icon Toggle (Off)'
    checkbox off, icon: 'favorite'

    'Radio (option1)'
    radio radioOptions, item: 'option1', title: 'Option 1'

    'Radio (option2)'
    radio radioOptions, item: 'option2', title: 'Option 2'

    'Radio (option3)'
    radio radioOptions, item: 'option3', title: 'Option 3'

    'Radio (option4)'
    radio radioOptions, item: 'option4', title: 'Option 4'

  ]

  addSection 'Sliders', [

    'Slider'
    slider()

    'Slider (custom range)'
    slider 150, min: 100, max: 200

  ]

  addSection 'Textfields', [

    'Plain'
    textfield()

    'With Value'
    textfield 'Hello!'

    'With Value'
    textfield title: 'Message'

    'With Value and Title'
    textfield 'Hello!', title: 'Message'

    'Validating'
    textfield title: 'Zip Code', pattern: '[0-9]{5}', error: 'Invalid zip code'

    'Validating'
    textfield '55555', title: 'Zip Code', pattern: '[0-9]{5}', error: 'Invalid zip code'

    'Expandable'
    textfield icon:'search'

    'Expandable with Title'
    textfield icon:'search', title:'Cat pictures'

  ]

  addSection 'Textareas', [

    'Plain'
    textarea()

    'With Value'
    textarea 'Hello World!'

    'With Title'
    textarea title: 'Message'

    'With Rows'
    textarea 'Hello World!', rows: 5

  ]

  addSection 'Badges', [

    'Default'
    badge()

    'With Title'
    badge title: 'Inbox'

    'With Value'
    badge 5, title: 'Inbox'

    'With Icon'
    badge 3, icon: 'account_box'

  ]

  lorem = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu."


  add app.pages, tabsPage = page title: 'Tabs'
  add tabsPage, grid cell heading 'Tabs'
  add tabsPage, grid cell tabs [
    tab "Acrylic: #{lorem}", title: 'Acrylic'
    tab "Plywood: #{lorem}", title: 'Plywood'
    tab "Laminate: #{lorem}", title: 'Laminate'
  ]


  add app.pages, gridsPage = page title: 'Grids'
  add gridsPage, grid cell heading 'Grids'
  sample = (title) -> markup "<div style='padding:5px;color:white;background:#aaa;height:75px'>#{title}</div"

  add gridsPage, grid cell strong '1 x 12'
  add gridsPage, grid [
    cell1 sample 1
    cell1 sample 1
    cell1 sample 1
    cell1 sample 1
    cell1 sample 1
    cell1 sample 1
    cell1 sample 1
    cell1 sample 1
    cell1 sample 1
    cell1 sample 1
    cell1 sample 1
    cell1 sample 1
  ]

  add gridsPage, grid cell strong '3 x 4'
  add gridsPage, grid [
    cell3 sample 3
    cell3 sample 3
    cell3 sample 3
    cell3 sample 3
  ]

  add gridsPage, grid cell strong '4 x 3'
  add gridsPage, grid [
    cell4 sample 4
    cell4 sample 4
    cell4 sample 4
  ]

  add gridsPage, grid cell strong '6-4-2'
  add gridsPage, grid [
    cell6 sample 6
    cell4 sample 4
    cell2 sample 2
  ]

  add app.pages, cardsPage = page title: 'Cards'
  add cardsPage, grid cell heading 'Cards'

  add cardsPage, grid cell strong 'Basic'
  add cardsPage, grid cell card lorem,  
    title: 'Card'
    buttons: [ button -> console.log 'Hello' ]

  add cardsPage, grid cell strong 'With Menu'
  add cardsPage, grid cell card lorem,  
    title: 'Card'
    menu: menu [
      command 'command1', -> console.log 'command1'
      command 'command2', -> console.log 'command2'
    ]
    buttons: [ button 'Button', color: 'primary', -> console.log 'Hello' ]

  add cardsPage, grid cell strong 'Auto-width'
  add cardsPage, grid cell card lorem,
    title: 'Card'
    width: 'auto'
    buttons: [ button -> console.log 'Hello' ]

  add cardsPage, grid cell strong 'Custom width'
  add cardsPage, grid cell card 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris sagittis pellentesque lacus eleifend lacinia...',  
    title: 'Welcome'
    height: 300
    width: 512
    color: 'white'
    image: 'sample.jpg'
    buttons: [ button 'Get Started', color: 'primary', -> console.log 'Welcome!' ]

  add cardsPage, grid cell strong 'Square'
  add cardsPage, grid cell card 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenan convallis.',  
    title: 'Updates'
    width: 320
    height: 320
    color: 'white'
    image: 'sample.jpg'
    buttons: [ button 'Get Updates', color: 'primary', -> console.log 'Welcome!' ]


  add cardsPage, grid cell strong 'Thumbnail'
  add cardsPage, grid cell thumbnail 'sample.jpg', title: 'Spaceman'

  add app.pages, tablesPage = page title: 'Tables'

  add tablesPage, grid cell heading 'Tables'
  add tablesPage, grid cell strong 'Table'
  add tablesPage, grid cell table [
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

  add tablesPage, grid cell strong 'Selectable Table'
  add tablesPage, grid cell table selectable: yes, [
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

  add app.pages, customPage = page title: 'Custom'

  # Markup
  add customPage, markup "<div style='background:blue; color:white; padding:5px;'>I am blue</div>"

  # Inline styles
  greenish = style background: 'green', color: 'white', padding: '5px' 
  greenishDiv = tags "div style='#{greenish}'"
  add customPage, markup greenishDiv 'I am green'

  # CSS rules
  reddish = rule background: 'red', color: 'white', padding: '5px'
  reddishDiv = tags ".#{reddish}"
  add customPage, markup reddishDiv 'I am red'

