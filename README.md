# constraint_layout

Android's beloved constraint layout for Flutter

# Comparison

## API


## Constraints
| Constraint Type | Included | Comment |
| :--- | :--- | :--- |
| Relative positioning | Yes | This is the main way of constraining views. |
| Margins | Yes | Margins are a fundamental part of any layout. |
| Centering positioning | Yes | Biases are to-be-added. |
| Circular positioning | No | Circular positioning is not supported. Will be added if there is demand. |
| Visibility behavior | - | Flutter doesnt have the concept of Visibility.GONE or Visibility.INVISIBLE |
| Dimension constraints | - | wrapContent behavior cannot be applied to `ConstraintLayout` itself. |
| Chains | No | Chains aren't supported. Will be added if there is demand. |
| Virtual Helpers objects | No | `Guideline`, `Barrier` and `Group` are not supported. |
| Optimizer | - | XML specific optimizers cannot be supported. |

