/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_credit_increment
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_credit_increment
whenever sqlerror continue none;
drop table ${iol_schema}.icms_credit_increment purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_credit_increment(
    serialno varchar2(40) -- 流水号
    ,customername varchar2(200) -- 增信方名称
    ,isprovideguaranty varchar2(2) -- 是否提供实质性担保
    ,customerid varchar2(32) -- 增信方编号
    ,objectno varchar2(48) -- 对象编号
    ,increaseway varchar2(4) -- 增信方式
    ,objecttype varchar2(48) -- 对象类型
    ,ishxcustomer varchar2(2) -- 增信方是否我行授信客户
    ,remark varchar2(4000) -- 增信条款说明
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
grant select on ${iol_schema}.icms_credit_increment to ${iml_schema};
grant select on ${iol_schema}.icms_credit_increment to ${icl_schema};
grant select on ${iol_schema}.icms_credit_increment to ${idl_schema};
grant select on ${iol_schema}.icms_credit_increment to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_credit_increment is '增信信息';
comment on column ${iol_schema}.icms_credit_increment.serialno is '流水号';
comment on column ${iol_schema}.icms_credit_increment.customername is '增信方名称';
comment on column ${iol_schema}.icms_credit_increment.isprovideguaranty is '是否提供实质性担保';
comment on column ${iol_schema}.icms_credit_increment.customerid is '增信方编号';
comment on column ${iol_schema}.icms_credit_increment.objectno is '对象编号';
comment on column ${iol_schema}.icms_credit_increment.increaseway is '增信方式';
comment on column ${iol_schema}.icms_credit_increment.objecttype is '对象类型';
comment on column ${iol_schema}.icms_credit_increment.ishxcustomer is '增信方是否我行授信客户';
comment on column ${iol_schema}.icms_credit_increment.remark is '增信条款说明';
comment on column ${iol_schema}.icms_credit_increment.start_dt is '开始时间';
comment on column ${iol_schema}.icms_credit_increment.end_dt is '结束时间';
comment on column ${iol_schema}.icms_credit_increment.id_mark is '增删标志';
comment on column ${iol_schema}.icms_credit_increment.etl_timestamp is 'ETL处理时间戳';
