/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_stresstestdetail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_stresstestdetail
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_stresstestdetail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_stresstestdetail(
    testcode varchar2(30) -- 
    ,scencecode varchar2(30) -- 
    ,seqno number(22) -- 
    ,valuechangerange number(6,2) -- 
    ,guartype varchar2(30) -- 
    ,deptcode varchar2(30) -- 
    ,city varchar2(90) -- 
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
grant select on ${iol_schema}.mims_si_stresstestdetail to ${iml_schema};
grant select on ${iol_schema}.mims_si_stresstestdetail to ${icl_schema};
grant select on ${iol_schema}.mims_si_stresstestdetail to ${idl_schema};
grant select on ${iol_schema}.mims_si_stresstestdetail to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_stresstestdetail is '压力测试明细信息';
comment on column ${iol_schema}.mims_si_stresstestdetail.testcode is '';
comment on column ${iol_schema}.mims_si_stresstestdetail.scencecode is '';
comment on column ${iol_schema}.mims_si_stresstestdetail.seqno is '';
comment on column ${iol_schema}.mims_si_stresstestdetail.valuechangerange is '';
comment on column ${iol_schema}.mims_si_stresstestdetail.guartype is '';
comment on column ${iol_schema}.mims_si_stresstestdetail.deptcode is '';
comment on column ${iol_schema}.mims_si_stresstestdetail.city is '';
comment on column ${iol_schema}.mims_si_stresstestdetail.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_stresstestdetail.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_stresstestdetail.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_stresstestdetail.etl_timestamp is 'ETL处理时间戳';
