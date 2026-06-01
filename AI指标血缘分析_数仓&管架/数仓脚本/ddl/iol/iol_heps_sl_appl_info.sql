/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol heps_sl_appl_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.heps_sl_appl_info
whenever sqlerror continue none;
drop table ${iol_schema}.heps_sl_appl_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.heps_sl_appl_info(
    flow_no varchar2(50) -- 业务流水号
    ,sl_house_nature varchar2(60) -- 赎楼对应房产性质
    ,sl_house_name varchar2(90) -- 赎楼对应房产名称
    ,is_gage_sts varchar2(5) -- 赎楼对应房产抵押状态
    ,house_gage_owner varchar2(90) -- 赎楼对应房产抵押权人
    ,o_loan_bk varchar2(30) -- 原贷款银行
    ,o_loan_spls_cptl number(16,2) -- 原贷款剩余本金
    ,next_bk_reply_amt number(16,2) -- 下一手银行批复金额
    ,sl_type varchar2(5) -- 赎楼类型
    ,transaction_amt number(16,2) -- 交易价格
    ,price_amt number(16,2) -- 定价金额
    ,capital_super_amt number(16,2) -- 资金监管金额
    ,cus_source varchar2(20) -- 客户来源
    ,guar_com_id varchar2(60) -- 担保公司编号
    ,create_time date -- 创建时间
    ,update_time date -- 更细时间
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
grant select on ${iol_schema}.heps_sl_appl_info to ${iml_schema};
grant select on ${iol_schema}.heps_sl_appl_info to ${icl_schema};
grant select on ${iol_schema}.heps_sl_appl_info to ${idl_schema};
grant select on ${iol_schema}.heps_sl_appl_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.heps_sl_appl_info is '赎楼业务信息';
comment on column ${iol_schema}.heps_sl_appl_info.flow_no is '业务流水号';
comment on column ${iol_schema}.heps_sl_appl_info.sl_house_nature is '赎楼对应房产性质';
comment on column ${iol_schema}.heps_sl_appl_info.sl_house_name is '赎楼对应房产名称';
comment on column ${iol_schema}.heps_sl_appl_info.is_gage_sts is '赎楼对应房产抵押状态';
comment on column ${iol_schema}.heps_sl_appl_info.house_gage_owner is '赎楼对应房产抵押权人';
comment on column ${iol_schema}.heps_sl_appl_info.o_loan_bk is '原贷款银行';
comment on column ${iol_schema}.heps_sl_appl_info.o_loan_spls_cptl is '原贷款剩余本金';
comment on column ${iol_schema}.heps_sl_appl_info.next_bk_reply_amt is '下一手银行批复金额';
comment on column ${iol_schema}.heps_sl_appl_info.sl_type is '赎楼类型';
comment on column ${iol_schema}.heps_sl_appl_info.transaction_amt is '交易价格';
comment on column ${iol_schema}.heps_sl_appl_info.price_amt is '定价金额';
comment on column ${iol_schema}.heps_sl_appl_info.capital_super_amt is '资金监管金额';
comment on column ${iol_schema}.heps_sl_appl_info.cus_source is '客户来源';
comment on column ${iol_schema}.heps_sl_appl_info.guar_com_id is '担保公司编号';
comment on column ${iol_schema}.heps_sl_appl_info.create_time is '创建时间';
comment on column ${iol_schema}.heps_sl_appl_info.update_time is '更细时间';
comment on column ${iol_schema}.heps_sl_appl_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.heps_sl_appl_info.etl_timestamp is 'ETL处理时间戳';
