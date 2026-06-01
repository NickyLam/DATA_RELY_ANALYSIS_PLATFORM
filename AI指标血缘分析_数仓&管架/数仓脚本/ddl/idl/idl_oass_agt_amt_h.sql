/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_amt_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_amt_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_amt_h(
etl_dt date --数据日期
,amt_type_cd varchar2(10) --金额类型代码
,curr_cd varchar2(10) --币种代码
,amt number(30,2) --金额
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,agt_id varchar2(60) --协议编号
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
grant select on ${idl_schema}.oass_agt_amt_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_amt_h is '协议金额历史';
comment on column ${idl_schema}.oass_agt_amt_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_agt_amt_h.amt_type_cd is '金额类型代码';
comment on column ${idl_schema}.oass_agt_amt_h.curr_cd is '币种代码';
comment on column ${idl_schema}.oass_agt_amt_h.amt is '金额';
comment on column ${idl_schema}.oass_agt_amt_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_agt_amt_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_agt_amt_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_agt_amt_h.agt_id is '协议编号';
comment on column ${idl_schema}.oass_agt_amt_h.lp_id is '法人编号';

