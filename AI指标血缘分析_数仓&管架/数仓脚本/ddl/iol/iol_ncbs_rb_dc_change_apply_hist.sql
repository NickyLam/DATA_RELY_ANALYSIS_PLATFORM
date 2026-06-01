/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_dc_change_apply_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_dc_change_apply_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_dc_change_apply_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_dc_change_apply_hist(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_name varchar2(200) -- 客户名称
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,res_seq_no varchar2(50) -- 限制编号
    ,stage_code varchar2(50) -- 期次代码
    ,last_change_date date -- 最后修改日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,dep_keep_days number(5) -- 存款天数
    ,int_rem_days number(5) -- 计息剩余天数
    ,trf_total_settle_amt number(17,2) -- 转让总对价
    ,trf_end_date date -- 转让到期日
    ,direction_trf_flag varchar2(1) -- 是否定期转让
    ,order_start_date date -- 挂单起始日期
    ,trf_in_fee_amt number(17,2) -- 转入费用
    ,order_end_date date -- 挂单结束日期
    ,trf_pri_amt number(17,2) -- 转让本金金额
    ,trf_command varchar2(50) -- 转让口令
    ,trf_rate number(15,8) -- 转让利率
    ,trf_type varchar2(2) -- 转让类型
    ,trf_status varchar2(1) -- 转让状态
    ,beneficiary_client_no varchar2(16) -- 受益人客户号
    ,trf_no varchar2(50) -- 转让号
    ,trf_date date -- 转让日期
    ,beneficiary_profit_rate number(15,8) -- 受让人收益率
    ,trf_out_fee_amt number(17,2) -- 转出费用
    ,prod_type varchar2(12) -- 产品编号|产品编号
    ,settle_acct_seq_no varchar2(5) -- 结算账户序号|结算账户序号
    ,settle_base_acct_no varchar2(50) -- 结算账号|结算账号
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
grant select on ${iol_schema}.ncbs_rb_dc_change_apply_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_dc_change_apply_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_change_apply_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_change_apply_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_dc_change_apply_hist is '大额存单转让申请历史表';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.res_seq_no is '限制编号';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.stage_code is '期次代码';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.dep_keep_days is '存款天数';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.int_rem_days is '计息剩余天数';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.trf_total_settle_amt is '转让总对价';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.trf_end_date is '转让到期日';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.direction_trf_flag is '是否定期转让';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.order_start_date is '挂单起始日期';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.trf_in_fee_amt is '转入费用';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.order_end_date is '挂单结束日期';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.trf_pri_amt is '转让本金金额';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.trf_command is '转让口令';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.trf_rate is '转让利率';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.trf_type is '转让类型';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.trf_status is '转让状态';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.beneficiary_client_no is '受益人客户号';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.trf_no is '转让号';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.trf_date is '转让日期';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.beneficiary_profit_rate is '受让人收益率';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.trf_out_fee_amt is '转出费用';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.prod_type is '产品编号|产品编号';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.settle_acct_seq_no is '结算账户序号|结算账户序号';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.settle_base_acct_no is '结算账号|结算账号';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_dc_change_apply_hist.etl_timestamp is 'ETL处理时间戳';
