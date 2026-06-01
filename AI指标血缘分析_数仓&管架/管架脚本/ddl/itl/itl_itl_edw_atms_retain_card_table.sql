/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_atms_retain_card_table
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_atms_retain_card_table
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_atms_retain_card_table purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_atms_retain_card_table(
    etl_dt date -- 数据日期
    ,logic_id varchar2(36) -- 编号
    ,dev_no varchar2(20) -- 设备号
    ,retain_date varchar2(10) -- 吞卡日期
    ,retain_time varchar2(10) -- 吞卡时间
    ,account varchar2(25) -- 卡号
    ,reason varchar2(200) -- 原因
    ,period varchar2(10) -- 会计周期号
    ,card_stuck_org varchar2(20) -- 吞卡机构
    ,card_handle_org varchar2(20) -- 处理机构
    ,auto_flag varchar2(1) -- 自动录入标志
    ,check_op varchar2(20) -- 登记人
    ,check_date varchar2(10) -- 登记日期
    ,check_time varchar2(10) -- 登记时间
    ,op_no varchar2(20) -- 处理人
    ,op_date varchar2(10) -- 处理日期
    ,op_time varchar2(10) -- 处理时间
    ,op_address varchar2(80) -- 处理地点
    ,account_name varchar2(20) -- 客户姓名
    ,account_id varchar2(20) -- 客户证件号
    ,account_phome varchar2(15) -- 客户电话
    ,cert_type varchar2(1) -- 证件类型
    ,status varchar2(2) -- 吞卡状态
    ,etl_timestamp timestamp -- ETL处理时间戳
   -- ,job_cd varchar2(10) -- 任务编码
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_atms_retain_card_table to ${iel_schema};

-- comment
comment on table ${itl_schema}.itl_edw_atms_retain_card_table is '吞卡信息表';
comment on column ${itl_schema}.itl_edw_atms_retain_card_table.etl_dt is '数据日期';
comment on column ${itl_schema}.itl_edw_atms_retain_card_table.logic_id is '编号';
comment on column ${itl_schema}.itl_edw_atms_retain_card_table.dev_no is '设备号';
comment on column ${itl_schema}.itl_edw_atms_retain_card_table.retain_date is '吞卡日期';
comment on column ${itl_schema}.itl_edw_atms_retain_card_table.retain_time is '吞卡时间';
comment on column ${itl_schema}.itl_edw_atms_retain_card_table.account is '卡号';
comment on column ${itl_schema}.itl_edw_atms_retain_card_table.reason is '原因';
comment on column ${itl_schema}.itl_edw_atms_retain_card_table.period is '会计周期号';
comment on column ${itl_schema}.itl_edw_atms_retain_card_table.card_stuck_org is '吞卡机构';
comment on column ${itl_schema}.itl_edw_atms_retain_card_table.card_handle_org is '处理机构';
comment on column ${itl_schema}.itl_edw_atms_retain_card_table.auto_flag is '自动录入标志';
comment on column ${itl_schema}.itl_edw_atms_retain_card_table.check_op is '登记人';
comment on column ${itl_schema}.itl_edw_atms_retain_card_table.check_date is '登记日期';
comment on column ${itl_schema}.itl_edw_atms_retain_card_table.check_time is '登记时间';
comment on column ${itl_schema}.itl_edw_atms_retain_card_table.op_no is '处理人';
comment on column ${itl_schema}.itl_edw_atms_retain_card_table.op_date is '处理日期';
comment on column ${itl_schema}.itl_edw_atms_retain_card_table.op_time is '处理时间';
comment on column ${itl_schema}.itl_edw_atms_retain_card_table.op_address is '处理地点';
comment on column ${itl_schema}.itl_edw_atms_retain_card_table.account_name is '客户姓名';
comment on column ${itl_schema}.itl_edw_atms_retain_card_table.account_id is '客户证件号';
comment on column ${itl_schema}.itl_edw_atms_retain_card_table.account_phome is '客户电话';
comment on column ${itl_schema}.itl_edw_atms_retain_card_table.cert_type is '证件类型';
comment on column ${itl_schema}.itl_edw_atms_retain_card_table.status is '吞卡状态';
comment on column ${itl_schema}.itl_edw_atms_retain_card_table.etl_timestamp is 'ETL处理时间戳';