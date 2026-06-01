/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_fundinformation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_fundinformation
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_fundinformation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_fundinformation(
    sccode varchar2(48) -- 
    ,fundcode varchar2(150) -- 
    ,account varchar2(90) -- 
    ,issuername varchar2(150) -- 
    ,startdate varchar2(15) -- 
    ,enddate varchar2(15) -- 
    ,fundname varchar2(150) -- 
    ,fundtype varchar2(3) -- 
    ,iscp varchar2(3) -- 
    ,istransfer varchar2(3) -- 
    ,invest varchar2(45) -- 
    ,ispublicoffer varchar2(3) -- 
    ,impawnnum number(22) -- 
    ,netvalue number(20,2) -- 
    ,totalvalue number(20,2) -- 
    ,isborrower varchar2(3) -- 
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
grant select on ${iol_schema}.mims_si_fundinformation to ${iml_schema};
grant select on ${iol_schema}.mims_si_fundinformation to ${icl_schema};
grant select on ${iol_schema}.mims_si_fundinformation to ${idl_schema};
grant select on ${iol_schema}.mims_si_fundinformation to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_fundinformation is '基金';
comment on column ${iol_schema}.mims_si_fundinformation.sccode is '';
comment on column ${iol_schema}.mims_si_fundinformation.fundcode is '';
comment on column ${iol_schema}.mims_si_fundinformation.account is '';
comment on column ${iol_schema}.mims_si_fundinformation.issuername is '';
comment on column ${iol_schema}.mims_si_fundinformation.startdate is '';
comment on column ${iol_schema}.mims_si_fundinformation.enddate is '';
comment on column ${iol_schema}.mims_si_fundinformation.fundname is '';
comment on column ${iol_schema}.mims_si_fundinformation.fundtype is '';
comment on column ${iol_schema}.mims_si_fundinformation.iscp is '';
comment on column ${iol_schema}.mims_si_fundinformation.istransfer is '';
comment on column ${iol_schema}.mims_si_fundinformation.invest is '';
comment on column ${iol_schema}.mims_si_fundinformation.ispublicoffer is '';
comment on column ${iol_schema}.mims_si_fundinformation.impawnnum is '';
comment on column ${iol_schema}.mims_si_fundinformation.netvalue is '';
comment on column ${iol_schema}.mims_si_fundinformation.totalvalue is '';
comment on column ${iol_schema}.mims_si_fundinformation.isborrower is '';
comment on column ${iol_schema}.mims_si_fundinformation.remark is '';
comment on column ${iol_schema}.mims_si_fundinformation.tdcurrency is '';
comment on column ${iol_schema}.mims_si_fundinformation.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_fundinformation.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_fundinformation.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_fundinformation.etl_timestamp is 'ETL处理时间戳';
