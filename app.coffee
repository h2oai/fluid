#TODO code-gen
{ get, set, fire, add, remove, clear, event, isEvent, atom, isAtom, list, isList, length, bind, unbind, to, from, page, grid, cell, cell1, cell2, cell3, cell4, cell5, cell6, cell7, cell8, cell9, cell10, cell11, cell12, table, tr, th, td, div, span, card, tabs, tab, text, markup, markdown, menu, command, button, link, badge, textfield, textarea, checkbox, radio, slider } = window.fluid

#TODO code-gen
window.fluid.start (context, app) ->

  home = app.home

  # --- end codegen ---

  app.title 'Kitchen Sink'

  home.label 'Form Elements'

  heading = (string) -> markup "<h4>#{string}</h4>"
  strong = (string) ->  markup "<strong>#{string}</strong>"

  createExampleGrid = (elements) ->
    examples = []
    for element, i in elements when i % 2 is 0
      examples.push cell3 div (strong element), elements[i + 1]
    grid examples

  addSection = (title, examples) ->
    add app.page, grid cell heading title
    add app.page, createExampleGrid examples

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

    'Labeled Checkbox (On)'
    checkbox on, label: 'Check on'

    'Labeled Checkbox (Off)'
    checkbox off, label: 'Check off'

    'Switch (Off)'
    checkbox off, icon: 'switch'

    'Switch (On)'
    checkbox on, icon: 'switch'

    'Checkbox without label'
    checkbox label: ' '

    'Icon Toggle'
    checkbox icon: 'wifi'

    'Icon Toggle (On)'
    checkbox on, icon: 'bluetooth'

    'Icon Toggle (Off)'
    checkbox off, icon: 'favorite'

    'Radio (option1)'
    radio radioOptions, item: 'option1', label: 'Option 1'

    'Radio (option2)'
    radio radioOptions, item: 'option2', label: 'Option 2'

    'Radio (option3)'
    radio radioOptions, item: 'option3', label: 'Option 3'

    'Radio (option4)'
    radio radioOptions, item: 'option4', label: 'Option 4'

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
    textfield label: 'Message'

    'With Value and Label'
    textfield 'Hello!', label: 'Message'

    'Validating'
    textfield label: 'Zip Code', pattern: '[0-9]{5}', error: 'Invalid zip code'

    'Validating'
    textfield '55555', label: 'Zip Code', pattern: '[0-9]{5}', error: 'Invalid zip code'

    'Expandable'
    textfield icon:'search'

    'Expandable with Label'
    textfield icon:'search', label:'Cat pictures'

  ]

  addSection 'Textareas', [

    'Plain'
    textarea()

    'With Value'
    textarea 'Hello World!'

    'With Label'
    textarea label: 'Message'

    'With Rows'
    textarea 'Hello World!', rows: 5

  ]

  addSection 'Badges', [

    'Default'
    badge()

    'With Label'
    badge label: 'Inbox'

    'With Value'
    badge 5, label: 'Inbox'

    'With Icon'
    badge 3, icon: 'account_box'

  ]

  tablesPage = page label: 'Tables'
  add app.pages, tablesPage

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
  ], selectable: yes

