/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_listedstock
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_listedstock
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_listedstock purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_listedstock(
    sccode varchar2(48) -- 
    ,stockcode varchar2(150) -- 
    ,stockname varchar2(150) -- 
    ,companyname varchar2(180) -- 
    ,isborrower varchar2(3) -- 
    ,profits number(20,2) -- 
    ,isnromal varchar2(3) -- 
    ,bourse varchar2(3) -- 
    ,ispublic varchar2(3) -- 
    ,exponent varchar2(150) -- 
    ,shareamount number(22) -- 
    ,stockamount number(20,2) -- 
    ,persharemarketprice number(20,2) -- 
    ,profitmoney number(20,2) -- 
    ,warningline number(20,2) -- 
    ,persharevalue number(20,2) -- 
    ,liquidateline number(20,2) -- 
    ,totalvalue number(20,2) -- 
    ,duedate varchar2(15) -- 
    ,remark varchar2(4000) -- 
    ,tdcurrency varchar2(5) -- 
    ,stockidc varchar2(150) -- 
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
grant select on ${iol_schema}.mims_si_listedstock to ${iml_schema};
grant select on ${iol_schema}.mims_si_listedstock to ${icl_schema};
grant select on ${iol_schema}.mims_si_listedstock to ${idl_schema};
grant select on ${iol_schema}.mims_si_listedstock to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_listedstock is '上市公司股权';
comment on column ${iol_schema}.mims_si_listedstock.sccode is '';
comment on column ${iol_schema}.mims_si_listedstock.stockcode is '';
comment on column ${iol_schema}.mims_si_listedstock.stockname is '';
comment on column ${iol_schema}.mims_si_listedstock.companyname is '';
comment on column ${iol_schema}.mims_si_listedstock.isborrower is '';
comment on column ${iol_schema}.mims_si_listedstock.profits is '';
comment on column ${iol_schema}.mims_si_listedstock.isnromal is '';
comment on column ${iol_schema}.mims_si_listedstock.bourse is '';
comment on column ${iol_schema}.mims_si_listedstock.ispublic is '';
comment on column ${iol_schema}.mims_si_listedstock.exponent is '';
comment on column ${iol_schema}.mims_si_listedstock.shareamount is '';
comment on column ${iol_schema}.mims_si_listedstock.stockamount is '';
comment on column ${iol_schema}.mims_si_listedstock.persharemarketprice is '';
comment on column ${iol_schema}.mims_si_listedstock.profitmoney is '';
comment on column ${iol_schema}.mims_si_listedstock.warningline is '';
comment on column ${iol_schema}.mims_si_listedstock.persharevalue is '';
comment on column ${iol_schema}.mims_si_listedstock.liquidateline is '';
comment on column ${iol_schema}.mims_si_listedstock.totalvalue is '';
comment on column ${iol_schema}.mims_si_listedstock.duedate is '';
comment on column ${iol_schema}.mims_si_listedstock.remark is '';
comment on column ${iol_schema}.mims_si_listedstock.tdcurrency is '';
comment on column ${iol_schema}.mims_si_listedstock.stockidc is '';
comment on column ${iol_schema}.mims_si_listedstock.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_listedstock.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_listedstock.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_listedstock.etl_timestamp is 'ETL处理时间戳';
