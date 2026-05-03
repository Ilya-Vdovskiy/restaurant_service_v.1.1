<template>
  <div class="progress-wrap" :aria-label="`${value}%`">
    <span :style="{ width: `${Math.min(value, 100)}%` }"></span>
  </div>
</template>

<script setup>
defineProps({ value: { type: Number, default: 0 } });
</script>
