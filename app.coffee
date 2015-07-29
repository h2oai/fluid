#TODO code-gen
{ get, set, fire, add, remove, clear, event, isEvent, atom, isAtom, list, isList, length, bind, unbind, to, from, page, grid, cell, cell1, cell2, cell3, cell4, cell5, cell6, cell7, cell8, cell9, cell10, cell11, cell12, div, span, card, tabs, tab, text, markup, markdown, menu, command, button, link, badge, textfield, textarea, checkbox, radio, slider } = window.fluid

#TODO code-gen
window.fluid.start (context, app) ->
  app.title 'Kitchen Sink'

  heading = (string) -> markup "<h4>#{string}</h4>"
  title = (string) ->  markup "<strong>#{string}</strong>"

  createExampleGrid = (elements) ->
    examples = []
    for element, i in elements when i % 2 is 0
      examples.push cell3 div element, elements[i + 1]
    grid examples

  addSection = (title, examples) ->
    add app.page, grid cell heading title
    add app.page, createExampleGrid examples

  addSection 'Buttons', [

    title 'Plain FAB'
    button type: 'floating'

    title 'Plain FAB (Disabled)'
    button type: 'floating', disabled: yes

    title 'Color FAB'
    button type: 'floating', color: 'primary'

    title 'Color FAB (Disabled)'
    button type: 'floating', color: 'primary', disabled: yes

    title 'Plain Mini FAB'
    button size: 'small', type: 'floating'

    title 'Plain Mini FAB (Disabled)'
    button size: 'small', type: 'floating', disabled: yes

    title 'Color Mini FAB'
    button size: 'small', type: 'floating', color: 'primary'

    title 'Color Mini FAB (Disabled)'
    button size: 'small', type: 'floating', color: 'primary', disabled: yes

    title 'Plain FAB with icon'
    button type: 'floating', icon: 'camera'

    title 'Color FAB with icon'
    button type: 'floating', color: 'primary', icon: 'camera'

    title 'Plain Mini FAB with icon'
    button size: 'small', type: 'floating', icon: 'camera'

    title 'Color Mini FAB with icon'
    button size: 'small', type: 'floating', color: 'primary', icon: 'camera'

    title 'Flat Button'
    button()

    title 'Flat Button (Disabled)'
    button disabled: yes

    title 'Flat Color Button'
    button color: 'primary'

    title 'Flat Color Button (Disabled)'
    button color: 'primary', disabled: yes

    title 'Flat Accent Button'
    button color: 'accent'

    title 'Flat Accent Button (Disabled)'
    button color: 'accent', disabled: yes

    title 'Raised Button'
    button type: 'raised'

    title 'Raised Button (Disabled)'
    button type: 'raised', disabled: yes

    title 'Raised Color Button'
    button type: 'raised', color: 'primary'

    title 'Raised Color Button (Disabled)'
    button type: 'raised', color: 'primary', disabled: yes

    title 'Raised Accent Button'
    button type: 'raised', color: 'accent'

    title 'Raised Accent Button (Disabled)'
    button type: 'raised', color: 'accent', disabled: yes

    title 'Icon Button'
    button icon: 'mood'

    title 'Icon Button (Disabled)'
    button icon: 'mood', disabled: yes

    title 'Icon Color Button'
    button icon: 'mood', color: 'primary'

    title 'Icon Color Button (Disabled)'
    button icon: 'mood', color: 'primary', disabled: yes

    title 'Icon Accent Button'
    button icon: 'mood', color: 'accent'

    title 'Icon Accent Button (Disabled)'
    button icon: 'mood', color: 'accent', disabled: yes
  ] 

  radioOptions = atom 'option1'

  addSection 'Toggles', [
    title 'Checkbox'
    checkbox()
    title 'Checkbox with value'
    checkbox value: on
    title 'Checkbox (Off)'
    checkbox off
    title 'Checkbox (On)'
    checkbox on
    title 'Labeled Checkbox (On)'
    checkbox on, label: 'Check on'
    title 'Labeled Checkbox (Off)'
    checkbox off, label: 'Check off'
    title 'Switch (Off)'
    checkbox off, icon: 'switch'
    title 'Switch (On)'
    checkbox on, icon: 'switch'
    title 'Checkbox without label'
    checkbox label: ' '
    title 'Icon Toggle'
    checkbox icon: 'wifi'
    title 'Icon Toggle (On)'
    checkbox on, icon: 'bluetooth'
    title 'Icon Toggle (Off)'
    checkbox off, icon: 'favorite'
    title 'Radio (option1)'
    radio radioOptions, item: 'option1', label: 'Option 1'
    title 'Radio (option2)'
    radio radioOptions, item: 'option2', label: 'Option 2'
    title 'Radio (option3)'
    radio radioOptions, item: 'option3', label: 'Option 3'
    title 'Radio (option4)'
    radio radioOptions, item: 'option4', label: 'Option 4'
  ]

