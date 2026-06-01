/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_pfp_brch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_pfp_brch
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_pfp_brch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_pfp_brch(
    stacid number(9) -- 账套标识
    ,brchcd varchar2(20) -- 组织编码
    ,brchtg varchar2(1) -- c：本年利润汇总t：未分配利润汇总
    ,smrytx varchar2(400) -- 摘要
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.tgls_pfp_brch to ${iml_schema};
grant select on ${iol_schema}.tgls_pfp_brch to ${icl_schema};
grant select on ${iol_schema}.tgls_pfp_brch to ${idl_schema};
grant select on ${iol_schema}.tgls_pfp_brch to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_pfp_brch is '本年利润汇总机构';
comment on column ${iol_schema}.tgls_pfp_brch.stacid is '账套标识';
comment on column ${iol_schema}.tgls_pfp_brch.brchcd is '组织编码';
comment on column ${iol_schema}.tgls_pfp_brch.brchtg is 'c：本年利润汇总t：未分配利润汇总';
comment on column ${iol_schema}.tgls_pfp_brch.smrytx is '摘要';
comment on column ${iol_schema}.tgls_pfp_brch.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_pfp_brch.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_pfp_brch.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_pfp_brch.etl_timestamp is 'ETL处理时间戳';
