/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_tax_pay_tran_flow_mpcsi1
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
drop table ${iml_schema}.evt_tax_pay_tran_flow_mpcsi1_tm purge;
alter table ${iml_schema}.evt_tax_pay_tran_flow add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_tax_pay_tran_flow modify partition p_mpcsi1
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
    v_sql := 'select count(0) from user_tab_subpartitions where table_name = upper(''evt_tax_pay_tran_flow'') and subpartition_name = ''P_MPCSI1_'||bat_dt||''' ';
   -- dbms_output.put_line(v_sql);
    execute immediate v_sql into v_p_exists;
    --dbms_output.put_line(v_p_exists);
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iml.evt_tax_pay_tran_flow truncate subpartition P_MPCSI1_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --dbms_output.put_line('BBB');  
    --no exists partitions  
    else 
        v_sql := 'alter table iml.evt_tax_pay_tran_flow modify partition p_mpcsi1 add subpartition P_MPCSI1_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
      --  dbms_output.put_line(v_sql);
        execute immediate v_sql;
      --  dbms_output.put_line('AAA');
    end if;
      end loop;
end;
/

-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a49tefetstran-1
insert into ${iml_schema}.evt_tax_pay_tran_flow(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_dt -- 交易日期
    ,tran_flow_num -- 交易流水号
    ,tran_tm -- 交易时间
    ,tran_type_subdv_cd -- 交易类型细分代码
    ,nostro_cd -- 往来账代码
    ,tran_status_cd -- 交易状态代码
    ,mgmt_org_id -- 管理机构编号
    ,check_entry_dt -- 对账日期
    ,core_tran_dt -- 核心交易日期
    ,core_tran_flow_num -- 核心交易流水号
    ,revs_dt -- 冲正日期
    ,revs_flow_num -- 冲正流水号
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,init_rg_cd -- 发起地区代码
    ,recv_rg_cd -- 接收地区代码
    ,entr_dt -- 委托日期
    ,mode_pay_cd -- 支付方式代码
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,comm_fee -- 手续费
    ,postage -- 邮电费
    ,todos -- 工本费
    ,origi_bank_no -- 发起行行号
    ,pay_bank_no -- 付款行行号
    ,payer_open_bank_no -- 付款人开户行行号
    ,payer_acct_id -- 付款人账户编号
    ,payer_name -- 付款人名称
    ,payer_open_acct_org_id -- 付款人开户机构编号
    ,recv_bank_no -- 收款行行号
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_acct_id -- 收款人账户编号
    ,recver_name -- 收款人名称
    ,bus_chn_cd -- 业务渠道代码
    ,bank_no -- 经收处银行行号
    ,bank_submit_dt -- 银行提交日期
    ,tax_bur_flow_num -- 税局流水号
    ,org_cate_cd -- 机关类别代码
    ,impose_org_id -- 征收机关编号
    ,impose_org_submit_dt -- 征收机关提交日期
    ,impose_org_flow_num -- 征收机关流水号
    ,recvbl_trea_id -- 收款国库编号
    ,tran_type_cd -- 交易类型代码
    ,impose_org_revs_dt -- 征收机关冲正日期
    ,impose_org_revs_flow_num -- 征收机关冲正流水号
    ,taxpayer_id -- 纳税人编号
    ,taxpayer_name -- 纳税人名称
    ,decl_way_cd -- 申报方式代码
    ,decl_flow_num -- 申报流水号
    ,pay_way_cd -- 缴款方式代码
    ,clear_dt -- 清算日期
    ,bus_org_id -- 营业机构编号
    ,teller_id -- 柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,auth_brac_id -- 授权网点编号
    ,bus_type_cd -- 业务类型代码
    ,refund_acct_id -- 退款账户编号
    ,refund_acct_name -- 退款户账户名称
    ,pay_ps_tel_num -- 缴款人电话号码
    ,pay_ps_cert_type_cd -- 缴款人证件类型代码
    ,pay_ps_cert_no -- 缴款人证件号码
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_id -- 凭证编号
    ,tran_chn_cd -- 交易渠道代码
    ,chn_flow_num -- 渠道流水号
    ,bus_flow_num -- 业务流水号
    ,ova_flow_num -- 全局流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104045'||P1.TRANDT||P1.TRANSQ -- 事件编号
    ,'9999' -- 法人编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANDT) -- 交易日期
    ,P1.TRANSQ -- 交易流水号
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANDT||P1.TRANTM) -- 交易时间
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.TXNTYPE END -- 交易类型细分代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.IOTYPE END -- 往来账代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.TRANST END -- 交易状态代码
    ,P1.MAGBRN -- 管理机构编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.COLLDATE) -- 对账日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.HOSTDT) -- 核心交易日期
    ,P1.HOSTSQ -- 核心交易流水号
    ,${iml_schema}.DATEFORMAT_MAX(P1.COLLDT) -- 冲正日期
    ,P1.COLLSQ -- 冲正流水号
    ,P1.MSGCODE -- 返回码
    ,P1.MSGTEXT -- 返回信息
    ,nvl(TRIM(P1.SNDZONE),'000000') -- 发起地区代码
    ,nvl(trim(P1.RCVZONE),'000000') -- 接收地区代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.ENTRUSTDATE) -- 委托日期
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.TRANTP END -- 支付方式代码
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.CURRENCYCD END -- 币种代码
    ,P1.AMOUNT -- 交易金额
    ,P1.FEEAMT -- 手续费
    ,P1.POSTAM -- 邮电费
    ,P1.HANDAM -- 工本费
    ,P1.SENDBANK -- 发起行行号
    ,P1.PAYERBANK -- 付款行行号
    ,P1.PAYERACCBANK -- 付款人开户行行号
    ,P1.PAYERACC -- 付款人账户编号
    ,P1.PAYERNAME -- 付款人名称
    ,P1.ACCTBR -- 付款人开户机构编号
    ,P1.PAYEEBANK -- 收款行行号
    ,P1.PAYEEACCBANK -- 收款人开户行行号
    ,P1.PAYEEACC -- 收款人账户编号
    ,P1.PAYEENAME -- 收款人名称
    ,P1.OPRCHL -- 业务渠道代码
    ,P1.MAINBR -- 经收处银行行号
    ,${iml_schema}.DATEFORMAT_MAX(P1.BANKDT） -- 银行提交日期
    ,P1.TRANID -- 税局流水号
    ,P1.TXBRCH -- 机关类别代码
    ,P1.ORIGCD -- 征收机关编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.ORIGDT） -- 征收机关提交日期
    ,P1.ORIGSQ -- 征收机关流水号
    ,P1.FISCCD -- 收款国库编号
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.OPRTYPE END -- 交易类型代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.TORIGDT） -- 征收机关冲正日期
    ,P1.TORIGSQ -- 征收机关冲正流水号
    ,P1.TXPYCD -- 纳税人编号
    ,P1.TXPYNA -- 纳税人名称
    ,P1.DECLACD -- 申报方式代码
    ,P1.DECLASQ -- 申报流水号
    ,P1.PAYECD -- 缴款方式代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.TXNDATE） -- 清算日期
    ,P1.BRCHNO -- 营业机构编号
    ,P1.USERID -- 柜员编号
    ,P1.CKBKUS -- 授权柜员编号
    ,P1.CKBKBR -- 授权网点编号
    ,P1.BUSTYPE -- 业务类型代码
    ,P1.BUGACCTNO -- 退款账户编号
    ,P1.BUGACCTNA -- 退款户账户名称
    ,P1.PAYERTEL -- 缴款人电话号码
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.IDTFTP END -- 缴款人证件类型代码
    ,P1.IDTFNO -- 缴款人证件号码
    ,P1.BOOKCD -- 凭证类型代码
    ,P1.BOOKNO -- 凭证编号
    ,CASE WHEN R8.TARGET_CD_VAL IS NOT NULL THEN R8.TARGET_CD_VAL ELSE '@'||P1.TRNCHL END -- 交易渠道代码
    ,P1.CHNLSQ -- 渠道流水号
    ,P1.TRANSEQNO -- 业务流水号
    ,P1.GLOBALSEQNO -- 全局流水号
    ,to_date(p1.trandt,'yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a49tefetstran' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a49tefetstran p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.TXNTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A49TEFETSTRAN'
        AND R1.SRC_FIELD_EN_NAME= 'TXNTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_TAX_PAY_TRAN_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TRAN_TYPE_SUBDV_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.IOTYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A49TEFETSTRAN'
        AND R2.SRC_FIELD_EN_NAME= 'IOTYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_TAX_PAY_TRAN_FLOW'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'NOSTRO_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.TRANST = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'MPCS'
        AND R3.SRC_TAB_EN_NAME= 'MPCS_A49TEFETSTRAN'
        AND R3.SRC_FIELD_EN_NAME= 'TRANST'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_TAX_PAY_TRAN_FLOW'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'TRAN_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.TRANTP = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'MPCS'
        AND R4.SRC_TAB_EN_NAME= 'MPCS_A49TEFETSTRAN'
        AND R4.SRC_FIELD_EN_NAME= 'TRANTP'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_TAX_PAY_TRAN_FLOW'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'MODE_PAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.CURRENCYCD = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'MPCS'
        AND R5.SRC_TAB_EN_NAME= 'MPCS_A49TEFETSTRAN'
        AND R5.SRC_FIELD_EN_NAME= 'CURRENCYCD'
        AND R5.TARGET_TAB_EN_NAME= 'EVT_TAX_PAY_TRAN_FLOW'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.OPRTYPE = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'MPCS'
        AND R6.SRC_TAB_EN_NAME= 'MPCS_A49TEFETSTRAN'
        AND R6.SRC_FIELD_EN_NAME= 'OPRTYPE'
        AND R6.TARGET_TAB_EN_NAME= 'EVT_TAX_PAY_TRAN_FLOW'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'TRAN_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.IDTFTP = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'MPCS'
        AND R7.SRC_TAB_EN_NAME= 'MPCS_A49TEFETSTRAN'
        AND R7.SRC_FIELD_EN_NAME= 'IDTFTP'
        AND R7.TARGET_TAB_EN_NAME= 'EVT_TAX_PAY_TRAN_FLOW'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'PAY_PS_CERT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r8 on P1.TRNCHL = R8.SRC_CODE_VAL
        AND R8.SORC_SYS_CD= 'MPCS'
        AND R8.SRC_TAB_EN_NAME= 'MPCS_A49TEFETSTRAN'
        AND R8.SRC_FIELD_EN_NAME= 'TRNCHL'
        AND R8.TARGET_TAB_EN_NAME= 'EVT_TAX_PAY_TRAN_FLOW'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'TRAN_CHN_CD'
where  1 = 1 
    and P1.trandt>=to_char(to_date('${batch_date}','yyyymmdd')-14,'yyyymmdd') and P1.trandt<='${batch_date}'
;
commit;

whenever sqlerror exit sql.sqlcode;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_tax_pay_tran_flow', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);