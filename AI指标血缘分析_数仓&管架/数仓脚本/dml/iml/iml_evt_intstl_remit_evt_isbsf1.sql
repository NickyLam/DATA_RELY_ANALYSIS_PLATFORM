/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_intstl_remit_evt_isbsf1
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
alter table ${iml_schema}.evt_intstl_remit_evt add partition p_isbsf1 values ('isbsf1')(
        subpartition p_isbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_isbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_intstl_remit_evt_isbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_intstl_remit_evt partition for ('isbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_intstl_remit_evt_isbsf1_tm purge;
drop table ${iml_schema}.evt_intstl_remit_evt_isbsf1_op purge;
drop table ${iml_schema}.evt_intstl_remit_evt_isbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_intstl_remit_evt_isbsf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,sorc_sys_id -- 源系统编号
    ,tran_descb -- 交易描述
    ,recver_cust_id -- 收款人客户编号
    ,recver_addr_name -- 收款人地址名称
    ,recver_en_name -- 收款人英文名称
    ,pay_bank_id -- 付款银行编号
    ,pay_bank_addr_name -- 付款银行地址名称
    ,pay_bank_name -- 付款银行名称
    ,remiter_cust_id -- 汇款人客户编号
    ,remiter_addr_name -- 汇款人地址名称
    ,remiter_name -- 汇款人名称
    ,remit_bank_id -- 汇款银行编号
    ,remit_bank_addr_name -- 汇款银行地址名称
    ,remit_bank_name -- 汇款银行名称
    ,value_dt -- 起息日期
    ,tran_start_tm -- 交易开始时间
    ,tran_close_tm -- 交易关闭时间
    ,abmt_msg_fee_bear_way_cd -- 汇入报文费用承担方式代码
    ,remit_oper_tm -- 汇款经办时间
    ,oper_user -- 经办用户
    ,remit_out_msg_fee_bear_way_cd -- 汇出报文费用承担方式代码
    ,pay_type_cd -- 付款类型代码
    ,clear_id -- 清算编号
    ,abmt_comm_fee_curr_cd -- 汇入手续费币种代码
    ,abmt_comm_fee_amt -- 汇入手续费金额
    ,remit_cate_cd -- 汇款类别代码
    ,remit_way_cd -- 汇款方式代码
    ,pay_dt -- 付款日期
    ,cust_type_cd -- 客户类型代码
    ,soe_type_cd -- 结汇类型代码
    ,init_curr_cd -- 原始币种代码
    ,remit_out_comm_fee_curr_cd -- 汇出手续费币种代码
    ,remit_out_comm_fee_amt -- 汇出手续费金额
    ,init_amt -- 原始金额
    ,exch_rat -- 汇率
    ,sell_fx_type_cd -- 售汇类型代码
    ,msg_type_cd -- 报文类型代码
    ,belong_org_id -- 归属机构编号
    ,oper_org_id -- 经办机构编号
    ,remit_proc_type_cd -- 汇款处理类型代码
    ,bal_pay_type_cd -- 收支类型代码
    ,remiter_acct_id -- 汇款人帐户编号
    ,recver_acct_id -- 收款人帐户编号
    ,refund_flg -- 退汇标志
    ,nra_acct_flg -- NRA账户标志
    ,clear_chn_cd -- 清算渠道代码
    ,cbec_flg -- 跨境电商标志
    ,cross_bor_cap_pool_flg -- 跨境资金池标志
    ,cap_pool_bus_type_cd -- 资金池业务类型代码
    ,cap_pool_bus_pric -- 资金池业务本金
    ,cap_pool_bus_int -- 资金池业务利息
    ,entr_pay_id -- 受托支付编号
    ,entr_pay_out_acct_dubil_id -- 受托支付出账借据编号
    ,gpi_remit_flg -- GPI汇款标志
    ,gpi_msg_feedback_status_cd -- GPI报文反馈状态代码
    ,inquiry_flg -- 询价标志
    ,deduct_acct_id -- 扣费账户编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_intstl_remit_evt partition for ('isbsf1')
where 0=1
;

create table ${iml_schema}.evt_intstl_remit_evt_isbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_intstl_remit_evt partition for ('isbsf1') where 0=1;

create table ${iml_schema}.evt_intstl_remit_evt_isbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_intstl_remit_evt partition for ('isbsf1') where 0=1;

-- 3.1 get new data into table
-- isbs_cpd-
insert into ${iml_schema}.evt_intstl_remit_evt_isbsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,sorc_sys_id -- 源系统编号
    ,tran_descb -- 交易描述
    ,recver_cust_id -- 收款人客户编号
    ,recver_addr_name -- 收款人地址名称
    ,recver_en_name -- 收款人英文名称
    ,pay_bank_id -- 付款银行编号
    ,pay_bank_addr_name -- 付款银行地址名称
    ,pay_bank_name -- 付款银行名称
    ,remiter_cust_id -- 汇款人客户编号
    ,remiter_addr_name -- 汇款人地址名称
    ,remiter_name -- 汇款人名称
    ,remit_bank_id -- 汇款银行编号
    ,remit_bank_addr_name -- 汇款银行地址名称
    ,remit_bank_name -- 汇款银行名称
    ,value_dt -- 起息日期
    ,tran_start_tm -- 交易开始时间
    ,tran_close_tm -- 交易关闭时间
    ,abmt_msg_fee_bear_way_cd -- 汇入报文费用承担方式代码
    ,remit_oper_tm -- 汇款经办时间
    ,oper_user -- 经办用户
    ,remit_out_msg_fee_bear_way_cd -- 汇出报文费用承担方式代码
    ,pay_type_cd -- 付款类型代码
    ,clear_id -- 清算编号
    ,abmt_comm_fee_curr_cd -- 汇入手续费币种代码
    ,abmt_comm_fee_amt -- 汇入手续费金额
    ,remit_cate_cd -- 汇款类别代码
    ,remit_way_cd -- 汇款方式代码
    ,pay_dt -- 付款日期
    ,cust_type_cd -- 客户类型代码
    ,soe_type_cd -- 结汇类型代码
    ,init_curr_cd -- 原始币种代码
    ,remit_out_comm_fee_curr_cd -- 汇出手续费币种代码
    ,remit_out_comm_fee_amt -- 汇出手续费金额
    ,init_amt -- 原始金额
    ,exch_rat -- 汇率
    ,sell_fx_type_cd -- 售汇类型代码
    ,msg_type_cd -- 报文类型代码
    ,belong_org_id -- 归属机构编号
    ,oper_org_id -- 经办机构编号
    ,remit_proc_type_cd -- 汇款处理类型代码
    ,bal_pay_type_cd -- 收支类型代码
    ,remiter_acct_id -- 汇款人帐户编号
    ,recver_acct_id -- 收款人帐户编号
    ,refund_flg -- 退汇标志
    ,nra_acct_flg -- NRA账户标志
    ,clear_chn_cd -- 清算渠道代码
    ,cbec_flg -- 跨境电商标志
    ,cross_bor_cap_pool_flg -- 跨境资金池标志
    ,cap_pool_bus_type_cd -- 资金池业务类型代码
    ,cap_pool_bus_pric -- 资金池业务本金
    ,cap_pool_bus_int -- 资金池业务利息
    ,entr_pay_id -- 受托支付编号
    ,entr_pay_out_acct_dubil_id -- 受托支付出账借据编号
    ,gpi_remit_flg -- GPI汇款标志
    ,gpi_msg_feedback_status_cd -- GPI报文反馈状态代码
    ,inquiry_flg -- 询价标志
    ,deduct_acct_id -- 扣费账户编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '105010'||P1.INR -- 事件编号
    ,'9999' -- 法人编号
    ,p1.INR -- 源系统编号
    ,p1.NAM -- 交易描述
    ,p2.extkey -- 收款人客户编号
    ,p4.nam -- 收款人地址名称
    ,p1.PYENAM -- 收款人英文名称
    ,p5.extkey -- 付款银行编号
    ,p7.nam -- 付款银行地址名称
    ,p1.PYBNAM -- 付款银行名称
    ,p8.extkey -- 汇款人客户编号
    ,p10.nam -- 汇款人地址名称
    ,p1.ORCNAM -- 汇款人名称
    ,p11.extkey -- 汇款银行编号
    ,p13.nam -- 汇款银行地址名称
    ,p1.ORINAM -- 汇款银行名称
    ,p1.VALDAT -- 起息日期
    ,p1.OPNDAT -- 交易开始时间
    ,p1.CLSDAT -- 交易关闭时间
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||p1.CHATO END -- 汇入报文费用承担方式代码
    ,p1.CREDAT -- 汇款经办时间
    ,p1.OWNUSR -- 经办用户
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||p1.DETCHGCOD END -- 汇出报文费用承担方式代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||p1.PAYTYP END -- 付款类型代码
    ,p1.SYSNO -- 清算编号
    ,nvl(trim(p1.FEECUR),'-') -- 汇入手续费币种代码
    ,p1.FEEAMT -- 汇入手续费金额
    ,CASE WHEN R10.TARGET_CD_VAL IS NOT NULL THEN R10.TARGET_CD_VAL ELSE '@'||p1.TRNTYP END -- 汇款类别代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||p1.PAYTYPE END -- 汇款方式代码
    ,p1.PAYDAT -- 付款日期
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||p1.CLITYP END -- 客户类型代码
    ,' ' -- 结汇类型代码
    ,nvl(trim(p1.CURF33B),'-') -- 原始币种代码
    ,nvl(trim(p1.CUR71F),'-') -- 汇出手续费币种代码
    ,p1.AMT71F -- 汇出手续费金额
    ,p1.AMTF33B -- 原始金额
    ,p1.F36 -- 汇率
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||p1.TRDOUT END -- 售汇类型代码
    ,nvl(trim(p1.SWFTYP),'-') -- 报文类型代码
    ,p1.BRANCHINR -- 归属机构编号
    ,p1.BCHKEYINR -- 经办机构编号
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||p1.ACCMOD END -- 汇款处理类型代码
    ,CASE WHEN R8.TARGET_CD_VAL IS NOT NULL THEN R8.TARGET_CD_VAL ELSE '@'||p1.SZTYP END -- 收支类型代码
    ,p1.ORCACT -- 汇款人帐户编号
    ,p1.PYEACT -- 收款人帐户编号
    ,p1.CANFLG -- 退汇标志
    ,p1.NRAFLG -- NRA账户标志
    ,CASE WHEN R11.TARGET_CD_VAL IS NOT NULL THEN R11.TARGET_CD_VAL ELSE '@'||p1.QSQDBH END -- 清算渠道代码
    ,CASE WHEN P1.ISKDS IN('Y','B') THEN '1' ELSE '0' END -- 跨境电商标志
    ,p1.ZJCFLG -- 跨境资金池标志
    ,CASE WHEN R9.TARGET_CD_VAL IS NOT NULL THEN R9.TARGET_CD_VAL ELSE '@'||p1.EDTYP END -- 资金池业务类型代码
    ,p1.BASAMT -- 资金池业务本金
    ,p1.INTAMT -- 资金池业务利息
    ,p1.STZFREF -- 受托支付编号
    ,p1.DUEBILLNO -- 受托支付出账借据编号
    ,p1.gpiflg -- GPI汇款标志
    ,CASE WHEN R12.TARGET_CD_VAL IS NOT NULL THEN R12.TARGET_CD_VAL ELSE '@'||p1.acstyp END -- GPI报文反馈状态代码
    ,p1.qufflg -- 询价标志
    ,p1.feeacc -- 扣费账户编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'isbs_cpd' -- 源表名称
    ,'isbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_cpd p1
    left join ${iol_schema}.isbs_pty p2 on p1.PYEPTYINR=p2.INR
and p2.start_dt <= to_date('${batch_date}','yyyymmdd') and p2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_pta p3 on p1.PYEPTAINR=p3.INR
and p3.start_dt <= to_date('${batch_date}','yyyymmdd') and p3.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_adr p4 on p3.objinr=p4.INR
and p4.start_dt <= to_date('${batch_date}','yyyymmdd') and p4.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_pty p5 on p1.PYBPTYINR=p5.INR
and p5.start_dt <= to_date('${batch_date}','yyyymmdd') and p5.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_pta p6 on p1.PYBPTAINR=p6.INR
and p6.start_dt <= to_date('${batch_date}','yyyymmdd') and p6.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_adr p7 on p6.objinr=p7.INR
and p7.start_dt <= to_date('${batch_date}','yyyymmdd') and p7.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_pty p8 on p1.ORCPTYINR=p8.INR
and p8.start_dt <= to_date('${batch_date}','yyyymmdd') and p8.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_pta p9 on p1.ORCPTAINR=p9.INR
and p9.start_dt <= to_date('${batch_date}','yyyymmdd') and p9.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_adr p10 on p9.objinr=p10.INR
and p10.start_dt <= to_date('${batch_date}','yyyymmdd') and p10.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_pty p11 on p1.ORIPTYINR=p11.INR
and p11.start_dt <= to_date('${batch_date}','yyyymmdd') and p11.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_pta p12 on p1.ORIPTAINR=p12.INR
and p12.start_dt <= to_date('${batch_date}','yyyymmdd') and p12.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_adr p13 on p12.objinr=p13.INR
and p13.start_dt <= to_date('${batch_date}','yyyymmdd') and p13.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r1 on nvl(P1.CHATO,' ') = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ISBS'
        AND R1.SRC_TAB_EN_NAME= 'ISBS_CPD'
        AND R1.SRC_FIELD_EN_NAME= 'CHATO'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_INTSTL_REMIT_EVT'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'ABMT_MSG_FEE_BEAR_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on nvl(P1.DETCHGCOD,' ') = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ISBS'
        AND R2.SRC_TAB_EN_NAME= 'ISBS_CPD'
        AND R2.SRC_FIELD_EN_NAME= 'DETCHGCOD'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_INTSTL_REMIT_EVT'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'REMIT_OUT_MSG_FEE_BEAR_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on nvl(P1.PAYTYP,' ') = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'ISBS'
        AND R3.SRC_TAB_EN_NAME= 'ISBS_CPD'
        AND R3.SRC_FIELD_EN_NAME= 'PAYTYP'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_INTSTL_REMIT_EVT'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'PAY_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r10 on nvl(P1.TRNTYP,' ') = R10.SRC_CODE_VAL
        AND R10.SORC_SYS_CD= 'ISBS'
        AND R10.SRC_TAB_EN_NAME= 'ISBS_CPD'
        AND R10.SRC_FIELD_EN_NAME= 'TRNTYP'
        AND R10.TARGET_TAB_EN_NAME= 'EVT_INTSTL_REMIT_EVT'
        AND R10.TARGET_TAB_FIELD_EN_NAME= 'REMIT_CATE_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on nvl(P1.PAYTYPE,' ') = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'ISBS'
        AND R4.SRC_TAB_EN_NAME= 'ISBS_CPD'
        AND R4.SRC_FIELD_EN_NAME= 'PAYTYPE'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_INTSTL_REMIT_EVT'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'REMIT_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on nvl(P1.CLITYP,' ') = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'ISBS'
        AND R5.SRC_TAB_EN_NAME= 'ISBS_CPD'
        AND R5.SRC_FIELD_EN_NAME= 'CLITYP'
        AND R5.TARGET_TAB_EN_NAME= 'EVT_INTSTL_REMIT_EVT'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on nvl(P1.TRDOUT,' ') = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'ISBS'
        AND R6.SRC_TAB_EN_NAME= 'ISBS_CPD'
        AND R6.SRC_FIELD_EN_NAME= 'TRDOUT'
        AND R6.TARGET_TAB_EN_NAME= 'EVT_INTSTL_REMIT_EVT'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'SELL_FX_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on nvl(P1.ACCMOD,' ') = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'ISBS'
        AND R7.SRC_TAB_EN_NAME= 'ISBS_CPD'
        AND R7.SRC_FIELD_EN_NAME= 'ACCMOD'
        AND R7.TARGET_TAB_EN_NAME= 'EVT_INTSTL_REMIT_EVT'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'REMIT_PROC_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r8 on nvl(P1.SZTYP,' ') = R8.SRC_CODE_VAL
        AND R8.SORC_SYS_CD= 'ISBS'
        AND R8.SRC_TAB_EN_NAME= 'ISBS_CPD'
        AND R8.SRC_FIELD_EN_NAME= 'SZTYP'
        AND R8.TARGET_TAB_EN_NAME= 'EVT_INTSTL_REMIT_EVT'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'BAL_PAY_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r11 on nvl(P1.QSQDBH,' ') = R11.SRC_CODE_VAL
        AND R11.SORC_SYS_CD= 'ISBS'
        AND R11.SRC_TAB_EN_NAME= 'ISBS_CPD'
        AND R11.SRC_FIELD_EN_NAME= 'QSQDBH'
        AND R11.TARGET_TAB_EN_NAME= 'EVT_INTSTL_REMIT_EVT'
        AND R11.TARGET_TAB_FIELD_EN_NAME= 'CLEAR_CHN_CD'
    left join ${iml_schema}.ref_pub_cd_map r9 on nvl(P1.EDTYP,' ') = R9.SRC_CODE_VAL
        AND R9.SORC_SYS_CD= 'ISBS'
        AND R9.SRC_TAB_EN_NAME= 'ISBS_CPD'
        AND R9.SRC_FIELD_EN_NAME= 'EDTYP'
        AND R9.TARGET_TAB_EN_NAME= 'EVT_INTSTL_REMIT_EVT'
        AND R9.TARGET_TAB_FIELD_EN_NAME= 'CAP_POOL_BUS_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r12 on nvl(P1.ACSTYP,' ') = R12.SRC_CODE_VAL
        AND R12.SORC_SYS_CD= 'ISBS'
        AND R12.SRC_TAB_EN_NAME= 'ISBS_CPD'
        AND R12.SRC_FIELD_EN_NAME= 'ACSTYP'
        AND R12.TARGET_TAB_EN_NAME= 'EVT_INTSTL_REMIT_EVT'
        AND R12.TARGET_TAB_FIELD_EN_NAME= 'GPI_MSG_FEEDBACK_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_intstl_remit_evt_isbsf1_tm 
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
        into ${iml_schema}.evt_intstl_remit_evt_isbsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,sorc_sys_id -- 源系统编号
    ,tran_descb -- 交易描述
    ,recver_cust_id -- 收款人客户编号
    ,recver_addr_name -- 收款人地址名称
    ,recver_en_name -- 收款人英文名称
    ,pay_bank_id -- 付款银行编号
    ,pay_bank_addr_name -- 付款银行地址名称
    ,pay_bank_name -- 付款银行名称
    ,remiter_cust_id -- 汇款人客户编号
    ,remiter_addr_name -- 汇款人地址名称
    ,remiter_name -- 汇款人名称
    ,remit_bank_id -- 汇款银行编号
    ,remit_bank_addr_name -- 汇款银行地址名称
    ,remit_bank_name -- 汇款银行名称
    ,value_dt -- 起息日期
    ,tran_start_tm -- 交易开始时间
    ,tran_close_tm -- 交易关闭时间
    ,abmt_msg_fee_bear_way_cd -- 汇入报文费用承担方式代码
    ,remit_oper_tm -- 汇款经办时间
    ,oper_user -- 经办用户
    ,remit_out_msg_fee_bear_way_cd -- 汇出报文费用承担方式代码
    ,pay_type_cd -- 付款类型代码
    ,clear_id -- 清算编号
    ,abmt_comm_fee_curr_cd -- 汇入手续费币种代码
    ,abmt_comm_fee_amt -- 汇入手续费金额
    ,remit_cate_cd -- 汇款类别代码
    ,remit_way_cd -- 汇款方式代码
    ,pay_dt -- 付款日期
    ,cust_type_cd -- 客户类型代码
    ,soe_type_cd -- 结汇类型代码
    ,init_curr_cd -- 原始币种代码
    ,remit_out_comm_fee_curr_cd -- 汇出手续费币种代码
    ,remit_out_comm_fee_amt -- 汇出手续费金额
    ,init_amt -- 原始金额
    ,exch_rat -- 汇率
    ,sell_fx_type_cd -- 售汇类型代码
    ,msg_type_cd -- 报文类型代码
    ,belong_org_id -- 归属机构编号
    ,oper_org_id -- 经办机构编号
    ,remit_proc_type_cd -- 汇款处理类型代码
    ,bal_pay_type_cd -- 收支类型代码
    ,remiter_acct_id -- 汇款人帐户编号
    ,recver_acct_id -- 收款人帐户编号
    ,refund_flg -- 退汇标志
    ,nra_acct_flg -- NRA账户标志
    ,clear_chn_cd -- 清算渠道代码
    ,cbec_flg -- 跨境电商标志
    ,cross_bor_cap_pool_flg -- 跨境资金池标志
    ,cap_pool_bus_type_cd -- 资金池业务类型代码
    ,cap_pool_bus_pric -- 资金池业务本金
    ,cap_pool_bus_int -- 资金池业务利息
    ,entr_pay_id -- 受托支付编号
    ,entr_pay_out_acct_dubil_id -- 受托支付出账借据编号
    ,gpi_remit_flg -- GPI汇款标志
    ,gpi_msg_feedback_status_cd -- GPI报文反馈状态代码
    ,inquiry_flg -- 询价标志
    ,deduct_acct_id -- 扣费账户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_intstl_remit_evt_isbsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,sorc_sys_id -- 源系统编号
    ,tran_descb -- 交易描述
    ,recver_cust_id -- 收款人客户编号
    ,recver_addr_name -- 收款人地址名称
    ,recver_en_name -- 收款人英文名称
    ,pay_bank_id -- 付款银行编号
    ,pay_bank_addr_name -- 付款银行地址名称
    ,pay_bank_name -- 付款银行名称
    ,remiter_cust_id -- 汇款人客户编号
    ,remiter_addr_name -- 汇款人地址名称
    ,remiter_name -- 汇款人名称
    ,remit_bank_id -- 汇款银行编号
    ,remit_bank_addr_name -- 汇款银行地址名称
    ,remit_bank_name -- 汇款银行名称
    ,value_dt -- 起息日期
    ,tran_start_tm -- 交易开始时间
    ,tran_close_tm -- 交易关闭时间
    ,abmt_msg_fee_bear_way_cd -- 汇入报文费用承担方式代码
    ,remit_oper_tm -- 汇款经办时间
    ,oper_user -- 经办用户
    ,remit_out_msg_fee_bear_way_cd -- 汇出报文费用承担方式代码
    ,pay_type_cd -- 付款类型代码
    ,clear_id -- 清算编号
    ,abmt_comm_fee_curr_cd -- 汇入手续费币种代码
    ,abmt_comm_fee_amt -- 汇入手续费金额
    ,remit_cate_cd -- 汇款类别代码
    ,remit_way_cd -- 汇款方式代码
    ,pay_dt -- 付款日期
    ,cust_type_cd -- 客户类型代码
    ,soe_type_cd -- 结汇类型代码
    ,init_curr_cd -- 原始币种代码
    ,remit_out_comm_fee_curr_cd -- 汇出手续费币种代码
    ,remit_out_comm_fee_amt -- 汇出手续费金额
    ,init_amt -- 原始金额
    ,exch_rat -- 汇率
    ,sell_fx_type_cd -- 售汇类型代码
    ,msg_type_cd -- 报文类型代码
    ,belong_org_id -- 归属机构编号
    ,oper_org_id -- 经办机构编号
    ,remit_proc_type_cd -- 汇款处理类型代码
    ,bal_pay_type_cd -- 收支类型代码
    ,remiter_acct_id -- 汇款人帐户编号
    ,recver_acct_id -- 收款人帐户编号
    ,refund_flg -- 退汇标志
    ,nra_acct_flg -- NRA账户标志
    ,clear_chn_cd -- 清算渠道代码
    ,cbec_flg -- 跨境电商标志
    ,cross_bor_cap_pool_flg -- 跨境资金池标志
    ,cap_pool_bus_type_cd -- 资金池业务类型代码
    ,cap_pool_bus_pric -- 资金池业务本金
    ,cap_pool_bus_int -- 资金池业务利息
    ,entr_pay_id -- 受托支付编号
    ,entr_pay_out_acct_dubil_id -- 受托支付出账借据编号
    ,gpi_remit_flg -- GPI汇款标志
    ,gpi_msg_feedback_status_cd -- GPI报文反馈状态代码
    ,inquiry_flg -- 询价标志
    ,deduct_acct_id -- 扣费账户编号
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
    ,nvl(n.sorc_sys_id, o.sorc_sys_id) as sorc_sys_id -- 源系统编号
    ,nvl(n.tran_descb, o.tran_descb) as tran_descb -- 交易描述
    ,nvl(n.recver_cust_id, o.recver_cust_id) as recver_cust_id -- 收款人客户编号
    ,nvl(n.recver_addr_name, o.recver_addr_name) as recver_addr_name -- 收款人地址名称
    ,nvl(n.recver_en_name, o.recver_en_name) as recver_en_name -- 收款人英文名称
    ,nvl(n.pay_bank_id, o.pay_bank_id) as pay_bank_id -- 付款银行编号
    ,nvl(n.pay_bank_addr_name, o.pay_bank_addr_name) as pay_bank_addr_name -- 付款银行地址名称
    ,nvl(n.pay_bank_name, o.pay_bank_name) as pay_bank_name -- 付款银行名称
    ,nvl(n.remiter_cust_id, o.remiter_cust_id) as remiter_cust_id -- 汇款人客户编号
    ,nvl(n.remiter_addr_name, o.remiter_addr_name) as remiter_addr_name -- 汇款人地址名称
    ,nvl(n.remiter_name, o.remiter_name) as remiter_name -- 汇款人名称
    ,nvl(n.remit_bank_id, o.remit_bank_id) as remit_bank_id -- 汇款银行编号
    ,nvl(n.remit_bank_addr_name, o.remit_bank_addr_name) as remit_bank_addr_name -- 汇款银行地址名称
    ,nvl(n.remit_bank_name, o.remit_bank_name) as remit_bank_name -- 汇款银行名称
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.tran_start_tm, o.tran_start_tm) as tran_start_tm -- 交易开始时间
    ,nvl(n.tran_close_tm, o.tran_close_tm) as tran_close_tm -- 交易关闭时间
    ,nvl(n.abmt_msg_fee_bear_way_cd, o.abmt_msg_fee_bear_way_cd) as abmt_msg_fee_bear_way_cd -- 汇入报文费用承担方式代码
    ,nvl(n.remit_oper_tm, o.remit_oper_tm) as remit_oper_tm -- 汇款经办时间
    ,nvl(n.oper_user, o.oper_user) as oper_user -- 经办用户
    ,nvl(n.remit_out_msg_fee_bear_way_cd, o.remit_out_msg_fee_bear_way_cd) as remit_out_msg_fee_bear_way_cd -- 汇出报文费用承担方式代码
    ,nvl(n.pay_type_cd, o.pay_type_cd) as pay_type_cd -- 付款类型代码
    ,nvl(n.clear_id, o.clear_id) as clear_id -- 清算编号
    ,nvl(n.abmt_comm_fee_curr_cd, o.abmt_comm_fee_curr_cd) as abmt_comm_fee_curr_cd -- 汇入手续费币种代码
    ,nvl(n.abmt_comm_fee_amt, o.abmt_comm_fee_amt) as abmt_comm_fee_amt -- 汇入手续费金额
    ,nvl(n.remit_cate_cd, o.remit_cate_cd) as remit_cate_cd -- 汇款类别代码
    ,nvl(n.remit_way_cd, o.remit_way_cd) as remit_way_cd -- 汇款方式代码
    ,nvl(n.pay_dt, o.pay_dt) as pay_dt -- 付款日期
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.soe_type_cd, o.soe_type_cd) as soe_type_cd -- 结汇类型代码
    ,nvl(n.init_curr_cd, o.init_curr_cd) as init_curr_cd -- 原始币种代码
    ,nvl(n.remit_out_comm_fee_curr_cd, o.remit_out_comm_fee_curr_cd) as remit_out_comm_fee_curr_cd -- 汇出手续费币种代码
    ,nvl(n.remit_out_comm_fee_amt, o.remit_out_comm_fee_amt) as remit_out_comm_fee_amt -- 汇出手续费金额
    ,nvl(n.init_amt, o.init_amt) as init_amt -- 原始金额
    ,nvl(n.exch_rat, o.exch_rat) as exch_rat -- 汇率
    ,nvl(n.sell_fx_type_cd, o.sell_fx_type_cd) as sell_fx_type_cd -- 售汇类型代码
    ,nvl(n.msg_type_cd, o.msg_type_cd) as msg_type_cd -- 报文类型代码
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 归属机构编号
    ,nvl(n.oper_org_id, o.oper_org_id) as oper_org_id -- 经办机构编号
    ,nvl(n.remit_proc_type_cd, o.remit_proc_type_cd) as remit_proc_type_cd -- 汇款处理类型代码
    ,nvl(n.bal_pay_type_cd, o.bal_pay_type_cd) as bal_pay_type_cd -- 收支类型代码
    ,nvl(n.remiter_acct_id, o.remiter_acct_id) as remiter_acct_id -- 汇款人帐户编号
    ,nvl(n.recver_acct_id, o.recver_acct_id) as recver_acct_id -- 收款人帐户编号
    ,nvl(n.refund_flg, o.refund_flg) as refund_flg -- 退汇标志
    ,nvl(n.nra_acct_flg, o.nra_acct_flg) as nra_acct_flg -- NRA账户标志
    ,nvl(n.clear_chn_cd, o.clear_chn_cd) as clear_chn_cd -- 清算渠道代码
    ,nvl(n.cbec_flg, o.cbec_flg) as cbec_flg -- 跨境电商标志
    ,nvl(n.cross_bor_cap_pool_flg, o.cross_bor_cap_pool_flg) as cross_bor_cap_pool_flg -- 跨境资金池标志
    ,nvl(n.cap_pool_bus_type_cd, o.cap_pool_bus_type_cd) as cap_pool_bus_type_cd -- 资金池业务类型代码
    ,nvl(n.cap_pool_bus_pric, o.cap_pool_bus_pric) as cap_pool_bus_pric -- 资金池业务本金
    ,nvl(n.cap_pool_bus_int, o.cap_pool_bus_int) as cap_pool_bus_int -- 资金池业务利息
    ,nvl(n.entr_pay_id, o.entr_pay_id) as entr_pay_id -- 受托支付编号
    ,nvl(n.entr_pay_out_acct_dubil_id, o.entr_pay_out_acct_dubil_id) as entr_pay_out_acct_dubil_id -- 受托支付出账借据编号
    ,nvl(n.gpi_remit_flg, o.gpi_remit_flg) as gpi_remit_flg -- GPI汇款标志
    ,nvl(n.gpi_msg_feedback_status_cd, o.gpi_msg_feedback_status_cd) as gpi_msg_feedback_status_cd -- GPI报文反馈状态代码
    ,nvl(n.inquiry_flg, o.inquiry_flg) as inquiry_flg -- 询价标志
    ,nvl(n.deduct_acct_id, o.deduct_acct_id) as deduct_acct_id -- 扣费账户编号
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
from ${iml_schema}.evt_intstl_remit_evt_isbsf1_tm n
    full join (select * from ${iml_schema}.evt_intstl_remit_evt_isbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.sorc_sys_id <> n.sorc_sys_id
        or o.tran_descb <> n.tran_descb
        or o.recver_cust_id <> n.recver_cust_id
        or o.recver_addr_name <> n.recver_addr_name
        or o.recver_en_name <> n.recver_en_name
        or o.pay_bank_id <> n.pay_bank_id
        or o.pay_bank_addr_name <> n.pay_bank_addr_name
        or o.pay_bank_name <> n.pay_bank_name
        or o.remiter_cust_id <> n.remiter_cust_id
        or o.remiter_addr_name <> n.remiter_addr_name
        or o.remiter_name <> n.remiter_name
        or o.remit_bank_id <> n.remit_bank_id
        or o.remit_bank_addr_name <> n.remit_bank_addr_name
        or o.remit_bank_name <> n.remit_bank_name
        or o.value_dt <> n.value_dt
        or o.tran_start_tm <> n.tran_start_tm
        or o.tran_close_tm <> n.tran_close_tm
        or o.abmt_msg_fee_bear_way_cd <> n.abmt_msg_fee_bear_way_cd
        or o.remit_oper_tm <> n.remit_oper_tm
        or o.oper_user <> n.oper_user
        or o.remit_out_msg_fee_bear_way_cd <> n.remit_out_msg_fee_bear_way_cd
        or o.pay_type_cd <> n.pay_type_cd
        or o.clear_id <> n.clear_id
        or o.abmt_comm_fee_curr_cd <> n.abmt_comm_fee_curr_cd
        or o.abmt_comm_fee_amt <> n.abmt_comm_fee_amt
        or o.remit_cate_cd <> n.remit_cate_cd
        or o.remit_way_cd <> n.remit_way_cd
        or o.pay_dt <> n.pay_dt
        or o.cust_type_cd <> n.cust_type_cd
        or o.soe_type_cd <> n.soe_type_cd
        or o.init_curr_cd <> n.init_curr_cd
        or o.remit_out_comm_fee_curr_cd <> n.remit_out_comm_fee_curr_cd
        or o.remit_out_comm_fee_amt <> n.remit_out_comm_fee_amt
        or o.init_amt <> n.init_amt
        or o.exch_rat <> n.exch_rat
        or o.sell_fx_type_cd <> n.sell_fx_type_cd
        or o.msg_type_cd <> n.msg_type_cd
        or o.belong_org_id <> n.belong_org_id
        or o.oper_org_id <> n.oper_org_id
        or o.remit_proc_type_cd <> n.remit_proc_type_cd
        or o.bal_pay_type_cd <> n.bal_pay_type_cd
        or o.remiter_acct_id <> n.remiter_acct_id
        or o.recver_acct_id <> n.recver_acct_id
        or o.refund_flg <> n.refund_flg
        or o.nra_acct_flg <> n.nra_acct_flg
        or o.clear_chn_cd <> n.clear_chn_cd
        or o.cbec_flg <> n.cbec_flg
        or o.cross_bor_cap_pool_flg <> n.cross_bor_cap_pool_flg
        or o.cap_pool_bus_type_cd <> n.cap_pool_bus_type_cd
        or o.cap_pool_bus_pric <> n.cap_pool_bus_pric
        or o.cap_pool_bus_int <> n.cap_pool_bus_int
        or o.entr_pay_id <> n.entr_pay_id
        or o.entr_pay_out_acct_dubil_id <> n.entr_pay_out_acct_dubil_id
        or o.gpi_remit_flg <> n.gpi_remit_flg
        or o.gpi_msg_feedback_status_cd <> n.gpi_msg_feedback_status_cd
        or o.inquiry_flg <> n.inquiry_flg
        or o.deduct_acct_id <> n.deduct_acct_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_intstl_remit_evt_isbsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,sorc_sys_id -- 源系统编号
    ,tran_descb -- 交易描述
    ,recver_cust_id -- 收款人客户编号
    ,recver_addr_name -- 收款人地址名称
    ,recver_en_name -- 收款人英文名称
    ,pay_bank_id -- 付款银行编号
    ,pay_bank_addr_name -- 付款银行地址名称
    ,pay_bank_name -- 付款银行名称
    ,remiter_cust_id -- 汇款人客户编号
    ,remiter_addr_name -- 汇款人地址名称
    ,remiter_name -- 汇款人名称
    ,remit_bank_id -- 汇款银行编号
    ,remit_bank_addr_name -- 汇款银行地址名称
    ,remit_bank_name -- 汇款银行名称
    ,value_dt -- 起息日期
    ,tran_start_tm -- 交易开始时间
    ,tran_close_tm -- 交易关闭时间
    ,abmt_msg_fee_bear_way_cd -- 汇入报文费用承担方式代码
    ,remit_oper_tm -- 汇款经办时间
    ,oper_user -- 经办用户
    ,remit_out_msg_fee_bear_way_cd -- 汇出报文费用承担方式代码
    ,pay_type_cd -- 付款类型代码
    ,clear_id -- 清算编号
    ,abmt_comm_fee_curr_cd -- 汇入手续费币种代码
    ,abmt_comm_fee_amt -- 汇入手续费金额
    ,remit_cate_cd -- 汇款类别代码
    ,remit_way_cd -- 汇款方式代码
    ,pay_dt -- 付款日期
    ,cust_type_cd -- 客户类型代码
    ,soe_type_cd -- 结汇类型代码
    ,init_curr_cd -- 原始币种代码
    ,remit_out_comm_fee_curr_cd -- 汇出手续费币种代码
    ,remit_out_comm_fee_amt -- 汇出手续费金额
    ,init_amt -- 原始金额
    ,exch_rat -- 汇率
    ,sell_fx_type_cd -- 售汇类型代码
    ,msg_type_cd -- 报文类型代码
    ,belong_org_id -- 归属机构编号
    ,oper_org_id -- 经办机构编号
    ,remit_proc_type_cd -- 汇款处理类型代码
    ,bal_pay_type_cd -- 收支类型代码
    ,remiter_acct_id -- 汇款人帐户编号
    ,recver_acct_id -- 收款人帐户编号
    ,refund_flg -- 退汇标志
    ,nra_acct_flg -- NRA账户标志
    ,clear_chn_cd -- 清算渠道代码
    ,cbec_flg -- 跨境电商标志
    ,cross_bor_cap_pool_flg -- 跨境资金池标志
    ,cap_pool_bus_type_cd -- 资金池业务类型代码
    ,cap_pool_bus_pric -- 资金池业务本金
    ,cap_pool_bus_int -- 资金池业务利息
    ,entr_pay_id -- 受托支付编号
    ,entr_pay_out_acct_dubil_id -- 受托支付出账借据编号
    ,gpi_remit_flg -- GPI汇款标志
    ,gpi_msg_feedback_status_cd -- GPI报文反馈状态代码
    ,inquiry_flg -- 询价标志
    ,deduct_acct_id -- 扣费账户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_intstl_remit_evt_isbsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,sorc_sys_id -- 源系统编号
    ,tran_descb -- 交易描述
    ,recver_cust_id -- 收款人客户编号
    ,recver_addr_name -- 收款人地址名称
    ,recver_en_name -- 收款人英文名称
    ,pay_bank_id -- 付款银行编号
    ,pay_bank_addr_name -- 付款银行地址名称
    ,pay_bank_name -- 付款银行名称
    ,remiter_cust_id -- 汇款人客户编号
    ,remiter_addr_name -- 汇款人地址名称
    ,remiter_name -- 汇款人名称
    ,remit_bank_id -- 汇款银行编号
    ,remit_bank_addr_name -- 汇款银行地址名称
    ,remit_bank_name -- 汇款银行名称
    ,value_dt -- 起息日期
    ,tran_start_tm -- 交易开始时间
    ,tran_close_tm -- 交易关闭时间
    ,abmt_msg_fee_bear_way_cd -- 汇入报文费用承担方式代码
    ,remit_oper_tm -- 汇款经办时间
    ,oper_user -- 经办用户
    ,remit_out_msg_fee_bear_way_cd -- 汇出报文费用承担方式代码
    ,pay_type_cd -- 付款类型代码
    ,clear_id -- 清算编号
    ,abmt_comm_fee_curr_cd -- 汇入手续费币种代码
    ,abmt_comm_fee_amt -- 汇入手续费金额
    ,remit_cate_cd -- 汇款类别代码
    ,remit_way_cd -- 汇款方式代码
    ,pay_dt -- 付款日期
    ,cust_type_cd -- 客户类型代码
    ,soe_type_cd -- 结汇类型代码
    ,init_curr_cd -- 原始币种代码
    ,remit_out_comm_fee_curr_cd -- 汇出手续费币种代码
    ,remit_out_comm_fee_amt -- 汇出手续费金额
    ,init_amt -- 原始金额
    ,exch_rat -- 汇率
    ,sell_fx_type_cd -- 售汇类型代码
    ,msg_type_cd -- 报文类型代码
    ,belong_org_id -- 归属机构编号
    ,oper_org_id -- 经办机构编号
    ,remit_proc_type_cd -- 汇款处理类型代码
    ,bal_pay_type_cd -- 收支类型代码
    ,remiter_acct_id -- 汇款人帐户编号
    ,recver_acct_id -- 收款人帐户编号
    ,refund_flg -- 退汇标志
    ,nra_acct_flg -- NRA账户标志
    ,clear_chn_cd -- 清算渠道代码
    ,cbec_flg -- 跨境电商标志
    ,cross_bor_cap_pool_flg -- 跨境资金池标志
    ,cap_pool_bus_type_cd -- 资金池业务类型代码
    ,cap_pool_bus_pric -- 资金池业务本金
    ,cap_pool_bus_int -- 资金池业务利息
    ,entr_pay_id -- 受托支付编号
    ,entr_pay_out_acct_dubil_id -- 受托支付出账借据编号
    ,gpi_remit_flg -- GPI汇款标志
    ,gpi_msg_feedback_status_cd -- GPI报文反馈状态代码
    ,inquiry_flg -- 询价标志
    ,deduct_acct_id -- 扣费账户编号
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
    ,o.sorc_sys_id -- 源系统编号
    ,o.tran_descb -- 交易描述
    ,o.recver_cust_id -- 收款人客户编号
    ,o.recver_addr_name -- 收款人地址名称
    ,o.recver_en_name -- 收款人英文名称
    ,o.pay_bank_id -- 付款银行编号
    ,o.pay_bank_addr_name -- 付款银行地址名称
    ,o.pay_bank_name -- 付款银行名称
    ,o.remiter_cust_id -- 汇款人客户编号
    ,o.remiter_addr_name -- 汇款人地址名称
    ,o.remiter_name -- 汇款人名称
    ,o.remit_bank_id -- 汇款银行编号
    ,o.remit_bank_addr_name -- 汇款银行地址名称
    ,o.remit_bank_name -- 汇款银行名称
    ,o.value_dt -- 起息日期
    ,o.tran_start_tm -- 交易开始时间
    ,o.tran_close_tm -- 交易关闭时间
    ,o.abmt_msg_fee_bear_way_cd -- 汇入报文费用承担方式代码
    ,o.remit_oper_tm -- 汇款经办时间
    ,o.oper_user -- 经办用户
    ,o.remit_out_msg_fee_bear_way_cd -- 汇出报文费用承担方式代码
    ,o.pay_type_cd -- 付款类型代码
    ,o.clear_id -- 清算编号
    ,o.abmt_comm_fee_curr_cd -- 汇入手续费币种代码
    ,o.abmt_comm_fee_amt -- 汇入手续费金额
    ,o.remit_cate_cd -- 汇款类别代码
    ,o.remit_way_cd -- 汇款方式代码
    ,o.pay_dt -- 付款日期
    ,o.cust_type_cd -- 客户类型代码
    ,o.soe_type_cd -- 结汇类型代码
    ,o.init_curr_cd -- 原始币种代码
    ,o.remit_out_comm_fee_curr_cd -- 汇出手续费币种代码
    ,o.remit_out_comm_fee_amt -- 汇出手续费金额
    ,o.init_amt -- 原始金额
    ,o.exch_rat -- 汇率
    ,o.sell_fx_type_cd -- 售汇类型代码
    ,o.msg_type_cd -- 报文类型代码
    ,o.belong_org_id -- 归属机构编号
    ,o.oper_org_id -- 经办机构编号
    ,o.remit_proc_type_cd -- 汇款处理类型代码
    ,o.bal_pay_type_cd -- 收支类型代码
    ,o.remiter_acct_id -- 汇款人帐户编号
    ,o.recver_acct_id -- 收款人帐户编号
    ,o.refund_flg -- 退汇标志
    ,o.nra_acct_flg -- NRA账户标志
    ,o.clear_chn_cd -- 清算渠道代码
    ,o.cbec_flg -- 跨境电商标志
    ,o.cross_bor_cap_pool_flg -- 跨境资金池标志
    ,o.cap_pool_bus_type_cd -- 资金池业务类型代码
    ,o.cap_pool_bus_pric -- 资金池业务本金
    ,o.cap_pool_bus_int -- 资金池业务利息
    ,o.entr_pay_id -- 受托支付编号
    ,o.entr_pay_out_acct_dubil_id -- 受托支付出账借据编号
    ,o.gpi_remit_flg -- GPI汇款标志
    ,o.gpi_msg_feedback_status_cd -- GPI报文反馈状态代码
    ,o.inquiry_flg -- 询价标志
    ,o.deduct_acct_id -- 扣费账户编号
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
from ${iml_schema}.evt_intstl_remit_evt_isbsf1_bk o
    left join ${iml_schema}.evt_intstl_remit_evt_isbsf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_intstl_remit_evt_isbsf1_cl d
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
--truncate table ${iml_schema}.evt_intstl_remit_evt;
--alter table ${iml_schema}.evt_intstl_remit_evt truncate partition for ('isbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_intstl_remit_evt') 
               and substr(subpartition_name,1,8)=upper('p_isbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_intstl_remit_evt drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.evt_intstl_remit_evt modify partition p_isbsf1 
add subpartition p_isbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_intstl_remit_evt exchange subpartition p_isbsf1_${batch_date} with table ${iml_schema}.evt_intstl_remit_evt_isbsf1_cl;
alter table ${iml_schema}.evt_intstl_remit_evt exchange subpartition p_isbsf1_20991231 with table ${iml_schema}.evt_intstl_remit_evt_isbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_intstl_remit_evt to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_intstl_remit_evt_isbsf1_tm purge;
drop table ${iml_schema}.evt_intstl_remit_evt_isbsf1_op purge;
drop table ${iml_schema}.evt_intstl_remit_evt_isbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_intstl_remit_evt_isbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_intstl_remit_evt', partname => 'p_isbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
