# ADR-0003 · Dinero en centavos enteros

- **Estado:** aceptado
- **Fecha:** 2026-11-14

## Contexto

Los cálculos de presupuesto deben cuadrar exactamente: sumas de asignaciones, gastos y traspasos. Los `double` introducen errores de redondeo acumulativos.

## Decisión

Persistir y calcular todo monto como `int` de centavos (`amountCents`, `assignedCents`, `spentCents`, `balanceCents`). El parseo y formateo se concentran en `lib/core/money/money.dart`:

- `parseCents`: acepta coma o punto decimal, hasta dos decimales.
- `formatCents`: presenta con símbolo `$` y separador de miles.

La UI usa `MoneyText` con cifras tabulares para alinear columnas.

## Consecuencias

- Sumas y comparaciones exactas en SQL y Dart.
- Ninguna capa intermedia convierte a `double`; la conversión ocurre solo al pintar.
- Entradas inválidas se rechazan antes de tocar la base.
- Los reportes comparten el mismo formateador, incluido el PDF.
