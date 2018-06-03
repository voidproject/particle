<template>
<div class="layout-content-main">

  <div class="thread-header">
    <div class="split">
      <h2><a>{{message.content && message.content.title}}</a></h2>
      <div class="item-metadata">
        <ul class="category-pill">
          <li class="category -color-1">
            <router-link v-if="message && message.content && message.content.channel" :to="{ name: 'channel', params: {key: message.content.channel} }">{{message.content.channel}}</router-link>
          </li>
        </ul>
      </div>
    </div>
    <div class="item-metadata">
      <div class="avatar">
        <img  v-bind:src="message.attached && message.attached.image ? ('/uploads/' + message.attached.image) : 'https://api.adorable.io/avatars/256/alice@adorable.png'" class="user-avatar -borderless">
      </div>
      <router-link class="username" :to="{ name: 'profile', params: {key: message.author} }"> {{message.attached && message.attached.name || message.author}}</router-link>
      <abbr class="time">{{message.timestamp | dateformat}}</abbr>
    </div>
  </div>

  <ol class="post-list">
    <li><div class="post-item first-post">
    <div class="body">
      <p v-html="marked(message.content && message.content.text || '')"></p>
    </div>

    <div class="post-item-actions">
      <div class="reply-count">
        {{message.attached && message.attached.subposts_count || 0}} replies
      </div>
      <div class="spacer"></div>
      <ul class="actions">

          <li class="reaction">
            <a v-if="liked" class="reaction-picker" @click="unlike(message.key)"> unlike </a>
            <a v-if="!liked" class="reaction-picker" @click="like(message.key)"> like </a>
          </li>

          <li class="reaction">
            <router-link class="reaction-picker" :to="{ name: 'new-reply', params: {key: message.key} }">
              reply
            </router-link>
          </li>

        <li class="watch">
            <a aria-label="unwatch">
              <i class="fa fa-eye -highlight"></i>
            </a>
        </li>

          <li class="quote">
            <a>
              <i class="fa fa-quote-right"></i>
            </a>
          </li>

        <li class="reply">
          <a aria-label="reply"> <i class="fa fa-reply"></i> </a>
        </li>
      </ul>
    </div>
  </div>
  </li>

  <li v-for="msg in submessages">
    <div class="post-item">
      <div class="item-metadata">
        <div class="avatar">
          <img  v-bind:src="msg.attached.image ? ('/uploads/' + msg.attached.image) : 'https://api.adorable.io/avatars/256/alice@adorable.png'" class="user-avatar -borderless">
        </div>
        <router-link class="username" :to="{ name: 'profile', params: {key: msg.author} }">{{msg.user && msg.user.name || msg.author}}</router-link>
        <abbr class="time">{{msg.timestamp | dateformat}}</abbr>
      </div>

      <div class="body">
        <p v-html="marked(msg.content && msg.content.text || '')"></p>
      </div>

      <div class="post-item-actions">
        <div class="spacer"></div>
        <ul class="actions">
          <li class="link">
            <a aria-label="link to post 2">
              <i class="fa fa-link"></i>
            </a>
          </li>

          <li class="quote">
            <a>
              <i class="fa fa-quote-right"></i>
            </a>
          </li>

          <li class="reply">
            <a aria-label="reply"> <i class="fa fa-reply"></i> </a>
          </li>
        </ul>
      </div>
    </div>
  </li>

  </ol>
</div>

</template>

<script>
import timeago from 'timeago.js';

export default {
  name: 'home',
  components: {
  },
  data () {
    return {
      message: {},
      submessages: [],
      liked: false
    }
  },
  created () {
    let key = this.$route.params.id
    this.getPost(key).then((message) => {
      this.message = message.data.post
      console.log('mmm', this.message.author)
      this.liked = message.data.post.liked
      console.log(this.message)
    })
    this.getMessagesByRoot(key).then((resp) => {
      this.submessages = resp.data.posts
      console.log(this.submessages)
    })
  },
  methods: {
    marked (t) {
      if (t) return $converter.makeHtml(t).replace('<img src="', '<img src="' + this.$imgurl)
      else return t
    },
    like(key) {
      this.newVote(key, 1).then((message) => {
        this.message = message.data.post
        this.liked = true
        console.log(this.message)
      })
    },
    unlike(key) {
      this.newVote(key, 0).then((message) => {
        this.message = message.data.post
        this.liked = false
        console.log(this.message)
      })
    },
  },
  filters: {
    dateformat (ts) {
      return timeago().format(ts)
    }
  }
}
</script>
