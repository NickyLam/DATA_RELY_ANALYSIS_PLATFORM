/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_ym_tran_flow_mpcsf1
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
alter table ${iml_schema}.evt_ym_tran_flow add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_mpcsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_ym_tran_flow_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_ym_tran_flow partition for ('mpcsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_ym_tran_flow_mpcsf1_tm purge;
drop table ${iml_schema}.evt_ym_tran_flow_mpcsf1_op purge;
drop table ${iml_schema}.evt_ym_tran_flow_mpcsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ym_tran_flow_mpcsf1_tm nologging
compress ${option_switch} for query high
as select
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
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ym_tran_flow partition for ('mpcsf1')
where 0=1
;

create table ${iml_schema}.evt_ym_tran_flow_mpcsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_ym_tran_flow partition for ('mpcsf1') where 0=1;

create table ${iml_schema}.evt_ym_tran_flow_mpcsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_ym_tran_flow partition for ('mpcsf1') where 0=1;

-- 3.1 get new data into table
-- mpcs_a92ordertrans-
insert into ${iml_schema}.evt_ym_tran_flow_mpcsf1_tm(
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
    ,nvl(trim(P1.CCY),'-')   -- 币种代码
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
    ,'mpcsf1' -- 任务编码
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
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_ym_tran_flow_mpcsf1_tm 
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
        into ${iml_schema}.evt_ym_tran_flow_mpcsf1_cl(
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
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_ym_tran_flow_mpcsf1_op(
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
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,nvl(n.fe_req_flow_num, o.fe_req_flow_num) as fe_req_flow_num -- 前端请求流水号
    ,nvl(n.tran_cfm_cd, o.tran_cfm_cd) as tran_cfm_cd -- 交易确认代码
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.serv_plat_abbr, o.serv_plat_abbr) as serv_plat_abbr -- 服务平台简称
    ,nvl(n.mercht_id, o.mercht_id) as mercht_id -- 商户编号
    ,nvl(n.tran_chn_cd, o.tran_chn_cd) as tran_chn_cd -- 交易渠道代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.ym_fund_acct_id, o.ym_fund_acct_id) as ym_fund_acct_id -- 盈米基金账户编号
    ,nvl(n.mode_pay_id, o.mode_pay_id) as mode_pay_id -- 支付方式编号
    ,nvl(n.prod_buy_type_cd, o.prod_buy_type_cd) as prod_buy_type_cd -- 产品购买类型代码
    ,nvl(n.fund_cd, o.fund_cd) as fund_cd -- 基金代码
    ,nvl(n.fund_name, o.fund_name) as fund_name -- 基金名称
    ,nvl(n.prod_charge_way_cd, o.prod_charge_way_cd) as prod_charge_way_cd -- 产品收费方式代码
    ,nvl(n.prod_divd_way_cd, o.prod_divd_way_cd) as prod_divd_way_cd -- 产品分红方式代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.lot_id, o.lot_id) as lot_id -- 份额编号
    ,nvl(n.tran_lot, o.tran_lot) as tran_lot -- 交易份额
    ,nvl(n.huge_redem_proc_flg_cd, o.huge_redem_proc_flg_cd) as huge_redem_proc_flg_cd -- 巨额赎回处理标志代码
    ,nvl(n.redem_ymb_flg, o.redem_ymb_flg) as redem_ymb_flg -- 赎回盈米宝标志
    ,nvl(n.tran_id, o.tran_id) as tran_id -- 交易编号
    ,nvl(n.tran_create_dt, o.tran_create_dt) as tran_create_dt -- 交易生成日期
    ,nvl(n.tran_appl_dt, o.tran_appl_dt) as tran_appl_dt -- 交易申请日期
    ,nvl(n.tran_expect_cfm_dt, o.tran_expect_cfm_dt) as tran_expect_cfm_dt -- 交易预计确认日期
    ,nvl(n.redem_money_pay_dt, o.redem_money_pay_dt) as redem_money_pay_dt -- 赎回款项支付日期
    ,nvl(n.upp_tran_code, o.upp_tran_code) as upp_tran_code -- UPP交易码
    ,nvl(n.acct_type_cd, o.acct_type_cd) as acct_type_cd -- 账户类型代码
    ,nvl(n.tran_out_acct_id, o.tran_out_acct_id) as tran_out_acct_id -- 转出方账户编号
    ,nvl(n.tran_out_acct_name, o.tran_out_acct_name) as tran_out_acct_name -- 转出方账户名称
    ,nvl(n.tran_out_org_id, o.tran_out_org_id) as tran_out_org_id -- 转出方机构编号
    ,nvl(n.tran_in_acct_id, o.tran_in_acct_id) as tran_in_acct_id -- 转入方账户编号
    ,nvl(n.tran_in_acct_name, o.tran_in_acct_name) as tran_in_acct_name -- 转入方账户名称
    ,nvl(n.tran_in_org_id, o.tran_in_org_id) as tran_in_org_id -- 转入方机构编号
    ,nvl(n.upp_stop_req_flow_num, o.upp_stop_req_flow_num) as upp_stop_req_flow_num -- UPP止付请求流水号
    ,nvl(n.clear_dt, o.clear_dt) as clear_dt -- 清算日期
    ,nvl(n.froz_id, o.froz_id) as froz_id -- 冻结编号
    ,nvl(n.upp_init_flow_num, o.upp_init_flow_num) as upp_init_flow_num -- UPP原流水号
    ,nvl(n.upp_host_dt, o.upp_host_dt) as upp_host_dt -- UPP主机日期
    ,nvl(n.upp_host_flow_num, o.upp_host_flow_num) as upp_host_flow_num -- UPP主机流水号
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.tran_revo_status_cd, o.tran_revo_status_cd) as tran_revo_status_cd -- 交易撤单状态代码
    ,nvl(n.tran_cfm_status_cd, o.tran_cfm_status_cd) as tran_cfm_status_cd -- 交易确认状态代码
    ,nvl(n.tran_flg_cd, o.tran_flg_cd) as tran_flg_cd -- 交易标志代码
    ,nvl(n.pay_rest_advise_sucs_cd, o.pay_rest_advise_sucs_cd) as pay_rest_advise_sucs_cd -- 支付结果通知成功代码
    ,nvl(n.sucsed_amt, o.sucsed_amt) as sucsed_amt -- 已成功金额
    ,nvl(n.sucsed_lot, o.sucsed_lot) as sucsed_lot -- 已成功份额
    ,nvl(n.err_cd, o.err_cd) as err_cd -- 错误码
    ,nvl(n.err_info_desc, o.err_info_desc) as err_info_desc -- 错误信息描述
    ,nvl(n.indent_status_cd, o.indent_status_cd) as indent_status_cd -- 订单状态代码
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
from ${iml_schema}.evt_ym_tran_flow_mpcsf1_tm n
    full join (select * from ${iml_schema}.evt_ym_tran_flow_mpcsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.tran_flow_num <> n.tran_flow_num
        or o.fe_req_flow_num <> n.fe_req_flow_num
        or o.tran_cfm_cd <> n.tran_cfm_cd
        or o.tran_tm <> n.tran_tm
        or o.serv_plat_abbr <> n.serv_plat_abbr
        or o.mercht_id <> n.mercht_id
        or o.tran_chn_cd <> n.tran_chn_cd
        or o.cust_id <> n.cust_id
        or o.ym_fund_acct_id <> n.ym_fund_acct_id
        or o.mode_pay_id <> n.mode_pay_id
        or o.prod_buy_type_cd <> n.prod_buy_type_cd
        or o.fund_cd <> n.fund_cd
        or o.fund_name <> n.fund_name
        or o.prod_charge_way_cd <> n.prod_charge_way_cd
        or o.prod_divd_way_cd <> n.prod_divd_way_cd
        or o.curr_cd <> n.curr_cd
        or o.tran_amt <> n.tran_amt
        or o.lot_id <> n.lot_id
        or o.tran_lot <> n.tran_lot
        or o.huge_redem_proc_flg_cd <> n.huge_redem_proc_flg_cd
        or o.redem_ymb_flg <> n.redem_ymb_flg
        or o.tran_id <> n.tran_id
        or o.tran_create_dt <> n.tran_create_dt
        or o.tran_appl_dt <> n.tran_appl_dt
        or o.tran_expect_cfm_dt <> n.tran_expect_cfm_dt
        or o.redem_money_pay_dt <> n.redem_money_pay_dt
        or o.upp_tran_code <> n.upp_tran_code
        or o.acct_type_cd <> n.acct_type_cd
        or o.tran_out_acct_id <> n.tran_out_acct_id
        or o.tran_out_acct_name <> n.tran_out_acct_name
        or o.tran_out_org_id <> n.tran_out_org_id
        or o.tran_in_acct_id <> n.tran_in_acct_id
        or o.tran_in_acct_name <> n.tran_in_acct_name
        or o.tran_in_org_id <> n.tran_in_org_id
        or o.upp_stop_req_flow_num <> n.upp_stop_req_flow_num
        or o.clear_dt <> n.clear_dt
        or o.froz_id <> n.froz_id
        or o.upp_init_flow_num <> n.upp_init_flow_num
        or o.upp_host_dt <> n.upp_host_dt
        or o.upp_host_flow_num <> n.upp_host_flow_num
        or o.tran_status_cd <> n.tran_status_cd
        or o.tran_revo_status_cd <> n.tran_revo_status_cd
        or o.tran_cfm_status_cd <> n.tran_cfm_status_cd
        or o.tran_flg_cd <> n.tran_flg_cd
        or o.pay_rest_advise_sucs_cd <> n.pay_rest_advise_sucs_cd
        or o.sucsed_amt <> n.sucsed_amt
        or o.sucsed_lot <> n.sucsed_lot
        or o.err_cd <> n.err_cd
        or o.err_info_desc <> n.err_info_desc
        or o.indent_status_cd <> n.indent_status_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_ym_tran_flow_mpcsf1_cl(
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
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_ym_tran_flow_mpcsf1_op(
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
    ,o.tran_flow_num -- 交易流水号
    ,o.fe_req_flow_num -- 前端请求流水号
    ,o.tran_cfm_cd -- 交易确认代码
    ,o.tran_tm -- 交易时间
    ,o.serv_plat_abbr -- 服务平台简称
    ,o.mercht_id -- 商户编号
    ,o.tran_chn_cd -- 交易渠道代码
    ,o.cust_id -- 客户编号
    ,o.ym_fund_acct_id -- 盈米基金账户编号
    ,o.mode_pay_id -- 支付方式编号
    ,o.prod_buy_type_cd -- 产品购买类型代码
    ,o.fund_cd -- 基金代码
    ,o.fund_name -- 基金名称
    ,o.prod_charge_way_cd -- 产品收费方式代码
    ,o.prod_divd_way_cd -- 产品分红方式代码
    ,o.curr_cd -- 币种代码
    ,o.tran_amt -- 交易金额
    ,o.lot_id -- 份额编号
    ,o.tran_lot -- 交易份额
    ,o.huge_redem_proc_flg_cd -- 巨额赎回处理标志代码
    ,o.redem_ymb_flg -- 赎回盈米宝标志
    ,o.tran_id -- 交易编号
    ,o.tran_create_dt -- 交易生成日期
    ,o.tran_appl_dt -- 交易申请日期
    ,o.tran_expect_cfm_dt -- 交易预计确认日期
    ,o.redem_money_pay_dt -- 赎回款项支付日期
    ,o.upp_tran_code -- UPP交易码
    ,o.acct_type_cd -- 账户类型代码
    ,o.tran_out_acct_id -- 转出方账户编号
    ,o.tran_out_acct_name -- 转出方账户名称
    ,o.tran_out_org_id -- 转出方机构编号
    ,o.tran_in_acct_id -- 转入方账户编号
    ,o.tran_in_acct_name -- 转入方账户名称
    ,o.tran_in_org_id -- 转入方机构编号
    ,o.upp_stop_req_flow_num -- UPP止付请求流水号
    ,o.clear_dt -- 清算日期
    ,o.froz_id -- 冻结编号
    ,o.upp_init_flow_num -- UPP原流水号
    ,o.upp_host_dt -- UPP主机日期
    ,o.upp_host_flow_num -- UPP主机流水号
    ,o.tran_status_cd -- 交易状态代码
    ,o.tran_revo_status_cd -- 交易撤单状态代码
    ,o.tran_cfm_status_cd -- 交易确认状态代码
    ,o.tran_flg_cd -- 交易标志代码
    ,o.pay_rest_advise_sucs_cd -- 支付结果通知成功代码
    ,o.sucsed_amt -- 已成功金额
    ,o.sucsed_lot -- 已成功份额
    ,o.err_cd -- 错误码
    ,o.err_info_desc -- 错误信息描述
    ,o.indent_status_cd -- 订单状态代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ym_tran_flow_mpcsf1_bk o
    left join ${iml_schema}.evt_ym_tran_flow_mpcsf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_ym_tran_flow_mpcsf1_cl d
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
--truncate table ${iml_schema}.evt_ym_tran_flow;
alter table ${iml_schema}.evt_ym_tran_flow truncate partition for ('mpcsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.evt_ym_tran_flow exchange subpartition p_mpcsf1_19000101 with table ${iml_schema}.evt_ym_tran_flow_mpcsf1_cl;
alter table ${iml_schema}.evt_ym_tran_flow exchange subpartition p_mpcsf1_20991231 with table ${iml_schema}.evt_ym_tran_flow_mpcsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_ym_tran_flow to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_ym_tran_flow_mpcsf1_tm purge;
drop table ${iml_schema}.evt_ym_tran_flow_mpcsf1_op purge;
drop table ${iml_schema}.evt_ym_tran_flow_mpcsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_ym_tran_flow_mpcsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_ym_tran_flow', partname => 'p_mpcsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
