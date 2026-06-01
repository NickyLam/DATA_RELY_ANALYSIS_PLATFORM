/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wmps_tbshareextend1
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wmps_tbshareextend1
whenever sqlerror continue none;
drop table ${iol_schema}.wmps_tbshareextend1 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wmps_tbshareextend1(
    in_client_no varchar2(20) -- 内部客户编号
    ,bank_no varchar2(9) -- 银行代码:租户编号(多租户模式用)
    ,seller_code varchar2(9) -- 销售商代码
    ,client_no varchar2(24) -- 银行客户号
    ,bank_acc varchar2(64) -- 资金账号
    ,ta_code varchar2(18) -- ta代码
    ,prd_code varchar2(32) -- 产品代码
    ,buy_amt_onway number(18,2) -- 在途申购金额
    ,red_exp_amt number(18,2) -- 已导出赎回金额
    ,red_income number(18,2) -- 已赎回未付收益
    ,income_prev_date number(18,2) -- 未付收益(上一日)
    ,income_upd_date number(22) -- 收益更新日期
    ,last_date number(22) -- 最后更新日期
    ,incomeonway_flag varchar2(1) -- 未付收益正负
    ,redall_flag varchar2(1) -- 全额赎回标志
    ,redall_trans_date number(22) -- 全额赎回交易日期
    ,integer1 number(22) -- 备用整型1
    ,integer2 number(22) -- 备用整型2
    ,integer3 number(22) -- 备用整型3
    ,amt1 number(18,2) -- 备用金额1
    ,amt2 number(18,2) -- 备用金额2
    ,amt3 number(18,2) -- 备用金额3
    ,amt4 number(18,2) -- 备用金额4
    ,amt5 number(18,2) -- 备用金额5
    ,reserve1 varchar2(250) -- 保留字段1
    ,reserve2 varchar2(250) -- 保留字段2
    ,reserve3 varchar2(250) -- 保留字段3
    ,reserve4 varchar2(250) -- 保留字段4
    ,reserve5 varchar2(250) -- 保留字段5
    ,batch_no varchar2(32) -- 批次号
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
grant select on ${iol_schema}.wmps_tbshareextend1 to ${iml_schema};
grant select on ${iol_schema}.wmps_tbshareextend1 to ${icl_schema};
grant select on ${iol_schema}.wmps_tbshareextend1 to ${idl_schema};
grant select on ${iol_schema}.wmps_tbshareextend1 to ${iel_schema};

-- comment
comment on table ${iol_schema}.wmps_tbshareextend1 is '销售端份额信息扩展表';
comment on column ${iol_schema}.wmps_tbshareextend1.in_client_no is '内部客户编号';
comment on column ${iol_schema}.wmps_tbshareextend1.bank_no is '银行代码:租户编号(多租户模式用)';
comment on column ${iol_schema}.wmps_tbshareextend1.seller_code is '销售商代码';
comment on column ${iol_schema}.wmps_tbshareextend1.client_no is '银行客户号';
comment on column ${iol_schema}.wmps_tbshareextend1.bank_acc is '资金账号';
comment on column ${iol_schema}.wmps_tbshareextend1.ta_code is 'ta代码';
comment on column ${iol_schema}.wmps_tbshareextend1.prd_code is '产品代码';
comment on column ${iol_schema}.wmps_tbshareextend1.buy_amt_onway is '在途申购金额';
comment on column ${iol_schema}.wmps_tbshareextend1.red_exp_amt is '已导出赎回金额';
comment on column ${iol_schema}.wmps_tbshareextend1.red_income is '已赎回未付收益';
comment on column ${iol_schema}.wmps_tbshareextend1.income_prev_date is '未付收益(上一日)';
comment on column ${iol_schema}.wmps_tbshareextend1.income_upd_date is '收益更新日期';
comment on column ${iol_schema}.wmps_tbshareextend1.last_date is '最后更新日期';
comment on column ${iol_schema}.wmps_tbshareextend1.incomeonway_flag is '未付收益正负';
comment on column ${iol_schema}.wmps_tbshareextend1.redall_flag is '全额赎回标志';
comment on column ${iol_schema}.wmps_tbshareextend1.redall_trans_date is '全额赎回交易日期';
comment on column ${iol_schema}.wmps_tbshareextend1.integer1 is '备用整型1';
comment on column ${iol_schema}.wmps_tbshareextend1.integer2 is '备用整型2';
comment on column ${iol_schema}.wmps_tbshareextend1.integer3 is '备用整型3';
comment on column ${iol_schema}.wmps_tbshareextend1.amt1 is '备用金额1';
comment on column ${iol_schema}.wmps_tbshareextend1.amt2 is '备用金额2';
comment on column ${iol_schema}.wmps_tbshareextend1.amt3 is '备用金额3';
comment on column ${iol_schema}.wmps_tbshareextend1.amt4 is '备用金额4';
comment on column ${iol_schema}.wmps_tbshareextend1.amt5 is '备用金额5';
comment on column ${iol_schema}.wmps_tbshareextend1.reserve1 is '保留字段1';
comment on column ${iol_schema}.wmps_tbshareextend1.reserve2 is '保留字段2';
comment on column ${iol_schema}.wmps_tbshareextend1.reserve3 is '保留字段3';
comment on column ${iol_schema}.wmps_tbshareextend1.reserve4 is '保留字段4';
comment on column ${iol_schema}.wmps_tbshareextend1.reserve5 is '保留字段5';
comment on column ${iol_schema}.wmps_tbshareextend1.batch_no is '批次号';
comment on column ${iol_schema}.wmps_tbshareextend1.start_dt is '开始时间';
comment on column ${iol_schema}.wmps_tbshareextend1.end_dt is '结束时间';
comment on column ${iol_schema}.wmps_tbshareextend1.id_mark is '增删标志';
comment on column ${iol_schema}.wmps_tbshareextend1.etl_timestamp is 'ETL处理时间戳';
