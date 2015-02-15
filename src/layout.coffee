EventEmitter = require './event_emitter'

Page = require './page'
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
      if oldPage = @pages[@currentIndex]
        Utils.removeClass 'current', oldPage.node

      Utils.addClass 'current', @pages[newIndex].node
      @pages[newIndex].resetAlerts()

      @currentIndex = newIndex
      return

    @container = Utils.createNode 'div', 'container'
    @root.appendChild @container

  findPage: (identifier) ->
    for page in @pages
      return page if page.identifier == identifier

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

    @pages.push page
    @container.appendChild page.node

    index

  setCurrentPage: (index) ->
    @tabbar.setCurrentTab index
    return

module.exports = Layout
