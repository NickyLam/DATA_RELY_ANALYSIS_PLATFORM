/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_afterloan_relative
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_afterloan_relative
whenever sqlerror continue none;
drop table ${iol_schema}.icms_afterloan_relative purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_afterloan_relative(
    serialno varchar2(64) -- 流水号
    ,objecttype varchar2(64) -- 关联类型
    ,objectno varchar2(64) -- 关联编号
    ,customerid varchar2(64) -- 客户号
    ,inputtime date -- 登记时间
    ,createtype varchar2(10) -- 生成方式
    ,status varchar2(10) -- 状态
    ,remark varchar2(2000) -- 备注
    ,inputuserid varchar2(30) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
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
grant select on ${iol_schema}.icms_afterloan_relative to ${iml_schema};
grant select on ${iol_schema}.icms_afterloan_relative to ${icl_schema};
grant select on ${iol_schema}.icms_afterloan_relative to ${idl_schema};
grant select on ${iol_schema}.icms_afterloan_relative to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_afterloan_relative is '贷后关联业务表';
comment on column ${iol_schema}.icms_afterloan_relative.serialno is '流水号';
comment on column ${iol_schema}.icms_afterloan_relative.objecttype is '关联类型';
comment on column ${iol_schema}.icms_afterloan_relative.objectno is '关联编号';
comment on column ${iol_schema}.icms_afterloan_relative.customerid is '客户号';
comment on column ${iol_schema}.icms_afterloan_relative.inputtime is '登记时间';
comment on column ${iol_schema}.icms_afterloan_relative.createtype is '生成方式';
comment on column ${iol_schema}.icms_afterloan_relative.status is '状态';
comment on column ${iol_schema}.icms_afterloan_relative.remark is '备注';
comment on column ${iol_schema}.icms_afterloan_relative.inputuserid is '登记人';
comment on column ${iol_schema}.icms_afterloan_relative.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_afterloan_relative.inputdate is '登记日期';
comment on column ${iol_schema}.icms_afterloan_relative.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_afterloan_relative.start_dt is '开始时间';
comment on column ${iol_schema}.icms_afterloan_relative.end_dt is '结束时间';
comment on column ${iol_schema}.icms_afterloan_relative.id_mark is '增删标志';
comment on column ${iol_schema}.icms_afterloan_relative.etl_timestamp is 'ETL处理时间戳';
