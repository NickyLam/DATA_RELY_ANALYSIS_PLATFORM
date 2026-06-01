/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_csb_ywlb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_csb_ywlb
whenever sqlerror continue none;
drop table ${iol_schema}.pams_csb_ywlb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_csb_ywlb(
    ywlb varchar2(3) -- 业务类别
    ,ms varchar2(300) -- 描述
    ,ddlb varchar2(150) -- 调度类别
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
grant select on ${iol_schema}.pams_csb_ywlb to ${iml_schema};
grant select on ${iol_schema}.pams_csb_ywlb to ${icl_schema};
grant select on ${iol_schema}.pams_csb_ywlb to ${idl_schema};
grant select on ${iol_schema}.pams_csb_ywlb to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_csb_ywlb is '参数表-业务类别';
comment on column ${iol_schema}.pams_csb_ywlb.ywlb is '业务类别';
comment on column ${iol_schema}.pams_csb_ywlb.ms is '描述';
comment on column ${iol_schema}.pams_csb_ywlb.ddlb is '调度类别';
comment on column ${iol_schema}.pams_csb_ywlb.start_dt is '开始时间';
comment on column ${iol_schema}.pams_csb_ywlb.end_dt is '结束时间';
comment on column ${iol_schema}.pams_csb_ywlb.id_mark is '增删标志';
comment on column ${iol_schema}.pams_csb_ywlb.etl_timestamp is 'ETL处理时间戳';
