/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_atmp_unionpay_tran_flow_mpcsi1
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
alter table ${iml_schema}.evt_atmp_unionpay_tran_flow add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_atmp_unionpay_tran_flow modify partition p_mpcsi1
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
    v_sql := 'select count(0) from user_tab_subpartitions where table_name = upper(''evt_atmp_unionpay_tran_flow'') and subpartition_name = ''P_MPCSI1_'||bat_dt||''' ';
    dbms_output.put_line(v_sql);
    execute immediate v_sql into v_p_exists;
    dbms_output.put_line(v_p_exists);
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iml.evt_atmp_unionpay_tran_flow truncate subpartition P_MPCSI1_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    dbms_output.put_line('BBB');  
    --no exists partitions  
    else 
        v_sql := 'alter table iml.evt_atmp_unionpay_tran_flow modify partition p_mpcsi1 add subpartition P_MPCSI1_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
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
-- mpcs_a50ubcardjourhis-
insert into ${iml_schema}.evt_atmp_unionpay_tran_flow(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,send_org_id -- 发送机构编号
    ,sys_follow_id -- 系统跟踪编号
    ,tran_tm -- 交易时间
    ,tran_cd -- 交易代码
    ,tran_type_cd -- 交易类型代码
    ,proc_org_id -- 受理机构编号
    ,tran_dt -- 交易日期
    ,teller_id -- 柜员编号
    ,tran_org_id -- 交易机构编号
    ,chn_cd -- 源系统代码
    ,msg_type_cd -- 报文类型代码
    ,main_acct_id -- 主账户编号
    ,proc_cd -- 处理代码
    ,intnal_proc_cd -- 内部处理代码
    ,tran_amt -- 交易金额
    ,onl_acct_bal -- 联机账户余额
    ,acct_td_aval_bal -- 账户当日可用余额
    ,atm_draw_td_aval_bal -- ATM取款当日可用余额
    ,tran_fee -- 交易费用
    ,proc_org_site_tm -- 受理机构所在地时间
    ,proc_org_site_dt -- 受理机构所在地日期
    ,clear_dt -- 清算日期
    ,mercht_type_cd -- 商户类型代码
    ,tran_serv_input_way_cd -- 交易服务点输入方式代码
    ,tran_serv_cond_cd -- 交易服务点条件代码
    ,retriv_ref_id -- 检索参考编号
    ,apprv_tran_auth_id -- 批准交易授权编号
    ,return_code -- 返回码
    ,proc_termn_id -- 受理终端编号
    ,proc_mercht_id -- 受理商户编号
    ,proc_mercht_name -- 受理商户名称
    ,addit_resp_descb -- 附加响应描述
    ,addit_priv -- 附加私有域
    ,curr_cd -- 币种代码
    ,resv_region -- 保留域
    ,recv_org_id -- 接收机构编号
    ,cups_resv_num -- CUPS保留号
    ,init_proc_org_id -- 原受理机构编号
    ,init_send_org_id -- 原发送机构编号
    ,init_sys_follow_id -- 原系统跟踪编号
    ,init_tran_tm -- 原交易时间
    ,unionpay_exch_rat -- 银联汇率
    ,expns_acct_id -- 支出账户编号
    ,depot_acct_id -- 存入账户编号
    ,atmc_tran_flow_num -- ATMC交易流水号
    ,msg_head_info -- 报文头信息
    ,tran_status_cd -- 交易状态代码
    ,err_cd -- 错误码
    ,err_info -- 错误信息
    ,termn_type_cd -- 终端类型代码
    ,init_way_cd -- 发起方式代码
    ,mercht_cty_rg_cd -- 商户国家地区代码
    ,deduct_amt -- 扣款金额
    ,deduct_exch_rat -- 扣款汇率
    ,clear_amt -- 清算金额
    ,send_org_actl_id -- 发送机构实际编号
    ,cross_bor_flg -- 跨境交易标志
    ,card_ser_num -- 卡序列号
    ,access_ic_data_region -- 接入IC卡数据域
    ,send_ic_data_region -- 发出IC卡数据域
    ,intnal_tran_cd -- 内部交易代码
    ,fcurr_tran_amt -- 外币交易金额
    ,bank_acct_type_cd -- 银行账户类型代码
    ,open_acct_org_id -- 开户机构编号
    ,comm_fee -- 手续费
    ,card_type_cd -- 卡类型代码
    ,card_tran_type_cd -- 卡交易类型代码
    ,qr_code_pay_scene_cd -- 二维码付款场景代码
    ,cross_bank_flg -- 跨行标志
    ,degr_flg -- 降级标志
    ,beps_unpasew_flg -- 小额免密标志
    ,subclass_return_code -- 细类返回码
    ,memo_cd -- 摘要代码
    ,ova_flow_num -- 全局流水号
    ,tran_flow_num -- 交易流水号
    ,init_tran_flow_num -- 原交易流水号
    ,upp_enter_status_cd -- UPP入账状态代码
    ,entry_flow_num -- 记账流水号
    ,entry_dt -- 记账日期
    ,delay_deduct_tran_flow_num -- 延时扣款交易流水号
    ,delay_deduct_tran_dt -- 延时扣款交易日期
    ,unionpay_delay_tran_return_cd -- 银联延时转账返回代码
    ,delay_tran_return_cd -- 延时转账返回代码
    ,termn_equip_id -- 终端设备编号
    ,termn_ip_addr -- 终端IP地址
    ,termn_sim_num -- 终端SIM号码
    ,termn_gps_position -- 终端GPS位置
    ,rsrv_mobile_no -- 预留手机号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,midgrod_tran_dt -- 中台交易日期
    ,acct_dt -- 账务日期
    ,init_tran_cd -- 原交易代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102059'||P1.acqinstid||P1.fwdinstid||P1.systrace||P1.transtime||P1.transcode||P1.trantype||p1.transdate -- 事件编号
    ,'9999' -- 法人编号
    ,P1.fwdinstid -- 发送机构编号
    ,P1.systrace -- 系统跟踪编号
    ,substr(P1.transdate, 1, 4) || P1.transtime-- 交易时间
    ,P1.transcode -- 交易代码
    ,P1.trantype -- 交易类型代码
    ,P1.acqinstid -- 受理机构编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.transdate) -- 交易日期
    ,P1.tlrnbr -- 柜员编号
    ,P1.brnnbr -- 交易机构编号
    ,P1.channels -- 源系统代码
    ,P1.msgtype -- 报文类型代码
    ,P1.priacct -- 主账户编号
    ,P1.procecode -- 处理代码
    ,P1.workcode -- 内部处理代码
    ,P1.transamt -- 交易金额
    ,P1.onlnbl -- 联机账户余额
    ,P1.avalbl -- 账户当日可用余额
    ,P1.cravbl -- ATM取款当日可用余额
    ,P1.trxfee -- 交易费用
    ,P1.localtime -- 受理机构所在地时间
    ,P1.localdate -- 受理机构所在地日期
    ,P1.settlmtdate -- 清算日期
    ,P1.mchnttype -- 商户类型代码
    ,P1.posentrymode -- 交易服务点输入方式代码
    ,nvl(trim(P1.servicecode),'-') -- 交易服务点条件代码
    ,P1.retrivarefnum -- 检索参考编号
    ,P1.authridresp -- 批准交易授权编号
    ,P1.respcode -- 返回码
    ,P1.acptermnlid -- 受理终端编号
    ,P1.accptrid -- 受理商户编号
    ,P1.accttrnameloc -- 受理商户名称
    ,P1.addtnlrespcd -- 附加响应描述
    ,P1.privatedate -- 附加私有域
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.currcycode END -- 币种代码
    ,P1.reserve -- 保留域
    ,P1.rcvinstid -- 接收机构编号
    ,P1.cupsreserve -- CUPS保留号
    ,P1.oldacqinstid -- 原受理机构编号
    ,P1.oldfwdinstid -- 原发送机构编号
    ,P1.oldsystrace -- 原系统跟踪编号
    ,${iml_schema}.dateformat_max(substr(p1.transdate,1,4)||p1.oldtranstime) -- 原交易时间
    ,nvl(trim(P1.outputdata),1) -- 银联汇率
    ,P1.outacctnbr -- 支出账户编号
    ,P1.inacctnbr -- 存入账户编号
    ,P1.atmctrace -- ATMC交易流水号
    ,' ' -- 报文头信息
    ,P1.status -- 交易状态代码
    ,P1.errcode -- 错误码
    ,P1.errmsg -- 错误信息
    ,nvl(trim(P1.tertype),'00') -- 终端类型代码
    ,nvl(trim(P1.promty),'0') -- 发起方式代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.acqinstctrycd END -- 商户国家地区代码
    ,P1.cardholdamt -- 扣款金额
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.cardholdrate, '[0-9.]+')),0)) -- 扣款汇率
    ,P1.settlmtamt -- 清算金额
    ,P1.newfwdinstid -- 发送机构实际编号
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.channeltp END -- 跨境交易标志
    ,P1.cardseq -- 卡序列号
    ,P1.inpbocelem -- 接入IC卡数据域
    ,P1.outpbocelem -- 发出IC卡数据域
    ,P1.trncd -- 内部交易代码
    ,P1.foriegnbl -- 外币交易金额
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.acctype END -- 银行账户类型代码
    ,P1.openbrch -- 开户机构编号
    ,P1.fee -- 手续费
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.card_type END -- 卡类型代码
    ,nvl(trim(P1.card_trn_typ),'-') -- 卡交易类型代码
    ,P1.scene -- 二维码付款场景代码
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.cross_flag END -- 跨行标志
    ,CASE WHEN R8.TARGET_CD_VAL IS NOT NULL THEN R8.TARGET_CD_VAL ELSE '@'||P1.fallback_fg END -- 降级标志
    ,CASE WHEN R9.TARGET_CD_VAL IS NOT NULL THEN R9.TARGET_CD_VAL ELSE '@'||P1.petty_flag END -- 小额免密标志
    ,P1.respcode_s -- 细类返回码
    ,P1.memo_cd -- 摘要代码
    ,P1.global_seq -- 全局流水号
    ,P1.trn_seq -- 交易流水号
    ,P1.old_trn_seq -- 原交易流水号
    ,P1.upp_status -- UPP入账状态代码
    ,P1.host_nbr -- 记账流水号
    ,${iml_schema}.DATEFORMAT_MIN(P1.host_date) -- 记账日期
    ,P1.dly_trn_id -- 延时扣款交易流水号
    ,${iml_schema}.DATEFORMAT_MIN(P1.dly_trn_dt) -- 延时扣款交易日期
    ,nvl(trim(P1.dly_yl_stu),'9') -- 银联延时转账返回代码
    ,nvl(trim(P1.dly_status),'9') -- 延时转账返回代码
    ,P1.cust_termid -- 终端设备编号
    ,P1.cust_ip -- 终端IP地址
    ,P1.client_sim -- 终端SIM号码
    ,P1.client_gps -- 终端GPS位置
    ,P1.mobile -- 预留手机号
    ,P1.cust_no -- 客户编号
    ,P1.cust_name -- 客户名称
    ,${iml_schema}.timeformat_min(substr(p1.trn_time,1,14)||'.'||substr(p1.trn_time,15,3))  -- 中台交易日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.back_acct_date) -- 账务日期
    ,P1.oldtranscode -- 原交易代码
    ,p1.etl_dt as etl_dt -- ETL处理日期
    ,'mpcs_a50ubcardjourhis' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a50ubcardjourhis p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.currcycode = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A50UBCARDJOUR'
        AND R2.SRC_FIELD_EN_NAME= 'currcycode'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_ATMP_UNIONPAY_TRAN_FLOW'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.acqinstctrycd = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'MPCS'
        AND R3.SRC_TAB_EN_NAME= 'MPCS_A50UBCARDJOUR'
        AND R3.SRC_FIELD_EN_NAME= 'acqinstctrycd'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_ATMP_UNIONPAY_TRAN_FLOW'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'MERCHT_CTY_RG_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.channeltp = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'MPCS'
        AND R4.SRC_TAB_EN_NAME= 'MPCS_A50UBCARDJOUR'
        AND R4.SRC_FIELD_EN_NAME= 'channeltp'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_ATMP_UNIONPAY_TRAN_FLOW'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'CROSS_BOR_FLG'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.acctype = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'MPCS'
        AND R5.SRC_TAB_EN_NAME= 'MPCS_A50UBCARDJOUR'
        AND R5.SRC_FIELD_EN_NAME= 'acctype'
        AND R5.TARGET_TAB_EN_NAME= 'EVT_ATMP_UNIONPAY_TRAN_FLOW'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'BANK_ACCT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.card_type = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'MPCS'
        AND R6.SRC_TAB_EN_NAME= 'MPCS_A50UBCARDJOUR'
        AND R6.SRC_FIELD_EN_NAME= 'card_type'
        AND R6.TARGET_TAB_EN_NAME= 'EVT_ATMP_UNIONPAY_TRAN_FLOW'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'CARD_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.cross_flag = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'MPCS'
        AND R7.SRC_TAB_EN_NAME= 'MPCS_A50UBCARDJOUR'
        AND R7.SRC_FIELD_EN_NAME= 'cross_flag'
        AND R7.TARGET_TAB_EN_NAME= 'EVT_ATMP_UNIONPAY_TRAN_FLOW'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'CROSS_BANK_FLG'
    left join ${iml_schema}.ref_pub_cd_map r8 on P1.fallback_fg = R8.SRC_CODE_VAL
        AND R8.SORC_SYS_CD= 'MPCS'
        AND R8.SRC_TAB_EN_NAME= 'MPCS_A50UBCARDJOUR'
        AND R8.SRC_FIELD_EN_NAME= 'fallback_fg'
        AND R8.TARGET_TAB_EN_NAME= 'EVT_ATMP_UNIONPAY_TRAN_FLOW'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'DEGR_FLG'
    left join ${iml_schema}.ref_pub_cd_map r9 on P1.petty_flag = R9.SRC_CODE_VAL
        AND R9.SORC_SYS_CD= 'MPCS'
        AND R9.SRC_TAB_EN_NAME= 'MPCS_A50UBCARDJOUR'
        AND R9.SRC_FIELD_EN_NAME= 'petty_flag'
        AND R9.TARGET_TAB_EN_NAME= 'EVT_ATMP_UNIONPAY_TRAN_FLOW'
        AND R9.TARGET_TAB_FIELD_EN_NAME= 'BEPS_UNPASEW_FLG'
where  1 = 1 
  and p1.etl_dt >= to_date('${batch_date}','yyyymmdd')-14
  and p1.etl_dt <= to_date('${batch_date}','yyyymmdd')
  ;
commit;


-- mpcs_a50ubcardjour-
insert into ${iml_schema}.evt_atmp_unionpay_tran_flow (
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,send_org_id -- 发送机构编号
    ,sys_follow_id -- 系统跟踪编号
    ,tran_tm -- 交易时间
    ,tran_cd -- 交易代码
    ,tran_type_cd -- 交易类型代码
    ,proc_org_id -- 受理机构编号
    ,tran_dt -- 交易日期
    ,teller_id -- 柜员编号
    ,tran_org_id -- 交易机构编号
    ,chn_cd -- 源系统代码
    ,msg_type_cd -- 报文类型代码
    ,main_acct_id -- 主账户编号
    ,proc_cd -- 处理代码
    ,intnal_proc_cd -- 内部处理代码
    ,tran_amt -- 交易金额
    ,onl_acct_bal -- 联机账户余额
    ,acct_td_aval_bal -- 账户当日可用余额
    ,atm_draw_td_aval_bal -- ATM取款当日可用余额
    ,tran_fee -- 交易费用
    ,proc_org_site_tm -- 受理机构所在地时间
    ,proc_org_site_dt -- 受理机构所在地日期
    ,clear_dt -- 清算日期
    ,mercht_type_cd -- 商户类型代码
    ,tran_serv_input_way_cd -- 交易服务点输入方式代码
    ,tran_serv_cond_cd -- 交易服务点条件代码
    ,retriv_ref_id -- 检索参考编号
    ,apprv_tran_auth_id -- 批准交易授权编号
    ,return_code -- 返回码
    ,proc_termn_id -- 受理终端编号
    ,proc_mercht_id -- 受理商户编号
    ,proc_mercht_name -- 受理商户名称
    ,addit_resp_descb -- 附加响应描述
    ,addit_priv -- 附加私有域
    ,curr_cd -- 币种代码
    ,resv_region -- 保留域
    ,recv_org_id -- 接收机构编号
    ,cups_resv_num -- CUPS保留号
    ,init_proc_org_id -- 原受理机构编号
    ,init_send_org_id -- 原发送机构编号
    ,init_sys_follow_id -- 原系统跟踪编号
    ,init_tran_tm -- 原交易时间
    ,unionpay_exch_rat -- 银联汇率
    ,expns_acct_id -- 支出账户编号
    ,depot_acct_id -- 存入账户编号
    ,atmc_tran_flow_num -- ATMC交易流水号
    ,msg_head_info -- 报文头信息
    ,tran_status_cd -- 交易状态代码
    ,err_cd -- 错误码
    ,err_info -- 错误信息
    ,termn_type_cd -- 终端类型代码
    ,init_way_cd -- 发起方式代码
    ,mercht_cty_rg_cd -- 商户国家地区代码
    ,deduct_amt -- 扣款金额
    ,deduct_exch_rat -- 扣款汇率
    ,clear_amt -- 清算金额
    ,send_org_actl_id -- 发送机构实际编号
    ,cross_bor_flg -- 跨境交易标志
    ,card_ser_num -- 卡序列号
    ,access_ic_data_region -- 接入IC卡数据域
    ,send_ic_data_region -- 发出IC卡数据域
    ,intnal_tran_cd -- 内部交易代码
    ,fcurr_tran_amt -- 外币交易金额
    ,bank_acct_type_cd -- 银行账户类型代码
    ,open_acct_org_id -- 开户机构编号
    ,comm_fee -- 手续费
    ,card_type_cd -- 卡类型代码
    ,card_tran_type_cd -- 卡交易类型代码
    ,qr_code_pay_scene_cd -- 二维码付款场景代码
    ,cross_bank_flg -- 跨行标志
    ,degr_flg -- 降级标志
    ,beps_unpasew_flg -- 小额免密标志
    ,subclass_return_code -- 细类返回码
    ,memo_cd -- 摘要代码
    ,ova_flow_num -- 全局流水号
    ,tran_flow_num -- 交易流水号
    ,init_tran_flow_num -- 原交易流水号
    ,upp_enter_status_cd -- UPP入账状态代码
    ,entry_flow_num -- 记账流水号
    ,entry_dt -- 记账日期
    ,delay_deduct_tran_flow_num -- 延时扣款交易流水号
    ,delay_deduct_tran_dt -- 延时扣款交易日期
    ,unionpay_delay_tran_return_cd -- 银联延时转账返回代码
    ,delay_tran_return_cd -- 延时转账返回代码
    ,termn_equip_id -- 终端设备编号
    ,termn_ip_addr -- 终端IP地址
    ,termn_sim_num -- 终端SIM号码
    ,termn_gps_position -- 终端GPS位置
    ,rsrv_mobile_no -- 预留手机号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,midgrod_tran_dt -- 中台交易日期
    ,acct_dt -- 账务日期
    ,init_tran_cd -- 原交易代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102059'||P1.acqinstid||P1.fwdinstid||P1.systrace||P1.transtime||P1.transcode||P1.trantype||p1.transdate -- 事件编号
    ,'9999' -- 法人编号
    ,P1.fwdinstid -- 发送机构编号
    ,P1.systrace -- 系统跟踪编号
    ,substr(P1.transdate, 1, 4) || P1.transtime -- 交易时间
    ,P1.transcode -- 交易代码
    ,P1.trantype -- 交易类型代码
    ,P1.acqinstid -- 受理机构编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.transdate) -- 交易日期
    ,P1.tlrnbr -- 柜员编号
    ,P1.brnnbr -- 交易机构编号
    ,P1.channels -- 源系统代码
    ,P1.msgtype -- 报文类型代码
    ,P1.priacct -- 主账户编号
    ,P1.procecode -- 处理代码
    ,P1.workcode -- 内部处理代码
    ,P1.transamt -- 交易金额
    ,P1.onlnbl -- 联机账户余额
    ,P1.avalbl -- 账户当日可用余额
    ,P1.cravbl -- ATM取款当日可用余额
    ,P1.trxfee -- 交易费用
    ,P1.localtime -- 受理机构所在地时间
    ,P1.localdate -- 受理机构所在地日期
    ,P1.settlmtdate -- 清算日期
    ,P1.mchnttype -- 商户类型代码
    ,P1.posentrymode -- 交易服务点输入方式代码
    ,nvl(trim(P1.servicecode),'-') -- 交易服务点条件代码
    ,P1.retrivarefnum -- 检索参考编号
    ,P1.authridresp -- 批准交易授权编号
    ,P1.respcode -- 返回码
    ,P1.acptermnlid -- 受理终端编号
    ,P1.accptrid -- 受理商户编号
    ,P1.accttrnameloc -- 受理商户名称
    ,P1.addtnlrespcd -- 附加响应描述
    ,P1.privatedate -- 附加私有域
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.currcycode END -- 币种代码
    ,P1.reserve -- 保留域
    ,P1.rcvinstid -- 接收机构编号
    ,P1.cupsreserve -- CUPS保留号
    ,P1.oldacqinstid -- 原受理机构编号
    ,P1.oldfwdinstid -- 原发送机构编号
    ,P1.oldsystrace -- 原系统跟踪编号
    ,${iml_schema}.dateformat_max(substr(p1.transdate,1,4)||p1.oldtranstime) -- 原交易时间
    ,nvl(trim(P1.outputdata),1) -- 银联汇率
    ,P1.outacctnbr -- 支出账户编号
    ,P1.inacctnbr -- 存入账户编号
    ,P1.atmctrace -- ATMC交易流水号
    ,' ' -- 报文头信息
    ,P1.status -- 交易状态代码
    ,P1.errcode -- 错误码
    ,P1.errmsg -- 错误信息
    ,nvl(trim(P1.tertype),'00') -- 终端类型代码
    ,nvl(trim(P1.promty),'0') -- 发起方式代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.acqinstctrycd END -- 商户国家地区代码
    ,P1.cardholdamt -- 扣款金额
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.cardholdrate, '[0-9.]+')),0)) -- 扣款汇率
    ,P1.settlmtamt -- 清算金额
    ,P1.newfwdinstid -- 发送机构实际编号
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.channeltp END -- 跨境交易标志
    ,P1.cardseq -- 卡序列号
    ,P1.inpbocelem -- 接入IC卡数据域
    ,P1.outpbocelem -- 发出IC卡数据域
    ,P1.trncd -- 内部交易代码
    ,P1.foriegnbl -- 外币交易金额
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.acctype END -- 银行账户类型代码
    ,P1.openbrch -- 开户机构编号
    ,P1.fee -- 手续费
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.card_type END -- 卡类型代码
    ,nvl(trim(P1.card_trn_typ),'-') -- 卡交易类型代码
    ,P1.scene -- 二维码付款场景代码
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.cross_flag END -- 跨行标志
    ,CASE WHEN R8.TARGET_CD_VAL IS NOT NULL THEN R8.TARGET_CD_VAL ELSE '@'||P1.fallback_fg END -- 降级标志
    ,CASE WHEN R9.TARGET_CD_VAL IS NOT NULL THEN R9.TARGET_CD_VAL ELSE '@'||P1.petty_flag END -- 小额免密标志
    ,P1.respcode_s -- 细类返回码
    ,P1.memo_cd -- 摘要代码
    ,P1.global_seq -- 全局流水号
    ,P1.trn_seq -- 交易流水号
    ,P1.old_trn_seq -- 原交易流水号
    ,P1.upp_status -- UPP入账状态代码
    ,P1.host_nbr -- 记账流水号
    ,${iml_schema}.DATEFORMAT_MIN(P1.host_date) -- 记账日期
    ,P1.dly_trn_id -- 延时扣款交易流水号
    ,${iml_schema}.DATEFORMAT_MIN(P1.dly_trn_dt) -- 延时扣款交易日期
    ,nvl(trim(P1.dly_yl_stu),'9') -- 银联延时转账返回代码
    ,nvl(trim(P1.dly_status),'9') -- 延时转账返回代码
    ,P1.cust_termid -- 终端设备编号
    ,P1.cust_ip -- 终端IP地址
    ,P1.client_sim -- 终端SIM号码
    ,P1.client_gps -- 终端GPS位置
    ,P1.mobile -- 预留手机号
    ,P1.cust_no -- 客户编号
    ,P1.cust_name -- 客户名称
    ,${iml_schema}.timeformat_min(substr(p1.trn_time,1,14)||'.'||substr(p1.trn_time,15,3))  -- 中台交易日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.back_acct_date) -- 账务日期
    ,P1.oldtranscode -- 原交易代码
    ,p1.etl_dt as etl_dt -- ETL处理日期
    ,'mpcs_a50ubcardjour' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a50ubcardjour p1
    left join ${iol_schema}.mpcs_a50ubcardjourhis p2 on p1.acqinstid=p2.acqinstid
        AND p1.fwdinstid=p2.fwdinstid
        AND p1.systrace=p2.systrace
        AND p1.transtime=p2.transtime
        AND p1.transcode=p2.transcode
        AND p1.trantype=p2.trantype
        AND p1.transdate =p2.transdate 
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.currcycode = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A50UBCARDJOUR'
        AND R2.SRC_FIELD_EN_NAME= 'currcycode'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_ATMP_UNIONPAY_TRAN_FLOW'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.acqinstctrycd = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'MPCS'
        AND R3.SRC_TAB_EN_NAME= 'MPCS_A50UBCARDJOUR'
        AND R3.SRC_FIELD_EN_NAME= 'acqinstctrycd'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_ATMP_UNIONPAY_TRAN_FLOW'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'MERCHT_CTY_RG_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.channeltp = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'MPCS'
        AND R4.SRC_TAB_EN_NAME= 'MPCS_A50UBCARDJOUR'
        AND R4.SRC_FIELD_EN_NAME= 'channeltp'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_ATMP_UNIONPAY_TRAN_FLOW'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'CROSS_BOR_FLG'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.acctype = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'MPCS'
        AND R5.SRC_TAB_EN_NAME= 'MPCS_A50UBCARDJOUR'
        AND R5.SRC_FIELD_EN_NAME= 'acctype'
        AND R5.TARGET_TAB_EN_NAME= 'EVT_ATMP_UNIONPAY_TRAN_FLOW'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'BANK_ACCT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.card_type = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'MPCS'
        AND R6.SRC_TAB_EN_NAME= 'MPCS_A50UBCARDJOUR'
        AND R6.SRC_FIELD_EN_NAME= 'card_type'
        AND R6.TARGET_TAB_EN_NAME= 'EVT_ATMP_UNIONPAY_TRAN_FLOW'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'CARD_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.cross_flag = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'MPCS'
        AND R7.SRC_TAB_EN_NAME= 'MPCS_A50UBCARDJOUR'
        AND R7.SRC_FIELD_EN_NAME= 'cross_flag'
        AND R7.TARGET_TAB_EN_NAME= 'EVT_ATMP_UNIONPAY_TRAN_FLOW'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'CROSS_BANK_FLG'
    left join ${iml_schema}.ref_pub_cd_map r8 on P1.fallback_fg = R8.SRC_CODE_VAL
        AND R8.SORC_SYS_CD= 'MPCS'
        AND R8.SRC_TAB_EN_NAME= 'MPCS_A50UBCARDJOUR'
        AND R8.SRC_FIELD_EN_NAME= 'fallback_fg'
        AND R8.TARGET_TAB_EN_NAME= 'EVT_ATMP_UNIONPAY_TRAN_FLOW'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'DEGR_FLG'
    left join ${iml_schema}.ref_pub_cd_map r9 on P1.petty_flag = R9.SRC_CODE_VAL
        AND R9.SORC_SYS_CD= 'MPCS'
        AND R9.SRC_TAB_EN_NAME= 'MPCS_A50UBCARDJOUR'
        AND R9.SRC_FIELD_EN_NAME= 'petty_flag'
        AND R9.TARGET_TAB_EN_NAME= 'EVT_ATMP_UNIONPAY_TRAN_FLOW'
        AND R9.TARGET_TAB_FIELD_EN_NAME= 'BEPS_UNPASEW_FLG'
where  1 = 1 
    and p1.etl_dt >= to_date('${batch_date}','yyyymmdd')-14
    and p1.etl_dt <= to_date('${batch_date}','yyyymmdd')
    and p2.acqinstid is null
;
commit;


-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_atmp_unionpay_tran_flow to ${iml_schema};


-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_atmp_unionpay_tran_flow', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);