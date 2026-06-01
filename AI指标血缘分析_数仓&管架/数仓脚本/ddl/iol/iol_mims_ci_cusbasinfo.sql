/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_ci_cusbasinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_ci_cusbasinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mims_ci_cusbasinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_ci_cusbasinfo(
    custid varchar2(48) -- 
    ,regioncode varchar2(6) -- 
    ,custcname varchar2(180) -- 
    ,orgcertcode varchar2(45) -- 
    ,interindustry varchar2(15) -- 
    ,thisindustry varchar2(15) -- 
    ,custscale varchar2(15) -- 
    ,custmgr varchar2(45) -- 
    ,deptcode varchar2(45) -- 
    ,orgcode varchar2(45) -- 
    ,state varchar2(2) -- 
    ,custtype varchar2(6) -- 
    ,custlevel varchar2(3) -- 
    ,pd varchar2(15) -- 
    ,inputdate varchar2(15) -- 
    ,inputer varchar2(45) -- 
    ,modifydate varchar2(15) -- 
    ,modifier varchar2(45) -- 
    ,curbal number(16,2) -- 
    ,liwacode varchar2(60) -- 
    ,corecustid varchar2(48) -- 
    ,barsign varchar2(2) -- 
    ,datasourceflag varchar2(2) -- 
    ,establishdate varchar2(15) -- 
    ,ecifcustcode varchar2(18) -- 
    ,certificatetype varchar2(8) -- 
    ,regstarea varchar2(9) -- 
    ,subscribecapital number(16,2) -- 
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
grant select on ${iol_schema}.mims_ci_cusbasinfo to ${iml_schema};
grant select on ${iol_schema}.mims_ci_cusbasinfo to ${icl_schema};
grant select on ${iol_schema}.mims_ci_cusbasinfo to ${idl_schema};
grant select on ${iol_schema}.mims_ci_cusbasinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_ci_cusbasinfo is '法人客户基本信息';
comment on column ${iol_schema}.mims_ci_cusbasinfo.custid is '';
comment on column ${iol_schema}.mims_ci_cusbasinfo.regioncode is '';
comment on column ${iol_schema}.mims_ci_cusbasinfo.custcname is '';
comment on column ${iol_schema}.mims_ci_cusbasinfo.orgcertcode is '';
comment on column ${iol_schema}.mims_ci_cusbasinfo.interindustry is '';
comment on column ${iol_schema}.mims_ci_cusbasinfo.thisindustry is '';
comment on column ${iol_schema}.mims_ci_cusbasinfo.custscale is '';
comment on column ${iol_schema}.mims_ci_cusbasinfo.custmgr is '';
comment on column ${iol_schema}.mims_ci_cusbasinfo.deptcode is '';
comment on column ${iol_schema}.mims_ci_cusbasinfo.orgcode is '';
comment on column ${iol_schema}.mims_ci_cusbasinfo.state is '';
comment on column ${iol_schema}.mims_ci_cusbasinfo.custtype is '';
comment on column ${iol_schema}.mims_ci_cusbasinfo.custlevel is '';
comment on column ${iol_schema}.mims_ci_cusbasinfo.pd is '';
comment on column ${iol_schema}.mims_ci_cusbasinfo.inputdate is '';
comment on column ${iol_schema}.mims_ci_cusbasinfo.inputer is '';
comment on column ${iol_schema}.mims_ci_cusbasinfo.modifydate is '';
comment on column ${iol_schema}.mims_ci_cusbasinfo.modifier is '';
comment on column ${iol_schema}.mims_ci_cusbasinfo.curbal is '';
comment on column ${iol_schema}.mims_ci_cusbasinfo.liwacode is '';
comment on column ${iol_schema}.mims_ci_cusbasinfo.corecustid is '';
comment on column ${iol_schema}.mims_ci_cusbasinfo.barsign is '';
comment on column ${iol_schema}.mims_ci_cusbasinfo.datasourceflag is '';
comment on column ${iol_schema}.mims_ci_cusbasinfo.establishdate is '';
comment on column ${iol_schema}.mims_ci_cusbasinfo.ecifcustcode is '';
comment on column ${iol_schema}.mims_ci_cusbasinfo.certificatetype is '';
comment on column ${iol_schema}.mims_ci_cusbasinfo.regstarea is '';
comment on column ${iol_schema}.mims_ci_cusbasinfo.subscribecapital is '';
comment on column ${iol_schema}.mims_ci_cusbasinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mims_ci_cusbasinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mims_ci_cusbasinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mims_ci_cusbasinfo.etl_timestamp is 'ETL处理时间戳';
