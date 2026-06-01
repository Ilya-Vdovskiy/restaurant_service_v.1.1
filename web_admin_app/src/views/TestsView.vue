<template>
  <section v-if="showEditor" class="page">
    <div class="section-head">
      <div>
        <button class="back-link" @click="showEditor = false">← Назад к тестам</button>
        <h1>Конструктор теста</h1>
      </div>
      <button class="primary">Сохранить тест</button>
    </div>

    <div class="editor-layout">
      <div class="editor-main">
        <section class="chart-card">
          <div class="section-head compact">
            <h2>Информация о тесте</h2>
          </div>
          <div class="form-grid">
            <label class="field-label">
              <span>Название теста</span>
              <input placeholder="Введите название..." />
            </label>
            <label class="field-label">
              <span>Описание</span>
              <textarea placeholder="Опишите тест..."></textarea>
            </label>
          </div>
        </section>

        <section class="chart-card">
          <div class="section-head compact">
            <h2>Вопросы</h2>
            <button class="text-action"><Plus :size="16" />Добавить вопрос</button>
          </div>
          <div class="question-editor-list">
            <article v-for="question in questions" :key="question.id" class="question-editor-card">
              <div class="question-title-row">
                <label>
                  <span>Вопрос {{ question.id }}</span>
                  <input :value="question.text" placeholder="Введите вопрос..." />
                </label>
                <button class="danger-icon" aria-label="Удалить вопрос"><Trash2 :size="17" /></button>
              </div>

              <div class="answer-list">
                <p>Варианты ответов</p>
                <div v-for="option in ['A', 'B', 'C', 'D']" :key="option" class="answer-row">
                  <input type="radio" :name="`question-${question.id}`" />
                  <input :placeholder="`Вариант ${option}`" />
                  <button type="button" class="muted-icon" aria-label="Удалить вариант"><XCircle :size="17" /></button>
                </div>
                <button type="button" class="text-action small-action">+ Добавить вариант</button>
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
              <span>Ограничение по времени</span>
              <div class="inline-field">
                <input type="number" placeholder="30" />
                <span>мин</span>
              </div>
            </label>
            <label class="field-label">
              <span>Проходной балл</span>
              <div class="inline-field">
                <input type="number" placeholder="80" />
                <span>%</span>
              </div>
            </label>
            <label class="field-label">
              <span>Количество попыток</span>
              <select>
                <option>1 попытка</option>
                <option>2 попытки</option>
                <option>3 попытки</option>
                <option>Неограниченно</option>
              </select>
            </label>
            <label class="check-line">
              <input type="checkbox" />
              <span>Перемешивать вопросы</span>
            </label>
          </div>
        </section>

        <section class="chart-card">
          <div class="section-head compact">
            <h2>Статистика</h2>
          </div>
          <div class="stat-list">
            <p><span>Вопросов</span><b>{{ questions.length }}</b></p>
            <p><span>Макс. баллов</span><b>100</b></p>
            <p><span>Время</span><b>30 мин</b></p>
          </div>
        </section>
      </aside>
    </div>
  </section>

  <section v-else class="page">
    <div class="section-head">
      <div>
        <h1>Тесты</h1>
        <p>Экзамены, проходные баллы и ограничения по времени.</p>
      </div>
      <button class="primary" @click="showEditor = true"><Plus :size="19" />Создать тест</button>
    </div>
    <DataTable :columns="columns">
      <tr v-for="test in tests" :key="test.id">
        <td><strong>{{ test.title }}</strong></td>
        <td>{{ test.course }}</td>
        <td>{{ test.questions }}</td>
        <td>{{ test.passingScore }}%</td>
        <td>{{ test.timeLimit }} мин</td>
        <td><StatusBadge :label="test.status" /></td>
        <td><button class="ghost small" @click="showEditor = true">Редактировать</button></td>
      </tr>
    </DataTable>
  </section>
</template>

<script setup>
import { ref } from 'vue';
import { Plus, Trash2, XCircle } from 'lucide-vue-next';
import DataTable from '../components/DataTable.vue';
import StatusBadge from '../components/StatusBadge.vue';
import { tests } from '../data/tests';

const showEditor = ref(false);
const questions = [
  { id: 1, text: 'Какой основной принцип обслуживания гостей?' },
  { id: 2, text: 'Какая температура хранения готовых блюд считается безопасной?' },
  { id: 3, text: 'Как корректно работать с жалобой гостя?' },
];

const columns = [
  { label: 'Название' },
  { label: 'Курс' },
  { label: 'Вопросы' },
  { label: 'Проходной балл' },
  { label: 'Время' },
  { label: 'Статус' },
  { label: 'Действия' },
];
</script>
