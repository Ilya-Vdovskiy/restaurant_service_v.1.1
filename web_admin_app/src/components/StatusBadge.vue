<template>
  <span class="status-badge" :class="badgeClass">{{ label }}</span>
</template>

<script setup>
import { computed } from 'vue';

const props = defineProps({ label: { type: String, required: true } });

const badgeClass = computed(() => {
  if (['Активен', 'Сдано', 'Завершено', 'Опубликован'].includes(props.label)) return 'success';
  if (['В процессе', 'На обучении', 'Назначено'].includes(props.label)) return 'warning';
  if (['Просрочено', 'Не сдано', 'Повторить'].includes(props.label)) return 'danger';
  return 'muted';
});
</script>
