/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_tbhistransreq
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
                       FROM nfss_tbhistransreq_bak_${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('nfss_tbhistransreq');
  
  if v_var <> 0 then 
    execute immediate 'alter table nfss_tbhistransreq drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table nfss_tbhistransreq add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.nfss_tbhistransreq(
            serial_no -- 流水号
            ,ex_serial -- 发起方流水号
            ,contract_no -- 合约编号
            ,trans_date -- 交易日期
            ,trans_time -- 交易时间
            ,occur_init_date -- 发生交易时的系统日期
            ,seller_code -- 合作商代码
            ,trans_code -- 交易代码
            ,control_flag -- 控制标志
            ,branch_no -- 交易机构
            ,open_branch -- 交易所属机构
            ,ta_code -- ta代码
            ,asset_acc -- 理财帐号
            ,in_client_no -- 内部客户编号
            ,client_type -- 客户类型
            ,id_type -- 证件类型
            ,id_code -- 证件号码
            ,bank_no -- 银行编号
            ,client_no -- 客户编号
            ,bank_acc -- 银行帐号
            ,cash_flag -- 钞汇标志
            ,trans_account_type -- 交易介质类型
            ,trans_account -- 交易介质
            ,channel -- 交易渠道
            ,term_no -- 终端编号
            ,oper_no -- 交易柜员
            ,auth_oper -- 授权柜员
            ,prd_code -- 产品代码
            ,curr_type -- 产品币种
            ,prd_type -- 产品类别
            ,share_class -- 收费方式
            ,asso_date -- 关联日期
            ,asso_serial -- 关联流水号
            ,asso_serial2 -- 协议关联流水号2
            ,asso_serial3 -- 协议关联流水号3
            ,amt -- 交易金额
            ,manage_charge -- 外收手续费
            ,manage_charge2 -- 撤单外收费金额
            ,agio -- 佣金折扣
            ,client_group -- 客户分组
            ,liqu_status -- 账务状态
            ,ori_channel -- 原流水交易渠道
            ,ori_branch_no -- 原流水交易机构
            ,vol -- 交易份额
            ,larg_red_flag -- 巨额赎回处理标志
            ,red_mode -- 赎回模式
            ,prd_price -- 产品价格
            ,amt_ratio -- 金额比例
            ,div_mode -- 分红方式
            ,div_rate -- 红利比例
            ,frozen_cause -- 冻结原因
            ,transfer_cause -- 过户原因
            ,conv_dir -- 转换方向
            ,targ_prd_code -- 目标产品代码
            ,targ_seller_code -- 对方销售商代码
            ,targ_asset_acc -- 对方理财账号
            ,targ_branch -- 对方网点号
            ,targ_bank_acc -- 目标银行帐号
            ,client_risk -- 客户风险等级
            ,product_risk -- 产品风险等级
            ,cfm_date -- 确认日期
            ,cfm_no -- ta确认流水号
            ,cfm_vol -- 确认份额
            ,to_host_serial -- 发送主机流水号
            ,host_check_date -- 主机对帐日期
            ,ori_host_chk_date -- 原交易主机对帐日期
            ,host_trans_code -- 主机交易码
            ,host_date -- 主机日期
            ,host_serial -- 主机流水号
            ,monitor_flag -- 监管标志
            ,client_manager -- 客户经理
            ,err_code -- 返回码
            ,err_msg -- 错误信息
            ,status -- 交易状态
            ,deal_mode -- 受理方式
            ,summary -- 摘要说明
            ,debit_account -- 认申购账号
            ,fee_account -- 外收费账号
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,reserve1 -- 保留域1
            ,reserve2 -- 保留域2
            ,reserve3 -- 保留域3
            ,reserve4 -- 保留域4
            ,reserve5 -- 保留域5
            ,crebit_account -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serial_no -- 流水号
            ,ex_serial -- 发起方流水号
            ,contract_no -- 合约编号
            ,trans_date -- 交易日期
            ,trans_time -- 交易时间
            ,occur_init_date -- 发生交易时的系统日期
            ,seller_code -- 合作商代码
            ,trans_code -- 交易代码
            ,control_flag -- 控制标志
            ,branch_no -- 交易机构
            ,open_branch -- 交易所属机构
            ,ta_code -- ta代码
            ,asset_acc -- 理财帐号
            ,in_client_no -- 内部客户编号
            ,client_type -- 客户类型
            ,id_type -- 证件类型
            ,id_code -- 证件号码
            ,bank_no -- 银行编号
            ,client_no -- 客户编号
            ,bank_acc -- 银行帐号
            ,cash_flag -- 钞汇标志
            ,trans_account_type -- 交易介质类型
            ,trans_account -- 交易介质
            ,channel -- 交易渠道
            ,term_no -- 终端编号
            ,oper_no -- 交易柜员
            ,auth_oper -- 授权柜员
            ,prd_code -- 产品代码
            ,curr_type -- 产品币种
            ,prd_type -- 产品类别
            ,share_class -- 收费方式
            ,asso_date -- 关联日期
            ,asso_serial -- 关联流水号
            ,asso_serial2 -- 协议关联流水号2
            ,asso_serial3 -- 协议关联流水号3
            ,amt -- 交易金额
            ,manage_charge -- 外收手续费
            ,manage_charge2 -- 撤单外收费金额
            ,agio -- 佣金折扣
            ,client_group -- 客户分组
            ,liqu_status -- 账务状态
            ,ori_channel -- 原流水交易渠道
            ,ori_branch_no -- 原流水交易机构
            ,vol -- 交易份额
            ,larg_red_flag -- 巨额赎回处理标志
            ,red_mode -- 赎回模式
            ,prd_price -- 产品价格
            ,amt_ratio -- 金额比例
            ,div_mode -- 分红方式
            ,div_rate -- 红利比例
            ,frozen_cause -- 冻结原因
            ,transfer_cause -- 过户原因
            ,conv_dir -- 转换方向
            ,targ_prd_code -- 目标产品代码
            ,targ_seller_code -- 对方销售商代码
            ,targ_asset_acc -- 对方理财账号
            ,targ_branch -- 对方网点号
            ,targ_bank_acc -- 目标银行帐号
            ,client_risk -- 客户风险等级
            ,product_risk -- 产品风险等级
            ,cfm_date -- 确认日期
            ,cfm_no -- ta确认流水号
            ,cfm_vol -- 确认份额
            ,to_host_serial -- 发送主机流水号
            ,host_check_date -- 主机对帐日期
            ,ori_host_chk_date -- 原交易主机对帐日期
            ,host_trans_code -- 主机交易码
            ,host_date -- 主机日期
            ,host_serial -- 主机流水号
            ,monitor_flag -- 监管标志
            ,client_manager -- 客户经理
            ,err_code -- 返回码
            ,err_msg -- 错误信息
            ,status -- 交易状态
            ,deal_mode -- 受理方式
            ,summary -- 摘要说明
            ,debit_account -- 认申购账号
            ,fee_account -- 外收费账号
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,reserve1 -- 保留域1
            ,reserve2 -- 保留域2
            ,reserve3 -- 保留域3
            ,reserve4 -- 保留域4
            ,reserve5 -- 保留域5
            ,' ' as crebit_account -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from nfss_tbhistransreq_bak_${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
