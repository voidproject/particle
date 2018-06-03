<template>
<div class="layout-content-main">
  <h2>Start a new reply</h2>
  <form accept-charset="UTF-8" class="new-thread post-editor" method="post">
    <div>reply to: {{rootkey}}</div>
    <input name="_utf8" type="hidden" value="✓">
    <br>
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
      rootkey: '',
      text: ''
    }
  },
  created () {
    this.rootkey = this.$route.params.key
  },
  methods: {
    marked (t) {
      if (t) return $converter.makeHtml(t).replace('<img src="', '<img src="' + this.$imgurl)
      else return t
    },
    create () {
      this.newReply(this.rootkey, this.text).then(() => {
        this.$router.push({ name: 'home' })
      })
    }
  }
}
</script>
