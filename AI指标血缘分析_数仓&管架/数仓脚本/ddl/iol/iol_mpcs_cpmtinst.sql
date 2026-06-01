/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_cpmtinst
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_cpmtinst
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_cpmtinst purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_cpmtinst(
    instno varchar2(15) -- 
    ,upinstno varchar2(15) -- 
    ,instlvl varchar2(2) -- 
    ,instname varchar2(90) -- 
    ,instabrname varchar2(90) -- 
    ,instaddr varchar2(120) -- 
    ,instenname varchar2(90) -- 
    ,instenabrname varchar2(30) -- 
    ,instenaddr varchar2(120) -- 
    ,insttel varchar2(30) -- 
    ,instemail varchar2(90) -- 
    ,insttype varchar2(2) -- 
    ,centflag varchar2(2) -- 
    ,seqnoprefix varchar2(9) -- 
    ,acctinstlvl varchar2(2) -- 
    ,upacctinst varchar2(15) -- 
    ,bankno varchar2(18) -- 
    ,citycd varchar2(9) -- 
    ,isleaf varchar2(2) -- 
    ,rowstat varchar2(2) -- 
    ,upddt varchar2(12) -- 
    ,updtm varchar2(9) -- 
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
grant select on ${iol_schema}.mpcs_cpmtinst to ${iml_schema};
grant select on ${iol_schema}.mpcs_cpmtinst to ${icl_schema};
grant select on ${iol_schema}.mpcs_cpmtinst to ${idl_schema};
grant select on ${iol_schema}.mpcs_cpmtinst to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_cpmtinst is '';
comment on column ${iol_schema}.mpcs_cpmtinst.instno is '';
comment on column ${iol_schema}.mpcs_cpmtinst.upinstno is '';
comment on column ${iol_schema}.mpcs_cpmtinst.instlvl is '';
comment on column ${iol_schema}.mpcs_cpmtinst.instname is '';
comment on column ${iol_schema}.mpcs_cpmtinst.instabrname is '';
comment on column ${iol_schema}.mpcs_cpmtinst.instaddr is '';
comment on column ${iol_schema}.mpcs_cpmtinst.instenname is '';
comment on column ${iol_schema}.mpcs_cpmtinst.instenabrname is '';
comment on column ${iol_schema}.mpcs_cpmtinst.instenaddr is '';
comment on column ${iol_schema}.mpcs_cpmtinst.insttel is '';
comment on column ${iol_schema}.mpcs_cpmtinst.instemail is '';
comment on column ${iol_schema}.mpcs_cpmtinst.insttype is '';
comment on column ${iol_schema}.mpcs_cpmtinst.centflag is '';
comment on column ${iol_schema}.mpcs_cpmtinst.seqnoprefix is '';
comment on column ${iol_schema}.mpcs_cpmtinst.acctinstlvl is '';
comment on column ${iol_schema}.mpcs_cpmtinst.upacctinst is '';
comment on column ${iol_schema}.mpcs_cpmtinst.bankno is '';
comment on column ${iol_schema}.mpcs_cpmtinst.citycd is '';
comment on column ${iol_schema}.mpcs_cpmtinst.isleaf is '';
comment on column ${iol_schema}.mpcs_cpmtinst.rowstat is '';
comment on column ${iol_schema}.mpcs_cpmtinst.upddt is '';
comment on column ${iol_schema}.mpcs_cpmtinst.updtm is '';
comment on column ${iol_schema}.mpcs_cpmtinst.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_cpmtinst.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_cpmtinst.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_cpmtinst.etl_timestamp is 'ETL处理时间戳';
