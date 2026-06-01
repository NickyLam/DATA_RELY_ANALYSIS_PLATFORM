/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_guarantyinfochange
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_guarantyinfochange
whenever sqlerror continue none;
drop table ${iol_schema}.icms_guarantyinfochange purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_guarantyinfochange(
    serialno varchar2(40) -- 流水号
    ,firstconfirmvlaue number(24,6) -- 初始认定价值
    ,inputdate date -- 登记日期
    ,updateorgid varchar2(12) -- 更新机构
    ,updateuserid varchar2(8) -- 更信人
    ,migtflag varchar2(80) -- 
    ,inputuserid varchar2(8) -- 登记人
    ,updatedate date -- 更新日期
    ,dynamicconfirmvalue number(24,6) -- 动态认定价值
    ,objectno varchar2(32) -- 对象号
    ,guarantyname varchar2(200) -- 押品名称
    ,inputorgid varchar2(32) -- 登记机构
    ,dynamicconfirmtime varchar2(20) -- 动态认定时间
    ,guarantyrate number(24,6) -- 抵质押物对本息覆盖
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
grant select on ${iol_schema}.icms_guarantyinfochange to ${iml_schema};
grant select on ${iol_schema}.icms_guarantyinfochange to ${icl_schema};
grant select on ${iol_schema}.icms_guarantyinfochange to ${idl_schema};
grant select on ${iol_schema}.icms_guarantyinfochange to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_guarantyinfochange is '押品变化情况';
comment on column ${iol_schema}.icms_guarantyinfochange.serialno is '流水号';
comment on column ${iol_schema}.icms_guarantyinfochange.firstconfirmvlaue is '初始认定价值';
comment on column ${iol_schema}.icms_guarantyinfochange.inputdate is '登记日期';
comment on column ${iol_schema}.icms_guarantyinfochange.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_guarantyinfochange.updateuserid is '更信人';
comment on column ${iol_schema}.icms_guarantyinfochange.migtflag is '';
comment on column ${iol_schema}.icms_guarantyinfochange.inputuserid is '登记人';
comment on column ${iol_schema}.icms_guarantyinfochange.updatedate is '更新日期';
comment on column ${iol_schema}.icms_guarantyinfochange.dynamicconfirmvalue is '动态认定价值';
comment on column ${iol_schema}.icms_guarantyinfochange.objectno is '对象号';
comment on column ${iol_schema}.icms_guarantyinfochange.guarantyname is '押品名称';
comment on column ${iol_schema}.icms_guarantyinfochange.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_guarantyinfochange.dynamicconfirmtime is '动态认定时间';
comment on column ${iol_schema}.icms_guarantyinfochange.guarantyrate is '抵质押物对本息覆盖';
comment on column ${iol_schema}.icms_guarantyinfochange.start_dt is '开始时间';
comment on column ${iol_schema}.icms_guarantyinfochange.end_dt is '结束时间';
comment on column ${iol_schema}.icms_guarantyinfochange.id_mark is '增删标志';
comment on column ${iol_schema}.icms_guarantyinfochange.etl_timestamp is 'ETL处理时间戳';
