#TODO code-gen
{ get, set, fire, add, remove, clear, action, isAction, atom, isAtom, list, isList, length, bind, unbind, to, from, page, grid, cell, cell1, cell2, cell3, cell4, cell5, cell6, cell7, cell8, cell9, cell10, cell11, cell12, table, tr, th, td, block, inline, card, spinner, progress, thumbnail, tabset, tab, text, markup, markdown, menu, command, button, link, badge, icon, textfield, textarea, checkbox, radio, slider, tags, style, rule, display4, display3, display2, display1, headline, title, subhead, body2, body1, caption, extend, print } = window.fluid

#TODO code-gen
window.fluid.start (context, app, home) ->
  lorem = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu."

  app.title 'Kitchen Sink'

  app.header.menu menu [
    command 'command1', -> print 'command1'
    command 'command2', -> print 'command2'
  ]
  add app.footer.buttons, button icon: 'search', -> print 'foo'

  home.items [
  ]

  add app.pages, typographyPage = page title: 'Typography', items: [
    display4 'Display 4: Light 112px'
    display3 'Display 3: Regular 56px'
    display2 'Display 2: Regular 45px'
    display1 'Display 1: Regular 34px'
    display1 'Display 1: Color Contrast', alt: on
    headline 'Headline: Regular 24px'
    title 'Title: Medium 20px'
    title 'Title: Color Contrast', alt: on
    subhead 'Subhead: Regular 16px (Device), Regular 15px (Desktop)'
    subhead 'Subhead: Color Contrast', alt: on
    body2 'Body 2: Medium 14px (Device), Medium 13px (Desktop)'
    body2 'Body 2 Color Contrast', alt: on
    body1 'Body 1: Regular 14px (Device), Regular 13px (Desktop)'
    caption 'Caption: Regular 12px'
    caption 'Caption: Color Contrast', alt: on
    body1 'Body 1: capitalize', capitalize: on
    body1 'Body 1: lowercase', lowercase: on
    body1 'Body 1: uppercase', uppercase: on
    body1 'Body 1: center align', center: on
    body1 'Body 1: justify', justify: on
    body1 'Body 1: left align', left: on
    body1 'Body 1: right align', right: on
    body1 'Body 1: no wrap', wrap: off
  ]

  allIcons = [
    '3d_rotation'
    'accessibility'
    'account_balance'
    'account_balance_wallet'
    'account_box'
    'account_circle'
    'add_shopping_cart'
    'alarm'
    'alarm_add'
    'alarm_off'
    'alarm_on'
    'android'
    'announcement'
    'aspect_ratio'
    'assessment'
    'assignment'
    'assignment_ind'
    'assignment_late'
    'assignment_return'
    'assignment_returned'
    'assignment_turned_in'
    'autorenew'
    'backup'
    'book'
    'bookmark'
    'bookmark_border'
    'bug_report'
    'build'
    'cached'
    'camera_enhance'
    'card_giftcard'
    'card_membership'
    'card_travel'
    'change_history'
    'check_circle'
    'chrome_reader_mode'
    'class'
    'code'
    'credit_card'
    'dashboard'
    'delete'
    'description'
    'dns'
    'done'
    'done_all'
    'eject'
    'event'
    'event_seat'
    'exit_to_app'
    'explore'
    'extension'
    'face'
    'favorite'
    'favorite_border'
    'feedback'
    'find_in_page'
    'find_replace'
    'flight_land'
    'flight_takeoff'
    'flip_to_back'
    'flip_to_front'
    'get_app'
    'gif'
    'grade'
    'group_work'
    'help'
    'help_outline'
    'highlight_off'
    'history'
    'home'
    'hourglass_empty'
    'hourglass_full'
    'http'
    'https'
    'info'
    'info_outline'
    'input'
    'invert_colors'
    'label'
    'label_outline'
    'language'
    'launch'
    'list'
    'lock'
    'lock_open'
    'lock_outline'
    'loyalty'
    'markunread_mailbox'
    'note_add'
    'offline_pin'
    'open_in_browser'
    'open_in_new'
    'open_with'
    'pageview'
    'payment'
    'perm_camera_mic'
    'perm_contact_calendar'
    'perm_data_setting'
    'perm_device_information'
    'perm_identity'
    'perm_media'
    'perm_phone_msg'
    'perm_scan_wifi'
    'picture_in_picture'
    'play_for_work'
    'polymer'
    'power_settings_new'
    'print'
    'query_builder'
    'question_answer'
    'receipt'
    'redeem'
    'reorder'
    'report_problem'
    'restore'
    'room'
    'schedule'
    'search'
    'settings'
    'settings_applications'
    'settings_backup_restore'
    'settings_bluetooth'
    'settings_brightness'
    'settings_cell'
    'settings_ethernet'
    'settings_input_antenna'
    'settings_input_component'
    'settings_input_composite'
    'settings_input_hdmi'
    'settings_input_svideo'
    'settings_overscan'
    'settings_phone'
    'settings_power'
    'settings_remote'
    'settings_voice'
    'shop'
    'shop_two'
    'shopping_basket'
    'shopping_cart'
    'speaker_notes'
    'spellcheck'
    'star_rate'
    'stars'
    'store'
    'subject'
    'supervisor_account'
    'swap_horiz'
    'swap_vert'
    'swap_vertical_circle'
    'system_update_alt'
    'tab'
    'tab_unselected'
    'theaters'
    'thumb_down'
    'thumb_up'
    'thumbs_up_down'
    'toc'
    'today'
    'toll'
    'track_changes'
    'translate'
    'trending_down'
    'trending_flat'
    'trending_up'
    'turned_in'
    'turned_in_not'
    'verified_user'
    'view_agenda'
    'view_array'
    'view_carousel'
    'view_column'
  ]

  add app.pages, iconsPage = page title: 'Icons', [
    title 'Icons'

    subhead 'Icon sizes'
    grid ['small', 'medium', 'large', 'x-large'].map (size) ->
      cell2 block [
        icon 'face', size: size
        caption size
      ]

    subhead 'Icon state'
    grid [
      cell2 block [
        icon 'face', size: 'x-large'
        caption 'active'
      ]
      cell2 block [
        icon 'face', size: 'x-large', disabled: yes
        caption 'inactive'
      ]
    ]

    subhead 'All Icons'
    grid allIcons.map (name) ->
      cell2 block [
        icon name, size: 'x-large'
        caption name
      ]
  ]

  add app.pages, formPage = page title: 'Controls'

  createExampleGrid = (elements) ->
    examples = []
    for element, i in elements when i % 2 is 0
      examples.push cell3 block [
        elements[i + 1]
        caption element
      ]
    grid examples

  addSection = (name, examples) ->
    add formPage, grid cell title name
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

  add app.pages, tabsPage = page title: 'Tabs'
  add tabsPage, grid cell title 'Tabs'
  add tabsPage, grid cell tabset [
    tab "Acrylic: #{lorem}", title: 'Acrylic'
    tab "Plywood: #{lorem}", title: 'Plywood'
    tab "Laminate: #{lorem}", title: 'Laminate'
  ]

  add app.pages, gridsPage = page title: 'Grids'
  add gridsPage, grid cell headline 'Grids'
  sample = (title) -> markup "<div style='padding:5px;color:white;background:#aaa;height:75px'>#{title}</div"

  add gridsPage, grid cell title '1 x 12'
  add gridsPage, grid [1 .. 12].map -> cell1 sample 1

  add gridsPage, grid cell title '3 x 4'
  add gridsPage, grid [1 .. 4].map -> cell3 sample 3

  add gridsPage, grid cell title '4 x 3'
  add gridsPage, grid [1 .. 3].map -> cell4 sample 4

  add gridsPage, grid cell title '6-4-2'
  add gridsPage, grid [
    cell6 sample 6
    cell4 sample 4
    cell2 sample 2
  ]

  add app.pages, cardsPage = page title: 'Cards'
  add cardsPage, grid cell headline 'Cards'

  add cardsPage, grid cell title 'Basic'
  add cardsPage, grid cell card lorem,  
    title: 'Card'
    buttons: [ button -> print 'Hello' ]

  add cardsPage, grid cell title 'With Menu'
  add cardsPage, grid cell card lorem,  
    title: 'Card'
    menu: menu [
      command 'command1', -> print 'command1'
      command 'command2', -> print 'command2'
    ]
    buttons: [ button 'Button', color: 'primary', -> print 'Hello' ]

  add cardsPage, grid cell title 'Auto-width'
  add cardsPage, grid cell card lorem,
    title: 'Card'
    width: 'auto'
    buttons: [ button -> print 'Hello' ]

  add cardsPage, grid cell title 'Custom width'
  add cardsPage, grid cell card 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris sagittis pellentesque lacus eleifend lacinia...',  
    title: 'Welcome'
    height: 300
    width: 512
    color: 'white'
    image: 'sample.jpg'
    buttons: [ button 'Get Started', color: 'primary', -> print 'Welcome!' ]

  add cardsPage, grid cell title 'Square'
  add cardsPage, grid cell card 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenan convallis.',  
    title: 'Updates'
    width: 320
    height: 320
    color: 'white'
    image: 'sample.jpg'
    buttons: [ button 'Get Updates', color: 'primary', -> print 'Welcome!' ]


  add cardsPage, grid cell title 'Thumbnail'
  add cardsPage, grid cell thumbnail 'sample.jpg', title: 'Spaceman'

  add app.pages, tablesPage = page title: 'Tables', [
    subhead 'Tables'
    table [
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

    caption 'Plain Table'
    table selectable: yes, [
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
    caption 'Selectable Table'
  ]

  add app.pages, page title: 'Progress', [
    title 'Progress Bars and Spinners'

    subhead 'Indeterminate Progress Bar'
    progress()

    subhead 'Updatable Progress Bar'
    block [
      progress1 = progress()
      progress1Button = button 'Update', ->
        progress1.progress Math.floor Math.random() * 100
    ]

    subhead 'Spinner'
    block spinner()
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

