/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_atms_retain_card_table
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_atms_retain_card_table
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_atms_retain_card_table purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_atms_retain_card_table(
    etl_dt date
    ,logic_id varchar2(36)
    ,dev_no varchar2(20)
    ,retain_date varchar2(10)
    ,retain_time varchar2(10)
    ,account varchar2(25)
    ,reason varchar2(200)
    ,period varchar2(10)
    ,card_stuck_org varchar2(20)
    ,card_handle_org varchar2(20)
    ,auto_flag varchar2(1)
    ,check_op varchar2(20)
    ,check_date varchar2(10)
    ,check_time varchar2(10)
    ,op_no varchar2(20)
    ,op_date varchar2(10)
    ,op_time varchar2(10)
    ,op_address varchar2(80)
    ,account_name varchar2(20)
    ,account_id varchar2(20)
    ,account_phome varchar2(15)
    ,cert_type varchar2(1)
    ,status varchar2(2)
    ,start_dt date
    ,end_dt date
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_atms_retain_card_table to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_atms_retain_card_table is '吞卡信息表';
comment on column ${msl_schema}.msl_edw_atms_retain_card_table.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_atms_retain_card_table.logic_id is '编号';
comment on column ${msl_schema}.msl_edw_atms_retain_card_table.dev_no is '设备号';
comment on column ${msl_schema}.msl_edw_atms_retain_card_table.retain_date is '吞卡日期';
comment on column ${msl_schema}.msl_edw_atms_retain_card_table.retain_time is '吞卡时间';
comment on column ${msl_schema}.msl_edw_atms_retain_card_table.account is '卡号';
comment on column ${msl_schema}.msl_edw_atms_retain_card_table.reason is '原因';
comment on column ${msl_schema}.msl_edw_atms_retain_card_table.period is '会计周期号';
comment on column ${msl_schema}.msl_edw_atms_retain_card_table.card_stuck_org is '吞卡机构';
comment on column ${msl_schema}.msl_edw_atms_retain_card_table.card_handle_org is '处理机构';
comment on column ${msl_schema}.msl_edw_atms_retain_card_table.auto_flag is '自动录入标志';
comment on column ${msl_schema}.msl_edw_atms_retain_card_table.check_op is '登记人';
comment on column ${msl_schema}.msl_edw_atms_retain_card_table.check_date is '登记日期';
comment on column ${msl_schema}.msl_edw_atms_retain_card_table.check_time is '登记时间';
comment on column ${msl_schema}.msl_edw_atms_retain_card_table.op_no is '处理人';
comment on column ${msl_schema}.msl_edw_atms_retain_card_table.op_date is '处理日期';
comment on column ${msl_schema}.msl_edw_atms_retain_card_table.op_time is '处理时间';
comment on column ${msl_schema}.msl_edw_atms_retain_card_table.op_address is '处理地点';
comment on column ${msl_schema}.msl_edw_atms_retain_card_table.account_name is '客户姓名';
comment on column ${msl_schema}.msl_edw_atms_retain_card_table.account_id is '客户证件号';
comment on column ${msl_schema}.msl_edw_atms_retain_card_table.account_phome is '客户电话';
comment on column ${msl_schema}.msl_edw_atms_retain_card_table.cert_type is '证件类型';
comment on column ${msl_schema}.msl_edw_atms_retain_card_table.status is '吞卡状态';
comment on column ${msl_schema}.msl_edw_atms_retain_card_table.start_dt is '开始时间';
comment on column ${msl_schema}.msl_edw_atms_retain_card_table.end_dt is '结束时间';
