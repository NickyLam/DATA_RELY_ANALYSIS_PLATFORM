/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_ownerfinancial
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_ownerfinancial
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_ownerfinancial purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_ownerfinancial(
    sccode varchar2(48) -- 
    ,productcode varchar2(150) -- 
    ,productname varchar2(150) -- 
    ,accountno varchar2(150) -- 
    ,cashaccount varchar2(75) -- 
    ,accountday number(22) -- 
    ,startdate varchar2(15) -- 
    ,enddate varchar2(15) -- 
    ,incometype varchar2(3) -- 
    ,impawnnum number(20,2) -- 
    ,predictyield number(5,2) -- 
    ,istermright varchar2(3) -- 
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
grant select on ${iol_schema}.mims_si_ownerfinancial to ${iml_schema};
grant select on ${iol_schema}.mims_si_ownerfinancial to ${icl_schema};
grant select on ${iol_schema}.mims_si_ownerfinancial to ${idl_schema};
grant select on ${iol_schema}.mims_si_ownerfinancial to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_ownerfinancial is '本行理财产品';
comment on column ${iol_schema}.mims_si_ownerfinancial.sccode is '';
comment on column ${iol_schema}.mims_si_ownerfinancial.productcode is '';
comment on column ${iol_schema}.mims_si_ownerfinancial.productname is '';
comment on column ${iol_schema}.mims_si_ownerfinancial.accountno is '';
comment on column ${iol_schema}.mims_si_ownerfinancial.cashaccount is '';
comment on column ${iol_schema}.mims_si_ownerfinancial.accountday is '';
comment on column ${iol_schema}.mims_si_ownerfinancial.startdate is '';
comment on column ${iol_schema}.mims_si_ownerfinancial.enddate is '';
comment on column ${iol_schema}.mims_si_ownerfinancial.incometype is '';
comment on column ${iol_schema}.mims_si_ownerfinancial.impawnnum is '';
comment on column ${iol_schema}.mims_si_ownerfinancial.predictyield is '';
comment on column ${iol_schema}.mims_si_ownerfinancial.istermright is '';
comment on column ${iol_schema}.mims_si_ownerfinancial.remark is '';
comment on column ${iol_schema}.mims_si_ownerfinancial.tdcurrency is '';
comment on column ${iol_schema}.mims_si_ownerfinancial.allnum is '';
comment on column ${iol_schema}.mims_si_ownerfinancial.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_ownerfinancial.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_ownerfinancial.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_ownerfinancial.etl_timestamp is 'ETL处理时间戳';
