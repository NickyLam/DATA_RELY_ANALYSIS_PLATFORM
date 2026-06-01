/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a35tassignhist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a35tassignhist
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a35tassignhist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a35tassignhist(
    cobank varchar2(2) -- 
    ,custname varchar2(105) -- 
    ,idtype varchar2(6) -- 
    ,idno varchar2(48) -- 
    ,oriacctno varchar2(48) -- 
    ,oripswd varchar2(24) -- 
    ,newacctno varchar2(48) -- 
    ,newpswd varchar2(24) -- 
    ,seccd varchar2(12) -- 
    ,secname varchar2(90) -- 
    ,capitalacctno varchar2(33) -- 
    ,capitalpswd varchar2(24) -- 
    ,ccy varchar2(5) -- 
    ,custmanagerid varchar2(12) -- 
    ,custtype varchar2(3) -- 
    ,openbrcno varchar2(15) -- 
    ,sex varchar2(2) -- 
    ,secbrcno varchar2(12) -- 
    ,tycustno varchar2(30) -- 
    ,tyacctno varchar2(48) -- 
    ,trntype varchar2(2) -- 
    ,trnname varchar2(45) -- 
    ,signtm varchar2(26) -- 
    ,brcno varchar2(9) -- 
    ,brcname varchar2(120) -- 
    ,chgflag varchar2(2) -- 
    ,bizagtname varchar2(30) -- 
    ,bizagtidtype varchar2(6) -- 
    ,bizagtidno varchar2(27) -- 
    ,custno varchar2(48) -- 
    ,reserve2 varchar2(96) -- 
    ,reserve3 varchar2(96) -- 
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.mpcs_a35tassignhist to ${iml_schema};
grant select on ${iol_schema}.mpcs_a35tassignhist to ${icl_schema};
grant select on ${iol_schema}.mpcs_a35tassignhist to ${idl_schema};
grant select on ${iol_schema}.mpcs_a35tassignhist to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a35tassignhist is '三方存管签约表';
comment on column ${iol_schema}.mpcs_a35tassignhist.cobank is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.custname is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.idtype is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.idno is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.oriacctno is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.oripswd is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.newacctno is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.newpswd is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.seccd is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.secname is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.capitalacctno is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.capitalpswd is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.ccy is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.custmanagerid is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.custtype is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.openbrcno is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.sex is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.secbrcno is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.tycustno is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.tyacctno is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.trntype is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.trnname is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.signtm is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.brcno is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.brcname is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.chgflag is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.bizagtname is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.bizagtidtype is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.bizagtidno is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.custno is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.reserve2 is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.reserve3 is '';
comment on column ${iol_schema}.mpcs_a35tassignhist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a35tassignhist.etl_timestamp is 'ETL处理时间戳';
