<template>
<div class="layout-content-main">
  <p v-if="notified" class="alert-box -info" role="alert"> User updated successfully. </p>

  <div class="user-details">
    <img v-bind:src="user.image ? ('/uploads/' + user.image) : 'https://api.adorable.io/avatars/256/alice@adorable.png'" class="user-avatar">
    <div class="contact">
      <h1 class="username">{{user && user.name}}</h1>
      <h3 class="name">{{user && user.key}}</h3>
    </div>
    <hr>
    <div class="meta">
      <ul>
        <li v-if="!following">
          <a @click="followkey(user.key)">follow</a>
        </li>
        <li v-if="following">
          <a @click="unfollowkey(user.key)">unfollow</a>
        </li>
      </ul>

      <ul>
        <li>
          <strong>messages</strong>
          {{user && user.seq}}
        </li>
      </ul>

      <ul>
      </ul>
    </div>
    <div class="edit">
      <a> <i class="fa fa-cog"></i> </a>
    </div>
  </div>

  <ol class="user-posts post-list">
    <li v-for="message in messages">
      <div class="post-item" id="post-2">
        <div class="item-metadata">
          <div class="avatar">
            <img  v-bind:src="message.user && message.user.image ? ('/uploads/' + message.user.image) : 'https://api.adorable.io/avatars/256/alice@adorable.png'" class="user-avatar -borderless">
          </div>
          <router-link class="headline" :to="{ name: 'post', params: {id: message.key} }">{{message.content.title}}</router-link>
          <router-link class="title" :to="{ name: 'post', params: {id: message.key} }"> <abbr class="time">{{message.timestamp | dateformat}}</abbr> </router-link>
        </div>
        <div class="body">
          <p v-html="marked(message.content && message.content.text || '')"></p>
        </div>

        <div class="post-item-actions">
          <div class="spacer"></div>
          <ul class="actions">
            <li>
              <a aria-label="link to post 2">
                <i class="fa fa-link"></i>
              </a>
            </li>
            <li class="reply">
              <a aria-label="reply">
                <i class="fa fa-reply"></i>
              </a>
            </li>
          </ul>
        </div>
      </div>
    </li>
  </ol>

  <nav aria-label="Page navigation">
    <ul @click="nextpage()" class="pagination">
      <li class="active page-item"><a class="page-link" rel="canonical">load more</a></li>
    </ul>
  </nav>
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
      user: {},
      notified: null,
      following: false,
      messages: [],
    }
  },
  created () {
    let key = this.$route.params.key
    console.log(key)
    this.getUser(key).then((resp) => {
      if (!resp.data.user) {
        this.$router.push({ name: 'new-account' })
        return
      }

      this.user = resp.data.user

      this.getUserMessages(key).then((resp) => {
        this.messages = resp.data.posts
      })

      this.hasFollowed(key).then((resp) => {
        console.log(resp.data)
        this.following = resp.data.following
      })

    })
  },
  methods: {
    marked (t) {
      if (t) return $converter.makeHtml(t).replace('<img src="', '<img src="' + this.$imgurl)
      else return t
    },
    followkey (key) {
      this.follow(key).then((message) => {
        this.message = message.data
        this.following = true
        console.log(this.message)
      })
    },
    unfollowkey (key) {
      this.unfollow(key).then((message) => {
        this.message = message.data
        this.following = false
        console.log(this.message)
      })
    },
    nextpage () {
      let key = this.$route.params.key
      this.getUserMessages(key, this.messages[this.messages.length-1].timestamp).then((messages) => {
        this.messages = this.messages.concat(messages.data)
        console.log(messages.data)
      })
    }
  },
  filters: {
    dateformat (ts) {
      return timeago().format(ts)
    }
  }
}
</script>
