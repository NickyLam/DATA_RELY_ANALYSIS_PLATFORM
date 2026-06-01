/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_myloan_tran_distr_cont_mybkf1
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
drop table ${iml_schema}.agt_myloan_tran_distr_cont_mybkf1_tm purge;
drop table ${iml_schema}.agt_myloan_tran_distr_cont_mybkf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_myloan_tran_distr_cont add partition p_mybkf1 values ('mybkf1')(
        subpartition p_mybkf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_myloan_tran_distr_cont modify partition p_mybkf1
    add subpartition p_mybkf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_myloan_tran_distr_cont_mybkf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_myloan_tran_distr_cont partition for ('mybkf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_myloan_tran_distr_cont_mybkf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,distr_cap_flow_num -- 放款资金流水号
    ,prod_code -- 产品码
    ,brwer_name -- 借款人名称
    ,brwer_cert_type_cd -- 借款人证件类型代码
    ,brwer_cert_no -- 借款人证件号码
    ,loan_status_cd -- 贷款状态代码
    ,loan_usage_cd -- 贷款用途代码
    ,loan_cap_dom_overs_flg -- 贷款资金境内外标志
    ,appl_disb_tm -- 申请支用时间
    ,distr_dt -- 放款日期
    ,curr_cd -- 币种代码
    ,distr_amt -- 放款金额
    ,loan_value_dt -- 贷款起息日期
    ,loan_exp_dt -- 贷款到期日期
    ,loan_tenor -- 贷款期限
    ,repay_way_cd -- 还款方式代码
    ,grace_period_days -- 宽限期天数
    ,int_rat_type_cd -- 利率类型代码
    ,loan_day_int_rat -- 贷款日利率
    ,pric_repay_ped_type_cd -- 本金还款周期类型代码
    ,int_repay_ped_type_cd -- 利息还款周期类型代码
    ,guar_type_cd -- 担保类型代码
    ,crdt_id -- 授信编号
    ,recvbl_num_type_cd -- 收款账号类型代码
    ,recvbl_house_hold_name -- 收款账号户主名称
    ,recvbl_num -- 收款账号
    ,recvbl_bank_name -- 收款银行名称
    ,repay_num_type_cd -- 还款账号类型代码
    ,repay_house_hold_name -- 还款账号户主名称
    ,repay_num -- 还款账号
    ,repay_bank_name -- 还款银行名称
    ,user_id -- 用户编号
    ,dist_cd -- 行政区划代码
    ,loan_year_int_rat -- 贷款年利率
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_myloan_tran_distr_cont
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_myloan_tran_distr_cont_mybkf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_myloan_tran_distr_cont partition for ('mybkf1') where 0=1;

-- 2.1 insert data to tm table
-- icms_mybk_acc_loan-1
insert into ${iml_schema}.agt_myloan_tran_distr_cont_mybkf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,distr_cap_flow_num -- 放款资金流水号
    ,prod_code -- 产品码
    ,brwer_name -- 借款人名称
    ,brwer_cert_type_cd -- 借款人证件类型代码
    ,brwer_cert_no -- 借款人证件号码
    ,loan_status_cd -- 贷款状态代码
    ,loan_usage_cd -- 贷款用途代码
    ,loan_cap_dom_overs_flg -- 贷款资金境内外标志
    ,appl_disb_tm -- 申请支用时间
    ,distr_dt -- 放款日期
    ,curr_cd -- 币种代码
    ,distr_amt -- 放款金额
    ,loan_value_dt -- 贷款起息日期
    ,loan_exp_dt -- 贷款到期日期
    ,loan_tenor -- 贷款期限
    ,repay_way_cd -- 还款方式代码
    ,grace_period_days -- 宽限期天数
    ,int_rat_type_cd -- 利率类型代码
    ,loan_day_int_rat -- 贷款日利率
    ,pric_repay_ped_type_cd -- 本金还款周期类型代码
    ,int_repay_ped_type_cd -- 利息还款周期类型代码
    ,guar_type_cd -- 担保类型代码
    ,crdt_id -- 授信编号
    ,recvbl_num_type_cd -- 收款账号类型代码
    ,recvbl_house_hold_name -- 收款账号户主名称
    ,recvbl_num -- 收款账号
    ,recvbl_bank_name -- 收款银行名称
    ,repay_num_type_cd -- 还款账号类型代码
    ,repay_house_hold_name -- 还款账号户主名称
    ,repay_num -- 还款账号
    ,repay_bank_name -- 还款银行名称
    ,user_id -- 用户编号
    ,dist_cd -- 行政区划代码
    ,loan_year_int_rat -- 贷款年利率
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222630'||P1.CONTRACTNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.CONTRACTNO -- 合同编号
    ,P1.FUNDSEQNO -- 放款资金流水号
    ,P1.PRODCODE -- 产品码
    ,P1.NAME -- 借款人名称
    ,nvl(trim(P1.CERTTYPE),'0000') -- 借款人证件类型代码
    ,P1.CERTNO -- 借款人证件号码
    ,nvl(trim(P1.LOANSTATUS),'0') -- 贷款状态代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.LOANUSE END  -- 贷款用途代码
    ,P1.USEAREA -- 贷款资金境内外标志
    ,case when trim(P1.APPLYDATE) is null then to_timestamp('2099-12-31 00:00:00', 'yyyy-mm-dd hh24:mi:ss.ff6') else to_timestamp(P1.APPLYDATE, 'yyyy-mm-dd hh24:mi:ss.ff6') end -- 申请支用时间
    ,${iml_schema}.dateformat_max2(P1.ENCASHDATE) -- 放款日期
    ,nvl(trim(P1.CURRENCY),'-')  -- 币种代码
    ,nvl(P1.ENCASHAMT,0) -- 放款金额
    ,${iml_schema}.DATEFORMAT_MIN(P1.STARTDATE) -- 贷款起息日期
    ,${iml_schema}.dateformat_max2(P1.ENDDATE) -- 贷款到期日期
    ,P1.TOTALTERMS -- 贷款期限
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.REPAYMODE END -- 还款方式代码
    ,nvl(trim(P1.GRACEDAY),0) -- 宽限期天数
    ,nvl(trim(P1.RATETYPE),'F') -- 利率类型代码
    ,P1.EXECRATE/360*100 -- 贷款日利率
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.PRINREPAYFREQUENCY END -- 本金还款周期类型代码
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.INTREPAYFREQUENCY END -- 利息还款周期类型代码
    ,nvl(trim(P1.GUARANTEETYPE),'Z')  -- 担保类型代码
    ,P1.CREDITNO -- 授信编号
    ,nvl(trim(P1.ENCASHACCTTYPE),'-') -- 收款账号类型代码
    ,P1.ENCASHACCTNAME -- 收款账号户主名称
    ,P1.ENCASHACCTNO -- 收款账号
    ,P1.ENCASHBANKNAME -- 收款银行名称
    ,nvl(trim(P1.REPAYACCTTYPE),'-') -- 还款账号类型代码
    ,P1.REPAYACCTNAME -- 还款账号户主名称
    ,P1.REPAYACCTNO -- 还款账号
    ,P1.REPAYBANKNAME -- 还款银行名称
    ,P1.IPID -- 用户编号
    ,' ' -- 行政区划代码
    ,P1.EXECRATE*100 -- 贷款年利率
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_mybk_acc_loan' -- 源表名称
    ,'mybkf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_mybk_acc_loan p1
    left join ${iol_schema}.rcrs_mybk_acc_loan_clear p2 on P1.contractno = P2.contract_no
 and P2.start_dt <= to_date('${batch_date}','yyyymmdd')
 and P2.end_dt >  to_date('${batch_date}','yyyymmdd')
   left join ${iml_schema}.ref_pub_cd_map r2 on P1.LOANUSE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ICMS'
        AND R2.SRC_TAB_EN_NAME= 'ICMS_MYBK_ACC_LOAN'
        AND R2.SRC_FIELD_EN_NAME= 'LOANUSE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_MYLOAN_TRAN_DISTR_CONT'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'LOAN_USAGE_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.REPAYMODE = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'ICMS'
        AND R4.SRC_TAB_EN_NAME= 'ICMS_MYBK_ACC_LOAN'
        AND R4.SRC_FIELD_EN_NAME= 'REPAYMODE'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_MYLOAN_TRAN_DISTR_CONT'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'REPAY_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.PRINREPAYFREQUENCY = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'ICMS'
        AND R5.SRC_TAB_EN_NAME= 'ICMS_MYBK_ACC_LOAN'
        AND R5.SRC_FIELD_EN_NAME= 'PRINREPAYFREQUENCY'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_MYLOAN_TRAN_DISTR_CONT'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'PRIC_REPAY_PED_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.INTREPAYFREQUENCY = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'ICMS'
        AND R6.SRC_TAB_EN_NAME= 'ICMS_MYBK_ACC_LOAN'
        AND R6.SRC_FIELD_EN_NAME= 'INTREPAYFREQUENCY'
        AND R6.TARGET_TAB_EN_NAME= 'AGT_MYLOAN_TRAN_DISTR_CONT'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'INT_REPAY_PED_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') 
  and p1.end_dt > to_date('${batch_date}','yyyymmdd')
  and P1.opttype = 'IN' 
  and P2.contract_no is null 
  and P1.biztype <> '201020100057' -- 过滤房抵贷数据
;
commit;

insert into ${iml_schema}.agt_myloan_tran_distr_cont_mybkf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,distr_cap_flow_num -- 放款资金流水号
    ,prod_code -- 产品码
    ,brwer_name -- 借款人名称
    ,brwer_cert_type_cd -- 借款人证件类型代码
    ,brwer_cert_no -- 借款人证件号码
    ,loan_status_cd -- 贷款状态代码
    ,loan_usage_cd -- 贷款用途代码
    ,loan_cap_dom_overs_flg -- 贷款资金境内外标志
    ,appl_disb_tm -- 申请支用时间
    ,distr_dt -- 放款日期
    ,curr_cd -- 币种代码
    ,distr_amt -- 放款金额
    ,loan_value_dt -- 贷款起息日期
    ,loan_exp_dt -- 贷款到期日期
    ,loan_tenor -- 贷款期限
    ,repay_way_cd -- 还款方式代码
    ,grace_period_days -- 宽限期天数
    ,int_rat_type_cd -- 利率类型代码
    ,loan_day_int_rat -- 贷款日利率
    ,pric_repay_ped_type_cd -- 本金还款周期类型代码
    ,int_repay_ped_type_cd -- 利息还款周期类型代码
    ,guar_type_cd -- 担保类型代码
    ,crdt_id -- 授信编号
    ,recvbl_num_type_cd -- 收款账号类型代码
    ,recvbl_house_hold_name -- 收款账号户主名称
    ,recvbl_num -- 收款账号
    ,recvbl_bank_name -- 收款银行名称
    ,repay_num_type_cd -- 还款账号类型代码
    ,repay_house_hold_name -- 还款账号户主名称
    ,repay_num -- 还款账号
    ,repay_bank_name -- 还款银行名称
    ,user_id -- 用户编号
    ,dist_cd -- 行政区划代码
    ,loan_year_int_rat -- 贷款年利率
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222630'||P1.CONTRACT_NO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.CONTRACT_NO -- 合同编号
    ,P1.FUND_SEQ_NO -- 放款资金流水号
    ,P1.PROD_CODE -- 产品码
    ,P1.NAME -- 借款人名称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CERT_TYPE END -- 借款人证件类型代码
    ,P1.CERT_NO -- 借款人证件号码
    ,nvl(trim(P1.LOAN_STATUS),'0') -- 贷款状态代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.LOAN_USE END  -- 贷款用途代码
    ,P1.USE_AREA -- 贷款资金境内外标志
    ,case when trim(P1.APPLY_DATE) is null then to_timestamp('2099-12-31 00:00:00', 'yyyy-mm-dd hh24:mi:ss.ff6') else to_timestamp(P1.APPLY_DATE, 'yyyy-mm-dd hh24:mi:ss.ff6') end -- 申请支用时间
    ,${iml_schema}.dateformat_max2(P1.ENCASH_DATE) -- 放款日期
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,nvl(P1.ENCASH_AMT,0) -- 放款金额
    ,${iml_schema}.dateformat_min(P1.START_DATE) -- 贷款起息日期
    ,${iml_schema}.dateformat_max2(P1.END_DATE) -- 贷款到期日期
    ,P1.TOTAL_TERMS -- 贷款期限
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.REPAY_MODE END -- 还款方式代码
    ,nvl(trim(P1.GRACE_DAY),0) -- 宽限期天数
    ,nvl(trim(P1.RATE_TYPE),'F') -- 利率类型代码
    ,P1.EXEC_RATE/360*100 -- 贷款日利率
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.PRIN_REPAY_FREQUENCY END -- 本金还款周期类型代码
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.INT_REPAY_FREQUENCY END -- 利息还款周期类型代码
    ,nvl(trim(P1.GUARANTEE_TYPE),'Z')  -- 担保类型代码
    ,P1.CREDIT_NO -- 授信编号
    ,P1.ENCASH_ACCT_TYPE -- 收款账号类型代码
    ,P1.ENCASH_ACCT_NAME -- 收款账号户主名称
    ,P1.ENCASH_ACCT_NO -- 收款账号
    ,P1.ENCASH_BANK_NAME -- 收款银行名称
    ,P1.REPAY_ACCT_TYPE -- 还款账号类型代码
    ,P1.REPAY_ACCT_NAME -- 还款账号户主名称
    ,P1.REPAY_ACCT_NO -- 还款账号
    ,P1.REPAY_BANK_NAME -- 还款银行名称
    ,P1.IP_ID -- 用户编号
    ,' ' -- 行政区划代码
    ,P1.EXEC_RATE*100 -- 贷款年利率
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'rcrs_mybk_acc_loan_clear' -- 源表名称
    ,'mybkf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.rcrs_mybk_acc_loan_clear p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CERT_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'RCRS_MYBK_ACC_LOAN_CLEAR'
        AND R1.SRC_FIELD_EN_NAME= 'CERT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_MYLOAN_TRAN_DISTR_CONT'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'BRWER_CERT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.LOAN_USE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ICMS'
        AND R2.SRC_TAB_EN_NAME= 'RCRS_MYBK_ACC_LOAN_CLEAR'
        AND R2.SRC_FIELD_EN_NAME= 'LOAN_USE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_MYLOAN_TRAN_DISTR_CONT'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'LOAN_USAGE_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.REPAY_MODE = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'ICMS'
        AND R4.SRC_TAB_EN_NAME= 'RCRS_MYBK_ACC_LOAN_CLEAR'
        AND R4.SRC_FIELD_EN_NAME= 'REPAY_MODE'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_MYLOAN_TRAN_DISTR_CONT'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'REPAY_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.PRIN_REPAY_FREQUENCY = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'ICMS'
        AND R5.SRC_TAB_EN_NAME= 'RCRS_MYBK_ACC_LOAN_CLEAR'
        AND R5.SRC_FIELD_EN_NAME= 'PRIN_REPAY_FREQUENCY'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_MYLOAN_TRAN_DISTR_CONT'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'PRIC_REPAY_PED_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.INT_REPAY_FREQUENCY = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'ICMS'
        AND R6.SRC_TAB_EN_NAME= 'RCRS_MYBK_ACC_LOAN_CLEAR'
        AND R6.SRC_FIELD_EN_NAME= 'INT_REPAY_FREQUENCY'
        AND R6.TARGET_TAB_EN_NAME= 'AGT_MYLOAN_TRAN_DISTR_CONT'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'INT_REPAY_PED_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
  and P1.opt_type = 'IN'
  and P1.biz_type <> '201020100057' -- 过滤房抵贷数据
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_myloan_tran_distr_cont_mybkf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_myloan_tran_distr_cont_mybkf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,distr_cap_flow_num -- 放款资金流水号
    ,prod_code -- 产品码
    ,brwer_name -- 借款人名称
    ,brwer_cert_type_cd -- 借款人证件类型代码
    ,brwer_cert_no -- 借款人证件号码
    ,loan_status_cd -- 贷款状态代码
    ,loan_usage_cd -- 贷款用途代码
    ,loan_cap_dom_overs_flg -- 贷款资金境内外标志
    ,appl_disb_tm -- 申请支用时间
    ,distr_dt -- 放款日期
    ,curr_cd -- 币种代码
    ,distr_amt -- 放款金额
    ,loan_value_dt -- 贷款起息日期
    ,loan_exp_dt -- 贷款到期日期
    ,loan_tenor -- 贷款期限
    ,repay_way_cd -- 还款方式代码
    ,grace_period_days -- 宽限期天数
    ,int_rat_type_cd -- 利率类型代码
    ,loan_day_int_rat -- 贷款日利率
    ,pric_repay_ped_type_cd -- 本金还款周期类型代码
    ,int_repay_ped_type_cd -- 利息还款周期类型代码
    ,guar_type_cd -- 担保类型代码
    ,crdt_id -- 授信编号
    ,recvbl_num_type_cd -- 收款账号类型代码
    ,recvbl_house_hold_name -- 收款账号户主名称
    ,recvbl_num -- 收款账号
    ,recvbl_bank_name -- 收款银行名称
    ,repay_num_type_cd -- 还款账号类型代码
    ,repay_house_hold_name -- 还款账号户主名称
    ,repay_num -- 还款账号
    ,repay_bank_name -- 还款银行名称
    ,user_id -- 用户编号
    ,dist_cd -- 行政区划代码
    ,loan_year_int_rat -- 贷款年利率
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.distr_cap_flow_num, o.distr_cap_flow_num) as distr_cap_flow_num -- 放款资金流水号
    ,nvl(n.prod_code, o.prod_code) as prod_code -- 产品码
    ,nvl(n.brwer_name, o.brwer_name) as brwer_name -- 借款人名称
    ,nvl(n.brwer_cert_type_cd, o.brwer_cert_type_cd) as brwer_cert_type_cd -- 借款人证件类型代码
    ,nvl(n.brwer_cert_no, o.brwer_cert_no) as brwer_cert_no -- 借款人证件号码
    ,nvl(n.loan_status_cd, o.loan_status_cd) as loan_status_cd -- 贷款状态代码
    ,nvl(n.loan_usage_cd, o.loan_usage_cd) as loan_usage_cd -- 贷款用途代码
    ,nvl(n.loan_cap_dom_overs_flg, o.loan_cap_dom_overs_flg) as loan_cap_dom_overs_flg -- 贷款资金境内外标志
    ,nvl(n.appl_disb_tm, o.appl_disb_tm) as appl_disb_tm -- 申请支用时间
    ,nvl(n.distr_dt, o.distr_dt) as distr_dt -- 放款日期
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.distr_amt, o.distr_amt) as distr_amt -- 放款金额
    ,nvl(n.loan_value_dt, o.loan_value_dt) as loan_value_dt -- 贷款起息日期
    ,nvl(n.loan_exp_dt, o.loan_exp_dt) as loan_exp_dt -- 贷款到期日期
    ,nvl(n.loan_tenor, o.loan_tenor) as loan_tenor -- 贷款期限
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.grace_period_days, o.grace_period_days) as grace_period_days -- 宽限期天数
    ,nvl(n.int_rat_type_cd, o.int_rat_type_cd) as int_rat_type_cd -- 利率类型代码
    ,nvl(n.loan_day_int_rat, o.loan_day_int_rat) as loan_day_int_rat -- 贷款日利率
    ,nvl(n.pric_repay_ped_type_cd, o.pric_repay_ped_type_cd) as pric_repay_ped_type_cd -- 本金还款周期类型代码
    ,nvl(n.int_repay_ped_type_cd, o.int_repay_ped_type_cd) as int_repay_ped_type_cd -- 利息还款周期类型代码
    ,nvl(n.guar_type_cd, o.guar_type_cd) as guar_type_cd -- 担保类型代码
    ,nvl(n.crdt_id, o.crdt_id) as crdt_id -- 授信编号
    ,nvl(n.recvbl_num_type_cd, o.recvbl_num_type_cd) as recvbl_num_type_cd -- 收款账号类型代码
    ,nvl(n.recvbl_house_hold_name, o.recvbl_house_hold_name) as recvbl_house_hold_name -- 收款账号户主名称
    ,nvl(n.recvbl_num, o.recvbl_num) as recvbl_num -- 收款账号
    ,nvl(n.recvbl_bank_name, o.recvbl_bank_name) as recvbl_bank_name -- 收款银行名称
    ,nvl(n.repay_num_type_cd, o.repay_num_type_cd) as repay_num_type_cd -- 还款账号类型代码
    ,nvl(n.repay_house_hold_name, o.repay_house_hold_name) as repay_house_hold_name -- 还款账号户主名称
    ,nvl(n.repay_num, o.repay_num) as repay_num -- 还款账号
    ,nvl(n.repay_bank_name, o.repay_bank_name) as repay_bank_name -- 还款银行名称
    ,nvl(n.user_id, o.user_id) as user_id -- 用户编号
    ,nvl(n.dist_cd, o.dist_cd) as dist_cd -- 行政区划代码
    ,nvl(n.loan_year_int_rat, o.loan_year_int_rat) as loan_year_int_rat -- 贷款年利率
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.cont_id <> n.cont_id
                or o.distr_cap_flow_num <> n.distr_cap_flow_num
                or o.prod_code <> n.prod_code
                or o.brwer_name <> n.brwer_name
                or o.brwer_cert_type_cd <> n.brwer_cert_type_cd
                or o.brwer_cert_no <> n.brwer_cert_no
                or o.loan_status_cd <> n.loan_status_cd
                or o.loan_usage_cd <> n.loan_usage_cd
                or o.loan_cap_dom_overs_flg <> n.loan_cap_dom_overs_flg
                or o.appl_disb_tm <> n.appl_disb_tm
                or o.distr_dt <> n.distr_dt
                or o.curr_cd <> n.curr_cd
                or o.distr_amt <> n.distr_amt
                or o.loan_value_dt <> n.loan_value_dt
                or o.loan_exp_dt <> n.loan_exp_dt
                or o.loan_tenor <> n.loan_tenor
                or o.repay_way_cd <> n.repay_way_cd
                or o.grace_period_days <> n.grace_period_days
                or o.int_rat_type_cd <> n.int_rat_type_cd
                or o.loan_day_int_rat <> n.loan_day_int_rat
                or o.pric_repay_ped_type_cd <> n.pric_repay_ped_type_cd
                or o.int_repay_ped_type_cd <> n.int_repay_ped_type_cd
                or o.guar_type_cd <> n.guar_type_cd
                or o.crdt_id <> n.crdt_id
                or o.recvbl_num_type_cd <> n.recvbl_num_type_cd
                or o.recvbl_house_hold_name <> n.recvbl_house_hold_name
                or o.recvbl_num <> n.recvbl_num
                or o.recvbl_bank_name <> n.recvbl_bank_name
                or o.repay_num_type_cd <> n.repay_num_type_cd
                or o.repay_house_hold_name <> n.repay_house_hold_name
                or o.repay_num <> n.repay_num
                or o.repay_bank_name <> n.repay_bank_name
                or o.user_id <> n.user_id
                or o.dist_cd <> n.dist_cd
                or o.loan_year_int_rat <> n.loan_year_int_rat
            ) or (
                 case when (
                           n.agt_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.agt_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_myloan_tran_distr_cont_mybkf1_tm n
    full join ${iml_schema}.agt_myloan_tran_distr_cont_mybkf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_myloan_tran_distr_cont truncate partition for ('mybkf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_myloan_tran_distr_cont exchange subpartition p_mybkf1_${batch_date} with table ${iml_schema}.agt_myloan_tran_distr_cont_mybkf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_myloan_tran_distr_cont drop subpartition p_mybkf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_myloan_tran_distr_cont to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_myloan_tran_distr_cont_mybkf1_tm purge;
drop table ${iml_schema}.agt_myloan_tran_distr_cont_mybkf1_ex purge;
drop table ${iml_schema}.agt_myloan_tran_distr_cont_mybkf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_myloan_tran_distr_cont', partname => 'p_mybkf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);