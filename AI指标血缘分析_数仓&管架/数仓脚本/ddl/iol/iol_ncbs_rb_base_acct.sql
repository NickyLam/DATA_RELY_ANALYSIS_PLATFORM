/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_base_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_base_acct
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_base_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_base_acct(
    acct_name varchar2(200) -- 账户名称
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,acct_status varchar2(1) -- 账户状态
    ,acct_type varchar2(1) -- 账户类型
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,card_no varchar2(50) -- 卡号
    ,client_no varchar2(16) -- 客户编号
    ,client_type varchar2(3) -- 客户类型
    ,doc_type varchar2(10) -- 凭证类型
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,voucher_status varchar2(3) -- 凭证状态
    ,acct_desc varchar2(200) -- 账户描述
    ,acct_exec varchar2(24) -- 银行客户经理编号
    ,acct_res_status varchar2(1) -- 账户限制标志
    ,acct_status_prev varchar2(1) -- 账户上一状态
    ,all_dep_ind varchar2(1) -- 通存标志
    ,all_dra_ind varchar2(1) -- 通兑标志
    ,checked_flag varchar2(1) -- 黑名单是否已检查标志位
    ,company varchar2(20) -- 法人
    ,prefix varchar2(10) -- 前缀
    ,source_module varchar2(3) -- 源模块
    ,source_type varchar2(6) -- 渠道编号
    ,terminal_id varchar2(50) -- 交易终端编号
    ,fixed_call varchar2(1) -- 定期账户细类
    ,acct_open_date date -- 账户开户日期
    ,acct_status_upd_date date -- 账户状态变更日期
    ,last_change_date date -- 最后修改日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,iss_country varchar2(3) -- 发证国家
    ,acct_branch varchar2(12) -- 开户机构编号
    ,acct_ccy varchar2(3) -- 账户币种
    ,acct_close_reason varchar2(300) -- 关闭原因
    ,acct_close_user_id varchar2(8) -- 账户销户操作柜员
    ,alt_acct_name varchar2(200) -- 备用账户名称
    ,last_change_user_id varchar2(8) -- 最后修改柜员
    ,old_prod_type varchar2(12) -- 原产品类型
    ,voucher_start_no varchar2(50) -- 凭证起始号码
    ,acct_close_date date -- 销户日期
    ,reason_code varchar2(10) -- 
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
grant select on ${iol_schema}.ncbs_rb_base_acct to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_base_acct to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_base_acct to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_base_acct to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_base_acct is '主账户基本信息表';
comment on column ${iol_schema}.ncbs_rb_base_acct.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_base_acct.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_base_acct.acct_status is '账户状态';
comment on column ${iol_schema}.ncbs_rb_base_acct.acct_type is '账户类型';
comment on column ${iol_schema}.ncbs_rb_base_acct.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_base_acct.card_no is '卡号';
comment on column ${iol_schema}.ncbs_rb_base_acct.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_base_acct.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_rb_base_acct.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_base_acct.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_rb_base_acct.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_rb_base_acct.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_base_acct.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_base_acct.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_base_acct.voucher_status is '凭证状态';
comment on column ${iol_schema}.ncbs_rb_base_acct.acct_desc is '账户描述';
comment on column ${iol_schema}.ncbs_rb_base_acct.acct_exec is '银行客户经理编号';
comment on column ${iol_schema}.ncbs_rb_base_acct.acct_res_status is '账户限制标志';
comment on column ${iol_schema}.ncbs_rb_base_acct.acct_status_prev is '账户上一状态';
comment on column ${iol_schema}.ncbs_rb_base_acct.all_dep_ind is '通存标志';
comment on column ${iol_schema}.ncbs_rb_base_acct.all_dra_ind is '通兑标志';
comment on column ${iol_schema}.ncbs_rb_base_acct.checked_flag is '黑名单是否已检查标志位';
comment on column ${iol_schema}.ncbs_rb_base_acct.company is '法人';
comment on column ${iol_schema}.ncbs_rb_base_acct.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_base_acct.source_module is '源模块';
comment on column ${iol_schema}.ncbs_rb_base_acct.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_base_acct.terminal_id is '交易终端编号';
comment on column ${iol_schema}.ncbs_rb_base_acct.fixed_call is '定期账户细类';
comment on column ${iol_schema}.ncbs_rb_base_acct.acct_open_date is '账户开户日期';
comment on column ${iol_schema}.ncbs_rb_base_acct.acct_status_upd_date is '账户状态变更日期';
comment on column ${iol_schema}.ncbs_rb_base_acct.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_base_acct.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_base_acct.iss_country is '发证国家';
comment on column ${iol_schema}.ncbs_rb_base_acct.acct_branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_rb_base_acct.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_base_acct.acct_close_reason is '关闭原因';
comment on column ${iol_schema}.ncbs_rb_base_acct.acct_close_user_id is '账户销户操作柜员';
comment on column ${iol_schema}.ncbs_rb_base_acct.alt_acct_name is '备用账户名称';
comment on column ${iol_schema}.ncbs_rb_base_acct.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_rb_base_acct.old_prod_type is '原产品类型';
comment on column ${iol_schema}.ncbs_rb_base_acct.voucher_start_no is '凭证起始号码';
comment on column ${iol_schema}.ncbs_rb_base_acct.acct_close_date is '销户日期';
comment on column ${iol_schema}.ncbs_rb_base_acct.reason_code is '';
comment on column ${iol_schema}.ncbs_rb_base_acct.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_base_acct.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_base_acct.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_base_acct.etl_timestamp is 'ETL处理时间戳';
