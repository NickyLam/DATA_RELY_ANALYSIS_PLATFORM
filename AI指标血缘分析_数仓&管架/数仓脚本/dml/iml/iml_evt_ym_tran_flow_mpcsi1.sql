/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_ym_tran_flow_mpcsi1
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
drop table ${iml_schema}.evt_ym_tran_flow_mpcsi1_tm purge;
alter table ${iml_schema}.evt_ym_tran_flow add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_ym_tran_flow modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ym_tran_flow_mpcsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,fe_req_flow_num -- 前端请求流水号
    ,tran_cfm_cd -- 交易确认代码
    ,tran_tm -- 交易时间
    ,serv_plat_abbr -- 服务平台简称
    ,mercht_id -- 商户编号
    ,tran_chn_cd -- 交易渠道代码
    ,cust_id -- 客户编号
    ,ym_fund_acct_id -- 盈米基金账户编号
    ,mode_pay_id -- 支付方式编号
    ,prod_buy_type_cd -- 产品购买类型代码
    ,fund_cd -- 基金代码
    ,fund_name -- 基金名称
    ,prod_charge_way_cd -- 产品收费方式代码
    ,prod_divd_way_cd -- 产品分红方式代码
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,lot_id -- 份额编号
    ,tran_lot -- 交易份额
    ,huge_redem_proc_flg_cd -- 巨额赎回处理标志代码
    ,redem_ymb_flg -- 赎回盈米宝标志
    ,tran_id -- 交易编号
    ,tran_create_dt -- 交易生成日期
    ,tran_appl_dt -- 交易申请日期
    ,tran_expect_cfm_dt -- 交易预计确认日期
    ,redem_money_pay_dt -- 赎回款项支付日期
    ,upp_tran_code -- UPP交易码
    ,acct_type_cd -- 账户类型代码
    ,tran_out_acct_id -- 转出方账户编号
    ,tran_out_acct_name -- 转出方账户名称
    ,tran_out_org_id -- 转出方机构编号
    ,tran_in_acct_id -- 转入方账户编号
    ,tran_in_acct_name -- 转入方账户名称
    ,tran_in_org_id -- 转入方机构编号
    ,upp_stop_req_flow_num -- UPP止付请求流水号
    ,clear_dt -- 清算日期
    ,froz_id -- 冻结编号
    ,upp_init_flow_num -- UPP原流水号
    ,upp_host_dt -- UPP主机日期
    ,upp_host_flow_num -- UPP主机流水号
    ,tran_status_cd -- 交易状态代码
    ,tran_revo_status_cd -- 交易撤单状态代码
    ,tran_cfm_status_cd -- 交易确认状态代码
    ,tran_flg_cd -- 交易标志代码
    ,pay_rest_advise_sucs_cd -- 支付结果通知成功代码
    ,sucsed_amt -- 已成功金额
    ,sucsed_lot -- 已成功份额
    ,err_cd -- 错误码
    ,err_info_desc -- 错误信息描述
    ,indent_status_cd -- 订单状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ym_tran_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a92ordertrans-
insert into ${iml_schema}.evt_ym_tran_flow_mpcsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,fe_req_flow_num -- 前端请求流水号
    ,tran_cfm_cd -- 交易确认代码
    ,tran_tm -- 交易时间
    ,serv_plat_abbr -- 服务平台简称
    ,mercht_id -- 商户编号
    ,tran_chn_cd -- 交易渠道代码
    ,cust_id -- 客户编号
    ,ym_fund_acct_id -- 盈米基金账户编号
    ,mode_pay_id -- 支付方式编号
    ,prod_buy_type_cd -- 产品购买类型代码
    ,fund_cd -- 基金代码
    ,fund_name -- 基金名称
    ,prod_charge_way_cd -- 产品收费方式代码
    ,prod_divd_way_cd -- 产品分红方式代码
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,lot_id -- 份额编号
    ,tran_lot -- 交易份额
    ,huge_redem_proc_flg_cd -- 巨额赎回处理标志代码
    ,redem_ymb_flg -- 赎回盈米宝标志
    ,tran_id -- 交易编号
    ,tran_create_dt -- 交易生成日期
    ,tran_appl_dt -- 交易申请日期
    ,tran_expect_cfm_dt -- 交易预计确认日期
    ,redem_money_pay_dt -- 赎回款项支付日期
    ,upp_tran_code -- UPP交易码
    ,acct_type_cd -- 账户类型代码
    ,tran_out_acct_id -- 转出方账户编号
    ,tran_out_acct_name -- 转出方账户名称
    ,tran_out_org_id -- 转出方机构编号
    ,tran_in_acct_id -- 转入方账户编号
    ,tran_in_acct_name -- 转入方账户名称
    ,tran_in_org_id -- 转入方机构编号
    ,upp_stop_req_flow_num -- UPP止付请求流水号
    ,clear_dt -- 清算日期
    ,froz_id -- 冻结编号
    ,upp_init_flow_num -- UPP原流水号
    ,upp_host_dt -- UPP主机日期
    ,upp_host_flow_num -- UPP主机流水号
    ,tran_status_cd -- 交易状态代码
    ,tran_revo_status_cd -- 交易撤单状态代码
    ,tran_cfm_status_cd -- 交易确认状态代码
    ,tran_flg_cd -- 交易标志代码
    ,pay_rest_advise_sucs_cd -- 支付结果通知成功代码
    ,sucsed_amt -- 已成功金额
    ,sucsed_lot -- 已成功份额
    ,err_cd -- 错误码
    ,err_info_desc -- 错误信息描述
    ,indent_status_cd -- 订单状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104032'||BROKERORDERNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.BROKERORDERNO -- 交易流水号
    ,P1.SRCSEQNO -- 前端请求流水号
    ,CASE WHEN R10.TARGET_CD_VAL IS NOT NULL THEN R10.TARGET_CD_VAL ELSE '@'||P1.TRANTYPE END -- 交易确认代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.TRANSTIME) -- 交易时间
    ,P1.PAYSYS -- 服务平台简称
    ,P1.INSTID -- 商户编号
    ,CASE WHEN R11.TARGET_CD_VAL IS NOT NULL THEN R11.TARGET_CD_VAL ELSE '@'||P1.CHANNEL END -- 交易渠道代码
    ,P1.CUSTOMNO -- 客户编号
    ,P1.ACCOUNTID -- 盈米基金账户编号
    ,P1.PAYMENTMETHODID -- 支付方式编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.BUY END -- 产品购买类型代码
    ,P1.FUNDCODE -- 基金代码
    ,P1.FUNDNAME -- 基金名称
    ,nvl(trim(P1.SHARETYPE),'-') -- 产品收费方式代码
    ,nvl(trim(P1.DIVIDENDMETHOD),'-') -- 产品分红方式代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CCY END -- 币种代码
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.AMOUNT, '[0-9.]+')),0)) -- 交易金额
    ,P1.SHAREID -- 份额编号
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.TRADESHARE, '[0-9.]+')),0)) -- 交易份额
    ,nvl(trim(P1.VASTLYREDEEMFLAG),'-') -- 巨额赎回处理标志代码
    ,nvl(trim(P1.REDEEMTOWALLET),'-') -- 赎回盈米宝标志
    ,P1.ORDERID -- 交易编号
    ,${iml_schema}.DATEFORMAT_MAX(substr(P1.ORDERCREATEDON,1,10)) -- 交易生成日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.ORDERTRADEDATE) -- 交易申请日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.ORDEREXPECTEDCONFIRMDATE) -- 交易预计确认日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.TRANSFERINTODATE) -- 赎回款项支付日期
    ,P1.WORKCODE -- UPP交易码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.ACCTTYPE END -- 账户类型代码
    ,P1.PAYERACCT -- 转出方账户编号
    ,P1.PAYERNAME -- 转出方账户名称
    ,P1.PAYEROPBK -- 转出方机构编号
    ,P1.PAYEEACCT -- 转入方账户编号
    ,P1.PAYEENAME -- 转入方账户名称
    ,P1.PAYEEOPBK -- 转入方机构编号
    ,P1.UPPFREETRACE -- UPP止付请求流水号
    ,${iml_schema}.DATEFORMAT_MAX(P1.SETTLDATE) -- 清算日期
    ,P1.FREEZERECORDID -- 冻结编号
    ,P1.UPPTRANSID -- UPP原流水号
    ,${iml_schema}.DATEFORMAT_MAX(P1.HOSTDATE) -- UPP主机日期
    ,P1.HOSTNBR -- UPP主机流水号
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.STATUS END -- 交易状态代码
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.CDFLG END -- 交易撤单状态代码
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.FINALSTATUS END -- 交易确认状态代码
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.TZFLG END -- 交易标志代码
    ,CASE WHEN R8.TARGET_CD_VAL IS NOT NULL THEN R8.TARGET_CD_VAL ELSE '@'||P1.ISNOTESUCCESS END -- 支付结果通知成功代码
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.SUCCESSAMOUNT, '[0-9.]+')),0)) -- 已成功金额
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.SUCCESSSHARE, '[0-9.]+')),0)) -- 已成功份额
    ,P1.RSPCD -- 错误码
    ,P1.RSPMSG -- 错误信息描述
    ,CASE WHEN R9.TARGET_CD_VAL IS NOT NULL THEN R9.TARGET_CD_VAL ELSE '@'||P1.ORDERSTAT END -- 订单状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a92ordertrans' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a92ordertrans p1
    left join ${iml_schema}.ref_pub_cd_map r10 on P1.TRANTYPE = R10.SRC_CODE_VAL
        AND R10.SORC_SYS_CD= 'MPCS'
        AND R10.SRC_TAB_EN_NAME= 'MPCS_A92ORDERTRANS'
        AND R10.SRC_FIELD_EN_NAME= 'TRANTYPE'
        AND R10.TARGET_TAB_EN_NAME= 'EVT_YM_TRAN_FLOW'
        AND R10.TARGET_TAB_FIELD_EN_NAME= 'TRAN_CFM_CD'
    left join ${iml_schema}.ref_pub_cd_map r11 on P1.CHANNEL = R11.SRC_CODE_VAL
        AND R11.SORC_SYS_CD= 'MPCS'
        AND R11.SRC_TAB_EN_NAME= 'MPCS_A92ORDERTRANS'
        AND R11.SRC_FIELD_EN_NAME= 'CHANNEL'
        AND R11.TARGET_TAB_EN_NAME= 'EVT_YM_TRAN_FLOW'
        AND R11.TARGET_TAB_FIELD_EN_NAME= 'TRAN_CHN_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.BUY = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A92ORDERTRANS'
        AND R2.SRC_FIELD_EN_NAME= 'BUY'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_YM_TRAN_FLOW'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'PROD_BUY_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CCY = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A92ORDERTRANS'
        AND R1.SRC_FIELD_EN_NAME= 'CCY'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_YM_TRAN_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.ACCTTYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'MPCS'
        AND R3.SRC_TAB_EN_NAME= 'MPCS_A92ORDERTRANS'
        AND R3.SRC_FIELD_EN_NAME= 'ACCTTYPE'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_YM_TRAN_FLOW'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'ACCT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.STATUS = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'MPCS'
        AND R4.SRC_TAB_EN_NAME= 'MPCS_A92ORDERTRANS'
        AND R4.SRC_FIELD_EN_NAME= 'STATUS'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_YM_TRAN_FLOW'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'TRAN_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.CDFLG = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'MPCS'
        AND R5.SRC_TAB_EN_NAME= 'MPCS_A92ORDERTRANS'
        AND R5.SRC_FIELD_EN_NAME= 'CDFLG'
        AND R5.TARGET_TAB_EN_NAME= 'EVT_YM_TRAN_FLOW'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'TRAN_REVO_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.FINALSTATUS = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'MPCS'
        AND R6.SRC_TAB_EN_NAME= 'MPCS_A92ORDERTRANS'
        AND R6.SRC_FIELD_EN_NAME= 'FINALSTATUS'
        AND R6.TARGET_TAB_EN_NAME= 'EVT_YM_TRAN_FLOW'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'TRAN_CFM_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.TZFLG = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'MPCS'
        AND R7.SRC_TAB_EN_NAME= 'MPCS_A92ORDERTRANS'
        AND R7.SRC_FIELD_EN_NAME= 'TZFLG'
        AND R7.TARGET_TAB_EN_NAME= 'EVT_YM_TRAN_FLOW'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'TRAN_FLG_CD'
    left join ${iml_schema}.ref_pub_cd_map r8 on P1.ISNOTESUCCESS = R8.SRC_CODE_VAL
        AND R8.SORC_SYS_CD= 'MPCS'
        AND R8.SRC_TAB_EN_NAME= 'MPCS_A92ORDERTRANS'
        AND R8.SRC_FIELD_EN_NAME= 'ISNOTESUCCESS'
        AND R8.TARGET_TAB_EN_NAME= 'EVT_YM_TRAN_FLOW'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'PAY_REST_ADVISE_SUCS_CD'
    left join ${iml_schema}.ref_pub_cd_map r9 on P1.ORDERSTAT = R9.SRC_CODE_VAL
        AND R9.SORC_SYS_CD= 'MPCS'
        AND R9.SRC_TAB_EN_NAME= 'MPCS_A92ORDERTRANS'
        AND R9.SRC_FIELD_EN_NAME= 'ORDERSTAT'
        AND R9.TARGET_TAB_EN_NAME= 'EVT_YM_TRAN_FLOW'
        AND R9.TARGET_TAB_FIELD_EN_NAME= 'INDENT_STATUS_CD'
where  1 = 1 
    and substr(P1.transtime,1,8)= '${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_ym_tran_flow truncate subpartition p_mpcsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_ym_tran_flow exchange subpartition p_mpcsi1_${batch_date} with table ${iml_schema}.evt_ym_tran_flow_mpcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_ym_tran_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_ym_tran_flow_mpcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_ym_tran_flow', partname => 'p_mpcsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);