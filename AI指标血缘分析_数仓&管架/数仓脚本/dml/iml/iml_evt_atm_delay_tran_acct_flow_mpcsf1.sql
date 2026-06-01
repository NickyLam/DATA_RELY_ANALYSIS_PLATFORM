/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_atm_delay_tran_acct_flow_mpcsf1
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
alter table ${iml_schema}.evt_atm_delay_tran_acct_flow add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mpcsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_atm_delay_tran_acct_flow_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_atm_delay_tran_acct_flow partition for ('mpcsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_atm_delay_tran_acct_flow_mpcsf1_tm purge;
drop table ${iml_schema}.evt_atm_delay_tran_acct_flow_mpcsf1_op purge;
drop table ${iml_schema}.evt_atm_delay_tran_acct_flow_mpcsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_atm_delay_tran_acct_flow_mpcsf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,main_acct_id -- 主账户编号
    ,sys_follow_id -- 系统跟踪编号
    ,rsrv_mobile_no -- 预留手机号
    ,curr_cd -- 币种代码
    ,unionpay_curr_cd -- 银联币种代码
    ,tran_flow_num -- 交易流水号
    ,midgrod_tran_dt -- 中台交易日期
    ,tran_dt -- 交易日期
    ,tran_cd -- 交易代码
    ,tran_type_cd -- 交易类型代码
    ,tran_status_cd -- 交易状态代码
    ,tran_amt -- 交易金额
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,ova_flow_num -- 全局流水号
    ,bus_flow_num -- 业务流水号
    ,ghb_dtran_acct_fail_ag_cnt -- 本行延时转账失败重试次数
    ,delay_tran_acct_rest_cd -- 延时转账处理结果代码
    ,fee_type_cd -- 费用类型代码
    ,comm_fee -- 手续费
    ,clear_amt -- 清算金额
    ,tran_out_acct_id -- 转出账户编号
    ,tran_out_acct_name -- 转出账户名称
    ,tran_in_acct_id -- 转入账户编号
    ,tran_in_acct_name -- 转入账户名称
    ,open_acct_org_id -- 开户机构编号
    ,proc_org_id -- 受理机构编号
    ,send_org_id -- 发送机构编号
    ,core_froz_flow_num -- 核心冻结流水号
    ,core_froz_dt -- 核心冻结日期
    ,core_deduct_flow_num -- 核心扣款流水号
    ,core_deduct_dt -- 核心扣款日期
    ,core_memo_code -- 核心摘要码
    ,core_intfc_code -- 核心接口码
    ,aldy_adj_entry_flg -- 已调账标志
    ,err_cd -- 错误码
    ,err_info -- 错误信息
    ,sorc_sys_cd -- 源系统代码
    ,pass_id -- 通道编号
    ,mercht_type_cd -- 商户类型代码
    ,proc_mercht_id -- 受理商户编号
    ,proc_mercht_name -- 受理商户名称
    ,init_sys_follow_id -- 原系统跟踪编号
    ,init_ova_flow_num -- 原全局流水号
    ,init_bus_flow_num -- 原业务流水号
    ,init_tran_tm -- 原交易时间
    ,init_tran_flow_num -- 原交易流水号
    ,init_proc_org_id -- 原受理机构编号
    ,init_send_org_id -- 原发送机构编号
    ,equip_id -- 设备号
    ,remark -- 备注
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_atm_delay_tran_acct_flow partition for ('mpcsf1')
where 0=1
;

create table ${iml_schema}.evt_atm_delay_tran_acct_flow_mpcsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_atm_delay_tran_acct_flow partition for ('mpcsf1') where 0=1;

create table ${iml_schema}.evt_atm_delay_tran_acct_flow_mpcsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_atm_delay_tran_acct_flow partition for ('mpcsf1') where 0=1;

-- 3.1 get new data into table
-- mpcs_a50tatmtfrtrace-1
insert into ${iml_schema}.evt_atm_delay_tran_acct_flow_mpcsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,main_acct_id -- 主账户编号
    ,sys_follow_id -- 系统跟踪编号
    ,rsrv_mobile_no -- 预留手机号
    ,curr_cd -- 币种代码
    ,unionpay_curr_cd -- 银联币种代码
    ,tran_flow_num -- 交易流水号
    ,midgrod_tran_dt -- 中台交易日期
    ,tran_dt -- 交易日期
    ,tran_cd -- 交易代码
    ,tran_type_cd -- 交易类型代码
    ,tran_status_cd -- 交易状态代码
    ,tran_amt -- 交易金额
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,ova_flow_num -- 全局流水号
    ,bus_flow_num -- 业务流水号
    ,ghb_dtran_acct_fail_ag_cnt -- 本行延时转账失败重试次数
    ,delay_tran_acct_rest_cd -- 延时转账处理结果代码
    ,fee_type_cd -- 费用类型代码
    ,comm_fee -- 手续费
    ,clear_amt -- 清算金额
    ,tran_out_acct_id -- 转出账户编号
    ,tran_out_acct_name -- 转出账户名称
    ,tran_in_acct_id -- 转入账户编号
    ,tran_in_acct_name -- 转入账户名称
    ,open_acct_org_id -- 开户机构编号
    ,proc_org_id -- 受理机构编号
    ,send_org_id -- 发送机构编号
    ,core_froz_flow_num -- 核心冻结流水号
    ,core_froz_dt -- 核心冻结日期
    ,core_deduct_flow_num -- 核心扣款流水号
    ,core_deduct_dt -- 核心扣款日期
    ,core_memo_code -- 核心摘要码
    ,core_intfc_code -- 核心接口码
    ,aldy_adj_entry_flg -- 已调账标志
    ,err_cd -- 错误码
    ,err_info -- 错误信息
    ,sorc_sys_cd -- 源系统代码
    ,pass_id -- 通道编号
    ,mercht_type_cd -- 商户类型代码
    ,proc_mercht_id -- 受理商户编号
    ,proc_mercht_name -- 受理商户名称
    ,init_sys_follow_id -- 原系统跟踪编号
    ,init_ova_flow_num -- 原全局流水号
    ,init_bus_flow_num -- 原业务流水号
    ,init_tran_tm -- 原交易时间
    ,init_tran_flow_num -- 原交易流水号
    ,init_proc_org_id -- 原受理机构编号
    ,init_send_org_id -- 原发送机构编号
    ,equip_id -- 设备号
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401037'||P1.PRIACCT||P1.SYSTRACE||P1.TRANSTIME -- 事件编号
    ,'9999' -- 法人编号
    ,P1.PRIACCT -- 主账户编号
    ,P1.SYSTRACE -- 系统跟踪编号
    ,P1.MOBILE -- 预留手机号
    ,nvl(trim(P1.CCYNBR),'CNY') -- 币种代码
    ,decode(P1.CCYNBR,'156','CNY',' ','-',P1.CCYNBR) -- 银联币种代码
    ,P1.TRN_SEQ -- 交易流水号
    ,${iml_schema}.dateformat_max2(P1.ZTTRANSDATE) -- 中台交易日期
    ,${iml_schema}.dateformat_max2(P1.TRANSDATE||substr(P1.TRANSTIME,5)) -- 交易日期
    ,P1.TRANSCODE -- 交易代码
    ,nvl(trim(P1.TRANSTP),'-') -- 交易类型代码
    ,nvl(trim(P1.STATUS),'U') -- 交易状态代码
    ,P1.TRANSAMT -- 交易金额
    ,P1.TLRNO -- 交易柜员编号
    ,P1.BRCNO -- 交易机构编号
    ,P1.GLOBAL_SEQ -- 全局流水号
    ,P1.BUSI_SEQ -- 业务流水号
    ,to_number(nvl(trim(P1.REMARK2),0)) -- 本行延时转账失败重试次数
    ,nvl(trim(P1.YLSTATUS),'U') -- 延时转账处理结果代码
    ,nvl(trim(P1.FEE_TYPE),'-') -- 费用类型代码
    ,P1.FEE -- 手续费
    ,P1.SETTLMTAMT -- 清算金额
    ,P1.OUTACCTNBR -- 转出账户编号
    ,P1.ACCTNAME -- 转出账户名称
    ,P1.INACCTNBR -- 转入账户编号
    ,P1.REMARK3 -- 转入账户名称
    ,P1.PBOCELEM -- 开户机构编号
    ,P1.ACQINSTID -- 受理机构编号
    ,P1.FWDINSTID -- 发送机构编号
    ,P1.HOSTNBR -- 核心冻结流水号
    ,${iml_schema}.dateformat_max2(P1.HOSTDATE) -- 核心冻结日期
    ,P1.DELAYHOSTNBR -- 核心扣款流水号
    ,${iml_schema}.dateformat_max2(P1.DELAYDATE||P1.DELAYTIME) -- 核心扣款日期
    ,nvl(trim(P1.MEMO_CD),'-') -- 核心摘要码
    ,P1.DSTTRNCD -- 核心接口码
    ,decode(P1.REMARK1,'1','1',' ','0',P1.REMARK1) -- 已调账标志
    ,P1.ERRCODE -- 错误码
    ,P1.ERRMSG -- 错误信息
    ,nvl(trim(P1.SERVTP),'-') -- 源系统代码
    ,P1.CHANNELS -- 通道编号
    ,nvl(trim(P1.MCHNTTYPE),'-') -- 商户类型代码
    ,P1.ACCPTRID -- 受理商户编号
    ,P1.ACCTTRNMLC -- 受理商户名称
    ,P1.OLDSYSTRACE -- 原系统跟踪编号
    ,P1.OLD_GLOBAL_SEQ -- 原全局流水号
    ,P1.OLD_BUSI_SEQ -- 原业务流水号
    ,P1.OLDTRANSTIME -- 原交易时间
    ,P1.OLD_TRN_SEQ -- 原交易流水号
    ,P1.OLDACQINSTID -- 原受理机构编号
    ,P1.OLDFWDINSTID -- 原发送机构编号
    ,P1.DEVNBR -- 设备号
    ,P1.MSGFILL -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a50tatmtfrtrace' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a50tatmtfrtrace p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_atm_delay_tran_acct_flow_mpcsf1_tm 
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
        into ${iml_schema}.evt_atm_delay_tran_acct_flow_mpcsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,main_acct_id -- 主账户编号
    ,sys_follow_id -- 系统跟踪编号
    ,rsrv_mobile_no -- 预留手机号
    ,curr_cd -- 币种代码
    ,unionpay_curr_cd -- 银联币种代码
    ,tran_flow_num -- 交易流水号
    ,midgrod_tran_dt -- 中台交易日期
    ,tran_dt -- 交易日期
    ,tran_cd -- 交易代码
    ,tran_type_cd -- 交易类型代码
    ,tran_status_cd -- 交易状态代码
    ,tran_amt -- 交易金额
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,ova_flow_num -- 全局流水号
    ,bus_flow_num -- 业务流水号
    ,ghb_dtran_acct_fail_ag_cnt -- 本行延时转账失败重试次数
    ,delay_tran_acct_rest_cd -- 延时转账处理结果代码
    ,fee_type_cd -- 费用类型代码
    ,comm_fee -- 手续费
    ,clear_amt -- 清算金额
    ,tran_out_acct_id -- 转出账户编号
    ,tran_out_acct_name -- 转出账户名称
    ,tran_in_acct_id -- 转入账户编号
    ,tran_in_acct_name -- 转入账户名称
    ,open_acct_org_id -- 开户机构编号
    ,proc_org_id -- 受理机构编号
    ,send_org_id -- 发送机构编号
    ,core_froz_flow_num -- 核心冻结流水号
    ,core_froz_dt -- 核心冻结日期
    ,core_deduct_flow_num -- 核心扣款流水号
    ,core_deduct_dt -- 核心扣款日期
    ,core_memo_code -- 核心摘要码
    ,core_intfc_code -- 核心接口码
    ,aldy_adj_entry_flg -- 已调账标志
    ,err_cd -- 错误码
    ,err_info -- 错误信息
    ,sorc_sys_cd -- 源系统代码
    ,pass_id -- 通道编号
    ,mercht_type_cd -- 商户类型代码
    ,proc_mercht_id -- 受理商户编号
    ,proc_mercht_name -- 受理商户名称
    ,init_sys_follow_id -- 原系统跟踪编号
    ,init_ova_flow_num -- 原全局流水号
    ,init_bus_flow_num -- 原业务流水号
    ,init_tran_tm -- 原交易时间
    ,init_tran_flow_num -- 原交易流水号
    ,init_proc_org_id -- 原受理机构编号
    ,init_send_org_id -- 原发送机构编号
    ,equip_id -- 设备号
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_atm_delay_tran_acct_flow_mpcsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,main_acct_id -- 主账户编号
    ,sys_follow_id -- 系统跟踪编号
    ,rsrv_mobile_no -- 预留手机号
    ,curr_cd -- 币种代码
    ,unionpay_curr_cd -- 银联币种代码
    ,tran_flow_num -- 交易流水号
    ,midgrod_tran_dt -- 中台交易日期
    ,tran_dt -- 交易日期
    ,tran_cd -- 交易代码
    ,tran_type_cd -- 交易类型代码
    ,tran_status_cd -- 交易状态代码
    ,tran_amt -- 交易金额
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,ova_flow_num -- 全局流水号
    ,bus_flow_num -- 业务流水号
    ,ghb_dtran_acct_fail_ag_cnt -- 本行延时转账失败重试次数
    ,delay_tran_acct_rest_cd -- 延时转账处理结果代码
    ,fee_type_cd -- 费用类型代码
    ,comm_fee -- 手续费
    ,clear_amt -- 清算金额
    ,tran_out_acct_id -- 转出账户编号
    ,tran_out_acct_name -- 转出账户名称
    ,tran_in_acct_id -- 转入账户编号
    ,tran_in_acct_name -- 转入账户名称
    ,open_acct_org_id -- 开户机构编号
    ,proc_org_id -- 受理机构编号
    ,send_org_id -- 发送机构编号
    ,core_froz_flow_num -- 核心冻结流水号
    ,core_froz_dt -- 核心冻结日期
    ,core_deduct_flow_num -- 核心扣款流水号
    ,core_deduct_dt -- 核心扣款日期
    ,core_memo_code -- 核心摘要码
    ,core_intfc_code -- 核心接口码
    ,aldy_adj_entry_flg -- 已调账标志
    ,err_cd -- 错误码
    ,err_info -- 错误信息
    ,sorc_sys_cd -- 源系统代码
    ,pass_id -- 通道编号
    ,mercht_type_cd -- 商户类型代码
    ,proc_mercht_id -- 受理商户编号
    ,proc_mercht_name -- 受理商户名称
    ,init_sys_follow_id -- 原系统跟踪编号
    ,init_ova_flow_num -- 原全局流水号
    ,init_bus_flow_num -- 原业务流水号
    ,init_tran_tm -- 原交易时间
    ,init_tran_flow_num -- 原交易流水号
    ,init_proc_org_id -- 原受理机构编号
    ,init_send_org_id -- 原发送机构编号
    ,equip_id -- 设备号
    ,remark -- 备注
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
    ,nvl(n.main_acct_id, o.main_acct_id) as main_acct_id -- 主账户编号
    ,nvl(n.sys_follow_id, o.sys_follow_id) as sys_follow_id -- 系统跟踪编号
    ,nvl(n.rsrv_mobile_no, o.rsrv_mobile_no) as rsrv_mobile_no -- 预留手机号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.unionpay_curr_cd, o.unionpay_curr_cd) as unionpay_curr_cd -- 银联币种代码
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,nvl(n.midgrod_tran_dt, o.midgrod_tran_dt) as midgrod_tran_dt -- 中台交易日期
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.tran_cd, o.tran_cd) as tran_cd -- 交易代码
    ,nvl(n.tran_type_cd, o.tran_type_cd) as tran_type_cd -- 交易类型代码
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.ova_flow_num, o.ova_flow_num) as ova_flow_num -- 全局流水号
    ,nvl(n.bus_flow_num, o.bus_flow_num) as bus_flow_num -- 业务流水号
    ,nvl(n.ghb_dtran_acct_fail_ag_cnt, o.ghb_dtran_acct_fail_ag_cnt) as ghb_dtran_acct_fail_ag_cnt -- 本行延时转账失败重试次数
    ,nvl(n.delay_tran_acct_rest_cd, o.delay_tran_acct_rest_cd) as delay_tran_acct_rest_cd -- 延时转账处理结果代码
    ,nvl(n.fee_type_cd, o.fee_type_cd) as fee_type_cd -- 费用类型代码
    ,nvl(n.comm_fee, o.comm_fee) as comm_fee -- 手续费
    ,nvl(n.clear_amt, o.clear_amt) as clear_amt -- 清算金额
    ,nvl(n.tran_out_acct_id, o.tran_out_acct_id) as tran_out_acct_id -- 转出账户编号
    ,nvl(n.tran_out_acct_name, o.tran_out_acct_name) as tran_out_acct_name -- 转出账户名称
    ,nvl(n.tran_in_acct_id, o.tran_in_acct_id) as tran_in_acct_id -- 转入账户编号
    ,nvl(n.tran_in_acct_name, o.tran_in_acct_name) as tran_in_acct_name -- 转入账户名称
    ,nvl(n.open_acct_org_id, o.open_acct_org_id) as open_acct_org_id -- 开户机构编号
    ,nvl(n.proc_org_id, o.proc_org_id) as proc_org_id -- 受理机构编号
    ,nvl(n.send_org_id, o.send_org_id) as send_org_id -- 发送机构编号
    ,nvl(n.core_froz_flow_num, o.core_froz_flow_num) as core_froz_flow_num -- 核心冻结流水号
    ,nvl(n.core_froz_dt, o.core_froz_dt) as core_froz_dt -- 核心冻结日期
    ,nvl(n.core_deduct_flow_num, o.core_deduct_flow_num) as core_deduct_flow_num -- 核心扣款流水号
    ,nvl(n.core_deduct_dt, o.core_deduct_dt) as core_deduct_dt -- 核心扣款日期
    ,nvl(n.core_memo_code, o.core_memo_code) as core_memo_code -- 核心摘要码
    ,nvl(n.core_intfc_code, o.core_intfc_code) as core_intfc_code -- 核心接口码
    ,nvl(n.aldy_adj_entry_flg, o.aldy_adj_entry_flg) as aldy_adj_entry_flg -- 已调账标志
    ,nvl(n.err_cd, o.err_cd) as err_cd -- 错误码
    ,nvl(n.err_info, o.err_info) as err_info -- 错误信息
    ,nvl(n.sorc_sys_cd, o.sorc_sys_cd) as sorc_sys_cd -- 源系统代码
    ,nvl(n.pass_id, o.pass_id) as pass_id -- 通道编号
    ,nvl(n.mercht_type_cd, o.mercht_type_cd) as mercht_type_cd -- 商户类型代码
    ,nvl(n.proc_mercht_id, o.proc_mercht_id) as proc_mercht_id -- 受理商户编号
    ,nvl(n.proc_mercht_name, o.proc_mercht_name) as proc_mercht_name -- 受理商户名称
    ,nvl(n.init_sys_follow_id, o.init_sys_follow_id) as init_sys_follow_id -- 原系统跟踪编号
    ,nvl(n.init_ova_flow_num, o.init_ova_flow_num) as init_ova_flow_num -- 原全局流水号
    ,nvl(n.init_bus_flow_num, o.init_bus_flow_num) as init_bus_flow_num -- 原业务流水号
    ,nvl(n.init_tran_tm, o.init_tran_tm) as init_tran_tm -- 原交易时间
    ,nvl(n.init_tran_flow_num, o.init_tran_flow_num) as init_tran_flow_num -- 原交易流水号
    ,nvl(n.init_proc_org_id, o.init_proc_org_id) as init_proc_org_id -- 原受理机构编号
    ,nvl(n.init_send_org_id, o.init_send_org_id) as init_send_org_id -- 原发送机构编号
    ,nvl(n.equip_id, o.equip_id) as equip_id -- 设备号
    ,nvl(n.remark, o.remark) as remark -- 备注
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
from ${iml_schema}.evt_atm_delay_tran_acct_flow_mpcsf1_tm n
    full join (select * from ${iml_schema}.evt_atm_delay_tran_acct_flow_mpcsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.main_acct_id <> n.main_acct_id
        or o.sys_follow_id <> n.sys_follow_id
        or o.rsrv_mobile_no <> n.rsrv_mobile_no
        or o.curr_cd <> n.curr_cd
        or o.unionpay_curr_cd <> n.unionpay_curr_cd
        or o.tran_flow_num <> n.tran_flow_num
        or o.midgrod_tran_dt <> n.midgrod_tran_dt
        or o.tran_dt <> n.tran_dt
        or o.tran_cd <> n.tran_cd
        or o.tran_type_cd <> n.tran_type_cd
        or o.tran_status_cd <> n.tran_status_cd
        or o.tran_amt <> n.tran_amt
        or o.tran_teller_id <> n.tran_teller_id
        or o.tran_org_id <> n.tran_org_id
        or o.ova_flow_num <> n.ova_flow_num
        or o.bus_flow_num <> n.bus_flow_num
        or o.ghb_dtran_acct_fail_ag_cnt <> n.ghb_dtran_acct_fail_ag_cnt
        or o.delay_tran_acct_rest_cd <> n.delay_tran_acct_rest_cd
        or o.fee_type_cd <> n.fee_type_cd
        or o.comm_fee <> n.comm_fee
        or o.clear_amt <> n.clear_amt
        or o.tran_out_acct_id <> n.tran_out_acct_id
        or o.tran_out_acct_name <> n.tran_out_acct_name
        or o.tran_in_acct_id <> n.tran_in_acct_id
        or o.tran_in_acct_name <> n.tran_in_acct_name
        or o.open_acct_org_id <> n.open_acct_org_id
        or o.proc_org_id <> n.proc_org_id
        or o.send_org_id <> n.send_org_id
        or o.core_froz_flow_num <> n.core_froz_flow_num
        or o.core_froz_dt <> n.core_froz_dt
        or o.core_deduct_flow_num <> n.core_deduct_flow_num
        or o.core_deduct_dt <> n.core_deduct_dt
        or o.core_memo_code <> n.core_memo_code
        or o.core_intfc_code <> n.core_intfc_code
        or o.aldy_adj_entry_flg <> n.aldy_adj_entry_flg
        or o.err_cd <> n.err_cd
        or o.err_info <> n.err_info
        or o.sorc_sys_cd <> n.sorc_sys_cd
        or o.pass_id <> n.pass_id
        or o.mercht_type_cd <> n.mercht_type_cd
        or o.proc_mercht_id <> n.proc_mercht_id
        or o.proc_mercht_name <> n.proc_mercht_name
        or o.init_sys_follow_id <> n.init_sys_follow_id
        or o.init_ova_flow_num <> n.init_ova_flow_num
        or o.init_bus_flow_num <> n.init_bus_flow_num
        or o.init_tran_tm <> n.init_tran_tm
        or o.init_tran_flow_num <> n.init_tran_flow_num
        or o.init_proc_org_id <> n.init_proc_org_id
        or o.init_send_org_id <> n.init_send_org_id
        or o.equip_id <> n.equip_id
        or o.remark <> n.remark
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_atm_delay_tran_acct_flow_mpcsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,main_acct_id -- 主账户编号
    ,sys_follow_id -- 系统跟踪编号
    ,rsrv_mobile_no -- 预留手机号
    ,curr_cd -- 币种代码
    ,unionpay_curr_cd -- 银联币种代码
    ,tran_flow_num -- 交易流水号
    ,midgrod_tran_dt -- 中台交易日期
    ,tran_dt -- 交易日期
    ,tran_cd -- 交易代码
    ,tran_type_cd -- 交易类型代码
    ,tran_status_cd -- 交易状态代码
    ,tran_amt -- 交易金额
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,ova_flow_num -- 全局流水号
    ,bus_flow_num -- 业务流水号
    ,ghb_dtran_acct_fail_ag_cnt -- 本行延时转账失败重试次数
    ,delay_tran_acct_rest_cd -- 延时转账处理结果代码
    ,fee_type_cd -- 费用类型代码
    ,comm_fee -- 手续费
    ,clear_amt -- 清算金额
    ,tran_out_acct_id -- 转出账户编号
    ,tran_out_acct_name -- 转出账户名称
    ,tran_in_acct_id -- 转入账户编号
    ,tran_in_acct_name -- 转入账户名称
    ,open_acct_org_id -- 开户机构编号
    ,proc_org_id -- 受理机构编号
    ,send_org_id -- 发送机构编号
    ,core_froz_flow_num -- 核心冻结流水号
    ,core_froz_dt -- 核心冻结日期
    ,core_deduct_flow_num -- 核心扣款流水号
    ,core_deduct_dt -- 核心扣款日期
    ,core_memo_code -- 核心摘要码
    ,core_intfc_code -- 核心接口码
    ,aldy_adj_entry_flg -- 已调账标志
    ,err_cd -- 错误码
    ,err_info -- 错误信息
    ,sorc_sys_cd -- 源系统代码
    ,pass_id -- 通道编号
    ,mercht_type_cd -- 商户类型代码
    ,proc_mercht_id -- 受理商户编号
    ,proc_mercht_name -- 受理商户名称
    ,init_sys_follow_id -- 原系统跟踪编号
    ,init_ova_flow_num -- 原全局流水号
    ,init_bus_flow_num -- 原业务流水号
    ,init_tran_tm -- 原交易时间
    ,init_tran_flow_num -- 原交易流水号
    ,init_proc_org_id -- 原受理机构编号
    ,init_send_org_id -- 原发送机构编号
    ,equip_id -- 设备号
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_atm_delay_tran_acct_flow_mpcsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,main_acct_id -- 主账户编号
    ,sys_follow_id -- 系统跟踪编号
    ,rsrv_mobile_no -- 预留手机号
    ,curr_cd -- 币种代码
    ,unionpay_curr_cd -- 银联币种代码
    ,tran_flow_num -- 交易流水号
    ,midgrod_tran_dt -- 中台交易日期
    ,tran_dt -- 交易日期
    ,tran_cd -- 交易代码
    ,tran_type_cd -- 交易类型代码
    ,tran_status_cd -- 交易状态代码
    ,tran_amt -- 交易金额
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,ova_flow_num -- 全局流水号
    ,bus_flow_num -- 业务流水号
    ,ghb_dtran_acct_fail_ag_cnt -- 本行延时转账失败重试次数
    ,delay_tran_acct_rest_cd -- 延时转账处理结果代码
    ,fee_type_cd -- 费用类型代码
    ,comm_fee -- 手续费
    ,clear_amt -- 清算金额
    ,tran_out_acct_id -- 转出账户编号
    ,tran_out_acct_name -- 转出账户名称
    ,tran_in_acct_id -- 转入账户编号
    ,tran_in_acct_name -- 转入账户名称
    ,open_acct_org_id -- 开户机构编号
    ,proc_org_id -- 受理机构编号
    ,send_org_id -- 发送机构编号
    ,core_froz_flow_num -- 核心冻结流水号
    ,core_froz_dt -- 核心冻结日期
    ,core_deduct_flow_num -- 核心扣款流水号
    ,core_deduct_dt -- 核心扣款日期
    ,core_memo_code -- 核心摘要码
    ,core_intfc_code -- 核心接口码
    ,aldy_adj_entry_flg -- 已调账标志
    ,err_cd -- 错误码
    ,err_info -- 错误信息
    ,sorc_sys_cd -- 源系统代码
    ,pass_id -- 通道编号
    ,mercht_type_cd -- 商户类型代码
    ,proc_mercht_id -- 受理商户编号
    ,proc_mercht_name -- 受理商户名称
    ,init_sys_follow_id -- 原系统跟踪编号
    ,init_ova_flow_num -- 原全局流水号
    ,init_bus_flow_num -- 原业务流水号
    ,init_tran_tm -- 原交易时间
    ,init_tran_flow_num -- 原交易流水号
    ,init_proc_org_id -- 原受理机构编号
    ,init_send_org_id -- 原发送机构编号
    ,equip_id -- 设备号
    ,remark -- 备注
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
    ,o.main_acct_id -- 主账户编号
    ,o.sys_follow_id -- 系统跟踪编号
    ,o.rsrv_mobile_no -- 预留手机号
    ,o.curr_cd -- 币种代码
    ,o.unionpay_curr_cd -- 银联币种代码
    ,o.tran_flow_num -- 交易流水号
    ,o.midgrod_tran_dt -- 中台交易日期
    ,o.tran_dt -- 交易日期
    ,o.tran_cd -- 交易代码
    ,o.tran_type_cd -- 交易类型代码
    ,o.tran_status_cd -- 交易状态代码
    ,o.tran_amt -- 交易金额
    ,o.tran_teller_id -- 交易柜员编号
    ,o.tran_org_id -- 交易机构编号
    ,o.ova_flow_num -- 全局流水号
    ,o.bus_flow_num -- 业务流水号
    ,o.ghb_dtran_acct_fail_ag_cnt -- 本行延时转账失败重试次数
    ,o.delay_tran_acct_rest_cd -- 延时转账处理结果代码
    ,o.fee_type_cd -- 费用类型代码
    ,o.comm_fee -- 手续费
    ,o.clear_amt -- 清算金额
    ,o.tran_out_acct_id -- 转出账户编号
    ,o.tran_out_acct_name -- 转出账户名称
    ,o.tran_in_acct_id -- 转入账户编号
    ,o.tran_in_acct_name -- 转入账户名称
    ,o.open_acct_org_id -- 开户机构编号
    ,o.proc_org_id -- 受理机构编号
    ,o.send_org_id -- 发送机构编号
    ,o.core_froz_flow_num -- 核心冻结流水号
    ,o.core_froz_dt -- 核心冻结日期
    ,o.core_deduct_flow_num -- 核心扣款流水号
    ,o.core_deduct_dt -- 核心扣款日期
    ,o.core_memo_code -- 核心摘要码
    ,o.core_intfc_code -- 核心接口码
    ,o.aldy_adj_entry_flg -- 已调账标志
    ,o.err_cd -- 错误码
    ,o.err_info -- 错误信息
    ,o.sorc_sys_cd -- 源系统代码
    ,o.pass_id -- 通道编号
    ,o.mercht_type_cd -- 商户类型代码
    ,o.proc_mercht_id -- 受理商户编号
    ,o.proc_mercht_name -- 受理商户名称
    ,o.init_sys_follow_id -- 原系统跟踪编号
    ,o.init_ova_flow_num -- 原全局流水号
    ,o.init_bus_flow_num -- 原业务流水号
    ,o.init_tran_tm -- 原交易时间
    ,o.init_tran_flow_num -- 原交易流水号
    ,o.init_proc_org_id -- 原受理机构编号
    ,o.init_send_org_id -- 原发送机构编号
    ,o.equip_id -- 设备号
    ,o.remark -- 备注
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
from ${iml_schema}.evt_atm_delay_tran_acct_flow_mpcsf1_bk o
    left join ${iml_schema}.evt_atm_delay_tran_acct_flow_mpcsf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_atm_delay_tran_acct_flow_mpcsf1_cl d
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
--truncate table ${iml_schema}.evt_atm_delay_tran_acct_flow;
--alter table ${iml_schema}.evt_atm_delay_tran_acct_flow truncate partition for ('mpcsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_atm_delay_tran_acct_flow') 
               and substr(subpartition_name,1,8)=upper('p_mpcsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_atm_delay_tran_acct_flow drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.evt_atm_delay_tran_acct_flow modify partition p_mpcsf1 
add subpartition p_mpcsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_atm_delay_tran_acct_flow exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.evt_atm_delay_tran_acct_flow_mpcsf1_cl;
alter table ${iml_schema}.evt_atm_delay_tran_acct_flow exchange subpartition p_mpcsf1_20991231 with table ${iml_schema}.evt_atm_delay_tran_acct_flow_mpcsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_atm_delay_tran_acct_flow to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_atm_delay_tran_acct_flow_mpcsf1_tm purge;
drop table ${iml_schema}.evt_atm_delay_tran_acct_flow_mpcsf1_op purge;
drop table ${iml_schema}.evt_atm_delay_tran_acct_flow_mpcsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_atm_delay_tran_acct_flow_mpcsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_atm_delay_tran_acct_flow', partname => 'p_mpcsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
