/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_rent
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_rent
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_rent purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_rent(
    sccode varchar2(48) -- 
    ,renttime number(22) -- 
    ,renttype varchar2(3) -- 
    ,rentmoney number(20,2) -- 
    ,descibe varchar2(300) -- 
    ,startdate varchar2(15) -- 
    ,duedate varchar2(15) -- 
    ,isnotice varchar2(3) -- 
    ,isproduce varchar2(3) -- 
    ,remark varchar2(4000) -- 
    ,isrelation2 varchar2(3) -- 
    ,tdcurrency varchar2(5) -- 
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
grant select on ${iol_schema}.mims_si_rent to ${iml_schema};
grant select on ${iol_schema}.mims_si_rent to ${icl_schema};
grant select on ${iol_schema}.mims_si_rent to ${idl_schema};
grant select on ${iol_schema}.mims_si_rent to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_rent is '应收租金';
comment on column ${iol_schema}.mims_si_rent.sccode is '';
comment on column ${iol_schema}.mims_si_rent.renttime is '';
comment on column ${iol_schema}.mims_si_rent.renttype is '';
comment on column ${iol_schema}.mims_si_rent.rentmoney is '';
comment on column ${iol_schema}.mims_si_rent.descibe is '';
comment on column ${iol_schema}.mims_si_rent.startdate is '';
comment on column ${iol_schema}.mims_si_rent.duedate is '';
comment on column ${iol_schema}.mims_si_rent.isnotice is '';
comment on column ${iol_schema}.mims_si_rent.isproduce is '';
comment on column ${iol_schema}.mims_si_rent.remark is '';
comment on column ${iol_schema}.mims_si_rent.isrelation2 is '';
comment on column ${iol_schema}.mims_si_rent.tdcurrency is '';
comment on column ${iol_schema}.mims_si_rent.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_rent.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_rent.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_rent.etl_timestamp is 'ETL处理时间戳';
