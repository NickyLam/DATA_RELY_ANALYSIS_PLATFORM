/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_prod_int_rat_info_h_ncbsf1
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
alter table ${iml_schema}.prd_prod_int_rat_info_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_prod_int_rat_info_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_prod_int_rat_info_h partition for ('ncbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_prod_int_rat_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.prd_prod_int_rat_info_h_ncbsf1_op purge;
drop table ${iml_schema}.prd_prod_int_rat_info_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_prod_int_rat_info_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,evt_cate_id -- 事件类别编号
    ,int_cls_cd -- 利息分类代码
    ,int_rat_type_cd -- 利率类型代码
    ,tax_category_cd -- 税种代码
    ,use_sub_acct_int_rat_flg -- 使用分户利率标志
    ,int_accr_way_cd -- 计息方式代码
    ,int_rat_file_way_cd -- 利率靠档方式代码
    ,file_amt_type_cd -- 靠档金额类型代码
    ,amt_file_dir_cd -- 金额靠档方向代码
    ,amt_file_way_cd -- 金额靠档方式代码
    ,days_file_dir_cd -- 天数靠档方向代码
    ,days_file_way_cd -- 天数靠档方式代码
    ,int_calc_amt_type_cd -- 利息计算金额类型代码
    ,value_day_get_val_way_cd -- 起息日取值方式代码
    ,file_days_calc_way_cd -- 靠档天数计算方式代码
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,grouping_rule_rela_cd -- 分组规则关系代码
    ,int_dtl_effect_way_cd -- 利息明细生效方式代码
    ,int_modif_way_cd -- 利息重算方式代码
    ,min_int_rat -- 最小利率
    ,max_int_rat -- 最大利率
    ,int_rat_modif_day -- 利率变更日
    ,int_rat_modif_ped_cd -- 利率变更周期代码
    ,substr_flg -- 截位标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_prod_int_rat_info_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.prd_prod_int_rat_info_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_prod_int_rat_info_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.prd_prod_int_rat_info_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_prod_int_rat_info_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_mb_prod_int-1
insert into ${iml_schema}.prd_prod_int_rat_info_h_ncbsf1_tm(
    lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,evt_cate_id -- 事件类别编号
    ,int_cls_cd -- 利息分类代码
    ,int_rat_type_cd -- 利率类型代码
    ,tax_category_cd -- 税种代码
    ,use_sub_acct_int_rat_flg -- 使用分户利率标志
    ,int_accr_way_cd -- 计息方式代码
    ,int_rat_file_way_cd -- 利率靠档方式代码
    ,file_amt_type_cd -- 靠档金额类型代码
    ,amt_file_dir_cd -- 金额靠档方向代码
    ,amt_file_way_cd -- 金额靠档方式代码
    ,days_file_dir_cd -- 天数靠档方向代码
    ,days_file_way_cd -- 天数靠档方式代码
    ,int_calc_amt_type_cd -- 利息计算金额类型代码
    ,value_day_get_val_way_cd -- 起息日取值方式代码
    ,file_days_calc_way_cd -- 靠档天数计算方式代码
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,grouping_rule_rela_cd -- 分组规则关系代码
    ,int_dtl_effect_way_cd -- 利息明细生效方式代码
    ,int_modif_way_cd -- 利息重算方式代码
    ,min_int_rat -- 最小利率
    ,max_int_rat -- 最大利率
    ,int_rat_modif_day -- 利率变更日
    ,int_rat_modif_ped_cd -- 利率变更周期代码
    ,substr_flg -- 截位标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '9999' -- 法人编号
    ,P1.PROD_TYPE -- 产品编号
    ,P1.EVENT_TYPE -- 事件类别编号
    ,P1.INT_CLASS -- 利息分类代码
    ,P1.INT_TYPE -- 利率类型代码
    ,nvl(trim(P1.TAX_TYPE),'-') -- 税种代码
    ,DECODE(P1.ACCT_RATE_FLAG,'Y','1','N','0') -- 使用分户利率标志
    ,nvl(trim(P1.INT_CALC_METHOD),'-') -- 计息方式代码
    ,nvl(trim(P1.RATE_LAYER_RULE),'-') -- 利率靠档方式代码
    ,nvl(trim(P1.RATE_GEAR_AMT_TYPE),'-') -- 靠档金额类型代码
    ,nvl(trim(P1.GEAR_AMT_IND),'-')-- 金额靠档方向代码
    ,nvl(trim(P1.GEAR_AMT_METHOD),'-') -- 金额靠档方式代码
    ,nvl(trim(P1.GEAR_DAYS_IND),'-') -- 天数靠档方向代码
    ,nvl(trim(P1.GEAR_DAYS_METHOD),'-') -- 天数靠档方式代码
    ,P1.INT_CALC_AMT_TYPE -- 利息计算金额类型代码
    ,P1.EFFECT_DATE_CALC_METHOD -- 起息日取值方式代码
    ,nvl(trim(P1.DAYS_GEAR_TYPE),'-') -- 靠档天数计算方式代码
    ,P1.INT_APPL_TYPE -- 利率启用方式代码
    ,P1.MONTH_BASIS -- 月计息基准代码
    ,P1.GROUP_RULE_TYPE -- 分组规则关系代码
    ,nvl(trim(P1.INT_MATCH_RULE),'-') -- 利息明细生效方式代码
    ,P1.INT_RECALC_METHOD -- 利息重算方式代码
    ,P1.MIN_RATE -- 最小利率
    ,P1.MAX_RATE -- 最大利率
    ,NVL(TRIM(P1.ROLL_DAY),0) -- 利率变更日
    ,nvl(trim(P1.ROLL_FREQ),'-') -- 利率变更周期代码
    ,DECODE(trim(P1.ROUND_DOWN_FLAG),'','-','Y','1','N','0') -- 截位标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_mb_prod_int' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_mb_prod_int p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_prod_int_rat_info_h_ncbsf1_tm 
  	                                group by 
  	                                        lp_id
  	                                        ,prod_id
  	                                        ,evt_cate_id
  	                                        ,int_cls_cd
  	                                        ,int_rat_type_cd
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
        into ${iml_schema}.prd_prod_int_rat_info_h_ncbsf1_cl(
            lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,evt_cate_id -- 事件类别编号
    ,int_cls_cd -- 利息分类代码
    ,int_rat_type_cd -- 利率类型代码
    ,tax_category_cd -- 税种代码
    ,use_sub_acct_int_rat_flg -- 使用分户利率标志
    ,int_accr_way_cd -- 计息方式代码
    ,int_rat_file_way_cd -- 利率靠档方式代码
    ,file_amt_type_cd -- 靠档金额类型代码
    ,amt_file_dir_cd -- 金额靠档方向代码
    ,amt_file_way_cd -- 金额靠档方式代码
    ,days_file_dir_cd -- 天数靠档方向代码
    ,days_file_way_cd -- 天数靠档方式代码
    ,int_calc_amt_type_cd -- 利息计算金额类型代码
    ,value_day_get_val_way_cd -- 起息日取值方式代码
    ,file_days_calc_way_cd -- 靠档天数计算方式代码
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,grouping_rule_rela_cd -- 分组规则关系代码
    ,int_dtl_effect_way_cd -- 利息明细生效方式代码
    ,int_modif_way_cd -- 利息重算方式代码
    ,min_int_rat -- 最小利率
    ,max_int_rat -- 最大利率
    ,int_rat_modif_day -- 利率变更日
    ,int_rat_modif_ped_cd -- 利率变更周期代码
    ,substr_flg -- 截位标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_prod_int_rat_info_h_ncbsf1_op(
            lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,evt_cate_id -- 事件类别编号
    ,int_cls_cd -- 利息分类代码
    ,int_rat_type_cd -- 利率类型代码
    ,tax_category_cd -- 税种代码
    ,use_sub_acct_int_rat_flg -- 使用分户利率标志
    ,int_accr_way_cd -- 计息方式代码
    ,int_rat_file_way_cd -- 利率靠档方式代码
    ,file_amt_type_cd -- 靠档金额类型代码
    ,amt_file_dir_cd -- 金额靠档方向代码
    ,amt_file_way_cd -- 金额靠档方式代码
    ,days_file_dir_cd -- 天数靠档方向代码
    ,days_file_way_cd -- 天数靠档方式代码
    ,int_calc_amt_type_cd -- 利息计算金额类型代码
    ,value_day_get_val_way_cd -- 起息日取值方式代码
    ,file_days_calc_way_cd -- 靠档天数计算方式代码
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,grouping_rule_rela_cd -- 分组规则关系代码
    ,int_dtl_effect_way_cd -- 利息明细生效方式代码
    ,int_modif_way_cd -- 利息重算方式代码
    ,min_int_rat -- 最小利率
    ,max_int_rat -- 最大利率
    ,int_rat_modif_day -- 利率变更日
    ,int_rat_modif_ped_cd -- 利率变更周期代码
    ,substr_flg -- 截位标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.evt_cate_id, o.evt_cate_id) as evt_cate_id -- 事件类别编号
    ,nvl(n.int_cls_cd, o.int_cls_cd) as int_cls_cd -- 利息分类代码
    ,nvl(n.int_rat_type_cd, o.int_rat_type_cd) as int_rat_type_cd -- 利率类型代码
    ,nvl(n.tax_category_cd, o.tax_category_cd) as tax_category_cd -- 税种代码
    ,nvl(n.use_sub_acct_int_rat_flg, o.use_sub_acct_int_rat_flg) as use_sub_acct_int_rat_flg -- 使用分户利率标志
    ,nvl(n.int_accr_way_cd, o.int_accr_way_cd) as int_accr_way_cd -- 计息方式代码
    ,nvl(n.int_rat_file_way_cd, o.int_rat_file_way_cd) as int_rat_file_way_cd -- 利率靠档方式代码
    ,nvl(n.file_amt_type_cd, o.file_amt_type_cd) as file_amt_type_cd -- 靠档金额类型代码
    ,nvl(n.amt_file_dir_cd, o.amt_file_dir_cd) as amt_file_dir_cd -- 金额靠档方向代码
    ,nvl(n.amt_file_way_cd, o.amt_file_way_cd) as amt_file_way_cd -- 金额靠档方式代码
    ,nvl(n.days_file_dir_cd, o.days_file_dir_cd) as days_file_dir_cd -- 天数靠档方向代码
    ,nvl(n.days_file_way_cd, o.days_file_way_cd) as days_file_way_cd -- 天数靠档方式代码
    ,nvl(n.int_calc_amt_type_cd, o.int_calc_amt_type_cd) as int_calc_amt_type_cd -- 利息计算金额类型代码
    ,nvl(n.value_day_get_val_way_cd, o.value_day_get_val_way_cd) as value_day_get_val_way_cd -- 起息日取值方式代码
    ,nvl(n.file_days_calc_way_cd, o.file_days_calc_way_cd) as file_days_calc_way_cd -- 靠档天数计算方式代码
    ,nvl(n.int_rat_start_use_way_cd, o.int_rat_start_use_way_cd) as int_rat_start_use_way_cd -- 利率启用方式代码
    ,nvl(n.mon_int_accr_base_cd, o.mon_int_accr_base_cd) as mon_int_accr_base_cd -- 月计息基准代码
    ,nvl(n.grouping_rule_rela_cd, o.grouping_rule_rela_cd) as grouping_rule_rela_cd -- 分组规则关系代码
    ,nvl(n.int_dtl_effect_way_cd, o.int_dtl_effect_way_cd) as int_dtl_effect_way_cd -- 利息明细生效方式代码
    ,nvl(n.int_modif_way_cd, o.int_modif_way_cd) as int_modif_way_cd -- 利息重算方式代码
    ,nvl(n.min_int_rat, o.min_int_rat) as min_int_rat -- 最小利率
    ,nvl(n.max_int_rat, o.max_int_rat) as max_int_rat -- 最大利率
    ,nvl(n.int_rat_modif_day, o.int_rat_modif_day) as int_rat_modif_day -- 利率变更日
    ,nvl(n.int_rat_modif_ped_cd, o.int_rat_modif_ped_cd) as int_rat_modif_ped_cd -- 利率变更周期代码
    ,nvl(n.substr_flg, o.substr_flg) as substr_flg -- 截位标志
    ,case when
            n.lp_id is null
            and n.prod_id is null
            and n.evt_cate_id is null
            and n.int_cls_cd is null
            and n.int_rat_type_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.lp_id is null
            and n.prod_id is null
            and n.evt_cate_id is null
            and n.int_cls_cd is null
            and n.int_rat_type_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.lp_id is null
            and n.prod_id is null
            and n.evt_cate_id is null
            and n.int_cls_cd is null
            and n.int_rat_type_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_prod_int_rat_info_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.prd_prod_int_rat_info_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.lp_id = n.lp_id
            and o.prod_id = n.prod_id
            and o.evt_cate_id = n.evt_cate_id
            and o.int_cls_cd = n.int_cls_cd
            and o.int_rat_type_cd = n.int_rat_type_cd
where (
        o.lp_id is null
        and o.prod_id is null
        and o.evt_cate_id is null
        and o.int_cls_cd is null
        and o.int_rat_type_cd is null
    )
    or (
        n.lp_id is null
        and n.prod_id is null
        and n.evt_cate_id is null
        and n.int_cls_cd is null
        and n.int_rat_type_cd is null
    )
    or (
        o.tax_category_cd <> n.tax_category_cd
        or o.use_sub_acct_int_rat_flg <> n.use_sub_acct_int_rat_flg
        or o.int_accr_way_cd <> n.int_accr_way_cd
        or o.int_rat_file_way_cd <> n.int_rat_file_way_cd
        or o.file_amt_type_cd <> n.file_amt_type_cd
        or o.amt_file_dir_cd <> n.amt_file_dir_cd
        or o.amt_file_way_cd <> n.amt_file_way_cd
        or o.days_file_dir_cd <> n.days_file_dir_cd
        or o.days_file_way_cd <> n.days_file_way_cd
        or o.int_calc_amt_type_cd <> n.int_calc_amt_type_cd
        or o.value_day_get_val_way_cd <> n.value_day_get_val_way_cd
        or o.file_days_calc_way_cd <> n.file_days_calc_way_cd
        or o.int_rat_start_use_way_cd <> n.int_rat_start_use_way_cd
        or o.mon_int_accr_base_cd <> n.mon_int_accr_base_cd
        or o.grouping_rule_rela_cd <> n.grouping_rule_rela_cd
        or o.int_dtl_effect_way_cd <> n.int_dtl_effect_way_cd
        or o.int_modif_way_cd <> n.int_modif_way_cd
        or o.min_int_rat <> n.min_int_rat
        or o.max_int_rat <> n.max_int_rat
        or o.int_rat_modif_day <> n.int_rat_modif_day
        or o.int_rat_modif_ped_cd <> n.int_rat_modif_ped_cd
        or o.substr_flg <> n.substr_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_prod_int_rat_info_h_ncbsf1_cl(
            lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,evt_cate_id -- 事件类别编号
    ,int_cls_cd -- 利息分类代码
    ,int_rat_type_cd -- 利率类型代码
    ,tax_category_cd -- 税种代码
    ,use_sub_acct_int_rat_flg -- 使用分户利率标志
    ,int_accr_way_cd -- 计息方式代码
    ,int_rat_file_way_cd -- 利率靠档方式代码
    ,file_amt_type_cd -- 靠档金额类型代码
    ,amt_file_dir_cd -- 金额靠档方向代码
    ,amt_file_way_cd -- 金额靠档方式代码
    ,days_file_dir_cd -- 天数靠档方向代码
    ,days_file_way_cd -- 天数靠档方式代码
    ,int_calc_amt_type_cd -- 利息计算金额类型代码
    ,value_day_get_val_way_cd -- 起息日取值方式代码
    ,file_days_calc_way_cd -- 靠档天数计算方式代码
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,grouping_rule_rela_cd -- 分组规则关系代码
    ,int_dtl_effect_way_cd -- 利息明细生效方式代码
    ,int_modif_way_cd -- 利息重算方式代码
    ,min_int_rat -- 最小利率
    ,max_int_rat -- 最大利率
    ,int_rat_modif_day -- 利率变更日
    ,int_rat_modif_ped_cd -- 利率变更周期代码
    ,substr_flg -- 截位标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_prod_int_rat_info_h_ncbsf1_op(
            lp_id -- 法人编号
    ,prod_id -- 产品编号
    ,evt_cate_id -- 事件类别编号
    ,int_cls_cd -- 利息分类代码
    ,int_rat_type_cd -- 利率类型代码
    ,tax_category_cd -- 税种代码
    ,use_sub_acct_int_rat_flg -- 使用分户利率标志
    ,int_accr_way_cd -- 计息方式代码
    ,int_rat_file_way_cd -- 利率靠档方式代码
    ,file_amt_type_cd -- 靠档金额类型代码
    ,amt_file_dir_cd -- 金额靠档方向代码
    ,amt_file_way_cd -- 金额靠档方式代码
    ,days_file_dir_cd -- 天数靠档方向代码
    ,days_file_way_cd -- 天数靠档方式代码
    ,int_calc_amt_type_cd -- 利息计算金额类型代码
    ,value_day_get_val_way_cd -- 起息日取值方式代码
    ,file_days_calc_way_cd -- 靠档天数计算方式代码
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,grouping_rule_rela_cd -- 分组规则关系代码
    ,int_dtl_effect_way_cd -- 利息明细生效方式代码
    ,int_modif_way_cd -- 利息重算方式代码
    ,min_int_rat -- 最小利率
    ,max_int_rat -- 最大利率
    ,int_rat_modif_day -- 利率变更日
    ,int_rat_modif_ped_cd -- 利率变更周期代码
    ,substr_flg -- 截位标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.lp_id -- 法人编号
    ,o.prod_id -- 产品编号
    ,o.evt_cate_id -- 事件类别编号
    ,o.int_cls_cd -- 利息分类代码
    ,o.int_rat_type_cd -- 利率类型代码
    ,o.tax_category_cd -- 税种代码
    ,o.use_sub_acct_int_rat_flg -- 使用分户利率标志
    ,o.int_accr_way_cd -- 计息方式代码
    ,o.int_rat_file_way_cd -- 利率靠档方式代码
    ,o.file_amt_type_cd -- 靠档金额类型代码
    ,o.amt_file_dir_cd -- 金额靠档方向代码
    ,o.amt_file_way_cd -- 金额靠档方式代码
    ,o.days_file_dir_cd -- 天数靠档方向代码
    ,o.days_file_way_cd -- 天数靠档方式代码
    ,o.int_calc_amt_type_cd -- 利息计算金额类型代码
    ,o.value_day_get_val_way_cd -- 起息日取值方式代码
    ,o.file_days_calc_way_cd -- 靠档天数计算方式代码
    ,o.int_rat_start_use_way_cd -- 利率启用方式代码
    ,o.mon_int_accr_base_cd -- 月计息基准代码
    ,o.grouping_rule_rela_cd -- 分组规则关系代码
    ,o.int_dtl_effect_way_cd -- 利息明细生效方式代码
    ,o.int_modif_way_cd -- 利息重算方式代码
    ,o.min_int_rat -- 最小利率
    ,o.max_int_rat -- 最大利率
    ,o.int_rat_modif_day -- 利率变更日
    ,o.int_rat_modif_ped_cd -- 利率变更周期代码
    ,o.substr_flg -- 截位标志
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_prod_int_rat_info_h_ncbsf1_bk o
    left join ${iml_schema}.prd_prod_int_rat_info_h_ncbsf1_op n
        on
            o.lp_id = n.lp_id
            and o.prod_id = n.prod_id
            and o.evt_cate_id = n.evt_cate_id
            and o.int_cls_cd = n.int_cls_cd
            and o.int_rat_type_cd = n.int_rat_type_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_prod_int_rat_info_h_ncbsf1_cl d
        on
            o.lp_id = d.lp_id
            and o.prod_id = d.prod_id
            and o.evt_cate_id = d.evt_cate_id
            and o.int_cls_cd = d.int_cls_cd
            and o.int_rat_type_cd = d.int_rat_type_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_prod_int_rat_info_h;
alter table ${iml_schema}.prd_prod_int_rat_info_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.prd_prod_int_rat_info_h exchange subpartition p_ncbsf1_19000101 with table ${iml_schema}.prd_prod_int_rat_info_h_ncbsf1_cl;
alter table ${iml_schema}.prd_prod_int_rat_info_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.prd_prod_int_rat_info_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_prod_int_rat_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_prod_int_rat_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.prd_prod_int_rat_info_h_ncbsf1_op purge;
drop table ${iml_schema}.prd_prod_int_rat_info_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_prod_int_rat_info_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_prod_int_rat_info_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
