/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_acct_int_accr_cfg_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_acct_int_accr_cfg_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_acct_int_accr_cfg_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_acct_int_accr_cfg_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,acct_id varchar2(100) -- 账户编号
    ,int_cls_cd varchar2(30) -- 利息分类代码
    ,cust_id varchar2(100) -- 客户编号
    ,int_rat_type_cd varchar2(30) -- 利率类型代码
    ,bank_int_int_rat number(18,8) -- 行内利率
    ,int_rat_float_point number(18,8) -- 利率浮动点数
    ,int_rat_float_ratio number(18,6) -- 利率浮动比例
    ,float_int_rat number(18,8) -- 浮动利率
    ,sub_acct_int_rat_float_point varchar2(100) -- 分户级利率浮动点数
    ,sub_acct_int_rat_float_ratio varchar2(100) -- 分户级利率浮动比例
    ,sub_acct_fix_int_rat number(18,8) -- 分户级固定利率
    ,higt_exec_int_rat number(18,8) -- 最高执行利率
    ,lowt_exec_int_rat number(18,8) -- 最低执行利率
    ,accrd_nomal_int_rat_float_flg varchar2(10) -- 按正常利率浮动标志
    ,exec_int_rat number(18,8) -- 执行利率
    ,int_set_freq_cd varchar2(30) -- 结息频率代码
    ,int_set_day varchar2(2) -- 结息日
    ,int_accr_way_cd varchar2(30) -- 计息方式代码
    ,year_int_accr_base_cd varchar2(30) -- 年计息基准代码
    ,mon_int_accr_base_cd varchar2(30) -- 月计息基准代码
    ,int_accr_base_cd varchar2(30) -- 计息基准代码
    ,int_accr_flg varchar2(10) -- 计息标志
    ,cap_flg varchar2(10) -- 资本化标志
    ,int_set_flg varchar2(10) -- 结息标志
    ,acalc_flg varchar2(10) -- 重算标志
    ,int_rat_start_use_way_cd varchar2(30) -- 利率启用方式代码
    ,int_rat_effect_way_cd varchar2(30) -- 利率生效方式代码
    ,int_rat_modif_ped_cd varchar2(30) -- 利率变更周期代码
    ,int_rat_chg_dt date -- 利率变动日期
    ,int_rat_modif_day number(10) -- 利率变更日
    ,next_int_rat_modif_dt date -- 下次重定价日期
    ,last_int_rat_modif_dt date -- 上次重定价日期
    ,exec_int_rat_chg_flg varchar2(10) -- 执行利率变化标志
    ,tax_category_cd varchar2(30) -- 税种代码
    ,tax_rat number(18,6) -- 税率
    ,pnlt_int_rat_use_way_cd varchar2(30) -- 罚息利率使用方式代码
    ,int_provi_day number(10) -- 利息计提日
    ,int_provi_ped number(10) -- 利息计提周期
    ,agt_chg_way_cd varchar2(30) -- 协议变动方式代码
    ,agt_fix_int_rat number(18,8) -- 协议固定利率
    ,agt_float_ratio number(18,6) -- 协议浮动比例
    ,agt_float_point number(18,8) -- 协议浮动点数
    ,sub_acct_fix_tax_rat number(18,6) -- 分户级固定税率
    ,sub_acct_tax_rat_float_point number(18,8) -- 分户级税率浮动点数
    ,sub_acct_tax_rat_float_ratio number(18,6) -- 分户级税率浮动比例
    ,exch_rat_float_cate_cd varchar2(30) -- 汇率浮动类别代码
    ,int_rat_day_type_cd varchar2(30) -- 利率日类型代码
    ,acrs_ped_flg varchar2(10) -- 跨周期标志
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
grant select on ${iml_schema}.agt_loan_acct_int_accr_cfg_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_acct_int_accr_cfg_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_acct_int_accr_cfg_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_acct_int_accr_cfg_h is '贷款账户计息配置历史';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.int_cls_cd is '利息分类代码';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.int_rat_type_cd is '利率类型代码';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.bank_int_int_rat is '行内利率';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.int_rat_float_point is '利率浮动点数';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.int_rat_float_ratio is '利率浮动比例';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.float_int_rat is '浮动利率';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.sub_acct_int_rat_float_point is '分户级利率浮动点数';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.sub_acct_int_rat_float_ratio is '分户级利率浮动比例';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.sub_acct_fix_int_rat is '分户级固定利率';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.higt_exec_int_rat is '最高执行利率';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.lowt_exec_int_rat is '最低执行利率';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.accrd_nomal_int_rat_float_flg is '按正常利率浮动标志';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.int_set_freq_cd is '结息频率代码';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.int_set_day is '结息日';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.int_accr_way_cd is '计息方式代码';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.year_int_accr_base_cd is '年计息基准代码';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.mon_int_accr_base_cd is '月计息基准代码';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.int_accr_base_cd is '计息基准代码';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.int_accr_flg is '计息标志';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.cap_flg is '资本化标志';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.int_set_flg is '结息标志';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.acalc_flg is '重算标志';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.int_rat_start_use_way_cd is '利率启用方式代码';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.int_rat_effect_way_cd is '利率生效方式代码';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.int_rat_modif_ped_cd is '利率变更周期代码';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.int_rat_chg_dt is '利率变动日期';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.int_rat_modif_day is '利率变更日';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.next_int_rat_modif_dt is '下次重定价日期';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.last_int_rat_modif_dt is '上次重定价日期';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.exec_int_rat_chg_flg is '执行利率变化标志';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.tax_category_cd is '税种代码';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.tax_rat is '税率';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.pnlt_int_rat_use_way_cd is '罚息利率使用方式代码';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.int_provi_day is '利息计提日';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.int_provi_ped is '利息计提周期';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.agt_chg_way_cd is '协议变动方式代码';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.agt_fix_int_rat is '协议固定利率';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.agt_float_ratio is '协议浮动比例';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.agt_float_point is '协议浮动点数';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.sub_acct_fix_tax_rat is '分户级固定税率';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.sub_acct_tax_rat_float_point is '分户级税率浮动点数';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.sub_acct_tax_rat_float_ratio is '分户级税率浮动比例';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.exch_rat_float_cate_cd is '汇率浮动类别代码';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.int_rat_day_type_cd is '利率日类型代码';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.acrs_ped_flg is '跨周期标志';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_acct_int_accr_cfg_h.etl_timestamp is 'ETL处理时间戳';
