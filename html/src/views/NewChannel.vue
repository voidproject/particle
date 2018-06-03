<template>
<div class="layout-content-main">
  <h2>Create a new channel</h2>
  <form accept-charset="UTF-8" action="" class="new-category" method="post">
    <input name="_utf8" type="hidden" value="✓">
    <input id="channel_title" name="channel[title]" placeholder="Type a title" type="text">
    <div class="action-bar">
      <div class="end">
        <a class="pure-button button-primary -muted cancel">Cancel</a>
        <button class="pure-button button-primary" type="submit">Create Channel</button>
      </div>
    </div>
  </form>
</div>

</template>

<script>
export default {
  name: 'home',
  components: {
  }
}
</script>
