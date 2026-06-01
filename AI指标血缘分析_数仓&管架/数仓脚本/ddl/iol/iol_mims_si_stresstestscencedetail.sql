/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_stresstestscencedetail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_stresstestscencedetail
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_stresstestscencedetail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_stresstestscencedetail(
    scencecode varchar2(30) -- 
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
grant select on ${iol_schema}.mims_si_stresstestscencedetail to ${iml_schema};
grant select on ${iol_schema}.mims_si_stresstestscencedetail to ${icl_schema};
grant select on ${iol_schema}.mims_si_stresstestscencedetail to ${idl_schema};
grant select on ${iol_schema}.mims_si_stresstestscencedetail to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_stresstestscencedetail is '压力测试情景明细信息';
comment on column ${iol_schema}.mims_si_stresstestscencedetail.scencecode is '';
comment on column ${iol_schema}.mims_si_stresstestscencedetail.seqno is '';
comment on column ${iol_schema}.mims_si_stresstestscencedetail.valuechangerange is '';
comment on column ${iol_schema}.mims_si_stresstestscencedetail.guartype is '';
comment on column ${iol_schema}.mims_si_stresstestscencedetail.deptcode is '';
comment on column ${iol_schema}.mims_si_stresstestscencedetail.city is '';
comment on column ${iol_schema}.mims_si_stresstestscencedetail.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_stresstestscencedetail.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_stresstestscencedetail.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_stresstestscencedetail.etl_timestamp is 'ETL处理时间戳';
