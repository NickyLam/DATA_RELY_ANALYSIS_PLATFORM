/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_beps_tran_evt_mpcsi1
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

alter table ${iml_schema}.evt_beps_tran_evt add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_beps_tran_evt modify partition p_mpcsi1
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
    v_sql := 'select count(0) from user_tab_subpartitions where table_name = upper(''evt_beps_tran_evt'') and subpartition_name = ''P_MPCSI1_'||bat_dt||''' ';
    dbms_output.put_line(v_sql);
    execute immediate v_sql into v_p_exists;
    dbms_output.put_line(v_p_exists);
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iml.evt_beps_tran_evt truncate subpartition P_MPCSI1_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    dbms_output.put_line('BBB');  
    --no exists partitions  
    else 
        v_sql := 'alter table iml.evt_beps_tran_evt modify partition p_mpcsi1 add subpartition P_MPCSI1_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
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
-- mpcs_a08tbetrx-
insert into ${iml_schema}.evt_beps_tran_evt(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,pay_decl_form_id -- 支付报单编号
    ,out_line_pay_tran_seq_num -- 行外支付交易序号
    ,bank_int_bus_seq_num -- 行内业务序号
    ,bus_type_cd -- 业务类型代码
    ,bus_kind_cd -- 业务种类代码
    ,pkg_seq_num -- 包序号
    ,pkg_entr_dt -- 包委托日期
    ,pkg_type -- 包类型
    ,host_tran_code -- 主机交易码
    ,midgrod_tran_code -- 中台交易码
    ,tran_dt -- 交易日期
    ,entr_dt -- 委托日期
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,payer_open_bank_dept_id -- 付款人开户行部门编号
    ,payer_open_bank_no -- 付款人开户行行号
    ,payer_acct_num -- 付款人账号
    ,payer_name -- 付款人名称
    ,payer_addr -- 付款人地址
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_acct_num -- 收款人账号
    ,recver_name -- 收款人名称
    ,recver_addr -- 收款人地址
    ,send_msg_center_cd -- 发报中心代码
    ,init_clear_bk_no -- 发起清算行行号
    ,origi_bank_no -- 发起行行号
    ,recv_msg_center_cd -- 收报中心代码
    ,recv_clear_bk_no -- 接收清算行行号
    ,recv_bank_no -- 接收行行号
    ,init_entr_dt -- 原委托日期
    ,init_pay_tran_seq_num -- 原支付交易序号
    ,init_bus_type_cd -- 原业务类型代码
    ,bill_num -- 票据号码
    ,offs_bal_node_type_cd -- 轧差节点类型代码
    ,offs_bal_num_site -- 轧差场次
    ,offs_bal_dt_or_fs_dt -- 轧差日期或终态日期
    ,refund_rs_cd -- 退汇原因代码
    ,proc_status_cd -- 处理状态代码
    ,status_rest_cd -- 状态处理结果代码
    ,pbc_bus_status_cd -- 人行业务状态代码
    ,rtn_rcpt_code -- 回执码
    ,proc_cd -- 处理代码
    ,sys_type_cd -- 系统类型代码
    ,node_type_cd -- 节点类型代码
    ,rest_cd -- 处理结果代码
    ,check_revs_flow_num -- 复核冲正流水号
    ,rtn_rcpt_tenor_cd -- 回执期限代码
    ,rtn_rcpt_dt -- 回执日期
    ,send_revs_flow_num -- 发送冲正流水号
    ,clear_dt -- 清算日期
    ,err_code -- 错误编码
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
    ,bank_int_out_line_flg -- 行内行外标志
    ,draft_appl_form_num -- 汇票申请书号码
    ,matn_enter_acct_num -- 维护入账账号
    ,reg_main_name -- 挂账或维护入账姓名
    ,matn_enter_acct_dt -- 维护入账日期
    ,matn_enter_acct_teller_id -- 维护入账柜员编号
    ,matn_enter_acct_dept_id -- 维护入账部门编号
    ,agent_flg -- 代理标志
    ,jnl_flow_num -- 日志流水号
    ,send_jnl_flow_num -- 发送日志流水号
    ,vouch_type_cd -- 凭证类型代码
    ,entr_vouch_dt -- 委托凭证日期
    ,entr_vouch_num -- 委托凭证号
    ,cert_kind_cd -- 证件种类代码
    ,cert_no -- 证件号码
    ,tran_lmt -- 转账限额
    ,tran_flow_num -- 交易流水号
    ,send_tran_flow_num -- 发送交易流水号
    ,mode_pay_cd -- 支付方式代码
    ,exch_bus_cors_tran_chn_cd -- 汇兑业务对应交易渠道代码
    ,recnt_modif_dt -- 最近修改日期
    ,bus_flow_num -- 业务流水号
    ,comm_fee -- 手续费
    ,remit_tran_fee -- 汇划费
    ,todos -- 工本费
    ,init_amt -- 原托金额
    ,pay_amt -- 支付金额
    ,multi_pay_amt -- 多付金额
    ,mpr_host_flow_num -- 维护入账冲账主机流水号
    ,mpr_host_dt -- 维护入账冲账主机日期
    ,mpr_teller_id -- 维护入账冲账柜员编号
    ,recnt_modif_tm -- 最近修改时间
    ,proc_org_id -- 处理机构编号
    ,rec_update_edit_num -- 记录更新版本号
    ,rec_status_cd -- 记录状态代码
    ,init_pkg_type -- 原包类型
    ,init_pkg_init_clear_bk_num -- 原包发起清算行号
    ,init_pkg_entr_dt -- 原包委托日期
    ,init_pkg_seq_num -- 原包序号
    ,prod_cd -- 产品代码
    ,intnal_acct_flg -- 内部账标志
    ,actl_deduct_acct_num -- 实际扣账账号
    ,actl_deduct_acct_name -- 实际扣账户名称
    ,bank_int_sys_edit_num -- 行内系统版本号
    ,cntpty_sys_edit_num -- 对手系统版本号
    ,ground_proc_status_cd -- 落地处理状态代码
    ,verify_proc_status_cd -- 查证处理状态代码
    ,rgst_addit_data_name -- 登记附加数据表名称
    ,rgst_addit_data_dtl_name -- 登记附加数据明细表名称
    ,on_acct_rs_cd -- 挂账原因代码
    ,pkg_bank_int_seq_num -- 包行内序号
    ,scd_gener_msg_type_id -- 二代报文类型编号
    ,scd_gener_bus_type_cd -- 二代业务类型代码
    ,scd_gener_bus_kind_cd -- 二代业务种类代码
    ,payer_open_bank_name -- 付款人开户行名称
    ,recver_open_bank_name -- 收款人开户行名称
    ,charge_way_cd -- 收费方式代码
    ,e_acct_cd -- 电子账户代码
    ,next_day_tran_flg -- 次日转账标志
    ,auto_refund_flg -- 自动退汇标志
    ,auto_refund_cnt -- 自动退汇次数
    ,vtual_acct_bind_acct -- 虚户绑定账户
    ,vtual_acct_bind_acct_name -- 虚户绑定账户名称
    ,acct_type_cd -- 账户类型代码
    ,vtual_open_acct_org_id -- 虚户绑定账户开户机构编号
    ,last_debit_rtn_rcpt_status_cd -- 上一借记回执状态代码
    ,last_tran_status_cd -- 上一交易状态代码
    ,acct_gen_cd -- 账户大类型代码
    ,lmt_order_no -- 限额订单号
    ,bind_flg -- 绑定标志
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
    '102041'||P1.TRANSDT||P1.MAINSQ -- 事件编号
    ,'9999' -- 法人编号
    ,P1.MAINSQ -- 支付报单编号
    ,P1.OPERSQ -- 行外支付交易序号
    ,P1.BUSINESSTRACE -- 行内业务序号
    ,NVL(TRIM(P1.BUSTYPE),'-') -- 业务类型代码
    ,NVL(TRIM(P1.SERVTYPE),'-') -- 业务种类代码
    ,P1.TRANSSEQ -- 包序号
    ,${iml_schema}.DATEFORMAT_MAX(P1.PKCODT) -- 包委托日期
    ,P1.PKTYPE -- 包类型
    ,P1.HOSTTRCD -- 主机交易码
    ,P1.FRONTTRCD -- 中台交易码
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANSDT) -- 交易日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.CONSIGNDT) -- 委托日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.HOSTDATE) -- 主机日期
    ,P1.HOSTNBR -- 主机流水号
    ,nvl(trim(P1.CRCYCD),'CNY') -- 币种代码
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.TRANSAMT, '[0-9.]+')),0)) -- 交易金额
    ,P1.PAYBRN -- 付款人开户行部门编号
    ,P1.PAYOPENBRN -- 付款人开户行行号
    ,P1.PAYACCT -- 付款人账号
    ,P1.PAYNAME -- 付款人名称
    ,P1.PAYADDR -- 付款人地址
    ,P1.INCOBRN -- 收款人开户行行号
    ,P1.INCOACCT -- 收款人账号
    ,P1.INCONAME -- 收款人名称
    ,P1.INCOADDR -- 收款人地址
    ,NVL(TRIM(P1.SNDCT),'-') -- 发报中心代码
    ,P1.SNDUPBRN -- 发起清算行行号
    ,P1.SNDBRN -- 发起行行号
    ,NVL(TRIM(P1.RCVCT),'-') -- 收报中心代码
    ,P1.RCVUPBRN -- 接收清算行行号
    ,P1.RCVBRN -- 接收行行号
    ,${iml_schema}.DATEFORMAT_MAX(P1.BILLDT) -- 原委托日期
    ,P1.BILLCD -- 原支付交易序号
    ,NVL(TRIM(P1.ORABUSTYPE),'-') -- 原业务类型代码
    ,P1.PTRASQ -- 票据号码
    ,P1.OBALTP -- 轧差节点类型代码
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.OBALOD, '[0-9.]+')),0)) -- 轧差场次
    ,${iml_schema}.DATEFORMAT_MAX(P1.OBALDT) -- 轧差日期或终态日期
    ,NVL(TRIM(P1.CACLRS),'-') -- 退汇原因代码
    ,P1.TRANST -- 处理状态代码
    ,case when length(nvl(trim(iotype||'C' ||TRANST),''))<3 then '-'
when substr(bustype,1,1) in ('A','C','E') then iotype||'C' ||TRANST
when substr(bustype,1,1) in ('B','D','F') then iotype||'D'||TRANST else '-' end -- 状态处理结果代码
    ,NVL(TRIM(P1.PROCESSCODE),'-') -- 人行业务状态代码
    ,P1.ADVEST -- 回执码
    ,P1.VRSEAL -- 处理代码
    ,CASE WHEN TRIM(P1.VRSEAL) IS NULL THEN '-'
     WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||substr(P1.VRSEAL,1,2) END -- 系统类型代码
    ,NVL(trim(substr(P1.VRSEAL,3,1)),'-')  -- 节点类型代码
    ,NVL(trim(substr(P1.VRSEAL,length(P1.VRSEAL)-4,5)),'-')  -- 处理结果代码
    ,P1.CKRVNO -- 复核冲正流水号
    ,P1.RNDDAY -- 回执期限代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.RETUDT) -- 回执日期
    ,P1.SDRVNO -- 发送冲正流水号
    ,${iml_schema}.DATEFORMAT_MAX(P1.CLERDT) -- 清算日期
    ,P1.BPERNO -- 错误编码
    ,P1.BPERMG -- 错误信息
    ,P1.LEVELS -- 优先级别
    ,P1.OPRTLR -- 录入柜员编号
    ,P1.CHKTLR -- 复核柜员编号
    ,P1.AUTTLR -- 授权柜员编号
    ,P1.OPRBRN -- 录入复核柜员部门编号
    ,P1.AUTBRN -- 授权柜员部门编号
    ,CASE WHEN R8.TARGET_CD_VAL IS NOT NULL THEN R8.TARGET_CD_VAL ELSE '@'||P1.CHKSTA END -- 对账状态代码
    ,P1.PRTCNT -- 打印次数
    ,${iml_schema}.DATEFORMAT_MIN(P1.RECVDT) -- 收到时间
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANSMITDT) -- 发送时间
    ,${iml_schema}.DATEFORMAT_MAX(P1.PAYDAT) -- 提示付款日期
    ,P1.IOTYPE -- 往来账标志
    ,P1.FLAG3 -- 收费标志
    ,NVL(TRIM(P1.FLAG4),'-') -- 借贷代码
    ,P1.INOUTFLAG -- 行内行外标志
    ,P1.BLRQNO -- 汇票申请书号码
    ,P1.SACACT -- 维护入账账号
    ,P1.SACANA -- 挂账或维护入账姓名
    ,${iml_schema}.DATEFORMAT_MAX(P1.CLENDT) -- 维护入账日期
    ,P1.CLENUS -- 维护入账柜员编号
    ,P1.CLRBRN -- 维护入账部门编号
    ,P1.PRDNBR -- 代理标志
    ,P1.TRANBR -- 日志流水号
    ,P1.SDTRNO -- 发送日志流水号
    ,NVL(TRIM(P1.BKCODE),'000') -- 凭证类型代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.COBKDT) -- 委托凭证日期
    ,P1.COBKCD -- 委托凭证号
    ,nvl(trim(P1.IDTYPE),'0000') END -- 证件种类代码
    ,P1.IDNO -- 证件号码
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.MXTRAM, '[0-9.]+')),0)) -- 转账限额
    ,P1.TRANSQ -- 交易流水号
    ,P1.SDTRSQ -- 发送交易流水号
    ,NVL(TRIM(P1.PAYMOD),'-') -- 支付方式代码
    ,nvl(trim(P1.OPNWIN),'-') -- 汇兑业务对应交易渠道代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.CHNGDT) -- 最近修改日期
    ,P1.BEPSSQ -- 业务流水号
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.FEAMT1, '[0-9.]+')),0)) -- 手续费
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.FEAMT2, '[0-9.]+')),0)) -- 汇划费
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.FEAMT3, '[0-9.]+')),0)) -- 工本费
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.PRIAMT, '[0-9.]+')),0)) -- 原托金额
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.PAYAMT, '[0-9.]+')),0)) -- 支付金额
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.SPIAMT, '[0-9.]+')),0)) -- 多付金额
    ,P1.EDHTNO -- 维护入账冲账主机流水号
    ,${iml_schema}.DATEFORMAT_MAX(P1.EDHTDT) -- 维护入账冲账主机日期
    ,P1.ENDTLR -- 维护入账冲账柜员编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.CHNGTI) -- 最近修改时间
    ,P1.MAGBRN -- 处理机构编号
    ,TO_CHAR(P1.RCDVER) -- 记录更新版本号
    ,NVL(TRIM(P1.RCDSTA),'-') -- 记录状态代码
    ,P1.PRPKTP -- 原包类型
    ,P1.PRCLBK -- 原包发起清算行号
    ,${iml_schema}.DATEFORMAT_MAX(P1.PRPKDT) -- 原包委托日期
    ,P1.PRPKSQ -- 原包序号
    ,NVL(TRIM(P1.PRODCD),'UNKN') -- 产品代码
    ,P1.ISINOUT -- 内部账标志
    ,P1.INACCT -- 实际扣账账号
    ,P1.INNAME -- 实际扣账户名称
    ,P1.OURCNAPSVER -- 行内系统版本号
    ,P1.OTHERCNAPSVER -- 对手系统版本号
    ,NVL(TRIM(P1.LANDDEALSTS),'-') -- 落地处理状态代码
    ,NVL(TRIM(P1.CHECKDEALSTS),'-') -- 查证处理状态代码
    ,P1.APPENDDATATABLE -- 登记附加数据表名称
    ,P1.APPENDDATADTLTAB -- 登记附加数据明细表名称
    ,NVL(TRIM(P1.HANGUPREASON),'-') -- 挂账原因代码
    ,P1.PKGBUSINESSTRACE -- 包行内序号
    ,P1.PKTYPE2 -- 二代报文类型编号
    ,NVL(TRIM(P1.BUSTYPE2),'-') -- 二代业务类型代码
    ,NVL(TRIM(P1.SERVTYPE2),'-') -- 二代业务种类代码
    ,P1.PAYOPENBANKNM -- 付款人开户行名称
    ,P1.RECVOPENBANKNM -- 收款人开户行名称
    ,P1.FEETYPE -- 收费方式代码
    ,NVL(TRIM(P1.EACCFLG),'-') -- 电子账户代码
    ,P1.NEXTDAYFLAG -- 次日转账标志
    ,P1.AUTOFLAG -- 自动退汇标志
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.AUTOCOUNT, '[0-9.]+')),0)) -- 自动退汇次数
    ,P1.BINDACCT -- 虚户绑定账户
    ,P1.BINDACCTNM -- 虚户绑定账户名称
    ,NVL(TRIM(P1.ACCTTYPE),'-') -- 账户类型代码
    ,P1.BINDACCTOPNBRN -- 虚户绑定账户开户机构编号
    ,P1.LSTTRANST -- 上一借记回执状态代码
    ,case when length(nvl(trim(iotype||'C' ||LSTTRANST),''))<3 then '-'
when substr(bustype,1,1) in ('A','C','E') then iotype||'C' ||LSTTRANST
when substr(bustype,1,1) in ('B','D','F') then iotype||'D'||LSTTRANST else '-' end -- 上一交易状态代码
    ,NVL(TRIM(P1.TACCTP),'-') -- 账户大类型代码
    ,P1.LIMITORDERID -- 限额订单号
    ,P1.ISBINDCARD -- 绑定标志
    ,P1.GLOBALSEQNO -- 全局流水号
    ,P1.RETURNCODE -- ESB接口返回码
    ,P1.RETURNMSG -- ESB接口返回信息
    ,P1.TRANSSEQNO -- ESB接口交易流水号
    ,${iml_schema}.DATEFORMAT_MIN(P1.SENDOUTTM) -- 发送人行时间
    ,P1.etl_dt as etl_dt -- ETL处理日期
    ,'mpcs_a08tbetrx' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a08tbetrx p1
    left join ${iml_schema}.ref_pub_cd_map r4 on NVL(trim(substr(P1.VRSEAL,1,2)),'-') = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'MPCS'
        AND R4.SRC_TAB_EN_NAME= 'MPCS_A08TBETRX'
        AND R4.SRC_FIELD_EN_NAME= 'VRSEAL'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_BEPS_TRAN_EVT'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'SYS_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r8 on P1.CHKSTA = R8.SRC_CODE_VAL
        AND R8.SORC_SYS_CD= 'MPCS'
        AND R8.SRC_TAB_EN_NAME= 'MPCS_A08TBETRX'
        AND R8.SRC_FIELD_EN_NAME= 'CHKSTA'
        AND R8.TARGET_TAB_EN_NAME= 'EVT_BEPS_TRAN_EVT'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'CHECK_ENTRY_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.OPNWIN = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A08TBETRX'
        AND R2.SRC_FIELD_EN_NAME= 'OPNWIN'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_BEPS_TRAN_EVT'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'EXCH_BUS_CORS_TRAN_CHN_CD'
where  1 = 1 
    and p1.etl_dt>=to_date('${batch_date}','yyyymmdd')-14 and p1.etl_dt<=to_date('${batch_date}','yyyymmdd')
;
commit;




-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_beps_tran_evt to ${iml_schema};


-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_beps_tran_evt', partname => 'p_mpcsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);