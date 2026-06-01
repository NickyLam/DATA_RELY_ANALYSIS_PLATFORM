/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_web_mall_indent_info_h_mrmsi1
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
alter table ${iml_schema}.evt_web_mall_indent_info_h add partition p_mrmsi1 values ('mrmsi1')(
        subpartition p_mrmsi1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mrmsi1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_web_mall_indent_info_h_mrmsi1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_web_mall_indent_info_h partition for ('mrmsi1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_web_mall_indent_info_h_mrmsi1_tm purge;
drop table ${iml_schema}.evt_web_mall_indent_info_h_mrmsi1_op purge;
drop table ${iml_schema}.evt_web_mall_indent_info_h_mrmsi1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_web_mall_indent_info_h_mrmsi1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,indent_flow_num -- 订单流水号
    ,tran_flow_num -- 交易流水号
    ,init_indent_flow_num -- 原订单流水号
    ,init_indent_tran_dt -- 原订单交易日期
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_code -- 交易码
    ,tran_status_cd -- 交易状态代码
    ,pay_sucs_dt -- 付款成功日期
    ,pay_sucs_tm -- 付款成功时间
    ,resp_code -- 响应码
    ,resp_code_descb -- 响应码描述
    ,pay_card_num -- 支付卡号
    ,card_name -- 卡名称
    ,ibank_no -- 银行联行号
    ,bank_name -- 银行名称
    ,card_type_cd -- 卡类型代码
    ,recv_bill_brch_id -- 收单分行编号
    ,caller_ova_flow_num -- 调用方全局流水号
    ,caller_onl_ova_flow_num -- 调用方联机全局流水号
    ,dispatch_status_cd -- 发货状态代码
    ,pick_goods_way_cd -- 提货方式代码
    ,mercht_no -- 商户号
    ,recver_name -- 收货人名称
    ,recver_mobile_no -- 收货人手机号码
    ,recver_local_prov -- 收货人所在省
    ,recver_local_city -- 收货人所在市
    ,recver_local_rg_county -- 收货人所在区县
    ,recver_local_town -- 收货人所在镇
    ,recver_dtl_addr -- 收货人详细地址
    ,indent_tot_amt -- 订单总金额
    ,indent_point_type_cd -- 订单积分类型代码
    ,indent_tot_point -- 订单总积分
    ,fregt_amt -- 运费金额
    ,cust_id -- 交易客户编号
    ,cust_name -- 客户名称
    ,cust_open_acct_org_id -- 客户开户机构编号
    ,bank_cust_mgr_id -- 银行客户经理编号
    ,tot_comm_fee_inco -- 总手续费收入
    ,agency_id -- 代理商编号
    ,pay_card_open_org_id -- 支付卡开户机构编号
    ,tran_org_id -- 交易机构编号
    ,surp_aval_amt -- 剩余可用金额
    ,surp_aval_point -- 剩余可用积分
    ,point_mall_order_no -- 积分商城订单号
    ,merchd_type_cd -- 商品类型代码
    ,remark -- 备注
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_web_mall_indent_info_h partition for ('mrmsi1')
where 0=1
;

create table ${iml_schema}.evt_web_mall_indent_info_h_mrmsi1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_web_mall_indent_info_h partition for ('mrmsi1') where 0=1;

create table ${iml_schema}.evt_web_mall_indent_info_h_mrmsi1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_web_mall_indent_info_h partition for ('mrmsi1') where 0=1;

-- 3.1 get new data into table
-- mrms_tbl_jf_order_txn-
insert into ${iml_schema}.evt_web_mall_indent_info_h_mrmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,indent_flow_num -- 订单流水号
    ,tran_flow_num -- 交易流水号
    ,init_indent_flow_num -- 原订单流水号
    ,init_indent_tran_dt -- 原订单交易日期
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_code -- 交易码
    ,tran_status_cd -- 交易状态代码
    ,pay_sucs_dt -- 付款成功日期
    ,pay_sucs_tm -- 付款成功时间
    ,resp_code -- 响应码
    ,resp_code_descb -- 响应码描述
    ,pay_card_num -- 支付卡号
    ,card_name -- 卡名称
    ,ibank_no -- 银行联行号
    ,bank_name -- 银行名称
    ,card_type_cd -- 卡类型代码
    ,recv_bill_brch_id -- 收单分行编号
    ,caller_ova_flow_num -- 调用方全局流水号
    ,caller_onl_ova_flow_num -- 调用方联机全局流水号
    ,dispatch_status_cd -- 发货状态代码
    ,pick_goods_way_cd -- 提货方式代码
    ,mercht_no -- 商户号
    ,recver_name -- 收货人名称
    ,recver_mobile_no -- 收货人手机号码
    ,recver_local_prov -- 收货人所在省
    ,recver_local_city -- 收货人所在市
    ,recver_local_rg_county -- 收货人所在区县
    ,recver_local_town -- 收货人所在镇
    ,recver_dtl_addr -- 收货人详细地址
    ,indent_tot_amt -- 订单总金额
    ,indent_point_type_cd -- 订单积分类型代码
    ,indent_tot_point -- 订单总积分
    ,fregt_amt -- 运费金额
    ,cust_id -- 交易客户编号
    ,cust_name -- 客户名称
    ,cust_open_acct_org_id -- 客户开户机构编号
    ,bank_cust_mgr_id -- 银行客户经理编号
    ,tot_comm_fee_inco -- 总手续费收入
    ,agency_id -- 代理商编号
    ,pay_card_open_org_id -- 支付卡开户机构编号
    ,tran_org_id -- 交易机构编号
    ,surp_aval_amt -- 剩余可用金额
    ,surp_aval_point -- 剩余可用积分
    ,point_mall_order_no -- 积分商城订单号
    ,merchd_type_cd -- 商品类型代码
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104033'||P1.KEY_RSP -- 事件编号
    ,'9999' -- 法人编号
    ,P1.KEY_RSP -- 订单流水号
    ,P1.ORDER_NO -- 交易流水号
    ,P1.OGL_ORD_ID -- 原订单流水号
    ,${iml_schema}.DATEFORMAT_MIN(P1.OGL_ORD_DATE) -- 原订单交易日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.INST_DATE) -- 交易日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.INST_DATE||P1.INST_TIME) -- 交易时间
    ,NVL(TRIM(P1.TXN_NUM),'-') -- 交易码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.TXN_STA END -- 交易状态代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.SUCCESSDATE) -- 付款成功日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.SUCCESSDATE||P1.SUCCESSTIME) -- 付款成功时间
    ,P1.RES_CODE -- 响应码
    ,P1.RES_DESC -- 响应码描述
    ,P1.CARD_NO -- 支付卡号
    ,P1.CARD_NAME -- 卡名称
    ,P1.OPEN_BK_NUM -- 银行联行号
    ,P1.OPEN_BK_NAME -- 银行名称
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CARD_TYPE END -- 卡类型代码
    ,P1.BRH_ID -- 收单分行编号
    ,P1.JF_PPP_KEY_IH -- 调用方全局流水号
    ,P1.TRAN_SEQ_NO_IH -- 调用方联机全局流水号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.SHIP_STATUS END -- 发货状态代码
    ,NVL(TRIM(P1.PICK_GOODS_MODE),'-') -- 提货方式代码
    ,P1.MCHT_NO -- 商户号
    ,P1.REVEIVER_NAME -- 收货人名称
    ,P1.REVEIVER_PHONE -- 收货人手机号码
    ,P1.REVEIVER_PROVICE -- 收货人所在省
    ,P1.REVEIVER_CITY -- 收货人所在市
    ,P1.REVEIVER_COUNTY -- 收货人所在区县
    ,P1.REVEIVER_TOWN -- 收货人所在镇
    ,P1.REVEIVER_ADDR -- 收货人详细地址
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.TOTAL_MONEY, '[0-9.]+')),0)) -- 订单总金额
    ,NVL(TRIM(P1.TRADE_TYPE),'-') -- 订单积分类型代码
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.TOTAL_POINT, '[0-9.]+')),0)) -- 订单总积分
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.FREIGHT_FEE, '[0-9.]+')),0)) -- 运费金额
    ,P1.PTY_ID -- 交易客户编号
    ,P1.PTY_NAME -- 客户名称
    ,P1.PTY_OPEN_ORG -- 客户开户机构编号
    ,P1.PTY_MGR_NUM -- 银行客户经理编号
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.GROSS_FEE, '[0-9.]+')),0)) -- 总手续费收入
    ,P1.AGENT_NO -- 代理商编号
    ,P1.OPEN_ORG_NUM -- 支付卡开户机构编号
    ,P1.TXN_ORG_NUM -- 交易机构编号
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.USABLE_MONEY, '[0-9.]+')),0)) -- 剩余可用金额
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.USABLE_POINT, '[0-9.]+')),0)) -- 剩余可用积分
    ,P1.SHOP_ORDER_ID -- 积分商城订单号
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.MRCHD_TYP END -- 商品类型代码
    ,P1.ADDDATA1 -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mrms_tbl_jf_order_txn' -- 源表名称
    ,'mrmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mrms_tbl_jf_order_txn p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.TXN_STA= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MRMS'
        AND R1.SRC_TAB_EN_NAME= 'MRMS_TBL_JF_ORDER_TXN'
        AND R1.SRC_FIELD_EN_NAME= 'TXN_STA'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_WEB_MALL_INDENT_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TRAN_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CARD_TYPE= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MRMS'
        AND R2.SRC_TAB_EN_NAME= 'MRMS_TBL_JF_ORDER_TXN'
        AND R2.SRC_FIELD_EN_NAME= 'CARD_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_WEB_MALL_INDENT_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CARD_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.SHIP_STATUS= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'MRMS'
        AND R3.SRC_TAB_EN_NAME= 'MRMS_TBL_JF_ORDER_TXN'
        AND R3.SRC_FIELD_EN_NAME= 'SHIP_STATUS'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_WEB_MALL_INDENT_INFO_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'DISPATCH_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.MRCHD_TYP= R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'MRMS'
        AND R4.SRC_TAB_EN_NAME= 'MRMS_TBL_JF_ORDER_TXN'
        AND R4.SRC_FIELD_EN_NAME= 'MRCHD_TYP'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_WEB_MALL_INDENT_INFO_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'MERCHD_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_web_mall_indent_info_h_mrmsi1_tm 
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
        into ${iml_schema}.evt_web_mall_indent_info_h_mrmsi1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,indent_flow_num -- 订单流水号
    ,tran_flow_num -- 交易流水号
    ,init_indent_flow_num -- 原订单流水号
    ,init_indent_tran_dt -- 原订单交易日期
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_code -- 交易码
    ,tran_status_cd -- 交易状态代码
    ,pay_sucs_dt -- 付款成功日期
    ,pay_sucs_tm -- 付款成功时间
    ,resp_code -- 响应码
    ,resp_code_descb -- 响应码描述
    ,pay_card_num -- 支付卡号
    ,card_name -- 卡名称
    ,ibank_no -- 银行联行号
    ,bank_name -- 银行名称
    ,card_type_cd -- 卡类型代码
    ,recv_bill_brch_id -- 收单分行编号
    ,caller_ova_flow_num -- 调用方全局流水号
    ,caller_onl_ova_flow_num -- 调用方联机全局流水号
    ,dispatch_status_cd -- 发货状态代码
    ,pick_goods_way_cd -- 提货方式代码
    ,mercht_no -- 商户号
    ,recver_name -- 收货人名称
    ,recver_mobile_no -- 收货人手机号码
    ,recver_local_prov -- 收货人所在省
    ,recver_local_city -- 收货人所在市
    ,recver_local_rg_county -- 收货人所在区县
    ,recver_local_town -- 收货人所在镇
    ,recver_dtl_addr -- 收货人详细地址
    ,indent_tot_amt -- 订单总金额
    ,indent_point_type_cd -- 订单积分类型代码
    ,indent_tot_point -- 订单总积分
    ,fregt_amt -- 运费金额
    ,cust_id -- 交易客户编号
    ,cust_name -- 客户名称
    ,cust_open_acct_org_id -- 客户开户机构编号
    ,bank_cust_mgr_id -- 银行客户经理编号
    ,tot_comm_fee_inco -- 总手续费收入
    ,agency_id -- 代理商编号
    ,pay_card_open_org_id -- 支付卡开户机构编号
    ,tran_org_id -- 交易机构编号
    ,surp_aval_amt -- 剩余可用金额
    ,surp_aval_point -- 剩余可用积分
    ,point_mall_order_no -- 积分商城订单号
    ,merchd_type_cd -- 商品类型代码
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_web_mall_indent_info_h_mrmsi1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,indent_flow_num -- 订单流水号
    ,tran_flow_num -- 交易流水号
    ,init_indent_flow_num -- 原订单流水号
    ,init_indent_tran_dt -- 原订单交易日期
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_code -- 交易码
    ,tran_status_cd -- 交易状态代码
    ,pay_sucs_dt -- 付款成功日期
    ,pay_sucs_tm -- 付款成功时间
    ,resp_code -- 响应码
    ,resp_code_descb -- 响应码描述
    ,pay_card_num -- 支付卡号
    ,card_name -- 卡名称
    ,ibank_no -- 银行联行号
    ,bank_name -- 银行名称
    ,card_type_cd -- 卡类型代码
    ,recv_bill_brch_id -- 收单分行编号
    ,caller_ova_flow_num -- 调用方全局流水号
    ,caller_onl_ova_flow_num -- 调用方联机全局流水号
    ,dispatch_status_cd -- 发货状态代码
    ,pick_goods_way_cd -- 提货方式代码
    ,mercht_no -- 商户号
    ,recver_name -- 收货人名称
    ,recver_mobile_no -- 收货人手机号码
    ,recver_local_prov -- 收货人所在省
    ,recver_local_city -- 收货人所在市
    ,recver_local_rg_county -- 收货人所在区县
    ,recver_local_town -- 收货人所在镇
    ,recver_dtl_addr -- 收货人详细地址
    ,indent_tot_amt -- 订单总金额
    ,indent_point_type_cd -- 订单积分类型代码
    ,indent_tot_point -- 订单总积分
    ,fregt_amt -- 运费金额
    ,cust_id -- 交易客户编号
    ,cust_name -- 客户名称
    ,cust_open_acct_org_id -- 客户开户机构编号
    ,bank_cust_mgr_id -- 银行客户经理编号
    ,tot_comm_fee_inco -- 总手续费收入
    ,agency_id -- 代理商编号
    ,pay_card_open_org_id -- 支付卡开户机构编号
    ,tran_org_id -- 交易机构编号
    ,surp_aval_amt -- 剩余可用金额
    ,surp_aval_point -- 剩余可用积分
    ,point_mall_order_no -- 积分商城订单号
    ,merchd_type_cd -- 商品类型代码
    ,remark -- 备注
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
    ,nvl(n.indent_flow_num, o.indent_flow_num) as indent_flow_num -- 订单流水号
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,nvl(n.init_indent_flow_num, o.init_indent_flow_num) as init_indent_flow_num -- 原订单流水号
    ,nvl(n.init_indent_tran_dt, o.init_indent_tran_dt) as init_indent_tran_dt -- 原订单交易日期
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.tran_code, o.tran_code) as tran_code -- 交易码
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.pay_sucs_dt, o.pay_sucs_dt) as pay_sucs_dt -- 付款成功日期
    ,nvl(n.pay_sucs_tm, o.pay_sucs_tm) as pay_sucs_tm -- 付款成功时间
    ,nvl(n.resp_code, o.resp_code) as resp_code -- 响应码
    ,nvl(n.resp_code_descb, o.resp_code_descb) as resp_code_descb -- 响应码描述
    ,nvl(n.pay_card_num, o.pay_card_num) as pay_card_num -- 支付卡号
    ,nvl(n.card_name, o.card_name) as card_name -- 卡名称
    ,nvl(n.ibank_no, o.ibank_no) as ibank_no -- 银行联行号
    ,nvl(n.bank_name, o.bank_name) as bank_name -- 银行名称
    ,nvl(n.card_type_cd, o.card_type_cd) as card_type_cd -- 卡类型代码
    ,nvl(n.recv_bill_brch_id, o.recv_bill_brch_id) as recv_bill_brch_id -- 收单分行编号
    ,nvl(n.caller_ova_flow_num, o.caller_ova_flow_num) as caller_ova_flow_num -- 调用方全局流水号
    ,nvl(n.caller_onl_ova_flow_num, o.caller_onl_ova_flow_num) as caller_onl_ova_flow_num -- 调用方联机全局流水号
    ,nvl(n.dispatch_status_cd, o.dispatch_status_cd) as dispatch_status_cd -- 发货状态代码
    ,nvl(n.pick_goods_way_cd, o.pick_goods_way_cd) as pick_goods_way_cd -- 提货方式代码
    ,nvl(n.mercht_no, o.mercht_no) as mercht_no -- 商户号
    ,nvl(n.recver_name, o.recver_name) as recver_name -- 收货人名称
    ,nvl(n.recver_mobile_no, o.recver_mobile_no) as recver_mobile_no -- 收货人手机号码
    ,nvl(n.recver_local_prov, o.recver_local_prov) as recver_local_prov -- 收货人所在省
    ,nvl(n.recver_local_city, o.recver_local_city) as recver_local_city -- 收货人所在市
    ,nvl(n.recver_local_rg_county, o.recver_local_rg_county) as recver_local_rg_county -- 收货人所在区县
    ,nvl(n.recver_local_town, o.recver_local_town) as recver_local_town -- 收货人所在镇
    ,nvl(n.recver_dtl_addr, o.recver_dtl_addr) as recver_dtl_addr -- 收货人详细地址
    ,nvl(n.indent_tot_amt, o.indent_tot_amt) as indent_tot_amt -- 订单总金额
    ,nvl(n.indent_point_type_cd, o.indent_point_type_cd) as indent_point_type_cd -- 订单积分类型代码
    ,nvl(n.indent_tot_point, o.indent_tot_point) as indent_tot_point -- 订单总积分
    ,nvl(n.fregt_amt, o.fregt_amt) as fregt_amt -- 运费金额
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 交易客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cust_open_acct_org_id, o.cust_open_acct_org_id) as cust_open_acct_org_id -- 客户开户机构编号
    ,nvl(n.bank_cust_mgr_id, o.bank_cust_mgr_id) as bank_cust_mgr_id -- 银行客户经理编号
    ,nvl(n.tot_comm_fee_inco, o.tot_comm_fee_inco) as tot_comm_fee_inco -- 总手续费收入
    ,nvl(n.agency_id, o.agency_id) as agency_id -- 代理商编号
    ,nvl(n.pay_card_open_org_id, o.pay_card_open_org_id) as pay_card_open_org_id -- 支付卡开户机构编号
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.surp_aval_amt, o.surp_aval_amt) as surp_aval_amt -- 剩余可用金额
    ,nvl(n.surp_aval_point, o.surp_aval_point) as surp_aval_point -- 剩余可用积分
    ,nvl(n.point_mall_order_no, o.point_mall_order_no) as point_mall_order_no -- 积分商城订单号
    ,nvl(n.merchd_type_cd, o.merchd_type_cd) as merchd_type_cd -- 商品类型代码
    ,nvl(n.remark, o.remark) as remark -- 备注
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
from ${iml_schema}.evt_web_mall_indent_info_h_mrmsi1_tm n
    full join (select * from ${iml_schema}.evt_web_mall_indent_info_h_mrmsi1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.indent_flow_num <> n.indent_flow_num
        or o.tran_flow_num <> n.tran_flow_num
        or o.init_indent_flow_num <> n.init_indent_flow_num
        or o.init_indent_tran_dt <> n.init_indent_tran_dt
        or o.tran_dt <> n.tran_dt
        or o.tran_tm <> n.tran_tm
        or o.tran_code <> n.tran_code
        or o.tran_status_cd <> n.tran_status_cd
        or o.pay_sucs_dt <> n.pay_sucs_dt
        or o.pay_sucs_tm <> n.pay_sucs_tm
        or o.resp_code <> n.resp_code
        or o.resp_code_descb <> n.resp_code_descb
        or o.pay_card_num <> n.pay_card_num
        or o.card_name <> n.card_name
        or o.ibank_no <> n.ibank_no
        or o.bank_name <> n.bank_name
        or o.card_type_cd <> n.card_type_cd
        or o.recv_bill_brch_id <> n.recv_bill_brch_id
        or o.caller_ova_flow_num <> n.caller_ova_flow_num
        or o.caller_onl_ova_flow_num <> n.caller_onl_ova_flow_num
        or o.dispatch_status_cd <> n.dispatch_status_cd
        or o.pick_goods_way_cd <> n.pick_goods_way_cd
        or o.mercht_no <> n.mercht_no
        or o.recver_name <> n.recver_name
        or o.recver_mobile_no <> n.recver_mobile_no
        or o.recver_local_prov <> n.recver_local_prov
        or o.recver_local_city <> n.recver_local_city
        or o.recver_local_rg_county <> n.recver_local_rg_county
        or o.recver_local_town <> n.recver_local_town
        or o.recver_dtl_addr <> n.recver_dtl_addr
        or o.indent_tot_amt <> n.indent_tot_amt
        or o.indent_point_type_cd <> n.indent_point_type_cd
        or o.indent_tot_point <> n.indent_tot_point
        or o.fregt_amt <> n.fregt_amt
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.cust_open_acct_org_id <> n.cust_open_acct_org_id
        or o.bank_cust_mgr_id <> n.bank_cust_mgr_id
        or o.tot_comm_fee_inco <> n.tot_comm_fee_inco
        or o.agency_id <> n.agency_id
        or o.pay_card_open_org_id <> n.pay_card_open_org_id
        or o.tran_org_id <> n.tran_org_id
        or o.surp_aval_amt <> n.surp_aval_amt
        or o.surp_aval_point <> n.surp_aval_point
        or o.point_mall_order_no <> n.point_mall_order_no
        or o.merchd_type_cd <> n.merchd_type_cd
        or o.remark <> n.remark
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_web_mall_indent_info_h_mrmsi1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,indent_flow_num -- 订单流水号
    ,tran_flow_num -- 交易流水号
    ,init_indent_flow_num -- 原订单流水号
    ,init_indent_tran_dt -- 原订单交易日期
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_code -- 交易码
    ,tran_status_cd -- 交易状态代码
    ,pay_sucs_dt -- 付款成功日期
    ,pay_sucs_tm -- 付款成功时间
    ,resp_code -- 响应码
    ,resp_code_descb -- 响应码描述
    ,pay_card_num -- 支付卡号
    ,card_name -- 卡名称
    ,ibank_no -- 银行联行号
    ,bank_name -- 银行名称
    ,card_type_cd -- 卡类型代码
    ,recv_bill_brch_id -- 收单分行编号
    ,caller_ova_flow_num -- 调用方全局流水号
    ,caller_onl_ova_flow_num -- 调用方联机全局流水号
    ,dispatch_status_cd -- 发货状态代码
    ,pick_goods_way_cd -- 提货方式代码
    ,mercht_no -- 商户号
    ,recver_name -- 收货人名称
    ,recver_mobile_no -- 收货人手机号码
    ,recver_local_prov -- 收货人所在省
    ,recver_local_city -- 收货人所在市
    ,recver_local_rg_county -- 收货人所在区县
    ,recver_local_town -- 收货人所在镇
    ,recver_dtl_addr -- 收货人详细地址
    ,indent_tot_amt -- 订单总金额
    ,indent_point_type_cd -- 订单积分类型代码
    ,indent_tot_point -- 订单总积分
    ,fregt_amt -- 运费金额
    ,cust_id -- 交易客户编号
    ,cust_name -- 客户名称
    ,cust_open_acct_org_id -- 客户开户机构编号
    ,bank_cust_mgr_id -- 银行客户经理编号
    ,tot_comm_fee_inco -- 总手续费收入
    ,agency_id -- 代理商编号
    ,pay_card_open_org_id -- 支付卡开户机构编号
    ,tran_org_id -- 交易机构编号
    ,surp_aval_amt -- 剩余可用金额
    ,surp_aval_point -- 剩余可用积分
    ,point_mall_order_no -- 积分商城订单号
    ,merchd_type_cd -- 商品类型代码
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_web_mall_indent_info_h_mrmsi1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,indent_flow_num -- 订单流水号
    ,tran_flow_num -- 交易流水号
    ,init_indent_flow_num -- 原订单流水号
    ,init_indent_tran_dt -- 原订单交易日期
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_code -- 交易码
    ,tran_status_cd -- 交易状态代码
    ,pay_sucs_dt -- 付款成功日期
    ,pay_sucs_tm -- 付款成功时间
    ,resp_code -- 响应码
    ,resp_code_descb -- 响应码描述
    ,pay_card_num -- 支付卡号
    ,card_name -- 卡名称
    ,ibank_no -- 银行联行号
    ,bank_name -- 银行名称
    ,card_type_cd -- 卡类型代码
    ,recv_bill_brch_id -- 收单分行编号
    ,caller_ova_flow_num -- 调用方全局流水号
    ,caller_onl_ova_flow_num -- 调用方联机全局流水号
    ,dispatch_status_cd -- 发货状态代码
    ,pick_goods_way_cd -- 提货方式代码
    ,mercht_no -- 商户号
    ,recver_name -- 收货人名称
    ,recver_mobile_no -- 收货人手机号码
    ,recver_local_prov -- 收货人所在省
    ,recver_local_city -- 收货人所在市
    ,recver_local_rg_county -- 收货人所在区县
    ,recver_local_town -- 收货人所在镇
    ,recver_dtl_addr -- 收货人详细地址
    ,indent_tot_amt -- 订单总金额
    ,indent_point_type_cd -- 订单积分类型代码
    ,indent_tot_point -- 订单总积分
    ,fregt_amt -- 运费金额
    ,cust_id -- 交易客户编号
    ,cust_name -- 客户名称
    ,cust_open_acct_org_id -- 客户开户机构编号
    ,bank_cust_mgr_id -- 银行客户经理编号
    ,tot_comm_fee_inco -- 总手续费收入
    ,agency_id -- 代理商编号
    ,pay_card_open_org_id -- 支付卡开户机构编号
    ,tran_org_id -- 交易机构编号
    ,surp_aval_amt -- 剩余可用金额
    ,surp_aval_point -- 剩余可用积分
    ,point_mall_order_no -- 积分商城订单号
    ,merchd_type_cd -- 商品类型代码
    ,remark -- 备注
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
    ,o.indent_flow_num -- 订单流水号
    ,o.tran_flow_num -- 交易流水号
    ,o.init_indent_flow_num -- 原订单流水号
    ,o.init_indent_tran_dt -- 原订单交易日期
    ,o.tran_dt -- 交易日期
    ,o.tran_tm -- 交易时间
    ,o.tran_code -- 交易码
    ,o.tran_status_cd -- 交易状态代码
    ,o.pay_sucs_dt -- 付款成功日期
    ,o.pay_sucs_tm -- 付款成功时间
    ,o.resp_code -- 响应码
    ,o.resp_code_descb -- 响应码描述
    ,o.pay_card_num -- 支付卡号
    ,o.card_name -- 卡名称
    ,o.ibank_no -- 银行联行号
    ,o.bank_name -- 银行名称
    ,o.card_type_cd -- 卡类型代码
    ,o.recv_bill_brch_id -- 收单分行编号
    ,o.caller_ova_flow_num -- 调用方全局流水号
    ,o.caller_onl_ova_flow_num -- 调用方联机全局流水号
    ,o.dispatch_status_cd -- 发货状态代码
    ,o.pick_goods_way_cd -- 提货方式代码
    ,o.mercht_no -- 商户号
    ,o.recver_name -- 收货人名称
    ,o.recver_mobile_no -- 收货人手机号码
    ,o.recver_local_prov -- 收货人所在省
    ,o.recver_local_city -- 收货人所在市
    ,o.recver_local_rg_county -- 收货人所在区县
    ,o.recver_local_town -- 收货人所在镇
    ,o.recver_dtl_addr -- 收货人详细地址
    ,o.indent_tot_amt -- 订单总金额
    ,o.indent_point_type_cd -- 订单积分类型代码
    ,o.indent_tot_point -- 订单总积分
    ,o.fregt_amt -- 运费金额
    ,o.cust_id -- 交易客户编号
    ,o.cust_name -- 客户名称
    ,o.cust_open_acct_org_id -- 客户开户机构编号
    ,o.bank_cust_mgr_id -- 银行客户经理编号
    ,o.tot_comm_fee_inco -- 总手续费收入
    ,o.agency_id -- 代理商编号
    ,o.pay_card_open_org_id -- 支付卡开户机构编号
    ,o.tran_org_id -- 交易机构编号
    ,o.surp_aval_amt -- 剩余可用金额
    ,o.surp_aval_point -- 剩余可用积分
    ,o.point_mall_order_no -- 积分商城订单号
    ,o.merchd_type_cd -- 商品类型代码
    ,o.remark -- 备注
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
from ${iml_schema}.evt_web_mall_indent_info_h_mrmsi1_bk o
    left join ${iml_schema}.evt_web_mall_indent_info_h_mrmsi1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_web_mall_indent_info_h_mrmsi1_cl d
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
--truncate table ${iml_schema}.evt_web_mall_indent_info_h;
--alter table ${iml_schema}.evt_web_mall_indent_info_h truncate partition for ('mrmsi1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_web_mall_indent_info_h') 
               and substr(subpartition_name,1,8)=upper('p_mrmsi1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_web_mall_indent_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.evt_web_mall_indent_info_h modify partition p_mrmsi1 
add subpartition p_mrmsi1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_web_mall_indent_info_h exchange subpartition p_mrmsi1_${batch_date} with table ${iml_schema}.evt_web_mall_indent_info_h_mrmsi1_cl;
alter table ${iml_schema}.evt_web_mall_indent_info_h exchange subpartition p_mrmsi1_20991231 with table ${iml_schema}.evt_web_mall_indent_info_h_mrmsi1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_web_mall_indent_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_web_mall_indent_info_h_mrmsi1_tm purge;
drop table ${iml_schema}.evt_web_mall_indent_info_h_mrmsi1_op purge;
drop table ${iml_schema}.evt_web_mall_indent_info_h_mrmsi1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_web_mall_indent_info_h_mrmsi1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_web_mall_indent_info_h', partname => 'p_mrmsi1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
