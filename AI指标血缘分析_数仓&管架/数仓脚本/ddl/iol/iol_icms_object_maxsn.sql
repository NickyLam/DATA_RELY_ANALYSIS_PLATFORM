/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_object_maxsn
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_object_maxsn
whenever sqlerror continue none;
drop table ${iol_schema}.icms_object_maxsn purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_object_maxsn(
    tablename varchar2(160) -- 表名
    ,maxserialno varchar2(160) -- 最大数
    ,nofmt varchar2(64) -- 流水号模式
    ,inputdate date -- 登记日期
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,inputorgid varchar2(64) -- 登记机构
    ,updateuserid varchar2(64) -- 更新人
    ,datefmt varchar2(64) -- 日期模式
    ,inputuserid varchar2(64) -- 登记人
    ,columnname varchar2(160) -- 列名
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
grant select on ${iol_schema}.icms_object_maxsn to ${iml_schema};
grant select on ${iol_schema}.icms_object_maxsn to ${icl_schema};
grant select on ${iol_schema}.icms_object_maxsn to ${idl_schema};
grant select on ${iol_schema}.icms_object_maxsn to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_object_maxsn is '系统流水表系统流水号表';
comment on column ${iol_schema}.icms_object_maxsn.tablename is '表名';
comment on column ${iol_schema}.icms_object_maxsn.maxserialno is '最大数';
comment on column ${iol_schema}.icms_object_maxsn.nofmt is '流水号模式';
comment on column ${iol_schema}.icms_object_maxsn.inputdate is '登记日期';
comment on column ${iol_schema}.icms_object_maxsn.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_object_maxsn.updatedate is '更新日期';
comment on column ${iol_schema}.icms_object_maxsn.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_object_maxsn.updateuserid is '更新人';
comment on column ${iol_schema}.icms_object_maxsn.datefmt is '日期模式';
comment on column ${iol_schema}.icms_object_maxsn.inputuserid is '登记人';
comment on column ${iol_schema}.icms_object_maxsn.columnname is '列名';
comment on column ${iol_schema}.icms_object_maxsn.start_dt is '开始时间';
comment on column ${iol_schema}.icms_object_maxsn.end_dt is '结束时间';
comment on column ${iol_schema}.icms_object_maxsn.id_mark is '增删标志';
comment on column ${iol_schema}.icms_object_maxsn.etl_timestamp is 'ETL处理时间戳';
