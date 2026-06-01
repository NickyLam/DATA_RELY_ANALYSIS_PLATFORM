/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_aml_evaluate_manual_approve
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_aml_evaluate_manual_approve
whenever sqlerror continue none;
drop table ${iol_schema}.icms_aml_evaluate_manual_approve purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_aml_evaluate_manual_approve(
    serialno varchar2(32) -- 流水号
    ,objectno varchar2(32) -- 业务流水号
    ,objecttype varchar2(32) -- 业务类型
    ,flowtaskserialno varchar2(32) -- 业务申请阶段
    ,customerid varchar2(16) -- 客户编号
    ,customername varchar2(200) -- 客户名称
    ,productid varchar2(32) -- 产品编号
    ,manualapprovaldescribe varchar2(2000) -- 人工审批说明
    ,processstatus varchar2(2) -- 处理状态
    ,processreason varchar2(2000) -- 处理原因
    ,addsource varchar2(2) -- 新增方式
    ,completeflag varchar2(1) -- 信息完成状态
    ,approvestatus varchar2(64) -- 审批状态
    ,operateuserid varchar2(64) -- 经办人
    ,operateorgid varchar2(64) -- 经办机构
    ,inputuserid varchar2(64) -- 录入人
    ,inputorgid varchar2(64) -- 录入机构
    ,inputdate date -- 录入日期
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
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
grant select on ${iol_schema}.icms_aml_evaluate_manual_approve to ${iml_schema};
grant select on ${iol_schema}.icms_aml_evaluate_manual_approve to ${icl_schema};
grant select on ${iol_schema}.icms_aml_evaluate_manual_approve to ${idl_schema};
grant select on ${iol_schema}.icms_aml_evaluate_manual_approve to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_aml_evaluate_manual_approve is '反洗钱评级人工审批表';
comment on column ${iol_schema}.icms_aml_evaluate_manual_approve.serialno is '流水号';
comment on column ${iol_schema}.icms_aml_evaluate_manual_approve.objectno is '业务流水号';
comment on column ${iol_schema}.icms_aml_evaluate_manual_approve.objecttype is '业务类型';
comment on column ${iol_schema}.icms_aml_evaluate_manual_approve.flowtaskserialno is '业务申请阶段';
comment on column ${iol_schema}.icms_aml_evaluate_manual_approve.customerid is '客户编号';
comment on column ${iol_schema}.icms_aml_evaluate_manual_approve.customername is '客户名称';
comment on column ${iol_schema}.icms_aml_evaluate_manual_approve.productid is '产品编号';
comment on column ${iol_schema}.icms_aml_evaluate_manual_approve.manualapprovaldescribe is '人工审批说明';
comment on column ${iol_schema}.icms_aml_evaluate_manual_approve.processstatus is '处理状态';
comment on column ${iol_schema}.icms_aml_evaluate_manual_approve.processreason is '处理原因';
comment on column ${iol_schema}.icms_aml_evaluate_manual_approve.addsource is '新增方式';
comment on column ${iol_schema}.icms_aml_evaluate_manual_approve.completeflag is '信息完成状态';
comment on column ${iol_schema}.icms_aml_evaluate_manual_approve.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_aml_evaluate_manual_approve.operateuserid is '经办人';
comment on column ${iol_schema}.icms_aml_evaluate_manual_approve.operateorgid is '经办机构';
comment on column ${iol_schema}.icms_aml_evaluate_manual_approve.inputuserid is '录入人';
comment on column ${iol_schema}.icms_aml_evaluate_manual_approve.inputorgid is '录入机构';
comment on column ${iol_schema}.icms_aml_evaluate_manual_approve.inputdate is '录入日期';
comment on column ${iol_schema}.icms_aml_evaluate_manual_approve.updateuserid is '更新人';
comment on column ${iol_schema}.icms_aml_evaluate_manual_approve.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_aml_evaluate_manual_approve.updatedate is '更新日期';
comment on column ${iol_schema}.icms_aml_evaluate_manual_approve.start_dt is '开始时间';
comment on column ${iol_schema}.icms_aml_evaluate_manual_approve.end_dt is '结束时间';
comment on column ${iol_schema}.icms_aml_evaluate_manual_approve.id_mark is '增删标志';
comment on column ${iol_schema}.icms_aml_evaluate_manual_approve.etl_timestamp is 'ETL处理时间戳';
