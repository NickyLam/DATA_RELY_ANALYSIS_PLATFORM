-- Create table
create table TAB_DATA_COMPARE_COUNT_ICL
(
  schema                  VARCHAR2(100),
  table_name              VARCHAR2(1000),
  count_table_user1       NUMBER,
  count_table_user2       NUMBER,
  count_user1_minus_user2 NUMBER,
  error_msg               VARCHAR2(4000),
  etl_timestamp           DATE
)
;

-- Create table
create table TAB_DATA_COMPARE_COUNT_IML
(
  schema                  VARCHAR2(100),
  table_name              VARCHAR2(1000),
  count_table_user1       NUMBER,
  count_table_user2       NUMBER,
  count_user1_minus_user2 NUMBER,
  error_msg               VARCHAR2(4000),
  etl_timestamp           DATE
)
;


-- Create table
create table TAB_DATA_COMPARE_COUNT_IOL
(
  schema                  VARCHAR2(100),
  table_name              VARCHAR2(1000),
  count_table_user1       NUMBER,
  count_table_user2       NUMBER,
  count_user1_minus_user2 NUMBER,
  error_msg               VARCHAR2(4000),
  etl_timestamp           DATE
)
;
