import axios from 'axios'
import Vue from 'vue'
import App from './App.vue'
import router from './router'

var ssbkeys = require('ssb-keys')

var showdown  = require('showdown'),
    converter = new showdown.Converter();

Vue.config.productionTip = false

Vue.prototype.$http = axios
const baseurl = ''

window.$converter = Vue.prototype.$converter = converter

Vue.prototype.generateKeys = function () {
  return ssbkeys.generate()
}

Vue.prototype.addUser = function (key) {
  return this.$http.post(baseurl + '/api/add_user', {key: key})
}

Vue.prototype.getHome = function (since) {
  if (since) {
    return this.$http.post(baseurl + '/api/get_home_feed', {since: since})
  } else {
    return this.$http.post(baseurl + '/api/get_home_feed')
  }
}

Vue.prototype.getChannels = function () {
  return this.$http.post(baseurl + '/api/get_channels')
}

Vue.prototype.getChannel = function (channel) {
  return this.$http.post(baseurl + '/api/get_channel_messages', {channel: channel})
}

Vue.prototype.getUsers = function (since) {
  if (since) {
    return this.$http.post(baseurl + '/api/get_users', {since: since})
  } else {
    return this.$http.post(baseurl + '/api/get_users')
  }
}

Vue.prototype.getUser = function (key) {
  return this.$http.post(baseurl + '/api/get_user', {key: key})
}

Vue.prototype.getUserMessages = function (key, since) {
  if (since) {
    return this.$http.post(baseurl + '/api/get_user_messages', {key: key, since: since})
  } else {
    return this.$http.post(baseurl + '/api/get_user_messages', {key: key})
  }
}

Vue.prototype.getMessagesByRoot = function (key) {
  return this.$http.post(baseurl + '/api/get_messages_by_root', {key: key})
}

Vue.prototype.getPost = function (key) {
  return this.$http.post(baseurl + '/api/get_message', {key: key})
}

Vue.prototype.publish = function (content) {
  return this.$http.post(baseurl + '/api/publish', content)
}

Vue.prototype.newAbout = function (about, name, image) {
  return this.add('about', {about: about, name: name, image: image})
}

Vue.prototype.newVote = function (link, value) {
  return this.add('vote', {link: link, value: value})
}

Vue.prototype.newPost = function (title, channel, text) {
  return this.add('post', {title: title, channel: channel, text: text})
}

Vue.prototype.newReply = function (rootkey, text) {
  return this.add('post', {root: rootkey, text: text})
}

Vue.prototype.hasFollowed = function (target) {
  let keys = JSON.parse(localStorage.getItem('keys'))
  return this.$http.post(baseurl + '/api/has_follow', {source: keys.id, target: target})
}

Vue.prototype.hasLiked = function (target) {
  let keys = JSON.parse(localStorage.getItem('keys'))
  return this.$http.post(baseurl + '/api/has_like', {source: keys.id, target: target})
}

Vue.prototype.uploadfile = function (data) {
  return this.$http.post(baseurl + '/api/uploadfile/', data, {headers: { 'content-type': 'multipart/form-data' } })
}

Vue.prototype.follow = function (contact) {
  return this.add('contact', {following: true, contact: contact, blocking: false})
}

Vue.prototype.unfollow = function (contact) {
  return this.add('contact', {following: false, contact: contact, blocking: false})
}

const protodefs = `
syntax = "proto3";

message Message {
  string author    = 1;
  int64  seq       = 2;
  int64  timestamp = 3;
  string previous  = 4;
  string type      = 5;
  bytes content    = 6;
}

message Post {
  string title    = 1;
  string text     = 2;
  string channel  = 3;
  string root     = 4;
  string branch   = 5;
  string mentions = 6;
  string recps    = 7;
}

message Contact {
  string contact = 1;
  bool following = 2;
  bool blocking  = 3;
}

message Vote {
  string link   = 1;
  int64  value  = 2;
  string reason = 3;
}

message About {
  string about = 1;
  string name  = 2;
  string image = 3;
}`

const protobuf = require('protocol-buffers')
let protos = protobuf(protodefs)


const clean = (obj) => {
  Object.keys(obj).forEach((key) => (obj[key] === null || obj[key] === undefined || obj[key] === "" || obj[key] === [] ) && delete obj[key]);
  return obj
}

function make(keys, type, content, seq, previous, timestamp) {
    let encoder = null
    if (type === 'post') {
      encoder = protos.Post
    } else if (type === 'about') {
      encoder = protos.About
    } else if (type === 'contact') {
      encoder = protos.Contact
    } else if (type === 'vote') {
      encoder = protos.Vote
    }
    content = clean(content)
    let encoded = encoder.encode(content)
    let msg = {
      type: type,
      author: keys.id,
      seq: (seq + 1),
      previous: previous,
      timestamp: timestamp,
      content: encoded
    }
    let msg_encoded = protos.Message.encode(msg)
    let hash = ssbkeys.hash(msg_encoded)
    let sig = ssbkeys.sign(keys, hash)
    msg.content = content
    msg.key = '~' + hash.toString('base64')+'.sha256'
    msg.sig = sig
    return msg
}

Vue.prototype.add = function (type, content) {
  let keys = JSON.parse(localStorage.getItem('keys'))
  return this.getUser(keys.id).then((resp) => {
    console.log(resp.data)
    let now = Math.floor(Date.now())
    let msg = make(keys, type, content, resp.data.seq || 0, resp.data.previous || null, now)
    return this.$http.post(baseurl + '/api/add', {message: JSON.stringify(msg)})
  })
}

new Vue({
  router,
  render: h => h(App)
}).$mount('#app')
