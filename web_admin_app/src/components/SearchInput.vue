<template>
  <label class="search-input">
    <Search :size="19" />
    <input :value="modelValue" :placeholder="placeholder" @input="$emit('update:modelValue', $event.target.value)" />
  </label>
</template>

<script setup>
import { Search } from 'lucide-vue-next';

defineProps({
  modelValue: { type: String, default: '' },
  placeholder: { type: String, default: 'Поиск...' },
});

defineEmits(['update:modelValue']);
</script>
