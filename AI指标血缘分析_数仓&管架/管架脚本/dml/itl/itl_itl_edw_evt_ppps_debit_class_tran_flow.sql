/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_evt_ppps_debit_class_tran_flow
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
--alter table ${itl_schema}.itl_edw_evt_ppps_debit_class_tran_flow drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_evt_ppps_debit_class_tran_flow drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_evt_ppps_debit_class_tran_flow add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_evt_ppps_debit_class_tran_flow partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,plat_flow_num -- 平台流水号
    ,plat_tran_dt -- 平台交易日期
    ,plat_tran_tm -- 平台交易时间
    ,prod_id -- 产品编号
    ,adv_flg -- 垫资标志
    ,check_entry_idf_type_cd -- 对账标识类型代码
    ,check_entry_proc_flg -- 对账处理标志
    ,check_entry_proc_tm -- 对账处理时间
    ,check_entry_rest_descb -- 对账结果描述
    ,check_entry_dt -- 对账日期
    ,check_entry_status_cd -- 对账状态代码
    ,payer_cust_acct_num -- 付款方客户账号
    ,payer_mobile_no -- 付款方手机号码
    ,payer_acct_num_cate_cd -- 付款方账号类别代码
    ,payer_acct_num_belong_core_type_cd -- 付款方账号所属核心类型代码
    ,payer_acct_name -- 付款方账户名称
    ,pay_bank_clear_bk_num -- 付款行清算行号
    ,pay_bank_clear_bk_name -- 付款行清算行名称
    ,check_teller_id -- 复核柜员编号
    ,core_revs_flow_num -- 核心冲正流水号
    ,core_check_entry_rest_descb -- 核心对账结果描述
    ,core_tran_flow_num -- 核心交易流水号
    ,core_resp_dt -- 核心响应日期
    ,core_resp_tm -- 核心响应时间
    ,fee_type_cd -- 计费类型代码
    ,tran_remark -- 交易备注
    ,tran_curr_cd -- 交易币种代码
    ,tran_proc_status_cd -- 交易处理状态代码
    ,tran_postsc -- 交易附言
    ,tran_teller_id -- 交易柜员编号
    ,tran_core_acct_status_cd -- 交易核心账务状态代码
    ,tran_org_id -- 交易机构编号
    ,tran_amt -- 交易金额
    ,tran_cate_cd -- 交易类别代码
    ,tran_batch_id -- 交易批次编号
    ,tran_clear_dt -- 交易清算日期
    ,tran_aging_type_cd -- 交易时效类型代码
    ,cust_comm_fee -- 客户手续费
    ,cross_bank_flg -- 跨行标志
    ,free_comm_fee_flg -- 免手续费标志
    ,clear_type_cd -- 清算类型代码
    ,clear_flow_num -- 清算流水号
    ,chn_id -- 渠道编号
    ,chn_check_entry_prod_id -- 渠道对账产品编号
    ,chn_check_entry_mode_cd -- 渠道对账模式代码
    ,chn_check_entry_dt -- 渠道对账日期
    ,chn_tran_flow_num -- 渠道交易流水号
    ,chn_tran_dt -- 渠道交易日期
    ,chn_tran_tm -- 渠道交易时间
    ,chn_tran_comm_fee -- 渠道交易手续费
    ,chn_comm_fee_entry_flow_num -- 渠道手续费记账流水号
    ,ova_flow_num -- 全局流水号
    ,realtm_clear_flg -- 实时清算标志
    ,recver_cust_acct_num -- 收款方客户账号
    ,recver_mobile_no -- 收款方手机号码
    ,recver_acct_num_cate_cd -- 收款方账号类别代码
    ,recver_acct_num_belong_core_type_cd -- 收款方账号所属核心类型代码
    ,recver_acct_name -- 收款方账户名称
    ,recv_bank_clear_bk_num -- 收款行清算行号
    ,recv_bank_clear_bk_name_name -- 收款行清算行名名称
    ,comm_fee_collect_status_cd -- 手续费计收状态代码
    ,auth_teller_id -- 授权柜员编号
    ,caller_sys_id -- 调用方系统ID
    ,pass_cost_fee -- 通道成本费
    ,pass_check_entry_rest_descb -- 通道对账结果描述
    ,pass_tran_flow_num -- 通道交易流水号
    ,pass_tran_dt -- 通道交易日期
    ,pass_tran_tm -- 通道交易时间
    ,pass_sys_code -- 通道系统编码
    ,pass_resp_flow_num -- 通道响应流水号
    ,pass_resp_dt -- 通道响应日期
    ,pass_resp_tm -- 通道响应时间
    ,pass_resp_status_cd -- 通道响应状态代码
    ,nostro_cd -- 往来账代码
    ,sys_comm_flow_num -- 系统通讯流水号
    ,bus_proc_status_cd -- 业务处理状态代码
    ,bus_type_cd -- 业务类型代码
    ,aldy_clear_flg -- 已清算标志
    ,aldy_refund_flg -- 已退款标志
    ,final_update_tm -- 最后更新时间
    --,src_table_name -- 源表名称
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(evt_id), ' ') as evt_id -- 事件编号
    ,nvl(trim(lp_id), ' ') as lp_id -- 法人编号
    ,nvl(trim(plat_flow_num), ' ') as plat_flow_num -- 平台流水号
    ,nvl(plat_tran_dt, to_date('00010101', 'yyyymmdd')) as plat_tran_dt -- 平台交易日期
    ,nvl(plat_tran_tm, to_timestamp('00010101', 'yyyymmdd')) as plat_tran_tm -- 平台交易时间
    ,nvl(trim(prod_id), ' ') as prod_id -- 产品编号
    ,nvl(trim(adv_flg), ' ') as adv_flg -- 垫资标志
    ,nvl(trim(check_entry_idf_type_cd), ' ') as check_entry_idf_type_cd -- 对账标识类型代码
    ,nvl(trim(check_entry_proc_flg), ' ') as check_entry_proc_flg -- 对账处理标志
    ,nvl(check_entry_proc_tm, to_timestamp('00010101', 'yyyymmdd')) as check_entry_proc_tm -- 对账处理时间
    ,nvl(trim(check_entry_rest_descb), ' ') as check_entry_rest_descb -- 对账结果描述
    ,nvl(check_entry_dt, to_date('00010101', 'yyyymmdd')) as check_entry_dt -- 对账日期
    ,nvl(trim(check_entry_status_cd), ' ') as check_entry_status_cd -- 对账状态代码
    ,nvl(trim(payer_cust_acct_num), ' ') as payer_cust_acct_num -- 付款方客户账号
    ,nvl(trim(payer_mobile_no), ' ') as payer_mobile_no -- 付款方手机号码
    ,nvl(trim(payer_acct_num_cate_cd), ' ') as payer_acct_num_cate_cd -- 付款方账号类别代码
    ,nvl(trim(payer_acct_num_belong_core_type_cd), ' ') as payer_acct_num_belong_core_type_cd -- 付款方账号所属核心类型代码
    ,nvl(trim(payer_acct_name), ' ') as payer_acct_name -- 付款方账户名称
    ,nvl(trim(pay_bank_clear_bk_num), ' ') as pay_bank_clear_bk_num -- 付款行清算行号
    ,nvl(trim(pay_bank_clear_bk_name), ' ') as pay_bank_clear_bk_name -- 付款行清算行名称
    ,nvl(trim(check_teller_id), ' ') as check_teller_id -- 复核柜员编号
    ,nvl(trim(core_revs_flow_num), ' ') as core_revs_flow_num -- 核心冲正流水号
    ,nvl(trim(core_check_entry_rest_descb), ' ') as core_check_entry_rest_descb -- 核心对账结果描述
    ,nvl(trim(core_tran_flow_num), ' ') as core_tran_flow_num -- 核心交易流水号
    ,nvl(core_resp_dt, to_date('00010101', 'yyyymmdd')) as core_resp_dt -- 核心响应日期
    ,nvl(core_resp_tm, to_timestamp('00010101', 'yyyymmdd')) as core_resp_tm -- 核心响应时间
    ,nvl(trim(fee_type_cd), ' ') as fee_type_cd -- 计费类型代码
    ,nvl(trim(tran_remark), ' ') as tran_remark -- 交易备注
    ,nvl(trim(tran_curr_cd), ' ') as tran_curr_cd -- 交易币种代码
    ,nvl(trim(tran_proc_status_cd), ' ') as tran_proc_status_cd -- 交易处理状态代码
    ,nvl(trim(tran_postsc), ' ') as tran_postsc -- 交易附言
    ,nvl(trim(tran_teller_id), ' ') as tran_teller_id -- 交易柜员编号
    ,nvl(trim(tran_core_acct_status_cd), ' ') as tran_core_acct_status_cd -- 交易核心账务状态代码
    ,nvl(trim(tran_org_id), ' ') as tran_org_id -- 交易机构编号
    ,nvl(trim(tran_amt), 0) as tran_amt -- 交易金额
    ,nvl(trim(tran_cate_cd), ' ') as tran_cate_cd -- 交易类别代码
    ,nvl(trim(tran_batch_id), ' ') as tran_batch_id -- 交易批次编号
    ,nvl(tran_clear_dt, to_date('00010101', 'yyyymmdd')) as tran_clear_dt -- 交易清算日期
    ,nvl(trim(tran_aging_type_cd), ' ') as tran_aging_type_cd -- 交易时效类型代码
    ,nvl(trim(cust_comm_fee), 0) as cust_comm_fee -- 客户手续费
    ,nvl(trim(cross_bank_flg), ' ') as cross_bank_flg -- 跨行标志
    ,nvl(trim(free_comm_fee_flg), ' ') as free_comm_fee_flg -- 免手续费标志
    ,nvl(trim(clear_type_cd), ' ') as clear_type_cd -- 清算类型代码
    ,nvl(trim(clear_flow_num), ' ') as clear_flow_num -- 清算流水号
    ,nvl(trim(chn_id), ' ') as chn_id -- 渠道编号
    ,nvl(trim(chn_check_entry_prod_id), ' ') as chn_check_entry_prod_id -- 渠道对账产品编号
    ,nvl(trim(chn_check_entry_mode_cd), ' ') as chn_check_entry_mode_cd -- 渠道对账模式代码
    ,nvl(chn_check_entry_dt, to_date('00010101', 'yyyymmdd')) as chn_check_entry_dt -- 渠道对账日期
    ,nvl(trim(chn_tran_flow_num), ' ') as chn_tran_flow_num -- 渠道交易流水号
    ,nvl(chn_tran_dt, to_date('00010101', 'yyyymmdd')) as chn_tran_dt -- 渠道交易日期
    ,nvl(chn_tran_tm, to_timestamp('00010101', 'yyyymmdd')) as chn_tran_tm -- 渠道交易时间
    ,nvl(trim(chn_tran_comm_fee), 0) as chn_tran_comm_fee -- 渠道交易手续费
    ,nvl(trim(chn_comm_fee_entry_flow_num), ' ') as chn_comm_fee_entry_flow_num -- 渠道手续费记账流水号
    ,nvl(trim(ova_flow_num), ' ') as ova_flow_num -- 全局流水号
    ,nvl(trim(realtm_clear_flg), ' ') as realtm_clear_flg -- 实时清算标志
    ,nvl(trim(recver_cust_acct_num), ' ') as recver_cust_acct_num -- 收款方客户账号
    ,nvl(trim(recver_mobile_no), ' ') as recver_mobile_no -- 收款方手机号码
    ,nvl(trim(recver_acct_num_cate_cd), ' ') as recver_acct_num_cate_cd -- 收款方账号类别代码
    ,nvl(trim(recver_acct_num_belong_core_type_cd), ' ') as recver_acct_num_belong_core_type_cd -- 收款方账号所属核心类型代码
    ,nvl(trim(recver_acct_name), ' ') as recver_acct_name -- 收款方账户名称
    ,nvl(trim(recv_bank_clear_bk_num), ' ') as recv_bank_clear_bk_num -- 收款行清算行号
    ,nvl(trim(recv_bank_clear_bk_name_name), ' ') as recv_bank_clear_bk_name_name -- 收款行清算行名名称
    ,nvl(trim(comm_fee_collect_status_cd), ' ') as comm_fee_collect_status_cd -- 手续费计收状态代码
    ,nvl(trim(auth_teller_id), ' ') as auth_teller_id -- 授权柜员编号
    ,nvl(trim(caller_sys_id), ' ') as caller_sys_id -- 调用方系统ID
    ,nvl(trim(pass_cost_fee), 0) as pass_cost_fee -- 通道成本费
    ,nvl(trim(pass_check_entry_rest_descb), ' ') as pass_check_entry_rest_descb -- 通道对账结果描述
    ,nvl(trim(pass_tran_flow_num), ' ') as pass_tran_flow_num -- 通道交易流水号
    ,nvl(pass_tran_dt, to_date('00010101', 'yyyymmdd')) as pass_tran_dt -- 通道交易日期
    ,nvl(pass_tran_tm, to_timestamp('00010101', 'yyyymmdd')) as pass_tran_tm -- 通道交易时间
    ,nvl(trim(pass_sys_code), ' ') as pass_sys_code -- 通道系统编码
    ,nvl(trim(pass_resp_flow_num), ' ') as pass_resp_flow_num -- 通道响应流水号
    ,nvl(pass_resp_dt, to_date('00010101', 'yyyymmdd')) as pass_resp_dt -- 通道响应日期
    ,nvl(pass_resp_tm, to_timestamp('00010101', 'yyyymmdd')) as pass_resp_tm -- 通道响应时间
    ,nvl(trim(pass_resp_status_cd), ' ') as pass_resp_status_cd -- 通道响应状态代码
    ,nvl(trim(nostro_cd), ' ') as nostro_cd -- 往来账代码
    ,nvl(trim(sys_comm_flow_num), ' ') as sys_comm_flow_num -- 系统通讯流水号
    ,nvl(trim(bus_proc_status_cd), ' ') as bus_proc_status_cd -- 业务处理状态代码
    ,nvl(trim(bus_type_cd), ' ') as bus_type_cd -- 业务类型代码
    ,nvl(trim(aldy_clear_flg), ' ') as aldy_clear_flg -- 已清算标志
    ,nvl(trim(aldy_refund_flg), ' ') as aldy_refund_flg -- 已退款标志
    ,nvl(final_update_tm, to_timestamp('00010101', 'yyyymmdd')) as final_update_tm -- 最后更新时间
    --,nvl(trim(src_table_name), ' ') as src_table_name -- 源表名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow
where etl_dt = to_date('${batch_date}','yyyymmdd')
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_evt_ppps_debit_class_tran_flow to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_evt_ppps_debit_class_tran_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);