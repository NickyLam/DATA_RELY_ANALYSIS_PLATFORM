/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_v_sth_stb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_v_sth_stb
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_v_sth_stb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_v_sth_stb(
    tbl varchar2(11) -- 码表代码
    ,nam varchar2(60) -- 码表名称
    ,cod varchar2(12) -- 码值代码
    ,txt varchar2(240) -- 码值名称
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.isbs_v_sth_stb to ${iml_schema};
grant select on ${iol_schema}.isbs_v_sth_stb to ${icl_schema};
grant select on ${iol_schema}.isbs_v_sth_stb to ${idl_schema};
grant select on ${iol_schema}.isbs_v_sth_stb to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_v_sth_stb is '码表视图';
comment on column ${iol_schema}.isbs_v_sth_stb.tbl is '码表代码';
comment on column ${iol_schema}.isbs_v_sth_stb.nam is '码表名称';
comment on column ${iol_schema}.isbs_v_sth_stb.cod is '码值代码';
comment on column ${iol_schema}.isbs_v_sth_stb.txt is '码值名称';
comment on column ${iol_schema}.isbs_v_sth_stb.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.isbs_v_sth_stb.etl_timestamp is 'ETL处理时间戳';
