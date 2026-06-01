/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_pi_cusbasinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_pi_cusbasinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mims_pi_cusbasinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_pi_cusbasinfo(
    custid varchar2(48) -- 
    ,regioncode varchar2(6) -- 
    ,custname varchar2(180) -- 
    ,custtype varchar2(15) -- 
    ,custmgr varchar2(45) -- 
    ,deptcode varchar2(45) -- 
    ,orgcode varchar2(45) -- 
    ,cardtype varchar2(15) -- 
    ,cardno varchar2(60) -- 
    ,liwacode varchar2(60) -- 
    ,inputer varchar2(45) -- 
    ,inputdate varchar2(15) -- 
    ,modifier varchar2(45) -- 
    ,modifydate varchar2(15) -- 
    ,custlevel varchar2(3) -- 
    ,pd varchar2(15) -- 
    ,state varchar2(6) -- 
    ,corecustid varchar2(48) -- 
    ,barsign varchar2(2) -- 
    ,curbal number(16,2) -- 
    ,datasourceflag varchar2(2) -- 
    ,ecifcustcode varchar2(18) -- 
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
grant select on ${iol_schema}.mims_pi_cusbasinfo to ${iml_schema};
grant select on ${iol_schema}.mims_pi_cusbasinfo to ${icl_schema};
grant select on ${iol_schema}.mims_pi_cusbasinfo to ${idl_schema};
grant select on ${iol_schema}.mims_pi_cusbasinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_pi_cusbasinfo is '个人客户基本信息';
comment on column ${iol_schema}.mims_pi_cusbasinfo.custid is '';
comment on column ${iol_schema}.mims_pi_cusbasinfo.regioncode is '';
comment on column ${iol_schema}.mims_pi_cusbasinfo.custname is '';
comment on column ${iol_schema}.mims_pi_cusbasinfo.custtype is '';
comment on column ${iol_schema}.mims_pi_cusbasinfo.custmgr is '';
comment on column ${iol_schema}.mims_pi_cusbasinfo.deptcode is '';
comment on column ${iol_schema}.mims_pi_cusbasinfo.orgcode is '';
comment on column ${iol_schema}.mims_pi_cusbasinfo.cardtype is '';
comment on column ${iol_schema}.mims_pi_cusbasinfo.cardno is '';
comment on column ${iol_schema}.mims_pi_cusbasinfo.liwacode is '';
comment on column ${iol_schema}.mims_pi_cusbasinfo.inputer is '';
comment on column ${iol_schema}.mims_pi_cusbasinfo.inputdate is '';
comment on column ${iol_schema}.mims_pi_cusbasinfo.modifier is '';
comment on column ${iol_schema}.mims_pi_cusbasinfo.modifydate is '';
comment on column ${iol_schema}.mims_pi_cusbasinfo.custlevel is '';
comment on column ${iol_schema}.mims_pi_cusbasinfo.pd is '';
comment on column ${iol_schema}.mims_pi_cusbasinfo.state is '';
comment on column ${iol_schema}.mims_pi_cusbasinfo.corecustid is '';
comment on column ${iol_schema}.mims_pi_cusbasinfo.barsign is '';
comment on column ${iol_schema}.mims_pi_cusbasinfo.curbal is '';
comment on column ${iol_schema}.mims_pi_cusbasinfo.datasourceflag is '';
comment on column ${iol_schema}.mims_pi_cusbasinfo.ecifcustcode is '';
comment on column ${iol_schema}.mims_pi_cusbasinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mims_pi_cusbasinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mims_pi_cusbasinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mims_pi_cusbasinfo.etl_timestamp is 'ETL处理时间戳';
