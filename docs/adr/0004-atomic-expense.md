# ADR-0004 · Gasto atómico y `spent_cents` cacheado

- **Estado:** aceptado
- **Fecha:** 2026-11-14

## Contexto

Un gasto afecta tres hechos: el movimiento, el saldo de la cuenta y el acumulado del sobre. Un fallo intermedio dejaría el presupuesto inconsistente. Además, recalcular `spent_cents` sumando movimientos en cada lectura complica las consultas reactivas.

## Decisión

`DriftTransactionsRepository.recordExpense` ejecuta todo dentro de una transacción Drift:

1. Valida cuenta activa y sobre existente.
2. Inserta el movimiento.
3. Decrementa `accounts.balance_cents`.
4. Incrementa `envelope_allocations.spent_cents` (upsert por `envelope_id + month`).

Si cualquier paso lanza, la transacción revierte por completo. `spent_cents` es la fuente de verdad para el disponible del sobre; los reportes también lo leen.

## Consecuencias

- La prueba de atomicidad usa un trigger que aborta el paso 4 y verifica que no quedan filas ni saldos alterados.
- El «disponible» es O(1) al leer.
- Cambiar un gasto o borrarlo exigirá ajustar el caché en la misma transacción (aún no implementado).
- Los ingresos no tocan `spent_cents`; solo aumentan saldo y «Por asignar».
