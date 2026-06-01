/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_isbs_wfe
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_isbs_wfe
whenever sqlerror continue none;
drop table ${idl_schema}.aml_isbs_wfe purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_isbs_wfe(
    etl_dt date -- 数据日期
    ,wfsinr varchar2(8) -- WFS ID
    ,wfssub varchar2(6) -- WFS记录内子ID
    ,srv varchar2(6) -- 服务名
    ,sta varchar2(1) -- 状态
    ,rtycnt number(6) -- 重试次数
    ,tardattim timestamp(6) -- 计划完成时间
    ,ssninr varchar2(8) -- 最近操作SSN ID
    ,dattim timestamp(6) -- 最近操作时间
    ,txt varchar2(183) -- 操作事件描述
    ,manflg varchar2(1) -- 是否手工干预
    ,opndur number(10) -- Open状态持续时间
    ,waidur number(10) -- Waiting状态持续时间
    ,retdur number(10) -- Retry状态持续时间
    ,hdldur number(10) -- 处理时间
    ,bchkeyinr varchar2(8) -- 经办机构号
    ,txt2 varchar2(183) -- 冲证描述
    ,itfinr varchar2(64) -- 接口流水号
    ,coreinr varchar2(100) -- 
    ,czinr varchar2(64) -- 
    ,itfdate varchar2(8) -- 
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_isbs_wfe to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_isbs_wfe is '工作流记录';
comment on column ${idl_schema}.aml_isbs_wfe.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_isbs_wfe.wfsinr is 'WFS ID';
comment on column ${idl_schema}.aml_isbs_wfe.wfssub is 'WFS记录内子ID';
comment on column ${idl_schema}.aml_isbs_wfe.srv is '服务名';
comment on column ${idl_schema}.aml_isbs_wfe.sta is '状态';
comment on column ${idl_schema}.aml_isbs_wfe.rtycnt is '重试次数';
comment on column ${idl_schema}.aml_isbs_wfe.tardattim is '计划完成时间';
comment on column ${idl_schema}.aml_isbs_wfe.ssninr is '最近操作SSN ID';
comment on column ${idl_schema}.aml_isbs_wfe.dattim is '最近操作时间';
comment on column ${idl_schema}.aml_isbs_wfe.txt is '操作事件描述';
comment on column ${idl_schema}.aml_isbs_wfe.manflg is '是否手工干预';
comment on column ${idl_schema}.aml_isbs_wfe.opndur is 'Open状态持续时间';
comment on column ${idl_schema}.aml_isbs_wfe.waidur is 'Waiting状态持续时间';
comment on column ${idl_schema}.aml_isbs_wfe.retdur is 'Retry状态持续时间';
comment on column ${idl_schema}.aml_isbs_wfe.hdldur is '处理时间';
comment on column ${idl_schema}.aml_isbs_wfe.bchkeyinr is '经办机构号';
comment on column ${idl_schema}.aml_isbs_wfe.txt2 is '冲证描述';
comment on column ${idl_schema}.aml_isbs_wfe.itfinr is '接口流水号';
comment on column ${idl_schema}.aml_isbs_wfe.coreinr is '';
comment on column ${idl_schema}.aml_isbs_wfe.czinr is '';
comment on column ${idl_schema}.aml_isbs_wfe.itfdate is '';
comment on column ${idl_schema}.aml_isbs_wfe.etl_timestamp is '数据处理时间';
