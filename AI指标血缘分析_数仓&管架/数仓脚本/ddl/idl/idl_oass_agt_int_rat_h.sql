/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_int_rat_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_int_rat_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_int_rat_h(
etl_dt date --数据日期
,int_rat_type_cd varchar2(10) --利率类型代码
,int_rat_id varchar2(60) --利率编号
,base_int_rat number(18,8) --基准利率
,exec_int_rat number(38,8) --执行利率
,int_rat_float_way_cd varchar2(10) --利率浮动方式代码
,int_rat_float_point number(38,8) --利率浮动点数
,int_rat_fl_rt number(38,8) --利率浮动比例
,int_rat_period_cd varchar2(10) --利率周期代码
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,agt_id varchar2(100) --协议编号
,lp_id varchar2(60) --法人编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_agt_int_rat_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_int_rat_h is '协议利率历史';
comment on column ${idl_schema}.oass_agt_int_rat_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_agt_int_rat_h.int_rat_type_cd is '利率类型代码';
comment on column ${idl_schema}.oass_agt_int_rat_h.int_rat_id is '利率编号';
comment on column ${idl_schema}.oass_agt_int_rat_h.base_int_rat is '基准利率';
comment on column ${idl_schema}.oass_agt_int_rat_h.exec_int_rat is '执行利率';
comment on column ${idl_schema}.oass_agt_int_rat_h.int_rat_float_way_cd is '利率浮动方式代码';
comment on column ${idl_schema}.oass_agt_int_rat_h.int_rat_float_point is '利率浮动点数';
comment on column ${idl_schema}.oass_agt_int_rat_h.int_rat_fl_rt is '利率浮动比例';
comment on column ${idl_schema}.oass_agt_int_rat_h.int_rat_period_cd is '利率周期代码';
comment on column ${idl_schema}.oass_agt_int_rat_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_agt_int_rat_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_agt_int_rat_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_agt_int_rat_h.agt_id is '协议编号';
comment on column ${idl_schema}.oass_agt_int_rat_h.lp_id is '法人编号';

