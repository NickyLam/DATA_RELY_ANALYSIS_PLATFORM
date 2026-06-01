/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_belong
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_belong
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_belong purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_belong(
    customerid varchar2(16) -- 客户编号
    ,belongorgid varchar2(32) -- 机构编号
    ,belonguserid varchar2(32) -- 员工编号
    ,editright varchar2(1) -- 信息维护权
    ,remark varchar2(500) -- 备注
    ,inputorgid varchar2(32) -- 登记机构
    ,inputuserid varchar2(32) -- 登记人
    ,viewright varchar2(1) -- 信息查看权
    ,updateuserid varchar2(32) -- 更新人
    ,corporgid varchar2(32) -- 法人机构编号
    ,businessright varchar2(1) -- 业务办理权
    ,inputdate date -- 登记日期
    ,businessright1 varchar2(2) -- 非标业务申办权
    ,manageright varchar2(1) -- 主办权
    ,updatedate date -- 更新日期
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,updateorgid varchar2(32) -- 更新机构
    ,migtoldvalue varchar2(250) -- 迁移数据-参数转换前字段值
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
grant select on ${iol_schema}.icms_customer_belong to ${iml_schema};
grant select on ${iol_schema}.icms_customer_belong to ${icl_schema};
grant select on ${iol_schema}.icms_customer_belong to ${idl_schema};
grant select on ${iol_schema}.icms_customer_belong to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_belong is '客户管辖权限信息表';
comment on column ${iol_schema}.icms_customer_belong.customerid is '客户编号';
comment on column ${iol_schema}.icms_customer_belong.belongorgid is '机构编号';
comment on column ${iol_schema}.icms_customer_belong.belonguserid is '员工编号';
comment on column ${iol_schema}.icms_customer_belong.editright is '信息维护权';
comment on column ${iol_schema}.icms_customer_belong.remark is '备注';
comment on column ${iol_schema}.icms_customer_belong.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_belong.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_belong.viewright is '信息查看权';
comment on column ${iol_schema}.icms_customer_belong.updateuserid is '更新人';
comment on column ${iol_schema}.icms_customer_belong.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_customer_belong.businessright is '业务办理权';
comment on column ${iol_schema}.icms_customer_belong.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_belong.businessright1 is '非标业务申办权';
comment on column ${iol_schema}.icms_customer_belong.manageright is '主办权';
comment on column ${iol_schema}.icms_customer_belong.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_belong.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_customer_belong.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_customer_belong.migtoldvalue is '迁移数据-参数转换前字段值';
comment on column ${iol_schema}.icms_customer_belong.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_belong.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_belong.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_belong.etl_timestamp is 'ETL处理时间戳';
