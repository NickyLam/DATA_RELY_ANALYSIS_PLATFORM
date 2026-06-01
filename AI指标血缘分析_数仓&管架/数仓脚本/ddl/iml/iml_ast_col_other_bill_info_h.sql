/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_col_other_bill_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_col_other_bill_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.ast_col_other_bill_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_other_bill_info_h(
    asset_id varchar2(100) -- 资产编号
    ,lp_id varchar2(60) -- 法人编号
    ,col_id varchar2(60) -- 押品编号
    ,bill_num varchar2(60) -- 票据号码
    ,bill_type_cd varchar2(30) -- 票据类型代码
    ,drawer_name varchar2(375) -- 出票人名称
    ,drawer_orgnz_cd varchar2(30) -- 出票人组织机构代码
    ,drawer_type_cd varchar2(30) -- 出票人类型代码
    ,drawer_open_bank_no varchar2(60) -- 出票人开户行行号
    ,drawer_acct_id varchar2(100) -- 出票人账户编号
    ,accptor_name varchar2(375) -- 承兑人名称
    ,accptor_type_cd varchar2(30) -- 承兑人类型代码
    ,recver_name varchar2(375) -- 收款人名称
    ,recver_type_cd varchar2(30) -- 收款人类型代码
    ,bill_rher_flg varchar2(10) -- 票据前手标志
    ,bill_rher_name varchar2(375) -- 票据前手名称
    ,bill_rher_type_cd varchar2(30) -- 票据前手类型代码
    ,fac_val_amt number(30,2) -- 票面金额
    ,bill_issue_dt date -- 票据签发日期
    ,bill_exp_dt date -- 票据到期日期
    ,drawer_local_cty_or_rg_cd varchar2(30) -- 出票人所在国家或地区代码
    ,drawer_ext_rating_rest_cd varchar2(30) -- 出票人外部评级结果代码
    ,accptor_local_cty_or_rg_cd varchar2(30) -- 承兑人所在国家或地区代码
    ,accptor_ext_rating_rest_cd varchar2(30) -- 承兑人外部评级结果代码
    ,bank_ensure_discount_flg varchar2(10) -- 银行保贴标志
    ,bank_ensure_discount_name varchar2(375) -- 银行保贴名称
    ,curr_cd varchar2(30) -- 币种代码
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.ast_col_other_bill_info_h to ${icl_schema};
grant select on ${iml_schema}.ast_col_other_bill_info_h to ${idl_schema};
grant select on ${iml_schema}.ast_col_other_bill_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_col_other_bill_info_h is '押品其他票据信息历史';
comment on column ${iml_schema}.ast_col_other_bill_info_h.asset_id is '资产编号';
comment on column ${iml_schema}.ast_col_other_bill_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.ast_col_other_bill_info_h.col_id is '押品编号';
comment on column ${iml_schema}.ast_col_other_bill_info_h.bill_num is '票据号码';
comment on column ${iml_schema}.ast_col_other_bill_info_h.bill_type_cd is '票据类型代码';
comment on column ${iml_schema}.ast_col_other_bill_info_h.drawer_name is '出票人名称';
comment on column ${iml_schema}.ast_col_other_bill_info_h.drawer_orgnz_cd is '出票人组织机构代码';
comment on column ${iml_schema}.ast_col_other_bill_info_h.drawer_type_cd is '出票人类型代码';
comment on column ${iml_schema}.ast_col_other_bill_info_h.drawer_open_bank_no is '出票人开户行行号';
comment on column ${iml_schema}.ast_col_other_bill_info_h.drawer_acct_id is '出票人账户编号';
comment on column ${iml_schema}.ast_col_other_bill_info_h.accptor_name is '承兑人名称';
comment on column ${iml_schema}.ast_col_other_bill_info_h.accptor_type_cd is '承兑人类型代码';
comment on column ${iml_schema}.ast_col_other_bill_info_h.recver_name is '收款人名称';
comment on column ${iml_schema}.ast_col_other_bill_info_h.recver_type_cd is '收款人类型代码';
comment on column ${iml_schema}.ast_col_other_bill_info_h.bill_rher_flg is '票据前手标志';
comment on column ${iml_schema}.ast_col_other_bill_info_h.bill_rher_name is '票据前手名称';
comment on column ${iml_schema}.ast_col_other_bill_info_h.bill_rher_type_cd is '票据前手类型代码';
comment on column ${iml_schema}.ast_col_other_bill_info_h.fac_val_amt is '票面金额';
comment on column ${iml_schema}.ast_col_other_bill_info_h.bill_issue_dt is '票据签发日期';
comment on column ${iml_schema}.ast_col_other_bill_info_h.bill_exp_dt is '票据到期日期';
comment on column ${iml_schema}.ast_col_other_bill_info_h.drawer_local_cty_or_rg_cd is '出票人所在国家或地区代码';
comment on column ${iml_schema}.ast_col_other_bill_info_h.drawer_ext_rating_rest_cd is '出票人外部评级结果代码';
comment on column ${iml_schema}.ast_col_other_bill_info_h.accptor_local_cty_or_rg_cd is '承兑人所在国家或地区代码';
comment on column ${iml_schema}.ast_col_other_bill_info_h.accptor_ext_rating_rest_cd is '承兑人外部评级结果代码';
comment on column ${iml_schema}.ast_col_other_bill_info_h.bank_ensure_discount_flg is '银行保贴标志';
comment on column ${iml_schema}.ast_col_other_bill_info_h.bank_ensure_discount_name is '银行保贴名称';
comment on column ${iml_schema}.ast_col_other_bill_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.ast_col_other_bill_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.ast_col_other_bill_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.ast_col_other_bill_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.ast_col_other_bill_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_col_other_bill_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.ast_col_other_bill_info_h.etl_timestamp is 'ETL处理时间戳';
