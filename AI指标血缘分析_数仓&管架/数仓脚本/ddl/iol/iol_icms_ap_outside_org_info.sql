/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_outside_org_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_outside_org_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_outside_org_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_outside_org_info(
    outsideorgno varchar2(64) -- 机构编号
    ,certtype varchar2(18) -- 证件类型
    ,inputorgid varchar2(64) -- 录入机构编号
    ,description varchar2(4000) -- 机构简介
    ,deleteflag varchar2(12) -- 删除标识
    ,updatedate date -- 更新日期
    ,updateuserid varchar2(64) -- 更新人
    ,outsideorgtype varchar2(2) -- 机构类型
    ,outsideorgname varchar2(160) -- 机构名称
    ,isuse varchar2(36) -- 使用状态
    ,orgcorptype varchar2(64) -- 组织机构证件类型
    ,inputuserid varchar2(64) -- 录入人编号
    ,orgcorpid varchar2(64) -- 组织机构代码证号
    ,address varchar2(400) -- 地址
    ,inputdate date -- 录入日期
    ,updateorgid varchar2(64) -- 更新机构
    ,certid varchar2(18) -- 证件编号
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
grant select on ${iol_schema}.icms_ap_outside_org_info to ${iml_schema};
grant select on ${iol_schema}.icms_ap_outside_org_info to ${icl_schema};
grant select on ${iol_schema}.icms_ap_outside_org_info to ${idl_schema};
grant select on ${iol_schema}.icms_ap_outside_org_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_outside_org_info is '外部机构信息表';
comment on column ${iol_schema}.icms_ap_outside_org_info.outsideorgno is '机构编号';
comment on column ${iol_schema}.icms_ap_outside_org_info.certtype is '证件类型';
comment on column ${iol_schema}.icms_ap_outside_org_info.inputorgid is '录入机构编号';
comment on column ${iol_schema}.icms_ap_outside_org_info.description is '机构简介';
comment on column ${iol_schema}.icms_ap_outside_org_info.deleteflag is '删除标识';
comment on column ${iol_schema}.icms_ap_outside_org_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_outside_org_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ap_outside_org_info.outsideorgtype is '机构类型';
comment on column ${iol_schema}.icms_ap_outside_org_info.outsideorgname is '机构名称';
comment on column ${iol_schema}.icms_ap_outside_org_info.isuse is '使用状态';
comment on column ${iol_schema}.icms_ap_outside_org_info.orgcorptype is '组织机构证件类型';
comment on column ${iol_schema}.icms_ap_outside_org_info.inputuserid is '录入人编号';
comment on column ${iol_schema}.icms_ap_outside_org_info.orgcorpid is '组织机构代码证号';
comment on column ${iol_schema}.icms_ap_outside_org_info.address is '地址';
comment on column ${iol_schema}.icms_ap_outside_org_info.inputdate is '录入日期';
comment on column ${iol_schema}.icms_ap_outside_org_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ap_outside_org_info.certid is '证件编号';
comment on column ${iol_schema}.icms_ap_outside_org_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_outside_org_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_outside_org_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_outside_org_info.etl_timestamp is 'ETL处理时间戳';
