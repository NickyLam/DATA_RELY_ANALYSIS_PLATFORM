/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_scfs_biz_inter_bank_fact_inf
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.scfs_biz_inter_bank_fact_inf_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.scfs_biz_inter_bank_fact_inf
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scfs_biz_inter_bank_fact_inf_op purge;
drop table ${iol_schema}.scfs_biz_inter_bank_fact_inf_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scfs_biz_inter_bank_fact_inf_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scfs_biz_inter_bank_fact_inf where 0=1;

create table ${iol_schema}.scfs_biz_inter_bank_fact_inf_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scfs_biz_inter_bank_fact_inf where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scfs_biz_inter_bank_fact_inf_cl(
            id -- 主键id
            ,bank_fact_id -- 跨行再保理编号
            ,bank_fact_type -- 业务类型
            ,coop_no -- 协议编号
            ,fact_bank_num -- 保理行行号
            ,fact_bank_nm -- 保理行行名
            ,re_fact_bank_num -- 再保理行行号
            ,re_fact_bank_nm -- 再保理行行名
            ,bay_out_rate -- 买断利率
            ,bay_out_rate_amt -- 买断利息
            ,fee_amt -- 手续费
            ,buss_term -- 业务期限
            ,start_date -- 起息日
            ,sell_date -- 卖出日
            ,re_fact_fnc_term_date -- 再保理融资到期日
            ,bay_out_net_amt -- 买断净额（转让净价）
            ,bay_out_amt -- 买断金额（合计）
            ,credit_risk_guar_bank -- 信用风险担保行
            ,wthr_pre_coll_int -- 是否预收息
            ,re_fact_bank_comfirm_deadline -- 再保理行确认截止日期
            ,bay_out_pay_term -- 买断净额支付期限（天）
            ,recv_acc_num -- 收款账号
            ,recv_acc_nm -- 收款账户名
            ,open_bank_num -- 开户行行号
            ,open_bank_nm -- 开户行行名
            ,large_pay_acc_num -- 大额支付号
            ,contact_name -- 联系人
            ,contact_phone -- 电话
            ,email -- 邮箱
            ,charge_serial_num -- 收费序号（费用编号）
            ,pcs_st_cd -- 流程状态代码
            ,interface_push_st_cd -- 交易状态
            ,transfer_st_cd -- 回款划出状态
            ,amorize_register_st_cd -- 摊销登记状态
            ,opin -- 意见
            ,tenant_id -- 租户id
            ,create_time -- 创建时间
            ,create_user -- 创建人
            ,update_time -- 更新时间
            ,update_user -- 更新人
            ,expd_id -- 扩展编号
            ,del_ind -- 删除标志
            ,version -- 版本号
            ,rspb_psn_id -- 经办人编号
            ,hdl_inst_id -- 经办机构编号
            ,hdl_dt -- 经办日期（营业日）
            ,refund_mark_out_date -- 回款划出日期
            ,interest_pay_amt -- 应付利息
            ,refund_mark_out_seq_no -- 回款划出转账流水号
            ,refund_mark_out_dt -- 回款划出转账日期
            ,refund_mark_out_platf_trx_seq -- 回款划出转账平台流水号
            ,refund_mark_out_platf_trx_dt -- 回款划出转账平台交易日期
            ,refund_mark_out_pay_acc_no -- 回款划出付款人账号
            ,refund_mark_out_pay_acc_nm -- 回款划出付款人名称
            ,refund_mark_out_pay_acc_amt -- 回款划出付款账户余额
            ,refund_mark_out_to_bank_no -- 回款划出收款方银行编号
            ,refund_mark_out_to_acc_no -- 回款划出收款人账号
            ,refund_mark_out_to_acc_nm -- 回款划出收款人名称
            ,refund_mark_out_info -- 回款划出附言
            ,sell_org_num -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scfs_biz_inter_bank_fact_inf_op(
            id -- 主键id
            ,bank_fact_id -- 跨行再保理编号
            ,bank_fact_type -- 业务类型
            ,coop_no -- 协议编号
            ,fact_bank_num -- 保理行行号
            ,fact_bank_nm -- 保理行行名
            ,re_fact_bank_num -- 再保理行行号
            ,re_fact_bank_nm -- 再保理行行名
            ,bay_out_rate -- 买断利率
            ,bay_out_rate_amt -- 买断利息
            ,fee_amt -- 手续费
            ,buss_term -- 业务期限
            ,start_date -- 起息日
            ,sell_date -- 卖出日
            ,re_fact_fnc_term_date -- 再保理融资到期日
            ,bay_out_net_amt -- 买断净额（转让净价）
            ,bay_out_amt -- 买断金额（合计）
            ,credit_risk_guar_bank -- 信用风险担保行
            ,wthr_pre_coll_int -- 是否预收息
            ,re_fact_bank_comfirm_deadline -- 再保理行确认截止日期
            ,bay_out_pay_term -- 买断净额支付期限（天）
            ,recv_acc_num -- 收款账号
            ,recv_acc_nm -- 收款账户名
            ,open_bank_num -- 开户行行号
            ,open_bank_nm -- 开户行行名
            ,large_pay_acc_num -- 大额支付号
            ,contact_name -- 联系人
            ,contact_phone -- 电话
            ,email -- 邮箱
            ,charge_serial_num -- 收费序号（费用编号）
            ,pcs_st_cd -- 流程状态代码
            ,interface_push_st_cd -- 交易状态
            ,transfer_st_cd -- 回款划出状态
            ,amorize_register_st_cd -- 摊销登记状态
            ,opin -- 意见
            ,tenant_id -- 租户id
            ,create_time -- 创建时间
            ,create_user -- 创建人
            ,update_time -- 更新时间
            ,update_user -- 更新人
            ,expd_id -- 扩展编号
            ,del_ind -- 删除标志
            ,version -- 版本号
            ,rspb_psn_id -- 经办人编号
            ,hdl_inst_id -- 经办机构编号
            ,hdl_dt -- 经办日期（营业日）
            ,refund_mark_out_date -- 回款划出日期
            ,interest_pay_amt -- 应付利息
            ,refund_mark_out_seq_no -- 回款划出转账流水号
            ,refund_mark_out_dt -- 回款划出转账日期
            ,refund_mark_out_platf_trx_seq -- 回款划出转账平台流水号
            ,refund_mark_out_platf_trx_dt -- 回款划出转账平台交易日期
            ,refund_mark_out_pay_acc_no -- 回款划出付款人账号
            ,refund_mark_out_pay_acc_nm -- 回款划出付款人名称
            ,refund_mark_out_pay_acc_amt -- 回款划出付款账户余额
            ,refund_mark_out_to_bank_no -- 回款划出收款方银行编号
            ,refund_mark_out_to_acc_no -- 回款划出收款人账号
            ,refund_mark_out_to_acc_nm -- 回款划出收款人名称
            ,refund_mark_out_info -- 回款划出附言
            ,sell_org_num -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键id
    ,nvl(n.bank_fact_id, o.bank_fact_id) as bank_fact_id -- 跨行再保理编号
    ,nvl(n.bank_fact_type, o.bank_fact_type) as bank_fact_type -- 业务类型
    ,nvl(n.coop_no, o.coop_no) as coop_no -- 协议编号
    ,nvl(n.fact_bank_num, o.fact_bank_num) as fact_bank_num -- 保理行行号
    ,nvl(n.fact_bank_nm, o.fact_bank_nm) as fact_bank_nm -- 保理行行名
    ,nvl(n.re_fact_bank_num, o.re_fact_bank_num) as re_fact_bank_num -- 再保理行行号
    ,nvl(n.re_fact_bank_nm, o.re_fact_bank_nm) as re_fact_bank_nm -- 再保理行行名
    ,nvl(n.bay_out_rate, o.bay_out_rate) as bay_out_rate -- 买断利率
    ,nvl(n.bay_out_rate_amt, o.bay_out_rate_amt) as bay_out_rate_amt -- 买断利息
    ,nvl(n.fee_amt, o.fee_amt) as fee_amt -- 手续费
    ,nvl(n.buss_term, o.buss_term) as buss_term -- 业务期限
    ,nvl(n.start_date, o.start_date) as start_date -- 起息日
    ,nvl(n.sell_date, o.sell_date) as sell_date -- 卖出日
    ,nvl(n.re_fact_fnc_term_date, o.re_fact_fnc_term_date) as re_fact_fnc_term_date -- 再保理融资到期日
    ,nvl(n.bay_out_net_amt, o.bay_out_net_amt) as bay_out_net_amt -- 买断净额（转让净价）
    ,nvl(n.bay_out_amt, o.bay_out_amt) as bay_out_amt -- 买断金额（合计）
    ,nvl(n.credit_risk_guar_bank, o.credit_risk_guar_bank) as credit_risk_guar_bank -- 信用风险担保行
    ,nvl(n.wthr_pre_coll_int, o.wthr_pre_coll_int) as wthr_pre_coll_int -- 是否预收息
    ,nvl(n.re_fact_bank_comfirm_deadline, o.re_fact_bank_comfirm_deadline) as re_fact_bank_comfirm_deadline -- 再保理行确认截止日期
    ,nvl(n.bay_out_pay_term, o.bay_out_pay_term) as bay_out_pay_term -- 买断净额支付期限（天）
    ,nvl(n.recv_acc_num, o.recv_acc_num) as recv_acc_num -- 收款账号
    ,nvl(n.recv_acc_nm, o.recv_acc_nm) as recv_acc_nm -- 收款账户名
    ,nvl(n.open_bank_num, o.open_bank_num) as open_bank_num -- 开户行行号
    ,nvl(n.open_bank_nm, o.open_bank_nm) as open_bank_nm -- 开户行行名
    ,nvl(n.large_pay_acc_num, o.large_pay_acc_num) as large_pay_acc_num -- 大额支付号
    ,nvl(n.contact_name, o.contact_name) as contact_name -- 联系人
    ,nvl(n.contact_phone, o.contact_phone) as contact_phone -- 电话
    ,nvl(n.email, o.email) as email -- 邮箱
    ,nvl(n.charge_serial_num, o.charge_serial_num) as charge_serial_num -- 收费序号（费用编号）
    ,nvl(n.pcs_st_cd, o.pcs_st_cd) as pcs_st_cd -- 流程状态代码
    ,nvl(n.interface_push_st_cd, o.interface_push_st_cd) as interface_push_st_cd -- 交易状态
    ,nvl(n.transfer_st_cd, o.transfer_st_cd) as transfer_st_cd -- 回款划出状态
    ,nvl(n.amorize_register_st_cd, o.amorize_register_st_cd) as amorize_register_st_cd -- 摊销登记状态
    ,nvl(n.opin, o.opin) as opin -- 意见
    ,nvl(n.tenant_id, o.tenant_id) as tenant_id -- 租户id
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.expd_id, o.expd_id) as expd_id -- 扩展编号
    ,nvl(n.del_ind, o.del_ind) as del_ind -- 删除标志
    ,nvl(n.version, o.version) as version -- 版本号
    ,nvl(n.rspb_psn_id, o.rspb_psn_id) as rspb_psn_id -- 经办人编号
    ,nvl(n.hdl_inst_id, o.hdl_inst_id) as hdl_inst_id -- 经办机构编号
    ,nvl(n.hdl_dt, o.hdl_dt) as hdl_dt -- 经办日期（营业日）
    ,nvl(n.refund_mark_out_date, o.refund_mark_out_date) as refund_mark_out_date -- 回款划出日期
    ,nvl(n.interest_pay_amt, o.interest_pay_amt) as interest_pay_amt -- 应付利息
    ,nvl(n.refund_mark_out_seq_no, o.refund_mark_out_seq_no) as refund_mark_out_seq_no -- 回款划出转账流水号
    ,nvl(n.refund_mark_out_dt, o.refund_mark_out_dt) as refund_mark_out_dt -- 回款划出转账日期
    ,nvl(n.refund_mark_out_platf_trx_seq, o.refund_mark_out_platf_trx_seq) as refund_mark_out_platf_trx_seq -- 回款划出转账平台流水号
    ,nvl(n.refund_mark_out_platf_trx_dt, o.refund_mark_out_platf_trx_dt) as refund_mark_out_platf_trx_dt -- 回款划出转账平台交易日期
    ,nvl(n.refund_mark_out_pay_acc_no, o.refund_mark_out_pay_acc_no) as refund_mark_out_pay_acc_no -- 回款划出付款人账号
    ,nvl(n.refund_mark_out_pay_acc_nm, o.refund_mark_out_pay_acc_nm) as refund_mark_out_pay_acc_nm -- 回款划出付款人名称
    ,nvl(n.refund_mark_out_pay_acc_amt, o.refund_mark_out_pay_acc_amt) as refund_mark_out_pay_acc_amt -- 回款划出付款账户余额
    ,nvl(n.refund_mark_out_to_bank_no, o.refund_mark_out_to_bank_no) as refund_mark_out_to_bank_no -- 回款划出收款方银行编号
    ,nvl(n.refund_mark_out_to_acc_no, o.refund_mark_out_to_acc_no) as refund_mark_out_to_acc_no -- 回款划出收款人账号
    ,nvl(n.refund_mark_out_to_acc_nm, o.refund_mark_out_to_acc_nm) as refund_mark_out_to_acc_nm -- 回款划出收款人名称
    ,nvl(n.refund_mark_out_info, o.refund_mark_out_info) as refund_mark_out_info -- 回款划出附言
    ,nvl(n.sell_org_num, o.sell_org_num) as sell_org_num -- 
    ,case when
            n.id is null
            and n.version is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
            and n.version is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
            and n.version is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.scfs_biz_inter_bank_fact_inf_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.scfs_biz_inter_bank_fact_inf where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
            and o.version = n.version
where (
        o.id is null
        and o.version is null
    )
    or (
        n.id is null
        and n.version is null
    )
    or (
        o.bank_fact_id <> n.bank_fact_id
        or o.bank_fact_type <> n.bank_fact_type
        or o.coop_no <> n.coop_no
        or o.fact_bank_num <> n.fact_bank_num
        or o.fact_bank_nm <> n.fact_bank_nm
        or o.re_fact_bank_num <> n.re_fact_bank_num
        or o.re_fact_bank_nm <> n.re_fact_bank_nm
        or o.bay_out_rate <> n.bay_out_rate
        or o.bay_out_rate_amt <> n.bay_out_rate_amt
        or o.fee_amt <> n.fee_amt
        or o.buss_term <> n.buss_term
        or o.start_date <> n.start_date
        or o.sell_date <> n.sell_date
        or o.re_fact_fnc_term_date <> n.re_fact_fnc_term_date
        or o.bay_out_net_amt <> n.bay_out_net_amt
        or o.bay_out_amt <> n.bay_out_amt
        or o.credit_risk_guar_bank <> n.credit_risk_guar_bank
        or o.wthr_pre_coll_int <> n.wthr_pre_coll_int
        or o.re_fact_bank_comfirm_deadline <> n.re_fact_bank_comfirm_deadline
        or o.bay_out_pay_term <> n.bay_out_pay_term
        or o.recv_acc_num <> n.recv_acc_num
        or o.recv_acc_nm <> n.recv_acc_nm
        or o.open_bank_num <> n.open_bank_num
        or o.open_bank_nm <> n.open_bank_nm
        or o.large_pay_acc_num <> n.large_pay_acc_num
        or o.contact_name <> n.contact_name
        or o.contact_phone <> n.contact_phone
        or o.email <> n.email
        or o.charge_serial_num <> n.charge_serial_num
        or o.pcs_st_cd <> n.pcs_st_cd
        or o.interface_push_st_cd <> n.interface_push_st_cd
        or o.transfer_st_cd <> n.transfer_st_cd
        or o.amorize_register_st_cd <> n.amorize_register_st_cd
        or o.opin <> n.opin
        or o.tenant_id <> n.tenant_id
        or o.create_time <> n.create_time
        or o.create_user <> n.create_user
        or o.update_time <> n.update_time
        or o.update_user <> n.update_user
        or o.expd_id <> n.expd_id
        or o.del_ind <> n.del_ind
        or o.rspb_psn_id <> n.rspb_psn_id
        or o.hdl_inst_id <> n.hdl_inst_id
        or o.hdl_dt <> n.hdl_dt
        or o.refund_mark_out_date <> n.refund_mark_out_date
        or o.interest_pay_amt <> n.interest_pay_amt
        or o.refund_mark_out_seq_no <> n.refund_mark_out_seq_no
        or o.refund_mark_out_dt <> n.refund_mark_out_dt
        or o.refund_mark_out_platf_trx_seq <> n.refund_mark_out_platf_trx_seq
        or o.refund_mark_out_platf_trx_dt <> n.refund_mark_out_platf_trx_dt
        or o.refund_mark_out_pay_acc_no <> n.refund_mark_out_pay_acc_no
        or o.refund_mark_out_pay_acc_nm <> n.refund_mark_out_pay_acc_nm
        or o.refund_mark_out_pay_acc_amt <> n.refund_mark_out_pay_acc_amt
        or o.refund_mark_out_to_bank_no <> n.refund_mark_out_to_bank_no
        or o.refund_mark_out_to_acc_no <> n.refund_mark_out_to_acc_no
        or o.refund_mark_out_to_acc_nm <> n.refund_mark_out_to_acc_nm
        or o.refund_mark_out_info <> n.refund_mark_out_info
        or o.sell_org_num <> n.sell_org_num
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scfs_biz_inter_bank_fact_inf_cl(
            id -- 主键id
            ,bank_fact_id -- 跨行再保理编号
            ,bank_fact_type -- 业务类型
            ,coop_no -- 协议编号
            ,fact_bank_num -- 保理行行号
            ,fact_bank_nm -- 保理行行名
            ,re_fact_bank_num -- 再保理行行号
            ,re_fact_bank_nm -- 再保理行行名
            ,bay_out_rate -- 买断利率
            ,bay_out_rate_amt -- 买断利息
            ,fee_amt -- 手续费
            ,buss_term -- 业务期限
            ,start_date -- 起息日
            ,sell_date -- 卖出日
            ,re_fact_fnc_term_date -- 再保理融资到期日
            ,bay_out_net_amt -- 买断净额（转让净价）
            ,bay_out_amt -- 买断金额（合计）
            ,credit_risk_guar_bank -- 信用风险担保行
            ,wthr_pre_coll_int -- 是否预收息
            ,re_fact_bank_comfirm_deadline -- 再保理行确认截止日期
            ,bay_out_pay_term -- 买断净额支付期限（天）
            ,recv_acc_num -- 收款账号
            ,recv_acc_nm -- 收款账户名
            ,open_bank_num -- 开户行行号
            ,open_bank_nm -- 开户行行名
            ,large_pay_acc_num -- 大额支付号
            ,contact_name -- 联系人
            ,contact_phone -- 电话
            ,email -- 邮箱
            ,charge_serial_num -- 收费序号（费用编号）
            ,pcs_st_cd -- 流程状态代码
            ,interface_push_st_cd -- 交易状态
            ,transfer_st_cd -- 回款划出状态
            ,amorize_register_st_cd -- 摊销登记状态
            ,opin -- 意见
            ,tenant_id -- 租户id
            ,create_time -- 创建时间
            ,create_user -- 创建人
            ,update_time -- 更新时间
            ,update_user -- 更新人
            ,expd_id -- 扩展编号
            ,del_ind -- 删除标志
            ,version -- 版本号
            ,rspb_psn_id -- 经办人编号
            ,hdl_inst_id -- 经办机构编号
            ,hdl_dt -- 经办日期（营业日）
            ,refund_mark_out_date -- 回款划出日期
            ,interest_pay_amt -- 应付利息
            ,refund_mark_out_seq_no -- 回款划出转账流水号
            ,refund_mark_out_dt -- 回款划出转账日期
            ,refund_mark_out_platf_trx_seq -- 回款划出转账平台流水号
            ,refund_mark_out_platf_trx_dt -- 回款划出转账平台交易日期
            ,refund_mark_out_pay_acc_no -- 回款划出付款人账号
            ,refund_mark_out_pay_acc_nm -- 回款划出付款人名称
            ,refund_mark_out_pay_acc_amt -- 回款划出付款账户余额
            ,refund_mark_out_to_bank_no -- 回款划出收款方银行编号
            ,refund_mark_out_to_acc_no -- 回款划出收款人账号
            ,refund_mark_out_to_acc_nm -- 回款划出收款人名称
            ,refund_mark_out_info -- 回款划出附言
            ,sell_org_num -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scfs_biz_inter_bank_fact_inf_op(
            id -- 主键id
            ,bank_fact_id -- 跨行再保理编号
            ,bank_fact_type -- 业务类型
            ,coop_no -- 协议编号
            ,fact_bank_num -- 保理行行号
            ,fact_bank_nm -- 保理行行名
            ,re_fact_bank_num -- 再保理行行号
            ,re_fact_bank_nm -- 再保理行行名
            ,bay_out_rate -- 买断利率
            ,bay_out_rate_amt -- 买断利息
            ,fee_amt -- 手续费
            ,buss_term -- 业务期限
            ,start_date -- 起息日
            ,sell_date -- 卖出日
            ,re_fact_fnc_term_date -- 再保理融资到期日
            ,bay_out_net_amt -- 买断净额（转让净价）
            ,bay_out_amt -- 买断金额（合计）
            ,credit_risk_guar_bank -- 信用风险担保行
            ,wthr_pre_coll_int -- 是否预收息
            ,re_fact_bank_comfirm_deadline -- 再保理行确认截止日期
            ,bay_out_pay_term -- 买断净额支付期限（天）
            ,recv_acc_num -- 收款账号
            ,recv_acc_nm -- 收款账户名
            ,open_bank_num -- 开户行行号
            ,open_bank_nm -- 开户行行名
            ,large_pay_acc_num -- 大额支付号
            ,contact_name -- 联系人
            ,contact_phone -- 电话
            ,email -- 邮箱
            ,charge_serial_num -- 收费序号（费用编号）
            ,pcs_st_cd -- 流程状态代码
            ,interface_push_st_cd -- 交易状态
            ,transfer_st_cd -- 回款划出状态
            ,amorize_register_st_cd -- 摊销登记状态
            ,opin -- 意见
            ,tenant_id -- 租户id
            ,create_time -- 创建时间
            ,create_user -- 创建人
            ,update_time -- 更新时间
            ,update_user -- 更新人
            ,expd_id -- 扩展编号
            ,del_ind -- 删除标志
            ,version -- 版本号
            ,rspb_psn_id -- 经办人编号
            ,hdl_inst_id -- 经办机构编号
            ,hdl_dt -- 经办日期（营业日）
            ,refund_mark_out_date -- 回款划出日期
            ,interest_pay_amt -- 应付利息
            ,refund_mark_out_seq_no -- 回款划出转账流水号
            ,refund_mark_out_dt -- 回款划出转账日期
            ,refund_mark_out_platf_trx_seq -- 回款划出转账平台流水号
            ,refund_mark_out_platf_trx_dt -- 回款划出转账平台交易日期
            ,refund_mark_out_pay_acc_no -- 回款划出付款人账号
            ,refund_mark_out_pay_acc_nm -- 回款划出付款人名称
            ,refund_mark_out_pay_acc_amt -- 回款划出付款账户余额
            ,refund_mark_out_to_bank_no -- 回款划出收款方银行编号
            ,refund_mark_out_to_acc_no -- 回款划出收款人账号
            ,refund_mark_out_to_acc_nm -- 回款划出收款人名称
            ,refund_mark_out_info -- 回款划出附言
            ,sell_org_num -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键id
    ,o.bank_fact_id -- 跨行再保理编号
    ,o.bank_fact_type -- 业务类型
    ,o.coop_no -- 协议编号
    ,o.fact_bank_num -- 保理行行号
    ,o.fact_bank_nm -- 保理行行名
    ,o.re_fact_bank_num -- 再保理行行号
    ,o.re_fact_bank_nm -- 再保理行行名
    ,o.bay_out_rate -- 买断利率
    ,o.bay_out_rate_amt -- 买断利息
    ,o.fee_amt -- 手续费
    ,o.buss_term -- 业务期限
    ,o.start_date -- 起息日
    ,o.sell_date -- 卖出日
    ,o.re_fact_fnc_term_date -- 再保理融资到期日
    ,o.bay_out_net_amt -- 买断净额（转让净价）
    ,o.bay_out_amt -- 买断金额（合计）
    ,o.credit_risk_guar_bank -- 信用风险担保行
    ,o.wthr_pre_coll_int -- 是否预收息
    ,o.re_fact_bank_comfirm_deadline -- 再保理行确认截止日期
    ,o.bay_out_pay_term -- 买断净额支付期限（天）
    ,o.recv_acc_num -- 收款账号
    ,o.recv_acc_nm -- 收款账户名
    ,o.open_bank_num -- 开户行行号
    ,o.open_bank_nm -- 开户行行名
    ,o.large_pay_acc_num -- 大额支付号
    ,o.contact_name -- 联系人
    ,o.contact_phone -- 电话
    ,o.email -- 邮箱
    ,o.charge_serial_num -- 收费序号（费用编号）
    ,o.pcs_st_cd -- 流程状态代码
    ,o.interface_push_st_cd -- 交易状态
    ,o.transfer_st_cd -- 回款划出状态
    ,o.amorize_register_st_cd -- 摊销登记状态
    ,o.opin -- 意见
    ,o.tenant_id -- 租户id
    ,o.create_time -- 创建时间
    ,o.create_user -- 创建人
    ,o.update_time -- 更新时间
    ,o.update_user -- 更新人
    ,o.expd_id -- 扩展编号
    ,o.del_ind -- 删除标志
    ,o.version -- 版本号
    ,o.rspb_psn_id -- 经办人编号
    ,o.hdl_inst_id -- 经办机构编号
    ,o.hdl_dt -- 经办日期（营业日）
    ,o.refund_mark_out_date -- 回款划出日期
    ,o.interest_pay_amt -- 应付利息
    ,o.refund_mark_out_seq_no -- 回款划出转账流水号
    ,o.refund_mark_out_dt -- 回款划出转账日期
    ,o.refund_mark_out_platf_trx_seq -- 回款划出转账平台流水号
    ,o.refund_mark_out_platf_trx_dt -- 回款划出转账平台交易日期
    ,o.refund_mark_out_pay_acc_no -- 回款划出付款人账号
    ,o.refund_mark_out_pay_acc_nm -- 回款划出付款人名称
    ,o.refund_mark_out_pay_acc_amt -- 回款划出付款账户余额
    ,o.refund_mark_out_to_bank_no -- 回款划出收款方银行编号
    ,o.refund_mark_out_to_acc_no -- 回款划出收款人账号
    ,o.refund_mark_out_to_acc_nm -- 回款划出收款人名称
    ,o.refund_mark_out_info -- 回款划出附言
    ,o.sell_org_num -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.scfs_biz_inter_bank_fact_inf_bk o
    left join ${iol_schema}.scfs_biz_inter_bank_fact_inf_op n
        on
            o.id = n.id
            and o.version = n.version
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.scfs_biz_inter_bank_fact_inf_cl d
        on
            o.id = d.id
            and o.version = d.version
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.scfs_biz_inter_bank_fact_inf;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('scfs_biz_inter_bank_fact_inf') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.scfs_biz_inter_bank_fact_inf drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.scfs_biz_inter_bank_fact_inf add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.scfs_biz_inter_bank_fact_inf exchange partition p_${batch_date} with table ${iol_schema}.scfs_biz_inter_bank_fact_inf_cl;
alter table ${iol_schema}.scfs_biz_inter_bank_fact_inf exchange partition p_20991231 with table ${iol_schema}.scfs_biz_inter_bank_fact_inf_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.scfs_biz_inter_bank_fact_inf to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scfs_biz_inter_bank_fact_inf_op purge;
drop table ${iol_schema}.scfs_biz_inter_bank_fact_inf_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.scfs_biz_inter_bank_fact_inf_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'scfs_biz_inter_bank_fact_inf',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
