/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_point_mall_pay_flow_amssf1
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
alter table ${iml_schema}.evt_point_mall_pay_flow add partition p_amssf1 values ('amssf1')(
        subpartition p_amssf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_amssf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_point_mall_pay_flow_amssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_point_mall_pay_flow partition for ('amssf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_point_mall_pay_flow_amssf1_tm purge;
drop table ${iml_schema}.evt_point_mall_pay_flow_amssf1_op purge;
drop table ${iml_schema}.evt_point_mall_pay_flow_amssf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_point_mall_pay_flow_amssf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,indent_flow_num -- 订单流水号
    ,indent_id -- 订单编号
    ,tran_dt -- 交易日期
    ,tran_code -- 交易码
    ,tran_descb -- 交易描述
    ,tran_flow_num -- 交易流水号
    ,tran_status_cd -- 交易状态代码
    ,tran_org_id -- 交易机构编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_mgr_id -- 客户经理编号
    ,open_acct_org_id -- 开户机构编号
    ,agency_id -- 代理商编号
    ,mercht_id -- 商户编号
    ,belong_org_id -- 所属机构编号
    ,merchd_type_cd -- 商品类型代码
    ,mode_pay_cd -- 支付方式代码
    ,indent_tot_amt -- 订单总金额
    ,indent_tot_point -- 订单总积分
    ,point_type_cd -- 积分类型代码
    ,indent_eqty_point -- 订单权益积分
    ,indent_tot_welfare_gold -- 订单总福利金
    ,surp_welfare_gold -- 剩余福利金
    ,surp_aval_amt -- 剩余可用金额
    ,surp_aval_point -- 剩余可用积分
    ,surp_aval_eqty_point -- 剩余可用权益积分
    ,pay_card_num -- 支付卡号
    ,pay_card_open_acct_org_id -- 支付卡开户机构编号
    ,card_name -- 卡名称
    ,card_type_cd -- 卡类型代码
    ,ibank_no -- 联行号
    ,bank_name -- 银行名称
    ,pay_sucs_dt -- 付款成功日期
    ,comb_pay_reb_sucs_flg -- 组合支付回滚成功标志
    ,advise_sucs_flg -- 通知成功标志
    ,pay_fail_advise_cnt -- 支付失败通知次数
    ,check_bal_flg -- 检查余额标志
    ,dispatch_status_cd -- 发货状态代码
    ,rtn_goods_init_indent_flow_num -- 退货原订单流水号
    ,rtn_goods_init_indent_tran_dt -- 退货原订单交易日期
    ,init_tran_order_no -- 原交易订单号
    ,init_indent_tran_dt -- 原订单交易日期
    ,resp_code -- 响应码
    ,resp_descb -- 响应描述
    ,valid_flg -- 有效标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_point_mall_pay_flow partition for ('amssf1')
where 0=1
;

create table ${iml_schema}.evt_point_mall_pay_flow_amssf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_point_mall_pay_flow partition for ('amssf1') where 0=1;

create table ${iml_schema}.evt_point_mall_pay_flow_amssf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_point_mall_pay_flow partition for ('amssf1') where 0=1;

-- 3.1 get new data into table
-- amss_points_mall_pay_order-1
insert into ${iml_schema}.evt_point_mall_pay_flow_amssf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,indent_flow_num -- 订单流水号
    ,indent_id -- 订单编号
    ,tran_dt -- 交易日期
    ,tran_code -- 交易码
    ,tran_descb -- 交易描述
    ,tran_flow_num -- 交易流水号
    ,tran_status_cd -- 交易状态代码
    ,tran_org_id -- 交易机构编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_mgr_id -- 客户经理编号
    ,open_acct_org_id -- 开户机构编号
    ,agency_id -- 代理商编号
    ,mercht_id -- 商户编号
    ,belong_org_id -- 所属机构编号
    ,merchd_type_cd -- 商品类型代码
    ,mode_pay_cd -- 支付方式代码
    ,indent_tot_amt -- 订单总金额
    ,indent_tot_point -- 订单总积分
    ,point_type_cd -- 积分类型代码
    ,indent_eqty_point -- 订单权益积分
    ,indent_tot_welfare_gold -- 订单总福利金
    ,surp_welfare_gold -- 剩余福利金
    ,surp_aval_amt -- 剩余可用金额
    ,surp_aval_point -- 剩余可用积分
    ,surp_aval_eqty_point -- 剩余可用权益积分
    ,pay_card_num -- 支付卡号
    ,pay_card_open_acct_org_id -- 支付卡开户机构编号
    ,card_name -- 卡名称
    ,card_type_cd -- 卡类型代码
    ,ibank_no -- 联行号
    ,bank_name -- 银行名称
    ,pay_sucs_dt -- 付款成功日期
    ,comb_pay_reb_sucs_flg -- 组合支付回滚成功标志
    ,advise_sucs_flg -- 通知成功标志
    ,pay_fail_advise_cnt -- 支付失败通知次数
    ,check_bal_flg -- 检查余额标志
    ,dispatch_status_cd -- 发货状态代码
    ,rtn_goods_init_indent_flow_num -- 退货原订单流水号
    ,rtn_goods_init_indent_tran_dt -- 退货原订单交易日期
    ,init_tran_order_no -- 原交易订单号
    ,init_indent_tran_dt -- 原订单交易日期
    ,resp_code -- 响应码
    ,resp_descb -- 响应描述
    ,valid_flg -- 有效标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401057'||P1.SERIAL_NUM -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SERIAL_NUM -- 订单流水号
    ,P1.ORDER_NUM -- 订单编号
    ,P1.TXN_DATE -- 交易日期
    ,to_char(P1.PAY_TYPE) -- 交易码
    ,P1.TXN_CODE -- 交易描述
    ,P1.TXN_NUM -- 交易流水号
    ,nvl(trim(P1.TXN_STATUS),'-') -- 交易状态代码
    ,P1.TXN_ORG_NUM -- 交易机构编号
    ,P1.PTY_ID -- 客户编号
    ,P1.PTY_NAME -- 客户名称
    ,P1.PTY_MGR_NUM -- 客户经理编号
    ,P1.PTY_OPEN_ORG -- 开户机构编号
    ,P1.AGENTS_ID -- 代理商编号
    ,P1.MERCH_NUM -- 商户编号
    ,P1.CHANNEL_ID -- 所属机构编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||to_char(P1.MRCHD_TYPE) END -- 商品类型代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||to_char(P1.CNSM_TYP) END -- 支付方式代码
    ,P1.GROSS_QTTY_AMT -- 订单总金额
    ,P1.GROSS_QTTY_POINTS -- 订单总积分
    ,nvl(trim(P1.POINTS_TYPE),'-') -- 积分类型代码
    ,P1.ENTITLEMENT_POINT -- 订单权益积分
    ,P1.GROSS_FJL -- 订单总福利金
    ,P1.REM_FLJ -- 剩余福利金
    ,P1.REM_AMT -- 剩余可用金额
    ,P1.REM_POINTS -- 剩余可用积分
    ,P1.REM_ENTITLEMENT_POINT -- 剩余可用权益积分
    ,P1.PAY_CARD_NUM -- 支付卡号
    ,P1.OPEN_ORG_NUM -- 支付卡开户机构编号
    ,P1.ACCT_NUM_NAME -- 卡名称
    ,decode(trim(P1.CARD_TYPE),'0','-',P1.CARD_TYPE) -- 卡类型代码
    ,P1.EXCH_BRCH_NO -- 联行号
    ,P1.BANK_NAME -- 银行名称
    ,P1.PAYMENT_SUCCESS_DATE -- 付款成功日期
    ,to_char(decode(trim(P1.RETURN_FLAG),'2','0','1','1','0','-',P1.RETURN_FLAG)) -- 组合支付回滚成功标志
    ,nvl(trim(P1.NOTIFY_FLAG),'-') -- 通知成功标志
    ,P1.NOTIFY_COUNT -- 支付失败通知次数
    ,nvl(trim(P1.WTHR_CHECK_BAL),'-') -- 检查余额标志
    ,nvl(trim(P1.SHIP_STATUS),'-') -- 发货状态代码
    ,P1.PAY_SERIAL_NUM -- 退货原订单流水号
    ,${iml_schema}.dateformat_max2(P1.PAY_ORDER_NUM) -- 退货原订单交易日期
    ,P1.ORIG_ORDER_NUM -- 原交易订单号
    ,${iml_schema}.dateformat_max2(P1.ORIG_TRX_DT) -- 原订单交易日期
    ,P1.SRV_RESP_CODE -- 响应码
    ,P1.SRV_RESP_INFO -- 响应描述
    ,case when P1.PHYSICS_FLAG = 1 then '1' else '0' end -- 有效标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'amss_points_mall_pay_order' -- 源表名称
    ,'amssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.amss_points_mall_pay_order p1
    left join ${iml_schema}.ref_pub_cd_map r1 on to_char(P1.MRCHD_TYPE) = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'AMSS'
        AND R1.SRC_TAB_EN_NAME= 'AMSS_POINTS_MALL_PAY_ORDER'
        AND R1.SRC_FIELD_EN_NAME= 'MRCHD_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_POINT_MALL_PAY_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'MERCHD_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on to_char(P1.CNSM_TYP) = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'AMSS'
        AND R2.SRC_TAB_EN_NAME= 'AMSS_POINTS_MALL_PAY_ORDER'
        AND R2.SRC_FIELD_EN_NAME= 'CNSM_TYP'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_POINT_MALL_PAY_FLOW'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'MODE_PAY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_point_mall_pay_flow_amssf1_tm 
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
        into ${iml_schema}.evt_point_mall_pay_flow_amssf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,indent_flow_num -- 订单流水号
    ,indent_id -- 订单编号
    ,tran_dt -- 交易日期
    ,tran_code -- 交易码
    ,tran_descb -- 交易描述
    ,tran_flow_num -- 交易流水号
    ,tran_status_cd -- 交易状态代码
    ,tran_org_id -- 交易机构编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_mgr_id -- 客户经理编号
    ,open_acct_org_id -- 开户机构编号
    ,agency_id -- 代理商编号
    ,mercht_id -- 商户编号
    ,belong_org_id -- 所属机构编号
    ,merchd_type_cd -- 商品类型代码
    ,mode_pay_cd -- 支付方式代码
    ,indent_tot_amt -- 订单总金额
    ,indent_tot_point -- 订单总积分
    ,point_type_cd -- 积分类型代码
    ,indent_eqty_point -- 订单权益积分
    ,indent_tot_welfare_gold -- 订单总福利金
    ,surp_welfare_gold -- 剩余福利金
    ,surp_aval_amt -- 剩余可用金额
    ,surp_aval_point -- 剩余可用积分
    ,surp_aval_eqty_point -- 剩余可用权益积分
    ,pay_card_num -- 支付卡号
    ,pay_card_open_acct_org_id -- 支付卡开户机构编号
    ,card_name -- 卡名称
    ,card_type_cd -- 卡类型代码
    ,ibank_no -- 联行号
    ,bank_name -- 银行名称
    ,pay_sucs_dt -- 付款成功日期
    ,comb_pay_reb_sucs_flg -- 组合支付回滚成功标志
    ,advise_sucs_flg -- 通知成功标志
    ,pay_fail_advise_cnt -- 支付失败通知次数
    ,check_bal_flg -- 检查余额标志
    ,dispatch_status_cd -- 发货状态代码
    ,rtn_goods_init_indent_flow_num -- 退货原订单流水号
    ,rtn_goods_init_indent_tran_dt -- 退货原订单交易日期
    ,init_tran_order_no -- 原交易订单号
    ,init_indent_tran_dt -- 原订单交易日期
    ,resp_code -- 响应码
    ,resp_descb -- 响应描述
    ,valid_flg -- 有效标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_point_mall_pay_flow_amssf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,indent_flow_num -- 订单流水号
    ,indent_id -- 订单编号
    ,tran_dt -- 交易日期
    ,tran_code -- 交易码
    ,tran_descb -- 交易描述
    ,tran_flow_num -- 交易流水号
    ,tran_status_cd -- 交易状态代码
    ,tran_org_id -- 交易机构编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_mgr_id -- 客户经理编号
    ,open_acct_org_id -- 开户机构编号
    ,agency_id -- 代理商编号
    ,mercht_id -- 商户编号
    ,belong_org_id -- 所属机构编号
    ,merchd_type_cd -- 商品类型代码
    ,mode_pay_cd -- 支付方式代码
    ,indent_tot_amt -- 订单总金额
    ,indent_tot_point -- 订单总积分
    ,point_type_cd -- 积分类型代码
    ,indent_eqty_point -- 订单权益积分
    ,indent_tot_welfare_gold -- 订单总福利金
    ,surp_welfare_gold -- 剩余福利金
    ,surp_aval_amt -- 剩余可用金额
    ,surp_aval_point -- 剩余可用积分
    ,surp_aval_eqty_point -- 剩余可用权益积分
    ,pay_card_num -- 支付卡号
    ,pay_card_open_acct_org_id -- 支付卡开户机构编号
    ,card_name -- 卡名称
    ,card_type_cd -- 卡类型代码
    ,ibank_no -- 联行号
    ,bank_name -- 银行名称
    ,pay_sucs_dt -- 付款成功日期
    ,comb_pay_reb_sucs_flg -- 组合支付回滚成功标志
    ,advise_sucs_flg -- 通知成功标志
    ,pay_fail_advise_cnt -- 支付失败通知次数
    ,check_bal_flg -- 检查余额标志
    ,dispatch_status_cd -- 发货状态代码
    ,rtn_goods_init_indent_flow_num -- 退货原订单流水号
    ,rtn_goods_init_indent_tran_dt -- 退货原订单交易日期
    ,init_tran_order_no -- 原交易订单号
    ,init_indent_tran_dt -- 原订单交易日期
    ,resp_code -- 响应码
    ,resp_descb -- 响应描述
    ,valid_flg -- 有效标志
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
    ,nvl(n.indent_id, o.indent_id) as indent_id -- 订单编号
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.tran_code, o.tran_code) as tran_code -- 交易码
    ,nvl(n.tran_descb, o.tran_descb) as tran_descb -- 交易描述
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.open_acct_org_id, o.open_acct_org_id) as open_acct_org_id -- 开户机构编号
    ,nvl(n.agency_id, o.agency_id) as agency_id -- 代理商编号
    ,nvl(n.mercht_id, o.mercht_id) as mercht_id -- 商户编号
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.merchd_type_cd, o.merchd_type_cd) as merchd_type_cd -- 商品类型代码
    ,nvl(n.mode_pay_cd, o.mode_pay_cd) as mode_pay_cd -- 支付方式代码
    ,nvl(n.indent_tot_amt, o.indent_tot_amt) as indent_tot_amt -- 订单总金额
    ,nvl(n.indent_tot_point, o.indent_tot_point) as indent_tot_point -- 订单总积分
    ,nvl(n.point_type_cd, o.point_type_cd) as point_type_cd -- 积分类型代码
    ,nvl(n.indent_eqty_point, o.indent_eqty_point) as indent_eqty_point -- 订单权益积分
    ,nvl(n.indent_tot_welfare_gold, o.indent_tot_welfare_gold) as indent_tot_welfare_gold -- 订单总福利金
    ,nvl(n.surp_welfare_gold, o.surp_welfare_gold) as surp_welfare_gold -- 剩余福利金
    ,nvl(n.surp_aval_amt, o.surp_aval_amt) as surp_aval_amt -- 剩余可用金额
    ,nvl(n.surp_aval_point, o.surp_aval_point) as surp_aval_point -- 剩余可用积分
    ,nvl(n.surp_aval_eqty_point, o.surp_aval_eqty_point) as surp_aval_eqty_point -- 剩余可用权益积分
    ,nvl(n.pay_card_num, o.pay_card_num) as pay_card_num -- 支付卡号
    ,nvl(n.pay_card_open_acct_org_id, o.pay_card_open_acct_org_id) as pay_card_open_acct_org_id -- 支付卡开户机构编号
    ,nvl(n.card_name, o.card_name) as card_name -- 卡名称
    ,nvl(n.card_type_cd, o.card_type_cd) as card_type_cd -- 卡类型代码
    ,nvl(n.ibank_no, o.ibank_no) as ibank_no -- 联行号
    ,nvl(n.bank_name, o.bank_name) as bank_name -- 银行名称
    ,nvl(n.pay_sucs_dt, o.pay_sucs_dt) as pay_sucs_dt -- 付款成功日期
    ,nvl(n.comb_pay_reb_sucs_flg, o.comb_pay_reb_sucs_flg) as comb_pay_reb_sucs_flg -- 组合支付回滚成功标志
    ,nvl(n.advise_sucs_flg, o.advise_sucs_flg) as advise_sucs_flg -- 通知成功标志
    ,nvl(n.pay_fail_advise_cnt, o.pay_fail_advise_cnt) as pay_fail_advise_cnt -- 支付失败通知次数
    ,nvl(n.check_bal_flg, o.check_bal_flg) as check_bal_flg -- 检查余额标志
    ,nvl(n.dispatch_status_cd, o.dispatch_status_cd) as dispatch_status_cd -- 发货状态代码
    ,nvl(n.rtn_goods_init_indent_flow_num, o.rtn_goods_init_indent_flow_num) as rtn_goods_init_indent_flow_num -- 退货原订单流水号
    ,nvl(n.rtn_goods_init_indent_tran_dt, o.rtn_goods_init_indent_tran_dt) as rtn_goods_init_indent_tran_dt -- 退货原订单交易日期
    ,nvl(n.init_tran_order_no, o.init_tran_order_no) as init_tran_order_no -- 原交易订单号
    ,nvl(n.init_indent_tran_dt, o.init_indent_tran_dt) as init_indent_tran_dt -- 原订单交易日期
    ,nvl(n.resp_code, o.resp_code) as resp_code -- 响应码
    ,nvl(n.resp_descb, o.resp_descb) as resp_descb -- 响应描述
    ,nvl(n.valid_flg, o.valid_flg) as valid_flg -- 有效标志
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
from ${iml_schema}.evt_point_mall_pay_flow_amssf1_tm n
    full join (select * from ${iml_schema}.evt_point_mall_pay_flow_amssf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        or o.indent_id <> n.indent_id
        or o.tran_dt <> n.tran_dt
        or o.tran_code <> n.tran_code
        or o.tran_descb <> n.tran_descb
        or o.tran_flow_num <> n.tran_flow_num
        or o.tran_status_cd <> n.tran_status_cd
        or o.tran_org_id <> n.tran_org_id
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.cust_mgr_id <> n.cust_mgr_id
        or o.open_acct_org_id <> n.open_acct_org_id
        or o.agency_id <> n.agency_id
        or o.mercht_id <> n.mercht_id
        or o.belong_org_id <> n.belong_org_id
        or o.merchd_type_cd <> n.merchd_type_cd
        or o.mode_pay_cd <> n.mode_pay_cd
        or o.indent_tot_amt <> n.indent_tot_amt
        or o.indent_tot_point <> n.indent_tot_point
        or o.point_type_cd <> n.point_type_cd
        or o.indent_eqty_point <> n.indent_eqty_point
        or o.indent_tot_welfare_gold <> n.indent_tot_welfare_gold
        or o.surp_welfare_gold <> n.surp_welfare_gold
        or o.surp_aval_amt <> n.surp_aval_amt
        or o.surp_aval_point <> n.surp_aval_point
        or o.surp_aval_eqty_point <> n.surp_aval_eqty_point
        or o.pay_card_num <> n.pay_card_num
        or o.pay_card_open_acct_org_id <> n.pay_card_open_acct_org_id
        or o.card_name <> n.card_name
        or o.card_type_cd <> n.card_type_cd
        or o.ibank_no <> n.ibank_no
        or o.bank_name <> n.bank_name
        or o.pay_sucs_dt <> n.pay_sucs_dt
        or o.comb_pay_reb_sucs_flg <> n.comb_pay_reb_sucs_flg
        or o.advise_sucs_flg <> n.advise_sucs_flg
        or o.pay_fail_advise_cnt <> n.pay_fail_advise_cnt
        or o.check_bal_flg <> n.check_bal_flg
        or o.dispatch_status_cd <> n.dispatch_status_cd
        or o.rtn_goods_init_indent_flow_num <> n.rtn_goods_init_indent_flow_num
        or o.rtn_goods_init_indent_tran_dt <> n.rtn_goods_init_indent_tran_dt
        or o.init_tran_order_no <> n.init_tran_order_no
        or o.init_indent_tran_dt <> n.init_indent_tran_dt
        or o.resp_code <> n.resp_code
        or o.resp_descb <> n.resp_descb
        or o.valid_flg <> n.valid_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_point_mall_pay_flow_amssf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,indent_flow_num -- 订单流水号
    ,indent_id -- 订单编号
    ,tran_dt -- 交易日期
    ,tran_code -- 交易码
    ,tran_descb -- 交易描述
    ,tran_flow_num -- 交易流水号
    ,tran_status_cd -- 交易状态代码
    ,tran_org_id -- 交易机构编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_mgr_id -- 客户经理编号
    ,open_acct_org_id -- 开户机构编号
    ,agency_id -- 代理商编号
    ,mercht_id -- 商户编号
    ,belong_org_id -- 所属机构编号
    ,merchd_type_cd -- 商品类型代码
    ,mode_pay_cd -- 支付方式代码
    ,indent_tot_amt -- 订单总金额
    ,indent_tot_point -- 订单总积分
    ,point_type_cd -- 积分类型代码
    ,indent_eqty_point -- 订单权益积分
    ,indent_tot_welfare_gold -- 订单总福利金
    ,surp_welfare_gold -- 剩余福利金
    ,surp_aval_amt -- 剩余可用金额
    ,surp_aval_point -- 剩余可用积分
    ,surp_aval_eqty_point -- 剩余可用权益积分
    ,pay_card_num -- 支付卡号
    ,pay_card_open_acct_org_id -- 支付卡开户机构编号
    ,card_name -- 卡名称
    ,card_type_cd -- 卡类型代码
    ,ibank_no -- 联行号
    ,bank_name -- 银行名称
    ,pay_sucs_dt -- 付款成功日期
    ,comb_pay_reb_sucs_flg -- 组合支付回滚成功标志
    ,advise_sucs_flg -- 通知成功标志
    ,pay_fail_advise_cnt -- 支付失败通知次数
    ,check_bal_flg -- 检查余额标志
    ,dispatch_status_cd -- 发货状态代码
    ,rtn_goods_init_indent_flow_num -- 退货原订单流水号
    ,rtn_goods_init_indent_tran_dt -- 退货原订单交易日期
    ,init_tran_order_no -- 原交易订单号
    ,init_indent_tran_dt -- 原订单交易日期
    ,resp_code -- 响应码
    ,resp_descb -- 响应描述
    ,valid_flg -- 有效标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_point_mall_pay_flow_amssf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,indent_flow_num -- 订单流水号
    ,indent_id -- 订单编号
    ,tran_dt -- 交易日期
    ,tran_code -- 交易码
    ,tran_descb -- 交易描述
    ,tran_flow_num -- 交易流水号
    ,tran_status_cd -- 交易状态代码
    ,tran_org_id -- 交易机构编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_mgr_id -- 客户经理编号
    ,open_acct_org_id -- 开户机构编号
    ,agency_id -- 代理商编号
    ,mercht_id -- 商户编号
    ,belong_org_id -- 所属机构编号
    ,merchd_type_cd -- 商品类型代码
    ,mode_pay_cd -- 支付方式代码
    ,indent_tot_amt -- 订单总金额
    ,indent_tot_point -- 订单总积分
    ,point_type_cd -- 积分类型代码
    ,indent_eqty_point -- 订单权益积分
    ,indent_tot_welfare_gold -- 订单总福利金
    ,surp_welfare_gold -- 剩余福利金
    ,surp_aval_amt -- 剩余可用金额
    ,surp_aval_point -- 剩余可用积分
    ,surp_aval_eqty_point -- 剩余可用权益积分
    ,pay_card_num -- 支付卡号
    ,pay_card_open_acct_org_id -- 支付卡开户机构编号
    ,card_name -- 卡名称
    ,card_type_cd -- 卡类型代码
    ,ibank_no -- 联行号
    ,bank_name -- 银行名称
    ,pay_sucs_dt -- 付款成功日期
    ,comb_pay_reb_sucs_flg -- 组合支付回滚成功标志
    ,advise_sucs_flg -- 通知成功标志
    ,pay_fail_advise_cnt -- 支付失败通知次数
    ,check_bal_flg -- 检查余额标志
    ,dispatch_status_cd -- 发货状态代码
    ,rtn_goods_init_indent_flow_num -- 退货原订单流水号
    ,rtn_goods_init_indent_tran_dt -- 退货原订单交易日期
    ,init_tran_order_no -- 原交易订单号
    ,init_indent_tran_dt -- 原订单交易日期
    ,resp_code -- 响应码
    ,resp_descb -- 响应描述
    ,valid_flg -- 有效标志
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
    ,o.indent_id -- 订单编号
    ,o.tran_dt -- 交易日期
    ,o.tran_code -- 交易码
    ,o.tran_descb -- 交易描述
    ,o.tran_flow_num -- 交易流水号
    ,o.tran_status_cd -- 交易状态代码
    ,o.tran_org_id -- 交易机构编号
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.cust_mgr_id -- 客户经理编号
    ,o.open_acct_org_id -- 开户机构编号
    ,o.agency_id -- 代理商编号
    ,o.mercht_id -- 商户编号
    ,o.belong_org_id -- 所属机构编号
    ,o.merchd_type_cd -- 商品类型代码
    ,o.mode_pay_cd -- 支付方式代码
    ,o.indent_tot_amt -- 订单总金额
    ,o.indent_tot_point -- 订单总积分
    ,o.point_type_cd -- 积分类型代码
    ,o.indent_eqty_point -- 订单权益积分
    ,o.indent_tot_welfare_gold -- 订单总福利金
    ,o.surp_welfare_gold -- 剩余福利金
    ,o.surp_aval_amt -- 剩余可用金额
    ,o.surp_aval_point -- 剩余可用积分
    ,o.surp_aval_eqty_point -- 剩余可用权益积分
    ,o.pay_card_num -- 支付卡号
    ,o.pay_card_open_acct_org_id -- 支付卡开户机构编号
    ,o.card_name -- 卡名称
    ,o.card_type_cd -- 卡类型代码
    ,o.ibank_no -- 联行号
    ,o.bank_name -- 银行名称
    ,o.pay_sucs_dt -- 付款成功日期
    ,o.comb_pay_reb_sucs_flg -- 组合支付回滚成功标志
    ,o.advise_sucs_flg -- 通知成功标志
    ,o.pay_fail_advise_cnt -- 支付失败通知次数
    ,o.check_bal_flg -- 检查余额标志
    ,o.dispatch_status_cd -- 发货状态代码
    ,o.rtn_goods_init_indent_flow_num -- 退货原订单流水号
    ,o.rtn_goods_init_indent_tran_dt -- 退货原订单交易日期
    ,o.init_tran_order_no -- 原交易订单号
    ,o.init_indent_tran_dt -- 原订单交易日期
    ,o.resp_code -- 响应码
    ,o.resp_descb -- 响应描述
    ,o.valid_flg -- 有效标志
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
from ${iml_schema}.evt_point_mall_pay_flow_amssf1_bk o
    left join ${iml_schema}.evt_point_mall_pay_flow_amssf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_point_mall_pay_flow_amssf1_cl d
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
--truncate table ${iml_schema}.evt_point_mall_pay_flow;
--alter table ${iml_schema}.evt_point_mall_pay_flow truncate partition for ('amssf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_point_mall_pay_flow') 
               and substr(subpartition_name,1,8)=upper('p_amssf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_point_mall_pay_flow drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.evt_point_mall_pay_flow modify partition p_amssf1 
add subpartition p_amssf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_point_mall_pay_flow exchange subpartition p_amssf1_${batch_date} with table ${iml_schema}.evt_point_mall_pay_flow_amssf1_cl;
alter table ${iml_schema}.evt_point_mall_pay_flow exchange subpartition p_amssf1_20991231 with table ${iml_schema}.evt_point_mall_pay_flow_amssf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_point_mall_pay_flow to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_point_mall_pay_flow_amssf1_tm purge;
drop table ${iml_schema}.evt_point_mall_pay_flow_amssf1_op purge;
drop table ${iml_schema}.evt_point_mall_pay_flow_amssf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_point_mall_pay_flow_amssf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_point_mall_pay_flow', partname => 'p_amssf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
