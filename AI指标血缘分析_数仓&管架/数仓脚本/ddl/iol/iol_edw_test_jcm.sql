whenever sqlerror continue none;
drop table iol.edw_test_jcm purge;

whenever sqlerror exit sql.sqlcode;
create table edw_test_jcm(
etl_dt      date,
execdate    timestamp(6)
);

