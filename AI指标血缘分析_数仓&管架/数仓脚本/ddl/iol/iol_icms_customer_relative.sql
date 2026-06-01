/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_relative
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_relative
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_relative purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_relative(
    customerid varchar2(16) -- 客户编号
    ,relationship varchar2(64) -- 关联关系
    ,relativeid varchar2(64) -- 关系编号
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,status varchar2(1) -- 是否有效
    ,updateorgid varchar2(64) -- 更新日期
    ,updatedate timestamp -- 更新机构
    ,updateuserid varchar2(64) -- 更新人
    ,inputorgid varchar2(64) -- 登记机构
    ,relationstate varchar2(18) -- 投资情况
    ,customername varchar2(200) -- 客户名称
    ,creditinstitutioncode varchar2(18) -- 机构信用代码
    ,inputdate timestamp -- 登记日期
    ,inputuserid varchar2(64) -- 登记人
    ,relatetype varchar2(3) -- 关联类型
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
grant select on ${iol_schema}.icms_customer_relative to ${iml_schema};
grant select on ${iol_schema}.icms_customer_relative to ${icl_schema};
grant select on ${iol_schema}.icms_customer_relative to ${idl_schema};
grant select on ${iol_schema}.icms_customer_relative to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_relative is '客户关联信息';
comment on column ${iol_schema}.icms_customer_relative.customerid is '客户编号';
comment on column ${iol_schema}.icms_customer_relative.relationship is '关联关系';
comment on column ${iol_schema}.icms_customer_relative.relativeid is '关系编号';
comment on column ${iol_schema}.icms_customer_relative.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_customer_relative.status is '是否有效';
comment on column ${iol_schema}.icms_customer_relative.updateorgid is '更新日期';
comment on column ${iol_schema}.icms_customer_relative.updatedate is '更新机构';
comment on column ${iol_schema}.icms_customer_relative.updateuserid is '更新人';
comment on column ${iol_schema}.icms_customer_relative.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_relative.relationstate is '投资情况';
comment on column ${iol_schema}.icms_customer_relative.customername is '客户名称';
comment on column ${iol_schema}.icms_customer_relative.creditinstitutioncode is '机构信用代码';
comment on column ${iol_schema}.icms_customer_relative.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_relative.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_relative.relatetype is '关联类型';
comment on column ${iol_schema}.icms_customer_relative.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_relative.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_relative.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_relative.etl_timestamp is 'ETL处理时间戳';
