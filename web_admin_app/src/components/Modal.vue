<template>
  <Teleport to="body">
    <div v-if="open" class="modal-backdrop" @click.self="$emit('close')">
      <section class="modal-panel">
        <header class="modal-header">
          <div>
            <h2>{{ title }}</h2>
            <p v-if="subtitle">{{ subtitle }}</p>
          </div>
          <button class="icon-button" @click="$emit('close')" aria-label="Закрыть">
            <X :size="20" />
          </button>
        </header>
        <slot />
      </section>
    </div>
  </Teleport>
</template>

<script setup>
import { X } from 'lucide-vue-next';

defineProps({
  open: Boolean,
  title: String,
  subtitle: String,
});

defineEmits(['close']);
</script>
