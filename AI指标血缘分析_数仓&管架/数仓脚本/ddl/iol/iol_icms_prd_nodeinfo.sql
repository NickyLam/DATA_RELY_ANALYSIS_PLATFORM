/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_prd_nodeinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_prd_nodeinfo
whenever sqlerror continue none;
drop table ${iol_schema}.icms_prd_nodeinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_prd_nodeinfo(
    nodeid varchar2(64) -- 节点编号
    ,updateorgid varchar2(64) -- 更新机构
    ,inputdate date -- 登记日期
    ,nodename varchar2(400) -- 节点名称
    ,sortno varchar2(64) -- 序列号
    ,contracturl varchar2(2000) -- 合同阶段路径
    ,isinuse varchar2(2) -- 是否使用
    ,corporgid varchar2(64) -- 法人机构编号
    ,remark varchar2(2000) -- 备注
    ,inputorgid varchar2(64) -- 登记机构
    ,inputuserid varchar2(64) -- 登记人
    ,updatedate date -- 更新日期
    ,updateuserid varchar2(64) -- 更新人
    ,itemdescribe varchar2(2000) -- 节点描述
    ,approveurl varchar2(2000) -- 批复阶段路径
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
grant select on ${iol_schema}.icms_prd_nodeinfo to ${iml_schema};
grant select on ${iol_schema}.icms_prd_nodeinfo to ${icl_schema};
grant select on ${iol_schema}.icms_prd_nodeinfo to ${idl_schema};
grant select on ${iol_schema}.icms_prd_nodeinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_prd_nodeinfo is '产品节点';
comment on column ${iol_schema}.icms_prd_nodeinfo.nodeid is '节点编号';
comment on column ${iol_schema}.icms_prd_nodeinfo.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_prd_nodeinfo.inputdate is '登记日期';
comment on column ${iol_schema}.icms_prd_nodeinfo.nodename is '节点名称';
comment on column ${iol_schema}.icms_prd_nodeinfo.sortno is '序列号';
comment on column ${iol_schema}.icms_prd_nodeinfo.contracturl is '合同阶段路径';
comment on column ${iol_schema}.icms_prd_nodeinfo.isinuse is '是否使用';
comment on column ${iol_schema}.icms_prd_nodeinfo.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_prd_nodeinfo.remark is '备注';
comment on column ${iol_schema}.icms_prd_nodeinfo.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_prd_nodeinfo.inputuserid is '登记人';
comment on column ${iol_schema}.icms_prd_nodeinfo.updatedate is '更新日期';
comment on column ${iol_schema}.icms_prd_nodeinfo.updateuserid is '更新人';
comment on column ${iol_schema}.icms_prd_nodeinfo.itemdescribe is '节点描述';
comment on column ${iol_schema}.icms_prd_nodeinfo.approveurl is '批复阶段路径';
comment on column ${iol_schema}.icms_prd_nodeinfo.start_dt is '开始时间';
comment on column ${iol_schema}.icms_prd_nodeinfo.end_dt is '结束时间';
comment on column ${iol_schema}.icms_prd_nodeinfo.id_mark is '增删标志';
comment on column ${iol_schema}.icms_prd_nodeinfo.etl_timestamp is 'ETL处理时间戳';
