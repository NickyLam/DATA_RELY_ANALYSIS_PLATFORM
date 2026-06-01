/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol albs_bps_rsh_cust_hit_fund
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.albs_bps_rsh_cust_hit_fund
whenever sqlerror continue none;
drop table ${iol_schema}.albs_bps_rsh_cust_hit_fund purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.albs_bps_rsh_cust_hit_fund(
    id varchar2(24) -- 表主键
    ,main_id varchar2(24) -- 表主键
    ,own_org varchar2(48) -- 归属组织
    ,cust_id varchar2(48) -- 客户表主键
    ,sch_result varchar2(3) -- 检索命中结果：00-检索通过；02-中黑名单；03-中白名单；01-中高风险国家地区；99-检索异常。
    ,match_level_id varchar2(48) -- 命中后的侦测等级ID，对应匹配等级参数表的值。
    ,risk_level varchar2(3) -- 风险等级（1-一级，2-二级，3-三级，4-四级，5-五级），该值从枚举表中定义，后面会变化
    ,list_scope varchar2(300) -- 检索名单范围，登记该次检索用到的名单范围，多个用半角逗号分隔。
    ,confirm_result varchar2(3) -- 确认结果
    ,last_confirm_result varchar2(3) -- 上次确认结果：0-未确认；1-确认命中；2-确认误中。
    ,crt_date varchar2(12) -- 创建日期(YYYYMMDD)
    ,crt_datetime varchar2(21) -- 创建时间(YYYYMMDDHHMMSS)
    ,last_datetime varchar2(21) -- 最后操作时间(YYYYMMDDHHMMSS)
    ,last_user_id varchar2(48) -- 最后操作用户ID
    ,last_user_code varchar2(96) -- 最后操作用户代码
    ,system_id varchar2(48) -- 对接系统
    ,cust_code varchar2(48) -- 客户编号
    ,cust_type varchar2(8) -- 客户类型
    ,cust_kind varchar2(2) -- 客户种类
    ,cust_name varchar2(180) -- 客户名称
    ,cust_eng_name varchar2(180) -- 客户英文名称
    ,cust_addr varchar2(360) -- 客户地址
    ,cust_eng_addr varchar2(360) -- 客户英文地址
    ,cust_id_type varchar2(24) -- 客户证件类型
    ,cust_id_no varchar2(48) -- 客户证件号
    ,cust_country varchar2(72) -- 客户国家
    ,crt_user_code varchar2(96) -- 创建用户代码
    ,crt_branch_code varchar2(96) -- 创建用户机构代码
    ,last_branch_id varchar2(48) -- 业务机构ID
    ,last_txn varchar2(48) -- 交易码
    ,sch_kind varchar2(12) -- 增量回溯类型
    ,backfiels1 varchar2(75) -- 备用字段1
    ,backfiels2 varchar2(75) -- 备用字段2
    ,backfiels3 varchar2(75) -- 备用字段3
    ,confirm_desc varchar2(768) -- 
    ,cust_check_pass varchar2(3) -- 
    ,check_pass_flag varchar2(3) -- 
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
grant select on ${iol_schema}.albs_bps_rsh_cust_hit_fund to ${iml_schema};
grant select on ${iol_schema}.albs_bps_rsh_cust_hit_fund to ${icl_schema};
grant select on ${iol_schema}.albs_bps_rsh_cust_hit_fund to ${idl_schema};
grant select on ${iol_schema}.albs_bps_rsh_cust_hit_fund to ${iel_schema};

-- comment
comment on table ${iol_schema}.albs_bps_rsh_cust_hit_fund is '增量客户命中表';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.id is '表主键';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.main_id is '表主键';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.own_org is '归属组织';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.cust_id is '客户表主键';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.sch_result is '检索命中结果：00-检索通过；02-中黑名单；03-中白名单；01-中高风险国家地区；99-检索异常。';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.match_level_id is '命中后的侦测等级ID，对应匹配等级参数表的值。';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.risk_level is '风险等级（1-一级，2-二级，3-三级，4-四级，5-五级），该值从枚举表中定义，后面会变化';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.list_scope is '检索名单范围，登记该次检索用到的名单范围，多个用半角逗号分隔。';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.confirm_result is '确认结果';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.last_confirm_result is '上次确认结果：0-未确认；1-确认命中；2-确认误中。';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.crt_date is '创建日期(YYYYMMDD)';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.crt_datetime is '创建时间(YYYYMMDDHHMMSS)';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.last_datetime is '最后操作时间(YYYYMMDDHHMMSS)';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.last_user_id is '最后操作用户ID';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.last_user_code is '最后操作用户代码';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.system_id is '对接系统';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.cust_code is '客户编号';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.cust_type is '客户类型';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.cust_kind is '客户种类';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.cust_name is '客户名称';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.cust_eng_name is '客户英文名称';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.cust_addr is '客户地址';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.cust_eng_addr is '客户英文地址';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.cust_id_type is '客户证件类型';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.cust_id_no is '客户证件号';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.cust_country is '客户国家';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.crt_user_code is '创建用户代码';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.crt_branch_code is '创建用户机构代码';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.last_branch_id is '业务机构ID';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.last_txn is '交易码';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.sch_kind is '增量回溯类型';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.backfiels1 is '备用字段1';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.backfiels2 is '备用字段2';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.backfiels3 is '备用字段3';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.confirm_desc is '';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.cust_check_pass is '';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.check_pass_flag is '';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.albs_bps_rsh_cust_hit_fund.etl_timestamp is 'ETL处理时间戳';
