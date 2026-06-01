/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_impound_hang_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_impound_hang_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_impound_hang_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_impound_hang_info(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,hang_status varchar2(1) -- 挂账状态
    ,individual_flag varchar2(1) -- 对公对私标志
    ,law_no varchar2(150) -- 法律文书号
    ,narrative varchar2(400) -- 摘要
    ,operate_channel varchar2(10) -- 操作渠道
    ,transfer_option varchar2(1) -- 强制扣划操作类型
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,auth_user_id varchar2(8) -- 授权柜员
    ,impound_amt number(17,2) -- 扣划金额
    ,judiciary_document_id varchar2(180) -- 执法人1证件号码
    ,judiciary_document_id2 varchar2(180) -- 执法人1证件号码2
    ,judiciary_document_type varchar2(4) -- 执法人1证件类型
    ,judiciary_document_type2 varchar2(4) -- 执法人1证件类型2
    ,judiciary_officer_name varchar2(200) -- 执法人1姓名
    ,judiciary_oth_document_id varchar2(60) -- 执法人2证件号码
    ,judiciary_oth_document_id2 varchar2(60) -- 执法人2证件号码2
    ,judiciary_oth_document_type varchar2(4) -- 执法人2证件类型
    ,judiciary_oth_document_type2 varchar2(4) -- 执法人2证件类型2
    ,judiciary_oth_officer_name varchar2(200) -- 执法人2姓名
    ,oth_acct_name varchar2(200) -- 对方账户名称
    ,oth_acct_seq_no varchar2(5) -- 对方账户序列号
    ,oth_base_acct_no varchar2(50) -- 对方账号/卡号
    ,oth_branch varchar2(20) -- 对方账户开户机构
    ,oth_branch_name varchar2(200) -- 收款行行名
    ,oth_ccy varchar2(3) -- 对手账户币种
    ,oth_prod_type varchar2(12) -- 对方账户产品类型
    ,payee_addr varchar2(400) -- 收款人地址
    ,payer_base_acct_no varchar2(50) -- 付款人账号
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
grant select on ${iol_schema}.ncbs_rb_impound_hang_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_impound_hang_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_impound_hang_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_impound_hang_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_impound_hang_info is '扣划记录表';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.company is '法人';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.hang_status is '挂账状态';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.individual_flag is '对公对私标志';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.law_no is '法律文书号';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.operate_channel is '操作渠道';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.transfer_option is '强制扣划操作类型';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.impound_amt is '扣划金额';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.judiciary_document_id is '执法人1证件号码';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.judiciary_document_id2 is '执法人1证件号码2';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.judiciary_document_type is '执法人1证件类型';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.judiciary_document_type2 is '执法人1证件类型2';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.judiciary_officer_name is '执法人1姓名';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.judiciary_oth_document_id is '执法人2证件号码';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.judiciary_oth_document_id2 is '执法人2证件号码2';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.judiciary_oth_document_type is '执法人2证件类型';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.judiciary_oth_document_type2 is '执法人2证件类型2';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.judiciary_oth_officer_name is '执法人2姓名';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.oth_acct_name is '对方账户名称';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.oth_acct_seq_no is '对方账户序列号';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.oth_base_acct_no is '对方账号/卡号';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.oth_branch is '对方账户开户机构';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.oth_branch_name is '收款行行名';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.oth_ccy is '对手账户币种';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.oth_prod_type is '对方账户产品类型';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.payee_addr is '收款人地址';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.payer_base_acct_no is '付款人账号';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_impound_hang_info.etl_timestamp is 'ETL处理时间戳';
