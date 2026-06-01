/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_cl_otherlimit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_cl_otherlimit
whenever sqlerror continue none;
drop table ${iol_schema}.icms_cl_otherlimit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_otherlimit(
    serialno varchar2(32) -- 流水号
    ,objectno varchar2(32) -- 对象编号
    ,objecttype varchar2(32) -- 对象类型
    ,contractserialno varchar2(32) -- 他用额度合同编号
    ,customerid varchar2(16) -- 他用额度客户编号
    ,customername varchar2(100) -- 他用额度客户名称
    ,cycleflag varchar2(4) -- 是否循环
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(32) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(32) -- 更新人
    ,updateorgid varchar2(32) -- 更新机构
    ,updatedate date -- 更新日期
    ,migtflag varchar2(80) -- 迁移标志
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
grant select on ${iol_schema}.icms_cl_otherlimit to ${iml_schema};
grant select on ${iol_schema}.icms_cl_otherlimit to ${icl_schema};
grant select on ${iol_schema}.icms_cl_otherlimit to ${idl_schema};
grant select on ${iol_schema}.icms_cl_otherlimit to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_cl_otherlimit is '他用额度信息表';
comment on column ${iol_schema}.icms_cl_otherlimit.serialno is '流水号';
comment on column ${iol_schema}.icms_cl_otherlimit.objectno is '对象编号';
comment on column ${iol_schema}.icms_cl_otherlimit.objecttype is '对象类型';
comment on column ${iol_schema}.icms_cl_otherlimit.contractserialno is '他用额度合同编号';
comment on column ${iol_schema}.icms_cl_otherlimit.customerid is '他用额度客户编号';
comment on column ${iol_schema}.icms_cl_otherlimit.customername is '他用额度客户名称';
comment on column ${iol_schema}.icms_cl_otherlimit.cycleflag is '是否循环';
comment on column ${iol_schema}.icms_cl_otherlimit.inputuserid is '登记人';
comment on column ${iol_schema}.icms_cl_otherlimit.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_cl_otherlimit.inputdate is '登记日期';
comment on column ${iol_schema}.icms_cl_otherlimit.updateuserid is '更新人';
comment on column ${iol_schema}.icms_cl_otherlimit.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_cl_otherlimit.updatedate is '更新日期';
comment on column ${iol_schema}.icms_cl_otherlimit.migtflag is '迁移标志';
comment on column ${iol_schema}.icms_cl_otherlimit.start_dt is '开始时间';
comment on column ${iol_schema}.icms_cl_otherlimit.end_dt is '结束时间';
comment on column ${iol_schema}.icms_cl_otherlimit.id_mark is '增删标志';
comment on column ${iol_schema}.icms_cl_otherlimit.etl_timestamp is 'ETL处理时间戳';
