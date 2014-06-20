Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  waitOn: -> [
    #Meteor.subscribe('posts'),
    #Meteor.subscribe('comments'),
    Meteor.subscribe('notifications')
  ]


PostsListController = RouteController.extend
  template: 'postsList'

  increment: 5

  limit: ->
    return parseInt(@params.postsLimit) or @increment

  findOptions: ->
    return {
      sort: @sort
      limit: @limit()
    }

  waitOn: ->
    return Meteor.subscribe 'posts', @findOptions()

  posts: ->
    return Posts.find {}, @findOptions()

  data: ->
    hasMore = @posts().count() is @limit()
    return {
      posts: @posts()
      nextPath: if hasMore then @nextPath() else null
    }

NewPostsListController = PostsListController.extend
  sort: {submitted: -1, _id: -1}
  nextPath: ->
    Router.routes.newPosts.path
      postsLimit: @limit() + @increment

BestPostsListController = PostsListController.extend
  sort: {votes: -1, submitted: -1, _id: -1}
  nextPath: ->
    Router.routes.bestPosts.path
      postsLimit: @limit() + @increment

Router.map ->
  @route 'postPage',
    path: '/posts/:_id'
    waitOn: -> 
      return [
        Meteor.subscribe 'singlePost', @params._id
        Meteor.subscribe 'comments', @params._id
      ]
    data: -> Posts.findOne @params._id

  @route 'postSubmit',
    path: '/submit'

  @route 'postEdit',
    path: '/posts/:_id/edit'
    waitOn: ->
      Meteor.subscribe 'singlePost', @params._id
    data: -> Posts.findOne @params._id

  @route 'home',
    path: '/'
    controller: NewPostsListController

  @route 'newPosts',
    path: '/new/:postsLimit?'
    controller: NewPostsListController
                
  @route 'bestPosts',
    path: '/best/:postsLimit?'
    controller: BestPostsListController


requireLogin = (pause) ->
  if not Meteor.user()
    if Meteor.loggingIn()
      @render @loadingTemplate
    else
      @render 'accessDenied'
    pause()

Router.onBeforeAction 'loading'
Router.onBeforeAction requireLogin,
  only: 'postSubmit'
Router.onBeforeAction -> window.Errors.clearSeen()
