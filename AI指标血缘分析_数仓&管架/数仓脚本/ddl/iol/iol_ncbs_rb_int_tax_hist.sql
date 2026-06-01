/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_int_tax_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_int_tax_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_int_tax_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_int_tax_hist(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,client_type varchar2(3) -- 客户类型
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,profit_center varchar2(20) -- 利润中心
    ,reference varchar2(50) -- 交易参考号
    ,tran_type varchar2(10) -- 交易类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,bank_seq_no varchar2(50) -- 银行交易序号
    ,bo_ind varchar2(1) -- 日终/联机标志
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,cr_dr_ind varchar2(1) -- 借贷标志
    ,event_type varchar2(20) -- 事件类型
    ,gl_posted_flag varchar2(1) -- 过账标记
    ,reversal_flag varchar2(1) -- 交易是否已冲正
    ,source_module varchar2(3) -- 源模块
    ,source_type varchar2(6) -- 渠道编号
    ,tax_seq_no varchar2(50) -- 利息税序号
    ,tax_type varchar2(2) -- 税种
    ,tran_seq_no varchar2(50) -- 交易序号
    ,reversal_date date -- 冲正日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,pay_interest number(17,2) -- 应付利息
    ,reversal_auth_user_id varchar2(8) -- 冲正授权柜员
    ,reversal_branch varchar2(12) -- 冲正机构
    ,reversal_user_id varchar2(8) -- 冲正柜员
    ,tax_amt number(17,2) -- 税金
    ,tax_ccy varchar2(3) -- 利息税币种
    ,tax_rate number(15,8) -- 税率
    ,tran_branch varchar2(12) -- 核心交易机构编号
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
grant select on ${iol_schema}.ncbs_rb_int_tax_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_int_tax_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_int_tax_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_int_tax_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_int_tax_hist is '利息税流水表';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.profit_center is '利润中心';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.bank_seq_no is '银行交易序号';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.bo_ind is '日终/联机标志';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.cr_dr_ind is '借贷标志';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.gl_posted_flag is '过账标记';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.reversal_flag is '交易是否已冲正';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.source_module is '源模块';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.tax_seq_no is '利息税序号';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.tax_type is '税种';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.tran_seq_no is '交易序号';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.reversal_date is '冲正日期';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.pay_interest is '应付利息';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.reversal_auth_user_id is '冲正授权柜员';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.reversal_branch is '冲正机构';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.reversal_user_id is '冲正柜员';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.tax_amt is '税金';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.tax_ccy is '利息税币种';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.tax_rate is '税率';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_int_tax_hist.etl_timestamp is 'ETL处理时间戳';
