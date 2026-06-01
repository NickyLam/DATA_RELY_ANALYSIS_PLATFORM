/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_otherguaranty
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_otherguaranty
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_otherguaranty purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_otherguaranty(
    sccode varchar2(48) -- 
    ,guarname varchar2(150) -- 
    ,amount number(10,2) -- 
    ,unit varchar2(15) -- 
    ,guarunitprice number(20,2) -- 
    ,guaraddress varchar2(150) -- 
    ,gaindate varchar2(15) -- 
    ,value number(18,2) -- 
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
grant select on ${iol_schema}.mims_si_otherguaranty to ${iml_schema};
grant select on ${iol_schema}.mims_si_otherguaranty to ${icl_schema};
grant select on ${iol_schema}.mims_si_otherguaranty to ${idl_schema};
grant select on ${iol_schema}.mims_si_otherguaranty to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_otherguaranty is '其他抵押物';
comment on column ${iol_schema}.mims_si_otherguaranty.sccode is '';
comment on column ${iol_schema}.mims_si_otherguaranty.guarname is '';
comment on column ${iol_schema}.mims_si_otherguaranty.amount is '';
comment on column ${iol_schema}.mims_si_otherguaranty.unit is '';
comment on column ${iol_schema}.mims_si_otherguaranty.guarunitprice is '';
comment on column ${iol_schema}.mims_si_otherguaranty.guaraddress is '';
comment on column ${iol_schema}.mims_si_otherguaranty.gaindate is '';
comment on column ${iol_schema}.mims_si_otherguaranty.value is '';
comment on column ${iol_schema}.mims_si_otherguaranty.remark is '';
comment on column ${iol_schema}.mims_si_otherguaranty.tdcurrency is '';
comment on column ${iol_schema}.mims_si_otherguaranty.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_otherguaranty.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_otherguaranty.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_otherguaranty.etl_timestamp is 'ETL处理时间戳';
