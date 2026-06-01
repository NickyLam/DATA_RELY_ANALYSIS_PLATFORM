/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_guarhistorytracking
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_guarhistorytracking
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_guarhistorytracking purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_guarhistorytracking(
    seqno varchar2(45) -- 
    ,sccode varchar2(48) -- 
    ,occurdate varchar2(45) -- 
    ,businesstype varchar2(3) -- 
    ,remarks varchar2(4000) -- 
    ,businessno varchar2(48) -- 
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
grant select on ${iol_schema}.mims_si_guarhistorytracking to ${iml_schema};
grant select on ${iol_schema}.mims_si_guarhistorytracking to ${icl_schema};
grant select on ${iol_schema}.mims_si_guarhistorytracking to ${idl_schema};
grant select on ${iol_schema}.mims_si_guarhistorytracking to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_guarhistorytracking is '押品历史变动轨迹信息';
comment on column ${iol_schema}.mims_si_guarhistorytracking.seqno is '';
comment on column ${iol_schema}.mims_si_guarhistorytracking.sccode is '';
comment on column ${iol_schema}.mims_si_guarhistorytracking.occurdate is '';
comment on column ${iol_schema}.mims_si_guarhistorytracking.businesstype is '';
comment on column ${iol_schema}.mims_si_guarhistorytracking.remarks is '';
comment on column ${iol_schema}.mims_si_guarhistorytracking.businessno is '';
comment on column ${iol_schema}.mims_si_guarhistorytracking.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_guarhistorytracking.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_guarhistorytracking.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_guarhistorytracking.etl_timestamp is 'ETL处理时间戳';
