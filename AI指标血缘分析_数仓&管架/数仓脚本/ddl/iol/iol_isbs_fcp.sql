/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_fcp
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_fcp
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_fcp purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_fcp(
    dat2 date -- 
    ,sepinr varchar2(12) -- 
    ,amt number(18,3) -- 
    ,modflg varchar2(2) -- 
    ,inr varchar2(12) -- 
    ,xrfcur varchar2(5) -- 
    ,payptyinr varchar2(12) -- 
    ,srctrninr varchar2(12) -- 
    ,dbttxt varchar2(60) -- 
    ,dat1 date -- 
    ,rpltrninr varchar2(12) -- 
    ,cur varchar2(5) -- 
    ,payrol varchar2(5) -- 
    ,dondat date -- 
    ,paytxt varchar2(60) -- 
    ,objinr varchar2(12) -- 
    ,dontrninr varchar2(12) -- 
    ,advdat date -- 
    ,dbtrol varchar2(5) -- 
    ,advtrninr varchar2(12) -- 
    ,rpldat date -- 
    ,dbtptyinr varchar2(12) -- 
    ,objtyp varchar2(9) -- 
    ,xrfamt number(18,3) -- 
    ,srcdat date -- 
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
grant select on ${iol_schema}.isbs_fcp to ${iml_schema};
grant select on ${iol_schema}.isbs_fcp to ${icl_schema};
grant select on ${iol_schema}.isbs_fcp to ${idl_schema};
grant select on ${iol_schema}.isbs_fcp to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_fcp is '国外费用池信息';
comment on column ${iol_schema}.isbs_fcp.dat2 is '';
comment on column ${iol_schema}.isbs_fcp.sepinr is '';
comment on column ${iol_schema}.isbs_fcp.amt is '';
comment on column ${iol_schema}.isbs_fcp.modflg is '';
comment on column ${iol_schema}.isbs_fcp.inr is '';
comment on column ${iol_schema}.isbs_fcp.xrfcur is '';
comment on column ${iol_schema}.isbs_fcp.payptyinr is '';
comment on column ${iol_schema}.isbs_fcp.srctrninr is '';
comment on column ${iol_schema}.isbs_fcp.dbttxt is '';
comment on column ${iol_schema}.isbs_fcp.dat1 is '';
comment on column ${iol_schema}.isbs_fcp.rpltrninr is '';
comment on column ${iol_schema}.isbs_fcp.cur is '';
comment on column ${iol_schema}.isbs_fcp.payrol is '';
comment on column ${iol_schema}.isbs_fcp.dondat is '';
comment on column ${iol_schema}.isbs_fcp.paytxt is '';
comment on column ${iol_schema}.isbs_fcp.objinr is '';
comment on column ${iol_schema}.isbs_fcp.dontrninr is '';
comment on column ${iol_schema}.isbs_fcp.advdat is '';
comment on column ${iol_schema}.isbs_fcp.dbtrol is '';
comment on column ${iol_schema}.isbs_fcp.advtrninr is '';
comment on column ${iol_schema}.isbs_fcp.rpldat is '';
comment on column ${iol_schema}.isbs_fcp.dbtptyinr is '';
comment on column ${iol_schema}.isbs_fcp.objtyp is '';
comment on column ${iol_schema}.isbs_fcp.xrfamt is '';
comment on column ${iol_schema}.isbs_fcp.srcdat is '';
comment on column ${iol_schema}.isbs_fcp.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_fcp.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_fcp.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_fcp.etl_timestamp is 'ETL处理时间戳';
