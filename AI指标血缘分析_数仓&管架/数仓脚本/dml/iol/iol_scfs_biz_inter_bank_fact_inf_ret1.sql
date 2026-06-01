/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_scfs_biz_inter_bank_fact_inf
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);
  
begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM scfs_biz_inter_bank_fact_inf_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('scfs_biz_inter_bank_fact_inf');
  
  if v_var <> 0 then 
    execute immediate 'alter table scfs_biz_inter_bank_fact_inf drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table scfs_biz_inter_bank_fact_inf add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.scfs_biz_inter_bank_fact_inf(
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
            ,' ' as sell_org_num -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.scfs_biz_inter_bank_fact_inf_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
