/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_due_diligence_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_due_diligence_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_due_diligence_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_due_diligence_info(
    serialno varchar2(32) -- 主键
    ,diligenceno varchar2(32) -- 尽调流水号
    ,baserialno varchar2(32) -- 关联授信流水号
    ,customerid varchar2(16) -- 客户编码
    ,customername varchar2(200) -- 客户名称
    ,customertype varchar2(1) -- 客户类型
    ,officeaddress varchar2(300) -- 办公地点
    ,registeraddress varchar2(300) -- 注册地点
    ,belongdept varchar2(32) -- 所属条线
    ,imagebatchno varchar2(64) -- 影像批次号
    ,uploaduserid varchar2(64) -- 影像上传人id
    ,diligencedate date -- 尽调时间
    ,diligenceaddress varchar2(300) -- 尽调地点
    ,arriveuserid varchar2(250) -- 到场用户编码
    ,arriveusername varchar2(500) -- 到场用户名称
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
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
grant select on ${iol_schema}.icms_due_diligence_info to ${iml_schema};
grant select on ${iol_schema}.icms_due_diligence_info to ${icl_schema};
grant select on ${iol_schema}.icms_due_diligence_info to ${idl_schema};
grant select on ${iol_schema}.icms_due_diligence_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_due_diligence_info is '尽职调查表';
comment on column ${iol_schema}.icms_due_diligence_info.serialno is '主键';
comment on column ${iol_schema}.icms_due_diligence_info.diligenceno is '尽调流水号';
comment on column ${iol_schema}.icms_due_diligence_info.baserialno is '关联授信流水号';
comment on column ${iol_schema}.icms_due_diligence_info.customerid is '客户编码';
comment on column ${iol_schema}.icms_due_diligence_info.customername is '客户名称';
comment on column ${iol_schema}.icms_due_diligence_info.customertype is '客户类型';
comment on column ${iol_schema}.icms_due_diligence_info.officeaddress is '办公地点';
comment on column ${iol_schema}.icms_due_diligence_info.registeraddress is '注册地点';
comment on column ${iol_schema}.icms_due_diligence_info.belongdept is '所属条线';
comment on column ${iol_schema}.icms_due_diligence_info.imagebatchno is '影像批次号';
comment on column ${iol_schema}.icms_due_diligence_info.uploaduserid is '影像上传人id';
comment on column ${iol_schema}.icms_due_diligence_info.diligencedate is '尽调时间';
comment on column ${iol_schema}.icms_due_diligence_info.diligenceaddress is '尽调地点';
comment on column ${iol_schema}.icms_due_diligence_info.arriveuserid is '到场用户编码';
comment on column ${iol_schema}.icms_due_diligence_info.arriveusername is '到场用户名称';
comment on column ${iol_schema}.icms_due_diligence_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_due_diligence_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_due_diligence_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_due_diligence_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_due_diligence_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_due_diligence_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_due_diligence_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_due_diligence_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_due_diligence_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_due_diligence_info.etl_timestamp is 'ETL处理时间戳';
