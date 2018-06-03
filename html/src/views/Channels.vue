<template>
  <div class="layout-content-main">
    <div class="page-header">
      <h2><a>Channels</a></h2>
      <div class="spacer"></div>
    </div>

    <ol class="category-list">
      <li v-for="channel in channels">
        <h2 class="title"> <router-link :to="{ name: 'channel', params: {key: channel} }">{{channel}}</router-link> </h2>
      </li>
    </ol>
  </div>

</template>

<script>
export default {
  name: 'home',
  components: {
  },
  data () {
    return {
      channels: []
    }
  },
  created () {
    this.getChannels().then((channels) => {
      this.channels = channels.data.channels
      console.log(this.channels)
    })
  },
  methods: {
  }
}
</script>

