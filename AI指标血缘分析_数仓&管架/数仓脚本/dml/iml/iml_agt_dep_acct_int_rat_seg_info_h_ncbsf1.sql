/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_dep_acct_int_rat_seg_info_h_ncbsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_dep_acct_int_rat_seg_info_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_dep_acct_int_rat_seg_info_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_int_rat_seg_info_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_dep_acct_int_rat_seg_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_acct_int_rat_seg_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_acct_int_rat_seg_info_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_acct_int_rat_seg_info_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,int_cls_cd -- 利息分类代码
    ,acct_id -- 账户编号
    ,bus_start_dt -- 业务开始日期
    ,bus_end_dt -- 业务结束日期
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,cust_acct_num -- 客户账号
    ,chn_id -- 渠道编号
    ,int_rat_seg_flg -- 利率分段标志
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,int_accr_begin_dt -- 计息起始日期
    ,provi_begin_dt -- 计提起始日期
    ,provi_end_dt -- 计提结束日期
    ,last_provi_dt -- 上一计提日期
    ,tran_org_id -- 交易机构编号
    ,agt_prefr_amt -- 协议优惠金额
    ,curr_cd -- 币种代码
    ,int_amt -- 利息金额
    ,int_accr_way_cd -- 计息方式代码
    ,int_rat_type_cd -- 利率类型代码
    ,bank_int_int_rat -- 行内利率
    ,term_end_acm_provi_amt -- 期末累计计提金额
    ,term_end_acm_provi_bal -- 期末累计计提差额
    ,term_end_acm_adj_amt -- 期末累计调整金额
    ,term_end_acm_int_tax -- 期末累计利息税金
    ,agt_chg_way_cd -- 协议变动方式代码
    ,agt_fix_int_rat -- 协议固定利率
    ,agt_float_point -- 协议浮动点数
    ,agt_float_ratio -- 协议浮动比例
    ,tax_category_cd -- 税种代码
    ,float_int_rat -- 浮动利率
    ,bank_int_exec_int_rat -- 行内执行利率
    ,tax_rat -- 税率
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,year_int_accr_base_cd -- 年计息基准代码
    ,int_accr_base_cd -- 计息基准代码
    ,currt_acm_provi_amt -- 当期累计计提金额
    ,currt_acm_adj_amt -- 当期累计调整金额
    ,currt_acm_int_accr_days -- 当期累计计息天数
    ,currt_acm_int_tax -- 当期累计利息税
    ,tm_bg_acm_provi_amt -- 期初累计计提金额
    ,tm_bg_acm_provi_bal -- 期初累计计提差额
    ,tm_bg_acm_adj_amt -- 期初累计调整金额
    ,tm_bg_acm_int_tax -- 期初累计利息税
    ,event_type_cd -- 事件类型代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_acct_int_rat_seg_info_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_dep_acct_int_rat_seg_info_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_int_rat_seg_info_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_dep_acct_int_rat_seg_info_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_int_rat_seg_info_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_int_split-1
insert into ${iml_schema}.agt_dep_acct_int_rat_seg_info_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,int_cls_cd -- 利息分类代码
    ,acct_id -- 账户编号
    ,bus_start_dt -- 业务开始日期
    ,bus_end_dt -- 业务结束日期
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,cust_acct_num -- 客户账号
    ,chn_id -- 渠道编号
    ,int_rat_seg_flg -- 利率分段标志
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,int_accr_begin_dt -- 计息起始日期
    ,provi_begin_dt -- 计提起始日期
    ,provi_end_dt -- 计提结束日期
    ,last_provi_dt -- 上一计提日期
    ,tran_org_id -- 交易机构编号
    ,agt_prefr_amt -- 协议优惠金额
    ,curr_cd -- 币种代码
    ,int_amt -- 利息金额
    ,int_accr_way_cd -- 计息方式代码
    ,int_rat_type_cd -- 利率类型代码
    ,bank_int_int_rat -- 行内利率
    ,term_end_acm_provi_amt -- 期末累计计提金额
    ,term_end_acm_provi_bal -- 期末累计计提差额
    ,term_end_acm_adj_amt -- 期末累计调整金额
    ,term_end_acm_int_tax -- 期末累计利息税金
    ,agt_chg_way_cd -- 协议变动方式代码
    ,agt_fix_int_rat -- 协议固定利率
    ,agt_float_point -- 协议浮动点数
    ,agt_float_ratio -- 协议浮动比例
    ,tax_category_cd -- 税种代码
    ,float_int_rat -- 浮动利率
    ,bank_int_exec_int_rat -- 行内执行利率
    ,tax_rat -- 税率
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,year_int_accr_base_cd -- 年计息基准代码
    ,int_accr_base_cd -- 计息基准代码
    ,currt_acm_provi_amt -- 当期累计计提金额
    ,currt_acm_adj_amt -- 当期累计调整金额
    ,currt_acm_int_accr_days -- 当期累计计息天数
    ,currt_acm_int_tax -- 当期累计利息税
    ,tm_bg_acm_provi_amt -- 期初累计计提金额
    ,tm_bg_acm_provi_bal -- 期初累计计提差额
    ,tm_bg_acm_adj_amt -- 期初累计调整金额
    ,tm_bg_acm_int_tax -- 期初累计利息税
    ,event_type_cd -- 事件类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '120010'||P1.INTERNAL_KEY -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INT_CLASS -- 利息分类代码
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.START_DATE -- 业务开始日期
    ,P1.END_DATE -- 业务结束日期
    ,P1.CLIENT_NO -- 客户编号
    ,P1.PROD_TYPE -- 产品编号
    ,P1.BASE_ACCT_NO -- 客户账号
    ,P1.SOURCE_TYPE -- 渠道编号
    ,nvl(trim(P1.SPLIT_RATE_FLAG),'-') -- 利率分段标志
    ,P1.ACCT_FIXED_RATE -- 分户级固定利率
    ,P1.ACCT_PERCENT_RATE -- 分户级利率浮动比例
    ,P1.ACCT_SPREAD_RATE -- 分户级利率浮动点数
    ,P1.CALC_BEGIN_DATE -- 计息起始日期
    ,${iml_schema}.dateformat_min(P1.TD_ACCR_INT_DAY) -- 计提起始日期
    ,P1.TD_END_ACCR_DATE -- 计提结束日期
    ,P1.TD_LAST_ACCR_DATE -- 上一计提日期
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,P1.AGREE_REDUCE_AMT -- 协议优惠金额
    ,P1.CCY -- 币种代码
    ,P1.INT_AMT -- 利息金额
    ,nvl(trim(nvl(trim(P1.INT_CALC_BAL),'-')),'-') -- 计息方式代码
    ,nvl(trim(P1.INT_TYPE),'-') -- 利率类型代码
    ,P1.ACTUAL_RATE -- 行内利率
    ,P1.AFTER_INT_ACCRUED -- 期末累计计提金额
    ,P1.AFTER_INT_ACCRUED_DIFF -- 期末累计计提差额
    ,P1.AFTER_INT_ADJ -- 期末累计调整金额
    ,P1.AFTER_TAX_ACCRUED -- 期末累计利息税金
    ,nvl(trim(P1.AGREE_CHANGE_TYPE),'-') -- 协议变动方式代码
    ,P1.AGREE_FIXED_RATE -- 协议固定利率
    ,P1.AGREE_SPREAD_RATE -- 协议浮动点数
    ,P1.AGREE_PERCENT_RATE -- 协议浮动比例
    ,P1.TAX_TYPE -- 税种代码
    ,P1.FLOAT_RATE -- 浮动利率
    ,P1.REAL_RATE -- 行内执行利率
    ,P1.TAX_RATE -- 税率
    ,nvl(trim(P1.MONTH_BASIS),'-') -- 月计息基准代码
    ,nvl(trim(P1.YEAR_BASIS),'-') -- 年计息基准代码
    ,case when MONTH_BASIS='ACT' and YEAR_BASIS='360'  then 'A/360'
     when MONTH_BASIS='D30' and YEAR_BASIS='360'  then '30/360'
     when MONTH_BASIS='ACT' and YEAR_BASIS='365'  then 'A/365'
     when MONTH_BASIS='D30' and YEAR_BASIS='365'  then '30/365'
     when MONTH_BASIS='ACT' and YEAR_BASIS='366'  then  'A/366'
     else '-'  end -- 计息基准代码
    ,P1.CUR_INT_ACCRUED -- 当期累计计提金额
    ,P1.CUR_INT_ADJ -- 当期累计调整金额
    ,P1.TD_INT_NUM_DAYS -- 当期累计计息天数
    ,P1.CUR_TAX_ACCRUED -- 当期累计利息税
    ,P1.PRE_INT_ACCRUED -- 期初累计计提金额
    ,P1.PRE_INT_ACCRUED_DIFF -- 期初累计计提差额
    ,P1.PRE_INT_ADJ -- 期初累计调整金额
    ,P1.PRE_TAX_ACCRUED -- 期初累计利息税
    ,P1.EVENT_TYPE -- 事件类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_int_split' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_int_split p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_dep_acct_int_rat_seg_info_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,int_cls_cd
  	                                        ,acct_id
  	                                        ,bus_start_dt
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_dep_acct_int_rat_seg_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,int_cls_cd -- 利息分类代码
    ,acct_id -- 账户编号
    ,bus_start_dt -- 业务开始日期
    ,bus_end_dt -- 业务结束日期
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,cust_acct_num -- 客户账号
    ,chn_id -- 渠道编号
    ,int_rat_seg_flg -- 利率分段标志
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,int_accr_begin_dt -- 计息起始日期
    ,provi_begin_dt -- 计提起始日期
    ,provi_end_dt -- 计提结束日期
    ,last_provi_dt -- 上一计提日期
    ,tran_org_id -- 交易机构编号
    ,agt_prefr_amt -- 协议优惠金额
    ,curr_cd -- 币种代码
    ,int_amt -- 利息金额
    ,int_accr_way_cd -- 计息方式代码
    ,int_rat_type_cd -- 利率类型代码
    ,bank_int_int_rat -- 行内利率
    ,term_end_acm_provi_amt -- 期末累计计提金额
    ,term_end_acm_provi_bal -- 期末累计计提差额
    ,term_end_acm_adj_amt -- 期末累计调整金额
    ,term_end_acm_int_tax -- 期末累计利息税金
    ,agt_chg_way_cd -- 协议变动方式代码
    ,agt_fix_int_rat -- 协议固定利率
    ,agt_float_point -- 协议浮动点数
    ,agt_float_ratio -- 协议浮动比例
    ,tax_category_cd -- 税种代码
    ,float_int_rat -- 浮动利率
    ,bank_int_exec_int_rat -- 行内执行利率
    ,tax_rat -- 税率
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,year_int_accr_base_cd -- 年计息基准代码
    ,int_accr_base_cd -- 计息基准代码
    ,currt_acm_provi_amt -- 当期累计计提金额
    ,currt_acm_adj_amt -- 当期累计调整金额
    ,currt_acm_int_accr_days -- 当期累计计息天数
    ,currt_acm_int_tax -- 当期累计利息税
    ,tm_bg_acm_provi_amt -- 期初累计计提金额
    ,tm_bg_acm_provi_bal -- 期初累计计提差额
    ,tm_bg_acm_adj_amt -- 期初累计调整金额
    ,tm_bg_acm_int_tax -- 期初累计利息税
    ,event_type_cd -- 事件类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_acct_int_rat_seg_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,int_cls_cd -- 利息分类代码
    ,acct_id -- 账户编号
    ,bus_start_dt -- 业务开始日期
    ,bus_end_dt -- 业务结束日期
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,cust_acct_num -- 客户账号
    ,chn_id -- 渠道编号
    ,int_rat_seg_flg -- 利率分段标志
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,int_accr_begin_dt -- 计息起始日期
    ,provi_begin_dt -- 计提起始日期
    ,provi_end_dt -- 计提结束日期
    ,last_provi_dt -- 上一计提日期
    ,tran_org_id -- 交易机构编号
    ,agt_prefr_amt -- 协议优惠金额
    ,curr_cd -- 币种代码
    ,int_amt -- 利息金额
    ,int_accr_way_cd -- 计息方式代码
    ,int_rat_type_cd -- 利率类型代码
    ,bank_int_int_rat -- 行内利率
    ,term_end_acm_provi_amt -- 期末累计计提金额
    ,term_end_acm_provi_bal -- 期末累计计提差额
    ,term_end_acm_adj_amt -- 期末累计调整金额
    ,term_end_acm_int_tax -- 期末累计利息税金
    ,agt_chg_way_cd -- 协议变动方式代码
    ,agt_fix_int_rat -- 协议固定利率
    ,agt_float_point -- 协议浮动点数
    ,agt_float_ratio -- 协议浮动比例
    ,tax_category_cd -- 税种代码
    ,float_int_rat -- 浮动利率
    ,bank_int_exec_int_rat -- 行内执行利率
    ,tax_rat -- 税率
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,year_int_accr_base_cd -- 年计息基准代码
    ,int_accr_base_cd -- 计息基准代码
    ,currt_acm_provi_amt -- 当期累计计提金额
    ,currt_acm_adj_amt -- 当期累计调整金额
    ,currt_acm_int_accr_days -- 当期累计计息天数
    ,currt_acm_int_tax -- 当期累计利息税
    ,tm_bg_acm_provi_amt -- 期初累计计提金额
    ,tm_bg_acm_provi_bal -- 期初累计计提差额
    ,tm_bg_acm_adj_amt -- 期初累计调整金额
    ,tm_bg_acm_int_tax -- 期初累计利息税
    ,event_type_cd -- 事件类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.int_cls_cd, o.int_cls_cd) as int_cls_cd -- 利息分类代码
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.bus_start_dt, o.bus_start_dt) as bus_start_dt -- 业务开始日期
    ,nvl(n.bus_end_dt, o.bus_end_dt) as bus_end_dt -- 业务结束日期
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.chn_id, o.chn_id) as chn_id -- 渠道编号
    ,nvl(n.int_rat_seg_flg, o.int_rat_seg_flg) as int_rat_seg_flg -- 利率分段标志
    ,nvl(n.sub_acct_fix_int_rat, o.sub_acct_fix_int_rat) as sub_acct_fix_int_rat -- 分户级固定利率
    ,nvl(n.sub_acct_int_rat_float_ratio, o.sub_acct_int_rat_float_ratio) as sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,nvl(n.sub_acct_int_rat_float_point, o.sub_acct_int_rat_float_point) as sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,nvl(n.int_accr_begin_dt, o.int_accr_begin_dt) as int_accr_begin_dt -- 计息起始日期
    ,nvl(n.provi_begin_dt, o.provi_begin_dt) as provi_begin_dt -- 计提起始日期
    ,nvl(n.provi_end_dt, o.provi_end_dt) as provi_end_dt -- 计提结束日期
    ,nvl(n.last_provi_dt, o.last_provi_dt) as last_provi_dt -- 上一计提日期
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.agt_prefr_amt, o.agt_prefr_amt) as agt_prefr_amt -- 协议优惠金额
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.int_amt, o.int_amt) as int_amt -- 利息金额
    ,nvl(n.int_accr_way_cd, o.int_accr_way_cd) as int_accr_way_cd -- 计息方式代码
    ,nvl(n.int_rat_type_cd, o.int_rat_type_cd) as int_rat_type_cd -- 利率类型代码
    ,nvl(n.bank_int_int_rat, o.bank_int_int_rat) as bank_int_int_rat -- 行内利率
    ,nvl(n.term_end_acm_provi_amt, o.term_end_acm_provi_amt) as term_end_acm_provi_amt -- 期末累计计提金额
    ,nvl(n.term_end_acm_provi_bal, o.term_end_acm_provi_bal) as term_end_acm_provi_bal -- 期末累计计提差额
    ,nvl(n.term_end_acm_adj_amt, o.term_end_acm_adj_amt) as term_end_acm_adj_amt -- 期末累计调整金额
    ,nvl(n.term_end_acm_int_tax, o.term_end_acm_int_tax) as term_end_acm_int_tax -- 期末累计利息税金
    ,nvl(n.agt_chg_way_cd, o.agt_chg_way_cd) as agt_chg_way_cd -- 协议变动方式代码
    ,nvl(n.agt_fix_int_rat, o.agt_fix_int_rat) as agt_fix_int_rat -- 协议固定利率
    ,nvl(n.agt_float_point, o.agt_float_point) as agt_float_point -- 协议浮动点数
    ,nvl(n.agt_float_ratio, o.agt_float_ratio) as agt_float_ratio -- 协议浮动比例
    ,nvl(n.tax_category_cd, o.tax_category_cd) as tax_category_cd -- 税种代码
    ,nvl(n.float_int_rat, o.float_int_rat) as float_int_rat -- 浮动利率
    ,nvl(n.bank_int_exec_int_rat, o.bank_int_exec_int_rat) as bank_int_exec_int_rat -- 行内执行利率
    ,nvl(n.tax_rat, o.tax_rat) as tax_rat -- 税率
    ,nvl(n.mon_int_accr_base_cd, o.mon_int_accr_base_cd) as mon_int_accr_base_cd -- 月计息基准代码
    ,nvl(n.year_int_accr_base_cd, o.year_int_accr_base_cd) as year_int_accr_base_cd -- 年计息基准代码
    ,nvl(n.int_accr_base_cd, o.int_accr_base_cd) as int_accr_base_cd -- 计息基准代码
    ,nvl(n.currt_acm_provi_amt, o.currt_acm_provi_amt) as currt_acm_provi_amt -- 当期累计计提金额
    ,nvl(n.currt_acm_adj_amt, o.currt_acm_adj_amt) as currt_acm_adj_amt -- 当期累计调整金额
    ,nvl(n.currt_acm_int_accr_days, o.currt_acm_int_accr_days) as currt_acm_int_accr_days -- 当期累计计息天数
    ,nvl(n.currt_acm_int_tax, o.currt_acm_int_tax) as currt_acm_int_tax -- 当期累计利息税
    ,nvl(n.tm_bg_acm_provi_amt, o.tm_bg_acm_provi_amt) as tm_bg_acm_provi_amt -- 期初累计计提金额
    ,nvl(n.tm_bg_acm_provi_bal, o.tm_bg_acm_provi_bal) as tm_bg_acm_provi_bal -- 期初累计计提差额
    ,nvl(n.tm_bg_acm_adj_amt, o.tm_bg_acm_adj_amt) as tm_bg_acm_adj_amt -- 期初累计调整金额
    ,nvl(n.tm_bg_acm_int_tax, o.tm_bg_acm_int_tax) as tm_bg_acm_int_tax -- 期初累计利息税
    ,nvl(n.event_type_cd, o.event_type_cd) as event_type_cd -- 事件类型代码
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.int_cls_cd is null
            and n.acct_id is null
            and n.bus_start_dt is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.int_cls_cd is null
            and n.acct_id is null
            and n.bus_start_dt is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.int_cls_cd is null
            and n.acct_id is null
            and n.bus_start_dt is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_acct_int_rat_seg_info_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_dep_acct_int_rat_seg_info_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.int_cls_cd = n.int_cls_cd
            and o.acct_id = n.acct_id
            and o.bus_start_dt = n.bus_start_dt
where (
        o.agt_id is null
        and o.lp_id is null
        and o.int_cls_cd is null
        and o.acct_id is null
        and o.bus_start_dt is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.int_cls_cd is null
        and n.acct_id is null
        and n.bus_start_dt is null
    )
    or (
        o.bus_end_dt <> n.bus_end_dt
        or o.cust_id <> n.cust_id
        or o.prod_id <> n.prod_id
        or o.cust_acct_num <> n.cust_acct_num
        or o.chn_id <> n.chn_id
        or o.int_rat_seg_flg <> n.int_rat_seg_flg
        or o.sub_acct_fix_int_rat <> n.sub_acct_fix_int_rat
        or o.sub_acct_int_rat_float_ratio <> n.sub_acct_int_rat_float_ratio
        or o.sub_acct_int_rat_float_point <> n.sub_acct_int_rat_float_point
        or o.int_accr_begin_dt <> n.int_accr_begin_dt
        or o.provi_begin_dt <> n.provi_begin_dt
        or o.provi_end_dt <> n.provi_end_dt
        or o.last_provi_dt <> n.last_provi_dt
        or o.tran_org_id <> n.tran_org_id
        or o.agt_prefr_amt <> n.agt_prefr_amt
        or o.curr_cd <> n.curr_cd
        or o.int_amt <> n.int_amt
        or o.int_accr_way_cd <> n.int_accr_way_cd
        or o.int_rat_type_cd <> n.int_rat_type_cd
        or o.bank_int_int_rat <> n.bank_int_int_rat
        or o.term_end_acm_provi_amt <> n.term_end_acm_provi_amt
        or o.term_end_acm_provi_bal <> n.term_end_acm_provi_bal
        or o.term_end_acm_adj_amt <> n.term_end_acm_adj_amt
        or o.term_end_acm_int_tax <> n.term_end_acm_int_tax
        or o.agt_chg_way_cd <> n.agt_chg_way_cd
        or o.agt_fix_int_rat <> n.agt_fix_int_rat
        or o.agt_float_point <> n.agt_float_point
        or o.agt_float_ratio <> n.agt_float_ratio
        or o.tax_category_cd <> n.tax_category_cd
        or o.float_int_rat <> n.float_int_rat
        or o.bank_int_exec_int_rat <> n.bank_int_exec_int_rat
        or o.tax_rat <> n.tax_rat
        or o.mon_int_accr_base_cd <> n.mon_int_accr_base_cd
        or o.year_int_accr_base_cd <> n.year_int_accr_base_cd
        or o.int_accr_base_cd <> n.int_accr_base_cd
        or o.currt_acm_provi_amt <> n.currt_acm_provi_amt
        or o.currt_acm_adj_amt <> n.currt_acm_adj_amt
        or o.currt_acm_int_accr_days <> n.currt_acm_int_accr_days
        or o.currt_acm_int_tax <> n.currt_acm_int_tax
        or o.tm_bg_acm_provi_amt <> n.tm_bg_acm_provi_amt
        or o.tm_bg_acm_provi_bal <> n.tm_bg_acm_provi_bal
        or o.tm_bg_acm_adj_amt <> n.tm_bg_acm_adj_amt
        or o.tm_bg_acm_int_tax <> n.tm_bg_acm_int_tax
        or o.event_type_cd <> n.event_type_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_dep_acct_int_rat_seg_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,int_cls_cd -- 利息分类代码
    ,acct_id -- 账户编号
    ,bus_start_dt -- 业务开始日期
    ,bus_end_dt -- 业务结束日期
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,cust_acct_num -- 客户账号
    ,chn_id -- 渠道编号
    ,int_rat_seg_flg -- 利率分段标志
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,int_accr_begin_dt -- 计息起始日期
    ,provi_begin_dt -- 计提起始日期
    ,provi_end_dt -- 计提结束日期
    ,last_provi_dt -- 上一计提日期
    ,tran_org_id -- 交易机构编号
    ,agt_prefr_amt -- 协议优惠金额
    ,curr_cd -- 币种代码
    ,int_amt -- 利息金额
    ,int_accr_way_cd -- 计息方式代码
    ,int_rat_type_cd -- 利率类型代码
    ,bank_int_int_rat -- 行内利率
    ,term_end_acm_provi_amt -- 期末累计计提金额
    ,term_end_acm_provi_bal -- 期末累计计提差额
    ,term_end_acm_adj_amt -- 期末累计调整金额
    ,term_end_acm_int_tax -- 期末累计利息税金
    ,agt_chg_way_cd -- 协议变动方式代码
    ,agt_fix_int_rat -- 协议固定利率
    ,agt_float_point -- 协议浮动点数
    ,agt_float_ratio -- 协议浮动比例
    ,tax_category_cd -- 税种代码
    ,float_int_rat -- 浮动利率
    ,bank_int_exec_int_rat -- 行内执行利率
    ,tax_rat -- 税率
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,year_int_accr_base_cd -- 年计息基准代码
    ,int_accr_base_cd -- 计息基准代码
    ,currt_acm_provi_amt -- 当期累计计提金额
    ,currt_acm_adj_amt -- 当期累计调整金额
    ,currt_acm_int_accr_days -- 当期累计计息天数
    ,currt_acm_int_tax -- 当期累计利息税
    ,tm_bg_acm_provi_amt -- 期初累计计提金额
    ,tm_bg_acm_provi_bal -- 期初累计计提差额
    ,tm_bg_acm_adj_amt -- 期初累计调整金额
    ,tm_bg_acm_int_tax -- 期初累计利息税
    ,event_type_cd -- 事件类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_acct_int_rat_seg_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,int_cls_cd -- 利息分类代码
    ,acct_id -- 账户编号
    ,bus_start_dt -- 业务开始日期
    ,bus_end_dt -- 业务结束日期
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,cust_acct_num -- 客户账号
    ,chn_id -- 渠道编号
    ,int_rat_seg_flg -- 利率分段标志
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,int_accr_begin_dt -- 计息起始日期
    ,provi_begin_dt -- 计提起始日期
    ,provi_end_dt -- 计提结束日期
    ,last_provi_dt -- 上一计提日期
    ,tran_org_id -- 交易机构编号
    ,agt_prefr_amt -- 协议优惠金额
    ,curr_cd -- 币种代码
    ,int_amt -- 利息金额
    ,int_accr_way_cd -- 计息方式代码
    ,int_rat_type_cd -- 利率类型代码
    ,bank_int_int_rat -- 行内利率
    ,term_end_acm_provi_amt -- 期末累计计提金额
    ,term_end_acm_provi_bal -- 期末累计计提差额
    ,term_end_acm_adj_amt -- 期末累计调整金额
    ,term_end_acm_int_tax -- 期末累计利息税金
    ,agt_chg_way_cd -- 协议变动方式代码
    ,agt_fix_int_rat -- 协议固定利率
    ,agt_float_point -- 协议浮动点数
    ,agt_float_ratio -- 协议浮动比例
    ,tax_category_cd -- 税种代码
    ,float_int_rat -- 浮动利率
    ,bank_int_exec_int_rat -- 行内执行利率
    ,tax_rat -- 税率
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,year_int_accr_base_cd -- 年计息基准代码
    ,int_accr_base_cd -- 计息基准代码
    ,currt_acm_provi_amt -- 当期累计计提金额
    ,currt_acm_adj_amt -- 当期累计调整金额
    ,currt_acm_int_accr_days -- 当期累计计息天数
    ,currt_acm_int_tax -- 当期累计利息税
    ,tm_bg_acm_provi_amt -- 期初累计计提金额
    ,tm_bg_acm_provi_bal -- 期初累计计提差额
    ,tm_bg_acm_adj_amt -- 期初累计调整金额
    ,tm_bg_acm_int_tax -- 期初累计利息税
    ,event_type_cd -- 事件类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.int_cls_cd -- 利息分类代码
    ,o.acct_id -- 账户编号
    ,o.bus_start_dt -- 业务开始日期
    ,o.bus_end_dt -- 业务结束日期
    ,o.cust_id -- 客户编号
    ,o.prod_id -- 产品编号
    ,o.cust_acct_num -- 客户账号
    ,o.chn_id -- 渠道编号
    ,o.int_rat_seg_flg -- 利率分段标志
    ,o.sub_acct_fix_int_rat -- 分户级固定利率
    ,o.sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,o.sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,o.int_accr_begin_dt -- 计息起始日期
    ,o.provi_begin_dt -- 计提起始日期
    ,o.provi_end_dt -- 计提结束日期
    ,o.last_provi_dt -- 上一计提日期
    ,o.tran_org_id -- 交易机构编号
    ,o.agt_prefr_amt -- 协议优惠金额
    ,o.curr_cd -- 币种代码
    ,o.int_amt -- 利息金额
    ,o.int_accr_way_cd -- 计息方式代码
    ,o.int_rat_type_cd -- 利率类型代码
    ,o.bank_int_int_rat -- 行内利率
    ,o.term_end_acm_provi_amt -- 期末累计计提金额
    ,o.term_end_acm_provi_bal -- 期末累计计提差额
    ,o.term_end_acm_adj_amt -- 期末累计调整金额
    ,o.term_end_acm_int_tax -- 期末累计利息税金
    ,o.agt_chg_way_cd -- 协议变动方式代码
    ,o.agt_fix_int_rat -- 协议固定利率
    ,o.agt_float_point -- 协议浮动点数
    ,o.agt_float_ratio -- 协议浮动比例
    ,o.tax_category_cd -- 税种代码
    ,o.float_int_rat -- 浮动利率
    ,o.bank_int_exec_int_rat -- 行内执行利率
    ,o.tax_rat -- 税率
    ,o.mon_int_accr_base_cd -- 月计息基准代码
    ,o.year_int_accr_base_cd -- 年计息基准代码
    ,o.int_accr_base_cd -- 计息基准代码
    ,o.currt_acm_provi_amt -- 当期累计计提金额
    ,o.currt_acm_adj_amt -- 当期累计调整金额
    ,o.currt_acm_int_accr_days -- 当期累计计息天数
    ,o.currt_acm_int_tax -- 当期累计利息税
    ,o.tm_bg_acm_provi_amt -- 期初累计计提金额
    ,o.tm_bg_acm_provi_bal -- 期初累计计提差额
    ,o.tm_bg_acm_adj_amt -- 期初累计调整金额
    ,o.tm_bg_acm_int_tax -- 期初累计利息税
    ,o.event_type_cd -- 事件类型代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_acct_int_rat_seg_info_h_ncbsf1_bk o
    left join ${iml_schema}.agt_dep_acct_int_rat_seg_info_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.int_cls_cd = n.int_cls_cd
            and o.acct_id = n.acct_id
            and o.bus_start_dt = n.bus_start_dt
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_dep_acct_int_rat_seg_info_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.int_cls_cd = d.int_cls_cd
            and o.acct_id = d.acct_id
            and o.bus_start_dt = d.bus_start_dt
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_dep_acct_int_rat_seg_info_h;
--alter table ${iml_schema}.agt_dep_acct_int_rat_seg_info_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_dep_acct_int_rat_seg_info_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_dep_acct_int_rat_seg_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_dep_acct_int_rat_seg_info_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_dep_acct_int_rat_seg_info_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_dep_acct_int_rat_seg_info_h_ncbsf1_cl;
alter table ${iml_schema}.agt_dep_acct_int_rat_seg_info_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_dep_acct_int_rat_seg_info_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_dep_acct_int_rat_seg_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_dep_acct_int_rat_seg_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_acct_int_rat_seg_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_acct_int_rat_seg_info_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_dep_acct_int_rat_seg_info_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_dep_acct_int_rat_seg_info_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
