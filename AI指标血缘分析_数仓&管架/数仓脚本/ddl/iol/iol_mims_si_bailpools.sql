/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_bailpools
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_bailpools
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_bailpools purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_bailpools(
    sccode varchar2(48) -- 
    ,billscode varchar2(48) -- 
    ,billnumber number(22) -- 
    ,billacountmoney number(20,2) -- 
    ,money number(20,2) -- 
    ,remark varchar2(4000) -- 
    ,usemoney number(20,2) -- 
    ,tdcurrency varchar2(5) -- 
    ,islimit varchar2(3) -- 是否使用票据池集团额度
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
grant select on ${iol_schema}.mims_si_bailpools to ${iml_schema};
grant select on ${iol_schema}.mims_si_bailpools to ${icl_schema};
grant select on ${iol_schema}.mims_si_bailpools to ${idl_schema};
grant select on ${iol_schema}.mims_si_bailpools to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_bailpools is '票据池';
comment on column ${iol_schema}.mims_si_bailpools.sccode is '';
comment on column ${iol_schema}.mims_si_bailpools.billscode is '';
comment on column ${iol_schema}.mims_si_bailpools.billnumber is '';
comment on column ${iol_schema}.mims_si_bailpools.billacountmoney is '';
comment on column ${iol_schema}.mims_si_bailpools.money is '';
comment on column ${iol_schema}.mims_si_bailpools.remark is '';
comment on column ${iol_schema}.mims_si_bailpools.usemoney is '';
comment on column ${iol_schema}.mims_si_bailpools.tdcurrency is '';
comment on column ${iol_schema}.mims_si_bailpools.islimit is '是否使用票据池集团额度';
comment on column ${iol_schema}.mims_si_bailpools.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_bailpools.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_bailpools.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_bailpools.etl_timestamp is 'ETL处理时间戳';
