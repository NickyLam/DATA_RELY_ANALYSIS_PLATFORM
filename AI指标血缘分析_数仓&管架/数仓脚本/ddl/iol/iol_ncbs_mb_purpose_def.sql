/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_mb_purpose_def
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_mb_purpose_def
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_mb_purpose_def purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_purpose_def(
    remark varchar2(600) -- 备注
    ,company varchar2(20) -- 法人
    ,purpose_id varchar2(50) -- 用途编号
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,day_limit number(17,2) -- 单日发放额度
    ,once_limit number(17,2) -- 单次发放额度
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
grant select on ${iol_schema}.ncbs_mb_purpose_def to ${iml_schema};
grant select on ${iol_schema}.ncbs_mb_purpose_def to ${icl_schema};
grant select on ${iol_schema}.ncbs_mb_purpose_def to ${idl_schema};
grant select on ${iol_schema}.ncbs_mb_purpose_def to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_mb_purpose_def is '卡易贷贷款用途定义表';
comment on column ${iol_schema}.ncbs_mb_purpose_def.remark is '备注';
comment on column ${iol_schema}.ncbs_mb_purpose_def.company is '法人';
comment on column ${iol_schema}.ncbs_mb_purpose_def.purpose_id is '用途编号';
comment on column ${iol_schema}.ncbs_mb_purpose_def.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_mb_purpose_def.day_limit is '单日发放额度';
comment on column ${iol_schema}.ncbs_mb_purpose_def.once_limit is '单次发放额度';
comment on column ${iol_schema}.ncbs_mb_purpose_def.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_mb_purpose_def.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_mb_purpose_def.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_mb_purpose_def.etl_timestamp is 'ETL处理时间戳';
