/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_payfan_indent_info_h_amssf1
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
alter table ${iml_schema}.agt_payfan_indent_info_h add partition p_amssf1 values ('amssf1')(
        subpartition p_amssf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_amssf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_payfan_indent_info_h_amssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_payfan_indent_info_h partition for ('amssf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_payfan_indent_info_h_amssf1_tm purge;
drop table ${iml_schema}.agt_payfan_indent_info_h_amssf1_op purge;
drop table ${iml_schema}.agt_payfan_indent_info_h_amssf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_payfan_indent_info_h_amssf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,payfan_chn_id -- 代付渠道编号
    ,tran_code -- 交易码
    ,curr_cd -- 币种代码
    ,tran_type_cd -- 交易类型代码
    ,tran_status_cd -- 交易状态代码
    ,tran_amt -- 交易金额
    ,batch_no -- 批次号
    ,batch_rgst_status_cd -- 批次登记状态代码
    ,tot -- 总笔数
    ,sucs_tran_amt -- 成功交易金额
    ,sucs_tran_cnt -- 成功交易笔数
    ,fail_tran_amt -- 失败交易金额
    ,fail_tran_cnt -- 失败交易笔数
    ,chn_order_no -- 渠道订单号
    ,resp_code -- 响应码
    ,resp_code_descb -- 响应码描述
    ,mercht_id -- 商户编号
    ,pay_acct_type_cd -- 支付账户类型代码
    ,pay_acct_id -- 支付账户编号
    ,pay_acct_name -- 支付账户名称
    ,intnal_acct_id -- 内部账户编号
    ,intnal_acct_name -- 内部账户名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,recvbl_bank_ibank_no -- 收款银行联行号
    ,recvbl_bank_name -- 收款银行名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,postsc -- 附言
    ,ova_flow_num -- 全局流水号
    ,core_flow_num -- 核心流水号
    ,unionpay_mercht_order_no -- 银联商户订单号
    ,unionpay_tran_flow_num -- 银联交易流水号
    ,unionpay_tran_dt -- 银联交易日期
    ,agt_corp_type_cd -- 协议单位类型代码
    ,agency_id -- 代理商编号
    ,agt_corp_id -- 协议单位编号
    ,agt_corp_name -- 协议单位名称
    ,api_sys_idf -- API系统标识
    ,teller_id -- 柜员编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_payfan_indent_info_h partition for ('amssf1')
where 0=1
;

create table ${iml_schema}.agt_payfan_indent_info_h_amssf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_payfan_indent_info_h partition for ('amssf1') where 0=1;

create table ${iml_schema}.agt_payfan_indent_info_h_amssf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_payfan_indent_info_h partition for ('amssf1') where 0=1;

-- 3.1 get new data into table
-- amss_tbl_df_order_txn-1
insert into ${iml_schema}.agt_payfan_indent_info_h_amssf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,payfan_chn_id -- 代付渠道编号
    ,tran_code -- 交易码
    ,curr_cd -- 币种代码
    ,tran_type_cd -- 交易类型代码
    ,tran_status_cd -- 交易状态代码
    ,tran_amt -- 交易金额
    ,batch_no -- 批次号
    ,batch_rgst_status_cd -- 批次登记状态代码
    ,tot -- 总笔数
    ,sucs_tran_amt -- 成功交易金额
    ,sucs_tran_cnt -- 成功交易笔数
    ,fail_tran_amt -- 失败交易金额
    ,fail_tran_cnt -- 失败交易笔数
    ,chn_order_no -- 渠道订单号
    ,resp_code -- 响应码
    ,resp_code_descb -- 响应码描述
    ,mercht_id -- 商户编号
    ,pay_acct_type_cd -- 支付账户类型代码
    ,pay_acct_id -- 支付账户编号
    ,pay_acct_name -- 支付账户名称
    ,intnal_acct_id -- 内部账户编号
    ,intnal_acct_name -- 内部账户名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,recvbl_bank_ibank_no -- 收款银行联行号
    ,recvbl_bank_name -- 收款银行名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,postsc -- 附言
    ,ova_flow_num -- 全局流水号
    ,core_flow_num -- 核心流水号
    ,unionpay_mercht_order_no -- 银联商户订单号
    ,unionpay_tran_flow_num -- 银联交易流水号
    ,unionpay_tran_dt -- 银联交易日期
    ,agt_corp_type_cd -- 协议单位类型代码
    ,agency_id -- 代理商编号
    ,agt_corp_id -- 协议单位编号
    ,agt_corp_name -- 协议单位名称
    ,api_sys_idf -- API系统标识
    ,teller_id -- 柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300042'||P1.KEY_RSP -- 协议编号
    ,'9999' -- 法人编号
    ,P1.KEY_RSP -- 交易流水号
    ,${iml_schema}.dateformat_max2(P1.TRAN_DATE||P1.TRAN_TIME) -- 交易日期
    ,P1.TRAN_CHANNEL -- 代付渠道编号
    ,nvl(trim(P1.TXN_NUM),'-') -- 交易码
    ,decode(P1.CNY,'156','CNY',' ','-',P1.CNY) -- 币种代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.ACCESS_TYPE END -- 交易类型代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.TXN_STA END -- 交易状态代码
    ,P1.TRADE_MONEY -- 交易金额
    ,P1.BATCH_NO -- 批次号
    ,nvl(trim(P1.BACTH_STA),'-') -- 批次登记状态代码
    ,to_number(nvl(trim(P1.SUM_COUNT),'0')) -- 总笔数
    ,to_number(nvl(trim(P1.SUCCEE_TRADE_MONEY),'0.00')) -- 成功交易金额
    ,to_number(nvl(trim(P1.SUCCEE_COUNT),'0'))  -- 成功交易笔数
    ,to_number(nvl(trim(P1.FAIL_TRADE_MONEY),'0.00'))  -- 失败交易金额
    ,to_number(nvl(trim(P1.FAIL_COUNT),'0')) -- 失败交易笔数
    ,P1.OUT_ORDER_NO -- 渠道订单号
    ,P1.RES_CODE -- 响应码
    ,P1.RES_DESC -- 响应码描述
    ,P1.MCHT_NO -- 商户编号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.ACCOUNTTYPE END -- 支付账户类型代码
    ,P1.ACCOUNTNUMBER -- 支付账户编号
    ,P1.ACCOUNTNAME -- 支付账户名称
    ,P1.CHANNEL_ACCT_NO -- 内部账户编号
    ,P1.CHANNEL_ACCT_NAME -- 内部账户名称
    ,P1.BANK_ACCOUNT_NO -- 收款账户编号
    ,P1.BANK_ACCOUNT_NAME -- 收款账户名称
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.BANK_ACCOUNT_TYPE END -- 收款账户类型代码
    ,P1.BANK_ACCOUNT_LINENO -- 收款银行联行号
    ,P1.BANK_NAME -- 收款银行名称
    ,nvl(trim(P1.CERT_TYPE_ID),'0000') -- 证件类型代码
    ,P1.CERT_NO -- 证件号码
    ,P1.PHONE -- 手机号码
    ,P1.PUBLIC_NOTE -- 附言
    ,P1.TRAN_SEQ_NO_IH -- 全局流水号
    ,P1.HOST_KEY_IH -- 核心流水号
    ,P1.TRAN_SEQ_NO_UP -- 银联商户订单号
    ,P1.TRACE_NO -- 银联交易流水号
    ,${iml_schema}.dateformat_max2(P1.TRAN_DATE||P1.TRAN_TIME) -- 银联交易日期
    ,'0' -- 协议单位类型代码
    ,P1.AGENT_NO -- 代理商编号
    ,P1.AGREE_UNIT_NO -- 协议单位编号
    ,P1.AGREE_UNIT_NAME -- 协议单位名称
    ,P1.API_ID -- API系统标识
    ,P1.OPR_ID -- 柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'amss_tbl_df_order_txn' -- 源表名称
    ,'amssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.amss_tbl_df_order_txn p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.ACCESS_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'AMSS'
        AND R1.SRC_TAB_EN_NAME= 'AMSS_TBL_DF_ORDER_TXN'
        AND R1.SRC_FIELD_EN_NAME= 'ACCESS_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_PAYFAN_INDENT_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TRAN_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.TXN_STA = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'AMSS'
        AND R2.SRC_TAB_EN_NAME= 'AMSS_TBL_DF_ORDER_TXN'
        AND R2.SRC_FIELD_EN_NAME= 'TXN_STA'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_PAYFAN_INDENT_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'TRAN_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.ACCOUNTTYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'AMSS'
        AND R3.SRC_TAB_EN_NAME= 'AMSS_TBL_DF_ORDER_TXN'
        AND R3.SRC_FIELD_EN_NAME= 'ACCOUNTTYPE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_PAYFAN_INDENT_INFO_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'PAY_ACCT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.BANK_ACCOUNT_TYPE = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'AMSS'
        AND R4.SRC_TAB_EN_NAME= 'AMSS_TBL_DF_ORDER_TXN'
        AND R4.SRC_FIELD_EN_NAME= 'BANK_ACCOUNT_TYPE'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_PAYFAN_INDENT_INFO_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'RECVBL_ACCT_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
     and P1.PRODUCT_CATEGORIES ='0' -- E校通
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_payfan_indent_info_h_amssf1_tm 
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_payfan_indent_info_h_amssf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,payfan_chn_id -- 代付渠道编号
    ,tran_code -- 交易码
    ,curr_cd -- 币种代码
    ,tran_type_cd -- 交易类型代码
    ,tran_status_cd -- 交易状态代码
    ,tran_amt -- 交易金额
    ,batch_no -- 批次号
    ,batch_rgst_status_cd -- 批次登记状态代码
    ,tot -- 总笔数
    ,sucs_tran_amt -- 成功交易金额
    ,sucs_tran_cnt -- 成功交易笔数
    ,fail_tran_amt -- 失败交易金额
    ,fail_tran_cnt -- 失败交易笔数
    ,chn_order_no -- 渠道订单号
    ,resp_code -- 响应码
    ,resp_code_descb -- 响应码描述
    ,mercht_id -- 商户编号
    ,pay_acct_type_cd -- 支付账户类型代码
    ,pay_acct_id -- 支付账户编号
    ,pay_acct_name -- 支付账户名称
    ,intnal_acct_id -- 内部账户编号
    ,intnal_acct_name -- 内部账户名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,recvbl_bank_ibank_no -- 收款银行联行号
    ,recvbl_bank_name -- 收款银行名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,postsc -- 附言
    ,ova_flow_num -- 全局流水号
    ,core_flow_num -- 核心流水号
    ,unionpay_mercht_order_no -- 银联商户订单号
    ,unionpay_tran_flow_num -- 银联交易流水号
    ,unionpay_tran_dt -- 银联交易日期
    ,agt_corp_type_cd -- 协议单位类型代码
    ,agency_id -- 代理商编号
    ,agt_corp_id -- 协议单位编号
    ,agt_corp_name -- 协议单位名称
    ,api_sys_idf -- API系统标识
    ,teller_id -- 柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_payfan_indent_info_h_amssf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,payfan_chn_id -- 代付渠道编号
    ,tran_code -- 交易码
    ,curr_cd -- 币种代码
    ,tran_type_cd -- 交易类型代码
    ,tran_status_cd -- 交易状态代码
    ,tran_amt -- 交易金额
    ,batch_no -- 批次号
    ,batch_rgst_status_cd -- 批次登记状态代码
    ,tot -- 总笔数
    ,sucs_tran_amt -- 成功交易金额
    ,sucs_tran_cnt -- 成功交易笔数
    ,fail_tran_amt -- 失败交易金额
    ,fail_tran_cnt -- 失败交易笔数
    ,chn_order_no -- 渠道订单号
    ,resp_code -- 响应码
    ,resp_code_descb -- 响应码描述
    ,mercht_id -- 商户编号
    ,pay_acct_type_cd -- 支付账户类型代码
    ,pay_acct_id -- 支付账户编号
    ,pay_acct_name -- 支付账户名称
    ,intnal_acct_id -- 内部账户编号
    ,intnal_acct_name -- 内部账户名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,recvbl_bank_ibank_no -- 收款银行联行号
    ,recvbl_bank_name -- 收款银行名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,postsc -- 附言
    ,ova_flow_num -- 全局流水号
    ,core_flow_num -- 核心流水号
    ,unionpay_mercht_order_no -- 银联商户订单号
    ,unionpay_tran_flow_num -- 银联交易流水号
    ,unionpay_tran_dt -- 银联交易日期
    ,agt_corp_type_cd -- 协议单位类型代码
    ,agency_id -- 代理商编号
    ,agt_corp_id -- 协议单位编号
    ,agt_corp_name -- 协议单位名称
    ,api_sys_idf -- API系统标识
    ,teller_id -- 柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.payfan_chn_id, o.payfan_chn_id) as payfan_chn_id -- 代付渠道编号
    ,nvl(n.tran_code, o.tran_code) as tran_code -- 交易码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.tran_type_cd, o.tran_type_cd) as tran_type_cd -- 交易类型代码
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 批次号
    ,nvl(n.batch_rgst_status_cd, o.batch_rgst_status_cd) as batch_rgst_status_cd -- 批次登记状态代码
    ,nvl(n.tot, o.tot) as tot -- 总笔数
    ,nvl(n.sucs_tran_amt, o.sucs_tran_amt) as sucs_tran_amt -- 成功交易金额
    ,nvl(n.sucs_tran_cnt, o.sucs_tran_cnt) as sucs_tran_cnt -- 成功交易笔数
    ,nvl(n.fail_tran_amt, o.fail_tran_amt) as fail_tran_amt -- 失败交易金额
    ,nvl(n.fail_tran_cnt, o.fail_tran_cnt) as fail_tran_cnt -- 失败交易笔数
    ,nvl(n.chn_order_no, o.chn_order_no) as chn_order_no -- 渠道订单号
    ,nvl(n.resp_code, o.resp_code) as resp_code -- 响应码
    ,nvl(n.resp_code_descb, o.resp_code_descb) as resp_code_descb -- 响应码描述
    ,nvl(n.mercht_id, o.mercht_id) as mercht_id -- 商户编号
    ,nvl(n.pay_acct_type_cd, o.pay_acct_type_cd) as pay_acct_type_cd -- 支付账户类型代码
    ,nvl(n.pay_acct_id, o.pay_acct_id) as pay_acct_id -- 支付账户编号
    ,nvl(n.pay_acct_name, o.pay_acct_name) as pay_acct_name -- 支付账户名称
    ,nvl(n.intnal_acct_id, o.intnal_acct_id) as intnal_acct_id -- 内部账户编号
    ,nvl(n.intnal_acct_name, o.intnal_acct_name) as intnal_acct_name -- 内部账户名称
    ,nvl(n.recvbl_acct_id, o.recvbl_acct_id) as recvbl_acct_id -- 收款账户编号
    ,nvl(n.recvbl_acct_name, o.recvbl_acct_name) as recvbl_acct_name -- 收款账户名称
    ,nvl(n.recvbl_acct_type_cd, o.recvbl_acct_type_cd) as recvbl_acct_type_cd -- 收款账户类型代码
    ,nvl(n.recvbl_bank_ibank_no, o.recvbl_bank_ibank_no) as recvbl_bank_ibank_no -- 收款银行联行号
    ,nvl(n.recvbl_bank_name, o.recvbl_bank_name) as recvbl_bank_name -- 收款银行名称
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.mobile_no, o.mobile_no) as mobile_no -- 手机号码
    ,nvl(n.postsc, o.postsc) as postsc -- 附言
    ,nvl(n.ova_flow_num, o.ova_flow_num) as ova_flow_num -- 全局流水号
    ,nvl(n.core_flow_num, o.core_flow_num) as core_flow_num -- 核心流水号
    ,nvl(n.unionpay_mercht_order_no, o.unionpay_mercht_order_no) as unionpay_mercht_order_no -- 银联商户订单号
    ,nvl(n.unionpay_tran_flow_num, o.unionpay_tran_flow_num) as unionpay_tran_flow_num -- 银联交易流水号
    ,nvl(n.unionpay_tran_dt, o.unionpay_tran_dt) as unionpay_tran_dt -- 银联交易日期
    ,nvl(n.agt_corp_type_cd, o.agt_corp_type_cd) as agt_corp_type_cd -- 协议单位类型代码
    ,nvl(n.agency_id, o.agency_id) as agency_id -- 代理商编号
    ,nvl(n.agt_corp_id, o.agt_corp_id) as agt_corp_id -- 协议单位编号
    ,nvl(n.agt_corp_name, o.agt_corp_name) as agt_corp_name -- 协议单位名称
    ,nvl(n.api_sys_idf, o.api_sys_idf) as api_sys_idf -- API系统标识
    ,nvl(n.teller_id, o.teller_id) as teller_id -- 柜员编号
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_payfan_indent_info_h_amssf1_tm n
    full join (select * from ${iml_schema}.agt_payfan_indent_info_h_amssf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.tran_flow_num <> n.tran_flow_num
        or o.tran_dt <> n.tran_dt
        or o.payfan_chn_id <> n.payfan_chn_id
        or o.tran_code <> n.tran_code
        or o.curr_cd <> n.curr_cd
        or o.tran_type_cd <> n.tran_type_cd
        or o.tran_status_cd <> n.tran_status_cd
        or o.tran_amt <> n.tran_amt
        or o.batch_no <> n.batch_no
        or o.batch_rgst_status_cd <> n.batch_rgst_status_cd
        or o.tot <> n.tot
        or o.sucs_tran_amt <> n.sucs_tran_amt
        or o.sucs_tran_cnt <> n.sucs_tran_cnt
        or o.fail_tran_amt <> n.fail_tran_amt
        or o.fail_tran_cnt <> n.fail_tran_cnt
        or o.chn_order_no <> n.chn_order_no
        or o.resp_code <> n.resp_code
        or o.resp_code_descb <> n.resp_code_descb
        or o.mercht_id <> n.mercht_id
        or o.pay_acct_type_cd <> n.pay_acct_type_cd
        or o.pay_acct_id <> n.pay_acct_id
        or o.pay_acct_name <> n.pay_acct_name
        or o.intnal_acct_id <> n.intnal_acct_id
        or o.intnal_acct_name <> n.intnal_acct_name
        or o.recvbl_acct_id <> n.recvbl_acct_id
        or o.recvbl_acct_name <> n.recvbl_acct_name
        or o.recvbl_acct_type_cd <> n.recvbl_acct_type_cd
        or o.recvbl_bank_ibank_no <> n.recvbl_bank_ibank_no
        or o.recvbl_bank_name <> n.recvbl_bank_name
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_no <> n.cert_no
        or o.mobile_no <> n.mobile_no
        or o.postsc <> n.postsc
        or o.ova_flow_num <> n.ova_flow_num
        or o.core_flow_num <> n.core_flow_num
        or o.unionpay_mercht_order_no <> n.unionpay_mercht_order_no
        or o.unionpay_tran_flow_num <> n.unionpay_tran_flow_num
        or o.unionpay_tran_dt <> n.unionpay_tran_dt
        or o.agt_corp_type_cd <> n.agt_corp_type_cd
        or o.agency_id <> n.agency_id
        or o.agt_corp_id <> n.agt_corp_id
        or o.agt_corp_name <> n.agt_corp_name
        or o.api_sys_idf <> n.api_sys_idf
        or o.teller_id <> n.teller_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_payfan_indent_info_h_amssf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,payfan_chn_id -- 代付渠道编号
    ,tran_code -- 交易码
    ,curr_cd -- 币种代码
    ,tran_type_cd -- 交易类型代码
    ,tran_status_cd -- 交易状态代码
    ,tran_amt -- 交易金额
    ,batch_no -- 批次号
    ,batch_rgst_status_cd -- 批次登记状态代码
    ,tot -- 总笔数
    ,sucs_tran_amt -- 成功交易金额
    ,sucs_tran_cnt -- 成功交易笔数
    ,fail_tran_amt -- 失败交易金额
    ,fail_tran_cnt -- 失败交易笔数
    ,chn_order_no -- 渠道订单号
    ,resp_code -- 响应码
    ,resp_code_descb -- 响应码描述
    ,mercht_id -- 商户编号
    ,pay_acct_type_cd -- 支付账户类型代码
    ,pay_acct_id -- 支付账户编号
    ,pay_acct_name -- 支付账户名称
    ,intnal_acct_id -- 内部账户编号
    ,intnal_acct_name -- 内部账户名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,recvbl_bank_ibank_no -- 收款银行联行号
    ,recvbl_bank_name -- 收款银行名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,postsc -- 附言
    ,ova_flow_num -- 全局流水号
    ,core_flow_num -- 核心流水号
    ,unionpay_mercht_order_no -- 银联商户订单号
    ,unionpay_tran_flow_num -- 银联交易流水号
    ,unionpay_tran_dt -- 银联交易日期
    ,agt_corp_type_cd -- 协议单位类型代码
    ,agency_id -- 代理商编号
    ,agt_corp_id -- 协议单位编号
    ,agt_corp_name -- 协议单位名称
    ,api_sys_idf -- API系统标识
    ,teller_id -- 柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_payfan_indent_info_h_amssf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,payfan_chn_id -- 代付渠道编号
    ,tran_code -- 交易码
    ,curr_cd -- 币种代码
    ,tran_type_cd -- 交易类型代码
    ,tran_status_cd -- 交易状态代码
    ,tran_amt -- 交易金额
    ,batch_no -- 批次号
    ,batch_rgst_status_cd -- 批次登记状态代码
    ,tot -- 总笔数
    ,sucs_tran_amt -- 成功交易金额
    ,sucs_tran_cnt -- 成功交易笔数
    ,fail_tran_amt -- 失败交易金额
    ,fail_tran_cnt -- 失败交易笔数
    ,chn_order_no -- 渠道订单号
    ,resp_code -- 响应码
    ,resp_code_descb -- 响应码描述
    ,mercht_id -- 商户编号
    ,pay_acct_type_cd -- 支付账户类型代码
    ,pay_acct_id -- 支付账户编号
    ,pay_acct_name -- 支付账户名称
    ,intnal_acct_id -- 内部账户编号
    ,intnal_acct_name -- 内部账户名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,recvbl_bank_ibank_no -- 收款银行联行号
    ,recvbl_bank_name -- 收款银行名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,postsc -- 附言
    ,ova_flow_num -- 全局流水号
    ,core_flow_num -- 核心流水号
    ,unionpay_mercht_order_no -- 银联商户订单号
    ,unionpay_tran_flow_num -- 银联交易流水号
    ,unionpay_tran_dt -- 银联交易日期
    ,agt_corp_type_cd -- 协议单位类型代码
    ,agency_id -- 代理商编号
    ,agt_corp_id -- 协议单位编号
    ,agt_corp_name -- 协议单位名称
    ,api_sys_idf -- API系统标识
    ,teller_id -- 柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.tran_flow_num -- 交易流水号
    ,o.tran_dt -- 交易日期
    ,o.payfan_chn_id -- 代付渠道编号
    ,o.tran_code -- 交易码
    ,o.curr_cd -- 币种代码
    ,o.tran_type_cd -- 交易类型代码
    ,o.tran_status_cd -- 交易状态代码
    ,o.tran_amt -- 交易金额
    ,o.batch_no -- 批次号
    ,o.batch_rgst_status_cd -- 批次登记状态代码
    ,o.tot -- 总笔数
    ,o.sucs_tran_amt -- 成功交易金额
    ,o.sucs_tran_cnt -- 成功交易笔数
    ,o.fail_tran_amt -- 失败交易金额
    ,o.fail_tran_cnt -- 失败交易笔数
    ,o.chn_order_no -- 渠道订单号
    ,o.resp_code -- 响应码
    ,o.resp_code_descb -- 响应码描述
    ,o.mercht_id -- 商户编号
    ,o.pay_acct_type_cd -- 支付账户类型代码
    ,o.pay_acct_id -- 支付账户编号
    ,o.pay_acct_name -- 支付账户名称
    ,o.intnal_acct_id -- 内部账户编号
    ,o.intnal_acct_name -- 内部账户名称
    ,o.recvbl_acct_id -- 收款账户编号
    ,o.recvbl_acct_name -- 收款账户名称
    ,o.recvbl_acct_type_cd -- 收款账户类型代码
    ,o.recvbl_bank_ibank_no -- 收款银行联行号
    ,o.recvbl_bank_name -- 收款银行名称
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_no -- 证件号码
    ,o.mobile_no -- 手机号码
    ,o.postsc -- 附言
    ,o.ova_flow_num -- 全局流水号
    ,o.core_flow_num -- 核心流水号
    ,o.unionpay_mercht_order_no -- 银联商户订单号
    ,o.unionpay_tran_flow_num -- 银联交易流水号
    ,o.unionpay_tran_dt -- 银联交易日期
    ,o.agt_corp_type_cd -- 协议单位类型代码
    ,o.agency_id -- 代理商编号
    ,o.agt_corp_id -- 协议单位编号
    ,o.agt_corp_name -- 协议单位名称
    ,o.api_sys_idf -- API系统标识
    ,o.teller_id -- 柜员编号
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
from ${iml_schema}.agt_payfan_indent_info_h_amssf1_bk o
    left join ${iml_schema}.agt_payfan_indent_info_h_amssf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_payfan_indent_info_h_amssf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_payfan_indent_info_h;
--alter table ${iml_schema}.agt_payfan_indent_info_h truncate partition for ('amssf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_payfan_indent_info_h') 
               and substr(subpartition_name,1,8)=upper('p_amssf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_payfan_indent_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_payfan_indent_info_h modify partition p_amssf1 
add subpartition p_amssf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_payfan_indent_info_h exchange subpartition p_amssf1_${batch_date} with table ${iml_schema}.agt_payfan_indent_info_h_amssf1_cl;
alter table ${iml_schema}.agt_payfan_indent_info_h exchange subpartition p_amssf1_20991231 with table ${iml_schema}.agt_payfan_indent_info_h_amssf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_payfan_indent_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_payfan_indent_info_h_amssf1_tm purge;
drop table ${iml_schema}.agt_payfan_indent_info_h_amssf1_op purge;
drop table ${iml_schema}.agt_payfan_indent_info_h_amssf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_payfan_indent_info_h_amssf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_payfan_indent_info_h', partname => 'p_amssf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
