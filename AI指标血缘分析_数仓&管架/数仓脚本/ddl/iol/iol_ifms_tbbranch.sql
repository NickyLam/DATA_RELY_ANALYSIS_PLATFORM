/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbbranch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbbranch
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbbranch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbbranch(
    internal_branch varchar2(384) -- 
    ,branch_no varchar2(24) -- 
    ,branch_name varchar2(250) -- 
    ,short_name varchar2(250) -- 
    ,up_branch varchar2(24) -- 
    ,branch_level varchar2(12) -- 
    ,branch_kind varchar2(4) -- 
    ,branch_trans varchar2(8) -- 
    ,reserve1 varchar2(384) -- 
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
grant select on ${iol_schema}.ifms_tbbranch to ${iml_schema};
grant select on ${iol_schema}.ifms_tbbranch to ${icl_schema};
grant select on ${iol_schema}.ifms_tbbranch to ${idl_schema};
grant select on ${iol_schema}.ifms_tbbranch to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbbranch is '机构信息表';
comment on column ${iol_schema}.ifms_tbbranch.internal_branch is '';
comment on column ${iol_schema}.ifms_tbbranch.branch_no is '';
comment on column ${iol_schema}.ifms_tbbranch.branch_name is '';
comment on column ${iol_schema}.ifms_tbbranch.short_name is '';
comment on column ${iol_schema}.ifms_tbbranch.up_branch is '';
comment on column ${iol_schema}.ifms_tbbranch.branch_level is '';
comment on column ${iol_schema}.ifms_tbbranch.branch_kind is '';
comment on column ${iol_schema}.ifms_tbbranch.branch_trans is '';
comment on column ${iol_schema}.ifms_tbbranch.reserve1 is '';
comment on column ${iol_schema}.ifms_tbbranch.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbbranch.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbbranch.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbbranch.etl_timestamp is 'ETL处理时间戳';
