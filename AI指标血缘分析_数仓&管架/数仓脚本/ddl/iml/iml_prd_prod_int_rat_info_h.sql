/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_prod_int_rat_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_prod_int_rat_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_prod_int_rat_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_prod_int_rat_info_h(
    lp_id varchar2(100) -- 法人编号
    ,prod_id varchar2(100) -- 产品编号
    ,evt_cate_id varchar2(100) -- 事件类别编号
    ,int_cls_cd varchar2(30) -- 利息分类代码
    ,int_rat_type_cd varchar2(30) -- 利率类型代码
    ,tax_category_cd varchar2(30) -- 税种代码
    ,use_sub_acct_int_rat_flg varchar2(10) -- 使用分户利率标志
    ,int_accr_way_cd varchar2(30) -- 计息方式代码
    ,int_rat_file_way_cd varchar2(30) -- 利率靠档方式代码
    ,file_amt_type_cd varchar2(30) -- 靠档金额类型代码
    ,amt_file_dir_cd varchar2(30) -- 金额靠档方向代码
    ,amt_file_way_cd varchar2(30) -- 金额靠档方式代码
    ,days_file_dir_cd varchar2(30) -- 天数靠档方向代码
    ,days_file_way_cd varchar2(30) -- 天数靠档方式代码
    ,int_calc_amt_type_cd varchar2(30) -- 利息计算金额类型代码
    ,value_day_get_val_way_cd varchar2(30) -- 起息日取值方式代码
    ,file_days_calc_way_cd varchar2(30) -- 靠档天数计算方式代码
    ,int_rat_start_use_way_cd varchar2(30) -- 利率启用方式代码
    ,mon_int_accr_base_cd varchar2(30) -- 月计息基准代码
    ,grouping_rule_rela_cd varchar2(30) -- 分组规则关系代码
    ,int_dtl_effect_way_cd varchar2(30) -- 利息明细生效方式代码
    ,int_modif_way_cd varchar2(30) -- 利息重算方式代码
    ,min_int_rat number(18,8) -- 最小利率
    ,max_int_rat number(18,8) -- 最大利率
    ,int_rat_modif_day number(10) -- 利率变更日
    ,int_rat_modif_ped_cd varchar2(30) -- 利率变更周期代码
    ,substr_flg varchar2(10) -- 截位标志
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.prd_prod_int_rat_info_h to ${icl_schema};
grant select on ${iml_schema}.prd_prod_int_rat_info_h to ${idl_schema};
grant select on ${iml_schema}.prd_prod_int_rat_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_prod_int_rat_info_h is '产品利率信息历史';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.evt_cate_id is '事件类别编号';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.int_cls_cd is '利息分类代码';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.int_rat_type_cd is '利率类型代码';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.tax_category_cd is '税种代码';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.use_sub_acct_int_rat_flg is '使用分户利率标志';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.int_accr_way_cd is '计息方式代码';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.int_rat_file_way_cd is '利率靠档方式代码';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.file_amt_type_cd is '靠档金额类型代码';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.amt_file_dir_cd is '金额靠档方向代码';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.amt_file_way_cd is '金额靠档方式代码';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.days_file_dir_cd is '天数靠档方向代码';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.days_file_way_cd is '天数靠档方式代码';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.int_calc_amt_type_cd is '利息计算金额类型代码';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.value_day_get_val_way_cd is '起息日取值方式代码';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.file_days_calc_way_cd is '靠档天数计算方式代码';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.int_rat_start_use_way_cd is '利率启用方式代码';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.mon_int_accr_base_cd is '月计息基准代码';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.grouping_rule_rela_cd is '分组规则关系代码';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.int_dtl_effect_way_cd is '利息明细生效方式代码';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.int_modif_way_cd is '利息重算方式代码';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.min_int_rat is '最小利率';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.max_int_rat is '最大利率';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.int_rat_modif_day is '利率变更日';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.int_rat_modif_ped_cd is '利率变更周期代码';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.substr_flg is '截位标志';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_prod_int_rat_info_h.etl_timestamp is 'ETL处理时间戳';
