<template>
  <header class="topbar">
    <SearchInput placeholder="Поиск сотрудников, курсов, тестов..." />
    <button class="icon-button" aria-label="Уведомления">
      <Bell :size="20" />
      <span class="notification-dot"></span>
    </button>
    <button class="profile-button">
      <span class="avatar small">РК</span>
      <span>Руководитель</span>
      <ChevronDown :size="16" />
    </button>
  </header>
</template>

<script setup>
import { Bell, ChevronDown } from 'lucide-vue-next';
import SearchInput from './SearchInput.vue';
</script>
