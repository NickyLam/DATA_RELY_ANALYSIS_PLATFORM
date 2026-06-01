/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_agreement_impound
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_agreement_impound
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_agreement_impound purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement_impound(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,period_freq varchar2(5) -- 频率id
    ,prod_type varchar2(12) -- 产品编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,agreement_id varchar2(50) -- 协议编号
    ,agreement_status varchar2(2) -- 协议状态
    ,agreement_type varchar2(5) -- 协议类型
    ,company varchar2(20) -- 法人
    ,impound_end_flag varchar2(1) -- 是否终止扣划
    ,impound_type varchar2(1) -- 扣划类型
    ,law_no varchar2(150) -- 法律文书号
    ,narrative varchar2(400) -- 摘要
    ,res_seq_no varchar2(50) -- 限制编号
    ,total_times number(5) -- 扣划总次数
    ,transfer_times number(5) -- 已扣划次数
    ,end_date date -- 结束日期
    ,next_deal_date date -- 下一处理日
    ,start_date date -- 开始日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,auth_user_id varchar2(8) -- 授权柜员
    ,benefit_base_acct_no varchar2(50) -- 受益人账户账号
    ,benefit_prod_type varchar2(12) -- 受益人账户产品类型
    ,benenfit_acct_name varchar2(200) -- 受益人账户户名
    ,benenfit_ccy varchar2(3) -- 受益人币种
    ,benenfit_seq_no varchar2(5) -- 受益人账户序号
    ,deduction_judiciary_name varchar2(200) -- 有权机关名称
    ,impound_total_amt number(17,2) -- 扣划总金额
    ,judiciary_document_id varchar2(180) -- 执法人1证件号码
    ,judiciary_document_type varchar2(4) -- 执法人1证件类型
    ,judiciary_officer_name varchar2(200) -- 执法人1姓名
    ,judiciary_oth_document_id varchar2(60) -- 执法人2证件号码
    ,judiciary_oth_document_type varchar2(4) -- 执法人2证件类型
    ,judiciary_oth_officer_name varchar2(200) -- 执法人2姓名
    ,total_amt number(17,2) -- 总金额
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
grant select on ${iol_schema}.ncbs_rb_agreement_impound to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_impound to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_impound to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_impound to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_agreement_impound is '周期性扣划协议表';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.period_freq is '频率id';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.agreement_status is '协议状态';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.agreement_type is '协议类型';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.company is '法人';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.impound_end_flag is '是否终止扣划';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.impound_type is '扣划类型';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.law_no is '法律文书号';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.res_seq_no is '限制编号';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.total_times is '扣划总次数';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.transfer_times is '已扣划次数';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.next_deal_date is '下一处理日';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.benefit_base_acct_no is '受益人账户账号';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.benefit_prod_type is '受益人账户产品类型';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.benenfit_acct_name is '受益人账户户名';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.benenfit_ccy is '受益人币种';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.benenfit_seq_no is '受益人账户序号';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.deduction_judiciary_name is '有权机关名称';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.impound_total_amt is '扣划总金额';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.judiciary_document_id is '执法人1证件号码';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.judiciary_document_type is '执法人1证件类型';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.judiciary_officer_name is '执法人1姓名';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.judiciary_oth_document_id is '执法人2证件号码';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.judiciary_oth_document_type is '执法人2证件类型';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.judiciary_oth_officer_name is '执法人2姓名';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.total_amt is '总金额';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_agreement_impound.etl_timestamp is 'ETL处理时间戳';
