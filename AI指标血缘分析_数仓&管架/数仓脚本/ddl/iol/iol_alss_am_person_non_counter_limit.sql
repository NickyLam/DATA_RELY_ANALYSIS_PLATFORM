/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol alss_am_person_non_counter_limit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.alss_am_person_non_counter_limit
whenever sqlerror continue none;
drop table ${iol_schema}.alss_am_person_non_counter_limit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.alss_am_person_non_counter_limit(
    apply_status varchar2(120) -- 审批类型
    ,cust_acct_id varchar2(120) -- 账号/卡号
    ,pre_proc_id varchar2(120) -- 预受理编号
    ,cust_name varchar2(120) -- 客户名称
    ,cert_type varchar2(120) -- 证件类型
    ,cert_no varchar2(120) -- 证件号
    ,create_organ varchar2(120) -- 发起人机构
    ,create_user_teller_id varchar2(120) -- 发起人
    ,create_time varchar2(120) -- 发起日期：YYYYMMDD H24:MM:SS
    ,deal_status varchar2(120) -- 处理状态：1-待处理、2-通过、3-不通过、4-终止
    ,cust_mgr_teller_id varchar2(120) -- 客户经理 员工号-姓名
    ,cust_mgr_deal_time varchar2(120) -- 客户经理处理日期 YYYYMMDD H24:MM:SS
    ,check_teller_id varchar2(1200) -- 复核人 员工号-姓名
    ,check_time varchar2(120) -- 复核日期 YYYYMMDD H24:MM:SS
    ,non_counter_limit varchar2(120) -- 单笔交易限额
    ,person_non_counter_day_limit varchar2(120) -- 日累计交易限额
    ,person_non_counter_day_count varchar2(120) -- 日累计笔数
    ,person_non_counter_year_limit varchar2(120) -- 年累计交易限额
    ,data_status varchar2(120) -- 数据状态
    ,apply_id varchar2(120) -- 审批单号
    ,cust_mgr_organ varchar2(120) -- 客户经理机构
    ,check_organ varchar2(120) -- 复核人机构
    ,check_info varchar2(3000) -- 复核说明
    ,phone varchar2(50) -- 手机号
    ,cust_no varchar2(50) -- 客户号
    ,card_class varchar2(120) -- 卡片等级
    ,paper_no varchar2(120) -- 证件号
    ,paper_type varchar2(120) -- 证件类型
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
grant select on ${iol_schema}.alss_am_person_non_counter_limit to ${iml_schema};
grant select on ${iol_schema}.alss_am_person_non_counter_limit to ${icl_schema};
grant select on ${iol_schema}.alss_am_person_non_counter_limit to ${idl_schema};
grant select on ${iol_schema}.alss_am_person_non_counter_limit to ${iel_schema};

-- comment
comment on table ${iol_schema}.alss_am_person_non_counter_limit is '个人非柜面限额审批';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.apply_status is '审批类型';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.cust_acct_id is '账号/卡号';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.pre_proc_id is '预受理编号';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.cust_name is '客户名称';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.cert_type is '证件类型';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.cert_no is '证件号';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.create_organ is '发起人机构';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.create_user_teller_id is '发起人';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.create_time is '发起日期：YYYYMMDD H24:MM:SS';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.deal_status is '处理状态：1-待处理、2-通过、3-不通过、4-终止';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.cust_mgr_teller_id is '客户经理 员工号-姓名';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.cust_mgr_deal_time is '客户经理处理日期 YYYYMMDD H24:MM:SS';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.check_teller_id is '复核人 员工号-姓名';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.check_time is '复核日期 YYYYMMDD H24:MM:SS';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.non_counter_limit is '单笔交易限额';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.person_non_counter_day_limit is '日累计交易限额';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.person_non_counter_day_count is '日累计笔数';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.person_non_counter_year_limit is '年累计交易限额';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.data_status is '数据状态';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.apply_id is '审批单号';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.cust_mgr_organ is '客户经理机构';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.check_organ is '复核人机构';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.check_info is '复核说明';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.phone is '手机号';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.cust_no is '客户号';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.card_class is '卡片等级';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.paper_no is '证件号';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.paper_type is '证件类型';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.alss_am_person_non_counter_limit.etl_timestamp is 'ETL处理时间戳';
