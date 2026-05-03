<template>
  <section class="page">
    <div class="page-title">
      <span>Restaurant Service</span>
      <h1>Панель управления</h1>
      <p>Контроль обучения, аттестации и прогресса сотрудников ресторана.</p>
    </div>

    <div class="stats-grid">
      <StatCard label="Всего сотрудников" value="284" change="+12%" :icon="Users" />
      <StatCard label="Активные курсы" value="48" change="+3" :icon="BookOpen" />
      <StatCard label="Пройдено тестов" value="1 247" change="+18%" :icon="CheckCircle2" />
      <StatCard label="Средний балл" value="87.5%" change="+2.3%" :icon="Trophy" />
    </div>

    <div class="grid two">
      <ChartCard title="Успеваемость сотрудников" subtitle="Средний балл за последние месяцы">
        <div class="line-chart">
          <span v-for="(point, index) in performance" :key="point.month" :style="{ height: `${point.score}%` }">
            <i>{{ point.score }}</i><small>{{ point.month }}</small>
          </span>
        </div>
      </ChartCard>
      <ChartCard title="Процент сдачи тестов" subtitle="По ключевым направлениям">
        <div class="bar-list">
          <div v-for="item in passRate" :key="item.name">
            <strong>{{ item.name }}</strong>
            <ProgressBar :value="item.value" />
            <span>{{ item.value }}%</span>
          </div>
        </div>
      </ChartCard>
    </div>

    <div class="grid three">
      <ChartCard title="Быстрые действия">
        <div class="quick-actions">
          <RouterLink to="/training" class="action-tile"><BookPlus :size="22" />Создать курс</RouterLink>
          <RouterLink to="/tests" class="action-tile"><FilePlus2 :size="22" />Создать тест</RouterLink>
          <RouterLink to="/assignments" class="action-tile"><ClipboardPlus :size="22" />Назначить обучение</RouterLink>
        </div>
      </ChartCard>
      <ChartCard class="wide" title="Последняя активность">
        <div class="activity-list">
          <div v-for="item in activity" :key="item.person + item.time" class="activity-item">
            <div class="avatar">{{ item.person.split(' ').map((p) => p[0]).join('') }}</div>
            <p><strong>{{ item.person }}</strong> {{ item.text }} <small>{{ item.time }}</small></p>
            <StatusBadge :label="item.status" />
          </div>
        </div>
      </ChartCard>
    </div>
  </section>
</template>

<script setup>
import { RouterLink } from 'vue-router';
import { BookOpen, BookPlus, CheckCircle2, ClipboardPlus, FilePlus2, Trophy, Users } from 'lucide-vue-next';
import StatCard from '../components/StatCard.vue';
import ChartCard from '../components/ChartCard.vue';
import ProgressBar from '../components/ProgressBar.vue';
import StatusBadge from '../components/StatusBadge.vue';
import { activity } from '../data/results';

const performance = [
  { month: 'Янв', score: 78 },
  { month: 'Фев', score: 82 },
  { month: 'Мар', score: 85 },
  { month: 'Апр', score: 83 },
  { month: 'Май', score: 87 },
  { month: 'Июн', score: 88 },
];

const passRate = [
  { name: 'Безопасность', value: 92 },
  { name: 'Сервис', value: 88 },
  { name: 'Гигиена', value: 95 },
  { name: 'Менеджмент', value: 78 },
];
</script>
