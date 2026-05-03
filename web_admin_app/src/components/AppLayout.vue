<template>
  <div class="app-shell">
    <Sidebar />
    <div class="app-main">
      <Topbar />
      <main class="content">
        <RouterView />
      </main>
    </div>
  </div>
</template>

<script setup>
import { RouterView } from 'vue-router';
import Sidebar from './Sidebar.vue';
import Topbar from './Topbar.vue';
</script>
