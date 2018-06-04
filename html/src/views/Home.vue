<template>
<div class="layout-content-main">
  <ol class="thread-list">
      <li v-for="message in messages" class="thread-list-item">
        <div class="details">
          <div class="summary">
            <ul class="category-pill">
            </ul>
            <router-link class="title" :to="{ name: 'post', params: {id: message.key} }">{{message.content.title}}</router-link>
            <router-link class="username" :to="{ name: 'profile', params: {key: message.author} }">{{message.attached && message.attached.name || message.author}}</router-link>
          </div>
          <div class="metadata">
            <abbr class="time">{{message.timestamp | dateformat}}</abbr>
          </div>
        </div>
        <div class="supplemental">
          <div class="badge-block">{{message.attached.subposts_count || 0}}</div>
        </div>
        <div class="preview">{{message.text}}</div>
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
      messages: []
    }
  },
  created () {
    this.getHome().then((messages) => {
      this.messages = messages.data.posts
      console.log(this.messages)
    })
  },
  methods: {
    nextpage () {
      console.log("next")
      this.getHome(this.messages[this.messages.length-1].id).then((messages) => {
        this.messages = this.messages.concat(messages.data.posts)
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
