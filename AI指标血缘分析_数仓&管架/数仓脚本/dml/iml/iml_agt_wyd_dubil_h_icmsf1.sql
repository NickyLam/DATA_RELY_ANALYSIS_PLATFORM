/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_wyd_dubil_h_icmsf1
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
drop table ${iml_schema}.agt_wyd_dubil_h_icmsf1_tm purge;
alter table ${iml_schema}.agt_wyd_dubil_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_wyd_dubil_h modify partition p_icmsf1
    add subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wyd_dubil_h_icmsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_type_cd -- 客户类型代码
    ,prod_id -- 产品编号
    ,prod_cls_cd -- 产品类别代码
    ,curr_cd -- 币种代码
    ,level5_cls_cd -- 五级分类代码
    ,indus_type_cd -- 行业类型代码
    ,loan_tenor_cate_cd -- 贷款期限类别代码
    ,loan_tenor -- 贷款期限
    ,loan_usage_cd -- 贷款用途代码
    ,loan_status_cd -- 贷款状态代码
    ,out_acct_flow_num -- 出账流水号
    ,distr_status_cd -- 放款状态代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,cont_id -- 合同编号
    ,cont_mon_tenor -- 合同月期限
    ,loan_amt -- 贷款金额
    ,loan_bal -- 贷款余额
    ,loan_int_rat -- 贷款利率
    ,ovdue_int_rat -- 逾期利率
    ,value_dt -- 起息日期
    ,repay_way_cd -- 还款方式代码
    ,repay_day -- 还款日
    ,int_set_way_cd -- 结息方式代码
    ,int_accr_way_cd -- 计息方式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_adj_ped -- 利率调整周期
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_flo_val -- 利率浮动值
    ,white_list_cust_flg -- 白户标志
    ,asset_thd_cls_cd -- 资产三分类代码
    ,td_acru_int -- 当日应计利息
    ,recvbl_over_int -- 应收欠息
    ,recvbl_acru_pnlt -- 应收应计罚息
    ,recvbl_pnlt -- 应收罚息
    ,repay_num_id -- 还款账户编号
    ,repay_num_name -- 还款账户名称
    ,repay_org_id -- 还款机构编号
    ,repay_org_name -- 还款机构名称
    ,distr_acct_id -- 放款账户编号
    ,distr_acct_name -- 放款账户名称
    ,distr_org_id -- 放款机构编号
    ,distr_org_name -- 放款机构名称
    ,appl_delay_repay_sucs_cnt -- 申请延期还款成功次数
    ,aval_lmt -- 可用额度
    ,clear_tran_id -- 清算交易编号
    ,fin_org_id -- 财务机构编号
    ,tax_flg -- 涉税标志
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wyd_dubil_h
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- icms_wyd_loan-1
insert into ${iml_schema}.agt_wyd_dubil_h_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_type_cd -- 客户类型代码
    ,prod_id -- 产品编号
    ,prod_cls_cd -- 产品类别代码
    ,curr_cd -- 币种代码
    ,level5_cls_cd -- 五级分类代码
    ,indus_type_cd -- 行业类型代码
    ,loan_tenor_cate_cd -- 贷款期限类别代码
    ,loan_tenor -- 贷款期限
    ,loan_usage_cd -- 贷款用途代码
    ,loan_status_cd -- 贷款状态代码
    ,out_acct_flow_num -- 出账流水号
    ,distr_status_cd -- 放款状态代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,cont_id -- 合同编号
    ,cont_mon_tenor -- 合同月期限
    ,loan_amt -- 贷款金额
    ,loan_bal -- 贷款余额
    ,loan_int_rat -- 贷款利率
    ,ovdue_int_rat -- 逾期利率
    ,value_dt -- 起息日期
    ,repay_way_cd -- 还款方式代码
    ,repay_day -- 还款日
    ,int_set_way_cd -- 结息方式代码
    ,int_accr_way_cd -- 计息方式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_adj_ped -- 利率调整周期
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_flo_val -- 利率浮动值
    ,white_list_cust_flg -- 白户标志
    ,asset_thd_cls_cd -- 资产三分类代码
    ,td_acru_int -- 当日应计利息
    ,recvbl_over_int -- 应收欠息
    ,recvbl_acru_pnlt -- 应收应计罚息
    ,recvbl_pnlt -- 应收罚息
    ,repay_num_id -- 还款账户编号
    ,repay_num_name -- 还款账户名称
    ,repay_org_id -- 还款机构编号
    ,repay_org_name -- 还款机构名称
    ,distr_acct_id -- 放款账户编号
    ,distr_acct_name -- 放款账户名称
    ,distr_org_id -- 放款机构编号
    ,distr_org_name -- 放款机构名称
    ,appl_delay_repay_sucs_cnt -- 申请延期还款成功次数
    ,aval_lmt -- 可用额度
    ,clear_tran_id -- 清算交易编号
    ,fin_org_id -- 财务机构编号
    ,tax_flg -- 涉税标志
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300066'||P1.LENDINGREF -- 协议编号
    ,'9999' -- 法人编号
    ,P1.LENDINGREF -- 借据编号
    ,P1.CUSTOMERID -- 客户编号
    ,nvl(trim(P2.CUSTOMERNAME),' ') -- 客户名称
    ,nvl(trim(P1.TYPEOFCUST),'-') -- 客户类型代码
    ,P1.PRODUCTID -- 产品编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'|| P1.DDTYP END -- 产品类别代码
    ,nvl(trim(P1.BUSINESSCURRENCY),'-') -- 币种代码
    ,nvl(trim(P1.CLASSIFYRESULT),'99') -- 五级分类代码
    ,nvl(trim(P1.CATEGORY),'-') -- 行业类型代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.TERMFLAG END -- 贷款期限类别代码
    ,to_number(nvl(trim(P1.TERMDATE),0)) -- 贷款期限
    ,nvl(trim(P1.LOANUSAGE),'000000') -- 贷款用途代码
    ,nvl(trim(P1.LOANSTATUS),'-') -- 贷款状态代码
    ,P1.SEQNO -- 出账流水号
    ,nvl(trim(P1.STATUS),'-') -- 放款状态代码
    ,nvl(trim(P1.BASERATETYPE),'-') -- 基准利率类型代码
    ,P1.LPRBASERATE -- 基准利率
    ,${iml_schema}.dateformat_min(P1.PUTOUTDATE) -- 生效日期
    ,${iml_schema}.dateformat_max2(P1.MATURITY) -- 到期日期
    ,P1.CONTRACTNO -- 合同编号
    ,P1.TREMMONTH -- 合同月期限
    ,P1.BUSINESSSUM -- 贷款金额
    ,P1.BALANCE -- 贷款余额
    ,P1.BUSINESSRATE -- 贷款利率
    ,P1.OVERDUEFINE -- 逾期利率
    ,${iml_schema}.dateformat_min(P1.STARTINTERESTDATE) -- 起息日期
    ,nvl(trim(P1.CORPUSPAYMETHOD),'-') -- 还款方式代码
    ,P1.PAYDAY -- 还款日
    ,nvl(trim(P1.IPCODE),'-') -- 结息方式代码
    ,nvl(trim(P1.INTERESTCALCULATETYPE),'-') -- 计息方式代码
    ,nvl(trim(P1.RATEADJUSTTYPE),'-') -- 利率调整方式代码
    ,nvl(trim(P1.REPRICETERMUNIT),'-') -- 利率调整周期代码
    ,to_number(nvl(trim(P1.REPRICETERMFREQUENCY),0)) -- 利率调整周期
    ,nvl(trim(P1.RATEFLOATTYPE),'-') -- 利率浮动方式代码
    ,P1.RATEFLOATVALUE -- 利率浮动值
    ,nvl(trim(P1.ISRISKCREDITWHITE),'-') -- 白户标志
    ,nvl(trim(P1.REMART),'XXX') -- 资产三分类代码
    ,to_number(nvl(trim(P1.ACCRUEINTERDAY),0)) -- 当日应计利息
    ,P1.YSINTAMT -- 应收欠息
    ,P1.RCVAACCRPNLT -- 应收应计罚息
    ,P1.YSODPAMT -- 应收罚息
    ,P1.PAYACCTNO -- 还款账户编号
    ,P1.PAYACCTNONAME -- 还款账户名称
    ,P1.PAYACCTBANKNO -- 还款机构编号
    ,P1.PAYACCTBANK -- 还款机构名称
    ,P1.INACCTNO -- 放款账户编号
    ,P1.INACCTNONAME -- 放款账户名称
    ,P1.INACCTBANKNO -- 放款机构编号
    ,P1.INACCTBANK -- 放款机构名称
    ,to_number(nvl(trim(P1.LOANCHANGFREQUENCY),0)) -- 申请延期还款成功次数
    ,P1.FKSDBUSINESSSUM -- 可用额度
    ,P1.WITHDRAWSETTLEID -- 清算交易编号
    ,P1.PUTOUTORGID -- 财务机构编号
    ,nvl(trim(P1.TAXFLAG),'-') -- 涉税标志
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 最后更新柜员编号
    ,P1.UPDATEORGID -- 最后更新机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_wyd_loan' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_wyd_loan p1
  left join ${iol_schema}.icms_customer_info_lhdk p2 
    on p1.customerid = p2.customerid 
   and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.ref_pub_cd_map r2 on P1.DDTYP = R2.SRC_CODE_VAL
   AND R2.SORC_SYS_CD= 'ICMS'
   AND R2.SRC_TAB_EN_NAME= 'ICMS_WYD_LOAN'
   AND R2.SRC_FIELD_EN_NAME= 'DDTYP'
   AND R2.TARGET_TAB_EN_NAME= 'AGT_WYD_DUBIL_H'
   AND R2.TARGET_TAB_FIELD_EN_NAME= 'PROD_CLS_CD'
  left join ${iml_schema}.ref_pub_cd_map r1 on P1.TERMFLAG = R1.SRC_CODE_VAL
   AND R1.SORC_SYS_CD= 'ICMS'
   AND R1.SRC_TAB_EN_NAME= 'ICMS_WYD_LOAN'
   AND R1.SRC_FIELD_EN_NAME= 'TERMFLAG'
   AND R1.TARGET_TAB_EN_NAME= 'AGT_WYD_DUBIL_H'
   AND R1.TARGET_TAB_FIELD_EN_NAME= 'LOAN_TENOR_CATE_CD'
where  1 = 1 
    and p1.etl_dt=to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.agt_wyd_dubil_h truncate subpartition p_icmsf1_${batch_date} reuse storage;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.agt_wyd_dubil_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_wyd_dubil_h_icmsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_wyd_dubil_h to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_wyd_dubil_h_icmsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_wyd_dubil_h', partname => 'p_icmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);