<template>
  <section class="page">
    <div class="section-head">
      <div>
        <h1>Сотрудники</h1>
        <p>Поиск, фильтрация и просмотр профилей сотрудников.</p>
      </div>
      <button class="primary"><UserPlus :size="19" />Добавить сотрудника</button>
    </div>

    <div class="toolbar">
      <SearchInput v-model="search" placeholder="Поиск по ФИО или должности..." />
      <select v-model="position"><option>Все должности</option><option v-for="item in positions" :key="item">{{ item }}</option></select>
      <select v-model="status"><option>Все статусы</option><option>Активен</option><option>На обучении</option><option>В отпуске</option></select>
    </div>

    <DataTable :columns="columns">
      <tr v-for="employee in filtered" :key="employee.id" @click="selected = employee">
        <td><span class="person"><b class="avatar small">{{ initials(employee.name) }}</b>{{ employee.name }}</span></td>
        <td>{{ employee.position }}</td>
        <td>{{ employee.department }}</td>
        <td><StatusBadge :label="employee.status" /></td>
        <td><ProgressBar :value="progress(employee)" /><small>{{ employee.completed }}/{{ employee.courses }} курсов</small></td>
        <td><strong :class="{ gold: employee.avgScore >= 90 }">{{ employee.avgScore }}%</strong></td>
        <td><button class="ghost small" @click.stop="selected = employee">Профиль</button></td>
      </tr>
    </DataTable>
    <EmptyState v-if="filtered.length === 0" />

    <div class="employee-cards">
      <EmployeeCard v-for="employee in filtered.slice(0, 4)" :key="employee.id" :employee="employee" @open="selected = $event" />
    </div>

    <Modal :open="!!selected" title="Профиль сотрудника" subtitle="Карточка обучения и аттестации" @close="selected = null">
      <div v-if="selected" class="profile-grid">
        <div class="profile-hero">
          <div class="avatar xl">{{ initials(selected.name) }}</div>
          <h3>{{ selected.name }}</h3>
          <p>{{ selected.position }} · {{ selected.department }}</p>
          <StatusBadge :label="selected.status" />
        </div>
        <div class="info-list">
          <p><span>Телефон</span>{{ selected.phone }}</p>
          <p><span>Email</span>{{ selected.email }}</p>
          <p><span>Дата найма</span>{{ selected.hired }}</p>
          <p><span>Общий прогресс</span>{{ progress(selected) }}%</p>
        </div>
      </div>
      <div class="modal-columns">
        <ChartCard title="Назначенные курсы">
          <p v-for="course in courses.slice(0, 3)" :key="course.id" class="list-line">{{ course.title }} <b>{{ course.progress }}%</b></p>
        </ChartCard>
        <ChartCard title="Результаты тестов">
          <p v-for="item in results.slice(0, 3)" :key="item.id" class="list-line">{{ item.test }} <b>{{ item.score }}%</b></p>
        </ChartCard>
        <ChartCard title="История активности">
          <p v-for="item in activity.slice(0, 3)" :key="item.time" class="list-line">{{ item.text }}</p>
        </ChartCard>
      </div>
    </Modal>
  </section>
</template>

<script setup>
import { computed, ref } from 'vue';
import { UserPlus } from 'lucide-vue-next';
import SearchInput from '../components/SearchInput.vue';
import DataTable from '../components/DataTable.vue';
import StatusBadge from '../components/StatusBadge.vue';
import ProgressBar from '../components/ProgressBar.vue';
import Modal from '../components/Modal.vue';
import ChartCard from '../components/ChartCard.vue';
import EmptyState from '../components/EmptyState.vue';
import EmployeeCard from '../components/EmployeeCard.vue';
import { employees } from '../data/employees';
import { courses } from '../data/courses';
import { activity, results } from '../data/results';

const search = ref('');
const position = ref('Все должности');
const status = ref('Все статусы');
const selected = ref(null);
const columns = [
  { key: 'name', label: 'ФИО' }, { key: 'position', label: 'Должность' }, { key: 'department', label: 'Подразделение' },
  { key: 'status', label: 'Статус' }, { key: 'progress', label: 'Прогресс' }, { key: 'score', label: 'Средний балл' }, { key: 'actions', label: 'Действия' },
];
const positions = [...new Set(employees.map((item) => item.position))];
const filtered = computed(() => employees.filter((employee) => {
  const text = `${employee.name} ${employee.position}`.toLowerCase();
  return text.includes(search.value.toLowerCase())
    && (position.value === 'Все должности' || employee.position === position.value)
    && (status.value === 'Все статусы' || employee.status === status.value);
}));
const initials = (name) => name.split(' ').map((part) => part[0]).join('');
const progress = (employee) => Math.round((employee.completed / employee.courses) * 100);
</script>
