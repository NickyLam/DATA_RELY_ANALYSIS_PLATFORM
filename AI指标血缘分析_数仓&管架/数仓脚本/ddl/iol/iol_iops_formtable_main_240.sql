/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iops_formtable_main_240
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iops_formtable_main_240
whenever sqlerror continue none;
drop table ${iol_schema}.iops_formtable_main_240 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iops_formtable_main_240(
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
    ,jzjs varchar2(4000) -- 
    ,lqzj varchar2(4000) -- 
    ,lqsj varchar2(500) -- 
    ,ghsj varchar2(500) -- 
    ,bt varchar2(4000) -- 
    ,fj varchar2(4000) -- 
    ,sqsjsfysjsjyz number(38,0) -- 
    ,dygqxz varchar2(4000) -- 
    ,sfylr number(38,0) -- 
    ,ylrbmfzr number(38,0) -- 
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
grant select on ${iol_schema}.iops_formtable_main_240 to ${iml_schema};
grant select on ${iol_schema}.iops_formtable_main_240 to ${icl_schema};
grant select on ${iol_schema}.iops_formtable_main_240 to ${idl_schema};
grant select on ${iol_schema}.iops_formtable_main_240 to ${iel_schema};

-- comment
comment on table ${iol_schema}.iops_formtable_main_240 is '';
comment on column ${iol_schema}.iops_formtable_main_240.id is '';
comment on column ${iol_schema}.iops_formtable_main_240.requestid is '';
comment on column ${iol_schema}.iops_formtable_main_240.sqr is '';
comment on column ${iol_schema}.iops_formtable_main_240.sqbm is '';
comment on column ${iol_schema}.iops_formtable_main_240.ygbh is '';
comment on column ${iol_schema}.iops_formtable_main_240.cjgzsj is '';
comment on column ${iol_schema}.iops_formtable_main_240.rxsj is '';
comment on column ${iol_schema}.iops_formtable_main_240.sqsj is '';
comment on column ${iol_schema}.iops_formtable_main_240.lxdh is '';
comment on column ${iol_schema}.iops_formtable_main_240.qxjlb is '';
comment on column ${iol_schema}.iops_formtable_main_240.syjq is '';
comment on column ${iol_schema}.iops_formtable_main_240.xjd is '';
comment on column ${iol_schema}.iops_formtable_main_240.sqkssj is '';
comment on column ${iol_schema}.iops_formtable_main_240.sqjssj is '';
comment on column ${iol_schema}.iops_formtable_main_240.sqgj is '';
comment on column ${iol_schema}.iops_formtable_main_240.yy is '';
comment on column ${iol_schema}.iops_formtable_main_240.gzjjr is '';
comment on column ${iol_schema}.iops_formtable_main_240.gzjjqj is '';
comment on column ${iol_schema}.iops_formtable_main_240.jjlxr is '';
comment on column ${iol_schema}.iops_formtable_main_240.jjlxrdh is '';
comment on column ${iol_schema}.iops_formtable_main_240.sjkssj is '';
comment on column ${iol_schema}.iops_formtable_main_240.sjjssj is '';
comment on column ${iol_schema}.iops_formtable_main_240.sjgj is '';
comment on column ${iol_schema}.iops_formtable_main_240.bh is '';
comment on column ${iol_schema}.iops_formtable_main_240.ssfx is '';
comment on column ${iol_schema}.iops_formtable_main_240.jzjs is '';
comment on column ${iol_schema}.iops_formtable_main_240.lqzj is '';
comment on column ${iol_schema}.iops_formtable_main_240.lqsj is '';
comment on column ${iol_schema}.iops_formtable_main_240.ghsj is '';
comment on column ${iol_schema}.iops_formtable_main_240.bt is '';
comment on column ${iol_schema}.iops_formtable_main_240.fj is '';
comment on column ${iol_schema}.iops_formtable_main_240.sqsjsfysjsjyz is '';
comment on column ${iol_schema}.iops_formtable_main_240.dygqxz is '';
comment on column ${iol_schema}.iops_formtable_main_240.sfylr is '';
comment on column ${iol_schema}.iops_formtable_main_240.ylrbmfzr is '';
comment on column ${iol_schema}.iops_formtable_main_240.ylrfgxld is '';
comment on column ${iol_schema}.iops_formtable_main_240.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.iops_formtable_main_240.etl_timestamp is 'ETL处理时间戳';
