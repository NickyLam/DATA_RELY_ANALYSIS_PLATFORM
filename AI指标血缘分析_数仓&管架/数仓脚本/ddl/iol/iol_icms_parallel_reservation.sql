/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_parallel_reservation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_parallel_reservation
whenever sqlerror continue none;
drop table ${iol_schema}.icms_parallel_reservation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_parallel_reservation(
    serialno varchar2(32) -- 流水号
    ,baserialno varchar2(32) -- 关联授信流水号
    ,customerid varchar2(32) -- 客户id
    ,customername varchar2(100) -- 客户名称
    ,reservationdate date -- 预约作业时间
    ,reservationplace varchar2(400) -- 预约作业地点
    ,approvedate date -- 审批作业时间
    ,remark varchar2(4000) -- 备注
    ,actualdate date -- 客户经理签到时间
    ,actualplace varchar2(400) -- 客户经理签到地点
    ,reportstatus varchar2(20) -- 报告状态
    ,actualdistance varchar2(100) -- 客户经理签到地址与注册地距离
    ,situationremark varchar2(4000) -- 客户经理现场情况说明
    ,approvestatus varchar2(20) -- 流程状态
    ,imageserialno varchar2(64) -- 影像流水号
    ,riskmanagerid varchar2(100) -- 风险经理id
    ,inputuserid varchar2(100) -- 登记人
    ,inputorgid varchar2(100) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(100) -- 更新人
    ,updateorgid varchar2(100) -- 更新机构
    ,updatedate date -- 更新日期
    ,riskactualdate date -- 风险经理签到时间
    ,riskactualplace varchar2(400) -- 风险经理签到地点
    ,riskactualdistance varchar2(100) -- 风险经理签到地址与注册地距离
    ,risksituationremark varchar2(4000) -- 风险经理现场情况说明
    ,issignin varchar2(1) -- 客户经理是否签到
    ,isrisksignin varchar2(1) -- 风险经理是否签到
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
grant select on ${iol_schema}.icms_parallel_reservation to ${iml_schema};
grant select on ${iol_schema}.icms_parallel_reservation to ${icl_schema};
grant select on ${iol_schema}.icms_parallel_reservation to ${idl_schema};
grant select on ${iol_schema}.icms_parallel_reservation to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_parallel_reservation is '平行作业预约表';
comment on column ${iol_schema}.icms_parallel_reservation.serialno is '流水号';
comment on column ${iol_schema}.icms_parallel_reservation.baserialno is '关联授信流水号';
comment on column ${iol_schema}.icms_parallel_reservation.customerid is '客户id';
comment on column ${iol_schema}.icms_parallel_reservation.customername is '客户名称';
comment on column ${iol_schema}.icms_parallel_reservation.reservationdate is '预约作业时间';
comment on column ${iol_schema}.icms_parallel_reservation.reservationplace is '预约作业地点';
comment on column ${iol_schema}.icms_parallel_reservation.approvedate is '审批作业时间';
comment on column ${iol_schema}.icms_parallel_reservation.remark is '备注';
comment on column ${iol_schema}.icms_parallel_reservation.actualdate is '客户经理签到时间';
comment on column ${iol_schema}.icms_parallel_reservation.actualplace is '客户经理签到地点';
comment on column ${iol_schema}.icms_parallel_reservation.reportstatus is '报告状态';
comment on column ${iol_schema}.icms_parallel_reservation.actualdistance is '客户经理签到地址与注册地距离';
comment on column ${iol_schema}.icms_parallel_reservation.situationremark is '客户经理现场情况说明';
comment on column ${iol_schema}.icms_parallel_reservation.approvestatus is '流程状态';
comment on column ${iol_schema}.icms_parallel_reservation.imageserialno is '影像流水号';
comment on column ${iol_schema}.icms_parallel_reservation.riskmanagerid is '风险经理id';
comment on column ${iol_schema}.icms_parallel_reservation.inputuserid is '登记人';
comment on column ${iol_schema}.icms_parallel_reservation.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_parallel_reservation.inputdate is '登记日期';
comment on column ${iol_schema}.icms_parallel_reservation.updateuserid is '更新人';
comment on column ${iol_schema}.icms_parallel_reservation.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_parallel_reservation.updatedate is '更新日期';
comment on column ${iol_schema}.icms_parallel_reservation.riskactualdate is '风险经理签到时间';
comment on column ${iol_schema}.icms_parallel_reservation.riskactualplace is '风险经理签到地点';
comment on column ${iol_schema}.icms_parallel_reservation.riskactualdistance is '风险经理签到地址与注册地距离';
comment on column ${iol_schema}.icms_parallel_reservation.risksituationremark is '风险经理现场情况说明';
comment on column ${iol_schema}.icms_parallel_reservation.issignin is '客户经理是否签到';
comment on column ${iol_schema}.icms_parallel_reservation.isrisksignin is '风险经理是否签到';
comment on column ${iol_schema}.icms_parallel_reservation.start_dt is '开始时间';
comment on column ${iol_schema}.icms_parallel_reservation.end_dt is '结束时间';
comment on column ${iol_schema}.icms_parallel_reservation.id_mark is '增删标志';
comment on column ${iol_schema}.icms_parallel_reservation.etl_timestamp is 'ETL处理时间戳';
