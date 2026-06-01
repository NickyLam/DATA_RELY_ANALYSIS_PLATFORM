/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_crball
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_crball
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_crball purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_crball(
    act varchar2(54) -- 账号
    ,extkey varchar2(30) -- 客户号
    ,mon varchar2(9) -- 月份
    ,iramt number(18,2) -- 汇入累计
    ,oramt number(18,2) -- 汇出累计
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
grant select on ${iol_schema}.isbs_crball to ${iml_schema};
grant select on ${iol_schema}.isbs_crball to ${icl_schema};
grant select on ${iol_schema}.isbs_crball to ${idl_schema};
grant select on ${iol_schema}.isbs_crball to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_crball is '跨境电商账号结算量表';
comment on column ${iol_schema}.isbs_crball.act is '账号';
comment on column ${iol_schema}.isbs_crball.extkey is '客户号';
comment on column ${iol_schema}.isbs_crball.mon is '月份';
comment on column ${iol_schema}.isbs_crball.iramt is '汇入累计';
comment on column ${iol_schema}.isbs_crball.oramt is '汇出累计';
comment on column ${iol_schema}.isbs_crball.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.isbs_crball.etl_timestamp is 'ETL处理时间戳';
