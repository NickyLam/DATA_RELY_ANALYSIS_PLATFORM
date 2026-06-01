/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_voucher_exchange
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_voucher_exchange
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_voucher_exchange purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_voucher_exchange(
    ccy varchar2(3) -- 币种
    ,doc_type varchar2(10) -- 凭证类型
    ,reference varchar2(50) -- 交易参考号
    ,company varchar2(20) -- 法人
    ,prefix varchar2(10) -- 前缀
    ,voucher_num number(6) -- 凭证数量
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,tran_amt number(17,2) -- 交易金额
    ,voucher_end_no varchar2(50) -- 凭证终止号码
    ,voucher_start_no varchar2(50) -- 凭证起始号码
    ,tb_exchange_detail_id varchar2(50) -- 尾箱交接明细编号
    ,tb_exchange_id varchar2(50) -- 尾箱交接编号
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
grant select on ${iol_schema}.ncbs_tb_voucher_exchange to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_voucher_exchange to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_voucher_exchange to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_voucher_exchange to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_voucher_exchange is '尾箱交接凭证信息表';
comment on column ${iol_schema}.ncbs_tb_voucher_exchange.ccy is '币种';
comment on column ${iol_schema}.ncbs_tb_voucher_exchange.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_tb_voucher_exchange.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_tb_voucher_exchange.company is '法人';
comment on column ${iol_schema}.ncbs_tb_voucher_exchange.prefix is '前缀';
comment on column ${iol_schema}.ncbs_tb_voucher_exchange.voucher_num is '凭证数量';
comment on column ${iol_schema}.ncbs_tb_voucher_exchange.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_voucher_exchange.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_tb_voucher_exchange.voucher_end_no is '凭证终止号码';
comment on column ${iol_schema}.ncbs_tb_voucher_exchange.voucher_start_no is '凭证起始号码';
comment on column ${iol_schema}.ncbs_tb_voucher_exchange.tb_exchange_detail_id is '尾箱交接明细编号';
comment on column ${iol_schema}.ncbs_tb_voucher_exchange.tb_exchange_id is '尾箱交接编号';
comment on column ${iol_schema}.ncbs_tb_voucher_exchange.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_voucher_exchange.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_voucher_exchange.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_voucher_exchange.etl_timestamp is 'ETL处理时间戳';
