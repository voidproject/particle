<template>
<div class="layout-content-main">
  <form accept-charset="UTF-8" action="" class="user-editor" method="post">
    <input name="_utf8" type="hidden" value="✓">
    <div class="form-group">
      <label class="control-label" for="user_username">Name</label>
      <div class="form-control">
        <input id="user_username" name="user[username]" type="text" value="" v-model="name">
        <p>People can mention you as @name</p>
      </div>
    </div>

    <div class="form-group">
      <div class="control-label">Avatar</div>
      <div class="form-control -avatar">
        <img v-bind:src="image ? ('/uploads/' + image) : 'https://api.adorable.io/avatars/256/alice@adorable.png'" class="user-avatar" @click="upload">
        <p>Click to Upload Image</p>
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
      image: null,
    }
  },
  created () {
    let keys = JSON.parse(localStorage.getItem('keys'))
    this.getUser(keys.id).then((resp) => {
      this.name = resp.data.user.name
      this.image = resp.data.user.image
    })

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
      let keys = JSON.parse(localStorage.getItem('keys'))
      console.log(keys)
      this.newAbout(keys.id, this.name, this.image).then(() => {
        this.$router.push({ name: 'home' })
      })
    },
    upload () {
      let fileinput = document.querySelector('input[type=file]')
      fileinput.click()
    }
  }
}
</script>
