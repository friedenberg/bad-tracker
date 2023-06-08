#! /usr/bin/env -S jq -s -r -f

def text_scale_to_number:
  {
    "Extremely urgent": 5,
    "Very urgent": 4,
    "Somewhat urgent": 3,
    "Not very urgent": 2,
    "Not at all urgent": 1,
  } as $lookup
  | if . == null then empty else $lookup[.] end
  ;

def text_scale_to_number_pain:
  {
    "Extremely painful or uncomfortable": 5,
    "Very painful or uncomfortable": 4,
    "Somewhat painful or uncomfortable": 3,
    "Not very painful or uncomfortable": 2,
    "Not at all painful or uncomfortable": 1,
  } as $lookup
  | if . == null then empty else $lookup[.] end
  ;

[
  .[]
  | .snapshots
  | .[]
  | {
    date: (.date | strptime("%Y-%m-%dT%H:%M:%S%z") | mktime),
    # type: (.responses[] | select(.questionPrompt == "Type") | .answeredOptions | .[]? | .[0:1]),
    type: [(.responses[] | select(.questionPrompt == "Type") | .answeredOptions | .[]? | .[0:1] | tonumber)],
    urgency: (.responses[] | select(.questionPrompt == "Urgency") | .answeredOptions[0] | text_scale_to_number),
    pain: (.responses[] | select(.questionPrompt == "Discomfort or pain") | .answeredOptions[0] | text_scale_to_number_pain),
    attributes: [(.responses[] | select(.questionPrompt == "Other attributes") | .tokens // [] | .[] | .text)],
  }
]
# | .[]
# | [
#   .date,
#   # (.date | strftime("%H")),
#   # (.urgency | text_scale_to_number),
#   # (.type | .[]),
#   try (.type | average) catch 0,
#   .urgency
#   # try (.urgency | average) catch 0
#   # try ((.type | max) - (.type | min)) catch 0
# ]
# # | [.date, .type, .urgency, .pain]
# | @tsv
