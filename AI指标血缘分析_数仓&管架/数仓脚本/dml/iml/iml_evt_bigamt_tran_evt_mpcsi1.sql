/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_bigamt_tran_evt_mpcsi1
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

alter table ${iml_schema}.evt_bigamt_tran_evt add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_bigamt_tran_evt modify partition p_mpcsi1
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
    v_sql := 'select count(0) from user_tab_subpartitions where table_name = upper(''evt_bigamt_tran_evt'') and subpartition_name = ''P_MPCSI1_'||bat_dt||''' ';
    dbms_output.put_line(v_sql);
    execute immediate v_sql into v_p_exists;
    dbms_output.put_line(v_p_exists);
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iml.evt_bigamt_tran_evt truncate subpartition P_MPCSI1_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    dbms_output.put_line('BBB');  
    --no exists partitions  
    else 
        v_sql := 'alter table iml.evt_bigamt_tran_evt modify partition p_mpcsi1 add subpartition P_MPCSI1_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
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
-- mpcs_a08thvtrx-
insert into ${iml_schema}.evt_bigamt_tran_evt(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,pay_decl_form_id -- 支付报单编号
    ,tran_dt -- 交易日期
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,out_line_pay_tran_seq_num -- 行外支付交易序号
    ,bank_int_bus_seq_num -- 行内业务序号
    ,msg_type_id -- 报文类型编号
    ,host_tran_code -- 主机交易码
    ,midgrod_tran_code -- 中台交易码
    ,entr_dt -- 委托日期
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,spec_prmssn_prtcptr_id -- 特许参与者编号
    ,send_msg_center_cd -- 发报中心代码
    ,init_clear_bk_no -- 发起清算行行号
    ,origi_bank_no -- 发起行行号
    ,payer_open_bank_dept_id -- 付款人开户行部门编号
    ,payer_open_bank_no -- 付款人开户行行号
    ,payer_open_bank_name -- 付款人开户行名称
    ,payer_acct_num -- 付款人账号
    ,payer_name -- 付款人名称
    ,payer_addr -- 付款人地址
    ,recv_msg_center_cd -- 收报中心代码
    ,recv_clear_bk_no -- 接收清算行行号
    ,recv_bank_bank_no -- 接收行行号
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,recver_acct_num -- 收款人账号
    ,recver_name -- 收款人名称
    ,recver_addr -- 收款人地址
    ,bus_kind_cd -- 业务种类代码
    ,bus_type_cd -- 业务类型代码
    ,init_entr_dt -- 原委托日期
    ,init_pay_tran_seq_num -- 原支付交易序号
    ,init_prtcpt_org_id -- 原发起参与机构编号
    ,init_msg_type_id -- 原报文类型编号
    ,proc_status_cd -- 处理状态代码
    ,pbc_bus_status_cd -- 人行业务状态代码
    ,npc_proc_cd -- NPC处理代码
    ,sys_type_cd -- 系统类型代码
    ,node_type_cd -- 节点类型代码
    ,npc_rest_cd -- NPC处理结果代码
    ,check_revs_flow_num -- 复核冲正流水号
    ,send_revs_flow_num -- 发送冲正流水号
    ,clear_dt -- 清算日期
    ,err_return_code -- 错误返回编码
    ,err_info -- 错误信息
    ,prior_level -- 优先级别
    ,input_teller_id -- 录入柜员编号
    ,check_teller_id -- 复核柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,input_check_teller_dept_id -- 录入复核柜员部门编号
    ,auth_teller_dept_id -- 授权柜员部门编号
    ,check_entry_status_cd -- 对账状态代码
    ,print_cnt -- 打印次数
    ,revid_tm -- 收到时间
    ,send_tm -- 发送时间
    ,sugst_pay_dt -- 提示付款日期
    ,nostro_flg -- 往来账标志
    ,charge_flg -- 收费标志
    ,debit_crdt_cd -- 借贷代码
    ,reg_main_acct_num -- 挂账或维护入账账号
    ,reg_main_name -- 挂账或维护入账姓名
    ,matn_enter_acct_dt -- 维护入账日期
    ,matn_enter_acct_teller_id -- 维护入账柜员编号
    ,matn_enter_acct_dept_id -- 维护入账部门编号
    ,clarify_enter_acct_num -- 清分入账账号
    ,clarify_flow_num -- 清分流水号
    ,agent_flg -- 代理标志
    ,jnl_flow_num -- 日志流水号
    ,send_jnl_flow_num -- 发送日志流水号
    ,vouch_type_cd -- 凭证类型代码
    ,vouch_dt -- 凭证日期
    ,vouch_no -- 凭证号码
    ,cert_kind_cd -- 证件种类代码
    ,cert_no -- 证件号码
    ,tran_lmt -- 转账限额
    ,tran_flow_num -- 交易流水号
    ,send_tran_flow_num -- 发送交易流水号
    ,modif_tm -- 修改时间
    ,cc_bank_draft_id -- 城商行汇票编号
    ,rec_update_edit_num -- 记录更新版本号
    ,rec_status_cd -- 记录状态代码
    ,mode_pay_cd -- 支付方式代码
    ,exch_bus_tran_chn_cd -- 汇兑业务交易渠道代码
    ,modif_dt -- 修改日期
    ,bus_flow_num -- 业务流水号
    ,mgmt_org_id -- 管理机构编号
    ,comm_fee_amt -- 手续费用金额
    ,remit_tran_fee_amt -- 汇划费用金额
    ,todos -- 工本费
    ,mpr_teller_id -- 维护入账冲账柜员编号
    ,revs_tran_flow_num -- 冲正交易流水号
    ,revs_tran_dt -- 冲正交易日期
    ,prod_cd -- 产品代码
    ,intnal_acct_flg -- 内部账标志
    ,actl_deduct_acct_num -- 实际扣账账号
    ,actl_deduct_acct_name -- 实际扣账户名称
    ,bank_int_sys_edit_num -- 行内系统版本号
    ,cntpty_sys_edit_num -- 对手系统版本号
    ,ground_proc_status_cd -- 落地处理状态代码
    ,verify_proc_status_cd -- 查证处理状态代码
    ,rgst_addit_data_name -- 登记附加数据表名称
    ,on_acct_rs_cd -- 挂账原因代码
    ,scd_gener_msg_type_id -- 二代报文类型编号
    ,scd_gener_bus_type_cd -- 二代业务类型代码
    ,scd_gener_bus_kind_cd -- 二代业务种类代码
    ,charge_way_cd -- 收费方式代码
    ,e_acct_cd -- 电子账户代码
    ,chn_flow_num -- 渠道流水号
    ,next_day_tran_flg -- 次日转账标志
    ,auto_refund_flg -- 自动退汇标志
    ,auto_refund_cnt -- 自动退汇次数
    ,vtual_acct_bind_acct -- 虚户绑定账户
    ,vtual_acct_bind_acct_name -- 虚户绑定账户名称
    ,acct_type_cd -- 账户类型代码
    ,vtual_open_acct_org_id -- 虚户绑定账户开户机构编号
    ,acct_gen_cd -- 账户大类型代码
    ,lmt_order_no -- 限额订单号
    ,ova_flow_num -- 全局流水号
    ,esb_intfc_return_code -- ESB接口返回码
    ,esb_intfc_return_info -- ESB接口返回信息
    ,esb_intfc_tran_flow_num -- ESB接口交易流水号
    ,send_pbc_tm -- 发送人行时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102042'||P1.TRANSDT||P1.MAINSEQ -- 事件编号
    ,'9999' -- 法人编号
    ,P1.MAINSEQ -- 支付报单编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANSDT) -- 交易日期
    ,nvl(trim(P1.CCYNBR),'CNY') -- 币种代码
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.TRANSAMT, '[0-9.]+')),0)) -- 交易金额
    ,P1.TRANSSEQ -- 行外支付交易序号
    ,P1.BUSINESSTRACE -- 行内业务序号
    ,P1.CMTNO -- 报文类型编号
    ,P1.HOSTTRCD -- 主机交易码
    ,P1.FRONTTRCD -- 中台交易码
    ,${iml_schema}.DATEFORMAT_MAX(P1.CONSIGNDT) -- 委托日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.HOSTDATE) -- 主机日期
    ,P1.HOSTNBR -- 主机流水号
    ,P1.SPBRN -- 特许参与者编号
    ,NVL(TRIM(P1.SNDCT),'-') -- 发报中心代码
    ,P1.SNDUPBRN -- 发起清算行行号
    ,P1.SNDBRN -- 发起行行号
    ,P1.PAYBRN -- 付款人开户行部门编号
    ,P1.PAYOPENBRN -- 付款人开户行行号
    ,P1.PAYOPENBANKNM -- 付款人开户行名称
    ,P1.PAYACCT -- 付款人账号
    ,P1.PAYNAME -- 付款人名称
    ,P1.PAYADDR -- 付款人地址
    ,P1.RCVCT -- 收报中心代码
    ,P1.RCVUPBRN -- 接收清算行行号
    ,P1.RCVBRN -- 接收行行号
    ,P1.INCOBRN -- 收款人开户行行号
    ,P1.RECVOPENBANKNM -- 收款人开户行名称
    ,P1.INCOACCT -- 收款人账号
    ,P1.INCONAME -- 收款人名称
    ,P1.INCOADDR -- 收款人地址
    ,NVL(TRIM(P1.SERVTYPE),'-') -- 业务种类代码
    ,NVL(TRIM(P1.BUSTYPE),'-') -- 业务类型代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.BILLDT) -- 原委托日期
    ,P1.BILLCODE -- 原支付交易序号
    ,P1.ORASNDBRN -- 原发起参与机构编号
    ,P1.ORACMTNO -- 原报文类型编号
    ,NVL(TRIM(P1.STATUS),'-') -- 处理状态代码
    ,NVL(TRIM(P1.PROCESSCODE),'-') -- 人行业务状态代码
    ,P1.VARSEAL -- NPC处理代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||substr(P1.VARSEAL,1,2) END -- 系统类型代码
    ,NVL(trim(substr(P1.VARSEAL,3,1) ),'-') -- 节点类型代码
    ,nvl(trim(substr(P1.VARSEAL,length(P1.VARSEAL)-4,5)),'-') -- NPC处理结果代码
    ,P1.CKRVNBR -- 复核冲正流水号
    ,P1.SNDRVNBR -- 发送冲正流水号
    ,${iml_schema}.DATEFORMAT_MAX(P1.CLEARDT) -- 清算日期
    ,P1.ERRCODE -- 错误返回编码
    ,P1.ERRMS -- 错误信息
    ,P1.LEVELS -- 优先级别
    ,P1.OPRTLR -- 录入柜员编号
    ,P1.CHKTLR -- 复核柜员编号
    ,P1.AUTTLR -- 授权柜员编号
    ,P1.OPRBRN -- 录入复核柜员部门编号
    ,P1.AUTBRN -- 授权柜员部门编号
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.CHKSTATUS END -- 对账状态代码
    ,P1.PRTCNT -- 打印次数
    ,${iml_schema}.DATEFORMAT_MIN(P1.RCVDT) -- 收到时间
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANSMITDT)-- 发送时间
    ,${iml_schema}.DATEFORMAT_MAX(P1.PAYDT) -- 提示付款日期
    ,P1.WLFLAG -- 往来账标志
    ,P1.FLAG3 -- 收费标志
    ,NVL(TRIM(P1.FLAG4),'-') -- 借贷代码
    ,P1.SACACCT -- 挂账或维护入账账号
    ,P1.SACNAME -- 挂账或维护入账姓名
    ,${iml_schema}.DATEFORMAT_MAX(P1.CRDT) -- 维护入账日期
    ,P1.CRTLR -- 维护入账柜员编号
    ,P1.CRBRN -- 维护入账部门编号
    ,P1.CRACCT -- 清分入账账号
    ,P1.CRSEQ -- 清分流水号
    ,P1.PRODNBR -- 代理标志
    ,P1.TRACENBR -- 日志流水号
    ,P1.SNDTRACENBR -- 发送日志流水号
    ,NVL(TRIM(P1.BOOKCODE),'000') -- 凭证类型代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.BOOKDATE) -- 凭证日期
    ,P1.BOOKSEQNO -- 凭证号码
    ,nvl(trim(P1.IDTYPE),'0000') -- 证件种类代码
    ,P1.IDNO -- 证件号码
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.MAXTRANSAMT, '[0-9.]+')),0)) -- 转账限额
    ,P1.TRANSNBR -- 交易流水号
    ,P1.SNDTRANSNBR -- 发送交易流水号
    ,${iml_schema}.DATEFORMAT_MIN(P1.CHANGTIME) -- 修改时间
    ,P1.RESERV40 -- 城商行汇票编号
    ,P1.RCDVER -- 记录更新版本号
    ,NVL(TRIM(P1.RCDSTATUS),'-') -- 记录状态代码
    ,NVL(TRIM(P1.PAYMOD),'-') -- 支付方式代码
    ,nvl(trim(P1.OPENWINTYPE),'-') -- 汇兑业务交易渠道代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.CHANGDATE) -- 修改日期
    ,P1.SERVNBR -- 业务流水号
    ,P1.MAGEBRN -- 管理机构编号
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.FEEAMT, '[0-9.]+')),0)) -- 手续费用金额
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.FEEAMT1, '[0-9.]+')),0)) -- 汇划费用金额
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.FEEAMT2, '[0-9.]+')),0)) -- 工本费
    ,P1.ENDTLR -- 维护入账冲账柜员编号
    ,P1.EDHOSTNBR -- 冲正交易流水号
    ,${iml_schema}.DATEFORMAT_MAX(P1.EDHOSTDT) -- 冲正交易日期
    ,NVL(TRIM(P1.PRODCD),'UNKN') -- 产品代码
    ,P1.ISINOUT -- 内部账标志
    ,P1.INACCT -- 实际扣账账号
    ,P1.INNAME -- 实际扣账户名称
    ,P1.OURCNAPSVER -- 行内系统版本号
    ,P1.OTHERCNAPSVER -- 对手系统版本号
    ,NVL(TRIM(P1.LANDDEALSTS),'-') -- 落地处理状态代码
    ,NVL(TRIM(P1.CHECKDEALSTS),'-') -- 查证处理状态代码
    ,P1.APPENDDATATABLE -- 登记附加数据表名称
    ,NVL(TRIM(P1.HANGUPREASON),'-') -- 挂账原因代码
    ,P1.CMTNO2 -- 二代报文类型编号
    ,NVL(TRIM(P1.BUSTYPE2),'-') -- 二代业务类型代码
    ,NVL(TRIM(P1.SERVTYPE2),'-') -- 二代业务种类代码
    ,P1.FEETYPE -- 收费方式代码
    ,NVL(TRIM(P1.EACCFLG),'-') -- 电子账户代码
    ,P1.SRCSYSSSN -- 渠道流水号
    ,P1.NEXTDAYFLAG -- 次日转账标志
    ,P1.AUTOFLAG -- 自动退汇标志
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.AUTOCOUNT, '[0-9.]+')),0)) -- 自动退汇次数
    ,P1.BINDACCT -- 虚户绑定账户
    ,P1.BINDACCTNM -- 虚户绑定账户名称
    ,NVL(TRIM(P1.ACCTTYPE),'-') -- 账户类型代码
    ,P1.BINDACCTOPNBRN -- 虚户绑定账户开户机构编号
    ,NVL(TRIM(P1.TACCTP),'-') -- 账户大类型代码
    ,P1.LIMITORDERID -- 限额订单号
    ,P1.GLOBALSEQNO -- 全局流水号
    ,P1.RETURNCODE -- ESB接口返回码
    ,P1.RETURNMSG -- ESB接口返回信息
    ,P1.TRANSSEQNO -- ESB接口交易流水号
    ,${iml_schema}.DATEFORMAT_MIN(P1.SENDOUTTM) -- 发送人行时间
    ,to_date(p1.transdt,'yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a08thvtrx' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a08thvtrx p1
    left join ${iml_schema}.ref_pub_cd_map r4 on substr(P1.VARSEAL,1,2) = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'MPCS'
        AND R4.SRC_TAB_EN_NAME= 'MPCS_A08THVTRX'
        AND R4.SRC_FIELD_EN_NAME= 'VARSEAL'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_BIGAMT_TRAN_EVT'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'SYS_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on substr(P1.VARSEAL,length(P1.VARSEAL)-4,5) = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'MPCS'
        AND R6.SRC_TAB_EN_NAME= 'MPCS_A08THVTRX'
        AND R6.SRC_FIELD_EN_NAME= 'VARSEAL'
        AND R6.TARGET_TAB_EN_NAME= 'EVT_BIGAMT_TRAN_EVT'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'NPC_REST_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.CHKSTATUS = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'MPCS'
        AND R7.SRC_TAB_EN_NAME= 'MPCS_A08THVTRX'
        AND R7.SRC_FIELD_EN_NAME= 'CHKSTATUS'
        AND R7.TARGET_TAB_EN_NAME= 'EVT_BIGAMT_TRAN_EVT'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'CHECK_ENTRY_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.OPENWINTYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A08THVTRX'
        AND R2.SRC_FIELD_EN_NAME= 'OPENWINTYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_BIGAMT_TRAN_EVT'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'EXCH_BUS_TRAN_CHN_CD'
where  1 = 1 
    and p1.transdt>=to_char(to_date('${batch_date}','yyyymmdd')-14,'yyyymmdd') and p1.transdt<='${batch_date}'
;
commit;



-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_bigamt_tran_evt to ${iml_schema};


-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_bigamt_tran_evt', partname => 'p_mpcsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);
