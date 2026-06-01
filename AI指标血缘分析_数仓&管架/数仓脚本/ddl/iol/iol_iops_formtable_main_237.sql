/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iops_formtable_main_237
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iops_formtable_main_237
whenever sqlerror continue none;
drop table ${iol_schema}.iops_formtable_main_237 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iops_formtable_main_237(
    id number(38,0) -- 
    ,requestid number(38,0) -- 
    ,sqr number(38,0) -- 
    ,sqbm number(38,0) -- 
    ,ygbh varchar2(4000) -- 
    ,cjgzsj varchar2(500) -- 
    ,rxsj varchar2(500) -- 
    ,sqsj varchar2(4000) -- 
    ,lxdh varchar2(4000) -- 
    ,qxjlb varchar2(4000) -- 
    ,syjq varchar2(4000) -- 
    ,xjd varchar2(4000) -- 
    ,sqkssj varchar2(500) -- 
    ,sqjssj varchar2(500) -- 
    ,sqgj number(38,2) -- 
    ,yy varchar2(4000) -- 
    ,gzjjr varchar2(4000) -- 
    ,gzjjqj varchar2(4000) -- 
    ,jjlxr varchar2(4000) -- 
    ,jjlxrdh varchar2(4000) -- 
    ,sjkssj varchar2(500) -- 
    ,sjjssj varchar2(500) -- 
    ,sjgj number(38,2) -- 
    ,bh varchar2(4000) -- 
    ,ssfx number(38,0) -- 
    ,lqzj varchar2(4000) -- 
    ,lqsj varchar2(500) -- 
    ,ghsj varchar2(500) -- 
    ,jzjs varchar2(4000) -- 
    ,sjbmfzr number(38,0) -- 
    ,bt varchar2(4000) -- 
    ,fj varchar2(4000) -- 
    ,sqsjsfysjsjyz number(38,0) -- 
    ,dygqxz varchar2(4000) -- 
    ,ylrfgxld number(38,0) -- 
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.iops_formtable_main_237 to ${iml_schema};
grant select on ${iol_schema}.iops_formtable_main_237 to ${icl_schema};
grant select on ${iol_schema}.iops_formtable_main_237 to ${idl_schema};
grant select on ${iol_schema}.iops_formtable_main_237 to ${iel_schema};

-- comment
comment on table ${iol_schema}.iops_formtable_main_237 is '';
comment on column ${iol_schema}.iops_formtable_main_237.id is '';
comment on column ${iol_schema}.iops_formtable_main_237.requestid is '';
comment on column ${iol_schema}.iops_formtable_main_237.sqr is '';
comment on column ${iol_schema}.iops_formtable_main_237.sqbm is '';
comment on column ${iol_schema}.iops_formtable_main_237.ygbh is '';
comment on column ${iol_schema}.iops_formtable_main_237.cjgzsj is '';
comment on column ${iol_schema}.iops_formtable_main_237.rxsj is '';
comment on column ${iol_schema}.iops_formtable_main_237.sqsj is '';
comment on column ${iol_schema}.iops_formtable_main_237.lxdh is '';
comment on column ${iol_schema}.iops_formtable_main_237.qxjlb is '';
comment on column ${iol_schema}.iops_formtable_main_237.syjq is '';
comment on column ${iol_schema}.iops_formtable_main_237.xjd is '';
comment on column ${iol_schema}.iops_formtable_main_237.sqkssj is '';
comment on column ${iol_schema}.iops_formtable_main_237.sqjssj is '';
comment on column ${iol_schema}.iops_formtable_main_237.sqgj is '';
comment on column ${iol_schema}.iops_formtable_main_237.yy is '';
comment on column ${iol_schema}.iops_formtable_main_237.gzjjr is '';
comment on column ${iol_schema}.iops_formtable_main_237.gzjjqj is '';
comment on column ${iol_schema}.iops_formtable_main_237.jjlxr is '';
comment on column ${iol_schema}.iops_formtable_main_237.jjlxrdh is '';
comment on column ${iol_schema}.iops_formtable_main_237.sjkssj is '';
comment on column ${iol_schema}.iops_formtable_main_237.sjjssj is '';
comment on column ${iol_schema}.iops_formtable_main_237.sjgj is '';
comment on column ${iol_schema}.iops_formtable_main_237.bh is '';
comment on column ${iol_schema}.iops_formtable_main_237.ssfx is '';
comment on column ${iol_schema}.iops_formtable_main_237.lqzj is '';
comment on column ${iol_schema}.iops_formtable_main_237.lqsj is '';
comment on column ${iol_schema}.iops_formtable_main_237.ghsj is '';
comment on column ${iol_schema}.iops_formtable_main_237.jzjs is '';
comment on column ${iol_schema}.iops_formtable_main_237.sjbmfzr is '';
comment on column ${iol_schema}.iops_formtable_main_237.bt is '';
comment on column ${iol_schema}.iops_formtable_main_237.fj is '';
comment on column ${iol_schema}.iops_formtable_main_237.sqsjsfysjsjyz is '';
comment on column ${iol_schema}.iops_formtable_main_237.dygqxz is '';
comment on column ${iol_schema}.iops_formtable_main_237.ylrfgxld is '';
comment on column ${iol_schema}.iops_formtable_main_237.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.iops_formtable_main_237.etl_timestamp is 'ETL处理时间戳';
