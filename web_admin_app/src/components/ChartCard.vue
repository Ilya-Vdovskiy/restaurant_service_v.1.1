<template>
  <section class="chart-card">
    <div class="section-head compact">
      <div>
        <h2>{{ title }}</h2>
        <p v-if="subtitle">{{ subtitle }}</p>
      </div>
    </div>
    <slot />
  </section>
</template>

<script setup>
defineProps({ title: String, subtitle: String });
</script>
