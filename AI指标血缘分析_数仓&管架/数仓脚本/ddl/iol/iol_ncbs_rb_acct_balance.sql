/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_balance
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_balance
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_balance purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_balance(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,company varchar2(20) -- 法人
    ,dac_value varchar2(200) -- dac值防篡改加密
    ,last_bal_upd_date date -- 上次动户日期
    ,last_change_date date -- 最后修改日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,dos_amount number(17,2) -- 久悬金额
    ,finreg_amount number(17,2) -- 理财登记薄账户金额
    ,last_change_user_id varchar2(8) -- 最后修改柜员
    ,od_amount number(17,2) -- 透支金额
    ,odd_amount number(17,2) -- 透支总金额
    ,pld_amount number(17,2) -- 冻结金额
    ,total_amount number(17,2) -- 汇总金额
    ,total_amount_prev number(17,2) -- 上日总金额
    ,total_amount_last_prev number(17,2) -- 上上日汇总余额
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
grant select on ${iol_schema}.ncbs_rb_acct_balance to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_balance to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_balance to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_balance to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_balance is '账户余额表';
comment on column ${iol_schema}.ncbs_rb_acct_balance.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct_balance.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_acct_balance.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_balance.dac_value is 'dac值防篡改加密';
comment on column ${iol_schema}.ncbs_rb_acct_balance.last_bal_upd_date is '上次动户日期';
comment on column ${iol_schema}.ncbs_rb_acct_balance.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_acct_balance.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_balance.dos_amount is '久悬金额';
comment on column ${iol_schema}.ncbs_rb_acct_balance.finreg_amount is '理财登记薄账户金额';
comment on column ${iol_schema}.ncbs_rb_acct_balance.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_rb_acct_balance.od_amount is '透支金额';
comment on column ${iol_schema}.ncbs_rb_acct_balance.odd_amount is '透支总金额';
comment on column ${iol_schema}.ncbs_rb_acct_balance.pld_amount is '冻结金额';
comment on column ${iol_schema}.ncbs_rb_acct_balance.total_amount is '汇总金额';
comment on column ${iol_schema}.ncbs_rb_acct_balance.total_amount_prev is '上日总金额';
comment on column ${iol_schema}.ncbs_rb_acct_balance.total_amount_last_prev is '上上日汇总余额';
comment on column ${iol_schema}.ncbs_rb_acct_balance.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_acct_balance.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_acct_balance.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_acct_balance.etl_timestamp is 'ETL处理时间戳';
