/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ccdb_log_tran_com_money
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ccdb_log_tran_com_money
whenever sqlerror continue none;
drop table ${iol_schema}.ccdb_log_tran_com_money purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ccdb_log_tran_com_money(
    code varchar2(50) -- 主键
    ,connect_id varchar2(50) -- 呼叫流水号
    ,call_no varchar2(30) -- 呼入号码
    ,channel_code varchar2(10) -- 渠道编码（c/i）
    ,tran_code varchar2(40) -- 交易码
    ,trans_date date -- 交易时间
    ,permission_code varchar2(20) -- 功能编号
    ,return_code varchar2(50) -- 返回码
    ,return_message varchar2(2000) -- 返回信息
    ,cust_name varchar2(100) -- 客户姓名
    ,card_no varchar2(30) -- 转出账号
    ,open_bank_code varchar2(30) -- 转出开户行
    ,open_bank_name varchar2(300) -- 转出转出开户行名
    ,to_card_no varchar2(30) -- 转入账号
    ,to_cust_name varchar2(100) -- 转入方户名
    ,to_open_bank_code varchar2(30) -- 转入开户行号
    ,to_open_bank_name varchar2(300) -- 转入开户行名
    ,trans_type varchar2(30) -- 转账方式（1实时，2普通，3次日转账4加急实时）
    ,trans_money varchar2(30) -- 交易金额
    ,trans_free varchar2(30) -- 手续费
    ,currency varchar2(50) -- 币种
    ,trans_channel varchar2(50) -- 大小额渠道（ibps实时，beps小额，hvps加急实时debit_card借记卡）
    ,deposit_name varchar2(50) -- 存期
    ,transfer_flag varchar2(50) -- 转存标记(0否，1是)
    ,operator_code varchar2(50) -- 操作员工号
    ,sign_nework varchar2(300) -- 签约网点
    ,deposit_code varchar2(50) -- 存期代码
    ,dispost_type varchar2(50) -- 储蓄种类
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ccdb_log_tran_com_money to ${iml_schema};
grant select on ${iol_schema}.ccdb_log_tran_com_money to ${icl_schema};
grant select on ${iol_schema}.ccdb_log_tran_com_money to ${idl_schema};

-- comment
comment on table ${iol_schema}.ccdb_log_tran_com_money is '交易资金动账类表';
comment on column ${iol_schema}.ccdb_log_tran_com_money.code is '主键';
comment on column ${iol_schema}.ccdb_log_tran_com_money.connect_id is '呼叫流水号';
comment on column ${iol_schema}.ccdb_log_tran_com_money.call_no is '呼入号码';
comment on column ${iol_schema}.ccdb_log_tran_com_money.channel_code is '渠道编码（c/i）';
comment on column ${iol_schema}.ccdb_log_tran_com_money.tran_code is '交易码';
comment on column ${iol_schema}.ccdb_log_tran_com_money.trans_date is '交易时间';
comment on column ${iol_schema}.ccdb_log_tran_com_money.permission_code is '功能编号';
comment on column ${iol_schema}.ccdb_log_tran_com_money.return_code is '返回码';
comment on column ${iol_schema}.ccdb_log_tran_com_money.return_message is '返回信息';
comment on column ${iol_schema}.ccdb_log_tran_com_money.cust_name is '客户姓名';
comment on column ${iol_schema}.ccdb_log_tran_com_money.card_no is '转出账号';
comment on column ${iol_schema}.ccdb_log_tran_com_money.open_bank_code is '转出开户行';
comment on column ${iol_schema}.ccdb_log_tran_com_money.open_bank_name is '转出转出开户行名';
comment on column ${iol_schema}.ccdb_log_tran_com_money.to_card_no is '转入账号';
comment on column ${iol_schema}.ccdb_log_tran_com_money.to_cust_name is '转入方户名';
comment on column ${iol_schema}.ccdb_log_tran_com_money.to_open_bank_code is '转入开户行号';
comment on column ${iol_schema}.ccdb_log_tran_com_money.to_open_bank_name is '转入开户行名';
comment on column ${iol_schema}.ccdb_log_tran_com_money.trans_type is '转账方式（1实时，2普通，3次日转账4加急实时）';
comment on column ${iol_schema}.ccdb_log_tran_com_money.trans_money is '交易金额';
comment on column ${iol_schema}.ccdb_log_tran_com_money.trans_free is '手续费';
comment on column ${iol_schema}.ccdb_log_tran_com_money.currency is '币种';
comment on column ${iol_schema}.ccdb_log_tran_com_money.trans_channel is '大小额渠道（ibps实时，beps小额，hvps加急实时debit_card借记卡）';
comment on column ${iol_schema}.ccdb_log_tran_com_money.deposit_name is '存期';
comment on column ${iol_schema}.ccdb_log_tran_com_money.transfer_flag is '转存标记(0否，1是)';
comment on column ${iol_schema}.ccdb_log_tran_com_money.operator_code is '操作员工号';
comment on column ${iol_schema}.ccdb_log_tran_com_money.sign_nework is '签约网点';
comment on column ${iol_schema}.ccdb_log_tran_com_money.deposit_code is '存期代码';
comment on column ${iol_schema}.ccdb_log_tran_com_money.dispost_type is '储蓄种类';
comment on column ${iol_schema}.ccdb_log_tran_com_money.start_dt is '开始时间';
comment on column ${iol_schema}.ccdb_log_tran_com_money.end_dt is '结束时间';
comment on column ${iol_schema}.ccdb_log_tran_com_money.id_mark is '增删标志';
comment on column ${iol_schema}.ccdb_log_tran_com_money.etl_timestamp is 'ETL处理时间戳';
