/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_fin_subj_info_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_fin_subj_info_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_fin_subj_info_h(
etl_dt date --数据日期
,subj_id varchar2(100) --科目编号
,super_subj_id varchar2(100) --上级科目编号
,subj_name varchar2(500) --科目名称
,subj_level_cd number(38,0) --科目级别代码
,subj_type_cd varchar2(30) --科目类型代码
,subj_attr_cd varchar2(30) --科目属性代码
,end_level_subj_flg varchar2(10) --末级科目标志
,subj_bal_dir_cd varchar2(30) --科目余额方向代码
,subj_status_cd varchar2(30) --科目状态代码
,lmt_subj_flg varchar2(10) --受限科目标志
,allow_od_flg varchar2(10) --透支标志
,curr_char_proj_cd varchar2(30) --货币性项目代码
,setup_acct_type_cd varchar2(30) --建账类型代码
,subj_belong_cd varchar2(30) --科目归属代码
,in_bs_flg varchar2(10) --表内标志
,manual_open_acct_proc_mode_cd varchar2(30) --手工开户受理模式代码
,start_use_dt date --启用日期
,stop_use_dt date --停用日期
,subj_use_sys_cd varchar2(100) --科目使用系统代码
,subj_amt_dir_cd varchar2(30) --科目发生额方向代码
,price_tax_sept_cd varchar2(30) --价税分离代码
,subj_bal_float_warn_flg varchar2(10) --科目余额浮动预警标志
,cnter_manual_entry_start_dt date --柜面手工记账开始日期
,cnter_manual_entry_end_dt date --柜面手工记账结束日期
,accti_midgrod_manual_entry_start_dt date --核算中台手工记账开始日期
,accti_midgrod_manual_entry_end_dt date --核算中台手工记账结束日期
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,sob_id varchar2(100) --账套编号
,lp_id varchar2(100) --法人编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_fin_subj_info_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_fin_subj_info_h is '科目信息历史';
comment on column ${idl_schema}.oass_fin_subj_info_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_fin_subj_info_h.subj_id is '科目编号';
comment on column ${idl_schema}.oass_fin_subj_info_h.super_subj_id is '上级科目编号';
comment on column ${idl_schema}.oass_fin_subj_info_h.subj_name is '科目名称';
comment on column ${idl_schema}.oass_fin_subj_info_h.subj_level_cd is '科目级别代码';
comment on column ${idl_schema}.oass_fin_subj_info_h.subj_type_cd is '科目类型代码';
comment on column ${idl_schema}.oass_fin_subj_info_h.subj_attr_cd is '科目属性代码';
comment on column ${idl_schema}.oass_fin_subj_info_h.end_level_subj_flg is '末级科目标志';
comment on column ${idl_schema}.oass_fin_subj_info_h.subj_bal_dir_cd is '科目余额方向代码';
comment on column ${idl_schema}.oass_fin_subj_info_h.subj_status_cd is '科目状态代码';
comment on column ${idl_schema}.oass_fin_subj_info_h.lmt_subj_flg is '受限科目标志';
comment on column ${idl_schema}.oass_fin_subj_info_h.allow_od_flg is '透支标志';
comment on column ${idl_schema}.oass_fin_subj_info_h.curr_char_proj_cd is '货币性项目代码';
comment on column ${idl_schema}.oass_fin_subj_info_h.setup_acct_type_cd is '建账类型代码';
comment on column ${idl_schema}.oass_fin_subj_info_h.subj_belong_cd is '科目归属代码';
comment on column ${idl_schema}.oass_fin_subj_info_h.in_bs_flg is '表内标志';
comment on column ${idl_schema}.oass_fin_subj_info_h.manual_open_acct_proc_mode_cd is '手工开户受理模式代码';
comment on column ${idl_schema}.oass_fin_subj_info_h.start_use_dt is '启用日期';
comment on column ${idl_schema}.oass_fin_subj_info_h.stop_use_dt is '停用日期';
comment on column ${idl_schema}.oass_fin_subj_info_h.subj_use_sys_cd is '科目使用系统代码';
comment on column ${idl_schema}.oass_fin_subj_info_h.subj_amt_dir_cd is '科目发生额方向代码';
comment on column ${idl_schema}.oass_fin_subj_info_h.price_tax_sept_cd is '价税分离代码';
comment on column ${idl_schema}.oass_fin_subj_info_h.subj_bal_float_warn_flg is '科目余额浮动预警标志';
comment on column ${idl_schema}.oass_fin_subj_info_h.cnter_manual_entry_start_dt is '柜面手工记账开始日期';
comment on column ${idl_schema}.oass_fin_subj_info_h.cnter_manual_entry_end_dt is '柜面手工记账结束日期';
comment on column ${idl_schema}.oass_fin_subj_info_h.accti_midgrod_manual_entry_start_dt is '核算中台手工记账开始日期';
comment on column ${idl_schema}.oass_fin_subj_info_h.accti_midgrod_manual_entry_end_dt is '核算中台手工记账结束日期';
comment on column ${idl_schema}.oass_fin_subj_info_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_fin_subj_info_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_fin_subj_info_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_fin_subj_info_h.sob_id is '账套编号';
comment on column ${idl_schema}.oass_fin_subj_info_h.lp_id is '法人编号';

