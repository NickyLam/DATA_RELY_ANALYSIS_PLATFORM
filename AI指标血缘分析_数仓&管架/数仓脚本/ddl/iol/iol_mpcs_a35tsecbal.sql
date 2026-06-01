/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a35tsecbal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a35tsecbal
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a35tsecbal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a35tsecbal(
    custname varchar2(105) -- 
    ,idtype varchar2(6) -- 
    ,idno varchar2(48) -- 
    ,acctno varchar2(48) -- 
    ,opdate varchar2(15) -- 
    ,seccd varchar2(12) -- 
    ,capitalacctno varchar2(33) -- 
    ,secbal varchar2(27) -- 
    ,status varchar2(30) -- 
    ,trndt varchar2(15) -- 
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
grant select on ${iol_schema}.mpcs_a35tsecbal to ${iml_schema};
grant select on ${iol_schema}.mpcs_a35tsecbal to ${icl_schema};
grant select on ${iol_schema}.mpcs_a35tsecbal to ${idl_schema};
grant select on ${iol_schema}.mpcs_a35tsecbal to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a35tsecbal is '证券持有资产';
comment on column ${iol_schema}.mpcs_a35tsecbal.custname is '';
comment on column ${iol_schema}.mpcs_a35tsecbal.idtype is '';
comment on column ${iol_schema}.mpcs_a35tsecbal.idno is '';
comment on column ${iol_schema}.mpcs_a35tsecbal.acctno is '';
comment on column ${iol_schema}.mpcs_a35tsecbal.opdate is '';
comment on column ${iol_schema}.mpcs_a35tsecbal.seccd is '';
comment on column ${iol_schema}.mpcs_a35tsecbal.capitalacctno is '';
comment on column ${iol_schema}.mpcs_a35tsecbal.secbal is '';
comment on column ${iol_schema}.mpcs_a35tsecbal.status is '';
comment on column ${iol_schema}.mpcs_a35tsecbal.trndt is '';
comment on column ${iol_schema}.mpcs_a35tsecbal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a35tsecbal.etl_timestamp is 'ETL处理时间戳';
