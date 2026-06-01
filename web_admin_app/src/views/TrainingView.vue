<template>
  <section v-if="showEditor" class="page">
    <div class="section-head">
      <div>
        <button class="back-link" @click="closeEditor">← Назад к курсам</button>
        <h1>{{ editingCourse ? 'Редактирование курса' : 'Создание курса' }}</h1>
      </div>
      <button class="primary">Сохранить курс</button>
    </div>

    <div class="editor-layout">
      <div class="editor-main">
        <section class="chart-card">
          <div class="section-head compact">
            <h2>Основная информация</h2>
          </div>
          <div class="form-grid">
            <label class="field-label">
              <span>Название курса</span>
              <input :value="editingCourse?.title || ''" placeholder="Введите название..." />
            </label>
            <label class="field-label">
              <span>Описание</span>
              <textarea :value="editingCourse?.description || ''" placeholder="Опишите курс..."></textarea>
            </label>
          </div>
        </section>

        <section class="chart-card">
          <div class="section-head compact">
            <h2>Модули курса</h2>
            <button class="text-action"><Plus :size="16" />Добавить модуль</button>
          </div>
          <div class="module-editor-list">
            <article v-for="module in modules" :key="module.id" class="module-editor-card">
              <div class="module-title-row">
                <input :value="module.title" placeholder="Название модуля" />
                <button class="danger-icon" aria-label="Удалить модуль"><Trash2 :size="17" /></button>
              </div>
              <textarea :placeholder="module.placeholder"></textarea>
              <div class="editor-chip-row">
                <button type="button">+ Текст</button>
                <button type="button">+ Изображение</button>
                <button type="button">+ Видео</button>
              </div>
            </article>
          </div>
        </section>
      </div>

      <aside class="editor-side">
        <section class="chart-card">
          <div class="section-head compact">
            <h2>Настройки</h2>
          </div>
          <div class="form-grid">
            <label class="field-label">
              <span>Статус</span>
              <select>
                <option>Активен</option>
                <option>Черновик</option>
                <option>Архив</option>
              </select>
            </label>
            <label class="field-label">
              <span>Длительность</span>
              <input value="4 часа" placeholder="4 часа" />
            </label>
          </div>
        </section>

        <section class="chart-card">
          <div class="section-head compact">
            <h2>Предпросмотр</h2>
          </div>
          <div class="editor-preview">
            <BookOpen :size="48" />
          </div>
        </section>
      </aside>
    </div>
  </section>

  <section v-else class="page">
    <div class="section-head">
      <div>
        <h1>Обучение</h1>
        <p>Управление учебными материалами, модулями и статусами курсов.</p>
      </div>
      <button class="primary" @click="openEditor()"><Plus :size="19" />Создать курс</button>
    </div>
    <div class="toolbar">
      <SearchInput placeholder="Поиск курса..." />
      <select>
        <option>Все категории</option>
        <option>Безопасность</option>
        <option>Сервис</option>
        <option>Кухня</option>
      </select>
    </div>
    <div class="cards-grid">
      <CourseCard v-for="course in courses" :key="course.id" :course="course" @edit="openEditor" />
    </div>
  </section>
</template>

<script setup>
import { ref } from 'vue';
import { BookOpen, Plus, Trash2 } from 'lucide-vue-next';
import SearchInput from '../components/SearchInput.vue';
import CourseCard from '../components/CourseCard.vue';
import { courses } from '../data/courses';

const showEditor = ref(false);
const editingCourse = ref(null);
const modules = [
  { id: 1, title: 'Модуль 1: Введение', placeholder: 'Содержание модуля...' },
  { id: 2, title: 'Модуль 2: Практические стандарты', placeholder: 'Содержание модуля...' },
  { id: 3, title: 'Модуль 3: Проверка знаний', placeholder: 'Содержание модуля...' },
];

const openEditor = (course = null) => {
  editingCourse.value = course;
  showEditor.value = true;
};

const closeEditor = () => {
  editingCourse.value = null;
  showEditor.value = false;
};
</script>
