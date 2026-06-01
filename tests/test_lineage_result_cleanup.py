from app.services.lineage_service import LineageService


def test_deduplicate_field_mappings_keeps_first_mapping_order():
    mappings = [
        {
            "source_table": "SRC",
            "source_column": "ID",
            "target_table": "TGT",
            "target_column": "ID",
            "procedure": "P1",
        },
        {
            "source_table": "SRC",
            "source_column": "ID",
            "target_table": "TGT",
            "target_column": "ID",
            "procedure": "P1",
        },
        {
            "source_table": "SRC",
            "source_column": "NAME",
            "target_table": "TGT",
            "target_column": "NAME",
            "procedure": "P1",
        },
    ]

    assert LineageService._deduplicate_field_mappings(mappings) == [
        mappings[0],
        mappings[2],
    ]
