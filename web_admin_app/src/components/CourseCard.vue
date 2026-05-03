<template>
  <article class="course-card">
    <div class="course-cover" :class="course.tone">
      <BookOpen :size="38" />
      <span>{{ course.category }}</span>
    </div>
    <div class="course-body">
      <div class="card-title-row">
        <h3>{{ course.title }}</h3>
        <StatusBadge :label="course.status" />
      </div>
      <p>{{ course.modules }} модулей · {{ course.duration }} · {{ course.enrolled }} сотрудников</p>
      <ProgressBar :value="course.progress" />
      <div class="card-actions">
        <button class="primary small" @click="$emit('edit', course)">Редактировать</button>
        <button class="ghost small">Предпросмотр</button>
      </div>
    </div>
  </article>
</template>

<script setup>
import { BookOpen } from 'lucide-vue-next';
import ProgressBar from './ProgressBar.vue';
import StatusBadge from './StatusBadge.vue';

defineProps({ course: { type: Object, required: true } });
defineEmits(['edit']);
</script>
