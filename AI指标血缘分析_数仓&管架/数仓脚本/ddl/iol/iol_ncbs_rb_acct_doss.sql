/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_doss
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_doss
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_doss purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_doss(
    acct_name varchar2(200) -- 账户名称
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,acct_status varchar2(1) -- 账户状态
    ,amt_type varchar2(10) -- 金额类型
    ,balance number(17,2) -- 余额
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,remark varchar2(600) -- 备注
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,doss_operate_type varchar2(2) -- 转久悬操作类型
    ,dormant_date date -- 转不动户日期
    ,doss_date date -- 转久悬日期
    ,out_date date -- 出库日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,int_amt number(17,2) -- 利息金额
    ,por_int_tot number(17,2) -- 本息合计
    ,tax_sc number(17,2) -- 账户利息税
    ,tran_branch varchar2(12) -- 核心交易机构编号
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
grant select on ${iol_schema}.ncbs_rb_acct_doss to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_doss to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_doss to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_doss to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_doss is '久悬户登记簿';
comment on column ${iol_schema}.ncbs_rb_acct_doss.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_acct_doss.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_acct_doss.acct_status is '账户状态';
comment on column ${iol_schema}.ncbs_rb_acct_doss.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_rb_acct_doss.balance is '余额';
comment on column ${iol_schema}.ncbs_rb_acct_doss.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_acct_doss.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct_doss.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_acct_doss.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_acct_doss.remark is '备注';
comment on column ${iol_schema}.ncbs_rb_acct_doss.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_acct_doss.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_doss.doss_operate_type is '转久悬操作类型';
comment on column ${iol_schema}.ncbs_rb_acct_doss.dormant_date is '转不动户日期';
comment on column ${iol_schema}.ncbs_rb_acct_doss.doss_date is '转久悬日期';
comment on column ${iol_schema}.ncbs_rb_acct_doss.out_date is '出库日期';
comment on column ${iol_schema}.ncbs_rb_acct_doss.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_acct_doss.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_doss.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_acct_doss.int_amt is '利息金额';
comment on column ${iol_schema}.ncbs_rb_acct_doss.por_int_tot is '本息合计';
comment on column ${iol_schema}.ncbs_rb_acct_doss.tax_sc is '账户利息税';
comment on column ${iol_schema}.ncbs_rb_acct_doss.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_acct_doss.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_acct_doss.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_acct_doss.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_acct_doss.etl_timestamp is 'ETL处理时间戳';
