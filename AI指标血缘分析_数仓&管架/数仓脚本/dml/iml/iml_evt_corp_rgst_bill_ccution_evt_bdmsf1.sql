/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_corp_rgst_bill_ccution_evt_bdmsf1
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
alter table ${iml_schema}.evt_corp_rgst_bill_ccution_evt add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_bdmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_corp_rgst_bill_ccution_evt_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_corp_rgst_bill_ccution_evt partition for ('bdmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_corp_rgst_bill_ccution_evt_bdmsf1_tm purge;
drop table ${iml_schema}.evt_corp_rgst_bill_ccution_evt_bdmsf1_op purge;
drop table ${iml_schema}.evt_corp_rgst_bill_ccution_evt_bdmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_corp_rgst_bill_ccution_evt_bdmsf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rgst_id -- 登记编号
    ,bill_id -- 票据编号
    ,recv_id -- 签收编号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,bus_type_cd -- 业务类型代码
    ,bus_attr_cd -- 业务属性代码
    ,bus_dir_cd -- 业务方向代码
    ,bill_src_cd -- 票据来源代码
    ,bill_num -- 票据号码
    ,bill_sub_intrv_id -- 票据子区间编号
    ,bill_amt -- 票据金额
    ,tran_dt -- 交易日期
    ,reqer_type_cd -- 请求方类型代码
    ,reqer_name -- 请求方名称
    ,reqer_soci_crdt_cd -- 请求方社会信用代码
    ,reqer_acct_type_cd -- 请求方账户类型代码
    ,reqer_acct_id -- 请求方账户编号
    ,reqer_acct_name -- 请求方账户名称
    ,reqer_open_bank_no -- 请求方开户行行号
    ,reqer_mem_cd -- 请求方会员代码
    ,reqer_org_cd -- 请求方机构代码
    ,recver_type_cd -- 接收方类型代码
    ,recver_name -- 接收方名称
    ,recver_soci_crdt_cd -- 接收方社会信用代码
    ,recver_acct_type_cd -- 接收方账户类型代码
    ,recver_acct_id -- 接收方账户编号
    ,recver_acct_name -- 接收方账户名称
    ,recver_open_bank_no -- 接收方开户行行号
    ,recver_mem_cd -- 接收方会员代码
    ,recver_org_cd -- 接收方机构代码
    ,discnt_int_rat -- 贴现利率
    ,discnt_actl_amt -- 贴现实付金额
    ,not_ngbl_cd -- 不得转让代码
    ,onl_clear_flg -- 线上清算标志
    ,enter_id -- 入账账户编号
    ,enter_acct_bank_no -- 入账行号
    ,reply_idf_cd -- 应答标识代码
    ,recv_dt -- 签收日期
    ,refuse_pay_cd -- 拒付代码
    ,refuse_pay_remark_info -- 拒付备注信息
    ,recs_type_cd -- 追偿类型代码
    ,actl_int -- 实付利息
    ,int_accr_exp_dt -- 计息到期日期
    ,int_payer_name -- 付息人名称
    ,int_payer_acct_id -- 付息人账户编号
    ,int_payer_open_bank_name -- 付息人开户行名称
    ,comm_fee -- 手续费
    ,todos -- 工本费
    ,pay_int_ratio -- 付息比例
    ,buyer_pay_int_int -- 买方付息利息
    ,tot_int -- 总利息
    ,stop_pay_type_cd -- 止付类型代码
    ,stop_pay_rs_descb -- 止付原因描述
    ,remit_stop_pay_type_cd -- 解除止付类型代码
    ,remit_stop_pay_rs_descb -- 解除止付原因描述
    ,surp_tenor -- 剩余期限
    ,stl_amt -- 结算金额
    ,stl_rest_cd -- 结算结果代码
    ,stl_dt -- 结算日期
    ,payoff_type_cd -- 结清类型代码
    ,tran_status_cd -- 交易状态代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_corp_rgst_bill_ccution_evt partition for ('bdmsf1')
where 0=1
;

create table ${iml_schema}.evt_corp_rgst_bill_ccution_evt_bdmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_corp_rgst_bill_ccution_evt partition for ('bdmsf1') where 0=1;

create table ${iml_schema}.evt_corp_rgst_bill_ccution_evt_bdmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_corp_rgst_bill_ccution_evt partition for ('bdmsf1') where 0=1;

-- 3.1 get new data into table
-- bdms_cust_dpc_draft_trans_info-
insert into ${iml_schema}.evt_corp_rgst_bill_ccution_evt_bdmsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rgst_id -- 登记编号
    ,bill_id -- 票据编号
    ,recv_id -- 签收编号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,bus_type_cd -- 业务类型代码
    ,bus_attr_cd -- 业务属性代码
    ,bus_dir_cd -- 业务方向代码
    ,bill_src_cd -- 票据来源代码
    ,bill_num -- 票据号码
    ,bill_sub_intrv_id -- 票据子区间编号
    ,bill_amt -- 票据金额
    ,tran_dt -- 交易日期
    ,reqer_type_cd -- 请求方类型代码
    ,reqer_name -- 请求方名称
    ,reqer_soci_crdt_cd -- 请求方社会信用代码
    ,reqer_acct_type_cd -- 请求方账户类型代码
    ,reqer_acct_id -- 请求方账户编号
    ,reqer_acct_name -- 请求方账户名称
    ,reqer_open_bank_no -- 请求方开户行行号
    ,reqer_mem_cd -- 请求方会员代码
    ,reqer_org_cd -- 请求方机构代码
    ,recver_type_cd -- 接收方类型代码
    ,recver_name -- 接收方名称
    ,recver_soci_crdt_cd -- 接收方社会信用代码
    ,recver_acct_type_cd -- 接收方账户类型代码
    ,recver_acct_id -- 接收方账户编号
    ,recver_acct_name -- 接收方账户名称
    ,recver_open_bank_no -- 接收方开户行行号
    ,recver_mem_cd -- 接收方会员代码
    ,recver_org_cd -- 接收方机构代码
    ,discnt_int_rat -- 贴现利率
    ,discnt_actl_amt -- 贴现实付金额
    ,not_ngbl_cd -- 不得转让代码
    ,onl_clear_flg -- 线上清算标志
    ,enter_id -- 入账账户编号
    ,enter_acct_bank_no -- 入账行号
    ,reply_idf_cd -- 应答标识代码
    ,recv_dt -- 签收日期
    ,refuse_pay_cd -- 拒付代码
    ,refuse_pay_remark_info -- 拒付备注信息
    ,recs_type_cd -- 追偿类型代码
    ,actl_int -- 实付利息
    ,int_accr_exp_dt -- 计息到期日期
    ,int_payer_name -- 付息人名称
    ,int_payer_acct_id -- 付息人账户编号
    ,int_payer_open_bank_name -- 付息人开户行名称
    ,comm_fee -- 手续费
    ,todos -- 工本费
    ,pay_int_ratio -- 付息比例
    ,buyer_pay_int_int -- 买方付息利息
    ,tot_int -- 总利息
    ,stop_pay_type_cd -- 止付类型代码
    ,stop_pay_rs_descb -- 止付原因描述
    ,remit_stop_pay_type_cd -- 解除止付类型代码
    ,remit_stop_pay_rs_descb -- 解除止付原因描述
    ,surp_tenor -- 剩余期限
    ,stl_amt -- 结算金额
    ,stl_rest_cd -- 结算结果代码
    ,stl_dt -- 结算日期
    ,payoff_type_cd -- 结清类型代码
    ,tran_status_cd -- 交易状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '105012'||P1.ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.ID -- 登记编号
    ,P1.DRAFT_ID -- 票据编号
    ,P1.APPLY_ID -- 签收编号
    ,P1.PRODUCT_NO -- 产品编号
    ,P1.PRODUCT_NAME -- 产品名称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.DRAFT_ATTR END -- 票据介质代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.DRAFT_TYPE END -- 票据类型代码
    ,NVL(TRIM(P1.BUSI_TYPE),'-') -- 业务类型代码
    ,P1.BUSI_ATTR_NO -- 业务属性代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.BUSS_FLAG END -- 业务方向代码
    ,NVL(TRIM(P1.PRODUCT_TYPE),'-') -- 票据来源代码
    ,P1.DRAFT_NUMBER -- 票据号码
    ,P1.CD_RANGE -- 票据子区间编号
    ,P1.DRAFT_AMOUNT -- 票据金额
    ,${iml_schema}.DATEFORMAT_MIN(P1.TXN_DATE) -- 交易日期
    ,NVL(TRIM(P1.REQ_BUSS_TYPE),'-') -- 请求方类型代码
    ,P1.REQ_NAME -- 请求方名称
    ,P1.REQ_CERT_NO -- 请求方社会信用代码
    ,NVL(TRIM(P1.REQ_DIST_TP),'-') -- 请求方账户类型代码
    ,P1.REQ_ACCOUNT -- 请求方账户编号
    ,P1.REQ_ACCOUNT_NAME -- 请求方账户名称
    ,P1.REQ_BANK_NO -- 请求方开户行行号
    ,P1.REQ_MEM_NO -- 请求方会员代码
    ,P1.REQ_BRH_NO -- 请求方机构代码
    ,NVL(TRIM(P1.RCV_BUSS_TYPE),'-') -- 接收方类型代码
    ,P1.RCV_NAME -- 接收方名称
    ,P1.RCV_CERT_NO -- 接收方社会信用代码
    ,NVL(TRIM(P1.RCV_DIST_TP),'-') -- 接收方账户类型代码
    ,P1.RCV_ACCOUNT -- 接收方账户编号
    ,P1.RCV_ACCOUNT_NAME -- 接收方账户名称
    ,P1.RCV_BANK_NO -- 接收方开户行行号
    ,P1.RCV_MEM_NO -- 接收方会员代码
    ,P1.RCV_BRH_NO -- 接收方机构代码
    ,P1.RATE -- 贴现利率
    ,P1.PAY_AMOUNT -- 贴现实付金额
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.TRANSFER_FLAG END -- 不得转让代码
    ,P1.STTLM_MK -- 线上清算标志
    ,P1.AOA_ACCOUNT -- 入账账户编号
    ,P1.AOA_BANK_NO -- 入账行号
    ,NVL(TRIM(P1.SIGN_MK),'-') -- 应答标识代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.SIGN_DATE) -- 签收日期
    ,NVL(TRIM(P1.REFUSE_REASON_CODE),'-') -- 拒付代码
    ,P1.REFUSE_REMARK -- 拒付备注信息
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.RECOVERY_TYPE END -- 追偿类型代码
    ,P1.PAY_INTEREST -- 实付利息
    ,${iml_schema}.DATEFORMAT_MAX2(P1.PAYMENT_DATE) -- 计息到期日期
    ,P1.INTEREST_PAYER_NAME -- 付息人名称
    ,P1.INTEREST_PAYER_ACCOUNT -- 付息人账户编号
    ,P1.INTEREST_PAYER_BANK_NAME -- 付息人开户行名称
    ,P1.CHARGE -- 手续费
    ,P1.EXPENSES -- 工本费
    ,P1.PAYER_SALE -- 付息比例
    ,P1.BUYER_INTEREST -- 买方付息利息
    ,P1.INTEREST -- 总利息
    ,NVL(TRIM(P1.STOP_PAY_TYPE),'-') -- 止付类型代码
    ,P1.STOP_PAY_RSN -- 止付原因描述
    ,NVL(TRIM(P1.RELIEVE_STP_TYPE),'-') -- 解除止付类型代码
    ,P1.RELIEVE_STP_RSN -- 解除止付原因描述
    ,P1.TENOR_DAYS -- 剩余期限
    ,P1.SETTLE_AMT -- 结算金额
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.SETTLE_RESULT END -- 结算结果代码
    ,${iml_schema}.DATEFORMAT_MAX2(P1.SETTLE_DATE) -- 结算日期
    ,NVL(TRIM(P1.SETTLE_TYPE),'-') -- 结清类型代码
    ,NVL(TRIM(P1.TRANS_STATUS),'-') -- 交易状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_cust_dpc_draft_trans_info' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_cust_dpc_draft_trans_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.DRAFT_ATTR = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_CUST_DPC_DRAFT_TRANS_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'DRAFT_ATTR'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_CORP_RGST_BILL_CCUTION_EVT'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'BILL_MED_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.DRAFT_TYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_CUST_DPC_DRAFT_TRANS_INFO'
        AND R2.SRC_FIELD_EN_NAME= 'DRAFT_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_CORP_RGST_BILL_CCUTION_EVT'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'BILL_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.BUSS_FLAG = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'BDMS'
        AND R3.SRC_TAB_EN_NAME= 'BDMS_CUST_DPC_DRAFT_TRANS_INFO'
        AND R3.SRC_FIELD_EN_NAME= 'BUSS_FLAG'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_CORP_RGST_BILL_CCUTION_EVT'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'BUS_DIR_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.TRANSFER_FLAG = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'BDMS'
        AND R4.SRC_TAB_EN_NAME= 'BDMS_CUST_DPC_DRAFT_TRANS_INFO'
        AND R4.SRC_FIELD_EN_NAME= 'TRANSFER_FLAG'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_CORP_RGST_BILL_CCUTION_EVT'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'NOT_NGBL_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.RECOVERY_TYPE = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'BDMS'
        AND R5.SRC_TAB_EN_NAME= 'BDMS_CUST_DPC_DRAFT_TRANS_INFO'
        AND R5.SRC_FIELD_EN_NAME= 'RECOVERY_TYPE'
        AND R5.TARGET_TAB_EN_NAME= 'EVT_CORP_RGST_BILL_CCUTION_EVT'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'RECS_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.SETTLE_RESULT = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'BDMS'
        AND R6.SRC_TAB_EN_NAME= 'BDMS_CUST_DPC_DRAFT_TRANS_INFO'
        AND R6.SRC_FIELD_EN_NAME= 'SETTLE_RESULT'
        AND R6.TARGET_TAB_EN_NAME= 'EVT_CORP_RGST_BILL_CCUTION_EVT'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'STL_REST_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_corp_rgst_bill_ccution_evt_bdmsf1_tm 
  	                                group by 
  	                                        evt_id
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_corp_rgst_bill_ccution_evt_bdmsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rgst_id -- 登记编号
    ,bill_id -- 票据编号
    ,recv_id -- 签收编号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,bus_type_cd -- 业务类型代码
    ,bus_attr_cd -- 业务属性代码
    ,bus_dir_cd -- 业务方向代码
    ,bill_src_cd -- 票据来源代码
    ,bill_num -- 票据号码
    ,bill_sub_intrv_id -- 票据子区间编号
    ,bill_amt -- 票据金额
    ,tran_dt -- 交易日期
    ,reqer_type_cd -- 请求方类型代码
    ,reqer_name -- 请求方名称
    ,reqer_soci_crdt_cd -- 请求方社会信用代码
    ,reqer_acct_type_cd -- 请求方账户类型代码
    ,reqer_acct_id -- 请求方账户编号
    ,reqer_acct_name -- 请求方账户名称
    ,reqer_open_bank_no -- 请求方开户行行号
    ,reqer_mem_cd -- 请求方会员代码
    ,reqer_org_cd -- 请求方机构代码
    ,recver_type_cd -- 接收方类型代码
    ,recver_name -- 接收方名称
    ,recver_soci_crdt_cd -- 接收方社会信用代码
    ,recver_acct_type_cd -- 接收方账户类型代码
    ,recver_acct_id -- 接收方账户编号
    ,recver_acct_name -- 接收方账户名称
    ,recver_open_bank_no -- 接收方开户行行号
    ,recver_mem_cd -- 接收方会员代码
    ,recver_org_cd -- 接收方机构代码
    ,discnt_int_rat -- 贴现利率
    ,discnt_actl_amt -- 贴现实付金额
    ,not_ngbl_cd -- 不得转让代码
    ,onl_clear_flg -- 线上清算标志
    ,enter_id -- 入账账户编号
    ,enter_acct_bank_no -- 入账行号
    ,reply_idf_cd -- 应答标识代码
    ,recv_dt -- 签收日期
    ,refuse_pay_cd -- 拒付代码
    ,refuse_pay_remark_info -- 拒付备注信息
    ,recs_type_cd -- 追偿类型代码
    ,actl_int -- 实付利息
    ,int_accr_exp_dt -- 计息到期日期
    ,int_payer_name -- 付息人名称
    ,int_payer_acct_id -- 付息人账户编号
    ,int_payer_open_bank_name -- 付息人开户行名称
    ,comm_fee -- 手续费
    ,todos -- 工本费
    ,pay_int_ratio -- 付息比例
    ,buyer_pay_int_int -- 买方付息利息
    ,tot_int -- 总利息
    ,stop_pay_type_cd -- 止付类型代码
    ,stop_pay_rs_descb -- 止付原因描述
    ,remit_stop_pay_type_cd -- 解除止付类型代码
    ,remit_stop_pay_rs_descb -- 解除止付原因描述
    ,surp_tenor -- 剩余期限
    ,stl_amt -- 结算金额
    ,stl_rest_cd -- 结算结果代码
    ,stl_dt -- 结算日期
    ,payoff_type_cd -- 结清类型代码
    ,tran_status_cd -- 交易状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_corp_rgst_bill_ccution_evt_bdmsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rgst_id -- 登记编号
    ,bill_id -- 票据编号
    ,recv_id -- 签收编号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,bus_type_cd -- 业务类型代码
    ,bus_attr_cd -- 业务属性代码
    ,bus_dir_cd -- 业务方向代码
    ,bill_src_cd -- 票据来源代码
    ,bill_num -- 票据号码
    ,bill_sub_intrv_id -- 票据子区间编号
    ,bill_amt -- 票据金额
    ,tran_dt -- 交易日期
    ,reqer_type_cd -- 请求方类型代码
    ,reqer_name -- 请求方名称
    ,reqer_soci_crdt_cd -- 请求方社会信用代码
    ,reqer_acct_type_cd -- 请求方账户类型代码
    ,reqer_acct_id -- 请求方账户编号
    ,reqer_acct_name -- 请求方账户名称
    ,reqer_open_bank_no -- 请求方开户行行号
    ,reqer_mem_cd -- 请求方会员代码
    ,reqer_org_cd -- 请求方机构代码
    ,recver_type_cd -- 接收方类型代码
    ,recver_name -- 接收方名称
    ,recver_soci_crdt_cd -- 接收方社会信用代码
    ,recver_acct_type_cd -- 接收方账户类型代码
    ,recver_acct_id -- 接收方账户编号
    ,recver_acct_name -- 接收方账户名称
    ,recver_open_bank_no -- 接收方开户行行号
    ,recver_mem_cd -- 接收方会员代码
    ,recver_org_cd -- 接收方机构代码
    ,discnt_int_rat -- 贴现利率
    ,discnt_actl_amt -- 贴现实付金额
    ,not_ngbl_cd -- 不得转让代码
    ,onl_clear_flg -- 线上清算标志
    ,enter_id -- 入账账户编号
    ,enter_acct_bank_no -- 入账行号
    ,reply_idf_cd -- 应答标识代码
    ,recv_dt -- 签收日期
    ,refuse_pay_cd -- 拒付代码
    ,refuse_pay_remark_info -- 拒付备注信息
    ,recs_type_cd -- 追偿类型代码
    ,actl_int -- 实付利息
    ,int_accr_exp_dt -- 计息到期日期
    ,int_payer_name -- 付息人名称
    ,int_payer_acct_id -- 付息人账户编号
    ,int_payer_open_bank_name -- 付息人开户行名称
    ,comm_fee -- 手续费
    ,todos -- 工本费
    ,pay_int_ratio -- 付息比例
    ,buyer_pay_int_int -- 买方付息利息
    ,tot_int -- 总利息
    ,stop_pay_type_cd -- 止付类型代码
    ,stop_pay_rs_descb -- 止付原因描述
    ,remit_stop_pay_type_cd -- 解除止付类型代码
    ,remit_stop_pay_rs_descb -- 解除止付原因描述
    ,surp_tenor -- 剩余期限
    ,stl_amt -- 结算金额
    ,stl_rest_cd -- 结算结果代码
    ,stl_dt -- 结算日期
    ,payoff_type_cd -- 结清类型代码
    ,tran_status_cd -- 交易状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.evt_id, o.evt_id) as evt_id -- 事件编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.rgst_id, o.rgst_id) as rgst_id -- 登记编号
    ,nvl(n.bill_id, o.bill_id) as bill_id -- 票据编号
    ,nvl(n.recv_id, o.recv_id) as recv_id -- 签收编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.bill_med_cd, o.bill_med_cd) as bill_med_cd -- 票据介质代码
    ,nvl(n.bill_type_cd, o.bill_type_cd) as bill_type_cd -- 票据类型代码
    ,nvl(n.bus_type_cd, o.bus_type_cd) as bus_type_cd -- 业务类型代码
    ,nvl(n.bus_attr_cd, o.bus_attr_cd) as bus_attr_cd -- 业务属性代码
    ,nvl(n.bus_dir_cd, o.bus_dir_cd) as bus_dir_cd -- 业务方向代码
    ,nvl(n.bill_src_cd, o.bill_src_cd) as bill_src_cd -- 票据来源代码
    ,nvl(n.bill_num, o.bill_num) as bill_num -- 票据号码
    ,nvl(n.bill_sub_intrv_id, o.bill_sub_intrv_id) as bill_sub_intrv_id -- 票据子区间编号
    ,nvl(n.bill_amt, o.bill_amt) as bill_amt -- 票据金额
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.reqer_type_cd, o.reqer_type_cd) as reqer_type_cd -- 请求方类型代码
    ,nvl(n.reqer_name, o.reqer_name) as reqer_name -- 请求方名称
    ,nvl(n.reqer_soci_crdt_cd, o.reqer_soci_crdt_cd) as reqer_soci_crdt_cd -- 请求方社会信用代码
    ,nvl(n.reqer_acct_type_cd, o.reqer_acct_type_cd) as reqer_acct_type_cd -- 请求方账户类型代码
    ,nvl(n.reqer_acct_id, o.reqer_acct_id) as reqer_acct_id -- 请求方账户编号
    ,nvl(n.reqer_acct_name, o.reqer_acct_name) as reqer_acct_name -- 请求方账户名称
    ,nvl(n.reqer_open_bank_no, o.reqer_open_bank_no) as reqer_open_bank_no -- 请求方开户行行号
    ,nvl(n.reqer_mem_cd, o.reqer_mem_cd) as reqer_mem_cd -- 请求方会员代码
    ,nvl(n.reqer_org_cd, o.reqer_org_cd) as reqer_org_cd -- 请求方机构代码
    ,nvl(n.recver_type_cd, o.recver_type_cd) as recver_type_cd -- 接收方类型代码
    ,nvl(n.recver_name, o.recver_name) as recver_name -- 接收方名称
    ,nvl(n.recver_soci_crdt_cd, o.recver_soci_crdt_cd) as recver_soci_crdt_cd -- 接收方社会信用代码
    ,nvl(n.recver_acct_type_cd, o.recver_acct_type_cd) as recver_acct_type_cd -- 接收方账户类型代码
    ,nvl(n.recver_acct_id, o.recver_acct_id) as recver_acct_id -- 接收方账户编号
    ,nvl(n.recver_acct_name, o.recver_acct_name) as recver_acct_name -- 接收方账户名称
    ,nvl(n.recver_open_bank_no, o.recver_open_bank_no) as recver_open_bank_no -- 接收方开户行行号
    ,nvl(n.recver_mem_cd, o.recver_mem_cd) as recver_mem_cd -- 接收方会员代码
    ,nvl(n.recver_org_cd, o.recver_org_cd) as recver_org_cd -- 接收方机构代码
    ,nvl(n.discnt_int_rat, o.discnt_int_rat) as discnt_int_rat -- 贴现利率
    ,nvl(n.discnt_actl_amt, o.discnt_actl_amt) as discnt_actl_amt -- 贴现实付金额
    ,nvl(n.not_ngbl_cd, o.not_ngbl_cd) as not_ngbl_cd -- 不得转让代码
    ,nvl(n.onl_clear_flg, o.onl_clear_flg) as onl_clear_flg -- 线上清算标志
    ,nvl(n.enter_id, o.enter_id) as enter_id -- 入账账户编号
    ,nvl(n.enter_acct_bank_no, o.enter_acct_bank_no) as enter_acct_bank_no -- 入账行号
    ,nvl(n.reply_idf_cd, o.reply_idf_cd) as reply_idf_cd -- 应答标识代码
    ,nvl(n.recv_dt, o.recv_dt) as recv_dt -- 签收日期
    ,nvl(n.refuse_pay_cd, o.refuse_pay_cd) as refuse_pay_cd -- 拒付代码
    ,nvl(n.refuse_pay_remark_info, o.refuse_pay_remark_info) as refuse_pay_remark_info -- 拒付备注信息
    ,nvl(n.recs_type_cd, o.recs_type_cd) as recs_type_cd -- 追偿类型代码
    ,nvl(n.actl_int, o.actl_int) as actl_int -- 实付利息
    ,nvl(n.int_accr_exp_dt, o.int_accr_exp_dt) as int_accr_exp_dt -- 计息到期日期
    ,nvl(n.int_payer_name, o.int_payer_name) as int_payer_name -- 付息人名称
    ,nvl(n.int_payer_acct_id, o.int_payer_acct_id) as int_payer_acct_id -- 付息人账户编号
    ,nvl(n.int_payer_open_bank_name, o.int_payer_open_bank_name) as int_payer_open_bank_name -- 付息人开户行名称
    ,nvl(n.comm_fee, o.comm_fee) as comm_fee -- 手续费
    ,nvl(n.todos, o.todos) as todos -- 工本费
    ,nvl(n.pay_int_ratio, o.pay_int_ratio) as pay_int_ratio -- 付息比例
    ,nvl(n.buyer_pay_int_int, o.buyer_pay_int_int) as buyer_pay_int_int -- 买方付息利息
    ,nvl(n.tot_int, o.tot_int) as tot_int -- 总利息
    ,nvl(n.stop_pay_type_cd, o.stop_pay_type_cd) as stop_pay_type_cd -- 止付类型代码
    ,nvl(n.stop_pay_rs_descb, o.stop_pay_rs_descb) as stop_pay_rs_descb -- 止付原因描述
    ,nvl(n.remit_stop_pay_type_cd, o.remit_stop_pay_type_cd) as remit_stop_pay_type_cd -- 解除止付类型代码
    ,nvl(n.remit_stop_pay_rs_descb, o.remit_stop_pay_rs_descb) as remit_stop_pay_rs_descb -- 解除止付原因描述
    ,nvl(n.surp_tenor, o.surp_tenor) as surp_tenor -- 剩余期限
    ,nvl(n.stl_amt, o.stl_amt) as stl_amt -- 结算金额
    ,nvl(n.stl_rest_cd, o.stl_rest_cd) as stl_rest_cd -- 结算结果代码
    ,nvl(n.stl_dt, o.stl_dt) as stl_dt -- 结算日期
    ,nvl(n.payoff_type_cd, o.payoff_type_cd) as payoff_type_cd -- 结清类型代码
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_corp_rgst_bill_ccution_evt_bdmsf1_tm n
    full join (select * from ${iml_schema}.evt_corp_rgst_bill_ccution_evt_bdmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
where (
        o.evt_id is null
        and o.lp_id is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
    )
    or (
        o.rgst_id <> n.rgst_id
        or o.bill_id <> n.bill_id
        or o.recv_id <> n.recv_id
        or o.prod_id <> n.prod_id
        or o.prod_name <> n.prod_name
        or o.bill_med_cd <> n.bill_med_cd
        or o.bill_type_cd <> n.bill_type_cd
        or o.bus_type_cd <> n.bus_type_cd
        or o.bus_attr_cd <> n.bus_attr_cd
        or o.bus_dir_cd <> n.bus_dir_cd
        or o.bill_src_cd <> n.bill_src_cd
        or o.bill_num <> n.bill_num
        or o.bill_sub_intrv_id <> n.bill_sub_intrv_id
        or o.bill_amt <> n.bill_amt
        or o.tran_dt <> n.tran_dt
        or o.reqer_type_cd <> n.reqer_type_cd
        or o.reqer_name <> n.reqer_name
        or o.reqer_soci_crdt_cd <> n.reqer_soci_crdt_cd
        or o.reqer_acct_type_cd <> n.reqer_acct_type_cd
        or o.reqer_acct_id <> n.reqer_acct_id
        or o.reqer_acct_name <> n.reqer_acct_name
        or o.reqer_open_bank_no <> n.reqer_open_bank_no
        or o.reqer_mem_cd <> n.reqer_mem_cd
        or o.reqer_org_cd <> n.reqer_org_cd
        or o.recver_type_cd <> n.recver_type_cd
        or o.recver_name <> n.recver_name
        or o.recver_soci_crdt_cd <> n.recver_soci_crdt_cd
        or o.recver_acct_type_cd <> n.recver_acct_type_cd
        or o.recver_acct_id <> n.recver_acct_id
        or o.recver_acct_name <> n.recver_acct_name
        or o.recver_open_bank_no <> n.recver_open_bank_no
        or o.recver_mem_cd <> n.recver_mem_cd
        or o.recver_org_cd <> n.recver_org_cd
        or o.discnt_int_rat <> n.discnt_int_rat
        or o.discnt_actl_amt <> n.discnt_actl_amt
        or o.not_ngbl_cd <> n.not_ngbl_cd
        or o.onl_clear_flg <> n.onl_clear_flg
        or o.enter_id <> n.enter_id
        or o.enter_acct_bank_no <> n.enter_acct_bank_no
        or o.reply_idf_cd <> n.reply_idf_cd
        or o.recv_dt <> n.recv_dt
        or o.refuse_pay_cd <> n.refuse_pay_cd
        or o.refuse_pay_remark_info <> n.refuse_pay_remark_info
        or o.recs_type_cd <> n.recs_type_cd
        or o.actl_int <> n.actl_int
        or o.int_accr_exp_dt <> n.int_accr_exp_dt
        or o.int_payer_name <> n.int_payer_name
        or o.int_payer_acct_id <> n.int_payer_acct_id
        or o.int_payer_open_bank_name <> n.int_payer_open_bank_name
        or o.comm_fee <> n.comm_fee
        or o.todos <> n.todos
        or o.pay_int_ratio <> n.pay_int_ratio
        or o.buyer_pay_int_int <> n.buyer_pay_int_int
        or o.tot_int <> n.tot_int
        or o.stop_pay_type_cd <> n.stop_pay_type_cd
        or o.stop_pay_rs_descb <> n.stop_pay_rs_descb
        or o.remit_stop_pay_type_cd <> n.remit_stop_pay_type_cd
        or o.remit_stop_pay_rs_descb <> n.remit_stop_pay_rs_descb
        or o.surp_tenor <> n.surp_tenor
        or o.stl_amt <> n.stl_amt
        or o.stl_rest_cd <> n.stl_rest_cd
        or o.stl_dt <> n.stl_dt
        or o.payoff_type_cd <> n.payoff_type_cd
        or o.tran_status_cd <> n.tran_status_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_corp_rgst_bill_ccution_evt_bdmsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rgst_id -- 登记编号
    ,bill_id -- 票据编号
    ,recv_id -- 签收编号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,bus_type_cd -- 业务类型代码
    ,bus_attr_cd -- 业务属性代码
    ,bus_dir_cd -- 业务方向代码
    ,bill_src_cd -- 票据来源代码
    ,bill_num -- 票据号码
    ,bill_sub_intrv_id -- 票据子区间编号
    ,bill_amt -- 票据金额
    ,tran_dt -- 交易日期
    ,reqer_type_cd -- 请求方类型代码
    ,reqer_name -- 请求方名称
    ,reqer_soci_crdt_cd -- 请求方社会信用代码
    ,reqer_acct_type_cd -- 请求方账户类型代码
    ,reqer_acct_id -- 请求方账户编号
    ,reqer_acct_name -- 请求方账户名称
    ,reqer_open_bank_no -- 请求方开户行行号
    ,reqer_mem_cd -- 请求方会员代码
    ,reqer_org_cd -- 请求方机构代码
    ,recver_type_cd -- 接收方类型代码
    ,recver_name -- 接收方名称
    ,recver_soci_crdt_cd -- 接收方社会信用代码
    ,recver_acct_type_cd -- 接收方账户类型代码
    ,recver_acct_id -- 接收方账户编号
    ,recver_acct_name -- 接收方账户名称
    ,recver_open_bank_no -- 接收方开户行行号
    ,recver_mem_cd -- 接收方会员代码
    ,recver_org_cd -- 接收方机构代码
    ,discnt_int_rat -- 贴现利率
    ,discnt_actl_amt -- 贴现实付金额
    ,not_ngbl_cd -- 不得转让代码
    ,onl_clear_flg -- 线上清算标志
    ,enter_id -- 入账账户编号
    ,enter_acct_bank_no -- 入账行号
    ,reply_idf_cd -- 应答标识代码
    ,recv_dt -- 签收日期
    ,refuse_pay_cd -- 拒付代码
    ,refuse_pay_remark_info -- 拒付备注信息
    ,recs_type_cd -- 追偿类型代码
    ,actl_int -- 实付利息
    ,int_accr_exp_dt -- 计息到期日期
    ,int_payer_name -- 付息人名称
    ,int_payer_acct_id -- 付息人账户编号
    ,int_payer_open_bank_name -- 付息人开户行名称
    ,comm_fee -- 手续费
    ,todos -- 工本费
    ,pay_int_ratio -- 付息比例
    ,buyer_pay_int_int -- 买方付息利息
    ,tot_int -- 总利息
    ,stop_pay_type_cd -- 止付类型代码
    ,stop_pay_rs_descb -- 止付原因描述
    ,remit_stop_pay_type_cd -- 解除止付类型代码
    ,remit_stop_pay_rs_descb -- 解除止付原因描述
    ,surp_tenor -- 剩余期限
    ,stl_amt -- 结算金额
    ,stl_rest_cd -- 结算结果代码
    ,stl_dt -- 结算日期
    ,payoff_type_cd -- 结清类型代码
    ,tran_status_cd -- 交易状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_corp_rgst_bill_ccution_evt_bdmsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rgst_id -- 登记编号
    ,bill_id -- 票据编号
    ,recv_id -- 签收编号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,bus_type_cd -- 业务类型代码
    ,bus_attr_cd -- 业务属性代码
    ,bus_dir_cd -- 业务方向代码
    ,bill_src_cd -- 票据来源代码
    ,bill_num -- 票据号码
    ,bill_sub_intrv_id -- 票据子区间编号
    ,bill_amt -- 票据金额
    ,tran_dt -- 交易日期
    ,reqer_type_cd -- 请求方类型代码
    ,reqer_name -- 请求方名称
    ,reqer_soci_crdt_cd -- 请求方社会信用代码
    ,reqer_acct_type_cd -- 请求方账户类型代码
    ,reqer_acct_id -- 请求方账户编号
    ,reqer_acct_name -- 请求方账户名称
    ,reqer_open_bank_no -- 请求方开户行行号
    ,reqer_mem_cd -- 请求方会员代码
    ,reqer_org_cd -- 请求方机构代码
    ,recver_type_cd -- 接收方类型代码
    ,recver_name -- 接收方名称
    ,recver_soci_crdt_cd -- 接收方社会信用代码
    ,recver_acct_type_cd -- 接收方账户类型代码
    ,recver_acct_id -- 接收方账户编号
    ,recver_acct_name -- 接收方账户名称
    ,recver_open_bank_no -- 接收方开户行行号
    ,recver_mem_cd -- 接收方会员代码
    ,recver_org_cd -- 接收方机构代码
    ,discnt_int_rat -- 贴现利率
    ,discnt_actl_amt -- 贴现实付金额
    ,not_ngbl_cd -- 不得转让代码
    ,onl_clear_flg -- 线上清算标志
    ,enter_id -- 入账账户编号
    ,enter_acct_bank_no -- 入账行号
    ,reply_idf_cd -- 应答标识代码
    ,recv_dt -- 签收日期
    ,refuse_pay_cd -- 拒付代码
    ,refuse_pay_remark_info -- 拒付备注信息
    ,recs_type_cd -- 追偿类型代码
    ,actl_int -- 实付利息
    ,int_accr_exp_dt -- 计息到期日期
    ,int_payer_name -- 付息人名称
    ,int_payer_acct_id -- 付息人账户编号
    ,int_payer_open_bank_name -- 付息人开户行名称
    ,comm_fee -- 手续费
    ,todos -- 工本费
    ,pay_int_ratio -- 付息比例
    ,buyer_pay_int_int -- 买方付息利息
    ,tot_int -- 总利息
    ,stop_pay_type_cd -- 止付类型代码
    ,stop_pay_rs_descb -- 止付原因描述
    ,remit_stop_pay_type_cd -- 解除止付类型代码
    ,remit_stop_pay_rs_descb -- 解除止付原因描述
    ,surp_tenor -- 剩余期限
    ,stl_amt -- 结算金额
    ,stl_rest_cd -- 结算结果代码
    ,stl_dt -- 结算日期
    ,payoff_type_cd -- 结清类型代码
    ,tran_status_cd -- 交易状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.evt_id -- 事件编号
    ,o.lp_id -- 法人编号
    ,o.rgst_id -- 登记编号
    ,o.bill_id -- 票据编号
    ,o.recv_id -- 签收编号
    ,o.prod_id -- 产品编号
    ,o.prod_name -- 产品名称
    ,o.bill_med_cd -- 票据介质代码
    ,o.bill_type_cd -- 票据类型代码
    ,o.bus_type_cd -- 业务类型代码
    ,o.bus_attr_cd -- 业务属性代码
    ,o.bus_dir_cd -- 业务方向代码
    ,o.bill_src_cd -- 票据来源代码
    ,o.bill_num -- 票据号码
    ,o.bill_sub_intrv_id -- 票据子区间编号
    ,o.bill_amt -- 票据金额
    ,o.tran_dt -- 交易日期
    ,o.reqer_type_cd -- 请求方类型代码
    ,o.reqer_name -- 请求方名称
    ,o.reqer_soci_crdt_cd -- 请求方社会信用代码
    ,o.reqer_acct_type_cd -- 请求方账户类型代码
    ,o.reqer_acct_id -- 请求方账户编号
    ,o.reqer_acct_name -- 请求方账户名称
    ,o.reqer_open_bank_no -- 请求方开户行行号
    ,o.reqer_mem_cd -- 请求方会员代码
    ,o.reqer_org_cd -- 请求方机构代码
    ,o.recver_type_cd -- 接收方类型代码
    ,o.recver_name -- 接收方名称
    ,o.recver_soci_crdt_cd -- 接收方社会信用代码
    ,o.recver_acct_type_cd -- 接收方账户类型代码
    ,o.recver_acct_id -- 接收方账户编号
    ,o.recver_acct_name -- 接收方账户名称
    ,o.recver_open_bank_no -- 接收方开户行行号
    ,o.recver_mem_cd -- 接收方会员代码
    ,o.recver_org_cd -- 接收方机构代码
    ,o.discnt_int_rat -- 贴现利率
    ,o.discnt_actl_amt -- 贴现实付金额
    ,o.not_ngbl_cd -- 不得转让代码
    ,o.onl_clear_flg -- 线上清算标志
    ,o.enter_id -- 入账账户编号
    ,o.enter_acct_bank_no -- 入账行号
    ,o.reply_idf_cd -- 应答标识代码
    ,o.recv_dt -- 签收日期
    ,o.refuse_pay_cd -- 拒付代码
    ,o.refuse_pay_remark_info -- 拒付备注信息
    ,o.recs_type_cd -- 追偿类型代码
    ,o.actl_int -- 实付利息
    ,o.int_accr_exp_dt -- 计息到期日期
    ,o.int_payer_name -- 付息人名称
    ,o.int_payer_acct_id -- 付息人账户编号
    ,o.int_payer_open_bank_name -- 付息人开户行名称
    ,o.comm_fee -- 手续费
    ,o.todos -- 工本费
    ,o.pay_int_ratio -- 付息比例
    ,o.buyer_pay_int_int -- 买方付息利息
    ,o.tot_int -- 总利息
    ,o.stop_pay_type_cd -- 止付类型代码
    ,o.stop_pay_rs_descb -- 止付原因描述
    ,o.remit_stop_pay_type_cd -- 解除止付类型代码
    ,o.remit_stop_pay_rs_descb -- 解除止付原因描述
    ,o.surp_tenor -- 剩余期限
    ,o.stl_amt -- 结算金额
    ,o.stl_rest_cd -- 结算结果代码
    ,o.stl_dt -- 结算日期
    ,o.payoff_type_cd -- 结清类型代码
    ,o.tran_status_cd -- 交易状态代码
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
from ${iml_schema}.evt_corp_rgst_bill_ccution_evt_bdmsf1_bk o
    left join ${iml_schema}.evt_corp_rgst_bill_ccution_evt_bdmsf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_corp_rgst_bill_ccution_evt_bdmsf1_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_corp_rgst_bill_ccution_evt;
--alter table ${iml_schema}.evt_corp_rgst_bill_ccution_evt truncate partition for ('bdmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_corp_rgst_bill_ccution_evt') 
               and substr(subpartition_name,1,8)=upper('p_bdmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_corp_rgst_bill_ccution_evt drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.evt_corp_rgst_bill_ccution_evt modify partition p_bdmsf1 
add subpartition p_bdmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_corp_rgst_bill_ccution_evt exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.evt_corp_rgst_bill_ccution_evt_bdmsf1_cl;
alter table ${iml_schema}.evt_corp_rgst_bill_ccution_evt exchange subpartition p_bdmsf1_20991231 with table ${iml_schema}.evt_corp_rgst_bill_ccution_evt_bdmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_corp_rgst_bill_ccution_evt to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_corp_rgst_bill_ccution_evt_bdmsf1_tm purge;
drop table ${iml_schema}.evt_corp_rgst_bill_ccution_evt_bdmsf1_op purge;
drop table ${iml_schema}.evt_corp_rgst_bill_ccution_evt_bdmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_corp_rgst_bill_ccution_evt_bdmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_corp_rgst_bill_ccution_evt', partname => 'p_bdmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
