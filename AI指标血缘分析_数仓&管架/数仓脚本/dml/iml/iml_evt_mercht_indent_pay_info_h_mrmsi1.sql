/*
Purpose:    整合模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_mercht_indent_pay_info_h_mrmsi1
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
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.evt_mercht_indent_pay_info_h add partition p_mrmsi1 values ('mrmsi1')(
        subpartition p_mrmsi1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mrmsi1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

create table ${iml_schema}.evt_mercht_indent_pay_info_h_mrmsi1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_mercht_indent_pay_info_h partition for ('mrmsi1') 
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_mercht_indent_pay_info_h_mrmsi1_tm purge;
drop table ${iml_schema}.evt_mercht_indent_pay_info_h_mrmsi1_op purge;
drop table ${iml_schema}.evt_mercht_indent_pay_info_h_mrmsi1_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_mercht_indent_pay_info_h_mrmsi1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,intnal_flow_num -- 内部流水号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,bus_type_cd -- 业务类型代码
    ,back_end_chn_type_cd -- 后端渠道类型代码
    ,mercht_id -- 商户编号
    ,mercht_name -- 商户名称
    ,chn_mercht_id -- 渠道商户编号
    ,chn_sub_mercht_id -- 渠道子商户编号
    ,chn_indent_flow_num -- 渠道订单流水号
    ,chn_indent_tran_dt -- 渠道订单交易日期
    ,pay_chn_fee_rat -- 支付渠道费率
    ,pay_flow_num -- 支付流水号
    ,ova_flow_num -- 全局流水号
    ,fee_rat_chn_cd -- 费率渠道代码
    ,ext_indent_id -- 外部订单编号
    ,indent_caption_name -- 订单标题名称
    ,indent_descb -- 订单描述
    ,agency_id -- 代理商编号
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,indent_bal -- 订单余额
    ,init_indent_flow_num -- 原订单流水号
    ,init_indent_tran_dt -- 原订单交易日期
    ,tran_status_cd -- 交易状态代码
    ,pay_sucs_dt -- 付款成功日期
    ,pay_sucs_tm -- 付款成功时间
    ,resp_code -- 响应码
    ,resp_code_descb -- 响应码描述
    ,rtn_goods_status_cd -- 退货状态代码
    ,on_acct_flg -- 挂账标志
    ,indent_valid_tm -- 订单有效时间
    ,pay_bank_card_id -- 支付银行卡编号
    ,termn_type_cd -- 终端类型代码
    ,recv_bill_brch_id -- 收单分行编号
    ,ext_mercht_id -- 外部商户编号
    ,pay_chn_cd -- 支付渠道代码
    ,back_end_chn_indent_id -- 后端渠道订单编号
    ,epc_g_room_flg -- 网联机房标志
    ,pay_vouch_id -- 付款凭证编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_mercht_indent_pay_info_h partition for ('mrmsi1')
where 0=1
;

create table ${iml_schema}.evt_mercht_indent_pay_info_h_mrmsi1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_mercht_indent_pay_info_h partition for ('mrmsi1') where 0=1;

create table ${iml_schema}.evt_mercht_indent_pay_info_h_mrmsi1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_mercht_indent_pay_info_h partition for ('mrmsi1') where 0=1;

-- 3.1 get new data into table
-- mrms_tbl_cp_order_txn-
insert into ${iml_schema}.evt_mercht_indent_pay_info_h_mrmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,intnal_flow_num -- 内部流水号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,bus_type_cd -- 业务类型代码
    ,back_end_chn_type_cd -- 后端渠道类型代码
    ,mercht_id -- 商户编号
    ,mercht_name -- 商户名称
    ,chn_mercht_id -- 渠道商户编号
    ,chn_sub_mercht_id -- 渠道子商户编号
    ,chn_indent_flow_num -- 渠道订单流水号
    ,chn_indent_tran_dt -- 渠道订单交易日期
    ,pay_chn_fee_rat -- 支付渠道费率
    ,pay_flow_num -- 支付流水号
    ,ova_flow_num -- 全局流水号
    ,fee_rat_chn_cd -- 费率渠道代码
    ,ext_indent_id -- 外部订单编号
    ,indent_caption_name -- 订单标题名称
    ,indent_descb -- 订单描述
    ,agency_id -- 代理商编号
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,indent_bal -- 订单余额
    ,init_indent_flow_num -- 原订单流水号
    ,init_indent_tran_dt -- 原订单交易日期
    ,tran_status_cd -- 交易状态代码
    ,pay_sucs_dt -- 付款成功日期
    ,pay_sucs_tm -- 付款成功时间
    ,resp_code -- 响应码
    ,resp_code_descb -- 响应码描述
    ,rtn_goods_status_cd -- 退货状态代码
    ,on_acct_flg -- 挂账标志
    ,indent_valid_tm -- 订单有效时间
    ,pay_bank_card_id -- 支付银行卡编号
    ,termn_type_cd -- 终端类型代码
    ,recv_bill_brch_id -- 收单分行编号
    ,ext_mercht_id -- 外部商户编号
    ,pay_chn_cd -- 支付渠道代码
    ,back_end_chn_indent_id -- 后端渠道订单编号
    ,epc_g_room_flg -- 网联机房标志
    ,pay_vouch_id -- 付款凭证编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '105011'||p1.KEY_RSP -- 事件编号
    ,'9999' -- 法人编号
    ,p1.KEY_RSP -- 内部流水号
    ,${iml_schema}.DATEFORMAT_MIN(p1.INST_DATE) -- 交易日期
    ,${iml_schema}.DATEFORMAT_MIN(p1.INST_DATE||p1.INST_TIME) -- 交易时间
    ,nvl(trim(p1.TXN_NUM),'-') -- 业务类型代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||p1.TXN_CHANNEL END -- 后端渠道类型代码
    ,p1.MCHT_NO -- 商户编号
    ,p1.MCHT_NAME -- 商户名称
    ,p1.CHANNEL_MCHT_NO -- 渠道商户编号
    ,p1.CHANNEL_SEC_MCHT_NO -- 渠道子商户编号
    ,p1.CHANNEL_SSN -- 渠道订单流水号
    ,${iml_schema}.DATEFORMAT_MIN(p1.CHANNEL_DATE) -- 渠道订单交易日期
    ,to_number(nvl(trim(decode(p1.PAY_RATE,'null','0',p1.PAY_RATE)),'0')) -- 支付渠道费率
    ,p1.ADDDATA1 -- 支付流水号
    ,p1.ADDDATA2 -- 全局流水号
    ,nvl(trim(p1.CHANNEL),'3') -- 费率渠道代码
    ,p1.OUT_ORDER_ID -- 外部订单编号
    ,p1.OUT_ORDER_TITLE -- 订单标题名称
    ,p1.OUT_ORDER_DESC -- 订单描述
    ,p1.AGENT_CD -- 代理商编号
    ,case when trim(p1.SETTLECURRENCYCODE) ='156' then 'CNY' else '-' end -- 币种代码
    ,to_number(nvl(trim(decode(p1.TRADE_MONEY,'null','0',p1.TRADE_MONEY)),'0')) -- 交易金额
    ,to_number(nvl(trim(decode(p1.ADD_MONEY,'null','0',p1.ADD_MONEY)),'0')) -- 订单余额
    ,p1.OGL_ORD_ID -- 原订单流水号
    ,${iml_schema}.DATEFORMAT_MIN(nvl(p1.OGL_ORD_DATE,'null')) -- 原订单交易日期
    ,nvl(trim(p1.TXN_STA),'-') -- 交易状态代码
    ,${iml_schema}.DATEFORMAT_MIN(p1.SUCCESSDATE) -- 付款成功日期
    ,${iml_schema}.DATEFORMAT_MIN(p1.SUCCESSDATE||p1.SUCCESSTIME) -- 付款成功时间
    ,p1.RES_CODE -- 响应码
    ,p1.RES_DESC -- 响应码描述
    ,nvl(trim(p1.UNDO_REFUND_FLAG),'-') -- 退货状态代码
    ,nvl(trim(p1.DELAY_FLAG),'-') -- 挂账标志
    ,p1.EXPIRETIME -- 订单有效时间
    ,p1.PAN -- 支付银行卡编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||p1.TERM_TYPE END -- 终端类型代码
    ,p1.BRH_ID -- 收单分行编号
    ,p1.OUT_MCHT_NO -- 外部商户编号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||p1.PAY_CHANNEL END -- 支付渠道代码
    ,p1.TRANSACTION_ID -- 后端渠道订单编号
    ,p1.IDC_FLAG -- 网联机房标志
    ,p1.VOUCHER_NUM -- 付款凭证编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mrms_tbl_cp_order_txn' -- 源表名称
    ,'mrmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mrms_tbl_cp_order_txn p1
    left join ${iml_schema}.ref_pub_cd_map r1 on nvl(trim(P1.TXN_CHANNEL),' ')= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MRMS'
        AND R1.SRC_TAB_EN_NAME= 'MRMS_TBL_CP_ORDER_TXN'
        AND R1.SRC_FIELD_EN_NAME= 'TXN_CHANNEL'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_MERCHT_INDENT_PAY_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'BACK_END_CHN_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on nvl(trim(P1.TERM_TYPE),' ')= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MRMS'
        AND R2.SRC_TAB_EN_NAME= 'MRMS_TBL_CP_ORDER_TXN'
        AND R2.SRC_FIELD_EN_NAME= 'TERM_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_MERCHT_INDENT_PAY_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'TERMN_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on nvl(trim(P1.PAY_CHANNEL),' ')= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'MRMS'
        AND R3.SRC_TAB_EN_NAME= 'MRMS_TBL_CP_ORDER_TXN'
        AND R3.SRC_FIELD_EN_NAME= 'PAY_CHANNEL'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_MERCHT_INDENT_PAY_INFO_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'PAY_CHN_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND p1.inst_date='${batch_date}'
;
commit;


commit;


whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_mercht_indent_pay_info_h_mrmsi1_tm 
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

-- 3.2 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.evt_mercht_indent_pay_info_h_mrmsi1_op(
        evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,intnal_flow_num -- 内部流水号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,bus_type_cd -- 业务类型代码
    ,back_end_chn_type_cd -- 后端渠道类型代码
    ,mercht_id -- 商户编号
    ,mercht_name -- 商户名称
    ,chn_mercht_id -- 渠道商户编号
    ,chn_sub_mercht_id -- 渠道子商户编号
    ,chn_indent_flow_num -- 渠道订单流水号
    ,chn_indent_tran_dt -- 渠道订单交易日期
    ,pay_chn_fee_rat -- 支付渠道费率
    ,pay_flow_num -- 支付流水号
    ,ova_flow_num -- 全局流水号
    ,fee_rat_chn_cd -- 费率渠道代码
    ,ext_indent_id -- 外部订单编号
    ,indent_caption_name -- 订单标题名称
    ,indent_descb -- 订单描述
    ,agency_id -- 代理商编号
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,indent_bal -- 订单余额
    ,init_indent_flow_num -- 原订单流水号
    ,init_indent_tran_dt -- 原订单交易日期
    ,tran_status_cd -- 交易状态代码
    ,pay_sucs_dt -- 付款成功日期
    ,pay_sucs_tm -- 付款成功时间
    ,resp_code -- 响应码
    ,resp_code_descb -- 响应码描述
    ,rtn_goods_status_cd -- 退货状态代码
    ,on_acct_flg -- 挂账标志
    ,indent_valid_tm -- 订单有效时间
    ,pay_bank_card_id -- 支付银行卡编号
    ,termn_type_cd -- 终端类型代码
    ,recv_bill_brch_id -- 收单分行编号
    ,ext_mercht_id -- 外部商户编号
    ,pay_chn_cd -- 支付渠道代码
    ,back_end_chn_indent_id -- 后端渠道订单编号
    ,epc_g_room_flg -- 网联机房标志
    ,pay_vouch_id -- 付款凭证编号
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,src_table_name -- 源表名称
        ,job_cd -- 任务编码
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.evt_id -- 事件编号
    ,n.lp_id -- 法人编号
    ,n.intnal_flow_num -- 内部流水号
    ,n.tran_dt -- 交易日期
    ,n.tran_tm -- 交易时间
    ,n.bus_type_cd -- 业务类型代码
    ,n.back_end_chn_type_cd -- 后端渠道类型代码
    ,n.mercht_id -- 商户编号
    ,n.mercht_name -- 商户名称
    ,n.chn_mercht_id -- 渠道商户编号
    ,n.chn_sub_mercht_id -- 渠道子商户编号
    ,n.chn_indent_flow_num -- 渠道订单流水号
    ,n.chn_indent_tran_dt -- 渠道订单交易日期
    ,n.pay_chn_fee_rat -- 支付渠道费率
    ,n.pay_flow_num -- 支付流水号
    ,n.ova_flow_num -- 全局流水号
    ,n.fee_rat_chn_cd -- 费率渠道代码
    ,n.ext_indent_id -- 外部订单编号
    ,n.indent_caption_name -- 订单标题名称
    ,n.indent_descb -- 订单描述
    ,n.agency_id -- 代理商编号
    ,n.curr_cd -- 币种代码
    ,n.tran_amt -- 交易金额
    ,n.indent_bal -- 订单余额
    ,n.init_indent_flow_num -- 原订单流水号
    ,n.init_indent_tran_dt -- 原订单交易日期
    ,n.tran_status_cd -- 交易状态代码
    ,n.pay_sucs_dt -- 付款成功日期
    ,n.pay_sucs_tm -- 付款成功时间
    ,n.resp_code -- 响应码
    ,n.resp_code_descb -- 响应码描述
    ,n.rtn_goods_status_cd -- 退货状态代码
    ,n.on_acct_flg -- 挂账标志
    ,n.indent_valid_tm -- 订单有效时间
    ,n.pay_bank_card_id -- 支付银行卡编号
    ,n.termn_type_cd -- 终端类型代码
    ,n.recv_bill_brch_id -- 收单分行编号
    ,n.ext_mercht_id -- 外部商户编号
    ,n.pay_chn_cd -- 支付渠道代码
    ,n.back_end_chn_indent_id -- 后端渠道订单编号
    ,n.epc_g_room_flg -- 网联机房标志
    ,n.pay_vouch_id -- 付款凭证编号
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark -- 增删标志
    ,n.src_table_name -- 源表名称
    ,'mrmsi1' as job_cd -- 任务编码
    ,n.etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_mercht_indent_pay_info_h_mrmsi1_tm n
    left join ${iml_schema}.evt_mercht_indent_pay_info_h_mrmsi1_bk o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
where (
        o.evt_id is null
        and o.lp_id is null
    )
    or (
        o.intnal_flow_num <> n.intnal_flow_num
        or o.tran_dt <> n.tran_dt
        or o.tran_tm <> n.tran_tm
        or o.bus_type_cd <> n.bus_type_cd
        or o.back_end_chn_type_cd <> n.back_end_chn_type_cd
        or o.mercht_id <> n.mercht_id
        or o.mercht_name <> n.mercht_name
        or o.chn_mercht_id <> n.chn_mercht_id
        or o.chn_sub_mercht_id <> n.chn_sub_mercht_id
        or o.chn_indent_flow_num <> n.chn_indent_flow_num
        or o.chn_indent_tran_dt <> n.chn_indent_tran_dt
        or o.pay_chn_fee_rat <> n.pay_chn_fee_rat
        or o.pay_flow_num <> n.pay_flow_num
        or o.ova_flow_num <> n.ova_flow_num
        or o.fee_rat_chn_cd <> n.fee_rat_chn_cd
        or o.ext_indent_id <> n.ext_indent_id
        or o.indent_caption_name <> n.indent_caption_name
        or o.indent_descb <> n.indent_descb
        or o.agency_id <> n.agency_id
        or o.curr_cd <> n.curr_cd
        or o.tran_amt <> n.tran_amt
        or o.indent_bal <> n.indent_bal
        or o.init_indent_flow_num <> n.init_indent_flow_num
        or o.init_indent_tran_dt <> n.init_indent_tran_dt
        or o.tran_status_cd <> n.tran_status_cd
        or o.pay_sucs_dt <> n.pay_sucs_dt
        or o.pay_sucs_tm <> n.pay_sucs_tm
        or o.resp_code <> n.resp_code
        or o.resp_code_descb <> n.resp_code_descb
        or o.rtn_goods_status_cd <> n.rtn_goods_status_cd
        or o.on_acct_flg <> n.on_acct_flg
        or o.indent_valid_tm <> n.indent_valid_tm
        or o.pay_bank_card_id <> n.pay_bank_card_id
        or o.termn_type_cd <> n.termn_type_cd
        or o.recv_bill_brch_id <> n.recv_bill_brch_id
        or o.ext_mercht_id <> n.ext_mercht_id
        or o.pay_chn_cd <> n.pay_chn_cd
        or o.back_end_chn_indent_id <> n.back_end_chn_indent_id
        or o.epc_g_room_flg <> n.epc_g_room_flg
        or o.pay_vouch_id <> n.pay_vouch_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_mercht_indent_pay_info_h_mrmsi1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,intnal_flow_num -- 内部流水号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,bus_type_cd -- 业务类型代码
    ,back_end_chn_type_cd -- 后端渠道类型代码
    ,mercht_id -- 商户编号
    ,mercht_name -- 商户名称
    ,chn_mercht_id -- 渠道商户编号
    ,chn_sub_mercht_id -- 渠道子商户编号
    ,chn_indent_flow_num -- 渠道订单流水号
    ,chn_indent_tran_dt -- 渠道订单交易日期
    ,pay_chn_fee_rat -- 支付渠道费率
    ,pay_flow_num -- 支付流水号
    ,ova_flow_num -- 全局流水号
    ,fee_rat_chn_cd -- 费率渠道代码
    ,ext_indent_id -- 外部订单编号
    ,indent_caption_name -- 订单标题名称
    ,indent_descb -- 订单描述
    ,agency_id -- 代理商编号
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,indent_bal -- 订单余额
    ,init_indent_flow_num -- 原订单流水号
    ,init_indent_tran_dt -- 原订单交易日期
    ,tran_status_cd -- 交易状态代码
    ,pay_sucs_dt -- 付款成功日期
    ,pay_sucs_tm -- 付款成功时间
    ,resp_code -- 响应码
    ,resp_code_descb -- 响应码描述
    ,rtn_goods_status_cd -- 退货状态代码
    ,on_acct_flg -- 挂账标志
    ,indent_valid_tm -- 订单有效时间
    ,pay_bank_card_id -- 支付银行卡编号
    ,termn_type_cd -- 终端类型代码
    ,recv_bill_brch_id -- 收单分行编号
    ,ext_mercht_id -- 外部商户编号
    ,pay_chn_cd -- 支付渠道代码
    ,back_end_chn_indent_id -- 后端渠道订单编号
    ,epc_g_room_flg -- 网联机房标志
    ,pay_vouch_id -- 付款凭证编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_mercht_indent_pay_info_h_mrmsi1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,intnal_flow_num -- 内部流水号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,bus_type_cd -- 业务类型代码
    ,back_end_chn_type_cd -- 后端渠道类型代码
    ,mercht_id -- 商户编号
    ,mercht_name -- 商户名称
    ,chn_mercht_id -- 渠道商户编号
    ,chn_sub_mercht_id -- 渠道子商户编号
    ,chn_indent_flow_num -- 渠道订单流水号
    ,chn_indent_tran_dt -- 渠道订单交易日期
    ,pay_chn_fee_rat -- 支付渠道费率
    ,pay_flow_num -- 支付流水号
    ,ova_flow_num -- 全局流水号
    ,fee_rat_chn_cd -- 费率渠道代码
    ,ext_indent_id -- 外部订单编号
    ,indent_caption_name -- 订单标题名称
    ,indent_descb -- 订单描述
    ,agency_id -- 代理商编号
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,indent_bal -- 订单余额
    ,init_indent_flow_num -- 原订单流水号
    ,init_indent_tran_dt -- 原订单交易日期
    ,tran_status_cd -- 交易状态代码
    ,pay_sucs_dt -- 付款成功日期
    ,pay_sucs_tm -- 付款成功时间
    ,resp_code -- 响应码
    ,resp_code_descb -- 响应码描述
    ,rtn_goods_status_cd -- 退货状态代码
    ,on_acct_flg -- 挂账标志
    ,indent_valid_tm -- 订单有效时间
    ,pay_bank_card_id -- 支付银行卡编号
    ,termn_type_cd -- 终端类型代码
    ,recv_bill_brch_id -- 收单分行编号
    ,ext_mercht_id -- 外部商户编号
    ,pay_chn_cd -- 支付渠道代码
    ,back_end_chn_indent_id -- 后端渠道订单编号
    ,epc_g_room_flg -- 网联机房标志
    ,pay_vouch_id -- 付款凭证编号
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
    ,o.intnal_flow_num -- 内部流水号
    ,o.tran_dt -- 交易日期
    ,o.tran_tm -- 交易时间
    ,o.bus_type_cd -- 业务类型代码
    ,o.back_end_chn_type_cd -- 后端渠道类型代码
    ,o.mercht_id -- 商户编号
    ,o.mercht_name -- 商户名称
    ,o.chn_mercht_id -- 渠道商户编号
    ,o.chn_sub_mercht_id -- 渠道子商户编号
    ,o.chn_indent_flow_num -- 渠道订单流水号
    ,o.chn_indent_tran_dt -- 渠道订单交易日期
    ,o.pay_chn_fee_rat -- 支付渠道费率
    ,o.pay_flow_num -- 支付流水号
    ,o.ova_flow_num -- 全局流水号
    ,o.fee_rat_chn_cd -- 费率渠道代码
    ,o.ext_indent_id -- 外部订单编号
    ,o.indent_caption_name -- 订单标题名称
    ,o.indent_descb -- 订单描述
    ,o.agency_id -- 代理商编号
    ,o.curr_cd -- 币种代码
    ,o.tran_amt -- 交易金额
    ,o.indent_bal -- 订单余额
    ,o.init_indent_flow_num -- 原订单流水号
    ,o.init_indent_tran_dt -- 原订单交易日期
    ,o.tran_status_cd -- 交易状态代码
    ,o.pay_sucs_dt -- 付款成功日期
    ,o.pay_sucs_tm -- 付款成功时间
    ,o.resp_code -- 响应码
    ,o.resp_code_descb -- 响应码描述
    ,o.rtn_goods_status_cd -- 退货状态代码
    ,o.on_acct_flg -- 挂账标志
    ,o.indent_valid_tm -- 订单有效时间
    ,o.pay_bank_card_id -- 支付银行卡编号
    ,o.termn_type_cd -- 终端类型代码
    ,o.recv_bill_brch_id -- 收单分行编号
    ,o.ext_mercht_id -- 外部商户编号
    ,o.pay_chn_cd -- 支付渠道代码
    ,o.back_end_chn_indent_id -- 后端渠道订单编号
    ,o.epc_g_room_flg -- 网联机房标志
    ,o.pay_vouch_id -- 付款凭证编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_mercht_indent_pay_info_h_mrmsi1_bk o
    left join ${iml_schema}.evt_mercht_indent_pay_info_h_mrmsi1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;


-- 4.1 rebuild partition
whenever sqlerror continue none;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_mercht_indent_pay_info_h') 
               and substr(subpartition_name,1,8)=upper('p_mrmsi1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_mercht_indent_pay_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.evt_mercht_indent_pay_info_h modify partition p_mrmsi1 
add subpartition p_mrmsi1_${batch_date} values (to_date('${batch_date}','YYYYMMDD'));
  
-- 4.2 exchange partition
alter table ${iml_schema}.evt_mercht_indent_pay_info_h exchange subpartition p_mrmsi1_${batch_date} with table ${iml_schema}.evt_mercht_indent_pay_info_h_mrmsi1_cl;
alter table ${iml_schema}.evt_mercht_indent_pay_info_h exchange subpartition p_mrmsi1_20991231 with table ${iml_schema}.evt_mercht_indent_pay_info_h_mrmsi1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_mercht_indent_pay_info_h to ${iml_schema};

-- 5.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_mercht_indent_pay_info_h_mrmsi1_tm purge;
drop table ${iml_schema}.evt_mercht_indent_pay_info_h_mrmsi1_op purge;
drop table ${iml_schema}.evt_mercht_indent_pay_info_h_mrmsi1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_mercht_indent_pay_info_h_mrmsi1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_mercht_indent_pay_info_h', partname => 'p_mrmsi1_20991231', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1', no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
