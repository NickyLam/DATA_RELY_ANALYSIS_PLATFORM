/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_int_reback_book
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_int_reback_book
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_int_reback_book purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_int_reback_book(
    amt_type varchar2(10) -- 金额类型
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,dd_no number(5) -- 发放号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,remark varchar2(600) -- 备注
    ,user_id varchar2(8) -- 交易柜员编号
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,channel_sub_seq_no varchar2(50) -- 渠道子流水号
    ,company varchar2(20) -- 法人
    ,orig_seq_no varchar2(50) -- 原交易序号
    ,receipt_no varchar2(50) -- 回收号
    ,seq_no varchar2(50) -- 序号
    ,status varchar2(1) -- 状态
    ,tran_desc varchar2(200) -- 交易描述
    ,last_change_date date -- 最后修改日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,auth_user_id varchar2(8) -- 授权柜员
    ,last_change_auth_user_id varchar2(8) -- 最后操作授权柜员
    ,last_change_user_id varchar2(8) -- 最后修改柜员
    ,loan_no varchar2(50) -- 贷款号
    ,settle_acct_ccy varchar2(3) -- 结算账户币种
    ,settle_acct_name varchar2(200) -- 结算账户户名
    ,settle_acct_prod_type varchar2(12) -- 利息返还结算账户产品类型
    ,settle_acct_seq_no varchar2(5) -- 结算账户序号
    ,settle_base_acct_no varchar2(50) -- 结算账号
    ,tran_amt number(17,2) -- 交易金额
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
grant select on ${iol_schema}.ncbs_cl_int_reback_book to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_int_reback_book to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_int_reback_book to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_int_reback_book to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_int_reback_book is '返还企业客户利息登记簿';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.ccy is '币种';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.dd_no is '发放号';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.remark is '备注';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.channel_sub_seq_no is '渠道子流水号';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.company is '法人';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.orig_seq_no is '原交易序号';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.receipt_no is '回收号';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.seq_no is '序号';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.status is '状态';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.tran_desc is '交易描述';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.last_change_auth_user_id is '最后操作授权柜员';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.settle_acct_ccy is '结算账户币种';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.settle_acct_name is '结算账户户名';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.settle_acct_prod_type is '利息返还结算账户产品类型';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.settle_acct_seq_no is '结算账户序号';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.settle_base_acct_no is '结算账号';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_cl_int_reback_book.etl_timestamp is 'ETL处理时间戳';
