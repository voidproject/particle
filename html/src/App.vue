<template>
  <div id="app" class="layout-app page-thread-recent">
    <!-- I'm using pure-drawer - http://mac81.github.io/pure-drawer/ - for a mobile navigation drawer -->
    <div class="pure-container" data-effect="pure-effect-slide">
      <input id="pure-toggle-right" class="pure-toggle" data-toggle="right" type="checkbox" />
      <label class="pure-toggle-label" data-toggle-label="right" for="pure-toggle-right">
        <span class="pure-toggle-icon"></span>
      </label>
      <div class="pure-drawer" data-position="right">
        <div class="navigation-drawer">
          <ul>
            <li class=" x-has-notifications"><router-link :to="{ name: 'home' }">Home</router-link></li>
            <li v-if="!haskey" class=" x-has-notifications"><router-link :to="{ name: 'new-account' }">New Account</router-link></li>
            <li v-if="!haskey" class=" x-has-notifications"><router-link :to="{ name: 'import' }">Import</router-link></li>
            <li v-if="haskey" class=" x-has-notifications"><router-link :to="{ name: 'new-post' }">New Post</router-link></li>
          </ul>
          <ul>
            <li class=" x-has-notifications"><router-link :to="{ name: 'channels' }">Categories</router-link></li>
            <li class=" x-has-notifications"><router-link :to="{ name: 'users' }">Users</router-link></li>
          </ul>
          <ul>
            <li v-if="haskey && keys" class=" x-has-notifications"><router-link :to="{ name: 'profile', params: {key: keys.id} }">Profile</router-link></li>
            <li v-if="haskey" class=" x-has-notifications"><router-link :to="{ name: 'editprofile' }">Edit Profile</router-link></li>
            <li v-if="haskey" class=" x-has-notifications"><router-link :to="{ name: 'export' }">Export</router-link></li>
            <li @click="logout" class=" x-has-notifications"><a>Log out</a></li>
          </ul>
        </div>
      </div>
      <!--
        this is the container for pure-drawer that holds the main content
        that the drawer will appear in front of
      -->
      <div class="pure-pusher-container">
        <!-- Stuff inside pure-pusher gets pushed if the drawer pushes content -->
        <div class="pure-pusher">
          <div class="pure-menu pure-menu-horizontal navigation-menu">
            <a class="pure-menu-heading pure-menu-link.navigation-logo-link" href="/">
          <div class="navigation-logo">
            <img alt="logo" src="/particle_logo.png" />
            <span>Particle</span>
          </div>
            </a>
          </div>
          <!-- Now our styles take over and we'll define the main content area -->
          <div class="layout-content">
            <div class="layout-drawer-tablet">
              <div class="navigation-drawer">
                  <ul v-if="!haskey">
                    <li class=" x-has-notifications"><router-link :to="{ name: 'home' }">Home</router-link></li>
                    <li class=" x-has-notifications"><router-link :to="{ name: 'new-account' }">New Account</router-link></li>
                    <li class=" x-has-notifications"><router-link :to="{ name: 'import' }">Import</router-link></li>
                  </ul>
                  <ul v-if="haskey">
                    <li class=" x-has-notifications"><router-link :to="{ name: 'home' }">Home</router-link></li>
                    <li v-if="haskey" class=" x-has-notifications"><router-link :to="{ name: 'new-post' }">New Post</router-link></li>
                  </ul>
                  <ul>
                    <li class=" x-has-notifications"><router-link :to="{ name: 'channels' }">Channels</router-link></li>
                    <li class=" x-has-notifications"><router-link :to="{ name: 'users' }">Users</router-link></li>
                  </ul>
                  <ul v-if="haskey">
                    <li class=" x-has-notifications"><router-link :to="{ name: 'profile', params: {key: keys.id} }">Profile</router-link></li>
                    <li v-if="haskey" class=" x-has-notifications"><router-link :to="{ name: 'editprofile' }">Edit Profile</router-link></li>
                    <li class=" x-has-notifications"><router-link :to="{ name: 'export' }">Export</router-link></li>
                    <li @click="logout" class=" x-has-notifications"><a>Log out</a></li>
                  </ul>
              </div>
            </div>

            <router-view/>

          </div>
        </div>
      </div>
      <label class="pure-overlay" data-overlay="right" for="pure-toggle-right"></label>
    </div>

  </div>
</template>

<style lang="scss">
</style>

<script>
import timeago from 'timeago.js';

export default {
  name: 'home',
  components: {
  },
  data () {
    return {
      haskey: false,
      keys: null
    }
  },
  created () {
    console.log()
    this.keys = JSON.parse(localStorage.getItem('keys'))
    this.haskey = !!this.keys
  },
  methods: {
    logout () {
      localStorage.removeItem('keys')
      this.haskey = false
      if (this.$route.name != 'home') {
        this.$router.push({ name: 'home' })
      }
    }
  },
}
</script>
