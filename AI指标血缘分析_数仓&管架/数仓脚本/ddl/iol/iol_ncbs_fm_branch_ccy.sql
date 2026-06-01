/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_fm_branch_ccy
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_fm_branch_ccy
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_fm_branch_ccy purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_branch_ccy(
    branch varchar2(12) -- 机构编号
    ,ccy varchar2(3) -- 币种
    ,company varchar2(20) -- 法人
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_fm_branch_ccy to ${iml_schema};
grant select on ${iol_schema}.ncbs_fm_branch_ccy to ${icl_schema};
grant select on ${iol_schema}.ncbs_fm_branch_ccy to ${idl_schema};
grant select on ${iol_schema}.ncbs_fm_branch_ccy to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_fm_branch_ccy is '机构币种表';
comment on column ${iol_schema}.ncbs_fm_branch_ccy.branch is '机构编号';
comment on column ${iol_schema}.ncbs_fm_branch_ccy.ccy is '币种';
comment on column ${iol_schema}.ncbs_fm_branch_ccy.company is '法人';
comment on column ${iol_schema}.ncbs_fm_branch_ccy.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_fm_branch_ccy.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_fm_branch_ccy.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_fm_branch_ccy.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_fm_branch_ccy.etl_timestamp is 'ETL处理时间戳';
