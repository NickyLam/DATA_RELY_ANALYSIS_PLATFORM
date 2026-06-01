/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_cc_asscontract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_cc_asscontract
whenever sqlerror continue none;
drop table ${iol_schema}.mims_cc_asscontract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_cc_asscontract(
    asscontno varchar2(75) -- 
    ,assconttype varchar2(2) -- 
    ,asscustid varchar2(48) -- 
    ,assregioncode varchar2(6) -- 
    ,asscusttype varchar2(2) -- 
    ,custlevel varchar2(3) -- 
    ,assamt number(16,2) -- 
    ,currency varchar2(5) -- 
    ,assamtrmb number(16,2) -- 
    ,startdate varchar2(15) -- 
    ,enddate varchar2(15) -- 
    ,effectedstate varchar2(2) -- 
    ,endstate varchar2(2) -- 
    ,createdate varchar2(15) -- 
    ,creater varchar2(45) -- 
    ,modifydate varchar2(15) -- 
    ,modifier varchar2(45) -- 
    ,ishighestbondedcontract varchar2(2) -- 
    ,datasourceflag varchar2(2) -- 
    ,barsign varchar2(2) -- 
    ,contype varchar2(2) -- 
    ,txtasscontno varchar2(150) -- 
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
grant select on ${iol_schema}.mims_cc_asscontract to ${iml_schema};
grant select on ${iol_schema}.mims_cc_asscontract to ${icl_schema};
grant select on ${iol_schema}.mims_cc_asscontract to ${idl_schema};
grant select on ${iol_schema}.mims_cc_asscontract to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_cc_asscontract is '担保合同信息表';
comment on column ${iol_schema}.mims_cc_asscontract.asscontno is '';
comment on column ${iol_schema}.mims_cc_asscontract.assconttype is '';
comment on column ${iol_schema}.mims_cc_asscontract.asscustid is '';
comment on column ${iol_schema}.mims_cc_asscontract.assregioncode is '';
comment on column ${iol_schema}.mims_cc_asscontract.asscusttype is '';
comment on column ${iol_schema}.mims_cc_asscontract.custlevel is '';
comment on column ${iol_schema}.mims_cc_asscontract.assamt is '';
comment on column ${iol_schema}.mims_cc_asscontract.currency is '';
comment on column ${iol_schema}.mims_cc_asscontract.assamtrmb is '';
comment on column ${iol_schema}.mims_cc_asscontract.startdate is '';
comment on column ${iol_schema}.mims_cc_asscontract.enddate is '';
comment on column ${iol_schema}.mims_cc_asscontract.effectedstate is '';
comment on column ${iol_schema}.mims_cc_asscontract.endstate is '';
comment on column ${iol_schema}.mims_cc_asscontract.createdate is '';
comment on column ${iol_schema}.mims_cc_asscontract.creater is '';
comment on column ${iol_schema}.mims_cc_asscontract.modifydate is '';
comment on column ${iol_schema}.mims_cc_asscontract.modifier is '';
comment on column ${iol_schema}.mims_cc_asscontract.ishighestbondedcontract is '';
comment on column ${iol_schema}.mims_cc_asscontract.datasourceflag is '';
comment on column ${iol_schema}.mims_cc_asscontract.barsign is '';
comment on column ${iol_schema}.mims_cc_asscontract.contype is '';
comment on column ${iol_schema}.mims_cc_asscontract.txtasscontno is '';
comment on column ${iol_schema}.mims_cc_asscontract.start_dt is '开始时间';
comment on column ${iol_schema}.mims_cc_asscontract.end_dt is '结束时间';
comment on column ${iol_schema}.mims_cc_asscontract.id_mark is '增删标志';
comment on column ${iol_schema}.mims_cc_asscontract.etl_timestamp is 'ETL处理时间戳';
