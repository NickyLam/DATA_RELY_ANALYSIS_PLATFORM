/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_guaranteeslip
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_guaranteeslip
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_guaranteeslip purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_guaranteeslip(
    sccode varchar2(48) -- 
    ,guaranteeslipno varchar2(90) -- 
    ,issuercode varchar2(150) -- 
    ,issuername varchar2(150) -- 
    ,insurancekind varchar2(3) -- 
    ,startdate varchar2(15) -- 
    ,enddate varchar2(15) -- 
    ,yearlimit number(3,1) -- 
    ,insuranceamount number(20,2) -- 
    ,policyholder varchar2(150) -- 
    ,beneficiary varchar2(150) -- 
    ,cancelprice number(20,2) -- 
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
grant select on ${iol_schema}.mims_si_guaranteeslip to ${iml_schema};
grant select on ${iol_schema}.mims_si_guaranteeslip to ${icl_schema};
grant select on ${iol_schema}.mims_si_guaranteeslip to ${idl_schema};
grant select on ${iol_schema}.mims_si_guaranteeslip to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_guaranteeslip is '保单';
comment on column ${iol_schema}.mims_si_guaranteeslip.sccode is '';
comment on column ${iol_schema}.mims_si_guaranteeslip.guaranteeslipno is '';
comment on column ${iol_schema}.mims_si_guaranteeslip.issuercode is '';
comment on column ${iol_schema}.mims_si_guaranteeslip.issuername is '';
comment on column ${iol_schema}.mims_si_guaranteeslip.insurancekind is '';
comment on column ${iol_schema}.mims_si_guaranteeslip.startdate is '';
comment on column ${iol_schema}.mims_si_guaranteeslip.enddate is '';
comment on column ${iol_schema}.mims_si_guaranteeslip.yearlimit is '';
comment on column ${iol_schema}.mims_si_guaranteeslip.insuranceamount is '';
comment on column ${iol_schema}.mims_si_guaranteeslip.policyholder is '';
comment on column ${iol_schema}.mims_si_guaranteeslip.beneficiary is '';
comment on column ${iol_schema}.mims_si_guaranteeslip.cancelprice is '';
comment on column ${iol_schema}.mims_si_guaranteeslip.remark is '';
comment on column ${iol_schema}.mims_si_guaranteeslip.tdcurrency is '';
comment on column ${iol_schema}.mims_si_guaranteeslip.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_guaranteeslip.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_guaranteeslip.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_guaranteeslip.etl_timestamp is 'ETL处理时间戳';
