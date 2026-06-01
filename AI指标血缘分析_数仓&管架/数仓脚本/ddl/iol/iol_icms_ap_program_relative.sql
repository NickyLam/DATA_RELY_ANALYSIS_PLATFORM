/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_program_relative
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_program_relative
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_program_relative purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_program_relative(
    programno varchar2(64) -- 方案编号
    ,objectno varchar2(160) -- 对象编号
    ,objecttype varchar2(160) -- 对象类型
    ,relativeno varchar2(160) -- 对象关联编号
    ,objectname varchar2(1000) -- 对象名称
    ,inputdate varchar2(64) -- 关联日期
    ,executestatus varchar2(2) -- 执行状态
    ,migtflag varchar2(80) -- 
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
grant select on ${iol_schema}.icms_ap_program_relative to ${iml_schema};
grant select on ${iol_schema}.icms_ap_program_relative to ${icl_schema};
grant select on ${iol_schema}.icms_ap_program_relative to ${idl_schema};
grant select on ${iol_schema}.icms_ap_program_relative to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_program_relative is '处置方案关联表';
comment on column ${iol_schema}.icms_ap_program_relative.programno is '方案编号';
comment on column ${iol_schema}.icms_ap_program_relative.objectno is '对象编号';
comment on column ${iol_schema}.icms_ap_program_relative.objecttype is '对象类型';
comment on column ${iol_schema}.icms_ap_program_relative.relativeno is '对象关联编号';
comment on column ${iol_schema}.icms_ap_program_relative.objectname is '对象名称';
comment on column ${iol_schema}.icms_ap_program_relative.inputdate is '关联日期';
comment on column ${iol_schema}.icms_ap_program_relative.executestatus is '执行状态';
comment on column ${iol_schema}.icms_ap_program_relative.migtflag is '';
comment on column ${iol_schema}.icms_ap_program_relative.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_program_relative.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_program_relative.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_program_relative.etl_timestamp is 'ETL处理时间戳';
