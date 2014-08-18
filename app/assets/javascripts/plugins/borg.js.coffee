class ContainersRestartWidget
  constructor: ->
    @tasks = {}

  appendTo: (@$container) ->

  getTask: (host) ->
    @tasks[host] ||= new ContainerView(@$container, host)

  update: (text) ->
    new CapistranoParser(text).stream (log) =>
      if match = log.output.match(/\[(\d+)\/(\d+)\] Restarting/)
        @getTask(log.host).update
          numPending: match[1]
          numLights: match[2]
      else if match = log.output.match(/\[(\d+)\/(\d+)\] Successfully Restarted/)
        @getTask(log.host).update
          numDone: match[1]
          numLights: match[2]
      else if match = log.output.match(/\[(\d+)\/(\d+)\] Unable to restart/)
        @getTask(log.host).update(numPending: match[1], numLights: match[2]).fail()
    null


class ContainerView
  TEMPLATE = $.trim """
    <div class="task-lights">
      <span class="task-lights-text">
        <span class="task-lights-node"></span>
      </span>
      <span class="task-lights-boxes"></span>
    </div>
  """
  numLights: 0
  numPending: 0
  numDone: 0

  constructor: (@$container, host) ->
    @$element = $(TEMPLATE)
    title = host.split('.')[0]
    @$element.find('.task-lights-node').text(title)
    @$element.appendTo(@$container)

  update: (attrs) ->
    $.extend(this, attrs)
    boxes = document.createDocumentFragment();
    for i in [1..(+@numLights)]
      status = if i <= @numDone
        'up'
      else if i <= @numPending
        'partial'
      else
        'neutral'
      $('<span>').addClass("task-lights-box box-#{status}").appendTo(boxes)
    @$element.find('.task-lights-boxes').empty().append(boxes)
    this

  fail: ->
    @$element.addClass('task-failed')


restartWidget = new ContainersRestartWidget()

ChunkPoller.prependFormatter (chunk) ->
  restartWidget.update(chunk)
  false

Sidebar.registerPlugin(restartWidget)
