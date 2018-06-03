<template>
<div class="layout-content-main">
  <h2>Start a new post</h2>
  <form accept-charset="UTF-8" class="new-thread post-editor" method="post">
    <input name="_utf8" type="hidden" value="✓">
    <input id="thread_title" name="thread[title]" placeholder="Type a title" type="text" v-model="title">
    <textarea id="thread_channel" name="thread[channel]" placeholder="Set channel here." v-model="channel"></textarea>
    <textarea id="thread_text" name="thread[text]" placeholder="Type thread content here. Use markdown syntax." v-model="text"></textarea>
    <div class="action-bar">
      <div class="begin">
        <div class="add-attachment">
          <label class="pure-button button-primary -inverted attachment">
            <input type="file" aria-label="add-attachment">
            <i class="fa fa-paperclip"></i>
          </label>
        </div>
      </div>
      <div class="end">
        <a class="pure-button button-primary -muted cancel" @click.prevent.stop="cancel">Cancel</a>
        <button class="pure-button button-primary reply" type="submit" @click.prevent.stop="create">Create Post</button>
      </div>
    </div>
  </form>
  <div class="post-preview">
    <h3>Preview</h3>
    <div class="content" v-html="marked(text || '')"></div>
  </div>
</div>
</template>

<script>
export default {
  name: 'home',
  data () {
    return {
      title: '',
      channel: '',
      text: ''
    }
  },
  created () {
  },
  methods: {
    marked (t) {
      if (t) return $converter.makeHtml(t).replace('<img src="', '<img src="' + this.$imgurl)
      else return t
    },
    create () {
      if (!this.title) {
        alert("title required ")
        return
      }
      this.newPost(this.title, this.channel, this.text).then(() => {
        this.$router.push({ name: 'home' })
      })
    }
  }
}
</script>
