/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_stresstestscenceinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_stresstestscenceinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_stresstestscenceinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_stresstestscenceinfo(
    scencecode varchar2(30) -- 
    ,scencename varchar2(150) -- 
    ,scencetype varchar2(9) -- 
    ,objecttype varchar2(9) -- 
    ,operator varchar2(30) -- 
    ,updatedate varchar2(15) -- 
    ,deptcode varchar2(30) -- 
    ,flag varchar2(3) -- 标识是否模板场景 1是 0否
    ,isforce varchar2(3) -- 标识是否生效 1是 0否
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
grant select on ${iol_schema}.mims_si_stresstestscenceinfo to ${iml_schema};
grant select on ${iol_schema}.mims_si_stresstestscenceinfo to ${icl_schema};
grant select on ${iol_schema}.mims_si_stresstestscenceinfo to ${idl_schema};
grant select on ${iol_schema}.mims_si_stresstestscenceinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_stresstestscenceinfo is '压力测试情景信息';
comment on column ${iol_schema}.mims_si_stresstestscenceinfo.scencecode is '';
comment on column ${iol_schema}.mims_si_stresstestscenceinfo.scencename is '';
comment on column ${iol_schema}.mims_si_stresstestscenceinfo.scencetype is '';
comment on column ${iol_schema}.mims_si_stresstestscenceinfo.objecttype is '';
comment on column ${iol_schema}.mims_si_stresstestscenceinfo.operator is '';
comment on column ${iol_schema}.mims_si_stresstestscenceinfo.updatedate is '';
comment on column ${iol_schema}.mims_si_stresstestscenceinfo.deptcode is '';
comment on column ${iol_schema}.mims_si_stresstestscenceinfo.flag is '标识是否模板场景 1是 0否';
comment on column ${iol_schema}.mims_si_stresstestscenceinfo.isforce is '标识是否生效 1是 0否';
comment on column ${iol_schema}.mims_si_stresstestscenceinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_stresstestscenceinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_stresstestscenceinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_stresstestscenceinfo.etl_timestamp is 'ETL处理时间戳';
