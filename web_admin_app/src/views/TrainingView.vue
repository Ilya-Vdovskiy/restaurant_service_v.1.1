<template>
  <section class="page">
    <div class="section-head">
      <div><h1>Обучение</h1><p>Управление учебными материалами, модулями и статусами курсов.</p></div>
      <button class="primary" @click="modal = true"><Plus :size="19" />Создать курс</button>
    </div>
    <div class="toolbar"><SearchInput placeholder="Поиск курса..." /><select><option>Все категории</option><option>Безопасность</option><option>Сервис</option><option>Кухня</option></select></div>
    <div class="cards-grid">
      <CourseCard v-for="course in courses" :key="course.id" :course="course" @edit="modal = true" />
    </div>
    <ChartCard title="Модули редактора курса" subtitle="Заготовки блоков для учебного контента">
      <div class="module-grid">
        <button><Type :size="22" />Текст</button><button><Image :size="22" />Изображение</button><button><Video :size="22" />Видео</button><button><FileText :size="22" />Документ</button>
      </div>
    </ChartCard>
    <Modal :open="modal" title="Редактор курса" subtitle="Форма-заглушка для создания и редактирования" @close="modal = false">
      <form class="form-grid" @submit.prevent="modal = false">
        <input placeholder="Название курса" value="Новый стандарт сервиса" />
        <input placeholder="Категория" value="Сервис" />
        <textarea placeholder="Описание">Краткое описание целей, материалов и ожидаемых результатов обучения.</textarea>
        <div class="module-grid compact"><button type="button">+ Текст</button><button type="button">+ Изображение</button><button type="button">+ Видео</button><button type="button">+ Документ</button></div>
        <button class="primary">Сохранить курс</button>
      </form>
    </Modal>
  </section>
</template>

<script setup>
import { ref } from 'vue';
import { FileText, Image, Plus, Type, Video } from 'lucide-vue-next';
import SearchInput from '../components/SearchInput.vue';
import CourseCard from '../components/CourseCard.vue';
import ChartCard from '../components/ChartCard.vue';
import Modal from '../components/Modal.vue';
import { courses } from '../data/courses';
const modal = ref(false);
</script>
