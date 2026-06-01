/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_risk_warning_operate
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_risk_warning_operate
whenever sqlerror continue none;
drop table ${iol_schema}.icms_risk_warning_operate purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_risk_warning_operate(
    serialno varchar2(64) -- 流水号
    ,cusrisklevel varchar2(2) -- 客户风险等级
    ,noteopinion varchar2(1000) -- 客户经理意见
    ,describe varchar2(600) -- 备注
    ,operatetype varchar2(12) -- 操作类型
    ,riskmeasure varchar2(20) -- 风险控制措施
    ,approvestatus varchar2(10) -- 审批状态
    ,inputorgid varchar2(64) -- 登记机构
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,signserno varchar2(32) -- 风险预警编号
    ,customername varchar2(200) -- 客户名称
    ,inputuserid varchar2(64) -- 登记人
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,customerid varchar2(16) -- 客户编号
    ,inputdate date -- 登记日期
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
grant select on ${iol_schema}.icms_risk_warning_operate to ${iml_schema};
grant select on ${iol_schema}.icms_risk_warning_operate to ${icl_schema};
grant select on ${iol_schema}.icms_risk_warning_operate to ${idl_schema};
grant select on ${iol_schema}.icms_risk_warning_operate to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_risk_warning_operate is '风险预警信号处理表';
comment on column ${iol_schema}.icms_risk_warning_operate.serialno is '流水号';
comment on column ${iol_schema}.icms_risk_warning_operate.cusrisklevel is '客户风险等级';
comment on column ${iol_schema}.icms_risk_warning_operate.noteopinion is '客户经理意见';
comment on column ${iol_schema}.icms_risk_warning_operate.describe is '备注';
comment on column ${iol_schema}.icms_risk_warning_operate.operatetype is '操作类型';
comment on column ${iol_schema}.icms_risk_warning_operate.riskmeasure is '风险控制措施';
comment on column ${iol_schema}.icms_risk_warning_operate.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_risk_warning_operate.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_risk_warning_operate.updateuserid is '更新人';
comment on column ${iol_schema}.icms_risk_warning_operate.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_risk_warning_operate.updatedate is '更新日期';
comment on column ${iol_schema}.icms_risk_warning_operate.signserno is '风险预警编号';
comment on column ${iol_schema}.icms_risk_warning_operate.customername is '客户名称';
comment on column ${iol_schema}.icms_risk_warning_operate.inputuserid is '登记人';
comment on column ${iol_schema}.icms_risk_warning_operate.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_risk_warning_operate.customerid is '客户编号';
comment on column ${iol_schema}.icms_risk_warning_operate.inputdate is '登记日期';
comment on column ${iol_schema}.icms_risk_warning_operate.start_dt is '开始时间';
comment on column ${iol_schema}.icms_risk_warning_operate.end_dt is '结束时间';
comment on column ${iol_schema}.icms_risk_warning_operate.id_mark is '增删标志';
comment on column ${iol_schema}.icms_risk_warning_operate.etl_timestamp is 'ETL处理时间戳';
