/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_stb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_stb
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_stb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_stb(
    tbl varchar2(9) -- 参数代码
    ,uil varchar2(3) -- 语种
    ,cod varchar2(12) -- 参数值
    ,txt varchar2(120) -- 注释
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
grant select on ${iol_schema}.isbs_stb to ${iml_schema};
grant select on ${iol_schema}.isbs_stb to ${icl_schema};
grant select on ${iol_schema}.isbs_stb to ${idl_schema};
grant select on ${iol_schema}.isbs_stb to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_stb is 'CodeTable内容';
comment on column ${iol_schema}.isbs_stb.tbl is '参数代码';
comment on column ${iol_schema}.isbs_stb.uil is '语种';
comment on column ${iol_schema}.isbs_stb.cod is '参数值';
comment on column ${iol_schema}.isbs_stb.txt is '注释';
comment on column ${iol_schema}.isbs_stb.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.isbs_stb.etl_timestamp is 'ETL处理时间戳';
