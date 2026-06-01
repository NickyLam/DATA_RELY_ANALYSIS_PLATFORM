/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_impound_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_impound_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_impound_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_impound_info(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,deposit_type varchar2(1) -- 存款类型
    ,impoind_int_flag varchar2(1) -- 标志
    ,impound_type varchar2(1) -- 扣划类型
    ,individual_flag varchar2(1) -- 对公对私标志
    ,int_ind_flag varchar2(1) -- 是否计息
    ,law_no varchar2(150) -- 法律文书号
    ,movt_status varchar2(1) -- 转存类型
    ,narrative varchar2(400) -- 摘要
    ,operate_channel varchar2(10) -- 操作渠道
    ,res_seq_no varchar2(50) -- 限制编号
    ,sched_no varchar2(50) -- 计划编号
    ,transfer_flag varchar2(1) -- 转账标志
    ,transfer_option varchar2(1) -- 强制扣划操作类型
    ,transfer_times number(5) -- 已扣划次数
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,accrued_int number(17,2) -- 扣划后金额重新计提的利息
    ,accrued_int_adj number(17,2) -- 扣划后金额重新计提的调整利息
    ,auth_user_id varchar2(8) -- 授权柜员
    ,beneficiary_branch varchar2(12) -- 对方行行号
    ,beneficiary_branch_name varchar2(200) -- 对方行行名
    ,benefit_base_acct_no varchar2(50) -- 受益人账户账号
    ,benefit_prod_type varchar2(12) -- 受益人账户产品类型
    ,benenfit_acct_name varchar2(200) -- 受益人账户户名
    ,benenfit_ccy varchar2(3) -- 受益人币种
    ,benenfit_seq_no varchar2(5) -- 受益人账户序号
    ,deduction_judiciary_name varchar2(200) -- 有权机关名称
    ,impound_amt number(17,2) -- 扣划金额
    ,impound_int number(17,2) -- 扣划利息
    ,impound_tax number(17,2) -- 扣划产生利息税
    ,impound_total_amt number(17,2) -- 扣划总金额
    ,int_acct_ccy varchar2(3) -- 利息转入账户币种
    ,int_acct_name varchar2(200) -- 利息入账账户户名
    ,int_acct_seq_no varchar2(5) -- 利息转入账户序列号
    ,int_amt number(17,2) -- 利息金额
    ,int_base_acct_no varchar2(50) -- 利息转入账号
    ,int_internal_key number(15) -- 利息入账账户标识符
    ,int_prod_type varchar2(12) -- 利息转入账户产品类型
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
    ,original_int number(17,2) -- 原计提利息
    ,original_int_adj number(17,2) -- 原计提调整利息
    ,oth_reference varchar2(50) -- 对方交易参考号
    ,other_client_address varchar2(400) -- 对方行收款人地址
    ,out_oth_acct_name varchar2(200) -- 对方行收款人户名
    ,out_oth_base_acct_no varchar2(50) -- 对方行收款人账户
    ,pledged_int_amt number(17,2) -- 冻结期间产生的利息
    ,pledged_tax_amt number(17,2) -- 冻结期间利息税
    ,total_amt number(17,2) -- 总金额
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
grant select on ${iol_schema}.ncbs_rb_impound_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_impound_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_impound_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_impound_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_impound_info is '扣划记录表';
comment on column ${iol_schema}.ncbs_rb_impound_info.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_impound_info.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_impound_info.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_impound_info.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_impound_info.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_impound_info.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_impound_info.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_impound_info.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_impound_info.company is '法人';
comment on column ${iol_schema}.ncbs_rb_impound_info.deposit_type is '存款类型';
comment on column ${iol_schema}.ncbs_rb_impound_info.impoind_int_flag is '标志';
comment on column ${iol_schema}.ncbs_rb_impound_info.impound_type is '扣划类型';
comment on column ${iol_schema}.ncbs_rb_impound_info.individual_flag is '对公对私标志';
comment on column ${iol_schema}.ncbs_rb_impound_info.int_ind_flag is '是否计息';
comment on column ${iol_schema}.ncbs_rb_impound_info.law_no is '法律文书号';
comment on column ${iol_schema}.ncbs_rb_impound_info.movt_status is '转存类型';
comment on column ${iol_schema}.ncbs_rb_impound_info.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_impound_info.operate_channel is '操作渠道';
comment on column ${iol_schema}.ncbs_rb_impound_info.res_seq_no is '限制编号';
comment on column ${iol_schema}.ncbs_rb_impound_info.sched_no is '计划编号';
comment on column ${iol_schema}.ncbs_rb_impound_info.transfer_flag is '转账标志';
comment on column ${iol_schema}.ncbs_rb_impound_info.transfer_option is '强制扣划操作类型';
comment on column ${iol_schema}.ncbs_rb_impound_info.transfer_times is '已扣划次数';
comment on column ${iol_schema}.ncbs_rb_impound_info.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_impound_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_impound_info.accrued_int is '扣划后金额重新计提的利息';
comment on column ${iol_schema}.ncbs_rb_impound_info.accrued_int_adj is '扣划后金额重新计提的调整利息';
comment on column ${iol_schema}.ncbs_rb_impound_info.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_impound_info.beneficiary_branch is '对方行行号';
comment on column ${iol_schema}.ncbs_rb_impound_info.beneficiary_branch_name is '对方行行名';
comment on column ${iol_schema}.ncbs_rb_impound_info.benefit_base_acct_no is '受益人账户账号';
comment on column ${iol_schema}.ncbs_rb_impound_info.benefit_prod_type is '受益人账户产品类型';
comment on column ${iol_schema}.ncbs_rb_impound_info.benenfit_acct_name is '受益人账户户名';
comment on column ${iol_schema}.ncbs_rb_impound_info.benenfit_ccy is '受益人币种';
comment on column ${iol_schema}.ncbs_rb_impound_info.benenfit_seq_no is '受益人账户序号';
comment on column ${iol_schema}.ncbs_rb_impound_info.deduction_judiciary_name is '有权机关名称';
comment on column ${iol_schema}.ncbs_rb_impound_info.impound_amt is '扣划金额';
comment on column ${iol_schema}.ncbs_rb_impound_info.impound_int is '扣划利息';
comment on column ${iol_schema}.ncbs_rb_impound_info.impound_tax is '扣划产生利息税';
comment on column ${iol_schema}.ncbs_rb_impound_info.impound_total_amt is '扣划总金额';
comment on column ${iol_schema}.ncbs_rb_impound_info.int_acct_ccy is '利息转入账户币种';
comment on column ${iol_schema}.ncbs_rb_impound_info.int_acct_name is '利息入账账户户名';
comment on column ${iol_schema}.ncbs_rb_impound_info.int_acct_seq_no is '利息转入账户序列号';
comment on column ${iol_schema}.ncbs_rb_impound_info.int_amt is '利息金额';
comment on column ${iol_schema}.ncbs_rb_impound_info.int_base_acct_no is '利息转入账号';
comment on column ${iol_schema}.ncbs_rb_impound_info.int_internal_key is '利息入账账户标识符';
comment on column ${iol_schema}.ncbs_rb_impound_info.int_prod_type is '利息转入账户产品类型';
comment on column ${iol_schema}.ncbs_rb_impound_info.judiciary_document_id is '执法人1证件号码';
comment on column ${iol_schema}.ncbs_rb_impound_info.judiciary_document_id2 is '执法人1证件号码2';
comment on column ${iol_schema}.ncbs_rb_impound_info.judiciary_document_type is '执法人1证件类型';
comment on column ${iol_schema}.ncbs_rb_impound_info.judiciary_document_type2 is '执法人1证件类型2';
comment on column ${iol_schema}.ncbs_rb_impound_info.judiciary_officer_name is '执法人1姓名';
comment on column ${iol_schema}.ncbs_rb_impound_info.judiciary_oth_document_id is '执法人2证件号码';
comment on column ${iol_schema}.ncbs_rb_impound_info.judiciary_oth_document_id2 is '执法人2证件号码2';
comment on column ${iol_schema}.ncbs_rb_impound_info.judiciary_oth_document_type is '执法人2证件类型';
comment on column ${iol_schema}.ncbs_rb_impound_info.judiciary_oth_document_type2 is '执法人2证件类型2';
comment on column ${iol_schema}.ncbs_rb_impound_info.judiciary_oth_officer_name is '执法人2姓名';
comment on column ${iol_schema}.ncbs_rb_impound_info.original_int is '原计提利息';
comment on column ${iol_schema}.ncbs_rb_impound_info.original_int_adj is '原计提调整利息';
comment on column ${iol_schema}.ncbs_rb_impound_info.oth_reference is '对方交易参考号';
comment on column ${iol_schema}.ncbs_rb_impound_info.other_client_address is '对方行收款人地址';
comment on column ${iol_schema}.ncbs_rb_impound_info.out_oth_acct_name is '对方行收款人户名';
comment on column ${iol_schema}.ncbs_rb_impound_info.out_oth_base_acct_no is '对方行收款人账户';
comment on column ${iol_schema}.ncbs_rb_impound_info.pledged_int_amt is '冻结期间产生的利息';
comment on column ${iol_schema}.ncbs_rb_impound_info.pledged_tax_amt is '冻结期间利息税';
comment on column ${iol_schema}.ncbs_rb_impound_info.total_amt is '总金额';
comment on column ${iol_schema}.ncbs_rb_impound_info.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_impound_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_impound_info.etl_timestamp is 'ETL处理时间戳';
