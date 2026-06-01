/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_transfer_history
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_transfer_history
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_transfer_history purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_transfer_history(
    serialno varchar2(192) -- 记录流水号
    ,clrid varchar2(96) -- 押品编号
    ,clrname varchar2(600) -- 押品名称
    ,clrtypeid varchar2(96) -- 押品资产类型编号
    ,oldmanageid varchar2(192) -- 原管户人用户编号
    ,oldmanageorg varchar2(192) -- 原管户人所属机构编号
    ,newmanageid varchar2(192) -- 新管户人用户编号
    ,newmanageorg varchar2(192) -- 新管户人所属机构编号
    ,operateuserid varchar2(192) -- 操作人用户编号
    ,operateorgid varchar2(192) -- 操作人所属机构编号
    ,operatetime timestamp -- 操作时间
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
grant select on ${iol_schema}.icms_clr_transfer_history to ${iml_schema};
grant select on ${iol_schema}.icms_clr_transfer_history to ${icl_schema};
grant select on ${iol_schema}.icms_clr_transfer_history to ${idl_schema};
grant select on ${iol_schema}.icms_clr_transfer_history to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_transfer_history is '押品管户变更历史记录表';
comment on column ${iol_schema}.icms_clr_transfer_history.serialno is '记录流水号';
comment on column ${iol_schema}.icms_clr_transfer_history.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_transfer_history.clrname is '押品名称';
comment on column ${iol_schema}.icms_clr_transfer_history.clrtypeid is '押品资产类型编号';
comment on column ${iol_schema}.icms_clr_transfer_history.oldmanageid is '原管户人用户编号';
comment on column ${iol_schema}.icms_clr_transfer_history.oldmanageorg is '原管户人所属机构编号';
comment on column ${iol_schema}.icms_clr_transfer_history.newmanageid is '新管户人用户编号';
comment on column ${iol_schema}.icms_clr_transfer_history.newmanageorg is '新管户人所属机构编号';
comment on column ${iol_schema}.icms_clr_transfer_history.operateuserid is '操作人用户编号';
comment on column ${iol_schema}.icms_clr_transfer_history.operateorgid is '操作人所属机构编号';
comment on column ${iol_schema}.icms_clr_transfer_history.operatetime is '操作时间';
comment on column ${iol_schema}.icms_clr_transfer_history.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_transfer_history.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_transfer_history.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_transfer_history.etl_timestamp is 'ETL处理时间戳';
