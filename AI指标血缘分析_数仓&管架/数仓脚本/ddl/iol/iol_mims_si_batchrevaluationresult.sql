/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_batchrevaluationresult
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_batchrevaluationresult
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_batchrevaluationresult purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_batchrevaluationresult(
    sccode varchar2(48) -- 
    ,evaldate varchar2(15) -- 
    ,evalmethod varchar2(30) -- 
    ,evalamt number(20,2) -- 
    ,evalexpdate varchar2(15) -- 
    ,evalstates varchar2(2) -- 
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
grant select on ${iol_schema}.mims_si_batchrevaluationresult to ${iml_schema};
grant select on ${iol_schema}.mims_si_batchrevaluationresult to ${icl_schema};
grant select on ${iol_schema}.mims_si_batchrevaluationresult to ${idl_schema};
grant select on ${iol_schema}.mims_si_batchrevaluationresult to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_batchrevaluationresult is '押品批量重估结果表';
comment on column ${iol_schema}.mims_si_batchrevaluationresult.sccode is '';
comment on column ${iol_schema}.mims_si_batchrevaluationresult.evaldate is '';
comment on column ${iol_schema}.mims_si_batchrevaluationresult.evalmethod is '';
comment on column ${iol_schema}.mims_si_batchrevaluationresult.evalamt is '';
comment on column ${iol_schema}.mims_si_batchrevaluationresult.evalexpdate is '';
comment on column ${iol_schema}.mims_si_batchrevaluationresult.evalstates is '';
comment on column ${iol_schema}.mims_si_batchrevaluationresult.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_batchrevaluationresult.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_batchrevaluationresult.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_batchrevaluationresult.etl_timestamp is 'ETL处理时间戳';
