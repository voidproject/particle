import Vue from 'vue'
import Router from 'vue-router'

import About from './views/About.vue'
import Channels from './views/Channels.vue'
import Channel from './views/Channel.vue'
import EditProfile from './views/EditProfile.vue'
import Home from './views/Home.vue'
import NewChannel from './views/NewChannel.vue'
import NewPost from './views/NewPost.vue'
import NewReply from './views/NewReply.vue'
import Notification from './views/Notification.vue'
import Notifications from './views/Notifications.vue'
import Post from './views/Post.vue'
import Profile from './views/Profile.vue'
import Signin from './views/Signin.vue'
import Signup from './views/Signup.vue'
import Users from './views/Users.vue'
import NewAccount from './views/NewAccount.vue'
import Import from './views/Import.vue'
import Export from './views/Export.vue'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'home',
      component: Home
    },
    {
      path: '/about',
      name: 'about',
      component: About
    },
    {
      path: '/signin',
      name: 'signin',
      component: Signin
    },
    {
      path: '/signup',
      name: 'signup',
      component: Signup
    },
    {
      path: '/profile/:key',
      name: 'profile',
      component: Profile
    },
    {
      path: '/editprofile',
      name: 'editprofile',
      component: EditProfile
    },
    {
      path: '/users',
      name: 'users',
      component: Users
    },
    {
      path: '/channels',
      name: 'channels',
      component: Channels
    },
    {
      path: '/new_channel',
      name: 'new_channel',
      component: NewChannel
    },
    {
      path: '/channel/:key',
      name: 'channel',
      component: Channel
    },
    {
      path: '/new-post',
      name: 'new-post',
      component: NewPost
    },
    {
      path: '/new-reply/:key',
      name: 'new-reply',
      component: NewReply
    },
    {
      path: '/post/:id',
      name: 'post',
      component: Post
    },
    {
      path: '/notification',
      name: 'notification',
      component: Notification
    },
    {
      path: '/notifications',
      name: 'notifications',
      component: Notifications
    },
    {
      path: '/new-account',
      name: 'new-account',
      component: NewAccount
    },
    {
      path: '/import',
      name: 'import',
      component: Import
    },
    {
      path: '/export',
      name: 'export',
      component: Export
    }
  ]
})
