/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_mb_prod_bal_default
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_mb_prod_bal_default
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_mb_prod_bal_default purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_prod_bal_default(
    ccy varchar2(3) -- 币种
    ,prod_type varchar2(12) -- 产品编号
    ,company varchar2(20) -- 法人
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,max_bal number(17,2) -- 最大余额
    ,min_bal number(17,2) -- 最小余额
    ,sg_max_amt number(17,2) -- 单笔认购最大金额
    ,sg_min_amt number(17,2) -- 单次最小支取金额
    ,remain_amount number(17,2) -- 留底金额
    ,init_amount number(17,2) -- 起存金额
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
grant select on ${iol_schema}.ncbs_mb_prod_bal_default to ${iml_schema};
grant select on ${iol_schema}.ncbs_mb_prod_bal_default to ${icl_schema};
grant select on ${iol_schema}.ncbs_mb_prod_bal_default to ${idl_schema};
grant select on ${iol_schema}.ncbs_mb_prod_bal_default to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_mb_prod_bal_default is '产品起存金额定义表';
comment on column ${iol_schema}.ncbs_mb_prod_bal_default.ccy is '币种';
comment on column ${iol_schema}.ncbs_mb_prod_bal_default.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_mb_prod_bal_default.company is '法人';
comment on column ${iol_schema}.ncbs_mb_prod_bal_default.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_mb_prod_bal_default.max_bal is '最大余额';
comment on column ${iol_schema}.ncbs_mb_prod_bal_default.min_bal is '最小余额';
comment on column ${iol_schema}.ncbs_mb_prod_bal_default.sg_max_amt is '单笔认购最大金额';
comment on column ${iol_schema}.ncbs_mb_prod_bal_default.sg_min_amt is '单次最小支取金额';
comment on column ${iol_schema}.ncbs_mb_prod_bal_default.remain_amount is '留底金额';
comment on column ${iol_schema}.ncbs_mb_prod_bal_default.init_amount is '起存金额';
comment on column ${iol_schema}.ncbs_mb_prod_bal_default.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_mb_prod_bal_default.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_mb_prod_bal_default.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_mb_prod_bal_default.etl_timestamp is 'ETL处理时间戳';
