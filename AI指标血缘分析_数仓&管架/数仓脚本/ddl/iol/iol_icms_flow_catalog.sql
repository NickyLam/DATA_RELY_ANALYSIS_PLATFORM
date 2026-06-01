/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_flow_catalog
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_flow_catalog
whenever sqlerror continue none;
drop table ${iol_schema}.icms_flow_catalog purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_flow_catalog(
    flowno varchar2(48) -- 流程编号
    ,version varchar2(18) -- 版本
    ,grouptitles varchar2(2000) -- 流程图分组标题
    ,viewfile varchar2(2000) -- 流程图文件
    ,inputorgid varchar2(32) -- 登记机构
    ,isinuse varchar2(6) -- 是否有效
    ,updateuserid varchar2(32) -- 更新人
    ,viewfilelength number(22) -- 流程图描述长度
    ,flowtype varchar2(32) -- 流程类型
    ,baseflowname varchar2(80) -- 基础流程名称
    ,corporgid varchar2(100) -- 法人机构编号
    ,flowname varchar2(80) -- 流程名称
    ,flowdescribe varchar2(500) -- 流程描述
    ,flowbuttonset varchar2(32) -- 流程按钮组，若流程没有关联的申请或审批类型，则使用此按钮组编号
    ,inputuserid varchar2(32) -- 登记人
    ,updateorgid varchar2(32) -- 更新机构
    ,updatedate date -- 更新日期
    ,baseflowno varchar2(32) -- 流程号
    ,aaenabled varchar2(6) -- 是否启用授权系统
    ,metaflowno varchar2(32) -- 元版本号
    ,inputdate date -- 登记日期
    ,initphase varchar2(500) -- 初始阶段
    ,aapolicy varchar2(32) -- 授权方案
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_flow_catalog to ${iml_schema};
grant select on ${iol_schema}.icms_flow_catalog to ${icl_schema};
grant select on ${iol_schema}.icms_flow_catalog to ${idl_schema};
grant select on ${iol_schema}.icms_flow_catalog to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_flow_catalog is '流程表';
comment on column ${iol_schema}.icms_flow_catalog.flowno is '流程编号';
comment on column ${iol_schema}.icms_flow_catalog.version is '版本';
comment on column ${iol_schema}.icms_flow_catalog.grouptitles is '流程图分组标题';
comment on column ${iol_schema}.icms_flow_catalog.viewfile is '流程图文件';
comment on column ${iol_schema}.icms_flow_catalog.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_flow_catalog.isinuse is '是否有效';
comment on column ${iol_schema}.icms_flow_catalog.updateuserid is '更新人';
comment on column ${iol_schema}.icms_flow_catalog.viewfilelength is '流程图描述长度';
comment on column ${iol_schema}.icms_flow_catalog.flowtype is '流程类型';
comment on column ${iol_schema}.icms_flow_catalog.baseflowname is '基础流程名称';
comment on column ${iol_schema}.icms_flow_catalog.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_flow_catalog.flowname is '流程名称';
comment on column ${iol_schema}.icms_flow_catalog.flowdescribe is '流程描述';
comment on column ${iol_schema}.icms_flow_catalog.flowbuttonset is '流程按钮组，若流程没有关联的申请或审批类型，则使用此按钮组编号';
comment on column ${iol_schema}.icms_flow_catalog.inputuserid is '登记人';
comment on column ${iol_schema}.icms_flow_catalog.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_flow_catalog.updatedate is '更新日期';
comment on column ${iol_schema}.icms_flow_catalog.baseflowno is '流程号';
comment on column ${iol_schema}.icms_flow_catalog.aaenabled is '是否启用授权系统';
comment on column ${iol_schema}.icms_flow_catalog.metaflowno is '元版本号';
comment on column ${iol_schema}.icms_flow_catalog.inputdate is '登记日期';
comment on column ${iol_schema}.icms_flow_catalog.initphase is '初始阶段';
comment on column ${iol_schema}.icms_flow_catalog.aapolicy is '授权方案';
comment on column ${iol_schema}.icms_flow_catalog.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_flow_catalog.etl_timestamp is 'ETL处理时间戳';
