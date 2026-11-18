# Glosario · KipuBudget

Vocabulario compartido entre UI, dominio y tests.
Los identificadores del código van en inglés; la interfaz, en español.

| Término (UI) | Identificador | Definición |
| --- | --- | --- |
| **Sobre** | `Envelope` | Bolsa lógica de dinero para un propósito (Comida, Alquiler). No es una cuenta bancaria. |
| **Grupo de sobres** | `EnvelopeGroup` | Agrupación visual y de orden de sobres (Vivienda, Vida diaria). |
| **Cuenta** | `Account` | Lugar donde existe el dinero real (efectivo, débito, crédito, ahorro). |
| **Saldo de cuenta** | `balanceCents` | Dinero disponible en la cuenta. Se actualiza con cada movimiento. |
| **Saldo inicial** | `openingBalanceCents` | Punto de partida de una cuenta al crearla; no genera movimiento. |
| **Movimiento** | `MoneyMovement` | Registro inmutable de ingreso, gasto o transferencia entre cuentas. |
| **Ingreso** | `MovementType.income` | Entrada de dinero a una cuenta. Alimenta «Por asignar». |
| **Gasto** | `MovementType.expense` | Salida de dinero de una cuenta; puede imputarse a un sobre. |
| **Transferencia** | `MovementType.transfer` | Traslado entre cuentas propias. No altera «Por asignar». |
| **Asignación** | `assignedCents` | Dinero del pool reservado a un sobre en un mes concreto. |
| **Gastado** | `spentCents` | Acumulado de gastos imputados a un sobre en el mes. Caché transaccional. |
| **Disponible** | `availableCents` | `asignado − gastado` de un sobre. Puede ser negativo. |
| **Por asignar** | `toAssignCents` | `Σ ingresos − Σ asignaciones`. Es global, no por mes. |
| **Base cero** | `zero-based` | Todo ingreso tiene un destino; «Por asignar» idealmente 0. |
| **Sobregiro** | `isOverage` | Disponible negativo. Se marca en coral y bloquea más gasto sin cobertura. |
| **Cobertura** | `moveBetweenEnvelopes` | Mover dinero asignado de un sobre a otro dentro del mes. |
| **Traspaso entre sobres** | `EnvelopeTransfer` | Registro histórico de una cobertura. No toca cuentas ni el pool. |
| **Regla de categorización** | `CategorisationRule` | Patrón de texto que sugiere un sobre al registrar un gasto. |
| **Patrón** | `pattern` | Subcadena buscada en la descripción, sin distinguir mayúsculas. |
| **Mes canónico** | `month` (`YYYY-MM`) | Clave de mes usada en asignaciones, traspasos y reportes. |
| **Centavos** | `amountCents` | Unidad monetaria entera. `$12.34` se guarda como `1234`. |
| **Informe mensual** | `MonthlyReport` | Resumen de activos, ingresos, gastos, sobres y movimientos de un mes. |
| **Flujo de caja** | `MonthlyCashFlow` | Ingresos y gastos por mes para la gráfica de analítica. |
| **Respaldo** | `exportBackup` | Copia consistente de la base SQLite (`VACUUM INTO`). |
| **Restauración** | `restoreBackup` | Reemplazo total de las tablas desde un respaldo válido. Operación destructiva. |
| **Bloqueo biométrico** | `biometric_enabled` | Ajuste que exige huella, rostro o credencial del dispositivo al abrir la app. Si no se puede leer el ajuste, la app queda bloqueada. |
| **Semilla** | `seedStarterData` | Datos mínimos del primer arranque para que la app sea usable. |

## Convenciones

- Montos: siempre `int` en centavos; nunca `double` en dominio ni persistencia.
- Fechas de movimiento: `DateTime` local; se guarda ISO-8601. Consultas usan `[from, to)`.
- Años/mes: texto `YYYY-MM` para poder ordenar y comparar en SQL.
- Errores de dominio: `DomainException` con mensaje en español listo para la UI.
- Capas: `domain/` define contratos; `data/` implementa; `presentation/` consume interfaces.
