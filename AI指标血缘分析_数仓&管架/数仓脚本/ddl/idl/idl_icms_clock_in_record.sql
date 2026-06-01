/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icms_clock_in_record
CreateDate: 20250509
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.icms_clock_in_record purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.icms_clock_in_record(
etl_dt date --数据日期
,serialno varchar2(64) --流水号
,opttype varchar2(10) --操作类型
,clockintype varchar2(20) --打卡类型
,ptytype varchar2(32) --客户类型
,ptyname varchar2(100) --客户姓名
,cellphonenum varchar2(20) --手机号
,loaninteamt number(24,6) --贷款意向金额(元)
,wthrcancel varchar2(10) --是否作废
,cancelreason varchar2(200) --作废原因
,ptymanagerid varchar2(32) --客户经理编号
,ptymanagername varchar2(100) --客户经理姓名
,taskstatus varchar2(10) --任务状态
,inputuserid varchar2(32) --登记人
,inputorgid varchar2(32) --登记机构
,inputdate date --登记日期
,updateuserid varchar2(32) --更新人
,updateorgid varchar2(32) --更新机构
,updatedate date --更新日期
,finishtime date --完成时间

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icms_clock_in_record to ${iel_schema};

-- comment
comment on table ${idl_schema}.icms_clock_in_record is '打卡记录表';
comment on column ${idl_schema}.icms_clock_in_record.etl_dt is '数据日期';
comment on column ${idl_schema}.icms_clock_in_record.serialno is '流水号';
comment on column ${idl_schema}.icms_clock_in_record.opttype is '操作类型';
comment on column ${idl_schema}.icms_clock_in_record.clockintype is '打卡类型';
comment on column ${idl_schema}.icms_clock_in_record.ptytype is '客户类型';
comment on column ${idl_schema}.icms_clock_in_record.ptyname is '客户姓名';
comment on column ${idl_schema}.icms_clock_in_record.cellphonenum is '手机号';
comment on column ${idl_schema}.icms_clock_in_record.loaninteamt is '贷款意向金额(元)';
comment on column ${idl_schema}.icms_clock_in_record.wthrcancel is '是否作废';
comment on column ${idl_schema}.icms_clock_in_record.cancelreason is '作废原因';
comment on column ${idl_schema}.icms_clock_in_record.ptymanagerid is '客户经理编号';
comment on column ${idl_schema}.icms_clock_in_record.ptymanagername is '客户经理姓名';
comment on column ${idl_schema}.icms_clock_in_record.taskstatus is '任务状态';
comment on column ${idl_schema}.icms_clock_in_record.inputuserid is '登记人';
comment on column ${idl_schema}.icms_clock_in_record.inputorgid is '登记机构';
comment on column ${idl_schema}.icms_clock_in_record.inputdate is '登记日期';
comment on column ${idl_schema}.icms_clock_in_record.updateuserid is '更新人';
comment on column ${idl_schema}.icms_clock_in_record.updateorgid is '更新机构';
comment on column ${idl_schema}.icms_clock_in_record.updatedate is '更新日期';
comment on column ${idl_schema}.icms_clock_in_record.finishtime is '完成时间';

