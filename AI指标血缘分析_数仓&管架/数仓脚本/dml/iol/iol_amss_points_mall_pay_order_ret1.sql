/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_points_mall_pay_order
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
                       FROM amss_points_mall_pay_order_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('amss_points_mall_pay_order');
  
  if v_var <> 0 then 
    execute immediate 'alter table amss_points_mall_pay_order drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table amss_points_mall_pay_order add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.amss_points_mall_pay_order(
            serial_num -- 流水号
            ,txn_date -- 交易日期
            ,txn_time -- 交易时间
            ,order_num -- 积分商城订单号
            ,pay_type -- 1-支付 2-退款
            ,pty_id -- 客户号
            ,pty_rank -- 客户等级
            ,pty_name -- 客户名称
            ,iden_type_cd -- 证件类型
            ,cert_num -- 证件号码
            ,pty_open_org -- 客户开户机构
            ,agents_id -- 代理商编号
            ,mrchd_type -- 商品类型 1-实体商品 2-虚拟商品 3-实物贵金属
            ,txn_code -- 交易码
            ,gross_qtty_amt -- 订单总金额
            ,gross_qtty_points -- 订单总积分
            ,points_type -- 订单积分类型
            ,entitlement_point -- 订单权益积分
            ,rem_amt -- 剩余可用金额
            ,rem_points -- 剩余可用积分
            ,rem_entitlement_point -- 剩余可用权益积分
            ,txn_status -- 交易状态 01-待支付、02-支付成（退款成功），03-支付失败（退款数币）、06-订单处理中
            ,payment_success_date -- 付款成功日期
            ,pay_card_num -- 支付卡号
            ,open_org_num -- 支付卡开户机构
            ,acct_num_name -- 支付卡名称
            ,bank_name -- 银行名称
            ,exch_brch_no -- 联行号
            ,card_type -- 卡类型 1-1类卡 2-2类卡 3-3类卡
            ,wthr_check_bal -- 是否检查余额 0否 1是 空否
            ,fret_amt -- 运费金额
            ,cons_name -- 收货人姓名
            ,cons_ceph_num -- 收货人手机号
            ,cons_loc_prov -- 收货人所在省
            ,cons_loc_city -- 收货人所在市
            ,cons_loc_cuty -- 收货人所在县（区）
            ,cons_loc_town -- 收货人所在镇
            ,cons_dtl_loc -- 收货人详细地址
            ,pick_goods_mode -- 提货方式
            ,pty_mgr_num -- 银行客户经理号
            ,txn_org_num -- 交易机构号
            ,orig_order_num -- 原交易订单号
            ,orig_trx_dt -- 原订单交易日期
            ,srv_resp_code -- 响应码
            ,srv_resp_info -- 响应描述
            ,merch_num -- 商户号
            ,channel_id -- 所属机构
            ,cnsm_typ -- 消费类型 1-积分支付、2-现金支付（本代本）、3-福利金支付、4- 权益积分、5-积分+现金、6-福利金+现金、7-权益积分+现金
            ,physics_flag -- 物理标识 1-正常 2-删除
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,create_emp -- 创建人
            ,update_emp -- 更新人
            ,pay_serial_num -- 原交易平台流水号（退款用）
            ,pay_order_num -- 原交易订单号（退款用）
            ,gross_fjl -- 订单总福利金
            ,rem_flj -- 剩余福利金
            ,return_flag -- 组合支付回滚标志
            ,txn_num -- 交易流水号
            ,notify_flag -- 是否通知成功 (0-失败 1-成功)
            ,notify_count -- 支付失败通知次数 (通知失败需补偿通知，最多补偿通知 6次，次数累加)
            ,ship_status -- 发货状态1：未发货 2：已发货
			    ,cons_loc_prov_v -- 收货人所在省
    ,cons_loc_city_v -- 收货人所在市
    ,cons_loc_cuty_v -- 收货人所在县（区）
    ,cons_loc_town_v -- 收货人所在镇
    ,cons_dtl_loc_v -- 收货人详细地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serial_num -- 流水号
            ,txn_date -- 交易日期
            ,txn_time -- 交易时间
            ,order_num -- 积分商城订单号
            ,pay_type -- 1-支付 2-退款
            ,pty_id -- 客户号
            ,pty_rank -- 客户等级
            ,pty_name -- 客户名称
            ,iden_type_cd -- 证件类型
            ,cert_num -- 证件号码
            ,pty_open_org -- 客户开户机构
            ,agents_id -- 代理商编号
            ,mrchd_type -- 商品类型 1-实体商品 2-虚拟商品 3-实物贵金属
            ,txn_code -- 交易码
            ,gross_qtty_amt -- 订单总金额
            ,gross_qtty_points -- 订单总积分
            ,points_type -- 订单积分类型
            ,entitlement_point -- 订单权益积分
            ,rem_amt -- 剩余可用金额
            ,rem_points -- 剩余可用积分
            ,rem_entitlement_point -- 剩余可用权益积分
            ,txn_status -- 交易状态 01-待支付、02-支付成（退款成功），03-支付失败（退款数币）、06-订单处理中
            ,payment_success_date -- 付款成功日期
            ,pay_card_num -- 支付卡号
            ,open_org_num -- 支付卡开户机构
            ,acct_num_name -- 支付卡名称
            ,bank_name -- 银行名称
            ,exch_brch_no -- 联行号
            ,card_type -- 卡类型 1-1类卡 2-2类卡 3-3类卡
            ,wthr_check_bal -- 是否检查余额 0否 1是 空否
            ,fret_amt -- 运费金额
            ,cons_name -- 收货人姓名
            ,cons_ceph_num -- 收货人手机号
            ,cons_loc_prov -- 收货人所在省
            ,cons_loc_city -- 收货人所在市
            ,cons_loc_cuty -- 收货人所在县（区）
            ,cons_loc_town -- 收货人所在镇
            ,cons_dtl_loc -- 收货人详细地址
            ,pick_goods_mode -- 提货方式
            ,pty_mgr_num -- 银行客户经理号
            ,txn_org_num -- 交易机构号
            ,orig_order_num -- 原交易订单号
            ,orig_trx_dt -- 原订单交易日期
            ,srv_resp_code -- 响应码
            ,srv_resp_info -- 响应描述
            ,merch_num -- 商户号
            ,channel_id -- 所属机构
            ,cnsm_typ -- 消费类型 1-积分支付、2-现金支付（本代本）、3-福利金支付、4- 权益积分、5-积分+现金、6-福利金+现金、7-权益积分+现金
            ,physics_flag -- 物理标识 1-正常 2-删除
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,create_emp -- 创建人
            ,update_emp -- 更新人
            ,pay_serial_num -- 原交易平台流水号（退款用）
            ,pay_order_num -- 原交易订单号（退款用）
            ,gross_fjl -- 订单总福利金
            ,rem_flj -- 剩余福利金
            ,return_flag -- 组合支付回滚标志
            ,txn_num -- 交易流水号
            ,notify_flag -- 是否通知成功 (0-失败 1-成功)
            ,notify_count -- 支付失败通知次数 (通知失败需补偿通知，最多补偿通知 6次，次数累加)
            ,' ' as ship_status -- 发货状态1：未发货 2：已发货
    ,' ' as cons_loc_prov_v -- 收货人所在省
    ,' ' as cons_loc_city_v -- 收货人所在市
    ,' ' as cons_loc_cuty_v -- 收货人所在县（区）
    ,' ' as cons_loc_town_v -- 收货人所在镇
    ,' ' as cons_dtl_loc_v -- 收货人详细地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.amss_points_mall_pay_order_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
