/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_securityinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_securityinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_securityinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_securityinfo(
    sccode varchar2(48) -- 
    ,guartype varchar2(30) -- 
    ,createuser varchar2(30) -- 
    ,deptcode varchar2(30) -- 
    ,createdate varchar2(15) -- 
    ,conominium varchar2(2) -- 
    ,conshare number(5,2) -- 
    ,effecttype varchar2(3) -- 
    ,isinsure varchar2(2) -- 
    ,guaregisterstate varchar2(3) -- 
    ,guainsurestate varchar2(3) -- 
    ,state varchar2(3) -- 
    ,usestate varchar2(3) -- 
    ,guaspecialstate varchar2(3) -- 
    ,bxability varchar2(2) -- 
    ,isotherguar varchar2(2) -- 
    ,isgencust varchar2(2) -- 
    ,confmamt number(20,2) -- 
    ,confmcurrency varchar2(5) -- 
    ,evaldate varchar2(15) -- 
    ,datasourceflag varchar2(2) -- 
    ,exapstate varchar2(2) -- 
    ,editstate varchar2(2) -- 
    ,bxability2 varchar2(2) -- 
    ,isgain varchar2(2) -- 
    ,ismodify varchar2(2) -- 
    ,guarinfoname varchar2(300) -- 
    ,controlchange varchar2(3) -- 
    ,updates varchar2(15) -- 
    ,upduser varchar2(30) -- 
    ,issaveowner varchar2(2) -- 是否保存我行
    ,amount number(24,2) -- 优先受偿权数额
    ,issequence varchar2(2) -- 是否第一顺位 c0101         0 否、1 是
    ,guarsign varchar2(3) -- 
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
grant select on ${iol_schema}.mims_si_securityinfo to ${iml_schema};
grant select on ${iol_schema}.mims_si_securityinfo to ${icl_schema};
grant select on ${iol_schema}.mims_si_securityinfo to ${idl_schema};
grant select on ${iol_schema}.mims_si_securityinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_securityinfo is '押品基本信息表';
comment on column ${iol_schema}.mims_si_securityinfo.sccode is '';
comment on column ${iol_schema}.mims_si_securityinfo.guartype is '';
comment on column ${iol_schema}.mims_si_securityinfo.createuser is '';
comment on column ${iol_schema}.mims_si_securityinfo.deptcode is '';
comment on column ${iol_schema}.mims_si_securityinfo.createdate is '';
comment on column ${iol_schema}.mims_si_securityinfo.conominium is '';
comment on column ${iol_schema}.mims_si_securityinfo.conshare is '';
comment on column ${iol_schema}.mims_si_securityinfo.effecttype is '';
comment on column ${iol_schema}.mims_si_securityinfo.isinsure is '';
comment on column ${iol_schema}.mims_si_securityinfo.guaregisterstate is '';
comment on column ${iol_schema}.mims_si_securityinfo.guainsurestate is '';
comment on column ${iol_schema}.mims_si_securityinfo.state is '';
comment on column ${iol_schema}.mims_si_securityinfo.usestate is '';
comment on column ${iol_schema}.mims_si_securityinfo.guaspecialstate is '';
comment on column ${iol_schema}.mims_si_securityinfo.bxability is '';
comment on column ${iol_schema}.mims_si_securityinfo.isotherguar is '';
comment on column ${iol_schema}.mims_si_securityinfo.isgencust is '';
comment on column ${iol_schema}.mims_si_securityinfo.confmamt is '';
comment on column ${iol_schema}.mims_si_securityinfo.confmcurrency is '';
comment on column ${iol_schema}.mims_si_securityinfo.evaldate is '';
comment on column ${iol_schema}.mims_si_securityinfo.datasourceflag is '';
comment on column ${iol_schema}.mims_si_securityinfo.exapstate is '';
comment on column ${iol_schema}.mims_si_securityinfo.editstate is '';
comment on column ${iol_schema}.mims_si_securityinfo.bxability2 is '';
comment on column ${iol_schema}.mims_si_securityinfo.isgain is '';
comment on column ${iol_schema}.mims_si_securityinfo.ismodify is '';
comment on column ${iol_schema}.mims_si_securityinfo.guarinfoname is '';
comment on column ${iol_schema}.mims_si_securityinfo.controlchange is '';
comment on column ${iol_schema}.mims_si_securityinfo.updates is '';
comment on column ${iol_schema}.mims_si_securityinfo.upduser is '';
comment on column ${iol_schema}.mims_si_securityinfo.issaveowner is '是否保存我行';
comment on column ${iol_schema}.mims_si_securityinfo.amount is '优先受偿权数额';
comment on column ${iol_schema}.mims_si_securityinfo.issequence is '是否第一顺位 c0101         0 否、1 是';
comment on column ${iol_schema}.mims_si_securityinfo.guarsign is '';
comment on column ${iol_schema}.mims_si_securityinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_securityinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_securityinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_securityinfo.etl_timestamp is 'ETL处理时间戳';
