/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1wpm_employee_base_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1wpm_employee_base_info
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1wpm_employee_base_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1wpm_employee_base_info(
    employee_id varchar2(192) -- 员工ID
    ,employee_name varchar2(768) -- 员工姓名
    ,incumbency_flag varchar2(12) -- 在职标识(Y-在职;N-离职)
    ,enable_flag varchar2(12) -- 启停用标识(Y-启用;N-停用)
    ,user_id varchar2(192) -- 用户ID
    ,cert_type varchar2(48) -- 证件类型
    ,cert_no varchar2(192) -- 证件号码
    ,leave_status varchar2(12) -- 离职状态(01-待离职;02-离职中;03-已离职;04-离职失败;05-撤销离职)
    ,acct_no varchar2(192) -- 银行账号
    ,phone_no varchar2(96) -- 电话号码
    ,company_id varchar2(192) -- 公司ID
    ,rank_id varchar2(192) -- 职级ID
    ,organ_id varchar2(192) -- 组织ID
    ,post_id varchar2(192) -- 岗位ID
    ,entry_date varchar2(60) -- 入职日期
    ,employee_type varchar2(12) -- 员工类型(01-正式;02-试用;03-实习)
    ,employee_gender varchar2(12) -- 员工性别(01-女;02-男)
    ,employee_no varchar2(192) -- 员工编号
    ,quit_company_flag varchar2(6) -- 是否退出公司(Y-是;N-否)
    ,syn_source varchar2(12) -- 员工信息来源(01-平台;02-企业微信;03-钉钉;04-飞书)
    ,recover_flag varchar2(6) -- 离职恢复标识(Y-是;N-否)
    ,create_timestamp varchar2(144) -- 创建时间戳
    ,update_timestamp varchar2(144) -- 更新时间戳
    ,manage_flag varchar2(6) -- 是否运管端停用
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
grant select on ${iol_schema}.mpcs_a1wpm_employee_base_info to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1wpm_employee_base_info to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1wpm_employee_base_info to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1wpm_employee_base_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1wpm_employee_base_info is '员工基础信息表';
comment on column ${iol_schema}.mpcs_a1wpm_employee_base_info.employee_id is '员工ID';
comment on column ${iol_schema}.mpcs_a1wpm_employee_base_info.employee_name is '员工姓名';
comment on column ${iol_schema}.mpcs_a1wpm_employee_base_info.incumbency_flag is '在职标识(Y-在职;N-离职)';
comment on column ${iol_schema}.mpcs_a1wpm_employee_base_info.enable_flag is '启停用标识(Y-启用;N-停用)';
comment on column ${iol_schema}.mpcs_a1wpm_employee_base_info.user_id is '用户ID';
comment on column ${iol_schema}.mpcs_a1wpm_employee_base_info.cert_type is '证件类型';
comment on column ${iol_schema}.mpcs_a1wpm_employee_base_info.cert_no is '证件号码';
comment on column ${iol_schema}.mpcs_a1wpm_employee_base_info.leave_status is '离职状态(01-待离职;02-离职中;03-已离职;04-离职失败;05-撤销离职)';
comment on column ${iol_schema}.mpcs_a1wpm_employee_base_info.acct_no is '银行账号';
comment on column ${iol_schema}.mpcs_a1wpm_employee_base_info.phone_no is '电话号码';
comment on column ${iol_schema}.mpcs_a1wpm_employee_base_info.company_id is '公司ID';
comment on column ${iol_schema}.mpcs_a1wpm_employee_base_info.rank_id is '职级ID';
comment on column ${iol_schema}.mpcs_a1wpm_employee_base_info.organ_id is '组织ID';
comment on column ${iol_schema}.mpcs_a1wpm_employee_base_info.post_id is '岗位ID';
comment on column ${iol_schema}.mpcs_a1wpm_employee_base_info.entry_date is '入职日期';
comment on column ${iol_schema}.mpcs_a1wpm_employee_base_info.employee_type is '员工类型(01-正式;02-试用;03-实习)';
comment on column ${iol_schema}.mpcs_a1wpm_employee_base_info.employee_gender is '员工性别(01-女;02-男)';
comment on column ${iol_schema}.mpcs_a1wpm_employee_base_info.employee_no is '员工编号';
comment on column ${iol_schema}.mpcs_a1wpm_employee_base_info.quit_company_flag is '是否退出公司(Y-是;N-否)';
comment on column ${iol_schema}.mpcs_a1wpm_employee_base_info.syn_source is '员工信息来源(01-平台;02-企业微信;03-钉钉;04-飞书)';
comment on column ${iol_schema}.mpcs_a1wpm_employee_base_info.recover_flag is '离职恢复标识(Y-是;N-否)';
comment on column ${iol_schema}.mpcs_a1wpm_employee_base_info.create_timestamp is '创建时间戳';
comment on column ${iol_schema}.mpcs_a1wpm_employee_base_info.update_timestamp is '更新时间戳';
comment on column ${iol_schema}.mpcs_a1wpm_employee_base_info.manage_flag is '是否运管端停用';
comment on column ${iol_schema}.mpcs_a1wpm_employee_base_info.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a1wpm_employee_base_info.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a1wpm_employee_base_info.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a1wpm_employee_base_info.etl_timestamp is 'ETL处理时间戳';
