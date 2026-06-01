/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_self_cycle
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_self_cycle
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_self_cycle purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_self_cycle(
    seqno varchar2(32) -- 记录序号
    ,clrid varchar2(32) -- 押品编号
    ,occurdate date -- 发生日期
    ,businesstype varchar2(2) -- 业务类型
    ,remarks varchar2(4000) -- 备注
    ,businessno varchar2(32) -- 相关业务编号
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
grant select on ${iol_schema}.icms_clr_self_cycle to ${iml_schema};
grant select on ${iol_schema}.icms_clr_self_cycle to ${icl_schema};
grant select on ${iol_schema}.icms_clr_self_cycle to ${idl_schema};
grant select on ${iol_schema}.icms_clr_self_cycle to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_self_cycle is '押品生命周期记录表';
comment on column ${iol_schema}.icms_clr_self_cycle.seqno is '记录序号';
comment on column ${iol_schema}.icms_clr_self_cycle.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_self_cycle.occurdate is '发生日期';
comment on column ${iol_schema}.icms_clr_self_cycle.businesstype is '业务类型';
comment on column ${iol_schema}.icms_clr_self_cycle.remarks is '备注';
comment on column ${iol_schema}.icms_clr_self_cycle.businessno is '相关业务编号';
comment on column ${iol_schema}.icms_clr_self_cycle.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_self_cycle.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_self_cycle.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_self_cycle.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_self_cycle.etl_timestamp is 'ETL处理时间戳';
