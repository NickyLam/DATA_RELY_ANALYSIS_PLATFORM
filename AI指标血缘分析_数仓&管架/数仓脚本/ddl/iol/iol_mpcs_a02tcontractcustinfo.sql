/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a02tcontractcustinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a02tcontractcustinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a02tcontractcustinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a02tcontractcustinfo(
    maincontractno varchar2(21) -- 
    ,contractno varchar2(15) -- 
    ,custno varchar2(30) -- 
    ,signdt varchar2(12) -- 
    ,signbrcno varchar2(15) -- 
    ,signtlrno varchar2(15) -- 
    ,signseqno varchar2(21) -- 
    ,unsigndt varchar2(15) -- 
    ,unsignbrcno varchar2(15) -- 
    ,unsigntlrno varchar2(15) -- 
    ,unsignseqno varchar2(21) -- 
    ,contractstat varchar2(2) -- 
    ,memo varchar2(75) -- 
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
grant select on ${iol_schema}.mpcs_a02tcontractcustinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a02tcontractcustinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a02tcontractcustinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a02tcontractcustinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a02tcontractcustinfo is '';
comment on column ${iol_schema}.mpcs_a02tcontractcustinfo.maincontractno is '';
comment on column ${iol_schema}.mpcs_a02tcontractcustinfo.contractno is '';
comment on column ${iol_schema}.mpcs_a02tcontractcustinfo.custno is '';
comment on column ${iol_schema}.mpcs_a02tcontractcustinfo.signdt is '';
comment on column ${iol_schema}.mpcs_a02tcontractcustinfo.signbrcno is '';
comment on column ${iol_schema}.mpcs_a02tcontractcustinfo.signtlrno is '';
comment on column ${iol_schema}.mpcs_a02tcontractcustinfo.signseqno is '';
comment on column ${iol_schema}.mpcs_a02tcontractcustinfo.unsigndt is '';
comment on column ${iol_schema}.mpcs_a02tcontractcustinfo.unsignbrcno is '';
comment on column ${iol_schema}.mpcs_a02tcontractcustinfo.unsigntlrno is '';
comment on column ${iol_schema}.mpcs_a02tcontractcustinfo.unsignseqno is '';
comment on column ${iol_schema}.mpcs_a02tcontractcustinfo.contractstat is '';
comment on column ${iol_schema}.mpcs_a02tcontractcustinfo.memo is '';
comment on column ${iol_schema}.mpcs_a02tcontractcustinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a02tcontractcustinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a02tcontractcustinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a02tcontractcustinfo.etl_timestamp is 'ETL处理时间戳';
