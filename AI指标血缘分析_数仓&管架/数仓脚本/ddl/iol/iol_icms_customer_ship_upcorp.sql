/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_ship_upcorp
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_ship_upcorp
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_ship_upcorp purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_ship_upcorp(
    serialno varchar2(64) -- 流水号
    ,corpid varchar2(32) -- 组织机构代码
    ,inputdate date -- 登记日期
    ,regedittype varchar2(10) -- 登记注册号类型
    ,societyinstitutioncode varchar2(18) -- 社会信用代码
    ,superorgname varchar2(320) -- 上级机构名称
    ,updateorgid varchar2(128) -- 更新机构
    ,updatedate date -- 更新日期
    ,updateuserid varchar2(128) -- 更新人
    ,migtflag varchar2(80) -- 迁移标志
    ,regeditcode varchar2(50) -- 登记注册号码
    ,commercialregno varchar2(18) -- 商事与非商事登记证号
    ,maincustomerid varchar2(32) -- 关联人客户号
    ,inputorgid varchar2(128) -- 登记机构
    ,relationship varchar2(72) -- 关联人类型
    ,creditinstitutioncode varchar2(18) -- 机构信用代码
    ,customerid varchar2(32) -- 机构信用代码
    ,migtoldvalue varchar2(250) -- 备份原字段值
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
grant select on ${iol_schema}.icms_customer_ship_upcorp to ${iml_schema};
grant select on ${iol_schema}.icms_customer_ship_upcorp to ${icl_schema};
grant select on ${iol_schema}.icms_customer_ship_upcorp to ${idl_schema};
grant select on ${iol_schema}.icms_customer_ship_upcorp to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_ship_upcorp is '上级机构信息表';
comment on column ${iol_schema}.icms_customer_ship_upcorp.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_ship_upcorp.corpid is '组织机构代码';
comment on column ${iol_schema}.icms_customer_ship_upcorp.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_ship_upcorp.regedittype is '登记注册号类型';
comment on column ${iol_schema}.icms_customer_ship_upcorp.societyinstitutioncode is '社会信用代码';
comment on column ${iol_schema}.icms_customer_ship_upcorp.superorgname is '上级机构名称';
comment on column ${iol_schema}.icms_customer_ship_upcorp.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_customer_ship_upcorp.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_ship_upcorp.updateuserid is '更新人';
comment on column ${iol_schema}.icms_customer_ship_upcorp.migtflag is '迁移标志';
comment on column ${iol_schema}.icms_customer_ship_upcorp.regeditcode is '登记注册号码';
comment on column ${iol_schema}.icms_customer_ship_upcorp.commercialregno is '商事与非商事登记证号';
comment on column ${iol_schema}.icms_customer_ship_upcorp.maincustomerid is '关联人客户号';
comment on column ${iol_schema}.icms_customer_ship_upcorp.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_ship_upcorp.relationship is '关联人类型';
comment on column ${iol_schema}.icms_customer_ship_upcorp.creditinstitutioncode is '机构信用代码';
comment on column ${iol_schema}.icms_customer_ship_upcorp.customerid is '机构信用代码';
comment on column ${iol_schema}.icms_customer_ship_upcorp.migtoldvalue is '备份原字段值';
comment on column ${iol_schema}.icms_customer_ship_upcorp.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_ship_upcorp.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_ship_upcorp.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_ship_upcorp.etl_timestamp is 'ETL处理时间戳';
