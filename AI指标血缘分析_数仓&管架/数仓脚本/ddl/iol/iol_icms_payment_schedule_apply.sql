/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_payment_schedule_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_payment_schedule_apply
whenever sqlerror continue none;
drop table ${iol_schema}.icms_payment_schedule_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_payment_schedule_apply(
    serialno varchar2(32) -- 流水号
    ,inputorgid varchar2(12) -- 登记机构
    ,operatedate date -- 经办日期
    ,inputuserid varchar2(8) -- 登记人
    ,migtflag varchar2(80) -- 
    ,operateuserid varchar2(8) -- 经办人
    ,putoutno varchar2(32) -- 出账号
    ,approveserialno varchar2(32) -- 关联授信条件变更的批复流水号
    ,extensionserialno varchar2(32) -- 关联展期申请流水号
    ,inputdate date -- 申请日期
    ,operateorgid varchar2(12) -- 经办机构
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
grant select on ${iol_schema}.icms_payment_schedule_apply to ${iml_schema};
grant select on ${iol_schema}.icms_payment_schedule_apply to ${icl_schema};
grant select on ${iol_schema}.icms_payment_schedule_apply to ${idl_schema};
grant select on ${iol_schema}.icms_payment_schedule_apply to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_payment_schedule_apply is '还款计划变更申请';
comment on column ${iol_schema}.icms_payment_schedule_apply.serialno is '流水号';
comment on column ${iol_schema}.icms_payment_schedule_apply.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_payment_schedule_apply.operatedate is '经办日期';
comment on column ${iol_schema}.icms_payment_schedule_apply.inputuserid is '登记人';
comment on column ${iol_schema}.icms_payment_schedule_apply.migtflag is '';
comment on column ${iol_schema}.icms_payment_schedule_apply.operateuserid is '经办人';
comment on column ${iol_schema}.icms_payment_schedule_apply.putoutno is '出账号';
comment on column ${iol_schema}.icms_payment_schedule_apply.approveserialno is '关联授信条件变更的批复流水号';
comment on column ${iol_schema}.icms_payment_schedule_apply.extensionserialno is '关联展期申请流水号';
comment on column ${iol_schema}.icms_payment_schedule_apply.inputdate is '申请日期';
comment on column ${iol_schema}.icms_payment_schedule_apply.operateorgid is '经办机构';
comment on column ${iol_schema}.icms_payment_schedule_apply.start_dt is '开始时间';
comment on column ${iol_schema}.icms_payment_schedule_apply.end_dt is '结束时间';
comment on column ${iol_schema}.icms_payment_schedule_apply.id_mark is '增删标志';
comment on column ${iol_schema}.icms_payment_schedule_apply.etl_timestamp is 'ETL处理时间戳';
