/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_loan_provi_flow_ncbsi1
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
drop table ${iml_schema}.evt_loan_provi_flow_ncbsi1_tm purge;
alter table ${iml_schema}.evt_loan_provi_flow add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_loan_provi_flow modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_loan_provi_flow_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,provi_flow_num -- 计提流水号
    ,provi_dt -- 计提日期
    ,acct_id -- 账户编号
    ,int_cls_cd -- 利息分类代码
    ,loan_num -- 贷款号
    ,prod_id -- 产品编号
    ,org_id -- 机构编号
    ,chn_id -- 渠道编号
    ,curr_cd -- 币种代码
    ,acm_provi_amt -- 累计计提金额
    ,td_provi_int -- 本日计提利息
    ,td_provi_actl_amt -- 本日计提实际金额
    ,provi_amt_bal -- 计提金额差额
    ,int_tax_acm_amt -- 利息税累计金额
    ,td_int_tax -- 本日利息税
    ,td_int_tax_init_amt -- 本日利息税原金额
    ,int_tax_bal -- 利息税差额
    ,tax_category_cd -- 税种代码
    ,provi_tax_rat -- 计提税率
    ,cust_id -- 客户编号
    ,tran_intior_type_cd -- 交易发起方类型代码
    ,src_module_type_cd -- 源模块类型代码
    ,sob_cate_cd -- 账套类别代码
    ,provi_accum -- 计提积数
    ,int_amt -- 利息金额
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,year_int_accr_base_cd -- 年计息基准代码
    ,int_accr_base_cd -- 计息基准代码
    ,tran_ref_no -- 交易参考号
    ,remark -- 备注
    ,revs_flg -- 冲正标志
    ,dubil_id -- 借据编号
    ,int_accr_way_cd -- 计息方式代码
    ,post_flg -- 过账标志
    ,cntpty_tran_ref_no -- 对方交易参考号
    ,int_rat_type_cd -- 利率类型代码
    ,bank_int_int_rat -- 行内利率
    ,float_int_rat -- 浮动利率
    ,exec_int_rat -- 执行利率
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,agt_chg_way_cd -- 协议变动方式代码
    ,agt_fix_int_rat -- 协议固定利率
    ,agt_float_ratio -- 协议浮动比例
    ,agt_float_point -- 协议浮动点数
    ,merge_flg -- 合并标志
    ,tran_tm -- 交易时间
    ,cust_type_cd -- 客户类型代码
    ,accti_status_cd -- 核算状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_loan_provi_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_cl_accr_info-1
insert into ${iml_schema}.evt_loan_provi_flow_ncbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,provi_flow_num -- 计提流水号
    ,provi_dt -- 计提日期
    ,acct_id -- 账户编号
    ,int_cls_cd -- 利息分类代码
    ,loan_num -- 贷款号
    ,prod_id -- 产品编号
    ,org_id -- 机构编号
    ,chn_id -- 渠道编号
    ,curr_cd -- 币种代码
    ,acm_provi_amt -- 累计计提金额
    ,td_provi_int -- 本日计提利息
    ,td_provi_actl_amt -- 本日计提实际金额
    ,provi_amt_bal -- 计提金额差额
    ,int_tax_acm_amt -- 利息税累计金额
    ,td_int_tax -- 本日利息税
    ,td_int_tax_init_amt -- 本日利息税原金额
    ,int_tax_bal -- 利息税差额
    ,tax_category_cd -- 税种代码
    ,provi_tax_rat -- 计提税率
    ,cust_id -- 客户编号
    ,tran_intior_type_cd -- 交易发起方类型代码
    ,src_module_type_cd -- 源模块类型代码
    ,sob_cate_cd -- 账套类别代码
    ,provi_accum -- 计提积数
    ,int_amt -- 利息金额
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,year_int_accr_base_cd -- 年计息基准代码
    ,int_accr_base_cd -- 计息基准代码
    ,tran_ref_no -- 交易参考号
    ,remark -- 备注
    ,revs_flg -- 冲正标志
    ,dubil_id -- 借据编号
    ,int_accr_way_cd -- 计息方式代码
    ,post_flg -- 过账标志
    ,cntpty_tran_ref_no -- 对方交易参考号
    ,int_rat_type_cd -- 利率类型代码
    ,bank_int_int_rat -- 行内利率
    ,float_int_rat -- 浮动利率
    ,exec_int_rat -- 执行利率
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,agt_chg_way_cd -- 协议变动方式代码
    ,agt_fix_int_rat -- 协议固定利率
    ,agt_float_ratio -- 协议浮动比例
    ,agt_float_point -- 协议浮动点数
    ,merge_flg -- 合并标志
    ,tran_tm -- 交易时间
    ,cust_type_cd -- 客户类型代码
    ,accti_status_cd -- 核算状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101020'||P1.SEQ_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SEQ_NO -- 计提流水号
    ,P1.ACCR_DATE -- 计提日期
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.INT_CLASS -- 利息分类代码
    ,P1.LOAN_NO -- 贷款号
    ,P1.PROD_TYPE -- 产品编号
    ,P1.BRANCH -- 机构编号
    ,P1.SOURCE_TYPE -- 渠道编号
    ,P1.CCY -- 币种代码
    ,P1.INT_ACCRUED -- 累计计提金额
    ,P1.INT_ACCRUED_CTD -- 本日计提利息
    ,P1.INT_ACCRUED_CALC_CTD -- 本日计提实际金额
    ,P1.INT_ACCRUED_DIFF -- 计提金额差额
    ,P1.TAX_ACCRUED -- 利息税累计金额
    ,P1.TAX_ACCRUED_CTD -- 本日利息税
    ,P1.TAX_ACCRUED_CALC_CTD -- 本日利息税原金额
    ,P1.TAX_ACCRUED_DIFF -- 利息税差额
    ,nvl(trim(P1.TAX_TYPE),'-') -- 税种代码
    ,P1.TAX_RATE -- 计提税率
    ,P1.CLIENT_NO -- 客户编号
    ,P1.TRAN_SOURCE -- 交易发起方类型代码
    ,P1.SOURCE_MODULE -- 源模块类型代码
    ,nvl(trim(P1.BUSINESS_UNIT),'-') -- 账套类别代码
    ,P1.AGG -- 计提积数
    ,P1.INT_AMT -- 利息金额
    ,nvl(trim(P1.MONTH_BASIS),'-') -- 月计息基准代码
    ,nvl(trim(P1.YEAR_BASIS),'-') -- 年计息基准代码
    ,case when nvl(trim(P1.MONTH_BASIS),'-')='ACT' and nvl(trim(P1.YEAR_BASIS),'-')='360'  then 'A/360'
     when nvl(trim(P1.MONTH_BASIS),'-')='D30' and nvl(trim(P1.YEAR_BASIS),'-')='360'  then '30/360'
     when nvl(trim(P1.MONTH_BASIS),'-')='ACT' and nvl(trim(P1.YEAR_BASIS),'-')='365'  then 'A/365'
     when nvl(trim(P1.MONTH_BASIS),'-')='D30' and nvl(trim(P1.YEAR_BASIS),'-')='365'  then '30/365'
     when nvl(trim(P1.MONTH_BASIS),'-')='ACT' and nvl(trim(P1.YEAR_BASIS),'-')='366'  then  'A/366'
     else '-'  end -- 计息基准代码
    ,P1.REFERENCE -- 交易参考号
    ,P1.REMARK -- 备注
    ,DECODE(TRIM(P1.REVERSAL),'','-','Y','1','N','0',P1.REVERSAL) -- 冲正标志
    ,P1.DD_NO -- 借据编号
    ,nvl(trim(P1.INT_CALC_BAL),'-') -- 计息方式代码
    ,DECODE(TRIM(P1.GL_POSTED_FLAG),'','-','Y','1','N','0',P1.GL_POSTED_FLAG) -- 过账标志
    ,P1.OTH_REFERENCE -- 对方交易参考号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.INT_TYPE END -- 利率类型代码
    ,P1.ACTUAL_RATE -- 行内利率
    ,P1.FLOAT_RATE -- 浮动利率
    ,P1.REAL_RATE -- 执行利率
    ,P1.ACCT_SPREAD_RATE -- 分户级利率浮动点数
    ,P1.ACCT_PERCENT_RATE -- 分户级利率浮动比例
    ,P1.ACCT_FIXED_RATE -- 分户级固定利率
    ,nvl(trim(P1.AGREE_CHANGE_TYPE),'-') -- 协议变动方式代码
    ,P1.AGREE_FIXED_RATE -- 协议固定利率
    ,P1.AGREE_PERCENT_RATE -- 协议浮动比例
    ,P1.AGREE_SPREAD_RATE -- 协议浮动点数
    ,DECODE(TRIM(P1.GL_MERGE_TYPE_FLAG),'','-','Y','1','N','0',P1.GL_MERGE_TYPE_FLAG) -- 合并标志
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,nvl(trim(P1.ACCOUNTING_STATUS),'-') -- 核算状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_accr_info' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_accr_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.INT_TYPE=R1.SRC_CODE_VAL
           AND R1.SORC_SYS_CD= 'NCBS'
           AND R1.SRC_TAB_EN_NAME ='NCBS_CL_ACCR_INFO'
           AND R1.SRC_FIELD_EN_NAME ='INT_TYPE'
           AND R1.TARGET_TAB_EN_NAME='EVT_LOAN_PROVI_FLOW'
           AND R1.TARGET_TAB_FIELD_EN_NAME='INT_RAT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CLIENT_TYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'NCBS'
        AND R2.SRC_TAB_EN_NAME= 'NCBS_CL_ACCR_INFO'
        AND R2.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_LOAN_PROVI_FLOW'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
where  1 = 1 
    and p1.accr_date = to_date( '${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_loan_provi_flow truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_loan_provi_flow exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_loan_provi_flow_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_loan_provi_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_loan_provi_flow_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_loan_provi_flow', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);