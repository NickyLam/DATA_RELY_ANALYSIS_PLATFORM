/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_ref_base_rat_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_ref_base_rat_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_ref_base_rat_h(
etl_dt date --数据日期
,curr_cd varchar2(30) --币种代码
,effect_dt date --生效日期
,base_rat number(18,8) --基准利率
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,lp_id varchar2(100) --法人编号
,base_rat_id varchar2(100) --基准利率编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_ref_base_rat_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_ref_base_rat_h is '基准利率历史表';
comment on column ${idl_schema}.oass_ref_base_rat_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_ref_base_rat_h.curr_cd is '币种代码';
comment on column ${idl_schema}.oass_ref_base_rat_h.effect_dt is '生效日期';
comment on column ${idl_schema}.oass_ref_base_rat_h.base_rat is '基准利率';
comment on column ${idl_schema}.oass_ref_base_rat_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_ref_base_rat_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_ref_base_rat_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_ref_base_rat_h.lp_id is '法人编号';
comment on column ${idl_schema}.oass_ref_base_rat_h.base_rat_id is '基准利率编号';

