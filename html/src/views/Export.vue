<template>
<div class="layout-content-main">
  <h2>Export</h2>
  <form accept-charset="UTF-8" action="" class="pure-form" method="post">
    <input name="_utf8" type="hidden" value="✓">
    <div>
      <label>
        Export secret keys:
        <div class="form-group">
          <div class="control-label"></div>
          <div class="form-control">
          <textarea id="thread_body" readonly="readonly" rows="6" cols="50" style="background: white;" placeholder="" v-model="keys"></textarea>
          </div>
        </div>

      </label>
    </div>
    <br />
    <button class="pure-button button-primary" type="submit" @click.prevent.stop="save">OK</button>
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
    let keys = localStorage.getItem('keys')
    this.keys = keys
  },
  methods: {
    save () {
      this.$router.push({ name: 'home' })
    }
  }
}
</script>
