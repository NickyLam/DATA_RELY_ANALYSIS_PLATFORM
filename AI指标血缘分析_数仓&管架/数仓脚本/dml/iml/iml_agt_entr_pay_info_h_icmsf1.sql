/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_entr_pay_info_h_icmsf1
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
alter table ${iml_schema}.agt_entr_pay_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_entr_pay_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_entr_pay_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_entr_pay_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_entr_pay_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_entr_pay_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_entr_pay_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,pay_flow_num -- 支付流水号
    ,out_acct_flow_num -- 出账流水号
    ,pay_ser_num -- 支付序列号
    ,plat_req_flow_num -- 平台请求流水号
    ,plat_tran_flow_num -- 平台交易流水号
    ,plat_tran_dt -- 平台交易日期
    ,core_flow_num -- 核心流水号
    ,dtl_flow_num -- 明细流水号
    ,ghb_cust_flg -- 本行客户标志
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,mode_pay_cd -- 支付方式代码
    ,pay_dt -- 支付日期
    ,actl_pay_dt -- 实际支付日期
    ,pay_tm -- 支付时间
    ,tran_in_bank_name -- 转入行名称
    ,recver_name -- 收款人名称
    ,recver_open_bank_name -- 收款人开户行名称
    ,recvbl_acct_id -- 收款账户编号
    ,recver_addr -- 收款人地址
    ,curr_cd -- 币种代码
    ,pay_amt -- 支付金额
    ,pay_status_cd -- 支付状态代码
    ,cap_usage_descb -- 资金用途描述
    ,precon_entr_pay_flg -- 预约受托支付标志
    ,entr_pay_id -- 受托支付编号
    ,entr_pay_batch_no -- 受托支付批次号
    ,entr_pay_seq_num -- 受托支付序号
    ,entr_pay_tot_id -- 受托支付汇总编号
    ,onl_entr_pay_status_cd -- 在线受托支付状态代码
    ,onl_entred_init_tran_plat_flow_num -- 在线受托原交易平台流水号
    ,onl_entred_stop_pay_tran_flow_num -- 在线受托止付交易流水号
    ,stop_pay_flow_num -- 止付流水号
    ,stop_pay_tran_dt -- 止付交易日期
    ,froz_flow_num -- 冻结流水号
    ,a_send_tm -- 重新发送时间
    ,pay_fail_rs_descb -- 支付失败原因描述
    ,bank_int_acct_flg -- 行内账户标志
    ,repeat_status_cd -- 重发状态代码
    ,cfm_status_cd -- 确认状态代码
    ,move_flg -- 迁移标志
    ,latest_pay_dt -- 最迟支付日期
    ,matn_idf_cd -- 维护标识代码
    ,cross_bor_flg -- 跨境标志
    ,loan_usage_descb -- 贷款用途描述
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_entr_pay_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_entr_pay_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_entr_pay_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_entr_pay_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_entr_pay_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_payment_info-1
insert into ${iml_schema}.agt_entr_pay_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,pay_flow_num -- 支付流水号
    ,out_acct_flow_num -- 出账流水号
    ,pay_ser_num -- 支付序列号
    ,plat_req_flow_num -- 平台请求流水号
    ,plat_tran_flow_num -- 平台交易流水号
    ,plat_tran_dt -- 平台交易日期
    ,core_flow_num -- 核心流水号
    ,dtl_flow_num -- 明细流水号
    ,ghb_cust_flg -- 本行客户标志
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,mode_pay_cd -- 支付方式代码
    ,pay_dt -- 支付日期
    ,actl_pay_dt -- 实际支付日期
    ,pay_tm -- 支付时间
    ,tran_in_bank_name -- 转入行名称
    ,recver_name -- 收款人名称
    ,recver_open_bank_name -- 收款人开户行名称
    ,recvbl_acct_id -- 收款账户编号
    ,recver_addr -- 收款人地址
    ,curr_cd -- 币种代码
    ,pay_amt -- 支付金额
    ,pay_status_cd -- 支付状态代码
    ,cap_usage_descb -- 资金用途描述
    ,precon_entr_pay_flg -- 预约受托支付标志
    ,entr_pay_id -- 受托支付编号
    ,entr_pay_batch_no -- 受托支付批次号
    ,entr_pay_seq_num -- 受托支付序号
    ,entr_pay_tot_id -- 受托支付汇总编号
    ,onl_entr_pay_status_cd -- 在线受托支付状态代码
    ,onl_entred_init_tran_plat_flow_num -- 在线受托原交易平台流水号
    ,onl_entred_stop_pay_tran_flow_num -- 在线受托止付交易流水号
    ,stop_pay_flow_num -- 止付流水号
    ,stop_pay_tran_dt -- 止付交易日期
    ,froz_flow_num -- 冻结流水号
    ,a_send_tm -- 重新发送时间
    ,pay_fail_rs_descb -- 支付失败原因描述
    ,bank_int_acct_flg -- 行内账户标志
    ,repeat_status_cd -- 重发状态代码
    ,cfm_status_cd -- 确认状态代码
    ,move_flg -- 迁移标志
    ,latest_pay_dt -- 最迟支付日期
    ,matn_idf_cd -- 维护标识代码
    ,cross_bor_flg -- 跨境标志
    ,loan_usage_descb -- 贷款用途描述
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300013'||P1.SERIALNO -- 协议编号
    , '9999' -- 法人编号
    ,P1.SERIALNO -- 支付流水号
    ,P1.PUTOUTSERIALNO -- 出账流水号
    ,P1.SEQUENCENUM -- 支付序列号
    ,P1.TRANSEQNO -- 平台请求流水号
    ,P1.TRANSFORMNO -- 平台交易流水号
    ,${iml_schema}.dateformat_min(P1.TRXDATE) -- 平台交易日期
    ,P1.BCSACCTSEQNUM -- 核心流水号
    ,P1.ROWNO -- 明细流水号
    ,nvl(trim(P1.ISBANKACCOUNT),'-') -- 本行客户标志
    ,P1.CUSTOMERID -- 客户编号
    ,P1.CUSTOMERNAME -- 客户名称
    ,nvl(trim(P1.PAYMENTTYPE),'0') -- 支付方式代码
    ,P1.PAYMENTDATE -- 支付日期
    ,P1.ACTUALPAYDATE -- 实际支付日期
    ,${iml_schema}.timeformat_min(P1.PAYMENTTIME) -- 支付时间
    ,P1.PAYEEBANKNAME -- 转入行名称
    ,P1.PAYEENAME -- 收款人名称
    ,P1.PAYEEBANK -- 收款人开户行名称
    ,P1.PAYEEACCOUNT -- 收款账户编号
    ,P1.PAYEENAMEADD -- 收款人地址
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,P1.PAYMENTSUM -- 支付金额
    ,nvl(trim(P1.PAYMENTSTATUS),'-') -- 支付状态代码
    ,P1.CAPITALPURPOSE -- 资金用途描述
    ,nvl(trim(P1.ISRESERVEPAY),'-')   -- 预约受托支付标志
    ,P1.ENTRUSTEDNO -- 受托支付编号
    ,P1.BATCHNO -- 受托支付批次号
    ,P1.ENTRUSTEDPAYID -- 受托支付序号
    ,P1.OBJECTNO -- 受托支付汇总编号
    ,nvl(trim(P1.PAYSTATUS),'-')  -- 在线受托支付状态代码
    ,P1.PLATTRXSEQ -- 在线受托原交易平台流水号
    ,P1.ZFJYSERIALNO -- 在线受托止付交易流水号
    ,P1.ZFSERIALNO -- 止付流水号
    ,P1.RESENDDATETIME -- 止付交易日期
    ,P1.FREEZESEQNO -- 冻结流水号
    ,P1.RESENDDATETIME -- 重新发送时间
    ,P1.CAUSE -- 支付失败原因描述
    ,P1.ISINNERACCOUNT -- 行内账户标志
    ,P1.RESENDSTATUS -- 重发状态代码
    ,P1.CONFIRMSTATUS -- 确认状态代码
    ,CASE WHEN TRIM(P1.MIGTFLAG) IS NOT NULL THEN '1' ELSE '0' END -- 迁移标志
    ,P1.MAXPAYDATE -- 最迟支付日期
    ,P1.ISINUSE -- 维护标识代码
    ,P1.ISKJ -- 跨境标志
    ,P1.CAPITALPURPOSEDESC -- 贷款用途描述
    ,P1.REMARK -- 备注
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEDATE -- 变更日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_payment_info' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_payment_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_entr_pay_info_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,pay_flow_num
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
        into ${iml_schema}.agt_entr_pay_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,pay_flow_num -- 支付流水号
    ,out_acct_flow_num -- 出账流水号
    ,pay_ser_num -- 支付序列号
    ,plat_req_flow_num -- 平台请求流水号
    ,plat_tran_flow_num -- 平台交易流水号
    ,plat_tran_dt -- 平台交易日期
    ,core_flow_num -- 核心流水号
    ,dtl_flow_num -- 明细流水号
    ,ghb_cust_flg -- 本行客户标志
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,mode_pay_cd -- 支付方式代码
    ,pay_dt -- 支付日期
    ,actl_pay_dt -- 实际支付日期
    ,pay_tm -- 支付时间
    ,tran_in_bank_name -- 转入行名称
    ,recver_name -- 收款人名称
    ,recver_open_bank_name -- 收款人开户行名称
    ,recvbl_acct_id -- 收款账户编号
    ,recver_addr -- 收款人地址
    ,curr_cd -- 币种代码
    ,pay_amt -- 支付金额
    ,pay_status_cd -- 支付状态代码
    ,cap_usage_descb -- 资金用途描述
    ,precon_entr_pay_flg -- 预约受托支付标志
    ,entr_pay_id -- 受托支付编号
    ,entr_pay_batch_no -- 受托支付批次号
    ,entr_pay_seq_num -- 受托支付序号
    ,entr_pay_tot_id -- 受托支付汇总编号
    ,onl_entr_pay_status_cd -- 在线受托支付状态代码
    ,onl_entred_init_tran_plat_flow_num -- 在线受托原交易平台流水号
    ,onl_entred_stop_pay_tran_flow_num -- 在线受托止付交易流水号
    ,stop_pay_flow_num -- 止付流水号
    ,stop_pay_tran_dt -- 止付交易日期
    ,froz_flow_num -- 冻结流水号
    ,a_send_tm -- 重新发送时间
    ,pay_fail_rs_descb -- 支付失败原因描述
    ,bank_int_acct_flg -- 行内账户标志
    ,repeat_status_cd -- 重发状态代码
    ,cfm_status_cd -- 确认状态代码
    ,move_flg -- 迁移标志
    ,latest_pay_dt -- 最迟支付日期
    ,matn_idf_cd -- 维护标识代码
    ,cross_bor_flg -- 跨境标志
    ,loan_usage_descb -- 贷款用途描述
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_entr_pay_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,pay_flow_num -- 支付流水号
    ,out_acct_flow_num -- 出账流水号
    ,pay_ser_num -- 支付序列号
    ,plat_req_flow_num -- 平台请求流水号
    ,plat_tran_flow_num -- 平台交易流水号
    ,plat_tran_dt -- 平台交易日期
    ,core_flow_num -- 核心流水号
    ,dtl_flow_num -- 明细流水号
    ,ghb_cust_flg -- 本行客户标志
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,mode_pay_cd -- 支付方式代码
    ,pay_dt -- 支付日期
    ,actl_pay_dt -- 实际支付日期
    ,pay_tm -- 支付时间
    ,tran_in_bank_name -- 转入行名称
    ,recver_name -- 收款人名称
    ,recver_open_bank_name -- 收款人开户行名称
    ,recvbl_acct_id -- 收款账户编号
    ,recver_addr -- 收款人地址
    ,curr_cd -- 币种代码
    ,pay_amt -- 支付金额
    ,pay_status_cd -- 支付状态代码
    ,cap_usage_descb -- 资金用途描述
    ,precon_entr_pay_flg -- 预约受托支付标志
    ,entr_pay_id -- 受托支付编号
    ,entr_pay_batch_no -- 受托支付批次号
    ,entr_pay_seq_num -- 受托支付序号
    ,entr_pay_tot_id -- 受托支付汇总编号
    ,onl_entr_pay_status_cd -- 在线受托支付状态代码
    ,onl_entred_init_tran_plat_flow_num -- 在线受托原交易平台流水号
    ,onl_entred_stop_pay_tran_flow_num -- 在线受托止付交易流水号
    ,stop_pay_flow_num -- 止付流水号
    ,stop_pay_tran_dt -- 止付交易日期
    ,froz_flow_num -- 冻结流水号
    ,a_send_tm -- 重新发送时间
    ,pay_fail_rs_descb -- 支付失败原因描述
    ,bank_int_acct_flg -- 行内账户标志
    ,repeat_status_cd -- 重发状态代码
    ,cfm_status_cd -- 确认状态代码
    ,move_flg -- 迁移标志
    ,latest_pay_dt -- 最迟支付日期
    ,matn_idf_cd -- 维护标识代码
    ,cross_bor_flg -- 跨境标志
    ,loan_usage_descb -- 贷款用途描述
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
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
    ,nvl(n.pay_flow_num, o.pay_flow_num) as pay_flow_num -- 支付流水号
    ,nvl(n.out_acct_flow_num, o.out_acct_flow_num) as out_acct_flow_num -- 出账流水号
    ,nvl(n.pay_ser_num, o.pay_ser_num) as pay_ser_num -- 支付序列号
    ,nvl(n.plat_req_flow_num, o.plat_req_flow_num) as plat_req_flow_num -- 平台请求流水号
    ,nvl(n.plat_tran_flow_num, o.plat_tran_flow_num) as plat_tran_flow_num -- 平台交易流水号
    ,nvl(n.plat_tran_dt, o.plat_tran_dt) as plat_tran_dt -- 平台交易日期
    ,nvl(n.core_flow_num, o.core_flow_num) as core_flow_num -- 核心流水号
    ,nvl(n.dtl_flow_num, o.dtl_flow_num) as dtl_flow_num -- 明细流水号
    ,nvl(n.ghb_cust_flg, o.ghb_cust_flg) as ghb_cust_flg -- 本行客户标志
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.mode_pay_cd, o.mode_pay_cd) as mode_pay_cd -- 支付方式代码
    ,nvl(n.pay_dt, o.pay_dt) as pay_dt -- 支付日期
    ,nvl(n.actl_pay_dt, o.actl_pay_dt) as actl_pay_dt -- 实际支付日期
    ,nvl(n.pay_tm, o.pay_tm) as pay_tm -- 支付时间
    ,nvl(n.tran_in_bank_name, o.tran_in_bank_name) as tran_in_bank_name -- 转入行名称
    ,nvl(n.recver_name, o.recver_name) as recver_name -- 收款人名称
    ,nvl(n.recver_open_bank_name, o.recver_open_bank_name) as recver_open_bank_name -- 收款人开户行名称
    ,nvl(n.recvbl_acct_id, o.recvbl_acct_id) as recvbl_acct_id -- 收款账户编号
    ,nvl(n.recver_addr, o.recver_addr) as recver_addr -- 收款人地址
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.pay_amt, o.pay_amt) as pay_amt -- 支付金额
    ,nvl(n.pay_status_cd, o.pay_status_cd) as pay_status_cd -- 支付状态代码
    ,nvl(n.cap_usage_descb, o.cap_usage_descb) as cap_usage_descb -- 资金用途描述
    ,nvl(n.precon_entr_pay_flg, o.precon_entr_pay_flg) as precon_entr_pay_flg -- 预约受托支付标志
    ,nvl(n.entr_pay_id, o.entr_pay_id) as entr_pay_id -- 受托支付编号
    ,nvl(n.entr_pay_batch_no, o.entr_pay_batch_no) as entr_pay_batch_no -- 受托支付批次号
    ,nvl(n.entr_pay_seq_num, o.entr_pay_seq_num) as entr_pay_seq_num -- 受托支付序号
    ,nvl(n.entr_pay_tot_id, o.entr_pay_tot_id) as entr_pay_tot_id -- 受托支付汇总编号
    ,nvl(n.onl_entr_pay_status_cd, o.onl_entr_pay_status_cd) as onl_entr_pay_status_cd -- 在线受托支付状态代码
    ,nvl(n.onl_entred_init_tran_plat_flow_num, o.onl_entred_init_tran_plat_flow_num) as onl_entred_init_tran_plat_flow_num -- 在线受托原交易平台流水号
    ,nvl(n.onl_entred_stop_pay_tran_flow_num, o.onl_entred_stop_pay_tran_flow_num) as onl_entred_stop_pay_tran_flow_num -- 在线受托止付交易流水号
    ,nvl(n.stop_pay_flow_num, o.stop_pay_flow_num) as stop_pay_flow_num -- 止付流水号
    ,nvl(n.stop_pay_tran_dt, o.stop_pay_tran_dt) as stop_pay_tran_dt -- 止付交易日期
    ,nvl(n.froz_flow_num, o.froz_flow_num) as froz_flow_num -- 冻结流水号
    ,nvl(n.a_send_tm, o.a_send_tm) as a_send_tm -- 重新发送时间
    ,nvl(n.pay_fail_rs_descb, o.pay_fail_rs_descb) as pay_fail_rs_descb -- 支付失败原因描述
    ,nvl(n.bank_int_acct_flg, o.bank_int_acct_flg) as bank_int_acct_flg -- 行内账户标志
    ,nvl(n.repeat_status_cd, o.repeat_status_cd) as repeat_status_cd -- 重发状态代码
    ,nvl(n.cfm_status_cd, o.cfm_status_cd) as cfm_status_cd -- 确认状态代码
    ,nvl(n.move_flg, o.move_flg) as move_flg -- 迁移标志
    ,nvl(n.latest_pay_dt, o.latest_pay_dt) as latest_pay_dt -- 最迟支付日期
    ,nvl(n.matn_idf_cd, o.matn_idf_cd) as matn_idf_cd -- 维护标识代码
    ,nvl(n.cross_bor_flg, o.cross_bor_flg) as cross_bor_flg -- 跨境标志
    ,nvl(n.loan_usage_descb, o.loan_usage_descb) as loan_usage_descb -- 贷款用途描述
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.modif_dt, o.modif_dt) as modif_dt -- 变更日期
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.pay_flow_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.pay_flow_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.pay_flow_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_entr_pay_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_entr_pay_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.pay_flow_num = n.pay_flow_num
where (
        o.agt_id is null
        and o.lp_id is null
        and o.pay_flow_num is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.pay_flow_num is null
    )
    or (
        o.out_acct_flow_num <> n.out_acct_flow_num
        or o.pay_ser_num <> n.pay_ser_num
        or o.plat_req_flow_num <> n.plat_req_flow_num
        or o.plat_tran_flow_num <> n.plat_tran_flow_num
        or o.plat_tran_dt <> n.plat_tran_dt
        or o.core_flow_num <> n.core_flow_num
        or o.dtl_flow_num <> n.dtl_flow_num
        or o.ghb_cust_flg <> n.ghb_cust_flg
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.mode_pay_cd <> n.mode_pay_cd
        or o.pay_dt <> n.pay_dt
        or o.actl_pay_dt <> n.actl_pay_dt
        or o.pay_tm <> n.pay_tm
        or o.tran_in_bank_name <> n.tran_in_bank_name
        or o.recver_name <> n.recver_name
        or o.recver_open_bank_name <> n.recver_open_bank_name
        or o.recvbl_acct_id <> n.recvbl_acct_id
        or o.recver_addr <> n.recver_addr
        or o.curr_cd <> n.curr_cd
        or o.pay_amt <> n.pay_amt
        or o.pay_status_cd <> n.pay_status_cd
        or o.cap_usage_descb <> n.cap_usage_descb
        or o.precon_entr_pay_flg <> n.precon_entr_pay_flg
        or o.entr_pay_id <> n.entr_pay_id
        or o.entr_pay_batch_no <> n.entr_pay_batch_no
        or o.entr_pay_seq_num <> n.entr_pay_seq_num
        or o.entr_pay_tot_id <> n.entr_pay_tot_id
        or o.onl_entr_pay_status_cd <> n.onl_entr_pay_status_cd
        or o.onl_entred_init_tran_plat_flow_num <> n.onl_entred_init_tran_plat_flow_num
        or o.onl_entred_stop_pay_tran_flow_num <> n.onl_entred_stop_pay_tran_flow_num
        or o.stop_pay_flow_num <> n.stop_pay_flow_num
        or o.stop_pay_tran_dt <> n.stop_pay_tran_dt
        or o.froz_flow_num <> n.froz_flow_num
        or o.a_send_tm <> n.a_send_tm
        or o.pay_fail_rs_descb <> n.pay_fail_rs_descb
        or o.bank_int_acct_flg <> n.bank_int_acct_flg
        or o.repeat_status_cd <> n.repeat_status_cd
        or o.cfm_status_cd <> n.cfm_status_cd
        or o.move_flg <> n.move_flg
        or o.latest_pay_dt <> n.latest_pay_dt
        or o.matn_idf_cd <> n.matn_idf_cd
        or o.cross_bor_flg <> n.cross_bor_flg
        or o.loan_usage_descb <> n.loan_usage_descb
        or o.remark <> n.remark
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.modif_dt <> n.modif_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_entr_pay_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,pay_flow_num -- 支付流水号
    ,out_acct_flow_num -- 出账流水号
    ,pay_ser_num -- 支付序列号
    ,plat_req_flow_num -- 平台请求流水号
    ,plat_tran_flow_num -- 平台交易流水号
    ,plat_tran_dt -- 平台交易日期
    ,core_flow_num -- 核心流水号
    ,dtl_flow_num -- 明细流水号
    ,ghb_cust_flg -- 本行客户标志
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,mode_pay_cd -- 支付方式代码
    ,pay_dt -- 支付日期
    ,actl_pay_dt -- 实际支付日期
    ,pay_tm -- 支付时间
    ,tran_in_bank_name -- 转入行名称
    ,recver_name -- 收款人名称
    ,recver_open_bank_name -- 收款人开户行名称
    ,recvbl_acct_id -- 收款账户编号
    ,recver_addr -- 收款人地址
    ,curr_cd -- 币种代码
    ,pay_amt -- 支付金额
    ,pay_status_cd -- 支付状态代码
    ,cap_usage_descb -- 资金用途描述
    ,precon_entr_pay_flg -- 预约受托支付标志
    ,entr_pay_id -- 受托支付编号
    ,entr_pay_batch_no -- 受托支付批次号
    ,entr_pay_seq_num -- 受托支付序号
    ,entr_pay_tot_id -- 受托支付汇总编号
    ,onl_entr_pay_status_cd -- 在线受托支付状态代码
    ,onl_entred_init_tran_plat_flow_num -- 在线受托原交易平台流水号
    ,onl_entred_stop_pay_tran_flow_num -- 在线受托止付交易流水号
    ,stop_pay_flow_num -- 止付流水号
    ,stop_pay_tran_dt -- 止付交易日期
    ,froz_flow_num -- 冻结流水号
    ,a_send_tm -- 重新发送时间
    ,pay_fail_rs_descb -- 支付失败原因描述
    ,bank_int_acct_flg -- 行内账户标志
    ,repeat_status_cd -- 重发状态代码
    ,cfm_status_cd -- 确认状态代码
    ,move_flg -- 迁移标志
    ,latest_pay_dt -- 最迟支付日期
    ,matn_idf_cd -- 维护标识代码
    ,cross_bor_flg -- 跨境标志
    ,loan_usage_descb -- 贷款用途描述
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_entr_pay_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,pay_flow_num -- 支付流水号
    ,out_acct_flow_num -- 出账流水号
    ,pay_ser_num -- 支付序列号
    ,plat_req_flow_num -- 平台请求流水号
    ,plat_tran_flow_num -- 平台交易流水号
    ,plat_tran_dt -- 平台交易日期
    ,core_flow_num -- 核心流水号
    ,dtl_flow_num -- 明细流水号
    ,ghb_cust_flg -- 本行客户标志
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,mode_pay_cd -- 支付方式代码
    ,pay_dt -- 支付日期
    ,actl_pay_dt -- 实际支付日期
    ,pay_tm -- 支付时间
    ,tran_in_bank_name -- 转入行名称
    ,recver_name -- 收款人名称
    ,recver_open_bank_name -- 收款人开户行名称
    ,recvbl_acct_id -- 收款账户编号
    ,recver_addr -- 收款人地址
    ,curr_cd -- 币种代码
    ,pay_amt -- 支付金额
    ,pay_status_cd -- 支付状态代码
    ,cap_usage_descb -- 资金用途描述
    ,precon_entr_pay_flg -- 预约受托支付标志
    ,entr_pay_id -- 受托支付编号
    ,entr_pay_batch_no -- 受托支付批次号
    ,entr_pay_seq_num -- 受托支付序号
    ,entr_pay_tot_id -- 受托支付汇总编号
    ,onl_entr_pay_status_cd -- 在线受托支付状态代码
    ,onl_entred_init_tran_plat_flow_num -- 在线受托原交易平台流水号
    ,onl_entred_stop_pay_tran_flow_num -- 在线受托止付交易流水号
    ,stop_pay_flow_num -- 止付流水号
    ,stop_pay_tran_dt -- 止付交易日期
    ,froz_flow_num -- 冻结流水号
    ,a_send_tm -- 重新发送时间
    ,pay_fail_rs_descb -- 支付失败原因描述
    ,bank_int_acct_flg -- 行内账户标志
    ,repeat_status_cd -- 重发状态代码
    ,cfm_status_cd -- 确认状态代码
    ,move_flg -- 迁移标志
    ,latest_pay_dt -- 最迟支付日期
    ,matn_idf_cd -- 维护标识代码
    ,cross_bor_flg -- 跨境标志
    ,loan_usage_descb -- 贷款用途描述
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
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
    ,o.pay_flow_num -- 支付流水号
    ,o.out_acct_flow_num -- 出账流水号
    ,o.pay_ser_num -- 支付序列号
    ,o.plat_req_flow_num -- 平台请求流水号
    ,o.plat_tran_flow_num -- 平台交易流水号
    ,o.plat_tran_dt -- 平台交易日期
    ,o.core_flow_num -- 核心流水号
    ,o.dtl_flow_num -- 明细流水号
    ,o.ghb_cust_flg -- 本行客户标志
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.mode_pay_cd -- 支付方式代码
    ,o.pay_dt -- 支付日期
    ,o.actl_pay_dt -- 实际支付日期
    ,o.pay_tm -- 支付时间
    ,o.tran_in_bank_name -- 转入行名称
    ,o.recver_name -- 收款人名称
    ,o.recver_open_bank_name -- 收款人开户行名称
    ,o.recvbl_acct_id -- 收款账户编号
    ,o.recver_addr -- 收款人地址
    ,o.curr_cd -- 币种代码
    ,o.pay_amt -- 支付金额
    ,o.pay_status_cd -- 支付状态代码
    ,o.cap_usage_descb -- 资金用途描述
    ,o.precon_entr_pay_flg -- 预约受托支付标志
    ,o.entr_pay_id -- 受托支付编号
    ,o.entr_pay_batch_no -- 受托支付批次号
    ,o.entr_pay_seq_num -- 受托支付序号
    ,o.entr_pay_tot_id -- 受托支付汇总编号
    ,o.onl_entr_pay_status_cd -- 在线受托支付状态代码
    ,o.onl_entred_init_tran_plat_flow_num -- 在线受托原交易平台流水号
    ,o.onl_entred_stop_pay_tran_flow_num -- 在线受托止付交易流水号
    ,o.stop_pay_flow_num -- 止付流水号
    ,o.stop_pay_tran_dt -- 止付交易日期
    ,o.froz_flow_num -- 冻结流水号
    ,o.a_send_tm -- 重新发送时间
    ,o.pay_fail_rs_descb -- 支付失败原因描述
    ,o.bank_int_acct_flg -- 行内账户标志
    ,o.repeat_status_cd -- 重发状态代码
    ,o.cfm_status_cd -- 确认状态代码
    ,o.move_flg -- 迁移标志
    ,o.latest_pay_dt -- 最迟支付日期
    ,o.matn_idf_cd -- 维护标识代码
    ,o.cross_bor_flg -- 跨境标志
    ,o.loan_usage_descb -- 贷款用途描述
    ,o.remark -- 备注
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
    ,o.modif_dt -- 变更日期
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
from ${iml_schema}.agt_entr_pay_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_entr_pay_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.pay_flow_num = n.pay_flow_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_entr_pay_info_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.pay_flow_num = d.pay_flow_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_entr_pay_info_h;
--alter table ${iml_schema}.agt_entr_pay_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_entr_pay_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_entr_pay_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_entr_pay_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_entr_pay_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_entr_pay_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_entr_pay_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_entr_pay_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_entr_pay_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_entr_pay_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_entr_pay_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_entr_pay_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_entr_pay_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_entr_pay_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
