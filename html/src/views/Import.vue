<template>
<div class="layout-content-main">
  <h2>Import</h2>
  <form accept-charset="UTF-8" action="" class="pure-form" method="post">
    <input name="_utf8" type="hidden" value="✓">
    <div>
      <label>
        Keystore:

        <div class="form-group">
          <div class="control-label"></div>
          <div class="form-control">
          <textarea id="thread_body" rows="6" cols="30" placeholder="Put keys here." v-model="keys"></textarea>
          </div>
        </div>

      </label>
    </div>
    <br />
    <button class="pure-button button-primary" type="submit" @click.prevent.stop="save">Import Keys</button>
  </form>
</div>
</template>

<script>
export default {
  name: 'home',
  components: {
  },
  data () {
    return {
      keys: ''
    }
  },
  created () {
  },
  methods: {
    save () {
      localStorage.setItem('keys', (this.keys))
      console.log(this.keys.id)
      this.addUser(JSON.parse(this.keys).id).then(() => {
        this.$parent.keys = keys
        this.$parent.haskey = true
        this.$router.push({ name: 'home' })
      })
    }
  }
}
</script>
