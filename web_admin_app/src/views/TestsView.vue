<template>
  <section class="page">
    <div class="section-head">
      <div><h1>Тесты</h1><p>Экзамены, проходные баллы и ограничения по времени.</p></div>
      <button class="primary" @click="modal = true"><Plus :size="19" />Создать тест</button>
    </div>
    <DataTable :columns="columns">
      <tr v-for="test in tests" :key="test.id">
        <td><strong>{{ test.title }}</strong></td><td>{{ test.course }}</td><td>{{ test.questions }}</td>
        <td>{{ test.passingScore }}%</td><td>{{ test.timeLimit }} мин</td><td><StatusBadge :label="test.status" /></td>
      </tr>
    </DataTable>
    <ChartCard title="Конструктор теста" subtitle="Быстрое представление структуры вопросов">
      <div class="question-builder">
        <div><h3>Вопрос 1</h3><p>Какая температура хранения готовых блюд считается безопасной?</p></div>
        <label><input type="radio" checked /> выше +65 °C</label><label><input type="radio" /> +25 °C</label><label><input type="radio" /> ниже +12 °C</label>
      </div>
    </ChartCard>
    <Modal :open="modal" title="Создание теста" subtitle="Форма-заглушка конструктора" @close="modal = false">
      <form class="form-grid" @submit.prevent="modal = false">
        <input placeholder="Название теста" value="Проверка стандартов сервиса" />
        <input placeholder="Курс" value="Сервис премиального ресторана" />
        <div class="split"><input placeholder="Проходной балл" value="80" /><input placeholder="Время, мин" value="30" /></div>
        <textarea placeholder="Вопрос">Опишите вопрос и варианты ответов...</textarea>
        <button class="primary">Сохранить тест</button>
      </form>
    </Modal>
  </section>
</template>

<script setup>
import { ref } from 'vue';
import { Plus } from 'lucide-vue-next';
import DataTable from '../components/DataTable.vue';
import StatusBadge from '../components/StatusBadge.vue';
import ChartCard from '../components/ChartCard.vue';
import Modal from '../components/Modal.vue';
import { tests } from '../data/tests';
const modal = ref(false);
const columns = [{ label: 'Название' }, { label: 'Курс' }, { label: 'Вопросы' }, { label: 'Проходной балл' }, { label: 'Время' }, { label: 'Статус' }];
</script>
