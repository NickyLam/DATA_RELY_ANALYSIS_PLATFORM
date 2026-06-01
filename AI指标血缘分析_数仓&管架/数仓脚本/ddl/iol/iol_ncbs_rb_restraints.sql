/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_restraints
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_restraints
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_restraints purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_restraints(
    client_no varchar2(16) -- 客户编号
    ,doc_type varchar2(10) -- 凭证类型
    ,internal_key number(15) -- 账户内部键值
    ,reference varchar2(50) -- 交易参考号
    ,restraint_type varchar2(3) -- 限制类型
    ,tran_type varchar2(10) -- 交易类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,term varchar2(5) -- 存期
    ,term_type varchar2(1) -- 期限单位
    ,appr_flag varchar2(1) -- 复核标志
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,deduction_law_no varchar2(50) -- 扣划法律文书号
    ,full_freeze_ind varchar2(1) -- 全额冻结标志
    ,help_option varchar2(20) -- 协助执行事项
    ,interrupt_flag varchar2(1) -- 是否中断
    ,is_frozen varchar2(1) -- 是否续冻
    ,maintain_type varchar2(1) -- 维护方式
    ,msg_bank varchar2(50) -- 银行信息
    ,msg_client varchar2(200) -- 客户信息
    ,narrative varchar2(400) -- 摘要
    ,no_of_payment number(5) -- 总支付笔数
    ,oth_acct_desc varchar2(600) -- 对方账户描述
    ,payment_made number(5) -- 已支付笔数
    ,prefix varchar2(10) -- 前缀
    ,program_id varchar2(20) -- 交易代码
    ,release_law_no varchar2(150) -- 解冻机关法律文书号
    ,res_acct_range varchar2(1) -- 限制账户范围
    ,res_law_no varchar2(150) -- 冻结机关法律文书号
    ,res_priority varchar2(2) -- 冻结级别
    ,res_seq_no varchar2(50) -- 限制编号
    ,restraint_judiciary_name varchar2(200) -- 冻结机关名称
    ,restraints_status varchar2(1) -- 限制状态
    ,source_module varchar2(3) -- 源模块
    ,spec_code varchar2(10) -- 指定他行信息
    ,start_cheque_no varchar2(50) -- 起始支票号码
    ,stl_seq_no varchar2(50) -- 结算流水号
    ,sub_restraint_class varchar2(10) -- 子限制类别
    ,thaw_officer_name varchar2(50) -- 经办人1姓名
    ,thaw_oth_officer_name varchar2(50) -- 经办人2姓名
    ,under_lien varchar2(1) -- 是否抵制押标志
    ,wait_seq varchar2(50) -- 轮候冻结序号
    ,approval_date date -- 复核日期
    ,channel_date date -- 渠道日期
    ,end_date date -- 结束日期
    ,last_change_date date -- 最后修改日期
    ,start_date date -- 开始日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,appr_user_id varchar2(8) -- 复核柜员
    ,auth_user_id varchar2(8) -- 授权柜员
    ,deduction_judiciary_name varchar2(200) -- 有权机关名称
    ,end_amt number(17,2) -- 截止金额
    ,end_cheque_no varchar2(50) -- 终止支票号码
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
    ,last_change_user_id varchar2(8) -- 最后修改柜员
    ,oth_acct_ccy varchar2(3) -- 对方账户币种
    ,oth_acct_no varchar2(50) -- 对方账号
    ,oth_bank_code varchar2(20) -- 对方银行代码
    ,oth_base_acct_no varchar2(50) -- 对方账号/卡号
    ,oth_prod_type varchar2(12) -- 对方账户产品类型
    ,paid_amt number(17,2) -- 已还金额
    ,pledged_acct_ccy varchar2(3) -- 抵押账户币种
    ,pledged_acct_no varchar2(50) -- 抵押账号
    ,pledged_acct_type varchar2(1) -- 抵押账户类型
    ,pledged_amt number(17,2) -- 限制金额
    ,pledged_base_acct_no varchar2(50) -- 抵押主账号
    ,real_restraint_amt number(17,2) -- 可扣划金额
    ,release_judiciary_name varchar2(200) -- 解冻机关名称
    ,start_amt number(17,2) -- 起始金额
    ,thaw_document_id varchar2(60) -- 经办人1证件号码
    ,thaw_document_id2 varchar2(60) -- 经办人1证件号码2
    ,thaw_document_type varchar2(4) -- 经办人1证件类型1
    ,thaw_oth_document_id varchar2(60) -- 经办人2证件号码
    ,thaw_oth_document_id2 varchar2(60) -- 经办人2证件号码2
    ,thaw_oth_document_type varchar2(4) -- 经办人2证件类型
    ,thaw_oth_document_type2 varchar2(4) -- 经办人2证件类型2
    ,to_pay_amt number(17,2) -- 支付金额
    ,tran_amt number(17,2) -- 交易金额
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,thaw_document_type2 varchar2(4) -- 经办人1证件类型2
    ,reaccount_cd varchar2(20) -- 对账代码
    ,reserve varchar2(1) -- 冲正标识|冲正标识|Y-冲正数据 N-非冲正数据"
    ,deduction_law_type varchar2(8) -- 扣划法律文书类型
    ,out_sign_user_id varchar2(8) -- 解约柜员
    ,unlost_time varchar2(26) -- 解挂时间
    ,sign_channel varchar2(6) -- 签约渠道|签约渠道
    ,sign_user_id varchar2(8) -- 签约柜员|签约柜员
    ,court_code varchar2(10) -- 执行机关码值
    ,actual_pld_amount number(17,2) -- 实际控制金额|司法扣划实际控制金额
    ,oper_narrative varchar2(400) -- 操作备注
    ,start_timestamp varchar2(26) -- 加限的交易时间戳
    ,actual_effect_time varchar2(26) -- 实际生效时间
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
grant select on ${iol_schema}.ncbs_rb_restraints to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_restraints to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_restraints to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_restraints to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_restraints is '帐户限制表';
comment on column ${iol_schema}.ncbs_rb_restraints.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_restraints.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_restraints.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_restraints.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_restraints.restraint_type is '限制类型';
comment on column ${iol_schema}.ncbs_rb_restraints.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_restraints.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_restraints.term is '存期';
comment on column ${iol_schema}.ncbs_rb_restraints.term_type is '期限单位';
comment on column ${iol_schema}.ncbs_rb_restraints.appr_flag is '复核标志';
comment on column ${iol_schema}.ncbs_rb_restraints.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_restraints.company is '法人';
comment on column ${iol_schema}.ncbs_rb_restraints.deduction_law_no is '扣划法律文书号';
comment on column ${iol_schema}.ncbs_rb_restraints.full_freeze_ind is '全额冻结标志';
comment on column ${iol_schema}.ncbs_rb_restraints.help_option is '协助执行事项';
comment on column ${iol_schema}.ncbs_rb_restraints.interrupt_flag is '是否中断';
comment on column ${iol_schema}.ncbs_rb_restraints.is_frozen is '是否续冻';
comment on column ${iol_schema}.ncbs_rb_restraints.maintain_type is '维护方式';
comment on column ${iol_schema}.ncbs_rb_restraints.msg_bank is '银行信息';
comment on column ${iol_schema}.ncbs_rb_restraints.msg_client is '客户信息';
comment on column ${iol_schema}.ncbs_rb_restraints.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_restraints.no_of_payment is '总支付笔数';
comment on column ${iol_schema}.ncbs_rb_restraints.oth_acct_desc is '对方账户描述';
comment on column ${iol_schema}.ncbs_rb_restraints.payment_made is '已支付笔数';
comment on column ${iol_schema}.ncbs_rb_restraints.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_restraints.program_id is '交易代码';
comment on column ${iol_schema}.ncbs_rb_restraints.release_law_no is '解冻机关法律文书号';
comment on column ${iol_schema}.ncbs_rb_restraints.res_acct_range is '限制账户范围';
comment on column ${iol_schema}.ncbs_rb_restraints.res_law_no is '冻结机关法律文书号';
comment on column ${iol_schema}.ncbs_rb_restraints.res_priority is '冻结级别';
comment on column ${iol_schema}.ncbs_rb_restraints.res_seq_no is '限制编号';
comment on column ${iol_schema}.ncbs_rb_restraints.restraint_judiciary_name is '冻结机关名称';
comment on column ${iol_schema}.ncbs_rb_restraints.restraints_status is '限制状态';
comment on column ${iol_schema}.ncbs_rb_restraints.source_module is '源模块';
comment on column ${iol_schema}.ncbs_rb_restraints.spec_code is '指定他行信息';
comment on column ${iol_schema}.ncbs_rb_restraints.start_cheque_no is '起始支票号码';
comment on column ${iol_schema}.ncbs_rb_restraints.stl_seq_no is '结算流水号';
comment on column ${iol_schema}.ncbs_rb_restraints.sub_restraint_class is '子限制类别';
comment on column ${iol_schema}.ncbs_rb_restraints.thaw_officer_name is '经办人1姓名';
comment on column ${iol_schema}.ncbs_rb_restraints.thaw_oth_officer_name is '经办人2姓名';
comment on column ${iol_schema}.ncbs_rb_restraints.under_lien is '是否抵制押标志';
comment on column ${iol_schema}.ncbs_rb_restraints.wait_seq is '轮候冻结序号';
comment on column ${iol_schema}.ncbs_rb_restraints.approval_date is '复核日期';
comment on column ${iol_schema}.ncbs_rb_restraints.channel_date is '渠道日期';
comment on column ${iol_schema}.ncbs_rb_restraints.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_rb_restraints.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_restraints.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_rb_restraints.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_restraints.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_rb_restraints.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_restraints.deduction_judiciary_name is '有权机关名称';
comment on column ${iol_schema}.ncbs_rb_restraints.end_amt is '截止金额';
comment on column ${iol_schema}.ncbs_rb_restraints.end_cheque_no is '终止支票号码';
comment on column ${iol_schema}.ncbs_rb_restraints.judiciary_document_id is '执法人1证件号码';
comment on column ${iol_schema}.ncbs_rb_restraints.judiciary_document_id2 is '执法人1证件号码2';
comment on column ${iol_schema}.ncbs_rb_restraints.judiciary_document_type is '执法人1证件类型';
comment on column ${iol_schema}.ncbs_rb_restraints.judiciary_document_type2 is '执法人1证件类型2';
comment on column ${iol_schema}.ncbs_rb_restraints.judiciary_officer_name is '执法人1姓名';
comment on column ${iol_schema}.ncbs_rb_restraints.judiciary_oth_document_id is '执法人2证件号码';
comment on column ${iol_schema}.ncbs_rb_restraints.judiciary_oth_document_id2 is '执法人2证件号码2';
comment on column ${iol_schema}.ncbs_rb_restraints.judiciary_oth_document_type is '执法人2证件类型';
comment on column ${iol_schema}.ncbs_rb_restraints.judiciary_oth_document_type2 is '执法人2证件类型2';
comment on column ${iol_schema}.ncbs_rb_restraints.judiciary_oth_officer_name is '执法人2姓名';
comment on column ${iol_schema}.ncbs_rb_restraints.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_rb_restraints.oth_acct_ccy is '对方账户币种';
comment on column ${iol_schema}.ncbs_rb_restraints.oth_acct_no is '对方账号';
comment on column ${iol_schema}.ncbs_rb_restraints.oth_bank_code is '对方银行代码';
comment on column ${iol_schema}.ncbs_rb_restraints.oth_base_acct_no is '对方账号/卡号';
comment on column ${iol_schema}.ncbs_rb_restraints.oth_prod_type is '对方账户产品类型';
comment on column ${iol_schema}.ncbs_rb_restraints.paid_amt is '已还金额';
comment on column ${iol_schema}.ncbs_rb_restraints.pledged_acct_ccy is '抵押账户币种';
comment on column ${iol_schema}.ncbs_rb_restraints.pledged_acct_no is '抵押账号';
comment on column ${iol_schema}.ncbs_rb_restraints.pledged_acct_type is '抵押账户类型';
comment on column ${iol_schema}.ncbs_rb_restraints.pledged_amt is '限制金额';
comment on column ${iol_schema}.ncbs_rb_restraints.pledged_base_acct_no is '抵押主账号';
comment on column ${iol_schema}.ncbs_rb_restraints.real_restraint_amt is '可扣划金额';
comment on column ${iol_schema}.ncbs_rb_restraints.release_judiciary_name is '解冻机关名称';
comment on column ${iol_schema}.ncbs_rb_restraints.start_amt is '起始金额';
comment on column ${iol_schema}.ncbs_rb_restraints.thaw_document_id is '经办人1证件号码';
comment on column ${iol_schema}.ncbs_rb_restraints.thaw_document_id2 is '经办人1证件号码2';
comment on column ${iol_schema}.ncbs_rb_restraints.thaw_document_type is '经办人1证件类型1';
comment on column ${iol_schema}.ncbs_rb_restraints.thaw_oth_document_id is '经办人2证件号码';
comment on column ${iol_schema}.ncbs_rb_restraints.thaw_oth_document_id2 is '经办人2证件号码2';
comment on column ${iol_schema}.ncbs_rb_restraints.thaw_oth_document_type is '经办人2证件类型';
comment on column ${iol_schema}.ncbs_rb_restraints.thaw_oth_document_type2 is '经办人2证件类型2';
comment on column ${iol_schema}.ncbs_rb_restraints.to_pay_amt is '支付金额';
comment on column ${iol_schema}.ncbs_rb_restraints.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_restraints.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_restraints.thaw_document_type2 is '经办人1证件类型2';
comment on column ${iol_schema}.ncbs_rb_restraints.reaccount_cd is '对账代码';
comment on column ${iol_schema}.ncbs_rb_restraints.reserve is '冲正标识|冲正标识|Y-冲正数据 N-非冲正数据"';
comment on column ${iol_schema}.ncbs_rb_restraints.deduction_law_type is '扣划法律文书类型';
comment on column ${iol_schema}.ncbs_rb_restraints.out_sign_user_id is '解约柜员';
comment on column ${iol_schema}.ncbs_rb_restraints.unlost_time is '解挂时间';
comment on column ${iol_schema}.ncbs_rb_restraints.sign_channel is '签约渠道|签约渠道';
comment on column ${iol_schema}.ncbs_rb_restraints.sign_user_id is '签约柜员|签约柜员';
comment on column ${iol_schema}.ncbs_rb_restraints.court_code is '执行机关码值';
comment on column ${iol_schema}.ncbs_rb_restraints.actual_pld_amount is '实际控制金额|司法扣划实际控制金额';
comment on column ${iol_schema}.ncbs_rb_restraints.oper_narrative is '操作备注';
comment on column ${iol_schema}.ncbs_rb_restraints.start_timestamp is '加限的交易时间戳';
comment on column ${iol_schema}.ncbs_rb_restraints.actual_effect_time is '实际生效时间';
comment on column ${iol_schema}.ncbs_rb_restraints.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_restraints.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_restraints.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_restraints.etl_timestamp is 'ETL处理时间戳';
