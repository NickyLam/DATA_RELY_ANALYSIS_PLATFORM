/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_loan_acct_int_rat_modif_dtl_ncbsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_loan_acct_int_rat_modif_dtl_ncbsi1_tm purge;
alter table ${iml_schema}.evt_loan_acct_int_rat_modif_dtl add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_loan_acct_int_rat_modif_dtl modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_loan_acct_int_rat_modif_dtl_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,int_cls_cd -- 利息分类代码
    ,effect_dt -- 生效日期
    ,acct_id -- 账户编号
    ,seq_num -- 序号
    ,new_int_rat_type_cd -- 新利率类型代码
    ,new_int_rat_float_point -- 新利率浮动点数
    ,new_exec_int_rat -- 新执行利率
    ,new_int_rat_float_ratio -- 新利率浮动比例
    ,new_int_rat_start_use_way_cd -- 新利率启用方式代码
    ,new_int_rat_effect_way_cd -- 新利率生效方式代码
    ,new_int_rat_modif_day -- 新利率变更日
    ,new_int_rat_modif_dt -- 新利率变更日期
    ,new_int_rat_modif_ped -- 新利率变更周期
    ,acct_aldy_check_flg -- 账户已复核标志
    ,tran_dt -- 交易日期
    ,effect_flg -- 生效标志
    ,acalc_flg -- 重算标志
    ,cust_id -- 客户编号
    ,accrd_nomal_int_rat_float_flg -- 按正常利率浮动标志
    ,precon_id -- 预约编号
    ,new_exec_tax_rat -- 新执行税率
    ,tax_rat_float_point -- 税率浮动点数
    ,tax_rat_float_ratio -- 税率浮动比例
    ,tax_info_flg -- 税信息标志
    ,check_teller_id -- 复核柜员编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_loan_acct_int_rat_modif_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_cl_int_roll-1
insert into ${iml_schema}.evt_loan_acct_int_rat_modif_dtl_ncbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,int_cls_cd -- 利息分类代码
    ,effect_dt -- 生效日期
    ,acct_id -- 账户编号
    ,seq_num -- 序号
    ,new_int_rat_type_cd -- 新利率类型代码
    ,new_int_rat_float_point -- 新利率浮动点数
    ,new_exec_int_rat -- 新执行利率
    ,new_int_rat_float_ratio -- 新利率浮动比例
    ,new_int_rat_start_use_way_cd -- 新利率启用方式代码
    ,new_int_rat_effect_way_cd -- 新利率生效方式代码
    ,new_int_rat_modif_day -- 新利率变更日
    ,new_int_rat_modif_dt -- 新利率变更日期
    ,new_int_rat_modif_ped -- 新利率变更周期
    ,acct_aldy_check_flg -- 账户已复核标志
    ,tran_dt -- 交易日期
    ,effect_flg -- 生效标志
    ,acalc_flg -- 重算标志
    ,cust_id -- 客户编号
    ,accrd_nomal_int_rat_float_flg -- 按正常利率浮动标志
    ,precon_id -- 预约编号
    ,new_exec_tax_rat -- 新执行税率
    ,tax_rat_float_point -- 税率浮动点数
    ,tax_rat_float_ratio -- 税率浮动比例
    ,tax_info_flg -- 税信息标志
    ,check_teller_id -- 复核柜员编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101025'||P1.INTERNAL_KEY||P1.INT_CLASS||P1.EFFECT_DATE -- 事件编号
    ,'9999' -- 法人编号
    ,P1.INT_CLASS -- 利息分类代码
    ,P1.EFFECT_DATE -- 生效日期
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.INTERNAL_KEY -- 序号
    ,P1.NEW_INT_TYPE -- 新利率类型代码
    ,P1.NEW_SPREAD_RATE -- 新利率浮动点数
    ,P1.NEW_REAL_RATE -- 新执行利率
    ,P1.NEW_SPREAD_PERCENT -- 新利率浮动比例
    ,P1.NEW_INT_APPL_TYPE -- 新利率启用方式代码
    ,P1.NEW_RATE_EFFECT_TYPE -- 新利率生效方式代码
    ,to_number(nvl(trim(P1.NEW_ROLL_DAY),'0')) -- 新利率变更日
    ,P1.NEW_NEXT_ROLL_DATE -- 新利率变更日期
    ,nvl(trim(P1.NEW_ROLL_FREQ),'-') -- 新利率变更周期
    ,decode(trim(P1.APPR_FLAG),'Y','1','N','0', '','-',P1.APPR_FLAG) -- 账户已复核标志
    ,P1.TRAN_DATE -- 交易日期
    ,decode(trim(P1.EFFECT_FLAG),'Y','1','N','0', '','-',P1.EFFECT_FLAG) -- 生效标志
    ,decode(trim(P1.RETRY_FLAG),'Y','1','N','0', '','-',P1.RETRY_FLAG) -- 重算标志
    ,P1.CLIENT_NO -- 客户编号
    ,decode(trim(P1.CALC_BY_INT),'Y','1','N','0', '','-',P1.CALC_BY_INT) -- 按正常利率浮动标志
    ,P1.ORDER_NO -- 预约编号
    ,P1.NEW_REAL_TAX_RATE -- 新执行税率
    ,P1.NEW_SPREAD_TAX_RATE -- 税率浮动点数
    ,P1.NEW_SPREAD_TAX_PERCENT -- 税率浮动比例
    ,decode(trim(P1.TAX_FLAG),'Y','1','N','0', '','-',P1.TAX_FLAG) -- 税信息标志
    ,P1.APPR_USER_ID -- 复核柜员编号
    ,P1.USER_ID -- 交易柜员编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_int_roll' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_int_roll p1
  where  1 = 1 
 and p1.TRAN_DATE = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_loan_acct_int_rat_modif_dtl truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_loan_acct_int_rat_modif_dtl exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_loan_acct_int_rat_modif_dtl_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_loan_acct_int_rat_modif_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_loan_acct_int_rat_modif_dtl_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_loan_acct_int_rat_modif_dtl', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);