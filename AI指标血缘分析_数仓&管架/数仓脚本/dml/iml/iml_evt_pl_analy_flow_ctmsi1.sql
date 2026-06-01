/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_pl_analy_flow_ctmsi1
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
drop table ${iml_schema}.evt_pl_analy_flow_ctmsi1_tm purge;
alter table ${iml_schema}.evt_pl_analy_flow add partition p_ctmsi1 values ('ctmsi1')(
        subpartition p_ctmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_pl_analy_flow modify partition p_ctmsi1
    add subpartition p_ctmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_pl_analy_flow_ctmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,pl_analy_type_cd -- 损益分析类型代码
    ,analy_dt -- 分析日期
    ,bond_id -- 债券编号
    ,bond_name -- 债券名称
    ,bond_type_cd -- 债券类型代码
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,denom -- 面额
    ,surp_pric -- 剩余本金
    ,avg_cost -- 平均成本
    ,dpa_net_price -- 折溢摊净价
    ,acru_int -- 应计利息
    ,subj_type_cd -- 科目类型代码
    ,bond_descb -- 债券描述
    ,curr_cd -- 币种代码
    ,coret_duran -- 修正久期
    ,pvbp -- DV01
    ,inv_port_id -- 投组编号
    ,inv_port_name -- 投组名称
    ,inv_port_thd_cls_name -- 投组三分类名称
    ,acct_b_id -- 账薄编号
    ,acct_b_cd -- 账薄代码
    ,acct_b_name -- 账薄名称
    ,dept_org_id -- 部门机构编号
    ,prod_id -- 产品编号
    ,exp_yld_rat -- 到期收益率
    ,pend_ped -- 待偿期
    ,int_income -- 利息收入
    ,pda -- 折溢摊
    ,bs_spd -- 买卖价差
    ,float_prft_loss -- 浮动盈亏
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_pl_analy_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ctms_vi_cms_avg_cost_analyse_dtl_bond-1
insert into ${iml_schema}.evt_pl_analy_flow_ctmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,pl_analy_type_cd -- 损益分析类型代码
    ,analy_dt -- 分析日期
    ,bond_id -- 债券编号
    ,bond_name -- 债券名称
    ,bond_type_cd -- 债券类型代码
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,denom -- 面额
    ,surp_pric -- 剩余本金
    ,avg_cost -- 平均成本
    ,dpa_net_price -- 折溢摊净价
    ,acru_int -- 应计利息
    ,subj_type_cd -- 科目类型代码
    ,bond_descb -- 债券描述
    ,curr_cd -- 币种代码
    ,coret_duran -- 修正久期
    ,pvbp -- DV01
    ,inv_port_id -- 投组编号
    ,inv_port_name -- 投组名称
    ,inv_port_thd_cls_name -- 投组三分类名称
    ,acct_b_id -- 账薄编号
    ,acct_b_cd -- 账薄代码
    ,acct_b_name -- 账薄名称
    ,dept_org_id -- 部门机构编号
    ,prod_id -- 产品编号
    ,exp_yld_rat -- 到期收益率
    ,pend_ped -- 待偿期
    ,int_income -- 利息收入
    ,pda -- 折溢摊
    ,bs_spd -- 买卖价差
    ,float_prft_loss -- 浮动盈亏
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401029'||'1'||P1.SECURITY_ID||P1.QUERY_END_DATE -- 事件编号
    ,'9999' -- 法人编号
    ,'1' -- 损益分析类型代码
    ,${iml_schema}.dateformat_max2(p1.QUERY_END_DATE) -- 分析日期
    ,P1.SECURITY_ID -- 债券编号
    ,P1.SECURITY_NAME -- 债券名称
    ,nvl(trim(P1.SECURITY_TYPE),'00') -- 债券类型代码
    ,${iml_schema}.dateformat_min(p1.START_DATE) -- 起息日期
    ,${iml_schema}.dateformat_max2(p1.END_DATE) -- 到期日期
    ,P1.POSITION -- 面额
    ,P1.RESIDUALQTY -- 剩余本金
    ,P1.AVERAGECOST -- 平均成本
    ,P1.DPAPRICE -- 折溢摊净价
    ,P1.ACCRUEDINTEREST -- 应计利息
    ,nvl(trim(P1.ASSETTYPE),'-') -- 科目类型代码
    ,P1.CNAME -- 债券描述
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,P1.MDURATION -- 修正久期
    ,P1.PVBP -- DV01
    ,decode(to_char(P1.PFOLIO_ID),'0',' ',P1.PFOLIO_ID) -- 投组编号
    ,P1.PFOLIO_NAME -- 投组名称
    ,P1.BUZTYPE -- 投组三分类名称
    ,decode(to_char(P1.KEEPFOLDER_ID),'0',' ',P1.KEEPFOLDER_ID) -- 账薄编号
    ,P1.KEEPFOLDER_CODE -- 账薄代码
    ,P1.KEEPFOLDER_SHORTNAME -- 账薄名称
    ,P1.ORG_ID -- 部门机构编号
    ,P1.PRODUCT_CODE -- 产品编号
    ,P1.YIELD -- 到期收益率
    ,P1.SECURITY_TERM_TO_MATURITY -- 待偿期
    ,P1.COUPONINTERESTAMT -- 利息收入
    ,P1.DPA -- 折溢摊
    ,P1.SPREAD -- 买卖价差
    ,P1.URPL -- 浮动盈亏
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_vi_cms_avg_cost_analyse_dtl_bond' -- 源表名称
    ,'ctmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond p1
 where 1 = 1
   and p1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
   ;
commit;

-- ctms_vi_cms_zyt_cost_analyse_dtl_bond-1
insert into ${iml_schema}.evt_pl_analy_flow_ctmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,pl_analy_type_cd -- 损益分析类型代码
    ,analy_dt -- 分析日期
    ,bond_id -- 债券编号
    ,bond_name -- 债券名称
    ,bond_type_cd -- 债券类型代码
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,denom -- 面额
    ,surp_pric -- 剩余本金
    ,avg_cost -- 平均成本
    ,dpa_net_price -- 折溢摊净价
    ,acru_int -- 应计利息
    ,subj_type_cd -- 科目类型代码
    ,bond_descb -- 债券描述
    ,curr_cd -- 币种代码
    ,coret_duran -- 修正久期
    ,pvbp -- DV01
    ,inv_port_id -- 投组编号
    ,inv_port_name -- 投组名称
    ,inv_port_thd_cls_name -- 投组三分类名称
    ,acct_b_id -- 账薄编号
    ,acct_b_cd -- 账薄代码
    ,acct_b_name -- 账薄名称
    ,dept_org_id -- 部门机构编号
    ,prod_id -- 产品编号
    ,exp_yld_rat -- 到期收益率
    ,pend_ped -- 待偿期
    ,int_income -- 利息收入
    ,pda -- 折溢摊
    ,bs_spd -- 买卖价差
    ,float_prft_loss -- 浮动盈亏
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401029'||'2'||P1.SECURITY_ID||P1.QUERY_END_DATE -- 事件编号
    ,'9999' -- 法人编号
    ,'2' -- 损益分析类型代码
    ,${iml_schema}.dateformat_max2(p1.QUERY_END_DATE) -- 分析日期
    ,P1.SECURITY_ID -- 债券编号
    ,P1.SECURITY_NAME -- 债券名称
    ,nvl(trim(P1.SECURITY_TYPE),'00') -- 债券类型代码
    ,${iml_schema}.dateformat_min(p1.START_DATE) -- 起息日期
    ,${iml_schema}.dateformat_max2(p1.END_DATE) -- 到期日期
    ,P1.POSITION -- 面额
    ,P1.RESIDUALQTY -- 剩余本金
    ,P1.AVERAGECOST -- 平均成本
    ,P1.DPAPRICE -- 折溢摊净价
    ,P1.ACCRUEDINTEREST -- 应计利息
    ,nvl(trim(P1.ASSETTYPE),'-') -- 科目类型代码
    ,P1.CNAME -- 债券描述
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,P1.MDURATION -- 修正久期
    ,P1.PVBP -- DV01
    ,decode(to_char(P1.PFOLIO_ID),'0',' ',P1.PFOLIO_ID) -- 投组编号
    ,P1.PFOLIO_NAME -- 投组名称
    ,P1.BUZTYPE -- 投组三分类名称
    ,decode(to_char(P1.KEEPFOLDER_ID),'0',' ',P1.KEEPFOLDER_ID) -- 账薄编号
    ,P1.KEEPFOLDER_CODE -- 账薄代码
    ,P1.KEEPFOLDER_SHORTNAME -- 账薄名称
    ,P1.ORG_ID -- 部门机构编号
    ,P1.PRODUCT_CODE -- 产品编号
    ,P1.YIELD -- 到期收益率
    ,P1.SECURITY_TERM_TO_MATURITY -- 待偿期
    ,P1.COUPONINTERESTAMT -- 利息收入
    ,P1.DPA -- 折溢摊
    ,P1.SPREAD -- 买卖价差
    ,P1.URPL -- 浮动盈亏
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_vi_cms_zyt_cost_analyse_dtl_bond' -- 源表名称
    ,'ctmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.ctms_vi_cms_zyt_cost_analyse_dtl_bond p1
 where 1 = 1
   and p1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_pl_analy_flow truncate subpartition p_ctmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_pl_analy_flow exchange subpartition p_ctmsi1_${batch_date} with table ${iml_schema}.evt_pl_analy_flow_ctmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_pl_analy_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_pl_analy_flow_ctmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_pl_analy_flow', partname => 'p_ctmsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);