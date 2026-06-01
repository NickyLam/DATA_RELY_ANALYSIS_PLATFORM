/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a02tcontractinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a02tcontractinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a02tcontractinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a02tcontractinfo(
    contractno varchar2(15) -- 
    ,contractname varchar2(45) -- 
    ,contracttype varchar2(3) -- 
    ,contractupdflag varchar2(3) -- 
    ,thirdcode varchar2(15) -- 
    ,allowcusttype varchar2(2) -- 
    ,labelno number(22) -- 
    ,serialno number(22) -- 
    ,maxcontractnum varchar2(15) -- 
    ,closeacctflag varchar2(2) -- 
    ,outbrcflag varchar2(2) -- 
    ,changeflag varchar2(2) -- 
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
grant select on ${iol_schema}.mpcs_a02tcontractinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a02tcontractinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a02tcontractinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a02tcontractinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a02tcontractinfo is '';
comment on column ${iol_schema}.mpcs_a02tcontractinfo.contractno is '';
comment on column ${iol_schema}.mpcs_a02tcontractinfo.contractname is '';
comment on column ${iol_schema}.mpcs_a02tcontractinfo.contracttype is '';
comment on column ${iol_schema}.mpcs_a02tcontractinfo.contractupdflag is '';
comment on column ${iol_schema}.mpcs_a02tcontractinfo.thirdcode is '';
comment on column ${iol_schema}.mpcs_a02tcontractinfo.allowcusttype is '';
comment on column ${iol_schema}.mpcs_a02tcontractinfo.labelno is '';
comment on column ${iol_schema}.mpcs_a02tcontractinfo.serialno is '';
comment on column ${iol_schema}.mpcs_a02tcontractinfo.maxcontractnum is '';
comment on column ${iol_schema}.mpcs_a02tcontractinfo.closeacctflag is '';
comment on column ${iol_schema}.mpcs_a02tcontractinfo.outbrcflag is '';
comment on column ${iol_schema}.mpcs_a02tcontractinfo.changeflag is '';
comment on column ${iol_schema}.mpcs_a02tcontractinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a02tcontractinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a02tcontractinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a02tcontractinfo.etl_timestamp is 'ETL处理时间戳';
