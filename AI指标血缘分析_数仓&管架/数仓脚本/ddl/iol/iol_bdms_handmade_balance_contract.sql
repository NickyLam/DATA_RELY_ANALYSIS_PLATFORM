/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_handmade_balance_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_handmade_balance_contract
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_handmade_balance_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_handmade_balance_contract(
    id varchar2(60) -- 主键ID
    ,systid varchar2(45) -- 系统代号
    ,brchcd varchar2(14) -- 财务机构编号
    ,prodcd varchar2(15) -- 解析产品
    ,bsnssq varchar2(50) -- 全局流水
    ,transq varchar2(96) -- 交易流水
    ,trprcd varchar2(12) -- 金额类型
    ,crcycd varchar2(5) -- 币种
    ,tranam number(20,2) -- 交易金额
    ,trade_direct varchar2(12) -- 交易方向
    ,assis1 varchar2(45) -- 可售产品
    ,assis2 varchar2(45) -- 辅助核算2
    ,channel varchar2(45) -- 渠道
    ,acct_status varchar2(3) -- 记账状态
    ,atfid varchar2(96) -- 冲抹原交易流水
    ,trandt varchar2(12) -- 交易日期
    ,datex0 varchar2(9) -- 交易时间
    ,tfid number(22) -- 原交易流水ID
    ,custcd varchar2(48) -- 客户号
    ,prcscd varchar2(24) -- 交易码
    ,balance_flag varchar2(3) -- 余额统计标志
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
grant select on ${iol_schema}.bdms_handmade_balance_contract to ${iml_schema};
grant select on ${iol_schema}.bdms_handmade_balance_contract to ${icl_schema};
grant select on ${iol_schema}.bdms_handmade_balance_contract to ${idl_schema};
grant select on ${iol_schema}.bdms_handmade_balance_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_handmade_balance_contract is '手工调账批次表';
comment on column ${iol_schema}.bdms_handmade_balance_contract.id is '主键ID';
comment on column ${iol_schema}.bdms_handmade_balance_contract.systid is '系统代号';
comment on column ${iol_schema}.bdms_handmade_balance_contract.brchcd is '财务机构编号';
comment on column ${iol_schema}.bdms_handmade_balance_contract.prodcd is '解析产品';
comment on column ${iol_schema}.bdms_handmade_balance_contract.bsnssq is '全局流水';
comment on column ${iol_schema}.bdms_handmade_balance_contract.transq is '交易流水';
comment on column ${iol_schema}.bdms_handmade_balance_contract.trprcd is '金额类型';
comment on column ${iol_schema}.bdms_handmade_balance_contract.crcycd is '币种';
comment on column ${iol_schema}.bdms_handmade_balance_contract.tranam is '交易金额';
comment on column ${iol_schema}.bdms_handmade_balance_contract.trade_direct is '交易方向';
comment on column ${iol_schema}.bdms_handmade_balance_contract.assis1 is '可售产品';
comment on column ${iol_schema}.bdms_handmade_balance_contract.assis2 is '辅助核算2';
comment on column ${iol_schema}.bdms_handmade_balance_contract.channel is '渠道';
comment on column ${iol_schema}.bdms_handmade_balance_contract.acct_status is '记账状态';
comment on column ${iol_schema}.bdms_handmade_balance_contract.atfid is '冲抹原交易流水';
comment on column ${iol_schema}.bdms_handmade_balance_contract.trandt is '交易日期';
comment on column ${iol_schema}.bdms_handmade_balance_contract.datex0 is '交易时间';
comment on column ${iol_schema}.bdms_handmade_balance_contract.tfid is '原交易流水ID';
comment on column ${iol_schema}.bdms_handmade_balance_contract.custcd is '客户号';
comment on column ${iol_schema}.bdms_handmade_balance_contract.prcscd is '交易码';
comment on column ${iol_schema}.bdms_handmade_balance_contract.balance_flag is '余额统计标志';
comment on column ${iol_schema}.bdms_handmade_balance_contract.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.bdms_handmade_balance_contract.etl_timestamp is 'ETL处理时间戳';
