/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_org_belong
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_org_belong
whenever sqlerror continue none;
drop table ${iol_schema}.icms_org_belong purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_org_belong(
    orgid varchar2(64) -- 机构编号
    ,managetype varchar2(12) -- 管辖类型
    ,belongorgid varchar2(64) -- 所属机构编号
    ,updateuserid varchar2(64) -- 更新人
    ,inputorgid varchar2(64) -- 登记机构
    ,updateorgid varchar2(64) -- 更新机构
    ,inputuserid varchar2(64) -- 登记人
    ,updatedate date -- 更新日期
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
grant select on ${iol_schema}.icms_org_belong to ${iml_schema};
grant select on ${iol_schema}.icms_org_belong to ${icl_schema};
grant select on ${iol_schema}.icms_org_belong to ${idl_schema};
grant select on ${iol_schema}.icms_org_belong to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_org_belong is '机构管辖表机构管辖信息';
comment on column ${iol_schema}.icms_org_belong.orgid is '机构编号';
comment on column ${iol_schema}.icms_org_belong.managetype is '管辖类型';
comment on column ${iol_schema}.icms_org_belong.belongorgid is '所属机构编号';
comment on column ${iol_schema}.icms_org_belong.updateuserid is '更新人';
comment on column ${iol_schema}.icms_org_belong.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_org_belong.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_org_belong.inputuserid is '登记人';
comment on column ${iol_schema}.icms_org_belong.updatedate is '更新日期';
comment on column ${iol_schema}.icms_org_belong.inputdate is '登记日期';
comment on column ${iol_schema}.icms_org_belong.start_dt is '开始时间';
comment on column ${iol_schema}.icms_org_belong.end_dt is '结束时间';
comment on column ${iol_schema}.icms_org_belong.id_mark is '增删标志';
comment on column ${iol_schema}.icms_org_belong.etl_timestamp is 'ETL处理时间戳';
