/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_recovery_service
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_recovery_service
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_recovery_service purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_recovery_service(
    serviceno varchar2(64) -- 记录编号
    ,inputorgid varchar2(64) -- 登记机构
    ,updatedate varchar2(64) -- 更新日期
    ,deleteflag varchar2(12) -- 删除标志
    ,remark varchar2(1000) -- 备注
    ,planno varchar2(64) -- 处置内容编号
    ,firstparty varchar2(160) -- 甲方
    ,protocolnumber varchar2(64) -- 协议编号
    ,signdate varchar2(64) -- 签约日期
    ,toobject varchar2(1000) -- 签约对象
    ,updateorgid varchar2(64) -- 更新机构
    ,fileno varchar2(64) -- 影像平台编号
    ,programno varchar2(64) -- 方案编号
    ,serviceprotocol varchar2(2000) -- 清收服务协议上传
    ,tmsp varchar2(64) -- 时间戳
    ,servicematurity varchar2(400) -- 清收服务期限
    ,inputdate varchar2(64) -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,serviceexpenses number(24,6) -- 服务费用
    ,serviceinfo varchar2(2000) -- 清收服务协议主要内容
    ,inputuserid varchar2(64) -- 登记人
    ,secondparty varchar2(160) -- 乙方
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
grant select on ${iol_schema}.icms_ap_recovery_service to ${iml_schema};
grant select on ${iol_schema}.icms_ap_recovery_service to ${icl_schema};
grant select on ${iol_schema}.icms_ap_recovery_service to ${idl_schema};
grant select on ${iol_schema}.icms_ap_recovery_service to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_recovery_service is '清收服务协议表';
comment on column ${iol_schema}.icms_ap_recovery_service.serviceno is '记录编号';
comment on column ${iol_schema}.icms_ap_recovery_service.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ap_recovery_service.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_recovery_service.deleteflag is '删除标志';
comment on column ${iol_schema}.icms_ap_recovery_service.remark is '备注';
comment on column ${iol_schema}.icms_ap_recovery_service.planno is '处置内容编号';
comment on column ${iol_schema}.icms_ap_recovery_service.firstparty is '甲方';
comment on column ${iol_schema}.icms_ap_recovery_service.protocolnumber is '协议编号';
comment on column ${iol_schema}.icms_ap_recovery_service.signdate is '签约日期';
comment on column ${iol_schema}.icms_ap_recovery_service.toobject is '签约对象';
comment on column ${iol_schema}.icms_ap_recovery_service.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ap_recovery_service.fileno is '影像平台编号';
comment on column ${iol_schema}.icms_ap_recovery_service.programno is '方案编号';
comment on column ${iol_schema}.icms_ap_recovery_service.serviceprotocol is '清收服务协议上传';
comment on column ${iol_schema}.icms_ap_recovery_service.tmsp is '时间戳';
comment on column ${iol_schema}.icms_ap_recovery_service.servicematurity is '清收服务期限';
comment on column ${iol_schema}.icms_ap_recovery_service.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_recovery_service.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ap_recovery_service.serviceexpenses is '服务费用';
comment on column ${iol_schema}.icms_ap_recovery_service.serviceinfo is '清收服务协议主要内容';
comment on column ${iol_schema}.icms_ap_recovery_service.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ap_recovery_service.secondparty is '乙方';
comment on column ${iol_schema}.icms_ap_recovery_service.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_recovery_service.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_recovery_service.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_recovery_service.etl_timestamp is 'ETL处理时间戳';
