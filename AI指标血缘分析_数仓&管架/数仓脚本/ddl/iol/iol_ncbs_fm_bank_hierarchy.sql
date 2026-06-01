/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_fm_bank_hierarchy
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_fm_bank_hierarchy
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_fm_bank_hierarchy purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_bank_hierarchy(
    company varchar2(20) -- 法人
    ,hierarchy_level varchar2(10) -- 分行级别
    ,hierarchy_name varchar2(50) -- 层级说明
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,hierarchy_code varchar2(2) -- 机构级别
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
grant select on ${iol_schema}.ncbs_fm_bank_hierarchy to ${iml_schema};
grant select on ${iol_schema}.ncbs_fm_bank_hierarchy to ${icl_schema};
grant select on ${iol_schema}.ncbs_fm_bank_hierarchy to ${idl_schema};
grant select on ${iol_schema}.ncbs_fm_bank_hierarchy to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_fm_bank_hierarchy is '机构层次表';
comment on column ${iol_schema}.ncbs_fm_bank_hierarchy.company is '法人';
comment on column ${iol_schema}.ncbs_fm_bank_hierarchy.hierarchy_level is '分行级别';
comment on column ${iol_schema}.ncbs_fm_bank_hierarchy.hierarchy_name is '层级说明';
comment on column ${iol_schema}.ncbs_fm_bank_hierarchy.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_fm_bank_hierarchy.hierarchy_code is '机构级别';
comment on column ${iol_schema}.ncbs_fm_bank_hierarchy.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_fm_bank_hierarchy.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_fm_bank_hierarchy.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_fm_bank_hierarchy.etl_timestamp is 'ETL处理时间戳';
