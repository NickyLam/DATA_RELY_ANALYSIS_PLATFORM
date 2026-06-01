/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_stresstestinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_stresstestinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_stresstestinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_stresstestinfo(
    testcode varchar2(30) -- 
    ,scencecode varchar2(30) -- 
    ,scencename varchar2(150) -- 
    ,scencetype varchar2(3) -- 
    ,objecttype varchar2(9) -- 作用对象类型 01：抵质押覆盖率和抵质押未覆盖贷款余额 02：债项评级
    ,operator varchar2(30) -- 
    ,updatedate varchar2(15) -- 
    ,deptcode varchar2(30) -- 
    ,testdate varchar2(15) -- 
    ,state varchar2(2) -- 
    ,norrmalcoverbal number(20,2) -- 
    ,abnorrmalcoverbal number(20,2) -- 
    ,norrmalnotcoverbal number(20,2) -- 
    ,abnorrmalnotcoverbal number(20,2) -- 
    ,businessinsid varchar2(45) -- 
    ,flag varchar2(3) -- 标识 01：抵质押覆盖率和抵质押未覆盖贷款余额 02：债项评级
    ,ispl varchar2(3) -- 是否夜间批量自动生成任务
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
grant select on ${iol_schema}.mims_si_stresstestinfo to ${iml_schema};
grant select on ${iol_schema}.mims_si_stresstestinfo to ${icl_schema};
grant select on ${iol_schema}.mims_si_stresstestinfo to ${idl_schema};
grant select on ${iol_schema}.mims_si_stresstestinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_stresstestinfo is '压力测试信息';
comment on column ${iol_schema}.mims_si_stresstestinfo.testcode is '';
comment on column ${iol_schema}.mims_si_stresstestinfo.scencecode is '';
comment on column ${iol_schema}.mims_si_stresstestinfo.scencename is '';
comment on column ${iol_schema}.mims_si_stresstestinfo.scencetype is '';
comment on column ${iol_schema}.mims_si_stresstestinfo.objecttype is '作用对象类型 01：抵质押覆盖率和抵质押未覆盖贷款余额 02：债项评级';
comment on column ${iol_schema}.mims_si_stresstestinfo.operator is '';
comment on column ${iol_schema}.mims_si_stresstestinfo.updatedate is '';
comment on column ${iol_schema}.mims_si_stresstestinfo.deptcode is '';
comment on column ${iol_schema}.mims_si_stresstestinfo.testdate is '';
comment on column ${iol_schema}.mims_si_stresstestinfo.state is '';
comment on column ${iol_schema}.mims_si_stresstestinfo.norrmalcoverbal is '';
comment on column ${iol_schema}.mims_si_stresstestinfo.abnorrmalcoverbal is '';
comment on column ${iol_schema}.mims_si_stresstestinfo.norrmalnotcoverbal is '';
comment on column ${iol_schema}.mims_si_stresstestinfo.abnorrmalnotcoverbal is '';
comment on column ${iol_schema}.mims_si_stresstestinfo.businessinsid is '';
comment on column ${iol_schema}.mims_si_stresstestinfo.flag is '标识 01：抵质押覆盖率和抵质押未覆盖贷款余额 02：债项评级';
comment on column ${iol_schema}.mims_si_stresstestinfo.ispl is '是否夜间批量自动生成任务';
comment on column ${iol_schema}.mims_si_stresstestinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_stresstestinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_stresstestinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_stresstestinfo.etl_timestamp is 'ETL处理时间戳';
