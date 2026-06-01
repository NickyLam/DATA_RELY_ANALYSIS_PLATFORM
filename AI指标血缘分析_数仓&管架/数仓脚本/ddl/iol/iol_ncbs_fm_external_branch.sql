/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_fm_external_branch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_fm_external_branch
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_fm_external_branch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_external_branch(
    bank_code varchar2(20) -- 银行代码
    ,branch_name varchar2(200) -- 银行机构名称
    ,country varchar2(3) -- 国家
    ,company varchar2(20) -- 法人
    ,state varchar2(6) -- 行政区划(省、州)
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,branch_code varchar2(12) -- 外部金融机构代码
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
grant select on ${iol_schema}.ncbs_fm_external_branch to ${iml_schema};
grant select on ${iol_schema}.ncbs_fm_external_branch to ${icl_schema};
grant select on ${iol_schema}.ncbs_fm_external_branch to ${idl_schema};
grant select on ${iol_schema}.ncbs_fm_external_branch to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_fm_external_branch is '外部金融机构分行表';
comment on column ${iol_schema}.ncbs_fm_external_branch.bank_code is '银行代码';
comment on column ${iol_schema}.ncbs_fm_external_branch.branch_name is '银行机构名称';
comment on column ${iol_schema}.ncbs_fm_external_branch.country is '国家';
comment on column ${iol_schema}.ncbs_fm_external_branch.company is '法人';
comment on column ${iol_schema}.ncbs_fm_external_branch.state is '行政区划(省、州)';
comment on column ${iol_schema}.ncbs_fm_external_branch.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_fm_external_branch.branch_code is '外部金融机构代码';
comment on column ${iol_schema}.ncbs_fm_external_branch.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_fm_external_branch.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_fm_external_branch.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_fm_external_branch.etl_timestamp is 'ETL处理时间戳';
