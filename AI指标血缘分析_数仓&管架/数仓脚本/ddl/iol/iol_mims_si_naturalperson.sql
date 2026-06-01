/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_naturalperson
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_naturalperson
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_naturalperson purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_naturalperson(
    sccode varchar2(48) -- 
    ,vouchertype varchar2(3) -- 
    ,voucherno varchar2(90) -- 
    ,vouchername varchar2(150) -- 
    ,cardno varchar2(90) -- 
    ,cardtype varchar2(15) -- 
    ,industry varchar2(150) -- 
    ,netasset number(20,2) -- 
    ,economic varchar2(3) -- 
    ,independence varchar2(3) -- 
    ,registcountry varchar2(150) -- 
    ,registcountryresult varchar2(150) -- 
    ,outratingdate varchar2(15) -- 
    ,outratingresult varchar2(150) -- 
    ,inratingdate varchar2(15) -- 
    ,inratingresult varchar2(150) -- 
    ,purpose varchar2(3) -- 
    ,isstage varchar2(3) -- 
    ,remark varchar2(4000) -- 
    ,tdcurrency varchar2(5) -- 
    ,isresident varchar2(3) -- 
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
grant select on ${iol_schema}.mims_si_naturalperson to ${iml_schema};
grant select on ${iol_schema}.mims_si_naturalperson to ${icl_schema};
grant select on ${iol_schema}.mims_si_naturalperson to ${idl_schema};
grant select on ${iol_schema}.mims_si_naturalperson to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_naturalperson is '自然人保证';
comment on column ${iol_schema}.mims_si_naturalperson.sccode is '';
comment on column ${iol_schema}.mims_si_naturalperson.vouchertype is '';
comment on column ${iol_schema}.mims_si_naturalperson.voucherno is '';
comment on column ${iol_schema}.mims_si_naturalperson.vouchername is '';
comment on column ${iol_schema}.mims_si_naturalperson.cardno is '';
comment on column ${iol_schema}.mims_si_naturalperson.cardtype is '';
comment on column ${iol_schema}.mims_si_naturalperson.industry is '';
comment on column ${iol_schema}.mims_si_naturalperson.netasset is '';
comment on column ${iol_schema}.mims_si_naturalperson.economic is '';
comment on column ${iol_schema}.mims_si_naturalperson.independence is '';
comment on column ${iol_schema}.mims_si_naturalperson.registcountry is '';
comment on column ${iol_schema}.mims_si_naturalperson.registcountryresult is '';
comment on column ${iol_schema}.mims_si_naturalperson.outratingdate is '';
comment on column ${iol_schema}.mims_si_naturalperson.outratingresult is '';
comment on column ${iol_schema}.mims_si_naturalperson.inratingdate is '';
comment on column ${iol_schema}.mims_si_naturalperson.inratingresult is '';
comment on column ${iol_schema}.mims_si_naturalperson.purpose is '';
comment on column ${iol_schema}.mims_si_naturalperson.isstage is '';
comment on column ${iol_schema}.mims_si_naturalperson.remark is '';
comment on column ${iol_schema}.mims_si_naturalperson.tdcurrency is '';
comment on column ${iol_schema}.mims_si_naturalperson.isresident is '';
comment on column ${iol_schema}.mims_si_naturalperson.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_naturalperson.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_naturalperson.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_naturalperson.etl_timestamp is 'ETL处理时间戳';
