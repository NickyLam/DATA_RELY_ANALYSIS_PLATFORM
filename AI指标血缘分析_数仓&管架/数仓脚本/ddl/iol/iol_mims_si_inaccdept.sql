/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_inaccdept
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_inaccdept
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_inaccdept purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_inaccdept(
    sccode varchar2(48) -- 
    ,datasourceflag varchar2(2) -- 
    ,inaccountdept varchar2(45) -- 
    ,registorg varchar2(300) -- 
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
grant select on ${iol_schema}.mims_si_inaccdept to ${iml_schema};
grant select on ${iol_schema}.mims_si_inaccdept to ${icl_schema};
grant select on ${iol_schema}.mims_si_inaccdept to ${idl_schema};
grant select on ${iol_schema}.mims_si_inaccdept to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_inaccdept is '押品与记账机构关系表';
comment on column ${iol_schema}.mims_si_inaccdept.sccode is '';
comment on column ${iol_schema}.mims_si_inaccdept.datasourceflag is '';
comment on column ${iol_schema}.mims_si_inaccdept.inaccountdept is '';
comment on column ${iol_schema}.mims_si_inaccdept.registorg is '';
comment on column ${iol_schema}.mims_si_inaccdept.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_inaccdept.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_inaccdept.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_inaccdept.etl_timestamp is 'ETL处理时间戳';
