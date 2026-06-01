/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_ci_custinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_ci_custinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mims_ci_custinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_ci_custinfo(
    custid varchar2(48) -- 
    ,regioncode varchar2(6) -- 
    ,custname varchar2(180) -- 
    ,custflag varchar2(30) -- 
    ,creditlevel varchar2(3) -- 
    ,pd varchar2(15) -- 
    ,lnbal number(16,2) -- 
    ,custmgr varchar2(45) -- 
    ,deptcode varchar2(45) -- 
    ,regionlayout varchar2(60) -- 
    ,branchname varchar2(180) -- 
    ,effectflag varchar2(2) -- 
    ,branchcode varchar2(45) -- 
    ,custscale varchar2(15) -- 
    ,interindustry varchar2(15) -- 
    ,thisindustry varchar2(15) -- 
    ,deptname varchar2(180) -- 
    ,cardtype varchar2(15) -- 
    ,cardid varchar2(60) -- 
    ,barsign varchar2(2) -- 
    ,corecustid varchar2(48) -- 
    ,datasourceflag varchar2(2) -- 
    ,establishdate varchar2(15) -- 
    ,ecifcustcode varchar2(30) -- 
    ,regstarea varchar2(9) -- 
    ,subscribecapital number(16,2) -- 
    ,guarmoney number(20,2) -- 
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
grant select on ${iol_schema}.mims_ci_custinfo to ${iml_schema};
grant select on ${iol_schema}.mims_ci_custinfo to ${icl_schema};
grant select on ${iol_schema}.mims_ci_custinfo to ${idl_schema};
grant select on ${iol_schema}.mims_ci_custinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_ci_custinfo is '法人与个人客户汇总信息';
comment on column ${iol_schema}.mims_ci_custinfo.custid is '';
comment on column ${iol_schema}.mims_ci_custinfo.regioncode is '';
comment on column ${iol_schema}.mims_ci_custinfo.custname is '';
comment on column ${iol_schema}.mims_ci_custinfo.custflag is '';
comment on column ${iol_schema}.mims_ci_custinfo.creditlevel is '';
comment on column ${iol_schema}.mims_ci_custinfo.pd is '';
comment on column ${iol_schema}.mims_ci_custinfo.lnbal is '';
comment on column ${iol_schema}.mims_ci_custinfo.custmgr is '';
comment on column ${iol_schema}.mims_ci_custinfo.deptcode is '';
comment on column ${iol_schema}.mims_ci_custinfo.regionlayout is '';
comment on column ${iol_schema}.mims_ci_custinfo.branchname is '';
comment on column ${iol_schema}.mims_ci_custinfo.effectflag is '';
comment on column ${iol_schema}.mims_ci_custinfo.branchcode is '';
comment on column ${iol_schema}.mims_ci_custinfo.custscale is '';
comment on column ${iol_schema}.mims_ci_custinfo.interindustry is '';
comment on column ${iol_schema}.mims_ci_custinfo.thisindustry is '';
comment on column ${iol_schema}.mims_ci_custinfo.deptname is '';
comment on column ${iol_schema}.mims_ci_custinfo.cardtype is '';
comment on column ${iol_schema}.mims_ci_custinfo.cardid is '';
comment on column ${iol_schema}.mims_ci_custinfo.barsign is '';
comment on column ${iol_schema}.mims_ci_custinfo.corecustid is '';
comment on column ${iol_schema}.mims_ci_custinfo.datasourceflag is '';
comment on column ${iol_schema}.mims_ci_custinfo.establishdate is '';
comment on column ${iol_schema}.mims_ci_custinfo.ecifcustcode is '';
comment on column ${iol_schema}.mims_ci_custinfo.regstarea is '';
comment on column ${iol_schema}.mims_ci_custinfo.subscribecapital is '';
comment on column ${iol_schema}.mims_ci_custinfo.guarmoney is '';
comment on column ${iol_schema}.mims_ci_custinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mims_ci_custinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mims_ci_custinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mims_ci_custinfo.etl_timestamp is 'ETL处理时间戳';
