/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_prd_nodeconfig
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_prd_nodeconfig
whenever sqlerror continue none;
drop table ${iol_schema}.icms_prd_nodeconfig purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_prd_nodeconfig(
    productid varchar2(64) -- 项目编号
    ,nodeid varchar2(64) -- 节点编号
    ,inputdate date -- 登记日期
    ,sortno varchar2(64) -- 排序后
    ,putoutphase varchar2(64) -- 放款阶段
    ,inputuserid varchar2(64) -- 登记人
    ,fac5 varchar2(64) -- FAC5
    ,approvephase varchar2(64) -- 批复阶段
    ,updateorgid varchar2(64) -- 更新机构
    ,updateuserid varchar2(64) -- 更新人
    ,updatedate date -- 更新日期
    ,inputorgid varchar2(64) -- 登记机构
    ,nodename varchar2(64) -- 节点名称
    ,contractphase varchar2(64) -- 合同阶段
    ,corporgid varchar2(64) -- 法人机构编号
    ,applyphase varchar2(64) -- 申请阶段
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
grant select on ${iol_schema}.icms_prd_nodeconfig to ${iml_schema};
grant select on ${iol_schema}.icms_prd_nodeconfig to ${icl_schema};
grant select on ${iol_schema}.icms_prd_nodeconfig to ${idl_schema};
grant select on ${iol_schema}.icms_prd_nodeconfig to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_prd_nodeconfig is '节点配置';
comment on column ${iol_schema}.icms_prd_nodeconfig.productid is '项目编号';
comment on column ${iol_schema}.icms_prd_nodeconfig.nodeid is '节点编号';
comment on column ${iol_schema}.icms_prd_nodeconfig.inputdate is '登记日期';
comment on column ${iol_schema}.icms_prd_nodeconfig.sortno is '排序后';
comment on column ${iol_schema}.icms_prd_nodeconfig.putoutphase is '放款阶段';
comment on column ${iol_schema}.icms_prd_nodeconfig.inputuserid is '登记人';
comment on column ${iol_schema}.icms_prd_nodeconfig.fac5 is 'FAC5';
comment on column ${iol_schema}.icms_prd_nodeconfig.approvephase is '批复阶段';
comment on column ${iol_schema}.icms_prd_nodeconfig.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_prd_nodeconfig.updateuserid is '更新人';
comment on column ${iol_schema}.icms_prd_nodeconfig.updatedate is '更新日期';
comment on column ${iol_schema}.icms_prd_nodeconfig.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_prd_nodeconfig.nodename is '节点名称';
comment on column ${iol_schema}.icms_prd_nodeconfig.contractphase is '合同阶段';
comment on column ${iol_schema}.icms_prd_nodeconfig.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_prd_nodeconfig.applyphase is '申请阶段';
comment on column ${iol_schema}.icms_prd_nodeconfig.start_dt is '开始时间';
comment on column ${iol_schema}.icms_prd_nodeconfig.end_dt is '结束时间';
comment on column ${iol_schema}.icms_prd_nodeconfig.id_mark is '增删标志';
comment on column ${iol_schema}.icms_prd_nodeconfig.etl_timestamp is 'ETL处理时间戳';
