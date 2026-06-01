/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_evt_ibs_pre_proc_flow
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
--alter table ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,pre_proc_id -- 预受理编号
    ,init_pre_proc_id -- 原预受理编号
    ,bus_type_cd -- 业务类型代码
    ,pre_proc_status_cd -- 预受理状态代码
    ,tran_flow_num -- 交易流水号
    ,init_chn_cd -- 发起渠道代码
    ,flow_bank_proc_flow_num -- 流程银行受理流水号
    ,appl_dt -- 申请日期
    ,appl_org_id -- 申请机构编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cert_name -- 证件名称
    ,agent_flg -- 代理标志
    ,agent_cert_type_cd -- 代理人证件类型代码
    ,agent_cert_no -- 代理人证件号码
    ,agent_cert_name -- 代理人证件名称
    ,agent_cont_mode_cd -- 代理人联系方式代码
    ,mobile_no -- 手机号码
    ,precon_id -- 预约ID
    ,wdraw_usage_and_reason -- 提现用途及理由
    ,other_usage -- 其他用途
    ,par_type_comb -- 券别组合
    ,par_type_amt_comb -- 券别金额组合
    ,curr_cd -- 币种代码
    ,wdraw_lmt_comb -- 提现金额组合
    ,tran_type_cd -- 交易类型代码
    ,card_status_cd -- 卡状态代码
    ,bus_content_descb -- 业务内容描述
    ,remark -- 备注
    ,create_tm -- 创建时间
    ,create_teller_id -- 创建柜员编号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(evt_id), ' ') as evt_id -- 事件编号
    ,nvl(trim(lp_id), ' ') as lp_id -- 法人编号
    ,nvl(trim(pre_proc_id), ' ') as pre_proc_id -- 预受理编号
    ,nvl(trim(init_pre_proc_id), ' ') as init_pre_proc_id -- 原预受理编号
    ,nvl(trim(bus_type_cd), ' ') as bus_type_cd -- 业务类型代码
    ,nvl(trim(pre_proc_status_cd), ' ') as pre_proc_status_cd -- 预受理状态代码
    ,nvl(trim(tran_flow_num), ' ') as tran_flow_num -- 交易流水号
    ,nvl(trim(init_chn_cd), ' ') as init_chn_cd -- 发起渠道代码
    ,nvl(trim(flow_bank_proc_flow_num), ' ') as flow_bank_proc_flow_num -- 流程银行受理流水号
    ,nvl(appl_dt, to_date('00010101', 'yyyymmdd')) as appl_dt -- 申请日期
    ,nvl(trim(appl_org_id), ' ') as appl_org_id -- 申请机构编号
    ,nvl(trim(acct_id), ' ') as acct_id -- 账户编号
    ,nvl(trim(acct_name), ' ') as acct_name -- 账户名称
    ,nvl(trim(cust_id), ' ') as cust_id -- 客户编号
    ,nvl(trim(cust_name), ' ') as cust_name -- 客户名称
    ,nvl(trim(cert_type_cd), ' ') as cert_type_cd -- 证件类型代码
    ,nvl(trim(cert_no), ' ') as cert_no -- 证件号码
    ,nvl(trim(cert_name), ' ') as cert_name -- 证件名称
    ,nvl(trim(agent_flg), ' ') as agent_flg -- 代理标志
    ,nvl(trim(agent_cert_type_cd), ' ') as agent_cert_type_cd -- 代理人证件类型代码
    ,nvl(trim(agent_cert_no), ' ') as agent_cert_no -- 代理人证件号码
    ,nvl(trim(agent_cert_name), ' ') as agent_cert_name -- 代理人证件名称
    ,nvl(trim(agent_cont_mode_cd), ' ') as agent_cont_mode_cd -- 代理人联系方式代码
    ,nvl(trim(mobile_no), ' ') as mobile_no -- 手机号码
    ,nvl(trim(precon_id), ' ') as precon_id -- 预约ID
    ,nvl(trim(wdraw_usage_and_reason), ' ') as wdraw_usage_and_reason -- 提现用途及理由
    ,nvl(trim(other_usage), ' ') as other_usage -- 其他用途
    ,nvl(trim(par_type_comb), ' ') as par_type_comb -- 券别组合
    ,nvl(trim(par_type_amt_comb), ' ') as par_type_amt_comb -- 券别金额组合
    ,nvl(trim(curr_cd), ' ') as curr_cd -- 币种代码
    ,nvl(trim(wdraw_lmt_comb), ' ') as wdraw_lmt_comb -- 提现金额组合
    ,nvl(trim(tran_type_cd), ' ') as tran_type_cd -- 交易类型代码
    ,nvl(trim(card_status_cd), ' ') as card_status_cd -- 卡状态代码
    ,nvl(trim(bus_content_descb), ' ') as bus_content_descb -- 业务内容描述
    ,nvl(trim(remark), ' ') as remark -- 备注
    ,nvl(create_tm, to_timestamp('00010101', 'yyyymmdd')) as create_tm -- 创建时间
    ,nvl(trim(create_teller_id), ' ') as create_teller_id -- 创建柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_evt_ibs_pre_proc_flow
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_evt_ibs_pre_proc_flow to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_evt_ibs_pre_proc_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);