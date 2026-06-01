/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_cbps_tran_flow_mpcsi1
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
alter table ${iml_schema}.evt_cbps_tran_flow add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_cbps_tran_flow modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;


set serveroutput on
--set line 200;
declare bat_dt varchar2(10);
    v_p_exists varchar2(10);
    v_sql varchar2(200);
begin    
--dbms_output.put_line('BBB');
for i in 0 .. 14 loop
    bat_dt := to_char(to_date('${batch_date}','yyyymmdd') - i,'yyyymmdd');
    v_sql := 'select count(0) from user_tab_subpartitions where table_name = upper(''evt_cbps_tran_flow'') and subpartition_name = ''P_MPCSI1_'||bat_dt||''' ';
    dbms_output.put_line(v_sql);
    execute immediate v_sql into v_p_exists;
    dbms_output.put_line(v_p_exists);
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iml.evt_cbps_tran_flow truncate subpartition P_MPCSI1_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    dbms_output.put_line('BBB');  
    --no exists partitions  
    else 
        v_sql := 'alter table iml.evt_cbps_tran_flow modify partition p_mpcsi1 add subpartition P_MPCSI1_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
        dbms_output.put_line('AAA');
    end if;
      end loop;
end;
/


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a1rtcbpstrx-
insert into ${iml_schema}.evt_cbps_tran_flow(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,sys_id -- 系统编号
    ,midgrod_flow_num -- 中台流水号
    ,midgrod_tran_dt -- 中台交易日期
    ,midgrod_tran_tm -- 中台交易时间
    ,msg_type_id -- 报文类型编号
    ,origi_bank_no -- 发起行行号
    ,init_clear_bk_no -- 发起清算行行号
    ,recv_bank_no -- 接收行行号
    ,recv_clear_bk_no -- 接收清算行行号
    ,entr_dt -- 委托日期
    ,msg_idf_id -- 报文标识编号
    ,dtl_idf_id -- 明细标识编号
    ,bank_int_bus_seq_num -- 行内业务序号
    ,midgrod_tran_code -- 中台交易码
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,nostro_cd -- 往来账代码
    ,debit_crdt_dir_cd -- 借贷方向代码
    ,core_tran_code -- 核心交易码
    ,core_tran_dt -- 核心交易日期
    ,core_flow_num -- 核心流水号
    ,entr_tm -- 委托时间
    ,payer_open_belong_city_cd -- 付款人开户行所属城市代码
    ,pay_clear_bk_no -- 付款清算行行号
    ,payer_open_dept_id -- 付款人开户行部门编号
    ,payer_open_no -- 付款人开户行行号
    ,payer_open_bank_name -- 付款人开户行名称
    ,payer_acct_type_cd -- 付款人账户类型代码
    ,payer_acct_num -- 付款人账号
    ,payer_name -- 付款人名称
    ,payer_addr -- 付款人地址
    ,recver_open_belong_city_cd -- 收款人开户行所属城市代码
    ,recver_open_bank_no -- 收款人开户行行号
    ,recvbl_clear_bk_no -- 收款清算行行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,recver_acct_type_cd -- 收款人账户类型代码
    ,recver_acct_num -- 收款人账号
    ,recver_name -- 收款人名称
    ,recver_addr -- 收款人地址
    ,bus_type_cd -- 业务类型代码
    ,bus_kind_cd -- 业务种类代码
    ,init_entr_dt -- 原委托日期
    ,init_msg_idf_id -- 原报文标识编号
    ,init_origi_bank_no -- 原发起行行号
    ,init_msg_type_id -- 原报文类型编号
    ,mode_pay_cd -- 支付方式代码
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_dt -- 凭证日期
    ,vouch_no -- 凭证号码
    ,prior_level -- 优先级别
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,refund_rs_descb -- 退汇原因描述
    ,tran_chn_cd -- 交易渠道代码
    ,tran_lmt -- 转账限额
    ,err_return_code -- 错误返回码
    ,err_info_desc -- 错误信息描述
    ,recv_tm -- 接收时间
    ,rtn_rcpt_msg_idf_id -- 回执报文标识编号
    ,cbps_bus_status_cd -- 城银清算业务状态代码
    ,offs_bal_num_site -- 轧差场次
    ,offs_bal_dt -- 轧差日期
    ,cbps_bus_process_cd -- 城银清算业务处理码
    ,clear_dt -- 清算日期
    ,bus_check_entry_status_cd -- 业务对账状态代码
    ,core_check_entry_status_cd -- 核心对账状态代码
    ,tran_status_cd -- 交易状态代码
    ,tran_rest_descb -- 交易结果描述
    ,update_tm -- 更新时间
    ,mgmt_org_id -- 管理机构编号
    ,on_acct_rs_cd -- 挂账原因代码
    ,on_acct_rs_comnt -- 挂账原因说明
    ,on_acct_dt -- 挂账日期
    ,on_acct_teller_id -- 挂账柜员编号
    ,on_acct_org_id -- 挂账机构编号
    ,on_acct_acct_num -- 挂账账号
    ,on_acct_acct_name -- 挂账账户名称
    ,matn_enter_acct_dt -- 维护入账日期
    ,matn_enter_acct_teller_id -- 维护入账柜员编号
    ,matn_enter_acct_org_id -- 维护入账机构编号
    ,matn_enter_acct_num -- 维护入账账号
    ,matn_enter_name -- 维护入账账户名称
    ,revs_teller_id -- 冲正柜员编号
    ,revs_tran_flow_num -- 冲正交易流水号
    ,revs_dt -- 冲正日期
    ,intnal_acct_flg -- 内部账标志
    ,actl_deduct_acct_num -- 实际扣账账号
    ,actl_deduct_acct_name -- 实际扣账账户名称
    ,e_acct_flg -- 电子账户标志
    ,acct_type_cd -- 账户类型代码
    ,ova_flow_num -- 全局流水号
    ,unify_pay_chn_flow_num -- 统一支付渠道流水号
    ,happ_od_flg -- 发生透支标志
    ,od_amt -- 透支金额
    ,lmt_order_no -- 限额订单号
    ,e_acct_prod_acct_num -- 电子账户产品账号
    ,e_acct_entry_memo -- 电子账户记账摘要
    ,pay_check_midgrod_flow_num -- 支付对账中台流水号
    ,pay_check_midgrod_tran_dt -- 支付对账中台交易日期
    ,tran_type_cd -- 交易类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104039'||P1.SYSCD||P1.MAINSEQ||P1.TRANSDT -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SYSCD -- 系统编号
    ,P1.MAINSEQ -- 中台流水号
    ,${iml_schema}.DATEFORMAT_MAX(P1.TRANSDT） -- 中台交易日期
    ,P1.TRANSTM -- 中台交易时间
    ,P1.PCKNO -- 报文类型编号
    ,P1.SNDBRN -- 发起行行号
    ,P1.SNDUPBRN -- 发起清算行行号
    ,P1.RCVBRN -- 接收行行号
    ,P1.RCVUPBRN -- 接收清算行行号
    ,${iml_schema}.DATEFORMAT_MAX(P1.CONSIGNDT） -- 委托日期
    ,P1.TRANSSEQ -- 报文标识编号
    ,P1.OPERSQ -- 明细标识编号
    ,P1.BUSINESSTRACE -- 行内业务序号
    ,P1.FRONTTRCD -- 中台交易码
    ,P1.CCYNBR -- 币种代码
    ,to_number(nvl(trim(p1.TRANSAMT),'0')) -- 交易金额
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.IOTYPE END -- 往来账代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.FLAG4 END -- 借贷方向代码
    ,P1.HOSTTRCD -- 核心交易码
    ,${iml_schema}.DATEFORMAT_MAX(P1.HOSTDATE） -- 核心交易日期
    ,P1.HOSTNBR -- 核心流水号
    ,${iml_schema}.DATEFORMAT_MIN(P1.ACCPTNCDTTM) -- 委托时间
    ,P1.PAYCITYCODE -- 付款人开户行所属城市代码
    ,P1.PAYUPBRN -- 付款清算行行号
    ,P1.PAYBRN -- 付款人开户行部门编号
    ,P1.PAYOPENBRN -- 付款人开户行行号
    ,P1.PAYOPENBANKNM -- 付款人开户行名称
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.PAYACCTTP END -- 付款人账户类型代码
    ,P1.PAYACCT -- 付款人账号
    ,P1.PAYNAME -- 付款人名称
    ,P1.PAYADDR -- 付款人地址
    ,P1.INCOCITYCODE -- 收款人开户行所属城市代码
    ,P1.INCOOPENBANK -- 收款人开户行行号
    ,P1.INCOUPBRN -- 收款清算行行号
    ,P1.INCOOPENBANKNM -- 收款人开户行名称
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.INCOACCTTP END -- 收款人账户类型代码
    ,P1.INCOACCT -- 收款人账号
    ,P1.INCONAME -- 收款人名称
    ,P1.INCOADDR -- 收款人地址
    ,CASE WHEN R14.TARGET_CD_VAL IS NOT NULL THEN R14.TARGET_CD_VAL ELSE '@'||P1.BUSTYPE END -- 业务类型代码
    ,CASE WHEN R15.TARGET_CD_VAL IS NOT NULL THEN R15.TARGET_CD_VAL ELSE '@'||P1.SERVTYPE END -- 业务种类代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.ORACONSIGNDT） -- 原委托日期
    ,P1.ORATRANSSEQ -- 原报文标识编号
    ,P1.ORASNDBRN -- 原发起行行号
    ,P1.ORAPCKNO -- 原报文类型编号
    ,CASE WHEN R16.TARGET_CD_VAL IS NOT NULL THEN R16.TARGET_CD_VAL ELSE '@'||P1.PAYMOD END -- 支付方式代码
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.BOOKCODE END -- 凭证类型代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.BOOKDATE） -- 凭证日期
    ,P1.BOOKSEQNO -- 凭证号码
    ,P1.LEVELS -- 优先级别
    ,P1.OPRBRN -- 交易机构编号
    ,P1.OPRTLR -- 交易柜员编号
    ,P1.ORGNLREASON -- 退汇原因描述
    ,nvl(trim(P1.OPNWIN),'-') -- 交易渠道代码
    ,to_number(nvl(trim(p1.MAXTRANSAMT),'0')) -- 转账限额
    ,P1.ERRCODE -- 错误返回码
    ,P1.ERRMS -- 错误信息描述
    ,${iml_schema}.DATEFORMAT_MAX(substr(P1.RCVDT,1,8)||P1.RCVTM) -- 接收时间
    ,P1.MSGID -- 回执报文标识编号
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.PROCESSCODE END -- 城银清算业务状态代码
    ,P1.NETGRND -- 轧差场次
    ,${iml_schema}.DATEFORMAT_MAX(P1.NETGDT） -- 轧差日期
    ,P1.PROCCD -- 城银清算业务处理码
    ,${iml_schema}.DATEFORMAT_MAX(P1.CLEARDT） -- 清算日期
    ,CASE WHEN R8.TARGET_CD_VAL IS NOT NULL THEN R8.TARGET_CD_VAL ELSE '@'||P1.CHKPRODSTATUS END -- 业务对账状态代码
    ,CASE WHEN R9.TARGET_CD_VAL IS NOT NULL THEN R9.TARGET_CD_VAL ELSE '@'||P1.CHKHOSTSTATUS END -- 核心对账状态代码
    ,case when P1.STATUS = ' ' then '-' else trim(P1.IOTYPE)||'_'||trim(P1.STATUS) end -- 交易状态代码
    ,P1.FILL -- 交易结果描述
    ,${iml_schema}.DATEFORMAT_MAX(P1.CHANGTIME) -- 更新时间
    ,P1.MAGEBRN -- 管理机构编号
    ,CASE WHEN R11.TARGET_CD_VAL IS NOT NULL THEN R11.TARGET_CD_VAL ELSE '@'||P1.HANGUPREASON END -- 挂账原因代码
    ,P1.HANGUPMESG -- 挂账原因说明
    ,${iml_schema}.DATEFORMAT_MAX(P1.SACDT） -- 挂账日期
    ,P1.SACTLR -- 挂账柜员编号
    ,P1.SACBRN -- 挂账机构编号
    ,P1.SACACCT -- 挂账账号
    ,P1.SACNAME -- 挂账账户名称
    ,${iml_schema}.DATEFORMAT_MAX(P1.CRDT） -- 维护入账日期
    ,P1.CRTLR -- 维护入账柜员编号
    ,P1.CRBRN -- 维护入账机构编号
    ,P1.CRACCT -- 维护入账账号
    ,P1.CRNAME -- 维护入账账户名称
    ,P1.ENDTLR -- 冲正柜员编号
    ,P1.EDHOSTNBR -- 冲正交易流水号
    ,${iml_schema}.DATEFORMAT_MAX(P1.EDHOSTDT) -- 冲正日期
    ,P1.ISINOUT -- 内部账标志
    ,P1.INACCT -- 实际扣账账号
    ,P1.INNAME -- 实际扣账账户名称
    ,P1.EACCFLG -- 电子账户标志
    ,CASE WHEN R12.TARGET_CD_VAL IS NOT NULL THEN R12.TARGET_CD_VAL ELSE '@'||P1.ACCT_TYP_ID END -- 账户类型代码
    ,P1.GLOBALSEQNO -- 全局流水号
    ,P1.SRCSYSSSN -- 统一支付渠道流水号
    ,P1.OD_FLAG -- 发生透支标志
    ,to_number(nvl(trim(p1.OD_OVTRANAM),'0')) -- 透支金额
    ,P1.LIMITORDERID -- 限额订单号
    ,P1.FINACCOUNTID -- 电子账户产品账号
    ,P1.MEMOCNTT -- 电子账户记账摘要
    ,P1.FINMAINSEQ -- 支付对账中台流水号
    ,${iml_schema}.DATEFORMAT_MAX(P1.FINTRANSDT) -- 支付对账中台交易日期
    ,CASE WHEN R13.TARGET_CD_VAL IS NOT NULL THEN R13.TARGET_CD_VAL ELSE '@'||P1.TRNTYPE END -- 交易类型代码
    ,P1.ETL_DT as etl_dt -- ETL处理日期
    ,'mpcs_a1rtcbpstrx' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a1rtcbpstrx p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.IOTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A1RTCBPSTRX'
        AND R1.SRC_FIELD_EN_NAME= 'IOTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_CBPS_TRAN_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'NOSTRO_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.FLAG4 = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A1RTCBPSTRX'
        AND R2.SRC_FIELD_EN_NAME= 'FLAG4'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_CBPS_TRAN_FLOW'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'DEBIT_CRDT_DIR_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.PAYACCTTP = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'MPCS'
        AND R3.SRC_TAB_EN_NAME= 'MPCS_A1RTCBPSTRX'
        AND R3.SRC_FIELD_EN_NAME= 'PAYACCTTP'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_CBPS_TRAN_FLOW'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'PAYER_ACCT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.INCOACCTTP = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'MPCS'
        AND R4.SRC_TAB_EN_NAME= 'MPCS_A1RTCBPSTRX'
        AND R4.SRC_FIELD_EN_NAME= 'INCOACCTTP'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_CBPS_TRAN_FLOW'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'RECVER_ACCT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r14 on P1.BUSTYPE = R14.SRC_CODE_VAL
        AND R14.SORC_SYS_CD= 'MPCS'
        AND R14.SRC_TAB_EN_NAME= 'MPCS_A1RTCBPSTRX'
        AND R14.SRC_FIELD_EN_NAME= 'BUSTYPE'
        AND R14.TARGET_TAB_EN_NAME= 'EVT_CBPS_TRAN_FLOW'
        AND R14.TARGET_TAB_FIELD_EN_NAME= 'BUS_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r15 on P1.SERVTYPE = R15.SRC_CODE_VAL
        AND R15.SORC_SYS_CD= 'MPCS'
        AND R15.SRC_TAB_EN_NAME= 'MPCS_A1RTCBPSTRX'
        AND R15.SRC_FIELD_EN_NAME= 'SERVTYPE'
        AND R15.TARGET_TAB_EN_NAME= 'EVT_CBPS_TRAN_FLOW'
        AND R15.TARGET_TAB_FIELD_EN_NAME= 'BUS_KIND_CD'
    left join ${iml_schema}.ref_pub_cd_map r16 on P1.PAYMOD = R16.SRC_CODE_VAL
        AND R16.SORC_SYS_CD= 'MPCS'
        AND R16.SRC_TAB_EN_NAME= 'MPCS_A1RTCBPSTRX'
        AND R16.SRC_FIELD_EN_NAME= 'PAYMOD'
        AND R16.TARGET_TAB_EN_NAME= 'EVT_CBPS_TRAN_FLOW'
        AND R16.TARGET_TAB_FIELD_EN_NAME= 'MODE_PAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.BOOKCODE = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'MPCS'
        AND R5.SRC_TAB_EN_NAME= 'MPCS_A1RTCBPSTRX'
        AND R5.SRC_FIELD_EN_NAME= 'BOOKCODE'
        AND R5.TARGET_TAB_EN_NAME= 'EVT_CBPS_TRAN_FLOW'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'VOUCH_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.PROCESSCODE = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'MPCS'
        AND R7.SRC_TAB_EN_NAME= 'MPCS_A1RTCBPSTRX'
        AND R7.SRC_FIELD_EN_NAME= 'PROCESSCODE'
        AND R7.TARGET_TAB_EN_NAME= 'EVT_CBPS_TRAN_FLOW'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'CBPS_BUS_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r8 on P1.CHKPRODSTATUS = R8.SRC_CODE_VAL
        AND R8.SORC_SYS_CD= 'MPCS'
        AND R8.SRC_TAB_EN_NAME= 'MPCS_A1RTCBPSTRX'
        AND R8.SRC_FIELD_EN_NAME= 'CHKPRODSTATUS'
        AND R8.TARGET_TAB_EN_NAME= 'EVT_CBPS_TRAN_FLOW'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'BUS_CHECK_ENTRY_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r9 on P1.CHKHOSTSTATUS = R9.SRC_CODE_VAL
        AND R9.SORC_SYS_CD= 'MPCS'
        AND R9.SRC_TAB_EN_NAME= 'MPCS_A1RTCBPSTRX'
        AND R9.SRC_FIELD_EN_NAME= 'CHKHOSTSTATUS'
        AND R9.TARGET_TAB_EN_NAME= 'EVT_CBPS_TRAN_FLOW'
        AND R9.TARGET_TAB_FIELD_EN_NAME= 'CORE_CHECK_ENTRY_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r11 on P1.HANGUPREASON = R11.SRC_CODE_VAL
        AND R11.SORC_SYS_CD= 'MPCS'
        AND R11.SRC_TAB_EN_NAME= 'MPCS_A1RTCBPSTRX'
        AND R11.SRC_FIELD_EN_NAME= 'HANGUPREASON'
        AND R11.TARGET_TAB_EN_NAME= 'EVT_CBPS_TRAN_FLOW'
        AND R11.TARGET_TAB_FIELD_EN_NAME= 'ON_ACCT_RS_CD'
    left join ${iml_schema}.ref_pub_cd_map r12 on P1.ACCT_TYP_ID = R12.SRC_CODE_VAL
        AND R12.SORC_SYS_CD= 'MPCS'
        AND R12.SRC_TAB_EN_NAME= 'MPCS_A1RTCBPSTRX'
        AND R12.SRC_FIELD_EN_NAME= 'ACCT_TYP_ID'
        AND R12.TARGET_TAB_EN_NAME= 'EVT_CBPS_TRAN_FLOW'
        AND R12.TARGET_TAB_FIELD_EN_NAME= 'ACCT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r13 on P1.TRNTYPE = R13.SRC_CODE_VAL
        AND R13.SORC_SYS_CD= 'MPCS'
        AND R13.SRC_TAB_EN_NAME= 'MPCS_A1RTCBPSTRX'
        AND R13.SRC_FIELD_EN_NAME= 'TRNTYPE'
        AND R13.TARGET_TAB_EN_NAME= 'EVT_CBPS_TRAN_FLOW'
        AND R13.TARGET_TAB_FIELD_EN_NAME= 'TRAN_TYPE_CD'
 where  1 = 1 
  and p1.etl_dt >= to_date('${batch_date}','yyyymmdd') - 14
  and p1.etl_dt <= to_date('${batch_date}','yyyymmdd')
  ;
commit;



-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_cbps_tran_flow to ${iml_schema};


-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_cbps_tran_flow', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);