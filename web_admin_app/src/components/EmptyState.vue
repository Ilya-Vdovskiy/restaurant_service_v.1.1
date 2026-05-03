<template>
  <div class="empty-state">
    <SearchX :size="32" />
    <h3>{{ title }}</h3>
    <p>{{ text }}</p>
  </div>
</template>

<script setup>
import { SearchX } from 'lucide-vue-next';

defineProps({
  title: { type: String, default: 'Ничего не найдено' },
  text: { type: String, default: 'Попробуйте изменить поиск или фильтры.' },
});
</script>
