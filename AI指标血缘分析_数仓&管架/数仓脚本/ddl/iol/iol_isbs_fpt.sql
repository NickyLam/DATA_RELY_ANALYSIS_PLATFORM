/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_fpt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_fpt
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_fpt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_fpt(
    inr varchar2(12) -- 主键
    ,contctnam varchar2(198) -- 合同名称
    ,ver varchar2(6) -- 版本号
    ,addamtcov varchar2(216) -- 保证金附加额
    ,fldmodblk varchar2(4000) -- 修改信息
    ,comdet varchar2(324) -- 帐目类型
    ,fptdet varchar2(4000) -- 单据币别类型
    ,narhis varchar2(4000) -- 名称
    ,tendet varchar2(270) -- 外部关键字
    ,contag72 varchar2(4000) -- tag 72内容
    ,contag79 varchar2(4000) -- 收到报文的79域信息
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
grant select on ${iol_schema}.isbs_fpt to ${iml_schema};
grant select on ${iol_schema}.isbs_fpt to ${icl_schema};
grant select on ${iol_schema}.isbs_fpt to ${idl_schema};
grant select on ${iol_schema}.isbs_fpt to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_fpt is '福费廷业务信息表';
comment on column ${iol_schema}.isbs_fpt.inr is '主键';
comment on column ${iol_schema}.isbs_fpt.contctnam is '合同名称';
comment on column ${iol_schema}.isbs_fpt.ver is '版本号';
comment on column ${iol_schema}.isbs_fpt.addamtcov is '保证金附加额';
comment on column ${iol_schema}.isbs_fpt.fldmodblk is '修改信息';
comment on column ${iol_schema}.isbs_fpt.comdet is '帐目类型';
comment on column ${iol_schema}.isbs_fpt.fptdet is '单据币别类型';
comment on column ${iol_schema}.isbs_fpt.narhis is '名称';
comment on column ${iol_schema}.isbs_fpt.tendet is '外部关键字';
comment on column ${iol_schema}.isbs_fpt.contag72 is 'tag 72内容';
comment on column ${iol_schema}.isbs_fpt.contag79 is '收到报文的79域信息';
comment on column ${iol_schema}.isbs_fpt.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_fpt.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_fpt.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_fpt.etl_timestamp is 'ETL处理时间戳';
