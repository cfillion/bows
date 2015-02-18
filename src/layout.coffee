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

  createPage: (identifier) ->
    return page if page = @findPage(identifier)

    page = new Page identifier
    @addPage page

    page

  addPage: (page) ->
    index = @tabbar.addTab page.name

    page.on 'nameChanged', (newName) =>
      @tabbar.renameTab index, newName
      return

    page.on 'alertCountChanged', (count) =>
      @tabbar.setAlertCount index, count if index != @currentIndex
      return

    page.on 'input', (text) =>
      @emit 'input', text, page
      return

    @pages.push page
    @container.appendChild page.node

    index

  setCurrentPage: (index) ->
    @tabbar.setCurrentTab index
    return

  currentTabChanged: (newIndex) ->
    return unless page = @pages[newIndex]

    if oldPage = @pages[@currentIndex]
      Utils.removeClass 'current', oldPage.node

    Utils.addClass 'current', page.node
    page.focus()

    @currentIndex = newIndex
    return

  closePage: (index) ->
    index = @indexOf index if index instanceof Page
    return unless page = @pages[index]

    @tabbar.removeTab index
    @container.removeChild page.node

    # don't resize the array
    @pages[index] = false

    @emit 'pageClosed', page

    newIndex = @findNeighbor(index)
    @setCurrentPage newIndex unless newIndex == undefined

    return

  findNeighbor: (index) ->
    # search a valid neighbour index first to the left and then to the right
    for testIndex in [(index - 1)...-@pages.length]
      testIndex = Math.abs testIndex
      return testIndex if @pages[testIndex]

    undefined

  indexOf: (page) ->
    @pages.indexOf page

module.exports = Layout
