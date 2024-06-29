export const limit_pool_abi = {
  "encoding": "1",
  "types": [
    {
      "typeId": 0,
      "type": "()",
      "components": [],
      "typeParameters": null
    },
    {
      "typeId": 1,
      "type": "(_, _)",
      "components": [
        {
          "name": "__tuple_element",
          "type": 21,
          "typeArguments": null
        },
        {
          "name": "__tuple_element",
          "type": 21,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 2,
      "type": "(_, _)",
      "components": [
        {
          "name": "__tuple_element",
          "type": 40,
          "typeArguments": null
        },
        {
          "name": "__tuple_element",
          "type": 40,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 3,
      "type": "(_, _, _)",
      "components": [
        {
          "name": "__tuple_element",
          "type": 40,
          "typeArguments": null
        },
        {
          "name": "__tuple_element",
          "type": 40,
          "typeArguments": null
        },
        {
          "name": "__tuple_element",
          "type": 27,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 4,
      "type": "(_, _, _, _)",
      "components": [
        {
          "name": "__tuple_element",
          "type": 21,
          "typeArguments": null
        },
        {
          "name": "__tuple_element",
          "type": 38,
          "typeArguments": null
        },
        {
          "name": "__tuple_element",
          "type": 40,
          "typeArguments": null
        },
        {
          "name": "__tuple_element",
          "type": 40,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 5,
      "type": "(_, _, _, _, _)",
      "components": [
        {
          "name": "__tuple_element",
          "type": 36,
          "typeArguments": [
            {
              "name": "",
              "type": 20,
              "typeArguments": null
            }
          ]
        },
        {
          "name": "__tuple_element",
          "type": 36,
          "typeArguments": [
            {
              "name": "",
              "type": 38,
              "typeArguments": null
            }
          ]
        },
        {
          "name": "__tuple_element",
          "type": 27,
          "typeArguments": null
        },
        {
          "name": "__tuple_element",
          "type": 40,
          "typeArguments": null
        },
        {
          "name": "__tuple_element",
          "type": 20,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 6,
      "type": "b256",
      "components": null,
      "typeParameters": null
    },
    {
      "typeId": 7,
      "type": "bool",
      "components": null,
      "typeParameters": null
    },
    {
      "typeId": 8,
      "type": "enum I64Error",
      "components": [
        {
          "name": "Overflow",
          "type": 0,
          "typeArguments": null
        },
        {
          "name": "DivisionByZero",
          "type": 0,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 9,
      "type": "enum Identity",
      "components": [
        {
          "name": "Address",
          "type": 12,
          "typeArguments": null
        },
        {
          "name": "ContractId",
          "type": 18,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 10,
      "type": "generic T",
      "components": null,
      "typeParameters": null
    },
    {
      "typeId": 11,
      "type": "raw untyped ptr",
      "components": null,
      "typeParameters": null
    },
    {
      "typeId": 12,
      "type": "struct Address",
      "components": [
        {
          "name": "bits",
          "type": 6,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 13,
      "type": "struct BurnLimitEvent",
      "components": [
        {
          "name": "pool_id",
          "type": 6,
          "typeArguments": null
        },
        {
          "name": "recipient",
          "type": 9,
          "typeArguments": null
        },
        {
          "name": "position_id",
          "type": 39,
          "typeArguments": null
        },
        {
          "name": "lower",
          "type": 20,
          "typeArguments": null
        },
        {
          "name": "upper",
          "type": 20,
          "typeArguments": null
        },
        {
          "name": "old_claim",
          "type": 20,
          "typeArguments": null
        },
        {
          "name": "new_claim",
          "type": 20,
          "typeArguments": null
        },
        {
          "name": "zero_for_one",
          "type": 7,
          "typeArguments": null
        },
        {
          "name": "liquidity_burned",
          "type": 40,
          "typeArguments": null
        },
        {
          "name": "token_in_claimed",
          "type": 40,
          "typeArguments": null
        },
        {
          "name": "token_out_burned",
          "type": 40,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 14,
      "type": "struct BurnLimitParams",
      "components": [
        {
          "name": "to",
          "type": 9,
          "typeArguments": null
        },
        {
          "name": "burn_percent",
          "type": 35,
          "typeArguments": null
        },
        {
          "name": "position_id",
          "type": 39,
          "typeArguments": null
        },
        {
          "name": "claim",
          "type": 20,
          "typeArguments": null
        },
        {
          "name": "zero_for_one",
          "type": 7,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 15,
      "type": "struct BurnRangeEvent",
      "components": [
        {
          "name": "pool_id",
          "type": 6,
          "typeArguments": null
        },
        {
          "name": "recipient",
          "type": 9,
          "typeArguments": null
        },
        {
          "name": "position_id",
          "type": 39,
          "typeArguments": null
        },
        {
          "name": "liquidity_burned",
          "type": 40,
          "typeArguments": null
        },
        {
          "name": "amount0_delta",
          "type": 21,
          "typeArguments": null
        },
        {
          "name": "amount1_delta",
          "type": 21,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 16,
      "type": "struct BurnRangeParams",
      "components": [
        {
          "name": "to",
          "type": 9,
          "typeArguments": null
        },
        {
          "name": "position_id",
          "type": 39,
          "typeArguments": null
        },
        {
          "name": "burn_percent",
          "type": 35,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 17,
      "type": "struct Bytes",
      "components": [
        {
          "name": "buf",
          "type": 29,
          "typeArguments": null
        },
        {
          "name": "len",
          "type": 40,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 18,
      "type": "struct ContractId",
      "components": [
        {
          "name": "bits",
          "type": 6,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 19,
      "type": "struct FeesParams",
      "components": [
        {
          "name": "protocol_swap_fee_0",
          "type": 37,
          "typeArguments": null
        },
        {
          "name": "protocol_swap_fee_1",
          "type": 37,
          "typeArguments": null
        },
        {
          "name": "protocol_fill_fee_0",
          "type": 37,
          "typeArguments": null
        },
        {
          "name": "protocol_fill_fee_1",
          "type": 37,
          "typeArguments": null
        },
        {
          "name": "set_fees_flags",
          "type": 7,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 20,
      "type": "struct I24",
      "components": [
        {
          "name": "underlying",
          "type": 39,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 21,
      "type": "struct I64",
      "components": [
        {
          "name": "underlying",
          "type": 40,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 22,
      "type": "struct InitPoolEvent",
      "components": [
        {
          "name": "pool_id",
          "type": 6,
          "typeArguments": null
        },
        {
          "name": "min_tick",
          "type": 20,
          "typeArguments": null
        },
        {
          "name": "max_tick",
          "type": 20,
          "typeArguments": null
        },
        {
          "name": "start_price",
          "type": 27,
          "typeArguments": null
        },
        {
          "name": "start_tick",
          "type": 20,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 23,
      "type": "struct MintLimitEvent",
      "components": [
        {
          "name": "pool_id",
          "type": 6,
          "typeArguments": null
        },
        {
          "name": "recipient",
          "type": 9,
          "typeArguments": null
        },
        {
          "name": "lower",
          "type": 20,
          "typeArguments": null
        },
        {
          "name": "upper",
          "type": 20,
          "typeArguments": null
        },
        {
          "name": "zero_for_one",
          "type": 7,
          "typeArguments": null
        },
        {
          "name": "position_id",
          "type": 39,
          "typeArguments": null
        },
        {
          "name": "epoch_last",
          "type": 39,
          "typeArguments": null
        },
        {
          "name": "amount_in",
          "type": 40,
          "typeArguments": null
        },
        {
          "name": "liquidity_minted",
          "type": 40,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 24,
      "type": "struct MintLimitParams",
      "components": [
        {
          "name": "to",
          "type": 9,
          "typeArguments": null
        },
        {
          "name": "amount",
          "type": 40,
          "typeArguments": null
        },
        {
          "name": "mint_percent",
          "type": 35,
          "typeArguments": null
        },
        {
          "name": "position_id",
          "type": 39,
          "typeArguments": null
        },
        {
          "name": "lower",
          "type": 20,
          "typeArguments": null
        },
        {
          "name": "upper",
          "type": 20,
          "typeArguments": null
        },
        {
          "name": "zero_for_one",
          "type": 7,
          "typeArguments": null
        },
        {
          "name": "callback_data",
          "type": 17,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 25,
      "type": "struct MintRangeEvent",
      "components": [
        {
          "name": "pool_id",
          "type": 6,
          "typeArguments": null
        },
        {
          "name": "recipient",
          "type": 9,
          "typeArguments": null
        },
        {
          "name": "lower",
          "type": 20,
          "typeArguments": null
        },
        {
          "name": "upper",
          "type": 20,
          "typeArguments": null
        },
        {
          "name": "position_id",
          "type": 39,
          "typeArguments": null
        },
        {
          "name": "liquidity_minted",
          "type": 40,
          "typeArguments": null
        },
        {
          "name": "amount0_delta",
          "type": 21,
          "typeArguments": null
        },
        {
          "name": "amount1_delta",
          "type": 21,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 26,
      "type": "struct MintRangeParams",
      "components": [
        {
          "name": "to",
          "type": 9,
          "typeArguments": null
        },
        {
          "name": "lower",
          "type": 20,
          "typeArguments": null
        },
        {
          "name": "upper",
          "type": 20,
          "typeArguments": null
        },
        {
          "name": "position_id",
          "type": 39,
          "typeArguments": null
        },
        {
          "name": "amount0",
          "type": 40,
          "typeArguments": null
        },
        {
          "name": "amount1",
          "type": 40,
          "typeArguments": null
        },
        {
          "name": "callback_data",
          "type": 17,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 27,
      "type": "struct Q64x64",
      "components": [
        {
          "name": "value",
          "type": 35,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 28,
      "type": "struct QuoteParams",
      "components": [
        {
          "name": "price_limit",
          "type": 27,
          "typeArguments": null
        },
        {
          "name": "amount",
          "type": 40,
          "typeArguments": null
        },
        {
          "name": "exact_in",
          "type": 7,
          "typeArguments": null
        },
        {
          "name": "zero_for_one",
          "type": 7,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 29,
      "type": "struct RawBytes",
      "components": [
        {
          "name": "ptr",
          "type": 11,
          "typeArguments": null
        },
        {
          "name": "cap",
          "type": 40,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 30,
      "type": "struct RawVec",
      "components": [
        {
          "name": "ptr",
          "type": 11,
          "typeArguments": null
        },
        {
          "name": "cap",
          "type": 40,
          "typeArguments": null
        }
      ],
      "typeParameters": [
        10
      ]
    },
    {
      "typeId": 31,
      "type": "struct SampleCountIncreased",
      "components": [
        {
          "name": "pool_id",
          "type": 6,
          "typeArguments": null
        },
        {
          "name": "new_sample_count_max",
          "type": 37,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 32,
      "type": "struct SnapshotLimitParams",
      "components": [
        {
          "name": "owner",
          "type": 9,
          "typeArguments": null
        },
        {
          "name": "burn_percent",
          "type": 35,
          "typeArguments": null
        },
        {
          "name": "position_id",
          "type": 39,
          "typeArguments": null
        },
        {
          "name": "claim",
          "type": 20,
          "typeArguments": null
        },
        {
          "name": "zero_for_one",
          "type": 7,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 33,
      "type": "struct SwapEvent",
      "components": [
        {
          "name": "pool_id",
          "type": 6,
          "typeArguments": null
        },
        {
          "name": "recipient",
          "type": 9,
          "typeArguments": null
        },
        {
          "name": "amount_in",
          "type": 40,
          "typeArguments": null
        },
        {
          "name": "amount_out",
          "type": 40,
          "typeArguments": null
        },
        {
          "name": "fee_growth_global0",
          "type": 38,
          "typeArguments": null
        },
        {
          "name": "fee_growth_global1",
          "type": 38,
          "typeArguments": null
        },
        {
          "name": "price",
          "type": 27,
          "typeArguments": null
        },
        {
          "name": "liquidity",
          "type": 40,
          "typeArguments": null
        },
        {
          "name": "fee_amount",
          "type": 40,
          "typeArguments": null
        },
        {
          "name": "tick_at_price",
          "type": 20,
          "typeArguments": null
        },
        {
          "name": "zero_for_one",
          "type": 7,
          "typeArguments": null
        },
        {
          "name": "exact_in",
          "type": 7,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 34,
      "type": "struct SwapParams",
      "components": [
        {
          "name": "to",
          "type": 9,
          "typeArguments": null
        },
        {
          "name": "price_limit",
          "type": 27,
          "typeArguments": null
        },
        {
          "name": "amount",
          "type": 40,
          "typeArguments": null
        },
        {
          "name": "exact_in",
          "type": 7,
          "typeArguments": null
        },
        {
          "name": "zero_for_one",
          "type": 7,
          "typeArguments": null
        },
        {
          "name": "callback_data",
          "type": 17,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 35,
      "type": "struct U128",
      "components": [
        {
          "name": "upper",
          "type": 40,
          "typeArguments": null
        },
        {
          "name": "lower",
          "type": 40,
          "typeArguments": null
        }
      ],
      "typeParameters": null
    },
    {
      "typeId": 36,
      "type": "struct Vec",
      "components": [
        {
          "name": "buf",
          "type": 30,
          "typeArguments": [
            {
              "name": "",
              "type": 10,
              "typeArguments": null
            }
          ]
        },
        {
          "name": "len",
          "type": 40,
          "typeArguments": null
        }
      ],
      "typeParameters": [
        10
      ]
    },
    {
      "typeId": 37,
      "type": "u16",
      "components": null,
      "typeParameters": null
    },
    {
      "typeId": 38,
      "type": "u256",
      "components": null,
      "typeParameters": null
    },
    {
      "typeId": 39,
      "type": "u32",
      "components": null,
      "typeParameters": null
    },
    {
      "typeId": 40,
      "type": "u64",
      "components": null,
      "typeParameters": null
    }
  ],
  "functions": [
    {
      "inputs": [
        {
          "name": "params",
          "type": 14,
          "typeArguments": null
        }
      ],
      "name": "burn_limit",
      "output": {
        "name": "",
        "type": 1,
        "typeArguments": null
      },
      "attributes": [
        {
          "name": "storage",
          "arguments": [
            "read",
            "write"
          ]
        }
      ]
    },
    {
      "inputs": [
        {
          "name": "params",
          "type": 16,
          "typeArguments": null
        }
      ],
      "name": "burn_range",
      "output": {
        "name": "",
        "type": 1,
        "typeArguments": null
      },
      "attributes": [
        {
          "name": "storage",
          "arguments": [
            "read",
            "write"
          ]
        }
      ]
    },
    {
      "inputs": [
        {
          "name": "params",
          "type": 19,
          "typeArguments": null
        }
      ],
      "name": "fees",
      "output": {
        "name": "",
        "type": 2,
        "typeArguments": null
      },
      "attributes": [
        {
          "name": "storage",
          "arguments": [
            "read",
            "write"
          ]
        }
      ]
    },
    {
      "inputs": [
        {
          "name": "new_sample_count_max",
          "type": 37,
          "typeArguments": null
        }
      ],
      "name": "increase_sample_count",
      "output": {
        "name": "",
        "type": 0,
        "typeArguments": null
      },
      "attributes": [
        {
          "name": "storage",
          "arguments": [
            "read",
            "write"
          ]
        }
      ]
    },
    {
      "inputs": [
        {
          "name": "start_price",
          "type": 27,
          "typeArguments": null
        }
      ],
      "name": "initialize",
      "output": {
        "name": "",
        "type": 0,
        "typeArguments": null
      },
      "attributes": [
        {
          "name": "storage",
          "arguments": [
            "read",
            "write"
          ]
        }
      ]
    },
    {
      "inputs": [
        {
          "name": "params",
          "type": 24,
          "typeArguments": null
        }
      ],
      "name": "mint_limit",
      "output": {
        "name": "",
        "type": 1,
        "typeArguments": null
      },
      "attributes": [
        {
          "name": "storage",
          "arguments": [
            "read",
            "write"
          ]
        }
      ]
    },
    {
      "inputs": [
        {
          "name": "params",
          "type": 26,
          "typeArguments": null
        }
      ],
      "name": "mint_range",
      "output": {
        "name": "",
        "type": 1,
        "typeArguments": null
      },
      "attributes": [
        {
          "name": "storage",
          "arguments": [
            "read",
            "write"
          ]
        }
      ]
    },
    {
      "inputs": [
        {
          "name": "params",
          "type": 28,
          "typeArguments": null
        }
      ],
      "name": "quote",
      "output": {
        "name": "",
        "type": 3,
        "typeArguments": null
      },
      "attributes": [
        {
          "name": "storage",
          "arguments": [
            "read"
          ]
        }
      ]
    },
    {
      "inputs": [
        {
          "name": "secondsAgo",
          "type": 36,
          "typeArguments": [
            {
              "name": "",
              "type": 39,
              "typeArguments": null
            }
          ]
        }
      ],
      "name": "sample",
      "output": {
        "name": "",
        "type": 5,
        "typeArguments": null
      },
      "attributes": [
        {
          "name": "storage",
          "arguments": [
            "read"
          ]
        }
      ]
    },
    {
      "inputs": [
        {
          "name": "params",
          "type": 32,
          "typeArguments": null
        }
      ],
      "name": "snapshot_limit",
      "output": {
        "name": "",
        "type": 2,
        "typeArguments": null
      },
      "attributes": [
        {
          "name": "storage",
          "arguments": [
            "read"
          ]
        }
      ]
    },
    {
      "inputs": [
        {
          "name": "position_id",
          "type": 39,
          "typeArguments": null
        }
      ],
      "name": "snapshot_range",
      "output": {
        "name": "",
        "type": 4,
        "typeArguments": null
      },
      "attributes": [
        {
          "name": "storage",
          "arguments": [
            "read"
          ]
        }
      ]
    },
    {
      "inputs": [
        {
          "name": "params",
          "type": 34,
          "typeArguments": null
        }
      ],
      "name": "swap",
      "output": {
        "name": "",
        "type": 1,
        "typeArguments": null
      },
      "attributes": [
        {
          "name": "storage",
          "arguments": [
            "read",
            "write"
          ]
        }
      ]
    }
  ],
  "loggedTypes": [
    {
      "logId": "8270131219760189612",
      "loggedType": {
        "name": "",
        "type": 13,
        "typeArguments": []
      }
    },
    {
      "logId": "12591881579666828212",
      "loggedType": {
        "name": "",
        "type": 15,
        "typeArguments": []
      }
    },
    {
      "logId": "4598085698273361370",
      "loggedType": {
        "name": "",
        "type": 31,
        "typeArguments": []
      }
    },
    {
      "logId": "2820793685322372861",
      "loggedType": {
        "name": "",
        "type": 22,
        "typeArguments": []
      }
    },
    {
      "logId": "6707969313597877536",
      "loggedType": {
        "name": "",
        "type": 23,
        "typeArguments": []
      }
    },
    {
      "logId": "16715308483435741526",
      "loggedType": {
        "name": "",
        "type": 8,
        "typeArguments": []
      }
    },
    {
      "logId": "4094768686226709746",
      "loggedType": {
        "name": "",
        "type": 25,
        "typeArguments": []
      }
    },
    {
      "logId": "12404834594863593261",
      "loggedType": {
        "name": "",
        "type": 33,
        "typeArguments": []
      }
    }
  ],
  "messagesTypes": [],
  "configurables": []
}