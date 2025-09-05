;; script: with a block scalar (| or >)
((block_mapping_pair
  key: (flow_node (plain_scalar (string_scalar) @key (#eq? @key "script")))
  value: (block_node
    (block_scalar) @injection.content))
 (#set! injection.language "bash"))

;; script: as a sequence of strings (list)
((block_mapping_pair
  key: (flow_node (plain_scalar (string_scalar) @key (#eq? @key "script")))
  value: (block_node
    (block_sequence
      (block_sequence_item
        (flow_node (plain_scalar (string_scalar) @injection.content))))))
 (#set! injection.language "bash"))

;; script: as a single plain string
((block_mapping_pair
  key: (flow_node (plain_scalar (string_scalar) @key (#eq? @key "script")))
  value: (flow_node (plain_scalar (string_scalar) @injection.content)))
 (#set! injection.language "bash"))

;; script: as a single quoted string
((block_mapping_pair
  key: (flow_node (plain_scalar (string_scalar) @key (#eq? @key "script")))
  value: (flow_node (quoted_scalar (string_scalar) @injection.content)))
 (#set! injection.language "bash"))
