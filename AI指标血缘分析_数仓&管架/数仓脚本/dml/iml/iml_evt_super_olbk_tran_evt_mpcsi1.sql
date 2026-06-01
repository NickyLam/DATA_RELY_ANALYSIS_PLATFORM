/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_super_olbk_tran_evt_mpcsi1
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

alter table ${iml_schema}.evt_super_olbk_tran_evt add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_super_olbk_tran_evt modify partition p_mpcsi1
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
    v_sql := 'select count(0) from user_tab_subpartitions where table_name = upper(''evt_super_olbk_tran_evt'') and subpartition_name = ''P_MPCSI1_'||bat_dt||''' ';
    dbms_output.put_line(v_sql);
    execute immediate v_sql into v_p_exists;
    dbms_output.put_line(v_p_exists);
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iml.evt_super_olbk_tran_evt truncate subpartition P_MPCSI1_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    dbms_output.put_line('BBB');  
    --no exists partitions  
    else 
        v_sql := 'alter table iml.evt_super_olbk_tran_evt modify partition p_mpcsi1 add subpartition P_MPCSI1_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
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
-- mpcs_a10tibpsdetaillog-
insert into ${iml_schema}.evt_super_olbk_tran_evt(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,evt_dt -- 事件日期
    ,front_flow_num -- 前置机流水号
    ,host_tran_code -- 主机交易码
    ,front_tran_code -- 前置交易码
    ,pbc_tran_code -- 人行交易编码
    ,bank_int_bus_seq_num -- 行内业务序号
    ,bus_seq_num -- 业务序号
    ,num_site -- 场次
    ,comm_fee -- 手续费
    ,postage -- 邮电费
    ,trdpty_org_comm_fee_amt -- 第三方机构手续费金额
    ,stl_amt -- 结算金额
    ,tran_amt -- 交易金额
    ,curr_cd -- 币种代码
    ,host_rest_cd -- 主机结果代码
    ,pbc_bus_status_cd -- 人行业务状态代码
    ,refuse_rs_cd -- 拒绝原因代码
    ,pbc_bus_type_cd -- 人行业务类型代码
    ,pbc_bus_kind_cd -- 人行业务种类代码
    ,host_check_entry_status_cd -- 与主机对账状态代码
    ,pbc_check_entry_status_cd -- 与人行对账状态代码
    ,host_flow_num -- 主机流水号
    ,sumos_id -- 传票编号
    ,tran_brac_id -- 交易网点编号
    ,operr_id -- 操作员编号
    ,brac_print_flg -- 网点打印标志
    ,temp_print_flg -- 临时打印标志
    ,print_cnt -- 打印次数
    ,subj_id -- 科目编号
    ,fac_val_recd_dt -- 票面记载日期
    ,present_wdraw_dt -- 提出提回日期
    ,entry_dt -- 记账日期
    ,send_bank_dt -- 送银行日期
    ,pbc_proc_dt -- 人行处理日期
    ,bank_int_sys_proc_tm -- 行内系统受理时间
    ,bus_init_tm -- 业务发起时间
    ,submit_prior_level -- 提交优先级
    ,present_wdraw_flg -- 提出提回标志
    ,realtm_onl_flg -- 实时联机标志
    ,charge_flg -- 收费标志
    ,debit_crdt_cd -- 借贷代码
    ,recv_bank_no -- 收款行行号
    ,recv_bank_name -- 收款行行名称
    ,recver_acct_num -- 收款人账号
    ,recver_name -- 收款人姓名
    ,recver_acct_type -- 收款人账户类型
    ,pay_bank_no -- 付款行行号
    ,pay_bank_name -- 付款行行名称
    ,payer_acct_num -- 付款人账号
    ,payer_name -- 付款人姓名
    ,payer_acct_type_cd -- 付款人账户类型代码
    ,send_msg_bank_no -- 发报行行号
    ,recv_msg_bank_no -- 收报行行号
    ,tran_status_cd -- 交易状态代码
    ,tran_status_rest_cd -- 交易状态结果代码
    ,chn_cd -- 渠道代码
    ,refuse_bus_org_bank_no -- 拒绝业务机构行号
    ,pay_clear_bk_no -- 付款清算行行号
    ,recvbl_clear_bk_no -- 收款清算行行号
    ,payer_open_bank_no -- 付款人开户行行号
    ,recver_open_bank_no -- 收款人开户行行号
    ,payer_bank_belong_city_cd -- 付款人开户行所属城市代码
    ,recver_bank_belong_city_cd -- 收款人开户行所属城市代码
    ,web_tran_odd_no -- 网上交易单号
    ,cert_way_cd -- 认证方式代码
    ,cert_info -- 认证信息
    ,pre_auth_id -- 预授权编号
    ,mercht_id -- 商户编号
    ,mercht_name -- 商户名称
    ,coll_comm_fee_org_id -- 收取手续费机构编号
    ,web_tran_tm -- 网上交易时间
    ,open_acct_brac_id -- 开户网点编号
    ,check_entry_dt -- 对账日期
    ,check_entry_proc_flg -- 对账处理标志
    ,tran_index_num -- 交易索引号
    ,e_acct_cd -- 电子账户代码
    ,e_acct_entry_req_flow_num -- 电子账户记账请求流水号
    ,next_day_arrive_flg -- 次日达标志
    ,supv_acct -- 监管账户
    ,supv_acct_num -- 监管账号
    ,supv_acct_num_acct_name -- 监管账号户名称
    ,supv_acct_num_open_org_id -- 监管账号开户机构编号
    ,acct_type_cd -- 账户类型代码
    ,sign_type_cd -- 签约类型代码
    ,refund_flg -- 退款标志
    ,init_msg_idf_id -- 原报文标识编号
    ,init_prtcpt_org_bank_no -- 发起参与机构行号
    ,acct_ety_code -- 会计分录编码
    ,acct_cate_cd -- 账户类别代码
    ,resv_bd_flg -- 预绑标志
    ,cust_id -- 客户编号
    ,st_msg_check_ser_num -- 短信验证序列号
    ,mobile_no -- 手机号码
    ,cert_no -- 证件号码
    ,super_olbk_entry_rela_seq_num -- 超级网银记账流水关联序号
    ,lmt_order_no -- 限额订单号
    ,bind_flg -- 绑定标志
    ,ova_flow_num -- 全局流水号
    ,esb_intfc_return_code -- ESB接口返回码
    ,esb_intfc_return_info -- ESB接口返回信息
    ,esb_intfc_tran_flow_num -- ESB接口交易流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102044'||P1.TRACE -- 事件编号
    ,'9999' -- 法人编号
    ,${iml_schema}.DATEFORMAT_MIN(substr(TRACE,1,8)) -- 事件日期
    ,P1.TRACE -- 前置机流水号
    ,P1.FUNCTION -- 主机交易码
    ,P1.FUNCTION1 -- 前置交易码
    ,P1.FUNCTION2 -- 人行交易编码
    ,P1.BUSINESSTRACE -- 行内业务序号
    ,P1.BUSINESSNO -- 业务序号
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.BATCH, '[0-9.]+')),0)) -- 场次
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.CHARGEFEE, '[0-9.]+')),0)) -- 手续费
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.POSTFEE, '[0-9.]+')),0)) -- 邮电费
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.THIRDCHARGEFEE, '[0-9.]+')),0)) -- 第三方机构手续费金额
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.SETTLEAMOUNT, '[0-9.]+')),0)) -- 结算金额
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.AMOUNT, '[0-9.]+')),0)) -- 交易金额
    ,NVL(TRIM(P1.KIND),'CNY') -- 币种代码
    ,NVL(TRIM(P1.HOSTRETCODE),'-') -- 主机结果代码
    ,NVL(TRIM(P1.PROCESSCODE),'-') -- 人行业务状态代码
    ,P1.RSCODE -- 拒绝原因代码
    ,NVL(TRIM(P1.FUNCTYPE),'-') -- 人行业务类型代码
    ,NVL(TRIM(P1.BUSINESSKIND),'-') -- 人行业务种类代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.BUSINESSTYPE END -- 与主机对账状态代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.SETTLESTAT END -- 与人行对账状态代码
    ,P1.HOSTTRACE -- 主机流水号
    ,P1.TICKET -- 传票编号
    ,P1.NODE -- 交易网点编号
    ,P1.OPERATER -- 操作员编号
    ,P1.PRINTSTAT -- 网点打印标志
    ,P1.PRINTSTAT1 -- 临时打印标志
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.PRINTTIME, '[0-9.]+')),0)) -- 打印次数
    ,P1.SUBJ -- 科目编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.BILLRECDATE) -- 票面记载日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.DATE0) -- 提出提回日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.DATE1) -- 记账日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.DATE2) -- 送银行日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.DEALDATE) -- 人行处理日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANTIME) -- 行内系统受理时间
    ,${iml_schema}.DATEFORMAT_MIN(P1.SENDTIME) -- 业务发起时间
    ,P1.LEVEL0 -- 提交优先级
    ,P1.FLAG1 -- 提出提回标志
    ,P1.FLAG2 -- 实时联机标志
    ,CASE WHEN P1.FLAG3='2' THEN '0' ELSE P1.FLAG3 END  -- 收费标志
    ,NVL(TRIM(P1.FLAG4),'-') -- 借贷代码
    ,P1.ACCEPTBANK -- 收款行行号
    ,P1.ACCEPTBANKNAME -- 收款行行名称
    ,P1.ACCEPTACCT -- 收款人账号
    ,P1.ACCEPTNAME -- 收款人姓名
    ,P1.ACCEPTACCTTYPE -- 收款人账户类型
    ,P1.SENDBANK -- 付款行行号
    ,P1.SENDBANKNAME -- 付款行行名称
    ,P1.SENDACCT -- 付款人账号
    ,P1.SENDNAME -- 付款人姓名
    ,NVL(TRIM(P1.SENDACCTTYPE),'-') -- 付款人账户类型代码
    ,P1.MSGOUTBANK -- 发报行行号
    ,P1.MSGINBANK -- 收报行行号
    ,P1.STATUS -- 交易状态代码
    ,case when  trim( Flag1) is  null  or substr(FuncType,1,1) not in ( 'D','C','M')   or trim( status) is  null     then '-' 
 else Flag1||'_'||substr(FuncType,1,1)||'_'||STATUS end -- 交易状态结果代码
    ,NVL(TRIM(P1.COUNTER),'-') -- 渠道代码
    ,P1.REJECTBANK -- 拒绝业务机构行号
    ,P1.OUTSDFICODE -- 付款清算行行号
    ,P1.INSDFICODE -- 收款清算行行号
    ,P1.SENDOPENBANK -- 付款人开户行行号
    ,P1.ACCEPTOPENBANK -- 收款人开户行行号
    ,NVL(TRIM(P1.SENDCITYCODE),'000000') -- 付款人开户行所属城市代码
    ,NVL(TRIM(P1.ACCEPTCITYCODE),'000000') -- 收款人开户行所属城市代码
    ,P1.ENDTOENDID -- 网上交易单号
    ,NVL(TRIM(P1.AUTHTYPE),'-') -- 认证方式代码
    ,P1.AUTHINFO -- 认证信息
    ,P1.AUTHID -- 预授权编号
    ,P1.MERCHANTCODE -- 商户编号
    ,P1.MERCHANTNAME -- 商户名称
    ,P1.ONLINETRANTRACE -- 收取手续费机构编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.ONLINETRANTIME) -- 网上交易时间
    ,P1.OPENNODE -- 开户网点编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.COLDATE) -- 对账日期
    ,P1.DEALCOLFLAG -- 对账处理标志
    ,P1.DATAID -- 交易索引号
    ,NVL(TRIM(P1.EACCFLG),'-') -- 电子账户代码
    ,P1.TRANSNO -- 电子账户记账请求流水号
    ,P1.NEXTDAYFLAG -- 次日达标志
    ,P1.BINGFLAG -- 监管账户
    ,P1.BINGACCT -- 监管账号
    ,P1.BINGACCTNM -- 监管账号户名称
    ,P1.BINGACCTOPENINST -- 监管账号开户机构编号
    ,NVL(TRIM(P1.ACCTTYPE),'-') -- 账户类型代码
    ,NVL(TRIM(P1.OPERTYPE),'-') -- 签约类型代码
    ,P1.BACKFLAG -- 退款标志
    ,P1.ORGNLMSGID -- 原报文标识编号
    ,P1.ORGNLMMBID -- 发起参与机构行号
    ,P1.ABSCDE -- 会计分录编码
    ,NVL(TRIM(P1.TACCTP),'-') -- 账户类别代码
    ,P1.HANDLEFLAG -- 预绑标志
    ,P1.CUSTNO -- 客户编号
    ,P1.OTPSEQNO -- 短信验证序列号
    ,P1.MOBILE -- 手机号码
    ,P1.SENDIDCODE -- 证件号码
    ,P1.TRACESEQNO -- 超级网银记账流水关联序号
    ,P1.LIMITORDERID -- 限额订单号
    ,P1.ISBINDCARD -- 绑定标志
    ,P1.GLOBALSEQNO -- 全局流水号
    ,P1.RETURNCODE -- ESB接口返回码
    ,P1.RETURNMSG -- ESB接口返回信息
    ,P1.TRANSSEQNO -- ESB接口交易流水号
    ,P1.ETL_DT as etl_dt -- ETL处理日期
    ,'mpcs_a10tibpsdetaillog' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.mpcs_a10tibpsdetaillog p1
  left join ${iml_schema}.ref_pub_cd_map r1
    on p1.businesstype = r1.src_code_val
   and r1.sorc_sys_cd = 'MPCS'
   and r1.src_tab_en_name = 'MPCS_A10TIBPSDETAILLOG'
   and r1.src_field_en_name = 'BUSINESSTYPE'
   and r1.target_tab_en_name = 'EVT_SUPER_OLBK_TRAN_EVT'
   and r1.target_tab_field_en_name = 'HOST_CHECK_ENTRY_STATUS_CD'
  left join ${iml_schema}.ref_pub_cd_map r2
    on p1.settlestat = r2.src_code_val
   and r2.sorc_sys_cd = 'MPCS'
   and r2.src_tab_en_name = 'MPCS_A10TIBPSDETAILLOG'
   and r2.src_field_en_name = 'SETTLESTAT'
   and r2.target_tab_en_name = 'EVT_SUPER_OLBK_TRAN_EVT'
   and r2.target_tab_field_en_name = 'PBC_CHECK_ENTRY_STATUS_CD'
 where 1 = 1
   and p1.etl_dt >= to_date('${batch_date}', 'yyyymmdd') - 14
   and p1.etl_dt <= to_date('${batch_date}', 'yyyymmdd')
   ;
commit;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_super_olbk_tran_evt to ${iml_schema};


-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_super_olbk_tran_evt', partname => 'p_mpcsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);