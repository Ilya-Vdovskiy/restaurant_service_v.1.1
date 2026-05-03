<template>
  <section class="page">
    <div class="section-head">
      <div><h1>Назначения</h1><p>Назначение курсов сотрудникам, группам и должностям.</p></div>
      <button class="primary" @click="modal = true"><Send :size="19" />Назначить курс</button>
    </div>
    <div class="assignment-board">
      <article v-for="item in assignments" :key="item.id" class="assignment-card">
        <StatusBadge :label="item.status" />
        <h3>{{ item.course }}</h3>
        <p>{{ item.target }}</p>
        <small>Дедлайн: {{ item.deadline }}</small>
      </article>
    </div>
    <Modal :open="modal" title="Назначение обучения" subtitle="Форма-заглушка для будущего backend" @close="modal = false">
      <form class="form-grid" @submit.prevent="modal = false">
        <select><option>Конкретный сотрудник</option><option>Группа</option><option>Должность</option></select>
        <input value="Михаил Орлов" placeholder="Сотрудник, группа или должность" />
        <select><option>Пищевая безопасность HACCP</option><option>Сервис премиального ресторана</option></select>
        <input type="date" value="2026-05-20" />
        <button class="primary">Назначить</button>
      </form>
    </Modal>
  </section>
</template>

<script setup>
import { ref } from 'vue';
import { Send } from 'lucide-vue-next';
import Modal from '../components/Modal.vue';
import StatusBadge from '../components/StatusBadge.vue';
import { assignments } from '../data/assignments';
const modal = ref(false);
</script>
