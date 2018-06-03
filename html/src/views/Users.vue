<template>
<div class="layout-content-main">
  <div class="page-header">
    <h2>Users</h2>
  </div>

  <ul v-for="user in users" class="user-list">
    <li>
      <div class="avatar">
         <router-link class="username" :to="{ name: 'profile', params: {key: user.key} }">
          <img v-bind:src="user.image ? ('/uploads/' + user.image) : 'https://api.adorable.io/avatars/256/alice@adorable.png'" class="user-avatar -borderless">
         </router-link>
      </div>
      <router-link class="username" :to="{ name: 'profile', params: {key: user.key} }">{{user.name || user.key}}</router-link>
    </li>
  </ul>

  <nav aria-label="Page navigation">
    <ul @click="nextpage()" class="pagination">
      <li class="active page-item"><a class="page-link" rel="canonical">load more</a></li>
    </ul>
  </nav>

</div>
</template>

<script>
export default {
  name: 'home',
  components: {
  },
  data () {
    return {
      users: []
    }
  },
  created () {
    this.getUsers().then((users) => {
      this.users = users.data.users
      console.log(this.users)
    })
  },
  methods: {
    nextpage () {
      this.getUsers(this.users[this.users.length-1].id).then((resp) => {
        this.users = this.users.concat(resp.data.users)
        console.log(resp.data)
      })
    }
  },
}
</script>
