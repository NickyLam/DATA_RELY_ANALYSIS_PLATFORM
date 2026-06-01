/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_evt_atmp_unionpay_tran_flow
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--这张表数仓供的是增量，所以需要保留历史
--alter table ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow partition for (to_date('${batch_date}','yyyymmdd')) (
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
    ,chn_cd -- 渠道代码
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
    ,cross_bor_flg -- 跨境标志
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
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(evt_id), ' ') as evt_id -- 事件编号
    ,nvl(trim(lp_id), ' ') as lp_id -- 法人编号
    ,nvl(trim(send_org_id), ' ') as send_org_id -- 发送机构编号
    ,nvl(trim(sys_follow_id), ' ') as sys_follow_id -- 系统跟踪编号
    ,nvl(trim(tran_tm), ' ') as tran_tm -- 交易时间
    ,nvl(trim(tran_cd), ' ') as tran_cd -- 交易代码
    ,nvl(trim(tran_type_cd), ' ') as tran_type_cd -- 交易类型代码
    ,nvl(trim(proc_org_id), ' ') as proc_org_id -- 受理机构编号
    ,nvl(tran_dt, to_date('00010101', 'yyyymmdd')) as tran_dt -- 交易日期
    ,nvl(trim(teller_id), ' ') as teller_id -- 柜员编号
    ,nvl(trim(tran_org_id), ' ') as tran_org_id -- 交易机构编号
    ,nvl(trim(chn_cd), ' ') as chn_cd -- 渠道代码
    ,nvl(trim(msg_type_cd), ' ') as msg_type_cd -- 报文类型代码
    ,nvl(trim(main_acct_id), ' ') as main_acct_id -- 主账户编号
    ,nvl(trim(proc_cd), ' ') as proc_cd -- 处理代码
    ,nvl(trim(intnal_proc_cd), ' ') as intnal_proc_cd -- 内部处理代码
    ,nvl(trim(tran_amt), 0) as tran_amt -- 交易金额
    ,nvl(trim(onl_acct_bal), 0) as onl_acct_bal -- 联机账户余额
    ,nvl(trim(acct_td_aval_bal), 0) as acct_td_aval_bal -- 账户当日可用余额
    ,nvl(trim(atm_draw_td_aval_bal), 0) as atm_draw_td_aval_bal -- ATM取款当日可用余额
    ,nvl(trim(tran_fee), ' ') as tran_fee -- 交易费用
    ,nvl(trim(proc_org_site_tm), ' ') as proc_org_site_tm -- 受理机构所在地时间
    ,nvl(trim(proc_org_site_dt), ' ') as proc_org_site_dt -- 受理机构所在地日期
    ,nvl(trim(clear_dt), ' ') as clear_dt -- 清算日期
    ,nvl(trim(mercht_type_cd), ' ') as mercht_type_cd -- 商户类型代码
    ,nvl(trim(tran_serv_input_way_cd), ' ') as tran_serv_input_way_cd -- 交易服务点输入方式代码
    ,nvl(trim(tran_serv_cond_cd), ' ') as tran_serv_cond_cd -- 交易服务点条件代码
    ,nvl(trim(retriv_ref_id), ' ') as retriv_ref_id -- 检索参考编号
    ,nvl(trim(apprv_tran_auth_id), ' ') as apprv_tran_auth_id -- 批准交易授权编号
    ,nvl(trim(return_code), ' ') as return_code -- 返回码
    ,nvl(trim(proc_termn_id), ' ') as proc_termn_id -- 受理终端编号
    ,nvl(trim(proc_mercht_id), ' ') as proc_mercht_id -- 受理商户编号
    ,nvl(trim(proc_mercht_name), ' ') as proc_mercht_name -- 受理商户名称
    ,nvl(trim(addit_resp_descb), ' ') as addit_resp_descb -- 附加响应描述
    ,nvl(trim(addit_priv), ' ') as addit_priv -- 附加私有域
    ,nvl(trim(curr_cd), ' ') as curr_cd -- 币种代码
    ,nvl(trim(resv_region), ' ') as resv_region -- 保留域
    ,nvl(trim(recv_org_id), ' ') as recv_org_id -- 接收机构编号
    ,nvl(trim(cups_resv_num), ' ') as cups_resv_num -- CUPS保留号
    ,nvl(trim(init_proc_org_id), ' ') as init_proc_org_id -- 原受理机构编号
    ,nvl(trim(init_send_org_id), ' ') as init_send_org_id -- 原发送机构编号
    ,nvl(trim(init_sys_follow_id), ' ') as init_sys_follow_id -- 原系统跟踪编号
    ,nvl(init_tran_tm, to_timestamp('00010101', 'yyyymmdd')) as init_tran_tm -- 原交易时间
    ,nvl(trim(unionpay_exch_rat), ' ') as unionpay_exch_rat -- 银联汇率
    ,nvl(trim(expns_acct_id), ' ') as expns_acct_id -- 支出账户编号
    ,nvl(trim(depot_acct_id), ' ') as depot_acct_id -- 存入账户编号
    ,nvl(trim(atmc_tran_flow_num), ' ') as atmc_tran_flow_num -- ATMC交易流水号
    ,nvl(trim(msg_head_info), ' ') as msg_head_info -- 报文头信息
    ,nvl(trim(tran_status_cd), ' ') as tran_status_cd -- 交易状态代码
    ,nvl(trim(err_cd), ' ') as err_cd -- 错误码
    ,nvl(trim(err_info), ' ') as err_info -- 错误信息
    ,nvl(trim(termn_type_cd), ' ') as termn_type_cd -- 终端类型代码
    ,nvl(trim(init_way_cd), ' ') as init_way_cd -- 发起方式代码
    ,nvl(trim(mercht_cty_rg_cd), ' ') as mercht_cty_rg_cd -- 商户国家地区代码
    ,nvl(trim(deduct_amt), 0) as deduct_amt -- 扣款金额
    ,nvl(trim(deduct_exch_rat), 0) as deduct_exch_rat -- 扣款汇率
    ,nvl(trim(clear_amt), 0) as clear_amt -- 清算金额
    ,nvl(trim(send_org_actl_id), ' ') as send_org_actl_id -- 发送机构实际编号
    ,nvl(trim(cross_bor_flg), ' ') as cross_bor_flg -- 跨境标志
    ,nvl(trim(card_ser_num), ' ') as card_ser_num -- 卡序列号
    ,nvl(trim(access_ic_data_region), ' ') as access_ic_data_region -- 接入IC卡数据域
    ,nvl(trim(send_ic_data_region), ' ') as send_ic_data_region -- 发出IC卡数据域
    ,nvl(trim(intnal_tran_cd), ' ') as intnal_tran_cd -- 内部交易代码
    ,nvl(trim(fcurr_tran_amt), 0) as fcurr_tran_amt -- 外币交易金额
    ,nvl(trim(bank_acct_type_cd), ' ') as bank_acct_type_cd -- 银行账户类型代码
    ,nvl(trim(open_acct_org_id), ' ') as open_acct_org_id -- 开户机构编号
    ,nvl(trim(comm_fee), 0) as comm_fee -- 手续费
    ,nvl(trim(card_type_cd), ' ') as card_type_cd -- 卡类型代码
    ,nvl(trim(card_tran_type_cd), ' ') as card_tran_type_cd -- 卡交易类型代码
    ,nvl(trim(qr_code_pay_scene_cd), ' ') as qr_code_pay_scene_cd -- 二维码付款场景代码
    ,nvl(trim(cross_bank_flg), ' ') as cross_bank_flg -- 跨行标志
    ,nvl(trim(degr_flg), ' ') as degr_flg -- 降级标志
    ,nvl(trim(beps_unpasew_flg), ' ') as beps_unpasew_flg -- 小额免密标志
    ,nvl(trim(subclass_return_code), ' ') as subclass_return_code -- 细类返回码
    ,nvl(trim(memo_cd), ' ') as memo_cd -- 摘要代码
    ,nvl(trim(ova_flow_num), ' ') as ova_flow_num -- 全局流水号
    ,nvl(trim(tran_flow_num), ' ') as tran_flow_num -- 交易流水号
    ,nvl(trim(init_tran_flow_num), ' ') as init_tran_flow_num -- 原交易流水号
    ,nvl(trim(upp_enter_status_cd), ' ') as upp_enter_status_cd -- UPP入账状态代码
    ,nvl(trim(entry_flow_num), ' ') as entry_flow_num -- 记账流水号
    ,nvl(entry_dt, to_date('00010101', 'yyyymmdd')) as entry_dt -- 记账日期
    ,nvl(trim(delay_deduct_tran_flow_num), ' ') as delay_deduct_tran_flow_num -- 延时扣款交易流水号
    ,nvl(delay_deduct_tran_dt, to_date('00010101', 'yyyymmdd')) as delay_deduct_tran_dt -- 延时扣款交易日期
    ,nvl(trim(unionpay_delay_tran_return_cd), ' ') as unionpay_delay_tran_return_cd -- 银联延时转账返回代码
    ,nvl(trim(delay_tran_return_cd), ' ') as delay_tran_return_cd -- 延时转账返回代码
    ,nvl(trim(termn_equip_id), ' ') as termn_equip_id -- 终端设备编号
    ,nvl(trim(termn_ip_addr), ' ') as termn_ip_addr -- 终端IP地址
    ,nvl(trim(termn_sim_num), ' ') as termn_sim_num -- 终端SIM号码
    ,nvl(trim(termn_gps_position), ' ') as termn_gps_position -- 终端GPS位置
    ,nvl(trim(rsrv_mobile_no), ' ') as rsrv_mobile_no -- 预留手机号
    ,nvl(trim(cust_id), ' ') as cust_id -- 客户编号
    ,nvl(trim(cust_name), ' ') as cust_name -- 客户名称
    ,nvl(midgrod_tran_dt, to_timestamp('00010101', 'yyyymmdd')) as midgrod_tran_dt -- 中台交易日期
    ,nvl(acct_dt, to_date('00010101', 'yyyymmdd')) as acct_dt -- 账务日期
    ,nvl(trim(init_tran_cd), ' ') as init_tran_cd -- 原交易代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_evt_atmp_unionpay_tran_flow to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_evt_atmp_unionpay_tran_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);