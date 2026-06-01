/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_acct_balance
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_acct_balance
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_acct_balance purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_acct_balance(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,company varchar2(20) -- 法人
    ,dac_value varchar2(200) -- dac值防篡改加密
    ,last_bal_upd_date date -- 上次动户日期
    ,last_change_date date -- 最后修改日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,dd_amt number(17,2) -- 发放金额
    ,dda_amt_prev number(17,2) -- 上日发放金额
    ,gintp_amt number(17,2) -- 宽限期利息
    ,gintp_amt_prev number(17,2) -- 上日宽限期利息
    ,godip_amt number(17,2) -- 宽限期复利
    ,godip_amt_prev number(17,2) -- 上日宽限期复利
    ,godpp_amt number(17,2) -- 宽限期罚息
    ,godpp_amt_prev number(17,2) -- 上日宽限期罚息
    ,gprd_amt number(17,2) -- 宽限期本金
    ,gprd_amt_prev number(17,2) -- 上日宽限期本金
    ,intp_amt number(17,2) -- 逾期利息
    ,intp_amt_prev number(17,2) -- 账户上日逾期利息
    ,last_change_user_id varchar2(8) -- 最后修改柜员
    ,odip_amt number(17,2) -- 复利余额
    ,odip_amt_prev number(17,2) -- 上日逾期复利
    ,odpp_amt number(17,2) -- 逾期罚息余额
    ,odpp_amt_prev number(17,2) -- 上日逾期罚息
    ,osl_amt number(17,2) -- 客户未到期本金
    ,osl_amt_prev number(17,2) -- 上日未到期本金
    ,prd_amt number(17,2) -- 逾期本金
    ,prd_amt_prev number(17,2) -- 上日逾期本金
    ,dd_amt_last_prev number(17,2) -- 上上日发放金额
    ,osl_amt_last_prev number(17,2) -- 上上日未到期本金
    ,prd_amt_last_prev number(17,2) -- 上上日逾期本金
    ,intp_amt_last_prev number(17,2) -- 上上日逾期利息
    ,odpp_amt_last_prev number(17,2) -- 上上日逾期罚息
    ,odip_amt_last_prev number(17,2) -- 上上日逾期复利
    ,gprd_amt_last_prev number(17,2) -- 上上日宽限期本金
    ,gintp_amt_last_prev number(17,2) -- 上上日宽限期利息
    ,godpp_amt_last_prev number(17,2) -- 上上日宽限期罚息
    ,godip_amt_last_prev number(17,2) -- 上上日宽限期复利
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
grant select on ${iol_schema}.ncbs_cl_acct_balance to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_acct_balance to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_acct_balance to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_acct_balance to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_acct_balance is '账户余额表';
comment on column ${iol_schema}.ncbs_cl_acct_balance.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_acct_balance.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_acct_balance.company is '法人';
comment on column ${iol_schema}.ncbs_cl_acct_balance.dac_value is 'dac值防篡改加密';
comment on column ${iol_schema}.ncbs_cl_acct_balance.last_bal_upd_date is '上次动户日期';
comment on column ${iol_schema}.ncbs_cl_acct_balance.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cl_acct_balance.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_acct_balance.dd_amt is '发放金额';
comment on column ${iol_schema}.ncbs_cl_acct_balance.dda_amt_prev is '上日发放金额';
comment on column ${iol_schema}.ncbs_cl_acct_balance.gintp_amt is '宽限期利息';
comment on column ${iol_schema}.ncbs_cl_acct_balance.gintp_amt_prev is '上日宽限期利息';
comment on column ${iol_schema}.ncbs_cl_acct_balance.godip_amt is '宽限期复利';
comment on column ${iol_schema}.ncbs_cl_acct_balance.godip_amt_prev is '上日宽限期复利';
comment on column ${iol_schema}.ncbs_cl_acct_balance.godpp_amt is '宽限期罚息';
comment on column ${iol_schema}.ncbs_cl_acct_balance.godpp_amt_prev is '上日宽限期罚息';
comment on column ${iol_schema}.ncbs_cl_acct_balance.gprd_amt is '宽限期本金';
comment on column ${iol_schema}.ncbs_cl_acct_balance.gprd_amt_prev is '上日宽限期本金';
comment on column ${iol_schema}.ncbs_cl_acct_balance.intp_amt is '逾期利息';
comment on column ${iol_schema}.ncbs_cl_acct_balance.intp_amt_prev is '账户上日逾期利息';
comment on column ${iol_schema}.ncbs_cl_acct_balance.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_cl_acct_balance.odip_amt is '复利余额';
comment on column ${iol_schema}.ncbs_cl_acct_balance.odip_amt_prev is '上日逾期复利';
comment on column ${iol_schema}.ncbs_cl_acct_balance.odpp_amt is '逾期罚息余额';
comment on column ${iol_schema}.ncbs_cl_acct_balance.odpp_amt_prev is '上日逾期罚息';
comment on column ${iol_schema}.ncbs_cl_acct_balance.osl_amt is '客户未到期本金';
comment on column ${iol_schema}.ncbs_cl_acct_balance.osl_amt_prev is '上日未到期本金';
comment on column ${iol_schema}.ncbs_cl_acct_balance.prd_amt is '逾期本金';
comment on column ${iol_schema}.ncbs_cl_acct_balance.prd_amt_prev is '上日逾期本金';
comment on column ${iol_schema}.ncbs_cl_acct_balance.dd_amt_last_prev is '上上日发放金额';
comment on column ${iol_schema}.ncbs_cl_acct_balance.osl_amt_last_prev is '上上日未到期本金';
comment on column ${iol_schema}.ncbs_cl_acct_balance.prd_amt_last_prev is '上上日逾期本金';
comment on column ${iol_schema}.ncbs_cl_acct_balance.intp_amt_last_prev is '上上日逾期利息';
comment on column ${iol_schema}.ncbs_cl_acct_balance.odpp_amt_last_prev is '上上日逾期罚息';
comment on column ${iol_schema}.ncbs_cl_acct_balance.odip_amt_last_prev is '上上日逾期复利';
comment on column ${iol_schema}.ncbs_cl_acct_balance.gprd_amt_last_prev is '上上日宽限期本金';
comment on column ${iol_schema}.ncbs_cl_acct_balance.gintp_amt_last_prev is '上上日宽限期利息';
comment on column ${iol_schema}.ncbs_cl_acct_balance.godpp_amt_last_prev is '上上日宽限期罚息';
comment on column ${iol_schema}.ncbs_cl_acct_balance.godip_amt_last_prev is '上上日宽限期复利';
comment on column ${iol_schema}.ncbs_cl_acct_balance.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_acct_balance.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_acct_balance.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_acct_balance.etl_timestamp is 'ETL处理时间戳';
