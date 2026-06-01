/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_pre_doss_reg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_pre_doss_reg
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_pre_doss_reg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_pre_doss_reg(
    batch_no varchar2(50) -- 批次号|批次号
    ,base_acct_no varchar2(50) -- 交易账号/卡号|用于描述不同账户结构下的账号，如果是卡的话代表卡号，否则代表账号
    ,acct_seq_no varchar2(5) -- 账户子账号|账户序列号，采用顺序数字，表示在同一账号、账户类型、币种下的不同子账户，比如定期存款序列号，卡下选择账户
    ,doss_date date -- 转久悬日期|转久悬日期
    ,acct_name varchar2(200) -- 账户名称|账户名称，一般指中文账户名称
    ,acct_branch varchar2(12) -- 开户机构编号|账户实际开户机构，柜面为实际网点机构，线上渠道一般为对应主账户的实际开户机构
    ,pre_trf_flag varchar2(1) -- 预转标识|久悬户预转标识|s-预转成功,f-预转失败
    ,batch_status varchar2(1) -- 批次处理状态|批次处理状态|n-新建,v-已验证,w-待处理(部分成功),s-成功,f-失败,d-待审批,a-已审批
    ,failure_reason varchar2(200) -- 失败原因|失败原因
    ,audit_date date -- 审计日期|审计日期
    ,company varchar2(20) -- 法人|法人
    ,tran_timestamp varchar2(26) -- 交易时间戳|交易时间戳
    ,approve_status varchar2(1) -- 审批状态|久悬户处理审批状态|y-审核通过,n-审核不通过
    ,remark varchar2(600) -- 备注|备注
    ,internal_key number(15,0) -- 账户内部键值|账户内部键值
    ,client_no varchar2(16) -- 客户编号|客户编号
    ,approval_date date -- 复核日期|复核日期
    ,sub_seq_no varchar2(100) -- 系统子流水号|系统子流水号
    ,user_id varchar2(8) -- 交易柜员编号|核心交易柜员编号
    ,control_msg varchar2(3000) -- 
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
grant select on ${iol_schema}.ncbs_rb_pre_doss_reg to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_pre_doss_reg to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_pre_doss_reg to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_pre_doss_reg to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_pre_doss_reg is '预转久悬清单';
comment on column ${iol_schema}.ncbs_rb_pre_doss_reg.batch_no is '批次号|批次号';
comment on column ${iol_schema}.ncbs_rb_pre_doss_reg.base_acct_no is '交易账号/卡号|用于描述不同账户结构下的账号，如果是卡的话代表卡号，否则代表账号';
comment on column ${iol_schema}.ncbs_rb_pre_doss_reg.acct_seq_no is '账户子账号|账户序列号，采用顺序数字，表示在同一账号、账户类型、币种下的不同子账户，比如定期存款序列号，卡下选择账户';
comment on column ${iol_schema}.ncbs_rb_pre_doss_reg.doss_date is '转久悬日期|转久悬日期';
comment on column ${iol_schema}.ncbs_rb_pre_doss_reg.acct_name is '账户名称|账户名称，一般指中文账户名称';
comment on column ${iol_schema}.ncbs_rb_pre_doss_reg.acct_branch is '开户机构编号|账户实际开户机构，柜面为实际网点机构，线上渠道一般为对应主账户的实际开户机构';
comment on column ${iol_schema}.ncbs_rb_pre_doss_reg.pre_trf_flag is '预转标识|久悬户预转标识|s-预转成功,f-预转失败';
comment on column ${iol_schema}.ncbs_rb_pre_doss_reg.batch_status is '批次处理状态|批次处理状态|n-新建,v-已验证,w-待处理(部分成功),s-成功,f-失败,d-待审批,a-已审批';
comment on column ${iol_schema}.ncbs_rb_pre_doss_reg.failure_reason is '失败原因|失败原因';
comment on column ${iol_schema}.ncbs_rb_pre_doss_reg.audit_date is '审计日期|审计日期';
comment on column ${iol_schema}.ncbs_rb_pre_doss_reg.company is '法人|法人';
comment on column ${iol_schema}.ncbs_rb_pre_doss_reg.tran_timestamp is '交易时间戳|交易时间戳';
comment on column ${iol_schema}.ncbs_rb_pre_doss_reg.approve_status is '审批状态|久悬户处理审批状态|y-审核通过,n-审核不通过';
comment on column ${iol_schema}.ncbs_rb_pre_doss_reg.remark is '备注|备注';
comment on column ${iol_schema}.ncbs_rb_pre_doss_reg.internal_key is '账户内部键值|账户内部键值';
comment on column ${iol_schema}.ncbs_rb_pre_doss_reg.client_no is '客户编号|客户编号';
comment on column ${iol_schema}.ncbs_rb_pre_doss_reg.approval_date is '复核日期|复核日期';
comment on column ${iol_schema}.ncbs_rb_pre_doss_reg.sub_seq_no is '系统子流水号|系统子流水号';
comment on column ${iol_schema}.ncbs_rb_pre_doss_reg.user_id is '交易柜员编号|核心交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_pre_doss_reg.control_msg is '';
comment on column ${iol_schema}.ncbs_rb_pre_doss_reg.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_pre_doss_reg.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_pre_doss_reg.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_pre_doss_reg.etl_timestamp is 'ETL处理时间戳';
