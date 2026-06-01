/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_settle_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_settle_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_settle_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_settle_hist(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,user_id varchar2(8) -- 交易柜员编号
    ,acct_settle_operate_type varchar2(2) -- 结算账户绑定操作类型
    ,company varchar2(20) -- 法人
    ,seq_no varchar2(50) -- 序号
    ,settle_acct_class varchar2(3) -- 结算账户分类
    ,settle_bank_flag varchar2(1) -- 资金转移账户银行标识
    ,settle_mobile_phone varchar2(20) -- 绑定账户手机号码
    ,settle_no varchar2(50) -- 结算编号
    ,last_charge_date date -- 上一收费日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,last_change_user_id varchar2(8) -- 最后修改柜员
    ,old_settle_base_acct_no varchar2(50) -- 原利息入账账号
    ,settle_acct_ccy varchar2(3) -- 结算账户币种
    ,settle_acct_internal_key number(15) -- 结算账户标志符
    ,settle_acct_name varchar2(200) -- 结算账户户名
    ,settle_acct_seq_no varchar2(5) -- 结算账户序号
    ,settle_base_acct_no varchar2(50) -- 结算账号
    ,settle_branch varchar2(12) -- 清算机构
    ,settle_client varchar2(16) -- 结算客户号
    ,settle_prod_type varchar2(12) -- 结算账户产品类型
    ,bind_acct_branch varchar2(20) -- 开户银行金融机构编码
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
grant select on ${iol_schema}.ncbs_rb_acct_settle_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_settle_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_settle_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_settle_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_settle_hist is 'ii,iii类账户绑定信息流水表';
comment on column ${iol_schema}.ncbs_rb_acct_settle_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct_settle_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_acct_settle_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_acct_settle_hist.acct_settle_operate_type is '结算账户绑定操作类型';
comment on column ${iol_schema}.ncbs_rb_acct_settle_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_settle_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_acct_settle_hist.settle_acct_class is '结算账户分类';
comment on column ${iol_schema}.ncbs_rb_acct_settle_hist.settle_bank_flag is '资金转移账户银行标识';
comment on column ${iol_schema}.ncbs_rb_acct_settle_hist.settle_mobile_phone is '绑定账户手机号码';
comment on column ${iol_schema}.ncbs_rb_acct_settle_hist.settle_no is '结算编号';
comment on column ${iol_schema}.ncbs_rb_acct_settle_hist.last_charge_date is '上一收费日期';
comment on column ${iol_schema}.ncbs_rb_acct_settle_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_settle_hist.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_rb_acct_settle_hist.old_settle_base_acct_no is '原利息入账账号';
comment on column ${iol_schema}.ncbs_rb_acct_settle_hist.settle_acct_ccy is '结算账户币种';
comment on column ${iol_schema}.ncbs_rb_acct_settle_hist.settle_acct_internal_key is '结算账户标志符';
comment on column ${iol_schema}.ncbs_rb_acct_settle_hist.settle_acct_name is '结算账户户名';
comment on column ${iol_schema}.ncbs_rb_acct_settle_hist.settle_acct_seq_no is '结算账户序号';
comment on column ${iol_schema}.ncbs_rb_acct_settle_hist.settle_base_acct_no is '结算账号';
comment on column ${iol_schema}.ncbs_rb_acct_settle_hist.settle_branch is '清算机构';
comment on column ${iol_schema}.ncbs_rb_acct_settle_hist.settle_client is '结算客户号';
comment on column ${iol_schema}.ncbs_rb_acct_settle_hist.settle_prod_type is '结算账户产品类型';
comment on column ${iol_schema}.ncbs_rb_acct_settle_hist.bind_acct_branch is '开户银行金融机构编码';
comment on column ${iol_schema}.ncbs_rb_acct_settle_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_acct_settle_hist.etl_timestamp is 'ETL处理时间戳';
