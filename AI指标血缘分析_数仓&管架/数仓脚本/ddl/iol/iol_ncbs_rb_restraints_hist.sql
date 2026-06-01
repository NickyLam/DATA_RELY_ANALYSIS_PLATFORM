/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_restraints_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_restraints_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_restraints_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_restraints_hist(
    base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,reference varchar2(50) -- 交易参考号
    ,restraint_type varchar2(3) -- 限制类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,term varchar2(5) -- 存期
    ,term_type varchar2(1) -- 期限单位
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,help_option varchar2(20) -- 协助执行事项
    ,init_seq_no varchar2(50) -- 初始限制流水号
    ,is_frozen varchar2(1) -- 是否续冻
    ,last_status varchar2(1) -- 前一限制状态
    ,main_flag varchar2(1) -- 主、分账户类型标志
    ,narrative varchar2(400) -- 摘要
    ,release_law_no varchar2(150) -- 解冻机关法律文书号
    ,res_acct_range varchar2(1) -- 限制账户范围
    ,res_law_no varchar2(150) -- 冻结机关法律文书号
    ,res_priority varchar2(2) -- 冻结级别
    ,res_seq_no varchar2(50) -- 限制编号
    ,restraint_judiciary_name varchar2(200) -- 冻结机关名称
    ,restraints_status varchar2(1) -- 限制状态
    ,seq_no varchar2(50) -- 序号
    ,source_type varchar2(6) -- 渠道编号
    ,sub_restraint_class varchar2(10) -- 子限制类别
    ,system_phase varchar2(3) -- 系统所处的阶段
    ,thaw_officer_name varchar2(50) -- 经办人1姓名
    ,thaw_oth_officer_name varchar2(50) -- 经办人2姓名
    ,under_lien varchar2(1) -- 是否抵制押标志
    ,approval_date date -- 复核日期
    ,end_date date -- 结束日期
    ,last_change_date date -- 最后修改日期
    ,start_date date -- 开始日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,auth_user_id varchar2(8) -- 授权柜员
    ,deduction_judiciary_name varchar2(200) -- 有权机关名称
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
    ,pledged_amt number(17,2) -- 限制金额
    ,release_judiciary_name varchar2(200) -- 解冻机关名称
    ,thaw_document_id varchar2(60) -- 经办人1证件号码
    ,thaw_document_id2 varchar2(60) -- 经办人1证件号码2
    ,thaw_document_type varchar2(4) -- 经办人1证件类型1
    ,thaw_oth_document_id varchar2(60) -- 经办人2证件号码
    ,thaw_oth_document_id2 varchar2(60) -- 经办人2证件号码2
    ,thaw_oth_document_type varchar2(4) -- 经办人2证件类型
    ,thaw_oth_document_type2 varchar2(4) -- 经办人2证件类型2
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,thaw_document_type2 varchar2(4) -- 经办人1证件类型2
    ,reserve varchar2(1) -- 冲正标识|冲正标识|Y-冲正数据 N-非冲正数据
    ,reaccount_cd varchar2(20) -- 对账代码|对账代码
    ,tran_amt number(17,2) -- 交易金额
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
grant select on ${iol_schema}.ncbs_rb_restraints_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_restraints_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_restraints_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_restraints_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_restraints_hist is '帐户限制历史表';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.restraint_type is '限制类型';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.term is '存期';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.term_type is '期限单位';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.help_option is '协助执行事项';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.init_seq_no is '初始限制流水号';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.is_frozen is '是否续冻';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.last_status is '前一限制状态';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.main_flag is '主、分账户类型标志';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.release_law_no is '解冻机关法律文书号';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.res_acct_range is '限制账户范围';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.res_law_no is '冻结机关法律文书号';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.res_priority is '冻结级别';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.res_seq_no is '限制编号';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.restraint_judiciary_name is '冻结机关名称';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.restraints_status is '限制状态';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.sub_restraint_class is '子限制类别';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.system_phase is '系统所处的阶段';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.thaw_officer_name is '经办人1姓名';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.thaw_oth_officer_name is '经办人2姓名';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.under_lien is '是否抵制押标志';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.approval_date is '复核日期';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.deduction_judiciary_name is '有权机关名称';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.judiciary_document_id is '执法人1证件号码';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.judiciary_document_id2 is '执法人1证件号码2';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.judiciary_document_type is '执法人1证件类型';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.judiciary_document_type2 is '执法人1证件类型2';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.judiciary_officer_name is '执法人1姓名';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.judiciary_oth_document_id is '执法人2证件号码';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.judiciary_oth_document_id2 is '执法人2证件号码2';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.judiciary_oth_document_type is '执法人2证件类型';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.judiciary_oth_document_type2 is '执法人2证件类型2';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.judiciary_oth_officer_name is '执法人2姓名';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.pledged_amt is '限制金额';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.release_judiciary_name is '解冻机关名称';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.thaw_document_id is '经办人1证件号码';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.thaw_document_id2 is '经办人1证件号码2';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.thaw_document_type is '经办人1证件类型1';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.thaw_oth_document_id is '经办人2证件号码';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.thaw_oth_document_id2 is '经办人2证件号码2';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.thaw_oth_document_type is '经办人2证件类型';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.thaw_oth_document_type2 is '经办人2证件类型2';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.thaw_document_type2 is '经办人1证件类型2';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.reserve is '冲正标识|冲正标识|Y-冲正数据 N-非冲正数据';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.reaccount_cd is '对账代码|对账代码';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_restraints_hist.etl_timestamp is 'ETL处理时间戳';
