/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icms_flow_object
CreateDate: 20250509
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.icms_flow_object purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.icms_flow_object(
etl_dt date --数据日期
,objecttype varchar2(64) --流程对象任务类型
,objectno varchar2(64) --流程对象编号
,userid varchar2(64) --登记人编号
,relativetaskno varchar2(64) --关联流程对象流水号
,flowname varchar2(160) --流程模型名称
,orgname varchar2(160) --评估单位
,processinstno varchar2(64) --流程实例编号
,phasename varchar2(160) --当前阶段名称
,objattribute2 varchar2(400) --流程属性2
,applyno varchar2(64) --申请编号
,baseflowno varchar2(64) --流程号
,flowno varchar2(64) --流程模型编号
,objattribute5 varchar2(400) --流程属性5
,archivetime date --归档时刻
,objattribute4 varchar2(400) --流程属性4
,username varchar2(160) --登记人名称
,orgid varchar2(64) --登记机构号
,objattribute1 varchar2(400) --流程属性1
,objattribute3 varchar2(400) --流程属性3
,flowstate varchar2(400) --流程状态
,processtaskno varchar2(64) --流程任务编号
,serialno varchar2(64) --流程对象流水号
,phaseno varchar2(64) --当前阶段编号
,objdescribe varchar2(1000) --流程描述
,applytype varchar2(64) --申请类型
,tasktype varchar2(64) --任务类型
,migtflag varchar2(80) --迁移标志：crs rcr ilc upl
,phasetype varchar2(64) --当前阶段类型
,archive varchar2(12) --归档标识
,version varchar2(64) --版本
,inputdate date --登记日期

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icms_flow_object to ${iel_schema};

-- comment
comment on table ${idl_schema}.icms_flow_object is '流程对象表';
comment on column ${idl_schema}.icms_flow_object.etl_dt is '数据日期';
comment on column ${idl_schema}.icms_flow_object.objecttype is '流程对象任务类型';
comment on column ${idl_schema}.icms_flow_object.objectno is '流程对象编号';
comment on column ${idl_schema}.icms_flow_object.userid is '登记人编号';
comment on column ${idl_schema}.icms_flow_object.relativetaskno is '关联流程对象流水号';
comment on column ${idl_schema}.icms_flow_object.flowname is '流程模型名称';
comment on column ${idl_schema}.icms_flow_object.orgname is '评估单位';
comment on column ${idl_schema}.icms_flow_object.processinstno is '流程实例编号';
comment on column ${idl_schema}.icms_flow_object.phasename is '当前阶段名称';
comment on column ${idl_schema}.icms_flow_object.objattribute2 is '流程属性2';
comment on column ${idl_schema}.icms_flow_object.applyno is '申请编号';
comment on column ${idl_schema}.icms_flow_object.baseflowno is '流程号';
comment on column ${idl_schema}.icms_flow_object.flowno is '流程模型编号';
comment on column ${idl_schema}.icms_flow_object.objattribute5 is '流程属性5';
comment on column ${idl_schema}.icms_flow_object.archivetime is '归档时刻';
comment on column ${idl_schema}.icms_flow_object.objattribute4 is '流程属性4';
comment on column ${idl_schema}.icms_flow_object.username is '登记人名称';
comment on column ${idl_schema}.icms_flow_object.orgid is '登记机构号';
comment on column ${idl_schema}.icms_flow_object.objattribute1 is '流程属性1';
comment on column ${idl_schema}.icms_flow_object.objattribute3 is '流程属性3';
comment on column ${idl_schema}.icms_flow_object.flowstate is '流程状态';
comment on column ${idl_schema}.icms_flow_object.processtaskno is '流程任务编号';
comment on column ${idl_schema}.icms_flow_object.serialno is '流程对象流水号';
comment on column ${idl_schema}.icms_flow_object.phaseno is '当前阶段编号';
comment on column ${idl_schema}.icms_flow_object.objdescribe is '流程描述';
comment on column ${idl_schema}.icms_flow_object.applytype is '申请类型';
comment on column ${idl_schema}.icms_flow_object.tasktype is '任务类型';
comment on column ${idl_schema}.icms_flow_object.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${idl_schema}.icms_flow_object.phasetype is '当前阶段类型';
comment on column ${idl_schema}.icms_flow_object.archive is '归档标识';
comment on column ${idl_schema}.icms_flow_object.version is '版本';
comment on column ${idl_schema}.icms_flow_object.inputdate is '登记日期';

