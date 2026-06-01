/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_fee0104
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_fee0104
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_fee0104 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_fee0104(
    inr varchar2(12) -- 主键
    ,trninr varchar2(12) -- trn主键
    ,credattim timestamp -- 创建时间
    ,seq varchar2(3) -- 序号
    ,client_no varchar2(30) -- 客户号
    ,fee_type varchar2(18) -- 汇率类别
    ,fee_ccy varchar2(5) -- 帐户动作收用币种
    ,fee_amt number(17,2) -- 账户动作收用金额
    ,fee_charge_method varchar2(2) -- 服务手续费收取方式
    ,charge_mode varchar2(2) -- 收取标志
    ,charge_to_base_acct_no varchar2(75) -- 收取账号
    ,charge_to_acct_seq_no varchar2(5) -- 收取账号序号
    ,withdrawal_type varchar2(2) -- 支取方式码
    ,effect_date varchar2(12) -- 生效日期
    ,amort_start varchar2(12) -- 摊销起始日期
    ,amort_end varchar2(12) -- 摊销截止日期
    ,feecod varchar2(9) -- 交易类别
    ,ownkey varchar2(30) -- 业务编号
    ,othcli varchar2(30) -- 外层客户号
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
grant select on ${iol_schema}.isbs_fee0104 to ${iml_schema};
grant select on ${iol_schema}.isbs_fee0104 to ${icl_schema};
grant select on ${iol_schema}.isbs_fee0104 to ${idl_schema};
grant select on ${iol_schema}.isbs_fee0104 to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_fee0104 is '';
comment on column ${iol_schema}.isbs_fee0104.inr is '主键';
comment on column ${iol_schema}.isbs_fee0104.trninr is 'trn主键';
comment on column ${iol_schema}.isbs_fee0104.credattim is '创建时间';
comment on column ${iol_schema}.isbs_fee0104.seq is '序号';
comment on column ${iol_schema}.isbs_fee0104.client_no is '客户号';
comment on column ${iol_schema}.isbs_fee0104.fee_type is '汇率类别';
comment on column ${iol_schema}.isbs_fee0104.fee_ccy is '帐户动作收用币种';
comment on column ${iol_schema}.isbs_fee0104.fee_amt is '账户动作收用金额';
comment on column ${iol_schema}.isbs_fee0104.fee_charge_method is '服务手续费收取方式';
comment on column ${iol_schema}.isbs_fee0104.charge_mode is '收取标志';
comment on column ${iol_schema}.isbs_fee0104.charge_to_base_acct_no is '收取账号';
comment on column ${iol_schema}.isbs_fee0104.charge_to_acct_seq_no is '收取账号序号';
comment on column ${iol_schema}.isbs_fee0104.withdrawal_type is '支取方式码';
comment on column ${iol_schema}.isbs_fee0104.effect_date is '生效日期';
comment on column ${iol_schema}.isbs_fee0104.amort_start is '摊销起始日期';
comment on column ${iol_schema}.isbs_fee0104.amort_end is '摊销截止日期';
comment on column ${iol_schema}.isbs_fee0104.feecod is '交易类别';
comment on column ${iol_schema}.isbs_fee0104.ownkey is '业务编号';
comment on column ${iol_schema}.isbs_fee0104.othcli is '外层客户号';
comment on column ${iol_schema}.isbs_fee0104.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_fee0104.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_fee0104.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_fee0104.etl_timestamp is 'ETL处理时间戳';
