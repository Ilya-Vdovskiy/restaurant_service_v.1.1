<template>
  <RouterView v-if="$route.meta.public" />
  <AppLayout v-else />
</template>

<script setup>
import { RouterView } from 'vue-router';
import AppLayout from './components/AppLayout.vue';
</script>
