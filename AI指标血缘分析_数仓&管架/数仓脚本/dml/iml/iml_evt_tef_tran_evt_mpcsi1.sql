/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_tef_tran_evt_mpcsi1
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

alter table ${iml_schema}.evt_tef_tran_evt add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_tef_tran_evt modify partition p_mpcsi1
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
    v_sql := 'select count(0) from user_tab_subpartitions where table_name = upper(''evt_tef_tran_evt'') and subpartition_name = ''P_MPCSI1_'||bat_dt||''' ';
    dbms_output.put_line(v_sql);
    execute immediate v_sql into v_p_exists;
    dbms_output.put_line(v_p_exists);
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iml.evt_tef_tran_evt truncate subpartition P_MPCSI1_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    dbms_output.put_line('BBB');  
    --no exists partitions  
    else 
        v_sql := 'alter table iml.evt_tef_tran_evt modify partition p_mpcsi1 add subpartition P_MPCSI1_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
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
-- mpcs_a49teftrx-
insert into ${iml_schema}.evt_tef_tran_evt(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,front_flow_num -- 前置流水号
    ,front_dt -- 前置日期
    ,front_tm -- 前置时间
    ,host_flow_num -- 主机流水号
    ,host_dt -- 主机日期
    ,mgmt_org_id -- 管理机构编号
    ,teller_id -- 柜员编号
    ,org_id -- 机构编号
    ,auth_teller_id -- 授权柜员编号
    ,auth_teller_dept_id -- 授权柜员部门编号
    ,pass_id -- 通道编号
    ,batch_dt -- 批次日期
    ,batch_flow_num -- 批次流水号
    ,pay_report_info_seq_num -- 支付报单号信息序号
    ,init_tran_pay_odd_no -- 原交易支付单号
    ,tran_subdv_type_cd -- 交易细分类型代码
    ,bus_kind_cd -- 业务种类代码
    ,entr_dt -- 委托日期
    ,vouch_submit_num -- 凭证提交号
    ,msg_id -- 报文编号
    ,pkg_seq_num -- 包序号
    ,pkg_dt -- 包日期
    ,ec_flg -- 钞汇标志
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,comm_fee_way -- 手续费方式
    ,comm_fee -- 手续费
    ,postage -- 邮电费
    ,todos -- 工本费
    ,vouch_type_cd -- 凭证类型代码
    ,entr_vouch_id -- 委托凭证编号
    ,intior_sys_num -- 发起方系统号
    ,intior_rg_cd -- 发起方地区代码
    ,origi_bank_no -- 发起行行号
    ,pay_bank_no -- 付款行行号
    ,payer_open_bank_no -- 付款人开户行行号
    ,payer_acct_num -- 付款人账号
    ,payer_name -- 付款人名称
    ,payer_addr -- 付款人地址
    ,recver_rg_cd -- 收款方地区代码
    ,recv_bank_no -- 收款行行号
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_acct_num -- 收款人账号
    ,recver_name -- 收款人名称
    ,recver_addr -- 收款人地址
    ,center_proc_num -- 中心受理号
    ,clear_dt -- 清算日期
    ,clear_num_site -- 清算场次
    ,init_origi_bank_no -- 原发起行行号
    ,init_tran_subdv_type_cd -- 原交易细分类型代码
    ,init_entr_dt -- 原委托日期
    ,init_vouch_submit_num -- 原凭证提交号
    ,init_host_flow_num -- 原主机流水号
    ,init_host_dt -- 原主机日期
    ,secd_magn_track_data -- 第二磁道数据
    ,trd_magn_track_data -- 第三磁道数据
    ,cash_tran_flg -- 现金转账标志
    ,corp_priv_flg -- 对公对私标志
    ,resp_bk_bus_proc_id -- 回应行业务处理编号
    ,resp_bk_tran_proc_tm -- 回应行交易受理时间
    ,cont_id -- 合同编号
    ,connet_id -- 连接编号
    ,nostro_flg -- 往来账标志
    ,status_cd -- 状态代码
    ,err_code -- 错误编码
    ,err_info -- 错误信息
    ,recv_bank_name -- 接收行行名称
    ,card_psbook_flg -- 卡折标志
    ,pay_bank_name -- 付款行行名称
    ,print_cnt -- 打印次数
    ,check_entry_dt -- 对账日期
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,intnal_acct_flg -- 内部账标志
    ,actl_acct_num -- 实际账号
    ,actl_deduct_acct_name -- 实际扣账户名称
    ,tran_dt -- 交易日期
    ,mode_pay_cd -- 支付方式代码
    ,minor_tot_amt -- 次总金额
    ,midgrod_tran_code -- 中台交易码
    ,recv_bank_num -- 接收行行号
    ,err_return_code -- 错误返回编码
    ,e_acct_cd -- 电子账户代码
    ,happ_od_flg -- 发生透支标志
    ,od_amt -- 透支金额
    ,chn_cd -- 渠道代码
    ,next_day_arrive_idf -- 次日达标识
    ,auto_refund_flg -- 自动退汇标志
    ,auto_refund_cnt -- 自动退汇次数
    ,auto_refund_info -- 自动退汇信息
    ,vtual_acct_bind_acct -- 虚户绑定账户
    ,vtual_acct_bind_acct_name -- 虚户绑定账户名称
    ,acct_type_cd -- 账户类型代码
    ,vtual_open_acct_org_id -- 虚户绑定账户开户机构编号
    ,lmt_order_no -- 限额订单号
    ,ova_flow_num -- 全局流水号
    ,bus_flow_num -- 业务流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102045'||P1.UNOTDATE||P1.UNOTNBR -- 事件编号
    ,'9999' -- 法人编号
    ,P1.UNOTNBR -- 前置流水号
    ,${iml_schema}.DATEFORMAT_MIN(P1.UNOTDATE) -- 前置日期
    ,P1.UNOTTIME -- 前置时间
    ,P1.HOSTNBR -- 主机流水号
    ,${iml_schema}.DATEFORMAT_MIN(P1.HOSTDATE) -- 主机日期
    ,P1.MAGBRN -- 管理机构编号
    ,P1.OPRTLR -- 柜员编号
    ,P1.OPRBRN -- 机构编号
    ,P1.AUTTLR -- 授权柜员编号
    ,P1.AUTBRN -- 授权柜员部门编号
    ,P1.OPRCHL -- 通道编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.BTHDATE) -- 批次日期
    ,P1.BTHSEQ -- 批次流水号
    ,P1.MSGID -- 支付报单号信息序号
    ,P1.ORIGMSGID -- 原交易支付单号
    ,P1.TXNTYPE -- 交易细分类型代码
    ,NVL(TRIM(P1.TRANTYPE),'-') -- 业务种类代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.ENTRUSTDATE) -- 委托日期
    ,P1.VOUCHNO -- 凭证提交号
    ,P1.MSGNO -- 报文编号
    ,P1.PKGNO -- 包序号
    ,${iml_schema}.DATEFORMAT_MIN(P1.PKGDATE) -- 包日期
    ,P1.MONEYFLAG -- 钞汇标志
    ,NVL(TRIM(P1.CURRENCYCD),'CNY') -- 币种代码
    ,P1.AMOUNT -- 交易金额
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.CHARGETYPE, '[0-9.]+')),0)) -- 手续费方式
    ,P1.FEEAMT1 -- 手续费
    ,P1.FEEAMT2 -- 邮电费
    ,P1.FEEAMT3 -- 工本费
    ,NVL(TRIM(P1.BOOKCD),'000') -- 凭证类型代码
    ,P1.BOOKNBR -- 委托凭证编号
    ,P1.SYSID -- 发起方系统号
    ,P1.SNDZONE -- 发起方地区代码
    ,P1.SENDBANK -- 发起行行号
    ,P1.PAYERBANK -- 付款行行号
    ,P1.PAYERACCBANK -- 付款人开户行行号
    ,P1.PAYERACC -- 付款人账号
    ,P1.PAYERNAME -- 付款人名称
    ,P1.PAYERADDR -- 付款人地址
    ,P1.RCVZONE -- 收款方地区代码
    ,P1.PAYEEBANK -- 收款行行号
    ,P1.PAYEEACCBANK -- 收款人开户行行号
    ,P1.PAYEEACC -- 收款人账号
    ,P1.PAYEENAME -- 收款人名称
    ,P1.PAYEEADDR -- 收款人地址
    ,P1.TXNID -- 中心受理号
    ,${iml_schema}.DATEFORMAT_MAX(P1.TXNDATE) -- 清算日期
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.TXNROUND, '[0-9.]+')),0)) -- 清算场次
    ,P1.ORIGSENDBANK -- 原发起行行号
    ,P1.ORIGTXNTYPE -- 原交易细分类型代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.ORIGENTRUSTDT) -- 原委托日期
    ,P1.ORIGVOUCHNO -- 原凭证提交号
    ,P1.ORIGHOSTNBR -- 原主机流水号
    ,${iml_schema}.DATEFORMAT_MIN(P1.ORIGHOSTDATE) -- 原主机日期
    ,P1.SECONDTRACK -- 第二磁道数据
    ,P1.THIRDTRACK -- 第三磁道数据
    ,P1.CASHFLAG -- 现金转账标志
    ,P1.PRIVATEFLAG -- 对公对私标志
    ,P1.OUTMID -- 回应行业务处理编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.OUTTIME) -- 回应行交易受理时间
    ,P1.CNTRNO -- 合同编号
    ,TO_CHAR(P1.LINKID) -- 连接编号
    ,P1.IOTYPE -- 往来账标志
    ,NVL(TRIM(P1.STATUS),'-') -- 状态代码
    ,P1.RETCD -- 错误编码
    ,P1.MSGTEXT -- 错误信息
    ,P1.RCVBRNNAME -- 接收行行名称
    ,P1.MEDIA -- 卡折标志
    ,P1.PAYERBANKNAME -- 付款行行名称
    ,P1.PRTNUM -- 打印次数
    ,${iml_schema}.DATEFORMAT_MAX(P1.COLLDATE) -- 对账日期
    ,nvl(trim(P1.IDENTYPE),'0000') -- 证件类型代码
    ,P1.IDENNBR -- 证件号码
    ,P1.ISINOUT -- 内部账标志
    ,P1.INACCT -- 实际账号
    ,P1.INNAME -- 实际扣账户名称
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANSDT) -- 交易日期
    ,NVL(TRIM(P1.PAYMOD),'-') -- 支付方式代码
    ,P1.CALFEE -- 次总金额
    ,P1.FRONTTRCD -- 中台交易码
    ,P1.RCVBRN -- 接收行行号
    ,P1.ERRCODE -- 错误返回编码
    ,NVL(TRIM(P1.EACCFLG),'-') -- 电子账户代码
    ,P1.OD_FLAG -- 发生透支标志
    ,P1.OD_OVTRANAM -- 透支金额
    ,nvl(trim(P1.OPNWIN),'-') -- 渠道代码
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.NEXTDAYFLAG, '[0-9.]+')),0)) -- 次日达标识
    ,P1.AUTOFLAG -- 自动退汇标志
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.AUTOCOUNT, '[0-9.]+')),0)) -- 自动退汇次数
    ,P1.AUTOMSG -- 自动退汇信息
    ,P1.BINDACCT -- 虚户绑定账户
    ,P1.BINDACCTNM -- 虚户绑定账户名称
    ,NVL(TRIM(P1.ACCTTYPE),'-') -- 账户类型代码
    ,P1.BINDACCTOPNBRN -- 虚户绑定账户开户机构编号
    ,P1.LIMITORDERID -- 限额订单号
    ,P1.GLOBALSEQNO -- 全局流水号
    ,P1.TRANSSEQNO -- 业务流水号
    ,p1.etl_dt as etl_dt -- ETL处理日期
    ,'mpcs_a49teftrx' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a49teftrx p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.OPNWIN = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A49TEFTRX'
        AND R1.SRC_FIELD_EN_NAME= 'OPNWIN'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_TEF_TRAN_EVT'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CHN_CD'
where  1 = 1 
    and p1.etl_dt>=to_date('${batch_date}','yyyymmdd')-14 and p1.etl_dt<=to_date('${batch_date}','yyyymmdd')
;

commit;


-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_tef_tran_evt to ${iml_schema};

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_tef_tran_evt', partname => 'p_mpcsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);