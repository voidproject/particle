<template>
<div class="layout-content-main">
  <form accept-charset="UTF-8" action="/users/1" class="user-editor" method="post">
    <input name="_utf8" type="hidden" value="✓">
    <div class="form-group">
      <label class="control-label" for="user_username">Name</label>
      <div class="form-control">
        <input id="user_username" name="user[username]" type="text" value="" v-model="name">
        <p>People can mention you as @username</p>
      </div>
    </div>

    <div class="form-group">
      <div class="control-label">Avatar</div>
      <div class="form-control -avatar">
        <img  v-bind:src="image ? ('/uploads/' + image) : 'https://api.adorable.io/avatars/256/alice@adorable.png'" class="user-avatar" @click="upload">
        <p>Set your avatar</p>
        <input type="file" id="upload" name="imagefile" style="opacity: 0; position: absolute; z-index: 10;" />
      </div>
    </div>

    <div class="action-bar">
      <div class="end">
        <button class="pure-button button-primary reply" type="submit" @click.prevent.stop="create"> Save </button>
      </div>
    </div>
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
      name: '',
      image: null
    }
  },
  created () {
    setTimeout(() => {
        let fileinput = document.querySelector('input[type=file]')
        fileinput.addEventListener('change', (x) => {
          if (x.target.files.length > 0) {
            var file = x.target.files[0];
            console.log(file)
            console.log(x.target.files.item(0))

            let data = new FormData();
            data.append('file', file, file.name);

            this.uploadfile(data).then(response => {
              console.log(response.data)
              this.image = response.data.hash
            })
          }
        }, false);
    }, 0)
  },
  methods: {
    create () {
      let keys
      if (localStorage.getItem('keys')) {
        keys = JSON.parse(localStorage.getItem('keys'))
      } else {
        keys = this.generateKeys()
        localStorage.setItem('keys', JSON.stringify(keys))
      }
      console.log(keys)
      this.addUser(keys.id).then(() => {
        this.newAbout(keys.id, this.name, this.image).then(() => {
          this.$parent.keys = keys
          this.$parent.haskey = true
          this.$router.push({ name: 'home' })
        })
      })
    },
    upload () {
      let fileinput = document.querySelector('input[type=file]')
      let obj = fileinput.click()
    }
  }
}
</script>
