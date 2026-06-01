/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_acct_int_accr_cfg_h_ncbsf1
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
alter table ${iml_schema}.agt_loan_acct_int_accr_cfg_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_acct_int_accr_cfg_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_acct_int_accr_cfg_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_acct_int_accr_cfg_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_loan_acct_int_accr_cfg_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_loan_acct_int_accr_cfg_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_acct_int_accr_cfg_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,int_cls_cd -- 利息分类代码
    ,cust_id -- 客户编号
    ,int_rat_type_cd -- 利率类型代码
    ,bank_int_int_rat -- 行内利率
    ,int_rat_float_point -- 利率浮动点数
    ,int_rat_float_ratio -- 利率浮动比例
    ,float_int_rat -- 浮动利率
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,higt_exec_int_rat -- 最高执行利率
    ,lowt_exec_int_rat -- 最低执行利率
    ,accrd_nomal_int_rat_float_flg -- 按正常利率浮动标志
    ,exec_int_rat -- 执行利率
    ,int_set_freq_cd -- 结息频率代码
    ,int_set_day -- 结息日
    ,int_accr_way_cd -- 计息方式代码
    ,year_int_accr_base_cd -- 年计息基准代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,int_accr_base_cd -- 计息基准代码
    ,int_accr_flg -- 计息标志
    ,cap_flg -- 资本化标志
    ,int_set_flg -- 结息标志
    ,acalc_flg -- 重算标志
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,int_rat_effect_way_cd -- 利率生效方式代码
    ,int_rat_modif_ped_cd -- 利率变更周期代码
    ,int_rat_chg_dt -- 利率变动日期
    ,int_rat_modif_day -- 利率变更日
    ,next_int_rat_modif_dt -- 下次重定价日期
    ,last_int_rat_modif_dt -- 上次重定价日期
    ,exec_int_rat_chg_flg -- 执行利率变化标志
    ,tax_category_cd -- 税种代码
    ,tax_rat -- 税率
    ,pnlt_int_rat_use_way_cd -- 罚息利率使用方式代码
    ,int_provi_day -- 利息计提日
    ,int_provi_ped -- 利息计提周期
    ,agt_chg_way_cd -- 协议变动方式代码
    ,agt_fix_int_rat -- 协议固定利率
    ,agt_float_ratio -- 协议浮动比例
    ,agt_float_point -- 协议浮动点数
    ,sub_acct_fix_tax_rat -- 分户级固定税率
    ,sub_acct_tax_rat_float_point -- 分户级税率浮动点数
    ,sub_acct_tax_rat_float_ratio -- 分户级税率浮动比例
    ,exch_rat_float_cate_cd -- 汇率浮动类别代码
    ,int_rat_day_type_cd -- 利率日类型代码
    ,acrs_ped_flg -- 跨周期标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_acct_int_accr_cfg_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_acct_int_accr_cfg_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_acct_int_accr_cfg_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_loan_acct_int_accr_cfg_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_acct_int_accr_cfg_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_cl_acct_rate_detail-1
insert into ${iml_schema}.agt_loan_acct_int_accr_cfg_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,int_cls_cd -- 利息分类代码
    ,cust_id -- 客户编号
    ,int_rat_type_cd -- 利率类型代码
    ,bank_int_int_rat -- 行内利率
    ,int_rat_float_point -- 利率浮动点数
    ,int_rat_float_ratio -- 利率浮动比例
    ,float_int_rat -- 浮动利率
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,higt_exec_int_rat -- 最高执行利率
    ,lowt_exec_int_rat -- 最低执行利率
    ,accrd_nomal_int_rat_float_flg -- 按正常利率浮动标志
    ,exec_int_rat -- 执行利率
    ,int_set_freq_cd -- 结息频率代码
    ,int_set_day -- 结息日
    ,int_accr_way_cd -- 计息方式代码
    ,year_int_accr_base_cd -- 年计息基准代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,int_accr_base_cd -- 计息基准代码
    ,int_accr_flg -- 计息标志
    ,cap_flg -- 资本化标志
    ,int_set_flg -- 结息标志
    ,acalc_flg -- 重算标志
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,int_rat_effect_way_cd -- 利率生效方式代码
    ,int_rat_modif_ped_cd -- 利率变更周期代码
    ,int_rat_chg_dt -- 利率变动日期
    ,int_rat_modif_day -- 利率变更日
    ,next_int_rat_modif_dt -- 下次重定价日期
    ,last_int_rat_modif_dt -- 上次重定价日期
    ,exec_int_rat_chg_flg -- 执行利率变化标志
    ,tax_category_cd -- 税种代码
    ,tax_rat -- 税率
    ,pnlt_int_rat_use_way_cd -- 罚息利率使用方式代码
    ,int_provi_day -- 利息计提日
    ,int_provi_ped -- 利息计提周期
    ,agt_chg_way_cd -- 协议变动方式代码
    ,agt_fix_int_rat -- 协议固定利率
    ,agt_float_ratio -- 协议浮动比例
    ,agt_float_point -- 协议浮动点数
    ,sub_acct_fix_tax_rat -- 分户级固定税率
    ,sub_acct_tax_rat_float_point -- 分户级税率浮动点数
    ,sub_acct_tax_rat_float_ratio -- 分户级税率浮动比例
    ,exch_rat_float_cate_cd -- 汇率浮动类别代码
    ,int_rat_day_type_cd -- 利率日类型代码
    ,acrs_ped_flg -- 跨周期标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300001'||P1.INTERNAL_KEY -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.INT_CLASS -- 利息分类代码
    ,P1.CLIENT_NO -- 客户编号
    ,P1.INT_TYPE -- 利率类型代码
    ,P1.ACTUAL_RATE -- 行内利率
    ,P1.SPREAD_RATE -- 利率浮动点数
    ,P1.SPREAD_PERCENT -- 利率浮动比例
    ,P1.FLOAT_RATE -- 浮动利率
    ,P1.ACCT_SPREAD_RATE -- 分户级利率浮动点数
    ,P1.ACCT_PERCENT_RATE -- 分户级利率浮动比例
    ,P1.ACCT_FIXED_RATE -- 分户级固定利率
    ,P1.MAX_INT_RATE -- 最高执行利率
    ,P1.MIN_INT_RATE -- 最低执行利率
    ,DECODE(P1.CALC_BY_INT,'Y','1','N','0') -- 按正常利率浮动标志
    ,P1.REAL_RATE -- 执行利率
    ,P1.CYCLE_FREQ -- 结息频率代码
    ,NVL(TRIM(P1.INT_DAY),0) -- 结息日
    ,nvl(trim(P1.INT_CALC_BAL),'-') -- 计息方式代码
    ,P1.YEAR_BASIS -- 年计息基准代码
    ,P1.MONTH_BASIS -- 月计息基准代码
    ,case when p1.MONTH_BASIS='ACT' and p1.YEAR_BASIS='360'  then 'A/360'
     when p1.MONTH_BASIS='D30' and p1.YEAR_BASIS='360'  then '30/360'
     when p1.MONTH_BASIS='ACT' and p1.YEAR_BASIS='365'  then 'A/365'
     when p1.MONTH_BASIS='D30' and p1.YEAR_BASIS='365'  then '30/365'
     when p1.MONTH_BASIS='ACT' and p1.YEAR_BASIS='366'  then  'A/366'
     else '-'  end -- 计息基准代码
    ,decode(trim(p1.INT_IND_FLAG),'','-','Y','1','N','0',p1.INT_IND_FLAG) -- 计息标志
    ,DECODE(P1.INT_CAP_FLAG,'Y','1','N','0') -- 资本化标志
    ,DECODE(P1.CYCLE_FLAG,'Y','1','N','0') -- 结息标志
    ,DECODE(P1.RETRY_FLAG,'Y','1','N','0') -- 重算标志
    ,P1.INT_APPL_TYPE -- 利率启用方式代码
    ,P1.RATE_EFFECT_TYPE -- 利率生效方式代码
    ,P1.ROLL_FREQ -- 利率变更周期代码
    ,P1.ROLL_DATE -- 利率变动日期
    ,NVL(TRIM(P1.ROLL_DAY),0) -- 利率变更日
    ,P1.NEXT_ROLL_DATE -- 下次重定价日期
    ,P1.LAST_ROLL_DATE -- 上次重定价日期
    ,DECODE(P1.RATE_CHANGE_IND,'Y','1','N','0') -- 执行利率变化标志
    ,P1.TAX_TYPE -- 税种代码
    ,P1.TAX_RATE -- 税率
    ,nvl(trim(P1.PENALTY_ODI_RATE_TYPE),'-') -- 罚息利率使用方式代码
    ,NVL(TRIM(P1.ACCR_INT_DAY),0) -- 利息计提日
    ,NVL(TRIM(P1.ACCR_PERIOD_FREQ),0) -- 利息计提周期
    ,P1.AGREE_CHANGE_TYPE -- 协议变动方式代码
    ,P1.AGREE_FIXED_RATE -- 协议固定利率
    ,P1.AGREE_PERCENT_RATE -- 协议浮动比例
    ,P1.AGREE_SPREAD_RATE -- 协议浮动点数
    ,P1.ACCT_FIXED_TAX_RATE -- 分户级固定税率
    ,P1.ACCT_SPREAD_TAX_RATE -- 分户级税率浮动点数
    ,P1.ACCT_PERCENT_TAX_RATE -- 分户级税率浮动比例
    ,P1.FLOAT_TYPE -- 汇率浮动类别代码
    ,nvl(trim(P1.FOLLOW_INT_DAY_TYPE),'-') -- 利率日类型代码
    ,P1.IS_CROSS_FLAG -- 跨周期标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_acct_rate_detail' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_acct_rate_detail p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_acct_int_accr_cfg_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,acct_id
  	                                        ,int_cls_cd
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
        into ${iml_schema}.agt_loan_acct_int_accr_cfg_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,int_cls_cd -- 利息分类代码
    ,cust_id -- 客户编号
    ,int_rat_type_cd -- 利率类型代码
    ,bank_int_int_rat -- 行内利率
    ,int_rat_float_point -- 利率浮动点数
    ,int_rat_float_ratio -- 利率浮动比例
    ,float_int_rat -- 浮动利率
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,higt_exec_int_rat -- 最高执行利率
    ,lowt_exec_int_rat -- 最低执行利率
    ,accrd_nomal_int_rat_float_flg -- 按正常利率浮动标志
    ,exec_int_rat -- 执行利率
    ,int_set_freq_cd -- 结息频率代码
    ,int_set_day -- 结息日
    ,int_accr_way_cd -- 计息方式代码
    ,year_int_accr_base_cd -- 年计息基准代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,int_accr_base_cd -- 计息基准代码
    ,int_accr_flg -- 计息标志
    ,cap_flg -- 资本化标志
    ,int_set_flg -- 结息标志
    ,acalc_flg -- 重算标志
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,int_rat_effect_way_cd -- 利率生效方式代码
    ,int_rat_modif_ped_cd -- 利率变更周期代码
    ,int_rat_chg_dt -- 利率变动日期
    ,int_rat_modif_day -- 利率变更日
    ,next_int_rat_modif_dt -- 下次重定价日期
    ,last_int_rat_modif_dt -- 上次重定价日期
    ,exec_int_rat_chg_flg -- 执行利率变化标志
    ,tax_category_cd -- 税种代码
    ,tax_rat -- 税率
    ,pnlt_int_rat_use_way_cd -- 罚息利率使用方式代码
    ,int_provi_day -- 利息计提日
    ,int_provi_ped -- 利息计提周期
    ,agt_chg_way_cd -- 协议变动方式代码
    ,agt_fix_int_rat -- 协议固定利率
    ,agt_float_ratio -- 协议浮动比例
    ,agt_float_point -- 协议浮动点数
    ,sub_acct_fix_tax_rat -- 分户级固定税率
    ,sub_acct_tax_rat_float_point -- 分户级税率浮动点数
    ,sub_acct_tax_rat_float_ratio -- 分户级税率浮动比例
    ,exch_rat_float_cate_cd -- 汇率浮动类别代码
    ,int_rat_day_type_cd -- 利率日类型代码
    ,acrs_ped_flg -- 跨周期标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_acct_int_accr_cfg_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,int_cls_cd -- 利息分类代码
    ,cust_id -- 客户编号
    ,int_rat_type_cd -- 利率类型代码
    ,bank_int_int_rat -- 行内利率
    ,int_rat_float_point -- 利率浮动点数
    ,int_rat_float_ratio -- 利率浮动比例
    ,float_int_rat -- 浮动利率
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,higt_exec_int_rat -- 最高执行利率
    ,lowt_exec_int_rat -- 最低执行利率
    ,accrd_nomal_int_rat_float_flg -- 按正常利率浮动标志
    ,exec_int_rat -- 执行利率
    ,int_set_freq_cd -- 结息频率代码
    ,int_set_day -- 结息日
    ,int_accr_way_cd -- 计息方式代码
    ,year_int_accr_base_cd -- 年计息基准代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,int_accr_base_cd -- 计息基准代码
    ,int_accr_flg -- 计息标志
    ,cap_flg -- 资本化标志
    ,int_set_flg -- 结息标志
    ,acalc_flg -- 重算标志
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,int_rat_effect_way_cd -- 利率生效方式代码
    ,int_rat_modif_ped_cd -- 利率变更周期代码
    ,int_rat_chg_dt -- 利率变动日期
    ,int_rat_modif_day -- 利率变更日
    ,next_int_rat_modif_dt -- 下次重定价日期
    ,last_int_rat_modif_dt -- 上次重定价日期
    ,exec_int_rat_chg_flg -- 执行利率变化标志
    ,tax_category_cd -- 税种代码
    ,tax_rat -- 税率
    ,pnlt_int_rat_use_way_cd -- 罚息利率使用方式代码
    ,int_provi_day -- 利息计提日
    ,int_provi_ped -- 利息计提周期
    ,agt_chg_way_cd -- 协议变动方式代码
    ,agt_fix_int_rat -- 协议固定利率
    ,agt_float_ratio -- 协议浮动比例
    ,agt_float_point -- 协议浮动点数
    ,sub_acct_fix_tax_rat -- 分户级固定税率
    ,sub_acct_tax_rat_float_point -- 分户级税率浮动点数
    ,sub_acct_tax_rat_float_ratio -- 分户级税率浮动比例
    ,exch_rat_float_cate_cd -- 汇率浮动类别代码
    ,int_rat_day_type_cd -- 利率日类型代码
    ,acrs_ped_flg -- 跨周期标志
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
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.int_cls_cd, o.int_cls_cd) as int_cls_cd -- 利息分类代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.int_rat_type_cd, o.int_rat_type_cd) as int_rat_type_cd -- 利率类型代码
    ,nvl(n.bank_int_int_rat, o.bank_int_int_rat) as bank_int_int_rat -- 行内利率
    ,nvl(n.int_rat_float_point, o.int_rat_float_point) as int_rat_float_point -- 利率浮动点数
    ,nvl(n.int_rat_float_ratio, o.int_rat_float_ratio) as int_rat_float_ratio -- 利率浮动比例
    ,nvl(n.float_int_rat, o.float_int_rat) as float_int_rat -- 浮动利率
    ,nvl(n.sub_acct_int_rat_float_point, o.sub_acct_int_rat_float_point) as sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,nvl(n.sub_acct_int_rat_float_ratio, o.sub_acct_int_rat_float_ratio) as sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,nvl(n.sub_acct_fix_int_rat, o.sub_acct_fix_int_rat) as sub_acct_fix_int_rat -- 分户级固定利率
    ,nvl(n.higt_exec_int_rat, o.higt_exec_int_rat) as higt_exec_int_rat -- 最高执行利率
    ,nvl(n.lowt_exec_int_rat, o.lowt_exec_int_rat) as lowt_exec_int_rat -- 最低执行利率
    ,nvl(n.accrd_nomal_int_rat_float_flg, o.accrd_nomal_int_rat_float_flg) as accrd_nomal_int_rat_float_flg -- 按正常利率浮动标志
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.int_set_freq_cd, o.int_set_freq_cd) as int_set_freq_cd -- 结息频率代码
    ,nvl(n.int_set_day, o.int_set_day) as int_set_day -- 结息日
    ,nvl(n.int_accr_way_cd, o.int_accr_way_cd) as int_accr_way_cd -- 计息方式代码
    ,nvl(n.year_int_accr_base_cd, o.year_int_accr_base_cd) as year_int_accr_base_cd -- 年计息基准代码
    ,nvl(n.mon_int_accr_base_cd, o.mon_int_accr_base_cd) as mon_int_accr_base_cd -- 月计息基准代码
    ,nvl(n.int_accr_base_cd, o.int_accr_base_cd) as int_accr_base_cd -- 计息基准代码
    ,nvl(n.int_accr_flg, o.int_accr_flg) as int_accr_flg -- 计息标志
    ,nvl(n.cap_flg, o.cap_flg) as cap_flg -- 资本化标志
    ,nvl(n.int_set_flg, o.int_set_flg) as int_set_flg -- 结息标志
    ,nvl(n.acalc_flg, o.acalc_flg) as acalc_flg -- 重算标志
    ,nvl(n.int_rat_start_use_way_cd, o.int_rat_start_use_way_cd) as int_rat_start_use_way_cd -- 利率启用方式代码
    ,nvl(n.int_rat_effect_way_cd, o.int_rat_effect_way_cd) as int_rat_effect_way_cd -- 利率生效方式代码
    ,nvl(n.int_rat_modif_ped_cd, o.int_rat_modif_ped_cd) as int_rat_modif_ped_cd -- 利率变更周期代码
    ,nvl(n.int_rat_chg_dt, o.int_rat_chg_dt) as int_rat_chg_dt -- 利率变动日期
    ,nvl(n.int_rat_modif_day, o.int_rat_modif_day) as int_rat_modif_day -- 利率变更日
    ,nvl(n.next_int_rat_modif_dt, o.next_int_rat_modif_dt) as next_int_rat_modif_dt -- 下次重定价日期
    ,nvl(n.last_int_rat_modif_dt, o.last_int_rat_modif_dt) as last_int_rat_modif_dt -- 上次重定价日期
    ,nvl(n.exec_int_rat_chg_flg, o.exec_int_rat_chg_flg) as exec_int_rat_chg_flg -- 执行利率变化标志
    ,nvl(n.tax_category_cd, o.tax_category_cd) as tax_category_cd -- 税种代码
    ,nvl(n.tax_rat, o.tax_rat) as tax_rat -- 税率
    ,nvl(n.pnlt_int_rat_use_way_cd, o.pnlt_int_rat_use_way_cd) as pnlt_int_rat_use_way_cd -- 罚息利率使用方式代码
    ,nvl(n.int_provi_day, o.int_provi_day) as int_provi_day -- 利息计提日
    ,nvl(n.int_provi_ped, o.int_provi_ped) as int_provi_ped -- 利息计提周期
    ,nvl(n.agt_chg_way_cd, o.agt_chg_way_cd) as agt_chg_way_cd -- 协议变动方式代码
    ,nvl(n.agt_fix_int_rat, o.agt_fix_int_rat) as agt_fix_int_rat -- 协议固定利率
    ,nvl(n.agt_float_ratio, o.agt_float_ratio) as agt_float_ratio -- 协议浮动比例
    ,nvl(n.agt_float_point, o.agt_float_point) as agt_float_point -- 协议浮动点数
    ,nvl(n.sub_acct_fix_tax_rat, o.sub_acct_fix_tax_rat) as sub_acct_fix_tax_rat -- 分户级固定税率
    ,nvl(n.sub_acct_tax_rat_float_point, o.sub_acct_tax_rat_float_point) as sub_acct_tax_rat_float_point -- 分户级税率浮动点数
    ,nvl(n.sub_acct_tax_rat_float_ratio, o.sub_acct_tax_rat_float_ratio) as sub_acct_tax_rat_float_ratio -- 分户级税率浮动比例
    ,nvl(n.exch_rat_float_cate_cd, o.exch_rat_float_cate_cd) as exch_rat_float_cate_cd -- 汇率浮动类别代码
    ,nvl(n.int_rat_day_type_cd, o.int_rat_day_type_cd) as int_rat_day_type_cd -- 利率日类型代码
    ,nvl(n.acrs_ped_flg, o.acrs_ped_flg) as acrs_ped_flg -- 跨周期标志
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
            and n.int_cls_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
            and n.int_cls_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
            and n.int_cls_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_acct_int_accr_cfg_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_acct_int_accr_cfg_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_id = n.acct_id
            and o.int_cls_cd = n.int_cls_cd
where (
        o.agt_id is null
        and o.lp_id is null
        and o.acct_id is null
        and o.int_cls_cd is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.acct_id is null
        and n.int_cls_cd is null
    )
    or (
        o.cust_id <> n.cust_id
        or o.int_rat_type_cd <> n.int_rat_type_cd
        or o.bank_int_int_rat <> n.bank_int_int_rat
        or o.int_rat_float_point <> n.int_rat_float_point
        or o.int_rat_float_ratio <> n.int_rat_float_ratio
        or o.float_int_rat <> n.float_int_rat
        or o.sub_acct_int_rat_float_point <> n.sub_acct_int_rat_float_point
        or o.sub_acct_int_rat_float_ratio <> n.sub_acct_int_rat_float_ratio
        or o.sub_acct_fix_int_rat <> n.sub_acct_fix_int_rat
        or o.higt_exec_int_rat <> n.higt_exec_int_rat
        or o.lowt_exec_int_rat <> n.lowt_exec_int_rat
        or o.accrd_nomal_int_rat_float_flg <> n.accrd_nomal_int_rat_float_flg
        or o.exec_int_rat <> n.exec_int_rat
        or o.int_set_freq_cd <> n.int_set_freq_cd
        or o.int_set_day <> n.int_set_day
        or o.int_accr_way_cd <> n.int_accr_way_cd
        or o.year_int_accr_base_cd <> n.year_int_accr_base_cd
        or o.mon_int_accr_base_cd <> n.mon_int_accr_base_cd
        or o.int_accr_base_cd <> n.int_accr_base_cd
        or o.int_accr_flg <> n.int_accr_flg
        or o.cap_flg <> n.cap_flg
        or o.int_set_flg <> n.int_set_flg
        or o.acalc_flg <> n.acalc_flg
        or o.int_rat_start_use_way_cd <> n.int_rat_start_use_way_cd
        or o.int_rat_effect_way_cd <> n.int_rat_effect_way_cd
        or o.int_rat_modif_ped_cd <> n.int_rat_modif_ped_cd
        or o.int_rat_chg_dt <> n.int_rat_chg_dt
        or o.int_rat_modif_day <> n.int_rat_modif_day
        or o.next_int_rat_modif_dt <> n.next_int_rat_modif_dt
        or o.last_int_rat_modif_dt <> n.last_int_rat_modif_dt
        or o.exec_int_rat_chg_flg <> n.exec_int_rat_chg_flg
        or o.tax_category_cd <> n.tax_category_cd
        or o.tax_rat <> n.tax_rat
        or o.pnlt_int_rat_use_way_cd <> n.pnlt_int_rat_use_way_cd
        or o.int_provi_day <> n.int_provi_day
        or o.int_provi_ped <> n.int_provi_ped
        or o.agt_chg_way_cd <> n.agt_chg_way_cd
        or o.agt_fix_int_rat <> n.agt_fix_int_rat
        or o.agt_float_ratio <> n.agt_float_ratio
        or o.agt_float_point <> n.agt_float_point
        or o.sub_acct_fix_tax_rat <> n.sub_acct_fix_tax_rat
        or o.sub_acct_tax_rat_float_point <> n.sub_acct_tax_rat_float_point
        or o.sub_acct_tax_rat_float_ratio <> n.sub_acct_tax_rat_float_ratio
        or o.exch_rat_float_cate_cd <> n.exch_rat_float_cate_cd
        or o.int_rat_day_type_cd <> n.int_rat_day_type_cd
        or o.acrs_ped_flg <> n.acrs_ped_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_acct_int_accr_cfg_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,int_cls_cd -- 利息分类代码
    ,cust_id -- 客户编号
    ,int_rat_type_cd -- 利率类型代码
    ,bank_int_int_rat -- 行内利率
    ,int_rat_float_point -- 利率浮动点数
    ,int_rat_float_ratio -- 利率浮动比例
    ,float_int_rat -- 浮动利率
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,higt_exec_int_rat -- 最高执行利率
    ,lowt_exec_int_rat -- 最低执行利率
    ,accrd_nomal_int_rat_float_flg -- 按正常利率浮动标志
    ,exec_int_rat -- 执行利率
    ,int_set_freq_cd -- 结息频率代码
    ,int_set_day -- 结息日
    ,int_accr_way_cd -- 计息方式代码
    ,year_int_accr_base_cd -- 年计息基准代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,int_accr_base_cd -- 计息基准代码
    ,int_accr_flg -- 计息标志
    ,cap_flg -- 资本化标志
    ,int_set_flg -- 结息标志
    ,acalc_flg -- 重算标志
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,int_rat_effect_way_cd -- 利率生效方式代码
    ,int_rat_modif_ped_cd -- 利率变更周期代码
    ,int_rat_chg_dt -- 利率变动日期
    ,int_rat_modif_day -- 利率变更日
    ,next_int_rat_modif_dt -- 下次重定价日期
    ,last_int_rat_modif_dt -- 上次重定价日期
    ,exec_int_rat_chg_flg -- 执行利率变化标志
    ,tax_category_cd -- 税种代码
    ,tax_rat -- 税率
    ,pnlt_int_rat_use_way_cd -- 罚息利率使用方式代码
    ,int_provi_day -- 利息计提日
    ,int_provi_ped -- 利息计提周期
    ,agt_chg_way_cd -- 协议变动方式代码
    ,agt_fix_int_rat -- 协议固定利率
    ,agt_float_ratio -- 协议浮动比例
    ,agt_float_point -- 协议浮动点数
    ,sub_acct_fix_tax_rat -- 分户级固定税率
    ,sub_acct_tax_rat_float_point -- 分户级税率浮动点数
    ,sub_acct_tax_rat_float_ratio -- 分户级税率浮动比例
    ,exch_rat_float_cate_cd -- 汇率浮动类别代码
    ,int_rat_day_type_cd -- 利率日类型代码
    ,acrs_ped_flg -- 跨周期标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_acct_int_accr_cfg_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,int_cls_cd -- 利息分类代码
    ,cust_id -- 客户编号
    ,int_rat_type_cd -- 利率类型代码
    ,bank_int_int_rat -- 行内利率
    ,int_rat_float_point -- 利率浮动点数
    ,int_rat_float_ratio -- 利率浮动比例
    ,float_int_rat -- 浮动利率
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,higt_exec_int_rat -- 最高执行利率
    ,lowt_exec_int_rat -- 最低执行利率
    ,accrd_nomal_int_rat_float_flg -- 按正常利率浮动标志
    ,exec_int_rat -- 执行利率
    ,int_set_freq_cd -- 结息频率代码
    ,int_set_day -- 结息日
    ,int_accr_way_cd -- 计息方式代码
    ,year_int_accr_base_cd -- 年计息基准代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,int_accr_base_cd -- 计息基准代码
    ,int_accr_flg -- 计息标志
    ,cap_flg -- 资本化标志
    ,int_set_flg -- 结息标志
    ,acalc_flg -- 重算标志
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,int_rat_effect_way_cd -- 利率生效方式代码
    ,int_rat_modif_ped_cd -- 利率变更周期代码
    ,int_rat_chg_dt -- 利率变动日期
    ,int_rat_modif_day -- 利率变更日
    ,next_int_rat_modif_dt -- 下次重定价日期
    ,last_int_rat_modif_dt -- 上次重定价日期
    ,exec_int_rat_chg_flg -- 执行利率变化标志
    ,tax_category_cd -- 税种代码
    ,tax_rat -- 税率
    ,pnlt_int_rat_use_way_cd -- 罚息利率使用方式代码
    ,int_provi_day -- 利息计提日
    ,int_provi_ped -- 利息计提周期
    ,agt_chg_way_cd -- 协议变动方式代码
    ,agt_fix_int_rat -- 协议固定利率
    ,agt_float_ratio -- 协议浮动比例
    ,agt_float_point -- 协议浮动点数
    ,sub_acct_fix_tax_rat -- 分户级固定税率
    ,sub_acct_tax_rat_float_point -- 分户级税率浮动点数
    ,sub_acct_tax_rat_float_ratio -- 分户级税率浮动比例
    ,exch_rat_float_cate_cd -- 汇率浮动类别代码
    ,int_rat_day_type_cd -- 利率日类型代码
    ,acrs_ped_flg -- 跨周期标志
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
    ,o.acct_id -- 账户编号
    ,o.int_cls_cd -- 利息分类代码
    ,o.cust_id -- 客户编号
    ,o.int_rat_type_cd -- 利率类型代码
    ,o.bank_int_int_rat -- 行内利率
    ,o.int_rat_float_point -- 利率浮动点数
    ,o.int_rat_float_ratio -- 利率浮动比例
    ,o.float_int_rat -- 浮动利率
    ,o.sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,o.sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,o.sub_acct_fix_int_rat -- 分户级固定利率
    ,o.higt_exec_int_rat -- 最高执行利率
    ,o.lowt_exec_int_rat -- 最低执行利率
    ,o.accrd_nomal_int_rat_float_flg -- 按正常利率浮动标志
    ,o.exec_int_rat -- 执行利率
    ,o.int_set_freq_cd -- 结息频率代码
    ,o.int_set_day -- 结息日
    ,o.int_accr_way_cd -- 计息方式代码
    ,o.year_int_accr_base_cd -- 年计息基准代码
    ,o.mon_int_accr_base_cd -- 月计息基准代码
    ,o.int_accr_base_cd -- 计息基准代码
    ,o.int_accr_flg -- 计息标志
    ,o.cap_flg -- 资本化标志
    ,o.int_set_flg -- 结息标志
    ,o.acalc_flg -- 重算标志
    ,o.int_rat_start_use_way_cd -- 利率启用方式代码
    ,o.int_rat_effect_way_cd -- 利率生效方式代码
    ,o.int_rat_modif_ped_cd -- 利率变更周期代码
    ,o.int_rat_chg_dt -- 利率变动日期
    ,o.int_rat_modif_day -- 利率变更日
    ,o.next_int_rat_modif_dt -- 下次重定价日期
    ,o.last_int_rat_modif_dt -- 上次重定价日期
    ,o.exec_int_rat_chg_flg -- 执行利率变化标志
    ,o.tax_category_cd -- 税种代码
    ,o.tax_rat -- 税率
    ,o.pnlt_int_rat_use_way_cd -- 罚息利率使用方式代码
    ,o.int_provi_day -- 利息计提日
    ,o.int_provi_ped -- 利息计提周期
    ,o.agt_chg_way_cd -- 协议变动方式代码
    ,o.agt_fix_int_rat -- 协议固定利率
    ,o.agt_float_ratio -- 协议浮动比例
    ,o.agt_float_point -- 协议浮动点数
    ,o.sub_acct_fix_tax_rat -- 分户级固定税率
    ,o.sub_acct_tax_rat_float_point -- 分户级税率浮动点数
    ,o.sub_acct_tax_rat_float_ratio -- 分户级税率浮动比例
    ,o.exch_rat_float_cate_cd -- 汇率浮动类别代码
    ,o.int_rat_day_type_cd -- 利率日类型代码
    ,o.acrs_ped_flg -- 跨周期标志
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
from ${iml_schema}.agt_loan_acct_int_accr_cfg_h_ncbsf1_bk o
    left join ${iml_schema}.agt_loan_acct_int_accr_cfg_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_id = n.acct_id
            and o.int_cls_cd = n.int_cls_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_acct_int_accr_cfg_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.acct_id = d.acct_id
            and o.int_cls_cd = d.int_cls_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_acct_int_accr_cfg_h;
--alter table ${iml_schema}.agt_loan_acct_int_accr_cfg_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_acct_int_accr_cfg_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_acct_int_accr_cfg_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_loan_acct_int_accr_cfg_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_acct_int_accr_cfg_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_loan_acct_int_accr_cfg_h_ncbsf1_cl;
alter table ${iml_schema}.agt_loan_acct_int_accr_cfg_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_loan_acct_int_accr_cfg_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_acct_int_accr_cfg_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_acct_int_accr_cfg_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_loan_acct_int_accr_cfg_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_loan_acct_int_accr_cfg_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_acct_int_accr_cfg_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_acct_int_accr_cfg_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
