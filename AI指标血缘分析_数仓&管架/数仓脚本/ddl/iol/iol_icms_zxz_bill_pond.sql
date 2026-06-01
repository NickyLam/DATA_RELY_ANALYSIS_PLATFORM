/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_zxz_bill_pond
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_zxz_bill_pond
whenever sqlerror continue none;
drop table ${iol_schema}.icms_zxz_bill_pond purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_zxz_bill_pond(
    billno varchar2(32) -- 借据号
    ,packageno varchar2(32) -- 批次包编号
    ,inpoolflag varchar2(10) -- 入池标识：申请（总行池）：1二级批次包：2后补3
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
grant select on ${iol_schema}.icms_zxz_bill_pond to ${iml_schema};
grant select on ${iol_schema}.icms_zxz_bill_pond to ${icl_schema};
grant select on ${iol_schema}.icms_zxz_bill_pond to ${idl_schema};
grant select on ${iol_schema}.icms_zxz_bill_pond to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_zxz_bill_pond is '支小再借据池表';
comment on column ${iol_schema}.icms_zxz_bill_pond.billno is '借据号';
comment on column ${iol_schema}.icms_zxz_bill_pond.packageno is '批次包编号';
comment on column ${iol_schema}.icms_zxz_bill_pond.inpoolflag is '入池标识：申请（总行池）：1二级批次包：2后补3';
comment on column ${iol_schema}.icms_zxz_bill_pond.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_zxz_bill_pond.start_dt is '开始时间';
comment on column ${iol_schema}.icms_zxz_bill_pond.end_dt is '结束时间';
comment on column ${iol_schema}.icms_zxz_bill_pond.id_mark is '增删标志';
comment on column ${iol_schema}.icms_zxz_bill_pond.etl_timestamp is 'ETL处理时间戳';
