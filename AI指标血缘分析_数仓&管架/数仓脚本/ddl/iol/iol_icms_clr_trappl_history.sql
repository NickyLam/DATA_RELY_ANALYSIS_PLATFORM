/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_trappl_history
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_trappl_history
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_trappl_history purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_trappl_history(
    businessinsid varchar2(32) -- 出入库申请任务流水号
    ,clrid varchar2(32) -- 押品编号
    ,clrtypeid varchar2(32) -- 押品类型
    ,confmamt number(20,2) -- 我行确认价值
    ,confmcurrency varchar2(3) -- 我行确认价值币种
    ,trapplstatus varchar2(2) -- 出入库状态
    ,busovetime date -- 出入库时间
    ,createuser varchar2(32) -- 创建人
    ,deptcode varchar2(32) -- 所属机构
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
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
grant select on ${iol_schema}.icms_clr_trappl_history to ${iml_schema};
grant select on ${iol_schema}.icms_clr_trappl_history to ${icl_schema};
grant select on ${iol_schema}.icms_clr_trappl_history to ${idl_schema};
grant select on ${iol_schema}.icms_clr_trappl_history to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_trappl_history is '押品出入库记录';
comment on column ${iol_schema}.icms_clr_trappl_history.businessinsid is '出入库申请任务流水号';
comment on column ${iol_schema}.icms_clr_trappl_history.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_trappl_history.clrtypeid is '押品类型';
comment on column ${iol_schema}.icms_clr_trappl_history.confmamt is '我行确认价值';
comment on column ${iol_schema}.icms_clr_trappl_history.confmcurrency is '我行确认价值币种';
comment on column ${iol_schema}.icms_clr_trappl_history.trapplstatus is '出入库状态';
comment on column ${iol_schema}.icms_clr_trappl_history.busovetime is '出入库时间';
comment on column ${iol_schema}.icms_clr_trappl_history.createuser is '创建人';
comment on column ${iol_schema}.icms_clr_trappl_history.deptcode is '所属机构';
comment on column ${iol_schema}.icms_clr_trappl_history.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_trappl_history.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_trappl_history.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_trappl_history.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_trappl_history.etl_timestamp is 'ETL处理时间戳';
