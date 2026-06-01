/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_prd_am_cashflow_info_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_prd_am_cashflow_info_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_prd_am_cashflow_info_h(
etl_dt date --数据日期
,cashflow_type_cd varchar2(60) --现金流类型代码
,cashflow_sub_type_cd varchar2(60) --现金流子类型代码
,curr_cd varchar2(60) --币种代码
,prod_id varchar2(60) --产品编号
,src_prod_id varchar2(60) --源产品编号
,brch_seq_num number(10,0) --分支序号
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,cashflow_id varchar2(60) --现金流编号
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
grant select on ${idl_schema}.oass_prd_am_cashflow_info_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_prd_am_cashflow_info_h is '资管现金流信息历史';
comment on column ${idl_schema}.oass_prd_am_cashflow_info_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_prd_am_cashflow_info_h.cashflow_type_cd is '现金流类型代码';
comment on column ${idl_schema}.oass_prd_am_cashflow_info_h.cashflow_sub_type_cd is '现金流子类型代码';
comment on column ${idl_schema}.oass_prd_am_cashflow_info_h.curr_cd is '币种代码';
comment on column ${idl_schema}.oass_prd_am_cashflow_info_h.prod_id is '产品编号';
comment on column ${idl_schema}.oass_prd_am_cashflow_info_h.src_prod_id is '源产品编号';
comment on column ${idl_schema}.oass_prd_am_cashflow_info_h.brch_seq_num is '分支序号';
comment on column ${idl_schema}.oass_prd_am_cashflow_info_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_prd_am_cashflow_info_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_prd_am_cashflow_info_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_prd_am_cashflow_info_h.cashflow_id is '现金流编号';
comment on column ${idl_schema}.oass_prd_am_cashflow_info_h.lp_id is '法人编号';

