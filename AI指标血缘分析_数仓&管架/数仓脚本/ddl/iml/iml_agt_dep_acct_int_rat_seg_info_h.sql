/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_dep_acct_int_rat_seg_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_dep_acct_int_rat_seg_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_dep_acct_int_rat_seg_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_acct_int_rat_seg_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,int_cls_cd varchar2(30) -- 利息分类代码
    ,acct_id varchar2(100) -- 账户编号
    ,bus_start_dt date -- 业务开始日期
    ,bus_end_dt date -- 业务结束日期
    ,cust_id varchar2(100) -- 客户编号
    ,prod_id varchar2(100) -- 产品编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,chn_id varchar2(100) -- 渠道编号
    ,int_rat_seg_flg varchar2(10) -- 利率分段标志
    ,sub_acct_fix_int_rat number(18,8) -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio number(18,6) -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point number(18,8) -- 分户级利率浮动点数
    ,int_accr_begin_dt date -- 计息起始日期
    ,provi_begin_dt date -- 计提起始日期
    ,provi_end_dt date -- 计提结束日期
    ,last_provi_dt date -- 上一计提日期
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,agt_prefr_amt number(30,2) -- 协议优惠金额
    ,curr_cd varchar2(30) -- 币种代码
    ,int_amt number(30,2) -- 利息金额
    ,int_accr_way_cd varchar2(30) -- 计息方式代码
    ,int_rat_type_cd varchar2(30) -- 利率类型代码
    ,bank_int_int_rat number(18,8) -- 行内利率
    ,term_end_acm_provi_amt number(30,2) -- 期末累计计提金额
    ,term_end_acm_provi_bal number(30,8) -- 期末累计计提差额
    ,term_end_acm_adj_amt number(30,2) -- 期末累计调整金额
    ,term_end_acm_int_tax number(30,2) -- 期末累计利息税金
    ,agt_chg_way_cd varchar2(30) -- 协议变动方式代码
    ,agt_fix_int_rat number(18,8) -- 协议固定利率
    ,agt_float_point number(18,8) -- 协议浮动点数
    ,agt_float_ratio number(18,6) -- 协议浮动比例
    ,tax_category_cd varchar2(30) -- 税种代码
    ,float_int_rat number(18,8) -- 浮动利率
    ,bank_int_exec_int_rat number(18,8) -- 行内执行利率
    ,tax_rat number(18,8) -- 税率
    ,mon_int_accr_base_cd varchar2(30) -- 月计息基准代码
    ,year_int_accr_base_cd varchar2(30) -- 年计息基准代码
    ,int_accr_base_cd varchar2(30) -- 计息基准代码
    ,currt_acm_provi_amt number(30,2) -- 当期累计计提金额
    ,currt_acm_adj_amt number(30,2) -- 当期累计调整金额
    ,currt_acm_int_accr_days number(10) -- 当期累计计息天数
    ,currt_acm_int_tax number(30,2) -- 当期累计利息税
    ,tm_bg_acm_provi_amt number(30,2) -- 期初累计计提金额
    ,tm_bg_acm_provi_bal number(30,8) -- 期初累计计提差额
    ,tm_bg_acm_adj_amt number(30,2) -- 期初累计调整金额
    ,tm_bg_acm_int_tax number(30,2) -- 期初累计利息税
    ,event_type_cd varchar2(30) -- 事件类型代码
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
grant select on ${iml_schema}.agt_dep_acct_int_rat_seg_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_dep_acct_int_rat_seg_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_dep_acct_int_rat_seg_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_dep_acct_int_rat_seg_info_h is '存款账户利率分段信息历史';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.int_cls_cd is '利息分类代码';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.bus_start_dt is '业务开始日期';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.bus_end_dt is '业务结束日期';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.cust_acct_num is '客户账号';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.chn_id is '渠道编号';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.int_rat_seg_flg is '利率分段标志';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.sub_acct_fix_int_rat is '分户级固定利率';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.sub_acct_int_rat_float_ratio is '分户级利率浮动比例';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.sub_acct_int_rat_float_point is '分户级利率浮动点数';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.int_accr_begin_dt is '计息起始日期';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.provi_begin_dt is '计提起始日期';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.provi_end_dt is '计提结束日期';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.last_provi_dt is '上一计提日期';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.agt_prefr_amt is '协议优惠金额';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.int_amt is '利息金额';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.int_accr_way_cd is '计息方式代码';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.int_rat_type_cd is '利率类型代码';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.bank_int_int_rat is '行内利率';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.term_end_acm_provi_amt is '期末累计计提金额';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.term_end_acm_provi_bal is '期末累计计提差额';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.term_end_acm_adj_amt is '期末累计调整金额';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.term_end_acm_int_tax is '期末累计利息税金';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.agt_chg_way_cd is '协议变动方式代码';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.agt_fix_int_rat is '协议固定利率';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.agt_float_point is '协议浮动点数';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.agt_float_ratio is '协议浮动比例';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.tax_category_cd is '税种代码';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.float_int_rat is '浮动利率';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.bank_int_exec_int_rat is '行内执行利率';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.tax_rat is '税率';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.mon_int_accr_base_cd is '月计息基准代码';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.year_int_accr_base_cd is '年计息基准代码';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.int_accr_base_cd is '计息基准代码';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.currt_acm_provi_amt is '当期累计计提金额';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.currt_acm_adj_amt is '当期累计调整金额';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.currt_acm_int_accr_days is '当期累计计息天数';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.currt_acm_int_tax is '当期累计利息税';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.tm_bg_acm_provi_amt is '期初累计计提金额';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.tm_bg_acm_provi_bal is '期初累计计提差额';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.tm_bg_acm_adj_amt is '期初累计调整金额';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.tm_bg_acm_int_tax is '期初累计利息税';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.event_type_cd is '事件类型代码';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_dep_acct_int_rat_seg_info_h.etl_timestamp is 'ETL处理时间戳';
