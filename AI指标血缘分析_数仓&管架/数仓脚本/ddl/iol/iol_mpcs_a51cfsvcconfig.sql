/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a51cfsvcconfig
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a51cfsvcconfig
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a51cfsvcconfig purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a51cfsvcconfig(
    cfgcode varchar2(12) -- 业务配置码
    ,levela varchar2(30) -- 业务配置级别a
    ,levelb varchar2(30) -- 业务配置级别b
    ,levelc varchar2(30) -- 业务配置级别c
    ,leveld varchar2(30) -- 业务配置级别d
    ,levele varchar2(30) -- 业务配置级别e
    ,brnlevel varchar2(3) -- 适用机构级别
    ,brnnbr varchar2(9) -- 适用的机构号
    ,lowerval number(15,2) -- 数字型级别的下限
    ,value1 varchar2(30) -- 业务配置值1
    ,value2 varchar2(30) -- 业务配置值2
    ,value3 varchar2(30) -- 业务配置值3
    ,value4 varchar2(30) -- 业务配置值4
    ,value5 varchar2(30) -- 业务配置值5
    ,value6 varchar2(30) -- 业务配置值6
    ,value7 varchar2(30) -- 业务配置值7
    ,value8 varchar2(30) -- 业务配置值8
    ,value9 varchar2(30) -- 业务配置值9
    ,value10 varchar2(30) -- 业务配置值10
    ,cfgnbr varchar2(9) -- 业务配置号
    ,cfgrem varchar2(93) -- 业务配置说明
    ,prodnbr varchar2(18) -- 管理产品实例号
    ,changdate number(22) -- 更新日期
    ,changtime number(22) -- 更新时间
    ,reserv20 varchar2(30) -- 特殊码20
    ,rcdver number(22) -- 记录更新版本号
    ,rcdstatus varchar2(2) -- 记录状态
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
grant select on ${iol_schema}.mpcs_a51cfsvcconfig to ${iml_schema};
grant select on ${iol_schema}.mpcs_a51cfsvcconfig to ${icl_schema};
grant select on ${iol_schema}.mpcs_a51cfsvcconfig to ${idl_schema};
grant select on ${iol_schema}.mpcs_a51cfsvcconfig to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a51cfsvcconfig is '业务参数配置表';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.cfgcode is '业务配置码';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.levela is '业务配置级别a';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.levelb is '业务配置级别b';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.levelc is '业务配置级别c';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.leveld is '业务配置级别d';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.levele is '业务配置级别e';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.brnlevel is '适用机构级别';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.brnnbr is '适用的机构号';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.lowerval is '数字型级别的下限';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.value1 is '业务配置值1';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.value2 is '业务配置值2';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.value3 is '业务配置值3';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.value4 is '业务配置值4';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.value5 is '业务配置值5';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.value6 is '业务配置值6';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.value7 is '业务配置值7';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.value8 is '业务配置值8';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.value9 is '业务配置值9';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.value10 is '业务配置值10';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.cfgnbr is '业务配置号';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.cfgrem is '业务配置说明';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.prodnbr is '管理产品实例号';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.changdate is '更新日期';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.changtime is '更新时间';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.reserv20 is '特殊码20';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.rcdver is '记录更新版本号';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.rcdstatus is '记录状态';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a51cfsvcconfig.etl_timestamp is 'ETL处理时间戳';
