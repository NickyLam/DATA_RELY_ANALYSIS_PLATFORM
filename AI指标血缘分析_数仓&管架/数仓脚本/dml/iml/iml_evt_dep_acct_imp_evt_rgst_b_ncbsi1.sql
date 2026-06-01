/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_dep_acct_imp_evt_rgst_b_ncbsi1
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
drop table ${iml_schema}.evt_dep_acct_imp_evt_rgst_b_ncbsi1_tm purge;
alter table ${iml_schema}.evt_dep_acct_imp_evt_rgst_b add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_dep_acct_imp_evt_rgst_b modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_dep_acct_imp_evt_rgst_b_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,acct_id -- 账户编号
    ,int_cls_cd -- 利息分类代码
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,acct_curr_cd -- 账户币种代码
    ,sub_acct_num -- 子账号
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_dt -- 开户日期
    ,cust_id -- 客户编号
    ,dep_redt_type_cd -- 存款转存类型代码
    ,int_rat_type_cd -- 利率类型代码
    ,bank_int_int_rat -- 行内利率
    ,float_int_rat -- 浮动利率
    ,float_point -- 浮动点数
    ,exec_int_rat -- 执行利率
    ,acm_int_adj_amt -- 累计利息调整金额
    ,provi_day_int_adj_amt -- 计提日利息调整金额
    ,base_int_rat -- 基础利率
    ,tot_int_amt -- 总利息金额
    ,int_accr_amt -- 计息金额
    ,last_int_set_dt -- 上一结息日期
    ,cap_flg -- 资本化标志
    ,dep_term_tenor -- 存期期限
    ,tenor_type_cd -- 期限类型代码
    ,exp_dt -- 到期日期
    ,amt_type_cd -- 金额类型代码
    ,tran_happ_pric -- 交易发生本金
    ,tran_amt -- 交易金额
    ,wdraw_int_rat -- 支取利率
    ,net_int -- 净利息
    ,int_accr_days -- 计息天数
    ,tax_rat -- 税率
    ,tax_category_cd -- 税种代码
    ,tax_amt -- 税金
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_no -- 凭证号码
    ,redt_seq_num -- 转存序号
    ,tran_ref_no -- 交易参考号
    ,post_flg -- 过账标志
    ,tran_revs_dt -- 交易冲正日期
    ,accti_status_cd -- 核算状态代码
    ,sob_cate_cd -- 账套类别代码
    ,tran_memo_descb -- 交易摘要描述
    ,src_module_type_cd -- 源模块类型代码
    ,bus_proc_status_cd -- 业务处理状态代码
    ,check_entry_cd -- 对账码
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,bus_flow_num -- 业务流水号
    ,cust_type_cd -- 客户类型代码
    ,int_calc_begin_dt -- 利息计算起始日期
    ,year_base_days -- 年计息基准代码
    ,mon_base_cd -- 月基准代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_dep_acct_imp_evt_rgst_b
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_rb_acct_event_register-1
insert into ${iml_schema}.evt_dep_acct_imp_evt_rgst_b_ncbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,acct_id -- 账户编号
    ,int_cls_cd -- 利息分类代码
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,acct_curr_cd -- 账户币种代码
    ,sub_acct_num -- 子账号
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_dt -- 开户日期
    ,cust_id -- 客户编号
    ,dep_redt_type_cd -- 存款转存类型代码
    ,int_rat_type_cd -- 利率类型代码
    ,bank_int_int_rat -- 行内利率
    ,float_int_rat -- 浮动利率
    ,float_point -- 浮动点数
    ,exec_int_rat -- 执行利率
    ,acm_int_adj_amt -- 累计利息调整金额
    ,provi_day_int_adj_amt -- 计提日利息调整金额
    ,base_int_rat -- 基础利率
    ,tot_int_amt -- 总利息金额
    ,int_accr_amt -- 计息金额
    ,last_int_set_dt -- 上一结息日期
    ,cap_flg -- 资本化标志
    ,dep_term_tenor -- 存期期限
    ,tenor_type_cd -- 期限类型代码
    ,exp_dt -- 到期日期
    ,amt_type_cd -- 金额类型代码
    ,tran_happ_pric -- 交易发生本金
    ,tran_amt -- 交易金额
    ,wdraw_int_rat -- 支取利率
    ,net_int -- 净利息
    ,int_accr_days -- 计息天数
    ,tax_rat -- 税率
    ,tax_category_cd -- 税种代码
    ,tax_amt -- 税金
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_no -- 凭证号码
    ,redt_seq_num -- 转存序号
    ,tran_ref_no -- 交易参考号
    ,post_flg -- 过账标志
    ,tran_revs_dt -- 交易冲正日期
    ,accti_status_cd -- 核算状态代码
    ,sob_cate_cd -- 账套类别代码
    ,tran_memo_descb -- 交易摘要描述
    ,src_module_type_cd -- 源模块类型代码
    ,bus_proc_status_cd -- 业务处理状态代码
    ,check_entry_cd -- 对账码
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,bus_flow_num -- 业务流水号
    ,cust_type_cd -- 客户类型代码
    ,int_calc_begin_dt -- 利息计算起始日期
    ,year_base_days -- 年计息基准代码
    ,mon_base_cd -- 月基准代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101047'||P1.INTERNAL_KEY||P1.SEQ_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SEQ_NO -- 序号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.INT_CLASS -- 利息分类代码
    ,P1.TRAN_DATE -- 交易日期
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,nvl(trim(p8.card_no),p1.BASE_ACCT_NO) -- 客户账号
    ,P1.PROD_TYPE -- 产品编号
    ,P1.ACCT_CCY -- 账户币种代码
    ,P1.ACCT_SEQ_NO -- 子账号
    ,P1.ACCT_BRANCH -- 开户机构编号
    ,P1.ACCT_OPEN_DATE -- 开户日期
    ,P1.CLIENT_NO -- 客户编号
    ,nvl(trim(P1.MOVT_STATUS),'-') -- 存款转存类型代码
    ,nvl(trim(P1.INT_TYPE),'-') -- 利率类型代码
    ,P1.ACTUAL_RATE -- 行内利率
    ,P1.FLOAT_RATE -- 浮动利率
    ,P1.SPREAD_RATE -- 浮动点数
    ,P1.REAL_RATE -- 执行利率
    ,P1.INT_ADJ -- 累计利息调整金额
    ,P1.INT_ADJ_CTD -- 计提日利息调整金额
    ,P1.ACCT_LEVEL_INT_RATE -- 基础利率
    ,P1.GROSS_INTEREST_AMT -- 总利息金额
    ,P1.CALC_INT_AMT -- 计息金额
    ,P1.LAST_CYCLE_DATE -- 上一结息日期
    ,DECODE(TRIM(P1.INT_CAP_FLAG),'','-','Y','1','N','0',P1.INT_CAP_FLAG) -- 资本化标志
    ,NVL(TRIM(P1.TERM),0) -- 存期期限
    ,nvl(trim(P1.TERM_TYPE),'-') -- 期限类型代码
    ,P1.MATURITY_DATE -- 到期日期
    ,nvl(trim(P1.AMT_TYPE),'-') -- 金额类型代码
    ,P1.PRINCIPAL_AMT -- 交易发生本金
    ,P1.TRAN_AMT -- 交易金额
    ,P1.DEBT_INT_RATE -- 支取利率
    ,P1.NET_INTEREST_AMT -- 净利息
    ,P1.CALC_DAYS -- 计息天数
    ,P1.TAX_RATE -- 税率
    ,nvl(trim(P1.TAX_TYPE),'-') -- 税种代码
    ,P1.TAX_AMT -- 税金
    ,nvl(trim(P1.DOC_TYPE),'-') -- 存款凭证类别代码
    ,P1.VOUCHER_NO -- 凭证号码
    ,P1.SEQ_RENEW_ROLLOVER_NO -- 转存序号
    ,P1.REFERENCE -- 交易参考号
    ,DECODE(TRIM(P1.GL_POSTED_FLAG),'','-','Y','1','N','0',P1.GL_POSTED_FLAG) -- 过账标志
    ,P1.REVERSAL_DATE -- 交易冲正日期
    ,nvl(trim(P1.ACCOUNTING_STATUS),'-') -- 核算状态代码
    ,nvl(trim(P1.BUSINESS_UNIT),'-') -- 账套类别代码
    ,P1.NARRATIVE -- 交易摘要描述
    ,P1.SOURCE_MODULE -- 源模块类型代码
    ,nvl(trim(P1.TRAN_STATUS),'-') -- 业务处理状态代码
    ,P1.REACCOUNT_CD -- 对账码
    ,P1.USER_ID -- 交易柜员编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.BUS_SEQ_NO -- 业务流水号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,P1.CALC_BEGIN_DATE -- 利息计算起始日期
    ,nvl(trim(P1.YEAR_BASIS),'-') -- 年计息基准代码
    ,nvl(trim(P1.MONTH_BASIS),'-') -- 月基准代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_acct_event_register' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_acct_event_register p1
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p8 on p1.BASE_ACCT_NO=p8.BASE_ACCT_NO and p8.BASE_ACCT_NO LIKE '0%'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLIENT_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NCBS'
        AND R1.SRC_TAB_EN_NAME= 'NCBS_RB_ACCT_EVENT_REGISTER'
        AND R1.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_DEP_ACCT_IMP_EVT_RGST_B'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
where  1 = 1 
    and p1.tran_date=to_date('${batch_date}','yyyymmdd') 
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_dep_acct_imp_evt_rgst_b truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_dep_acct_imp_evt_rgst_b exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_dep_acct_imp_evt_rgst_b_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_dep_acct_imp_evt_rgst_b to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_dep_acct_imp_evt_rgst_b_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_dep_acct_imp_evt_rgst_b', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);