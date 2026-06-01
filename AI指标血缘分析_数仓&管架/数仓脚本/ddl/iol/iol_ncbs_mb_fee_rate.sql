/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_mb_fee_rate
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_mb_fee_rate
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_mb_fee_rate purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_fee_rate(
    branch varchar2(12) -- 机构编号
    ,ccy varchar2(3) -- 币种
    ,company varchar2(20) -- 法人
    ,fee_type varchar2(20) -- 费率类型
    ,irl_seq_no varchar2(50) -- 费率编号
    ,effect_date date -- 产品生效日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,high_limit number(17,2) -- 收费金额上限
    ,low_limit number(17,2) -- 收费金额下限
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
grant select on ${iol_schema}.ncbs_mb_fee_rate to ${iml_schema};
grant select on ${iol_schema}.ncbs_mb_fee_rate to ${icl_schema};
grant select on ${iol_schema}.ncbs_mb_fee_rate to ${idl_schema};
grant select on ${iol_schema}.ncbs_mb_fee_rate to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_mb_fee_rate is '费率信息表';
comment on column ${iol_schema}.ncbs_mb_fee_rate.branch is '机构编号';
comment on column ${iol_schema}.ncbs_mb_fee_rate.ccy is '币种';
comment on column ${iol_schema}.ncbs_mb_fee_rate.company is '法人';
comment on column ${iol_schema}.ncbs_mb_fee_rate.fee_type is '费率类型';
comment on column ${iol_schema}.ncbs_mb_fee_rate.irl_seq_no is '费率编号';
comment on column ${iol_schema}.ncbs_mb_fee_rate.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_mb_fee_rate.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_mb_fee_rate.high_limit is '收费金额上限';
comment on column ${iol_schema}.ncbs_mb_fee_rate.low_limit is '收费金额下限';
comment on column ${iol_schema}.ncbs_mb_fee_rate.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_mb_fee_rate.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_mb_fee_rate.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_mb_fee_rate.etl_timestamp is 'ETL处理时间戳';
