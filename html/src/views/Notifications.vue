<template>
    <div class="layout-content-main">
      <div class="page-header">
        <h2>Notifications</h2>
        <div class="spacer"></div>
        <ul class="actions">
          <li>
            <a class="pure-button button-primary">
              <i class="fa fa-plus"></i>
              Mark All Read
            </a>
          </li>
        </ul>
      </div>

      <ol class="notification-list">
          <li>
            <div class="notification-item">
              <div class="subject">
                <a>There was a new post in thread: ruby</a>
              </div>
            </div>
          </li>
      </ol>
    </div>
</template>

<script>
export default {
  name: 'home',
  components: {
  }
}
</script>
