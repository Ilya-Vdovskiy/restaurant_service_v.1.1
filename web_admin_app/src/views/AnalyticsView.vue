<template>
  <section class="page">
    <div class="page-title"><span>Аналитика</span><h1>Статистика результатов</h1><p>Фильтры, таблицы и визуальные блоки для контроля аттестации.</p></div>
    <div class="toolbar"><select><option>Все сотрудники</option></select><select><option>Все курсы</option></select><input type="date" value="2026-04-28" /><select><option>Все статусы</option><option>Сдано</option><option>Не сдано</option></select></div>
    <div class="grid three">
      <ChartCard title="Распределение баллов"><div class="score-bars"><span style="height:42%">60</span><span style="height:68%">70</span><span style="height:84%">80</span><span style="height:96%">90</span></div></ChartCard>
      <ChartCard title="Процент сдачи"><div class="donut"><b>86%</b></div></ChartCard>
      <ChartCard title="Динамика результатов">
        <div class="line-axis-chart">
          <svg viewBox="0 0 420 220" role="img" aria-label="Линейный график динамики результатов">
            <line x1="42" y1="20" x2="42" y2="176" class="chart-axis" />
            <line x1="42" y1="176" x2="398" y2="176" class="chart-axis" />
            <line v-for="y in [36, 72, 108, 144]" :key="y" x1="42" :y1="y" x2="398" :y2="y" class="chart-grid-line" />
            <polyline points="42,146 101,124 160,132 219,92 279,104 338,58 398,70" class="chart-line-fill" />
            <polyline points="42,146 101,124 160,132 219,92 279,104 338,58 398,70" class="chart-line" />
            <circle v-for="point in trendPoints" :key="point.label" :cx="point.x" :cy="point.y" r="5" class="chart-dot" />
            <text x="18" y="40" class="chart-label">100</text>
            <text x="24" y="108" class="chart-label">80</text>
            <text x="24" y="176" class="chart-label">60</text>
            <text v-for="point in trendPoints" :key="point.label + '-label'" :x="point.x" y="202" text-anchor="middle" class="chart-label">{{ point.label }}</text>
          </svg>
        </div>
      </ChartCard>
    </div>
    <DataTable :columns="columns">
      <tr v-for="item in results" :key="item.id">
        <td>{{ item.employee }}</td><td>{{ item.course }}</td><td>{{ item.date }}</td><td><strong>{{ item.score }}%</strong></td><td><StatusBadge :label="item.status" /></td>
      </tr>
    </DataTable>
    <ChartCard title="Сотрудники с низкими результатами">
      <div class="low-list"><p v-for="item in lowResults" :key="item.id">{{ item.employee }} <b>{{ item.score }}%</b></p></div>
    </ChartCard>
  </section>
</template>

<script setup>
import { computed } from 'vue';
import ChartCard from '../components/ChartCard.vue';
import DataTable from '../components/DataTable.vue';
import StatusBadge from '../components/StatusBadge.vue';
import { results } from '../data/results';
const columns = [{ label: 'Сотрудник' }, { label: 'Курс' }, { label: 'Дата' }, { label: 'Балл' }, { label: 'Статус' }];
const lowResults = computed(() => results.filter((item) => item.score < 75));
const trendPoints = [
  { label: 'Янв', x: 42, y: 146 },
  { label: 'Фев', x: 101, y: 124 },
  { label: 'Мар', x: 160, y: 132 },
  { label: 'Апр', x: 219, y: 92 },
  { label: 'Май', x: 279, y: 104 },
  { label: 'Июн', x: 338, y: 58 },
  { label: 'Июл', x: 398, y: 70 },
];
</script>
