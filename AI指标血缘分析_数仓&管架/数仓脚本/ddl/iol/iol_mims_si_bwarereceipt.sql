/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_bwarereceipt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_bwarereceipt
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_bwarereceipt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_bwarereceipt(
    sccode varchar2(48) -- 
    ,warereceiptno varchar2(150) -- 
    ,startdate varchar2(15) -- 
    ,enddate varchar2(15) -- 
    ,tradename varchar2(150) -- 
    ,issuername varchar2(150) -- 
    ,issuertype varchar2(3) -- 
    ,bourse varchar2(3) -- 
    ,totalprice number(20,2) -- 
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
grant select on ${iol_schema}.mims_si_bwarereceipt to ${iml_schema};
grant select on ${iol_schema}.mims_si_bwarereceipt to ${icl_schema};
grant select on ${iol_schema}.mims_si_bwarereceipt to ${idl_schema};
grant select on ${iol_schema}.mims_si_bwarereceipt to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_bwarereceipt is '标准仓单';
comment on column ${iol_schema}.mims_si_bwarereceipt.sccode is '';
comment on column ${iol_schema}.mims_si_bwarereceipt.warereceiptno is '';
comment on column ${iol_schema}.mims_si_bwarereceipt.startdate is '';
comment on column ${iol_schema}.mims_si_bwarereceipt.enddate is '';
comment on column ${iol_schema}.mims_si_bwarereceipt.tradename is '';
comment on column ${iol_schema}.mims_si_bwarereceipt.issuername is '';
comment on column ${iol_schema}.mims_si_bwarereceipt.issuertype is '';
comment on column ${iol_schema}.mims_si_bwarereceipt.bourse is '';
comment on column ${iol_schema}.mims_si_bwarereceipt.totalprice is '';
comment on column ${iol_schema}.mims_si_bwarereceipt.remark is '';
comment on column ${iol_schema}.mims_si_bwarereceipt.tdcurrency is '';
comment on column ${iol_schema}.mims_si_bwarereceipt.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_bwarereceipt.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_bwarereceipt.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_bwarereceipt.etl_timestamp is 'ETL处理时间戳';
