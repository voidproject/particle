<template>
<div class="layout-content-main">
  <div class="category-header">
    <h2><a>{{channel}}</a></h2>
    <div class="spacer"></div>
    <ul class="actions">
      <li>
        <router-link :to="{ name: 'new-post' }" class="pure-button button-primary">
          <i class="fa fa-plus"></i>
          New Post
        </router-link>
      </li>
    </ul>
  </div>

  <ol class="thread-list">
    <li v-for="message in messages" class="thread-list-item">
    <div class="details">
      <div class="summary">
        <ul class="category-pill">
          <li class="category -color-246">
            <router-link :to="{ name: 'channel', params: {key: channel} }">{{message.content.channel}}</router-link>
          </li>
        </ul>
        <router-link class="title" :to="{ name: 'post', params: {id: message.key} }">{{message.content.title}}</router-link>
        <router-link class="username" :to="{ name: 'profile', params: {key: message.author} }">{{message.attached && message.attached.name || message.author}}</router-link>
      </div>
      <div class="metadata">
        <abbr class="time" :title="message.timestamp">{{message.timestamp | dateformat}}</abbr>
      </div>
    </div>
    <div class="supplemental">
      <div class="badge-block">{{message.attached.subposts_count || 0}}</div>
    </div>
    <div class="preview">{{message.text}}</div>
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
      channel: '',
      messages: []
    }
  },
  created () {
    this.channel = this.$route.params.key
    this.getChannel(this.channel).then((messages) => {
      this.messages = messages.data.posts
      console.log(this.messages)
    })
  },
  filters: {
    dateformat (ts) {
      return timeago().format(ts)
    }
  }
}
</script>
