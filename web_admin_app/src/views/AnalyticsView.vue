<template>
  <section class="page">
    <div class="page-title"><span>Аналитика</span><h1>Статистика результатов</h1><p>Фильтры, таблицы и визуальные блоки для контроля аттестации.</p></div>
    <div class="toolbar"><select><option>Все сотрудники</option></select><select><option>Все курсы</option></select><input type="date" value="2026-04-28" /><select><option>Все статусы</option><option>Сдано</option><option>Не сдано</option></select></div>
    <div class="grid three">
      <ChartCard title="Распределение баллов"><div class="score-bars"><span style="height:42%">60</span><span style="height:68%">70</span><span style="height:84%">80</span><span style="height:96%">90</span></div></ChartCard>
      <ChartCard title="Процент сдачи"><div class="donut"><b>86%</b></div></ChartCard>
      <ChartCard title="Динамика результатов"><div class="sparkline"><i v-for="n in [34,52,46,72,64,88,81]" :key="n" :style="{height: n + '%'}"></i></div></ChartCard>
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
</script>
