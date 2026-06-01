/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_bid_margin_enter_acct_info_h_mpcsf1
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
alter table ${iml_schema}.agt_bid_margin_enter_acct_info_h add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mpcsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_bid_margin_enter_acct_info_h_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bid_margin_enter_acct_info_h partition for ('mpcsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_bid_margin_enter_acct_info_h_mpcsf1_tm purge;
drop table ${iml_schema}.agt_bid_margin_enter_acct_info_h_mpcsf1_op purge;
drop table ${iml_schema}.agt_bid_margin_enter_acct_info_h_mpcsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bid_margin_enter_acct_info_h_mpcsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,midgrod_tran_flow_num -- 中台交易流水号
    ,tran_cd -- 交易代码
    ,midgrod_dt -- 中台日期
    ,chn_sys_cd -- 渠道系统代码
    ,chn_tran_dt -- 渠道交易日期
    ,chn_tran_flow_num -- 渠道交易流水号
    ,chn_org_id -- 渠道机构编号
    ,curr_cd -- 币种代码
    ,debit_crdt_flg -- 借贷标志
    ,oper_type_cd -- 操作类型代码
    ,avl_tm -- 到帐时间
    ,avl_amt -- 到帐金额
    ,advise_status_cd -- 通知状态代码
    ,fin_status_cd -- 财务状态代码
    ,aldy_check_entry_flg -- 已对账标志
    ,refund_flg -- 退汇标志
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,payer_open_bank_num -- 付款人开户行号
    ,payer_open_bank_name -- 付款人开户行名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,stl_acct_id -- 结算账户编号
    ,stl_acct_name -- 结算账户名称
    ,stl_acct_bal -- 结算账户余额
    ,margin_acct_status_cd -- 保证金账户状态代码
    ,core_entry_tran_dt -- 核心记账交易日期
    ,core_entry_host_flow_num -- 核心记账主机流水号
    ,core_entry_tran_flow_num -- 核心记账交易流水号
    ,core_entry_status -- 核心记账状态代码
    ,memo_cd -- 摘要代码
    ,f_r_acct_up_host_return_code -- 内部户到结算户上主机返回码
    ,f_r_acct_host_return_info -- 内部户到结算户主机返回信息
    ,f_r_acct_host_dt -- 内部户到结算户主机日期
    ,f_r_acct_host_flow -- 内部户到结算户主机流水号
    ,open_acct_status_cd -- 开户状态代码
    ,open_acct_dt -- 开户日期
    ,open_acct_host_flow_num -- 开户上主机流水号
    ,open_acct_host_dt -- 开户主机日期
    ,open_acct_uphost_flow -- 开户主机流水号
    ,open_acct_host_return_code -- 开户主机返回码
    ,open_acct_host_return_info -- 开户主机返回信息
    ,open_bank_name -- 开户行名称
    ,trdpty_tran_dt -- 第三方交易日期
    ,trdpty_flow_num -- 第三方流水号
    ,rest_cd -- 处理结果代码
    ,rest_descb -- 处理结果描述
    ,fail_rs_descb -- 失败原因描述
    ,postsc -- 附言
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,tran_vouch_type_cd -- 交易凭证类型代码
    ,tran_vouch_no -- 交易凭证号码
    ,tran_vouch_sell_dt -- 交易凭证出售日期
    ,aldy_spdst_flg_cd -- 已试算标志代码
    ,spdst_uniq_idf -- 试算唯一标识
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,advise_send_cnt -- 通知推送次数
    ,proj_name -- 项目名称
    ,oper_name -- 经办名称
    ,memo_descb -- 摘要描述
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bid_margin_enter_acct_info_h partition for ('mpcsf1')
where 0=1
;

create table ${iml_schema}.agt_bid_margin_enter_acct_info_h_mpcsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bid_margin_enter_acct_info_h partition for ('mpcsf1') where 0=1;

create table ${iml_schema}.agt_bid_margin_enter_acct_info_h_mpcsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bid_margin_enter_acct_info_h partition for ('mpcsf1') where 0=1;

-- 3.1 get new data into table
-- mpcs_a71tfsbinnotice-1
insert into ${iml_schema}.agt_bid_margin_enter_acct_info_h_mpcsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,midgrod_tran_flow_num -- 中台交易流水号
    ,tran_cd -- 交易代码
    ,midgrod_dt -- 中台日期
    ,chn_sys_cd -- 渠道系统代码
    ,chn_tran_dt -- 渠道交易日期
    ,chn_tran_flow_num -- 渠道交易流水号
    ,chn_org_id -- 渠道机构编号
    ,curr_cd -- 币种代码
    ,debit_crdt_flg -- 借贷标志
    ,oper_type_cd -- 操作类型代码
    ,avl_tm -- 到帐时间
    ,avl_amt -- 到帐金额
    ,advise_status_cd -- 通知状态代码
    ,fin_status_cd -- 财务状态代码
    ,aldy_check_entry_flg -- 已对账标志
    ,refund_flg -- 退汇标志
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,payer_open_bank_num -- 付款人开户行号
    ,payer_open_bank_name -- 付款人开户行名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,stl_acct_id -- 结算账户编号
    ,stl_acct_name -- 结算账户名称
    ,stl_acct_bal -- 结算账户余额
    ,margin_acct_status_cd -- 保证金账户状态代码
    ,core_entry_tran_dt -- 核心记账交易日期
    ,core_entry_host_flow_num -- 核心记账主机流水号
    ,core_entry_tran_flow_num -- 核心记账交易流水号
    ,core_entry_status -- 核心记账状态代码
    ,memo_cd -- 摘要代码
    ,f_r_acct_up_host_return_code -- 内部户到结算户上主机返回码
    ,f_r_acct_host_return_info -- 内部户到结算户主机返回信息
    ,f_r_acct_host_dt -- 内部户到结算户主机日期
    ,f_r_acct_host_flow -- 内部户到结算户主机流水号
    ,open_acct_status_cd -- 开户状态代码
    ,open_acct_dt -- 开户日期
    ,open_acct_host_flow_num -- 开户上主机流水号
    ,open_acct_host_dt -- 开户主机日期
    ,open_acct_uphost_flow -- 开户主机流水号
    ,open_acct_host_return_code -- 开户主机返回码
    ,open_acct_host_return_info -- 开户主机返回信息
    ,open_bank_name -- 开户行名称
    ,trdpty_tran_dt -- 第三方交易日期
    ,trdpty_flow_num -- 第三方流水号
    ,rest_cd -- 处理结果代码
    ,rest_descb -- 处理结果描述
    ,fail_rs_descb -- 失败原因描述
    ,postsc -- 附言
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,tran_vouch_type_cd -- 交易凭证类型代码
    ,tran_vouch_no -- 交易凭证号码
    ,tran_vouch_sell_dt -- 交易凭证出售日期
    ,aldy_spdst_flg_cd -- 已试算标志代码
    ,spdst_uniq_idf -- 试算唯一标识
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,advise_send_cnt -- 通知推送次数
    ,proj_name -- 项目名称
    ,oper_name -- 经办名称
    ,memo_descb -- 摘要描述
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300041'||P1.MAINSEQ -- 协议编号
    ,'9999' -- 法人编号
    ,P1.MAINSEQ -- 中台交易流水号
    ,P1.TRANSCODE -- 交易代码
    ,${iml_schema}.dateformat_max2(P1.TRANSDT||P1.TRANSTM) -- 中台日期
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.SYSCD END -- 渠道系统代码
    ,${iml_schema}.dateformat_max2(P1.CHNLDATE) -- 渠道交易日期
    ,P1.CHNLNBR -- 渠道交易流水号
    ,P1.INSTCODE -- 渠道机构编号
    ,nvl(trim(P1.CCYNBR),'-') -- 币种代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL  ELSE '@'||P1.AMNTCD END -- 借贷标志
    ,nvl(trim(P1.OPERTYP),'-') -- 操作类型代码
    ,${iml_schema}.timeformat_max2(P1.INDATE) -- 到帐时间
    ,to_number(nvl(trim(P1.INAMOUNT),0.00)) -- 到帐金额
    ,nvl(trim(P1.STATUS),'-') -- 通知状态代码
    ,nvl(trim(P1.FLAG),'-') -- 财务状态代码
    ,decode(trim(P1.CHECKFLAG),'','-','3','-',P1.CHECKFLAG) -- 已对账标志
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.RTNFLG END -- 退汇标志
    ,P1.INACCT -- 付款账户编号
    ,P1.INNAME -- 付款账户名称
    ,P1.INBANK -- 付款人开户行号
    ,P1.INBANKNAME -- 付款人开户行名称
    ,P1.INMEMO -- 收款账户编号
    ,P1.ACCTNAME -- 收款账户名称
    ,P1.JSHACCTNO -- 结算账户编号
    ,P1.JSHACCTNAME -- 结算账户名称
    ,to_number(nvl(trim(P1.ACCTBAL),0.00)) -- 结算账户余额
    ,nvl(trim(P1.ZIHUFLAG),'-') -- 保证金账户状态代码
    ,${iml_schema}.dateformat_max2(P1.FTRANSDATE||P1.FTRANSTIME) -- 核心记账交易日期
    ,P1.FTRACE -- 核心记账主机流水号
    ,P1.DATAID -- 核心记账交易流水号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.ACCFLAG END -- 核心记账状态代码
    ,nvl(trim(P1.MEMOCD),'-') -- 摘要代码
    ,P1.FHOSTCMD -- 内部户到结算户上主机返回码
    ,P1.FHOSTMSG -- 内部户到结算户主机返回信息
    ,${iml_schema}.dateformat_max2(P1.FHOSTDATE) -- 内部户到结算户主机日期
    ,P1.FHOSTNBR -- 内部户到结算户主机流水号
    ,nvl(trim(P1.OPENACCFLAG),'-') -- 开户状态代码
    ,${iml_schema}.dateformat_max2(P1.KTRANSDATE||P1.KTRANSTIME) -- 开户日期
    ,P1.KTRACE -- 开户上主机流水号
    ,${iml_schema}.dateformat_min(P1.KHOSTDATE) -- 开户主机日期
    ,P1.KHOSTNBR -- 开户主机流水号
    ,P1.KHOSTCMD -- 开户主机返回码
    ,P1.KHOSTMSG -- 开户主机返回信息
    ,P1.SUBOPENBANKNM -- 开户行名称
    ,${iml_schema}.dateformat_max2(P1.TRANSDATE||P1.TRANSTIME) -- 第三方交易日期
    ,P1.THDSEQNO -- 第三方流水号
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.RESULT END -- 处理结果代码
    ,P1.ADDWORD -- 处理结果描述
    ,P1.ERRMSG -- 失败原因描述
    ,P1.REMARK -- 附言
    ,nvl(trim(P1.IDTFTP),'0000') -- 证件类型代码
    ,P1.IDTFNO -- 证件号码
    ,nvl(trim(P1.CHEQTP),'000') -- 交易凭证类型代码
    ,P1.CHEQNO -- 交易凭证号码
    ,${iml_schema}.dateformat_max2(P1.INVODT) -- 交易凭证出售日期
    ,nvl(trim(P1.TRIFLAG),'-') -- 已试算标志代码
    ,P1.UNIQUEFLAG -- 试算唯一标识
    ,P1.BRCNO -- 交易机构编号
    ,P1.TLRNO -- 交易柜员编号
    ,P1.AUTHTLRNO -- 授权柜员编号
    ,to_number(nvl(trim(P1.NTCTIMES),0)) -- 通知推送次数
    ,P1.PROJNAME -- 项目名称
    ,P1.OPERRNAME -- 经办名称
    ,P1.MEMOINFO -- 摘要描述
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a71tfsbinnotice' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a71tfsbinnotice p1
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.SYSCD = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'MPCS'
        AND R5.SRC_TAB_EN_NAME= 'MPCS_A71TFSBINNOTICE'
        AND R5.SRC_FIELD_EN_NAME= 'SYSCD'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_BID_MARGIN_ENTER_ACCT_INFO_H'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'CHN_SYS_CD'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.AMNTCD = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A71TFSBINNOTICE'
        AND R1.SRC_FIELD_EN_NAME= 'AMNTCD'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_BID_MARGIN_ENTER_ACCT_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'DEBIT_CRDT_FLG'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.RTNFLG = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A71TFSBINNOTICE'
        AND R2.SRC_FIELD_EN_NAME= 'RTNFLG'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_BID_MARGIN_ENTER_ACCT_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'REFUND_FLG'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.ACCFLAG = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'MPCS'
        AND R3.SRC_TAB_EN_NAME= 'MPCS_A71TFSBINNOTICE'
        AND R3.SRC_FIELD_EN_NAME= 'ACCFLAG'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_BID_MARGIN_ENTER_ACCT_INFO_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CORE_ENTRY_STATUS'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.RESULT = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'MPCS'
        AND R4.SRC_TAB_EN_NAME= 'MPCS_A71TFSBINNOTICE'
        AND R4.SRC_FIELD_EN_NAME= 'RESULT'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_BID_MARGIN_ENTER_ACCT_INFO_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'REST_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_bid_margin_enter_acct_info_h_mpcsf1_tm 
  	                                group by 
  	                                        agt_id
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
        into ${iml_schema}.agt_bid_margin_enter_acct_info_h_mpcsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,midgrod_tran_flow_num -- 中台交易流水号
    ,tran_cd -- 交易代码
    ,midgrod_dt -- 中台日期
    ,chn_sys_cd -- 渠道系统代码
    ,chn_tran_dt -- 渠道交易日期
    ,chn_tran_flow_num -- 渠道交易流水号
    ,chn_org_id -- 渠道机构编号
    ,curr_cd -- 币种代码
    ,debit_crdt_flg -- 借贷标志
    ,oper_type_cd -- 操作类型代码
    ,avl_tm -- 到帐时间
    ,avl_amt -- 到帐金额
    ,advise_status_cd -- 通知状态代码
    ,fin_status_cd -- 财务状态代码
    ,aldy_check_entry_flg -- 已对账标志
    ,refund_flg -- 退汇标志
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,payer_open_bank_num -- 付款人开户行号
    ,payer_open_bank_name -- 付款人开户行名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,stl_acct_id -- 结算账户编号
    ,stl_acct_name -- 结算账户名称
    ,stl_acct_bal -- 结算账户余额
    ,margin_acct_status_cd -- 保证金账户状态代码
    ,core_entry_tran_dt -- 核心记账交易日期
    ,core_entry_host_flow_num -- 核心记账主机流水号
    ,core_entry_tran_flow_num -- 核心记账交易流水号
    ,core_entry_status -- 核心记账状态代码
    ,memo_cd -- 摘要代码
    ,f_r_acct_up_host_return_code -- 内部户到结算户上主机返回码
    ,f_r_acct_host_return_info -- 内部户到结算户主机返回信息
    ,f_r_acct_host_dt -- 内部户到结算户主机日期
    ,f_r_acct_host_flow -- 内部户到结算户主机流水号
    ,open_acct_status_cd -- 开户状态代码
    ,open_acct_dt -- 开户日期
    ,open_acct_host_flow_num -- 开户上主机流水号
    ,open_acct_host_dt -- 开户主机日期
    ,open_acct_uphost_flow -- 开户主机流水号
    ,open_acct_host_return_code -- 开户主机返回码
    ,open_acct_host_return_info -- 开户主机返回信息
    ,open_bank_name -- 开户行名称
    ,trdpty_tran_dt -- 第三方交易日期
    ,trdpty_flow_num -- 第三方流水号
    ,rest_cd -- 处理结果代码
    ,rest_descb -- 处理结果描述
    ,fail_rs_descb -- 失败原因描述
    ,postsc -- 附言
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,tran_vouch_type_cd -- 交易凭证类型代码
    ,tran_vouch_no -- 交易凭证号码
    ,tran_vouch_sell_dt -- 交易凭证出售日期
    ,aldy_spdst_flg_cd -- 已试算标志代码
    ,spdst_uniq_idf -- 试算唯一标识
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,advise_send_cnt -- 通知推送次数
    ,proj_name -- 项目名称
    ,oper_name -- 经办名称
    ,memo_descb -- 摘要描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_bid_margin_enter_acct_info_h_mpcsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,midgrod_tran_flow_num -- 中台交易流水号
    ,tran_cd -- 交易代码
    ,midgrod_dt -- 中台日期
    ,chn_sys_cd -- 渠道系统代码
    ,chn_tran_dt -- 渠道交易日期
    ,chn_tran_flow_num -- 渠道交易流水号
    ,chn_org_id -- 渠道机构编号
    ,curr_cd -- 币种代码
    ,debit_crdt_flg -- 借贷标志
    ,oper_type_cd -- 操作类型代码
    ,avl_tm -- 到帐时间
    ,avl_amt -- 到帐金额
    ,advise_status_cd -- 通知状态代码
    ,fin_status_cd -- 财务状态代码
    ,aldy_check_entry_flg -- 已对账标志
    ,refund_flg -- 退汇标志
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,payer_open_bank_num -- 付款人开户行号
    ,payer_open_bank_name -- 付款人开户行名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,stl_acct_id -- 结算账户编号
    ,stl_acct_name -- 结算账户名称
    ,stl_acct_bal -- 结算账户余额
    ,margin_acct_status_cd -- 保证金账户状态代码
    ,core_entry_tran_dt -- 核心记账交易日期
    ,core_entry_host_flow_num -- 核心记账主机流水号
    ,core_entry_tran_flow_num -- 核心记账交易流水号
    ,core_entry_status -- 核心记账状态代码
    ,memo_cd -- 摘要代码
    ,f_r_acct_up_host_return_code -- 内部户到结算户上主机返回码
    ,f_r_acct_host_return_info -- 内部户到结算户主机返回信息
    ,f_r_acct_host_dt -- 内部户到结算户主机日期
    ,f_r_acct_host_flow -- 内部户到结算户主机流水号
    ,open_acct_status_cd -- 开户状态代码
    ,open_acct_dt -- 开户日期
    ,open_acct_host_flow_num -- 开户上主机流水号
    ,open_acct_host_dt -- 开户主机日期
    ,open_acct_uphost_flow -- 开户主机流水号
    ,open_acct_host_return_code -- 开户主机返回码
    ,open_acct_host_return_info -- 开户主机返回信息
    ,open_bank_name -- 开户行名称
    ,trdpty_tran_dt -- 第三方交易日期
    ,trdpty_flow_num -- 第三方流水号
    ,rest_cd -- 处理结果代码
    ,rest_descb -- 处理结果描述
    ,fail_rs_descb -- 失败原因描述
    ,postsc -- 附言
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,tran_vouch_type_cd -- 交易凭证类型代码
    ,tran_vouch_no -- 交易凭证号码
    ,tran_vouch_sell_dt -- 交易凭证出售日期
    ,aldy_spdst_flg_cd -- 已试算标志代码
    ,spdst_uniq_idf -- 试算唯一标识
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,advise_send_cnt -- 通知推送次数
    ,proj_name -- 项目名称
    ,oper_name -- 经办名称
    ,memo_descb -- 摘要描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.midgrod_tran_flow_num, o.midgrod_tran_flow_num) as midgrod_tran_flow_num -- 中台交易流水号
    ,nvl(n.tran_cd, o.tran_cd) as tran_cd -- 交易代码
    ,nvl(n.midgrod_dt, o.midgrod_dt) as midgrod_dt -- 中台日期
    ,nvl(n.chn_sys_cd, o.chn_sys_cd) as chn_sys_cd -- 渠道系统代码
    ,nvl(n.chn_tran_dt, o.chn_tran_dt) as chn_tran_dt -- 渠道交易日期
    ,nvl(n.chn_tran_flow_num, o.chn_tran_flow_num) as chn_tran_flow_num -- 渠道交易流水号
    ,nvl(n.chn_org_id, o.chn_org_id) as chn_org_id -- 渠道机构编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.debit_crdt_flg, o.debit_crdt_flg) as debit_crdt_flg -- 借贷标志
    ,nvl(n.oper_type_cd, o.oper_type_cd) as oper_type_cd -- 操作类型代码
    ,nvl(n.avl_tm, o.avl_tm) as avl_tm -- 到帐时间
    ,nvl(n.avl_amt, o.avl_amt) as avl_amt -- 到帐金额
    ,nvl(n.advise_status_cd, o.advise_status_cd) as advise_status_cd -- 通知状态代码
    ,nvl(n.fin_status_cd, o.fin_status_cd) as fin_status_cd -- 财务状态代码
    ,nvl(n.aldy_check_entry_flg, o.aldy_check_entry_flg) as aldy_check_entry_flg -- 已对账标志
    ,nvl(n.refund_flg, o.refund_flg) as refund_flg -- 退汇标志
    ,nvl(n.pay_acct_id, o.pay_acct_id) as pay_acct_id -- 付款账户编号
    ,nvl(n.pay_acct_name, o.pay_acct_name) as pay_acct_name -- 付款账户名称
    ,nvl(n.payer_open_bank_num, o.payer_open_bank_num) as payer_open_bank_num -- 付款人开户行号
    ,nvl(n.payer_open_bank_name, o.payer_open_bank_name) as payer_open_bank_name -- 付款人开户行名称
    ,nvl(n.recvbl_acct_id, o.recvbl_acct_id) as recvbl_acct_id -- 收款账户编号
    ,nvl(n.recvbl_acct_name, o.recvbl_acct_name) as recvbl_acct_name -- 收款账户名称
    ,nvl(n.stl_acct_id, o.stl_acct_id) as stl_acct_id -- 结算账户编号
    ,nvl(n.stl_acct_name, o.stl_acct_name) as stl_acct_name -- 结算账户名称
    ,nvl(n.stl_acct_bal, o.stl_acct_bal) as stl_acct_bal -- 结算账户余额
    ,nvl(n.margin_acct_status_cd, o.margin_acct_status_cd) as margin_acct_status_cd -- 保证金账户状态代码
    ,nvl(n.core_entry_tran_dt, o.core_entry_tran_dt) as core_entry_tran_dt -- 核心记账交易日期
    ,nvl(n.core_entry_host_flow_num, o.core_entry_host_flow_num) as core_entry_host_flow_num -- 核心记账主机流水号
    ,nvl(n.core_entry_tran_flow_num, o.core_entry_tran_flow_num) as core_entry_tran_flow_num -- 核心记账交易流水号
    ,nvl(n.core_entry_status, o.core_entry_status) as core_entry_status -- 核心记账状态代码
    ,nvl(n.memo_cd, o.memo_cd) as memo_cd -- 摘要代码
    ,nvl(n.f_r_acct_up_host_return_code, o.f_r_acct_up_host_return_code) as f_r_acct_up_host_return_code -- 内部户到结算户上主机返回码
    ,nvl(n.f_r_acct_host_return_info, o.f_r_acct_host_return_info) as f_r_acct_host_return_info -- 内部户到结算户主机返回信息
    ,nvl(n.f_r_acct_host_dt, o.f_r_acct_host_dt) as f_r_acct_host_dt -- 内部户到结算户主机日期
    ,nvl(n.f_r_acct_host_flow, o.f_r_acct_host_flow) as f_r_acct_host_flow -- 内部户到结算户主机流水号
    ,nvl(n.open_acct_status_cd, o.open_acct_status_cd) as open_acct_status_cd -- 开户状态代码
    ,nvl(n.open_acct_dt, o.open_acct_dt) as open_acct_dt -- 开户日期
    ,nvl(n.open_acct_host_flow_num, o.open_acct_host_flow_num) as open_acct_host_flow_num -- 开户上主机流水号
    ,nvl(n.open_acct_host_dt, o.open_acct_host_dt) as open_acct_host_dt -- 开户主机日期
    ,nvl(n.open_acct_uphost_flow, o.open_acct_uphost_flow) as open_acct_uphost_flow -- 开户主机流水号
    ,nvl(n.open_acct_host_return_code, o.open_acct_host_return_code) as open_acct_host_return_code -- 开户主机返回码
    ,nvl(n.open_acct_host_return_info, o.open_acct_host_return_info) as open_acct_host_return_info -- 开户主机返回信息
    ,nvl(n.open_bank_name, o.open_bank_name) as open_bank_name -- 开户行名称
    ,nvl(n.trdpty_tran_dt, o.trdpty_tran_dt) as trdpty_tran_dt -- 第三方交易日期
    ,nvl(n.trdpty_flow_num, o.trdpty_flow_num) as trdpty_flow_num -- 第三方流水号
    ,nvl(n.rest_cd, o.rest_cd) as rest_cd -- 处理结果代码
    ,nvl(n.rest_descb, o.rest_descb) as rest_descb -- 处理结果描述
    ,nvl(n.fail_rs_descb, o.fail_rs_descb) as fail_rs_descb -- 失败原因描述
    ,nvl(n.postsc, o.postsc) as postsc -- 附言
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.tran_vouch_type_cd, o.tran_vouch_type_cd) as tran_vouch_type_cd -- 交易凭证类型代码
    ,nvl(n.tran_vouch_no, o.tran_vouch_no) as tran_vouch_no -- 交易凭证号码
    ,nvl(n.tran_vouch_sell_dt, o.tran_vouch_sell_dt) as tran_vouch_sell_dt -- 交易凭证出售日期
    ,nvl(n.aldy_spdst_flg_cd, o.aldy_spdst_flg_cd) as aldy_spdst_flg_cd -- 已试算标志代码
    ,nvl(n.spdst_uniq_idf, o.spdst_uniq_idf) as spdst_uniq_idf -- 试算唯一标识
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.auth_teller_id, o.auth_teller_id) as auth_teller_id -- 授权柜员编号
    ,nvl(n.advise_send_cnt, o.advise_send_cnt) as advise_send_cnt -- 通知推送次数
    ,nvl(n.proj_name, o.proj_name) as proj_name -- 项目名称
    ,nvl(n.oper_name, o.oper_name) as oper_name -- 经办名称
    ,nvl(n.memo_descb, o.memo_descb) as memo_descb -- 摘要描述
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bid_margin_enter_acct_info_h_mpcsf1_tm n
    full join (select * from ${iml_schema}.agt_bid_margin_enter_acct_info_h_mpcsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.midgrod_tran_flow_num <> n.midgrod_tran_flow_num
        or o.tran_cd <> n.tran_cd
        or o.midgrod_dt <> n.midgrod_dt
        or o.chn_sys_cd <> n.chn_sys_cd
        or o.chn_tran_dt <> n.chn_tran_dt
        or o.chn_tran_flow_num <> n.chn_tran_flow_num
        or o.chn_org_id <> n.chn_org_id
        or o.curr_cd <> n.curr_cd
        or o.debit_crdt_flg <> n.debit_crdt_flg
        or o.oper_type_cd <> n.oper_type_cd
        or o.avl_tm <> n.avl_tm
        or o.avl_amt <> n.avl_amt
        or o.advise_status_cd <> n.advise_status_cd
        or o.fin_status_cd <> n.fin_status_cd
        or o.aldy_check_entry_flg <> n.aldy_check_entry_flg
        or o.refund_flg <> n.refund_flg
        or o.pay_acct_id <> n.pay_acct_id
        or o.pay_acct_name <> n.pay_acct_name
        or o.payer_open_bank_num <> n.payer_open_bank_num
        or o.payer_open_bank_name <> n.payer_open_bank_name
        or o.recvbl_acct_id <> n.recvbl_acct_id
        or o.recvbl_acct_name <> n.recvbl_acct_name
        or o.stl_acct_id <> n.stl_acct_id
        or o.stl_acct_name <> n.stl_acct_name
        or o.stl_acct_bal <> n.stl_acct_bal
        or o.margin_acct_status_cd <> n.margin_acct_status_cd
        or o.core_entry_tran_dt <> n.core_entry_tran_dt
        or o.core_entry_host_flow_num <> n.core_entry_host_flow_num
        or o.core_entry_tran_flow_num <> n.core_entry_tran_flow_num
        or o.core_entry_status <> n.core_entry_status
        or o.memo_cd <> n.memo_cd
        or o.f_r_acct_up_host_return_code <> n.f_r_acct_up_host_return_code
        or o.f_r_acct_host_return_info <> n.f_r_acct_host_return_info
        or o.f_r_acct_host_dt <> n.f_r_acct_host_dt
        or o.f_r_acct_host_flow <> n.f_r_acct_host_flow
        or o.open_acct_status_cd <> n.open_acct_status_cd
        or o.open_acct_dt <> n.open_acct_dt
        or o.open_acct_host_flow_num <> n.open_acct_host_flow_num
        or o.open_acct_host_dt <> n.open_acct_host_dt
        or o.open_acct_uphost_flow <> n.open_acct_uphost_flow
        or o.open_acct_host_return_code <> n.open_acct_host_return_code
        or o.open_acct_host_return_info <> n.open_acct_host_return_info
        or o.open_bank_name <> n.open_bank_name
        or o.trdpty_tran_dt <> n.trdpty_tran_dt
        or o.trdpty_flow_num <> n.trdpty_flow_num
        or o.rest_cd <> n.rest_cd
        or o.rest_descb <> n.rest_descb
        or o.fail_rs_descb <> n.fail_rs_descb
        or o.postsc <> n.postsc
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_no <> n.cert_no
        or o.tran_vouch_type_cd <> n.tran_vouch_type_cd
        or o.tran_vouch_no <> n.tran_vouch_no
        or o.tran_vouch_sell_dt <> n.tran_vouch_sell_dt
        or o.aldy_spdst_flg_cd <> n.aldy_spdst_flg_cd
        or o.spdst_uniq_idf <> n.spdst_uniq_idf
        or o.tran_org_id <> n.tran_org_id
        or o.tran_teller_id <> n.tran_teller_id
        or o.auth_teller_id <> n.auth_teller_id
        or o.advise_send_cnt <> n.advise_send_cnt
        or o.proj_name <> n.proj_name
        or o.oper_name <> n.oper_name
        or o.memo_descb <> n.memo_descb
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_bid_margin_enter_acct_info_h_mpcsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,midgrod_tran_flow_num -- 中台交易流水号
    ,tran_cd -- 交易代码
    ,midgrod_dt -- 中台日期
    ,chn_sys_cd -- 渠道系统代码
    ,chn_tran_dt -- 渠道交易日期
    ,chn_tran_flow_num -- 渠道交易流水号
    ,chn_org_id -- 渠道机构编号
    ,curr_cd -- 币种代码
    ,debit_crdt_flg -- 借贷标志
    ,oper_type_cd -- 操作类型代码
    ,avl_tm -- 到帐时间
    ,avl_amt -- 到帐金额
    ,advise_status_cd -- 通知状态代码
    ,fin_status_cd -- 财务状态代码
    ,aldy_check_entry_flg -- 已对账标志
    ,refund_flg -- 退汇标志
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,payer_open_bank_num -- 付款人开户行号
    ,payer_open_bank_name -- 付款人开户行名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,stl_acct_id -- 结算账户编号
    ,stl_acct_name -- 结算账户名称
    ,stl_acct_bal -- 结算账户余额
    ,margin_acct_status_cd -- 保证金账户状态代码
    ,core_entry_tran_dt -- 核心记账交易日期
    ,core_entry_host_flow_num -- 核心记账主机流水号
    ,core_entry_tran_flow_num -- 核心记账交易流水号
    ,core_entry_status -- 核心记账状态代码
    ,memo_cd -- 摘要代码
    ,f_r_acct_up_host_return_code -- 内部户到结算户上主机返回码
    ,f_r_acct_host_return_info -- 内部户到结算户主机返回信息
    ,f_r_acct_host_dt -- 内部户到结算户主机日期
    ,f_r_acct_host_flow -- 内部户到结算户主机流水号
    ,open_acct_status_cd -- 开户状态代码
    ,open_acct_dt -- 开户日期
    ,open_acct_host_flow_num -- 开户上主机流水号
    ,open_acct_host_dt -- 开户主机日期
    ,open_acct_uphost_flow -- 开户主机流水号
    ,open_acct_host_return_code -- 开户主机返回码
    ,open_acct_host_return_info -- 开户主机返回信息
    ,open_bank_name -- 开户行名称
    ,trdpty_tran_dt -- 第三方交易日期
    ,trdpty_flow_num -- 第三方流水号
    ,rest_cd -- 处理结果代码
    ,rest_descb -- 处理结果描述
    ,fail_rs_descb -- 失败原因描述
    ,postsc -- 附言
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,tran_vouch_type_cd -- 交易凭证类型代码
    ,tran_vouch_no -- 交易凭证号码
    ,tran_vouch_sell_dt -- 交易凭证出售日期
    ,aldy_spdst_flg_cd -- 已试算标志代码
    ,spdst_uniq_idf -- 试算唯一标识
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,advise_send_cnt -- 通知推送次数
    ,proj_name -- 项目名称
    ,oper_name -- 经办名称
    ,memo_descb -- 摘要描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_bid_margin_enter_acct_info_h_mpcsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,midgrod_tran_flow_num -- 中台交易流水号
    ,tran_cd -- 交易代码
    ,midgrod_dt -- 中台日期
    ,chn_sys_cd -- 渠道系统代码
    ,chn_tran_dt -- 渠道交易日期
    ,chn_tran_flow_num -- 渠道交易流水号
    ,chn_org_id -- 渠道机构编号
    ,curr_cd -- 币种代码
    ,debit_crdt_flg -- 借贷标志
    ,oper_type_cd -- 操作类型代码
    ,avl_tm -- 到帐时间
    ,avl_amt -- 到帐金额
    ,advise_status_cd -- 通知状态代码
    ,fin_status_cd -- 财务状态代码
    ,aldy_check_entry_flg -- 已对账标志
    ,refund_flg -- 退汇标志
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,payer_open_bank_num -- 付款人开户行号
    ,payer_open_bank_name -- 付款人开户行名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,stl_acct_id -- 结算账户编号
    ,stl_acct_name -- 结算账户名称
    ,stl_acct_bal -- 结算账户余额
    ,margin_acct_status_cd -- 保证金账户状态代码
    ,core_entry_tran_dt -- 核心记账交易日期
    ,core_entry_host_flow_num -- 核心记账主机流水号
    ,core_entry_tran_flow_num -- 核心记账交易流水号
    ,core_entry_status -- 核心记账状态代码
    ,memo_cd -- 摘要代码
    ,f_r_acct_up_host_return_code -- 内部户到结算户上主机返回码
    ,f_r_acct_host_return_info -- 内部户到结算户主机返回信息
    ,f_r_acct_host_dt -- 内部户到结算户主机日期
    ,f_r_acct_host_flow -- 内部户到结算户主机流水号
    ,open_acct_status_cd -- 开户状态代码
    ,open_acct_dt -- 开户日期
    ,open_acct_host_flow_num -- 开户上主机流水号
    ,open_acct_host_dt -- 开户主机日期
    ,open_acct_uphost_flow -- 开户主机流水号
    ,open_acct_host_return_code -- 开户主机返回码
    ,open_acct_host_return_info -- 开户主机返回信息
    ,open_bank_name -- 开户行名称
    ,trdpty_tran_dt -- 第三方交易日期
    ,trdpty_flow_num -- 第三方流水号
    ,rest_cd -- 处理结果代码
    ,rest_descb -- 处理结果描述
    ,fail_rs_descb -- 失败原因描述
    ,postsc -- 附言
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,tran_vouch_type_cd -- 交易凭证类型代码
    ,tran_vouch_no -- 交易凭证号码
    ,tran_vouch_sell_dt -- 交易凭证出售日期
    ,aldy_spdst_flg_cd -- 已试算标志代码
    ,spdst_uniq_idf -- 试算唯一标识
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,advise_send_cnt -- 通知推送次数
    ,proj_name -- 项目名称
    ,oper_name -- 经办名称
    ,memo_descb -- 摘要描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.midgrod_tran_flow_num -- 中台交易流水号
    ,o.tran_cd -- 交易代码
    ,o.midgrod_dt -- 中台日期
    ,o.chn_sys_cd -- 渠道系统代码
    ,o.chn_tran_dt -- 渠道交易日期
    ,o.chn_tran_flow_num -- 渠道交易流水号
    ,o.chn_org_id -- 渠道机构编号
    ,o.curr_cd -- 币种代码
    ,o.debit_crdt_flg -- 借贷标志
    ,o.oper_type_cd -- 操作类型代码
    ,o.avl_tm -- 到帐时间
    ,o.avl_amt -- 到帐金额
    ,o.advise_status_cd -- 通知状态代码
    ,o.fin_status_cd -- 财务状态代码
    ,o.aldy_check_entry_flg -- 已对账标志
    ,o.refund_flg -- 退汇标志
    ,o.pay_acct_id -- 付款账户编号
    ,o.pay_acct_name -- 付款账户名称
    ,o.payer_open_bank_num -- 付款人开户行号
    ,o.payer_open_bank_name -- 付款人开户行名称
    ,o.recvbl_acct_id -- 收款账户编号
    ,o.recvbl_acct_name -- 收款账户名称
    ,o.stl_acct_id -- 结算账户编号
    ,o.stl_acct_name -- 结算账户名称
    ,o.stl_acct_bal -- 结算账户余额
    ,o.margin_acct_status_cd -- 保证金账户状态代码
    ,o.core_entry_tran_dt -- 核心记账交易日期
    ,o.core_entry_host_flow_num -- 核心记账主机流水号
    ,o.core_entry_tran_flow_num -- 核心记账交易流水号
    ,o.core_entry_status -- 核心记账状态代码
    ,o.memo_cd -- 摘要代码
    ,o.f_r_acct_up_host_return_code -- 内部户到结算户上主机返回码
    ,o.f_r_acct_host_return_info -- 内部户到结算户主机返回信息
    ,o.f_r_acct_host_dt -- 内部户到结算户主机日期
    ,o.f_r_acct_host_flow -- 内部户到结算户主机流水号
    ,o.open_acct_status_cd -- 开户状态代码
    ,o.open_acct_dt -- 开户日期
    ,o.open_acct_host_flow_num -- 开户上主机流水号
    ,o.open_acct_host_dt -- 开户主机日期
    ,o.open_acct_uphost_flow -- 开户主机流水号
    ,o.open_acct_host_return_code -- 开户主机返回码
    ,o.open_acct_host_return_info -- 开户主机返回信息
    ,o.open_bank_name -- 开户行名称
    ,o.trdpty_tran_dt -- 第三方交易日期
    ,o.trdpty_flow_num -- 第三方流水号
    ,o.rest_cd -- 处理结果代码
    ,o.rest_descb -- 处理结果描述
    ,o.fail_rs_descb -- 失败原因描述
    ,o.postsc -- 附言
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_no -- 证件号码
    ,o.tran_vouch_type_cd -- 交易凭证类型代码
    ,o.tran_vouch_no -- 交易凭证号码
    ,o.tran_vouch_sell_dt -- 交易凭证出售日期
    ,o.aldy_spdst_flg_cd -- 已试算标志代码
    ,o.spdst_uniq_idf -- 试算唯一标识
    ,o.tran_org_id -- 交易机构编号
    ,o.tran_teller_id -- 交易柜员编号
    ,o.auth_teller_id -- 授权柜员编号
    ,o.advise_send_cnt -- 通知推送次数
    ,o.proj_name -- 项目名称
    ,o.oper_name -- 经办名称
    ,o.memo_descb -- 摘要描述
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
from ${iml_schema}.agt_bid_margin_enter_acct_info_h_mpcsf1_bk o
    left join ${iml_schema}.agt_bid_margin_enter_acct_info_h_mpcsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_bid_margin_enter_acct_info_h_mpcsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_bid_margin_enter_acct_info_h;
--alter table ${iml_schema}.agt_bid_margin_enter_acct_info_h truncate partition for ('mpcsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_bid_margin_enter_acct_info_h') 
               and substr(subpartition_name,1,8)=upper('p_mpcsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_bid_margin_enter_acct_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_bid_margin_enter_acct_info_h modify partition p_mpcsf1 
add subpartition p_mpcsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_bid_margin_enter_acct_info_h exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.agt_bid_margin_enter_acct_info_h_mpcsf1_cl;
alter table ${iml_schema}.agt_bid_margin_enter_acct_info_h exchange subpartition p_mpcsf1_20991231 with table ${iml_schema}.agt_bid_margin_enter_acct_info_h_mpcsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_bid_margin_enter_acct_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_bid_margin_enter_acct_info_h_mpcsf1_tm purge;
drop table ${iml_schema}.agt_bid_margin_enter_acct_info_h_mpcsf1_op purge;
drop table ${iml_schema}.agt_bid_margin_enter_acct_info_h_mpcsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_bid_margin_enter_acct_info_h_mpcsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_bid_margin_enter_acct_info_h', partname => 'p_mpcsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
