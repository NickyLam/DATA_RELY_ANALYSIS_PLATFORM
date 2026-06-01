/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_fin_am_prod_intnal_subj_bal_famsi2
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
drop table ${iml_schema}.fin_am_prod_intnal_subj_bal_famsi2_tm purge;
alter table ${iml_schema}.fin_am_prod_intnal_subj_bal add partition p_famsi2 values ('famsi2')(
        subpartition p_famsi2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.fin_am_prod_intnal_subj_bal modify partition p_famsi2
    add subpartition p_famsi2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.fin_am_prod_intnal_subj_bal_famsi2_tm
compress ${option_switch} for query high
as
select
    acct_pkg_id -- 套账编号
    ,lp_id -- 法人编号
    ,bal_dt -- 余额日期
    ,subj_id -- 科目编号
    ,super_subj_id -- 上级科目编号
    ,subj_level_cd -- 科目等级代码
    ,bal_dir_cd -- 科目余额方向
    ,carr_bal_dir_cd -- 结转余额方向代码
    ,oc_curr_cd -- 原币币种代码
    ,oc_bal -- 原币余额
    ,oc_cr_bal -- 原币贷方余额
    ,oc_dr_bal -- 原币借方余额
    ,oc_carr_bal -- 原币结转余额
    ,oc_cr_carr_bal -- 原币贷方结转余额
    ,oc_dr_carr_bal -- 原币借方结转余额
    ,dc_curr_cd -- 本币币种代码
    ,dc_bal -- 本币余额
    ,dc_cr_bal -- 本币贷方余额
    ,dc_dr_bal -- 本币借方余额
    ,dc_carr_bal -- 本币结转余额
    ,dc_cr_carr_bal -- 本币贷方结转余额
    ,dc_dr_carr_bal -- 本币借方结转余额
    ,td_oc_amt -- 当日原币发生额
    ,td_oc_cr_amt -- 当日原币贷方发生额
    ,td_oc_dr_amt -- 当日原币借方发生额
    ,td_oc_carr_amt -- 当日原币结转发生额
    ,td_oc_cr_carr_amt -- 当日原币贷方结转发生额
    ,td_oc_dr_carr_amt -- 当日原币借方结转发生额
    ,td_dc_amt -- 当日本币发生额
    ,td_dc_cr_amt -- 当日本币贷方发生额
    ,td_dc_dr_amt -- 当日本币借方发生额
    ,td_dc_carr_amt -- 当日本币结转发生额
    ,td_dc_cr_carr_amt -- 当日本币贷方结转发生额
    ,td_dc_dr_carr_amt -- 当日本币借方结转发生额
    ,noth_subor_subj_flg -- 无下级科目标志
    ,lot -- 份额
    ,td_amt_dir_cd -- 当日发生额方向代码
    ,td_carr_amt_dir_cd -- 当日结转发生额方向代码
    ,oc_dr_purch_unrliz_gain -- 原币借方申购未实现平准金
    ,oc_dr_redem_unrliz_gain -- 原币借方赎回未实现平准金
    ,oc_cr_purch_unrliz_gain -- 原币贷方申购未实现平准金
    ,oc_cr_redem_unrliz_gain -- 原币贷方赎回未实现平准金
    ,dc_dr_purch_unrliz_gain -- 本币借方申购未实现平准金
    ,dc_dr_redem_unrliz_gain -- 本币借方赎回未实现平准金
    ,dc_cr_purch_unrliz_gain -- 本币贷方申购未实现平准金
    ,dc_cr_redem_unrliz_gain -- 本币贷方赎回未实现平准金
    ,ear_d_oc_bal_dir_cd -- 日初原币余额方向代码
    ,ear_d_oc_bal -- 日初原币余额
    ,end_d_oc_bal_dir_cd -- 日末原币余额方向代码
    ,end_d_oc_bal -- 日末原币余额
    ,ear_d_dc_bal_dir_cd -- 日初本币余额方向代码
    ,ear_d_dc_bal -- 日初本币余额
    ,end_d_dc_bal_dir_cd -- 日末本币余额方向代码
    ,end_d_dc_bal -- 日末本币余额
    ,sob_name -- 账套名称
    ,subj_name -- 科目名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.fin_am_prod_intnal_subj_bal
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- fams_bok_balance-1
insert into ${iml_schema}.fin_am_prod_intnal_subj_bal_famsi2_tm(
    acct_pkg_id -- 套账编号
    ,lp_id -- 法人编号
    ,bal_dt -- 余额日期
    ,subj_id -- 科目编号
    ,super_subj_id -- 上级科目编号
    ,subj_level_cd -- 科目等级代码
    ,bal_dir_cd -- 科目余额方向
    ,carr_bal_dir_cd -- 结转余额方向代码
    ,oc_curr_cd -- 原币币种代码
    ,oc_bal -- 原币余额
    ,oc_cr_bal -- 原币贷方余额
    ,oc_dr_bal -- 原币借方余额
    ,oc_carr_bal -- 原币结转余额
    ,oc_cr_carr_bal -- 原币贷方结转余额
    ,oc_dr_carr_bal -- 原币借方结转余额
    ,dc_curr_cd -- 本币币种代码
    ,dc_bal -- 本币余额
    ,dc_cr_bal -- 本币贷方余额
    ,dc_dr_bal -- 本币借方余额
    ,dc_carr_bal -- 本币结转余额
    ,dc_cr_carr_bal -- 本币贷方结转余额
    ,dc_dr_carr_bal -- 本币借方结转余额
    ,td_oc_amt -- 当日原币发生额
    ,td_oc_cr_amt -- 当日原币贷方发生额
    ,td_oc_dr_amt -- 当日原币借方发生额
    ,td_oc_carr_amt -- 当日原币结转发生额
    ,td_oc_cr_carr_amt -- 当日原币贷方结转发生额
    ,td_oc_dr_carr_amt -- 当日原币借方结转发生额
    ,td_dc_amt -- 当日本币发生额
    ,td_dc_cr_amt -- 当日本币贷方发生额
    ,td_dc_dr_amt -- 当日本币借方发生额
    ,td_dc_carr_amt -- 当日本币结转发生额
    ,td_dc_cr_carr_amt -- 当日本币贷方结转发生额
    ,td_dc_dr_carr_amt -- 当日本币借方结转发生额
    ,noth_subor_subj_flg -- 无下级科目标志
    ,lot -- 份额
    ,td_amt_dir_cd -- 当日发生额方向代码
    ,td_carr_amt_dir_cd -- 当日结转发生额方向代码
    ,oc_dr_purch_unrliz_gain -- 原币借方申购未实现平准金
    ,oc_dr_redem_unrliz_gain -- 原币借方赎回未实现平准金
    ,oc_cr_purch_unrliz_gain -- 原币贷方申购未实现平准金
    ,oc_cr_redem_unrliz_gain -- 原币贷方赎回未实现平准金
    ,dc_dr_purch_unrliz_gain -- 本币借方申购未实现平准金
    ,dc_dr_redem_unrliz_gain -- 本币借方赎回未实现平准金
    ,dc_cr_purch_unrliz_gain -- 本币贷方申购未实现平准金
    ,dc_cr_redem_unrliz_gain -- 本币贷方赎回未实现平准金
    ,ear_d_oc_bal_dir_cd -- 日初原币余额方向代码
    ,ear_d_oc_bal -- 日初原币余额
    ,end_d_oc_bal_dir_cd -- 日末原币余额方向代码
    ,end_d_oc_bal -- 日末原币余额
    ,ear_d_dc_bal_dir_cd -- 日初本币余额方向代码
    ,ear_d_dc_bal -- 日初本币余额
    ,end_d_dc_bal_dir_cd -- 日末本币余额方向代码
    ,end_d_dc_bal -- 日末本币余额
    ,sob_name -- 账套名称
    ,subj_name -- 科目名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.BOOKSET_ID -- 套账编号
    ,'9999' -- 法人编号
    ,P1.BALANCE_DATE -- 余额日期
    ,P1.SUBJECT_NO -- 科目编号
    ,P1.FSUBJECT_NO -- 上级科目编号
    ,P1.SUBJECT_LEVEL -- 科目等级代码
    ,P1.BAL_FLAG -- 科目余额方向
    ,P1.BAL_CO_FLAG -- 结转余额方向代码
    ,NVL(TRIM(P1.O_CCY),'-') -- 原币币种代码
    ,P1.O_AMT -- 原币余额
    ,P1.O_C_AMT -- 原币贷方余额
    ,P1.O_D_AMT -- 原币借方余额
    ,P1.O_CO_AMT -- 原币结转余额
    ,P1.O_CO_C_AMT -- 原币贷方结转余额
    ,P1.O_CO_D_AMT -- 原币借方结转余额
    ,NVL(TRIM(P1.B_CCY),'-') -- 本币币种代码
    ,P1.B_AMT -- 本币余额
    ,P1.B_C_AMT -- 本币贷方余额
    ,P1.B_D_AMT -- 本币借方余额
    ,P1.B_CO_AMT -- 本币结转余额
    ,P1.B_CO_C_AMT -- 本币贷方结转余额
    ,P1.B_CO_D_AMT -- 本币借方结转余额
    ,P1.TDY_O_AMT -- 当日原币发生额
    ,P1.TDY_O_C_AMT -- 当日原币贷方发生额
    ,P1.TDY_O_D_AMT -- 当日原币借方发生额
    ,P1.TDY_O_CO_AMT -- 当日原币结转发生额
    ,P1.TDY_O_CO_C_AMT -- 当日原币贷方结转发生额
    ,P1.TDY_O_CO_D_AMT -- 当日原币借方结转发生额
    ,P1.TDY_B_AMT -- 当日本币发生额
    ,P1.TDY_B_C_AMT -- 当日本币贷方发生额
    ,P1.TDY_B_D_AMT -- 当日本币借方发生额
    ,P1.TDY_B_CO_AMT -- 当日本币结转发生额
    ,P1.TDY_B_CO_C_AMT -- 当日本币贷方结转发生额
    ,P1.TDY_B_CO_D_AMT -- 当日本币借方结转发生额
    ,CASE WHEN P1.IS_LEAF ='N' THEN '0' WHEN P1.IS_LEAF ='Y' THEN '1' ELSE '-' END -- 无下级科目标志
    ,P1.NUM_AMT -- 份额
    ,P1.TDY_AMT_FLAG -- 当日发生额方向代码
    ,P1.TDY_CO_FLAG -- 当日结转发生额方向代码
    ,P1.TDY_PUR_O_D_ULAMT -- 原币借方申购未实现平准金
    ,P1.TDY_RED_O_D_ULAMT -- 原币借方赎回未实现平准金
    ,P1.TDY_PUR_O_C_ULAMT -- 原币贷方申购未实现平准金
    ,P1.TDY_RED_O_C_ULAMT -- 原币贷方赎回未实现平准金
    ,P1.TDY_PUR_B_D_ULAMT -- 本币借方申购未实现平准金
    ,P1.TDY_RED_B_D_ULAMT -- 本币借方赎回未实现平准金
    ,P1.TDY_PUR_B_C_ULAMT -- 本币贷方申购未实现平准金
    ,P1.TDY_RED_B_C_ULAMT -- 本币贷方赎回未实现平准金
    ,P2.O_OPEN_BAL_FLAG -- 日初原币余额方向代码
    ,P2.O_OPEN_BALANCE -- 日初原币余额
    ,P2.O_END_BAL_FLAG -- 日末原币余额方向代码
    ,P2.O_END_BALANCE -- 日末原币余额
    ,P2.B_OPEN_BAL_FLAG -- 日初本币余额方向代码
    ,P2.B_OPEN_BALANCE -- 日初本币余额
    ,P2.B_END_BAL_FLAG -- 日末本币余额方向代码
    ,P2.B_END_BALANCE -- 日末本币余额
    ,P2.BOOKSET_NAME -- 账套名称
    ,P2.SUBJECT_NAME -- 科目名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_bok_balance' -- 源表名称
    ,'famsi2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
 from ${iol_schema}.fams_bok_balance p1
 left join ${iol_schema}.fams_bok_bal_table_data p2 
   on p1.bookset_id = p2.bookset_id 
  and p1.balance_date = p2.bal_date 
  and p1.subject_no = p2.subject_no
  and p2.start_dt <= to_date('${batch_date}','yyyymmdd') 
  and p2.end_dt > to_date('${batch_date}','yyyymmdd')
where p1.balance_date = to_date('${batch_date}','yyyymmdd')
;

commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.fin_am_prod_intnal_subj_bal truncate subpartition p_famsi2_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.fin_am_prod_intnal_subj_bal exchange subpartition p_famsi2_${batch_date} with table ${iml_schema}.fin_am_prod_intnal_subj_bal_famsi2_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.fin_am_prod_intnal_subj_bal to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.fin_am_prod_intnal_subj_bal_famsi2_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'fin_am_prod_intnal_subj_bal', partname => 'p_famsi2_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);