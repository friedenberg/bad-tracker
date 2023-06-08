#! /usr/bin/env -S jq -r -f

def average:
  [.[] | tonumber]
  | (. | length) as $length
  | add / $length
  ;

[
  .[]
  | {
    week: (.date | strflocaltime("%Y-%W")),
    month: (.date | strflocaltime("%Y-%m")),
    day: (.date | strflocaltime("%Y-%m-%d")),
    date: (.date | strflocaltime("%Y-%m-%d")),
    types: .type,
    urgency: .urgency,
    pain: .pain
    # type_1: (if (.type | any(. == 1)) then 1 else 0 end),
    # type_2: (if (.type | any(. == 2)) then 1 else 0 end),
    # type_3: (if (.type | any(. == 3)) then 1 else 0 end),
    # type_4: (if (.type | any(. == 4)) then 1 else 0 end),
    # type_5: (if (.type | any(. == 5)) then 1 else 0 end),
    # type_6: (if (.type | any(. == 6)) then 1 else 0 end),
    # type_7: (if (.type | any(. == 7)) then 1 else 0 end)
  }
] | group_by(.month) | .[] | [
  .[0].date,
  (([.[] | .types | .[] | select(. == 1)] | length) / ([.[] | .types | .[]] | length)),
  (([.[] | .types | .[] | select(. == 2)] | length) / ([.[] | .types | .[]] | length)),
  (([.[] | .types | .[] | select(. == 3)] | length) / ([.[] | .types | .[]] | length)),
  (([.[] | .types | .[] | select(. == 4)] | length) / ([.[] | .types | .[]] | length)),
  (([.[] | .types | .[] | select(. == 5)] | length) / ([.[] | .types | .[]] | length)),
  (([.[] | .types | .[] | select(. == 6)] | length) / ([.[] | .types | .[]] | length)),
  (([.[] | .types | .[] | select(. == 7)] | length) / ([.[] | .types | .[]] | length)),
  (([.[] | if .urgency == 1 then 1 else 0 end] | add) / (. | length)),
  (([.[] | if .urgency == 2 then 1 else 0 end] | add) / (. | length)),
  (([.[] | if .urgency == 3 then 1 else 0 end] | add) / (. | length)),
  (([.[] | if .urgency == 4 then 1 else 0 end] | add) / (. | length)),
  (([.[] | if .urgency == 5 then 1 else 0 end] | add) / (. | length)),
  (([.[] | if .pain == 1 then 1 else 0 end] | add) / (. | length)),
  (([.[] | if .pain == 2 then 1 else 0 end] | add) / (. | length)),
  (([.[] | if .pain == 3 then 1 else 0 end] | add) / (. | length)),
  (([.[] | if .pain == 4 then 1 else 0 end] | add) / (. | length)),
  (([.[] | if .pain == 5 then 1 else 0 end] | add) / (. | length))
]
| @tsv
# [
#   .week,
#   .type_1
#   # (.date | strftime("%H")),
#   # (.urgency | text_scale_to_number),
#   # (.type | .[]),
#   # try (.type | average) catch 0,
#   # .urgency
#   # try (.urgency | average) catch 0
#   # try ((.type | max) - (.type | min)) catch 0
# ]
# | @tsv
