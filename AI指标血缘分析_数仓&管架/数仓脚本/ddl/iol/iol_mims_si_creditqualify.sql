/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_creditqualify
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_creditqualify
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_creditqualify purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_creditqualify(
    sccode varchar2(48) -- 
    ,applycode varchar2(45) -- 
    ,isrelation varchar2(3) -- 
    ,isworkable varchar2(3) -- 
    ,guarrelation varchar2(3) -- 
    ,guarresult varchar2(3) -- 
    ,qztypeishg varchar2(3) -- 
    ,qzishgtools varchar2(3) -- 
    ,qzhgtoolstype varchar2(3) -- 
    ,nptypeishg varchar2(3) -- 
    ,npishgtools varchar2(3) -- 
    ,nphgtoolstype varchar2(3) -- 
    ,guarmoney number(20,2) -- 
    ,guarrate number(10,6) -- 
    ,bzguarmethod varchar2(8) -- 
    ,bzmethod varchar2(8) -- 
    ,guarcurrency varchar2(5) -- 
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
grant select on ${iol_schema}.mims_si_creditqualify to ${iml_schema};
grant select on ${iol_schema}.mims_si_creditqualify to ${icl_schema};
grant select on ${iol_schema}.mims_si_creditqualify to ${idl_schema};
grant select on ${iol_schema}.mims_si_creditqualify to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_creditqualify is '授信合格认定表';
comment on column ${iol_schema}.mims_si_creditqualify.sccode is '';
comment on column ${iol_schema}.mims_si_creditqualify.applycode is '';
comment on column ${iol_schema}.mims_si_creditqualify.isrelation is '';
comment on column ${iol_schema}.mims_si_creditqualify.isworkable is '';
comment on column ${iol_schema}.mims_si_creditqualify.guarrelation is '';
comment on column ${iol_schema}.mims_si_creditqualify.guarresult is '';
comment on column ${iol_schema}.mims_si_creditqualify.qztypeishg is '';
comment on column ${iol_schema}.mims_si_creditqualify.qzishgtools is '';
comment on column ${iol_schema}.mims_si_creditqualify.qzhgtoolstype is '';
comment on column ${iol_schema}.mims_si_creditqualify.nptypeishg is '';
comment on column ${iol_schema}.mims_si_creditqualify.npishgtools is '';
comment on column ${iol_schema}.mims_si_creditqualify.nphgtoolstype is '';
comment on column ${iol_schema}.mims_si_creditqualify.guarmoney is '';
comment on column ${iol_schema}.mims_si_creditqualify.guarrate is '';
comment on column ${iol_schema}.mims_si_creditqualify.bzguarmethod is '';
comment on column ${iol_schema}.mims_si_creditqualify.bzmethod is '';
comment on column ${iol_schema}.mims_si_creditqualify.guarcurrency is '';
comment on column ${iol_schema}.mims_si_creditqualify.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_creditqualify.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_creditqualify.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_creditqualify.etl_timestamp is 'ETL处理时间戳';
