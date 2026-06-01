/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_vchr_iomp
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_vchr_iomp
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_vchr_iomp purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_vchr_iomp(
    module varchar2(20) -- 业务类型
    ,desctx varchar2(255) -- 分录规则映射
    ,stacid number(19) -- 账套标记
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
grant select on ${iol_schema}.tgls_vchr_iomp to ${iml_schema};
grant select on ${iol_schema}.tgls_vchr_iomp to ${icl_schema};
grant select on ${iol_schema}.tgls_vchr_iomp to ${idl_schema};
grant select on ${iol_schema}.tgls_vchr_iomp to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_vchr_iomp is '分录规则映射主表';
comment on column ${iol_schema}.tgls_vchr_iomp.module is '业务类型';
comment on column ${iol_schema}.tgls_vchr_iomp.desctx is '分录规则映射';
comment on column ${iol_schema}.tgls_vchr_iomp.stacid is '账套标记';
comment on column ${iol_schema}.tgls_vchr_iomp.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_vchr_iomp.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_vchr_iomp.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_vchr_iomp.etl_timestamp is 'ETL处理时间戳';
