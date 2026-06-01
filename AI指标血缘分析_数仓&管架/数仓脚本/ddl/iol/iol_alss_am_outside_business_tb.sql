/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol alss_am_outside_business_tb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.alss_am_outside_business_tb
whenever sqlerror continue none;
drop table ${iol_schema}.alss_am_outside_business_tb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.alss_am_outside_business_tb(
    id varchar2(50) -- ID
    ,bach_date varchar2(50) -- 批次年月
    ,acct_no varchar2(100) -- 账号
    ,card_id varchar2(100) -- 卡号
    ,acct_name varchar2(200) -- 户名
    ,open_acct_organ varchar2(10) -- 开户机构
    ,approve_result varchar2(10) -- 审批结果
    ,approve_date varchar2(20) -- 审批日期
    ,upload_date varchar2(20) -- 上传日志
    ,jx_money varchar2(20) -- 久悬金额
    ,open_acct_date varchar2(20) -- 开户日期
    ,bd_date varchar2(20) -- 设置不动户日期
    ,jx_date varchar2(20) -- 设置久悬户日期
    ,old_trans_date varchar2(20) -- 上一次主动交易日期
    ,one_acct_num varchar2(20) -- 一人多户数量
    ,is_iden_date varchar2(20) -- 是否证件过期（0-否，1-是）
    ,nine_info varchar2(10) -- 9要素是否齐全
    ,gg_person varchar2(200) -- 共管人
    ,gh_person varchar2(200) -- 管户人
    ,last_aum varchar2(20) -- 上季度AUM
    ,cus_wealth_level varchar2(50) -- 客户财富等级
    ,last_quarter_approve varchar2(1000) -- 上季度审批情况
    ,last_quarter_ncbs_approve varchar2(1000) -- 上季度核心处理结果
    ,data_type varchar2(1) -- 数据类型
    ,acct_seq_no varchar2(10) -- 账户子账号
    ,sys_user_id varchar2(100) -- 共管人ID
    ,mag_cst_mgr_id varchar2(1000) -- 管户人ID
    ,fail_reason varchar2(4000) -- 
    ,bach_no varchar2(50) -- 
    ,date1 varchar2(50) -- 
    ,cust_id varchar2(100) -- 
    ,querter varchar2(100) -- 季度
    ,is_exception_of_phone varchar2(120) -- 手机号是否异常
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
grant select on ${iol_schema}.alss_am_outside_business_tb to ${iml_schema};
grant select on ${iol_schema}.alss_am_outside_business_tb to ${icl_schema};
grant select on ${iol_schema}.alss_am_outside_business_tb to ${idl_schema};
grant select on ${iol_schema}.alss_am_outside_business_tb to ${iel_schema};

-- comment
comment on table ${iol_schema}.alss_am_outside_business_tb is '个人久悬户转营业外待处置的基本信息';
comment on column ${iol_schema}.alss_am_outside_business_tb.id is 'ID';
comment on column ${iol_schema}.alss_am_outside_business_tb.bach_date is '批次年月';
comment on column ${iol_schema}.alss_am_outside_business_tb.acct_no is '账号';
comment on column ${iol_schema}.alss_am_outside_business_tb.card_id is '卡号';
comment on column ${iol_schema}.alss_am_outside_business_tb.acct_name is '户名';
comment on column ${iol_schema}.alss_am_outside_business_tb.open_acct_organ is '开户机构';
comment on column ${iol_schema}.alss_am_outside_business_tb.approve_result is '审批结果';
comment on column ${iol_schema}.alss_am_outside_business_tb.approve_date is '审批日期';
comment on column ${iol_schema}.alss_am_outside_business_tb.upload_date is '上传日志';
comment on column ${iol_schema}.alss_am_outside_business_tb.jx_money is '久悬金额';
comment on column ${iol_schema}.alss_am_outside_business_tb.open_acct_date is '开户日期';
comment on column ${iol_schema}.alss_am_outside_business_tb.bd_date is '设置不动户日期';
comment on column ${iol_schema}.alss_am_outside_business_tb.jx_date is '设置久悬户日期';
comment on column ${iol_schema}.alss_am_outside_business_tb.old_trans_date is '上一次主动交易日期';
comment on column ${iol_schema}.alss_am_outside_business_tb.one_acct_num is '一人多户数量';
comment on column ${iol_schema}.alss_am_outside_business_tb.is_iden_date is '是否证件过期（0-否，1-是）';
comment on column ${iol_schema}.alss_am_outside_business_tb.nine_info is '9要素是否齐全';
comment on column ${iol_schema}.alss_am_outside_business_tb.gg_person is '共管人';
comment on column ${iol_schema}.alss_am_outside_business_tb.gh_person is '管户人';
comment on column ${iol_schema}.alss_am_outside_business_tb.last_aum is '上季度AUM';
comment on column ${iol_schema}.alss_am_outside_business_tb.cus_wealth_level is '客户财富等级';
comment on column ${iol_schema}.alss_am_outside_business_tb.last_quarter_approve is '上季度审批情况';
comment on column ${iol_schema}.alss_am_outside_business_tb.last_quarter_ncbs_approve is '上季度核心处理结果';
comment on column ${iol_schema}.alss_am_outside_business_tb.data_type is '数据类型';
comment on column ${iol_schema}.alss_am_outside_business_tb.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.alss_am_outside_business_tb.sys_user_id is '共管人ID';
comment on column ${iol_schema}.alss_am_outside_business_tb.mag_cst_mgr_id is '管户人ID';
comment on column ${iol_schema}.alss_am_outside_business_tb.fail_reason is '';
comment on column ${iol_schema}.alss_am_outside_business_tb.bach_no is '';
comment on column ${iol_schema}.alss_am_outside_business_tb.date1 is '';
comment on column ${iol_schema}.alss_am_outside_business_tb.cust_id is '';
comment on column ${iol_schema}.alss_am_outside_business_tb.querter is '季度';
comment on column ${iol_schema}.alss_am_outside_business_tb.is_exception_of_phone is '手机号是否异常';
comment on column ${iol_schema}.alss_am_outside_business_tb.start_dt is '开始时间';
comment on column ${iol_schema}.alss_am_outside_business_tb.end_dt is '结束时间';
comment on column ${iol_schema}.alss_am_outside_business_tb.id_mark is '增删标志';
comment on column ${iol_schema}.alss_am_outside_business_tb.etl_timestamp is 'ETL处理时间戳';
