/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_guarwarrantsinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_guarwarrantsinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_guarwarrantsinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_guarwarrantsinfo(
    guartype varchar2(30) -- 
    ,guarname varchar2(450) -- 
    ,upguartype varchar2(30) -- 
    ,levelcode number(22) -- 
    ,isleaf varchar2(2) -- 
    ,tname varchar2(180) -- 
    ,financialcolumn varchar2(45) -- 
    ,keycolumn varchar2(90) -- 
    ,effecttype varchar2(3) -- 
    ,controlwarrants varchar2(45) -- 
    ,companyguarrate number(9,4) -- 
    ,personalguarrate number(9,4) -- 
    ,smallcompanyguarrate number(9,4) -- 
    ,guaranteeaccexplain varchar2(600) -- 
    ,state varchar2(2) -- 
    ,allenterystatus varchar2(6) -- 
    ,financespecialinfo varchar2(45) -- 
    ,datavalidation varchar2(3) -- 
    ,reportvalidation varchar2(2) -- 
    ,motime varchar2(15) -- 
    ,deptcode varchar2(30) -- 
    ,isall varchar2(2) -- 
    ,datatype varchar2(2) -- 
    ,guaranteetype varchar2(15) -- 
    ,modifier varchar2(30) -- 
    ,evalfrequency varchar2(3) -- 
    ,risklevel number(22) -- 
    ,highestguarrate number(9,4) -- 
    ,keycolumn1 varchar2(90) -- 
    ,genera varchar2(30) -- 
    ,isneedpeoplecheck varchar2(2) -- 
    ,fz number(22) -- 
    ,barsign varchar2(2) -- 
    ,jzcp varchar2(30) -- 
    ,abtype varchar2(2) -- 
    ,isunion varchar2(2) -- 
    ,idneeduniquecheck varchar2(2) -- 
    ,coltypesubmcali varchar2(2) -- 押品大类
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
grant select on ${iol_schema}.mims_si_guarwarrantsinfo to ${iml_schema};
grant select on ${iol_schema}.mims_si_guarwarrantsinfo to ${icl_schema};
grant select on ${iol_schema}.mims_si_guarwarrantsinfo to ${idl_schema};
grant select on ${iol_schema}.mims_si_guarwarrantsinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_guarwarrantsinfo is '押品类型定义表';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.guartype is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.guarname is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.upguartype is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.levelcode is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.isleaf is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.tname is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.financialcolumn is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.keycolumn is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.effecttype is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.controlwarrants is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.companyguarrate is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.personalguarrate is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.smallcompanyguarrate is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.guaranteeaccexplain is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.state is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.allenterystatus is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.financespecialinfo is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.datavalidation is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.reportvalidation is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.motime is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.deptcode is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.isall is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.datatype is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.guaranteetype is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.modifier is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.evalfrequency is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.risklevel is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.highestguarrate is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.keycolumn1 is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.genera is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.isneedpeoplecheck is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.fz is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.barsign is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.jzcp is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.abtype is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.isunion is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.idneeduniquecheck is '';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.coltypesubmcali is '押品大类';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_guarwarrantsinfo.etl_timestamp is 'ETL处理时间戳';
