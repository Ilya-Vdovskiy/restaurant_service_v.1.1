<template>
  <article class="employee-card">
    <div class="avatar large">{{ initials }}</div>
    <h3>{{ employee.name }}</h3>
    <p>{{ employee.position }} · {{ employee.department }}</p>
    <StatusBadge :label="employee.status" />
    <ProgressBar :value="progress" />
    <button class="ghost small" @click="$emit('open', employee)">Открыть профиль</button>
  </article>
</template>

<script setup>
import { computed } from 'vue';
import ProgressBar from './ProgressBar.vue';
import StatusBadge from './StatusBadge.vue';

const props = defineProps({ employee: { type: Object, required: true } });
defineEmits(['open']);

const initials = computed(() => props.employee.name.split(' ').map((part) => part[0]).join(''));
const progress = computed(() => Math.round((props.employee.completed / props.employee.courses) * 100));
</script>
