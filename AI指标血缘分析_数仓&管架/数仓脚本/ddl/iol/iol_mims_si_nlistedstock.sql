/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_nlistedstock
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_nlistedstock
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_nlistedstock purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_nlistedstock(
    sccode varchar2(48) -- 
    ,companyname varchar2(180) -- 
    ,stockcode varchar2(45) -- 
    ,isborrower varchar2(3) -- 
    ,shareamount number(22) -- 
    ,ratio number(5,2) -- 
    ,stockamount number(9,0) -- 
    ,persharemarketprice number(20,2) -- 
    ,profitmoney number(20,2) -- 
    ,peridentyshare number(10,2) -- 
    ,totalvalue number(38,2) -- 
    ,persharevalue number(20,2) -- 
    ,warningline number(20,2) -- 
    ,liquidateline number(20,2) -- 
    ,sharetotalvalue number(20,2) -- 
    ,remark varchar2(4000) -- 
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
grant select on ${iol_schema}.mims_si_nlistedstock to ${iml_schema};
grant select on ${iol_schema}.mims_si_nlistedstock to ${icl_schema};
grant select on ${iol_schema}.mims_si_nlistedstock to ${idl_schema};
grant select on ${iol_schema}.mims_si_nlistedstock to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_nlistedstock is '非上市股权';
comment on column ${iol_schema}.mims_si_nlistedstock.sccode is '';
comment on column ${iol_schema}.mims_si_nlistedstock.companyname is '';
comment on column ${iol_schema}.mims_si_nlistedstock.stockcode is '';
comment on column ${iol_schema}.mims_si_nlistedstock.isborrower is '';
comment on column ${iol_schema}.mims_si_nlistedstock.shareamount is '';
comment on column ${iol_schema}.mims_si_nlistedstock.ratio is '';
comment on column ${iol_schema}.mims_si_nlistedstock.stockamount is '';
comment on column ${iol_schema}.mims_si_nlistedstock.persharemarketprice is '';
comment on column ${iol_schema}.mims_si_nlistedstock.profitmoney is '';
comment on column ${iol_schema}.mims_si_nlistedstock.peridentyshare is '';
comment on column ${iol_schema}.mims_si_nlistedstock.totalvalue is '';
comment on column ${iol_schema}.mims_si_nlistedstock.persharevalue is '';
comment on column ${iol_schema}.mims_si_nlistedstock.warningline is '';
comment on column ${iol_schema}.mims_si_nlistedstock.liquidateline is '';
comment on column ${iol_schema}.mims_si_nlistedstock.sharetotalvalue is '';
comment on column ${iol_schema}.mims_si_nlistedstock.remark is '';
comment on column ${iol_schema}.mims_si_nlistedstock.tdcurrency is '';
comment on column ${iol_schema}.mims_si_nlistedstock.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_nlistedstock.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_nlistedstock.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_nlistedstock.etl_timestamp is 'ETL处理时间戳';
