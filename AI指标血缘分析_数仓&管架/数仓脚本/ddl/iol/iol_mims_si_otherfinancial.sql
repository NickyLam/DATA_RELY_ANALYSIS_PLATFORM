/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_otherfinancial
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_otherfinancial
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_otherfinancial purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_otherfinancial(
    sccode varchar2(48) -- 
    ,productcode varchar2(150) -- 
    ,productname varchar2(150) -- 
    ,cashaccount number(22) -- 
    ,startdate varchar2(15) -- 
    ,enddate varchar2(15) -- 
    ,incometype varchar2(3) -- 
    ,impawnnum number(20,2) -- 
    ,predictyield number(5,2) -- 
    ,istermright varchar2(3) -- 
    ,accountname varchar2(45) -- 
    ,address varchar2(15) -- 
    ,outratingdate varchar2(15) -- 
    ,outratingresult varchar2(150) -- 
    ,inratingdate varchar2(15) -- 
    ,inratingresult varchar2(150) -- 
    ,remark varchar2(4000) -- 
    ,tdcurrency varchar2(5) -- 
    ,allnum number(20,2) -- 
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
grant select on ${iol_schema}.mims_si_otherfinancial to ${iml_schema};
grant select on ${iol_schema}.mims_si_otherfinancial to ${icl_schema};
grant select on ${iol_schema}.mims_si_otherfinancial to ${idl_schema};
grant select on ${iol_schema}.mims_si_otherfinancial to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_otherfinancial is '他行理财产品';
comment on column ${iol_schema}.mims_si_otherfinancial.sccode is '';
comment on column ${iol_schema}.mims_si_otherfinancial.productcode is '';
comment on column ${iol_schema}.mims_si_otherfinancial.productname is '';
comment on column ${iol_schema}.mims_si_otherfinancial.cashaccount is '';
comment on column ${iol_schema}.mims_si_otherfinancial.startdate is '';
comment on column ${iol_schema}.mims_si_otherfinancial.enddate is '';
comment on column ${iol_schema}.mims_si_otherfinancial.incometype is '';
comment on column ${iol_schema}.mims_si_otherfinancial.impawnnum is '';
comment on column ${iol_schema}.mims_si_otherfinancial.predictyield is '';
comment on column ${iol_schema}.mims_si_otherfinancial.istermright is '';
comment on column ${iol_schema}.mims_si_otherfinancial.accountname is '';
comment on column ${iol_schema}.mims_si_otherfinancial.address is '';
comment on column ${iol_schema}.mims_si_otherfinancial.outratingdate is '';
comment on column ${iol_schema}.mims_si_otherfinancial.outratingresult is '';
comment on column ${iol_schema}.mims_si_otherfinancial.inratingdate is '';
comment on column ${iol_schema}.mims_si_otherfinancial.inratingresult is '';
comment on column ${iol_schema}.mims_si_otherfinancial.remark is '';
comment on column ${iol_schema}.mims_si_otherfinancial.tdcurrency is '';
comment on column ${iol_schema}.mims_si_otherfinancial.allnum is '';
comment on column ${iol_schema}.mims_si_otherfinancial.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_otherfinancial.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_otherfinancial.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_otherfinancial.etl_timestamp is 'ETL处理时间戳';
