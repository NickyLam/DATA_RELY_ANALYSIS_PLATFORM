/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_loan_acct_int_rat_modif_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_loan_acct_int_rat_modif_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_loan_acct_int_rat_modif_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_loan_acct_int_rat_modif_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,int_cls_cd varchar2(30) -- 利息分类代码
    ,effect_dt date -- 生效日期
    ,acct_id varchar2(100) -- 账户编号
    ,seq_num varchar2(100) -- 序号
    ,new_int_rat_type_cd varchar2(30) -- 新利率类型代码
    ,new_int_rat_float_point number(18,8) -- 新利率浮动点数
    ,new_exec_int_rat number(18,8) -- 新执行利率
    ,new_int_rat_float_ratio number(18,6) -- 新利率浮动比例
    ,new_int_rat_start_use_way_cd varchar2(30) -- 新利率启用方式代码
    ,new_int_rat_effect_way_cd varchar2(30) -- 新利率生效方式代码
    ,new_int_rat_modif_day number(10) -- 新利率变更日
    ,new_int_rat_modif_dt date -- 新利率变更日期
    ,new_int_rat_modif_ped varchar2(30) -- 新利率变更周期
    ,acct_aldy_check_flg varchar2(10) -- 账户已复核标志
    ,tran_dt date -- 交易日期
    ,effect_flg varchar2(10) -- 生效标志
    ,acalc_flg varchar2(10) -- 重算标志
    ,cust_id varchar2(100) -- 客户编号
    ,accrd_nomal_int_rat_float_flg varchar2(10) -- 按正常利率浮动标志
    ,precon_id varchar2(100) -- 预约编号
    ,new_exec_tax_rat number(18,6) -- 新执行税率
    ,tax_rat_float_point number(18,8) -- 税率浮动点数
    ,tax_rat_float_ratio number(18,6) -- 税率浮动比例
    ,tax_info_flg varchar2(10) -- 税信息标志
    ,check_teller_id varchar2(100) -- 复核柜员编号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,tran_tm timestamp -- 交易时间
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_loan_acct_int_rat_modif_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_loan_acct_int_rat_modif_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_loan_acct_int_rat_modif_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_loan_acct_int_rat_modif_dtl is '贷款账户利率变更明细';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.int_cls_cd is '利息分类代码';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.effect_dt is '生效日期';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.acct_id is '账户编号';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.seq_num is '序号';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.new_int_rat_type_cd is '新利率类型代码';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.new_int_rat_float_point is '新利率浮动点数';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.new_exec_int_rat is '新执行利率';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.new_int_rat_float_ratio is '新利率浮动比例';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.new_int_rat_start_use_way_cd is '新利率启用方式代码';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.new_int_rat_effect_way_cd is '新利率生效方式代码';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.new_int_rat_modif_day is '新利率变更日';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.new_int_rat_modif_dt is '新利率变更日期';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.new_int_rat_modif_ped is '新利率变更周期';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.acct_aldy_check_flg is '账户已复核标志';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.effect_flg is '生效标志';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.acalc_flg is '重算标志';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.cust_id is '客户编号';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.accrd_nomal_int_rat_float_flg is '按正常利率浮动标志';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.precon_id is '预约编号';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.new_exec_tax_rat is '新执行税率';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.tax_rat_float_point is '税率浮动点数';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.tax_rat_float_ratio is '税率浮动比例';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.tax_info_flg is '税信息标志';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.check_teller_id is '复核柜员编号';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_loan_acct_int_rat_modif_dtl.etl_timestamp is 'ETL处理时间戳';
