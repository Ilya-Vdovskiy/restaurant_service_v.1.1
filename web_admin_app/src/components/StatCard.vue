<template>
  <article class="stat-card">
    <div class="stat-icon">
      <component :is="icon" :size="23" />
    </div>
    <div class="stat-change">{{ change }}</div>
    <p>{{ label }}</p>
    <strong>{{ value }}</strong>
  </article>
</template>

<script setup>
defineProps({
  label: String,
  value: [String, Number],
  change: String,
  icon: Object,
});
</script>
