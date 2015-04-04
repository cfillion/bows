EventEmitter = require './event_emitter'

Page = require './page'
StatusBar = require './statusbar'
TabBar = require './tabbar'
Utils = require './utils'

class Layout extends EventEmitter
  constructor: ->
    @pages = []
    @currentIndex = -1

    @root = document.getElementById Utils.prefix('root')
    Utils.clearNode @root

    @tabbar = new TabBar
    @root.appendChild @tabbar.node

    @tabbar.on 'currentChanged', (newIndex) =>
      @currentTabChanged newIndex
      return

    @tabbar.on 'closeRequested', (index) =>
      @closePage index
      return

    @container = Utils.createNode 'div', 'container'
    @root.appendChild @container

    @statusbar = new StatusBar
    @root.appendChild @statusbar.node

  findPage: (identifier) ->
    for page in @pages
      return page if page && page.identifier == identifier

    undefined

  createPage: (identifier, markAsRead = false) ->
    return page if page = @findPage(identifier)

    page = new Page identifier
    @addPage page, markAsRead

    page

  addPage: (page, markAsRead = false) ->
    index = @tabbar.addTab page.name
    @tabbar.markAsRead index if markAsRead

    page.on 'nameChanged', (newName) =>
      @tabbar.renameTab index, newName
      return

    page.on 'alertCountChanged', (count) =>
      @tabbar.setAlertCount index, count

      return

    page.on 'input', (text) =>
      @emit 'input', text, page
      return

    @pages.push page
    @container.appendChild page.node

    @setCurrentPage index if @autoFocus == page.identifier

    index

  setCurrentPage: (index) ->
    index = @resolveIndex index
    @tabbar.setCurrentTab index
    return

  currentTabChanged: (newIndex) ->
    return if @currentIndex == newIndex

    @pages[@currentIndex]?.blur() # previous page
    @pages[newIndex].focus()

    @currentIndex = newIndex

    return

  closePage: (index) ->
    index = @resolveIndex index
    return unless page = @pages[index]

    @tabbar.removeTab index
    @container.removeChild page.node

    # the timout prevents the page from being immediately reopened
    # (otherwise rooms would be un-closable when joined)
    window.setTimeout =>
      # clear memory without resizing the array (thus keeping the index reserved)
      @pages[index] = null
    , 1000

    page.isClosed = true
    @emit 'pageClosed', page

    newIndex = @findNeighbor index
    @setCurrentPage newIndex unless newIndex == undefined

    return

  findNeighbor: (index) ->
    # search a valid neighbour index first to the left and then to the right
    for testIndex in [(index - 1)...-@pages.length]
      testIndex = Math.abs testIndex
      page = @pages[testIndex]
      return testIndex if page && !page.isClosed

    undefined

  indexOf: (page) ->
    @pages.indexOf page

  delayFocus: (identifier) ->
    @autoFocus = identifier

    window.setTimeout =>
      @autoFocus = null if @autoFocus == identifier
    , 1000

  setClosable: (index, boolean) ->
    index = @resolveIndex index
    @tabbar.setClosable index, boolean

    return

  isClosable: (index) ->
    index = @resolveIndex index
    @tabbar.isClosable index

  resolveIndex: (index) ->
    if index instanceof Page
      @indexOf index
    else
      index

module.exports = Layout
