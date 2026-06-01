/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_customer_info
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
                       FROM bdms_bms_customer_info_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('bdms_bms_customer_info');
  
  if v_var <> 0 then 
    execute immediate 'alter table bdms_bms_customer_info drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table bdms_bms_customer_info add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.bdms_bms_customer_info(
            id -- ID
            ,cust_type -- 客户类型
            ,cust_no -- 客户编号
            ,role_type -- 参与者类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,cust_name -- 客户名称
            ,cust_address -- 地址
            ,telephone -- 电话号码
            ,fax -- 传真
            ,contacter -- 联系人
            ,post -- 邮政编码
            ,province -- 行政区划
            ,city -- 城市
            ,class_id -- 性质ID
            ,scale_id -- 企业规模
            ,trade_type_id -- 所属行业类型
            ,credit_level_id -- 信用等级ID
            ,register_fund -- 注册资金
            ,group_flag -- 集团客户标志
            ,group_id -- 集团客户ID
            ,bank_no -- 人行支付行号
            ,bank_cate_id -- 行分类ID
            ,bank_level -- 行级别
            ,bln_brh_no -- 管理机构编号
            ,top_branch_no -- 所属总行机构
            ,company_up -- 上级公司
            ,company_flag -- 是否总公司： 0 否 1 是
            ,valid_flag -- 生效标志
            ,credit_flag -- 是否授信客户： 0 否 1 是
            ,organ_code -- 组织机构代码
            ,has_sign_web -- 签约网银标志
            ,last_upd_oper_no -- 最后更新操作员
            ,last_upd_time -- 最后更新时间
            ,group_rake -- 是否占用集团客户额度： 0 否 1 是
            ,dualcontrol_locks -- 双岗复核锁标记
            ,agent_flag -- 
            ,top_bank_no -- 
            ,account_no -- 
            ,delete_flag -- 删除标志： 0 否 1 是
            ,ind_cls -- 票交所行业分类
            ,corp_scale -- 票交所企业规模
            ,arc_flag -- 是否三农企业：0-否 1-是
            ,grn_flag -- 是否绿色企业：0-否 1-是
            ,social_credit_no -- 统一社会信用代码
            ,sci_flag -- 是否科技企业： 0 否 1 是
            ,pop_flag -- 是否民企： 0 否 1 是
            ,brh_no -- 会员机构代码
            ,create_time -- 创建时间
            ,quick_accept_flag -- 是否签约秒开： 0 否 1 是
            ,quick_discount_flag -- 是否签约秒贴： 0 否 1 是
            ,quick_collztn_flag -- 是否签约秒押： 0 否 1 是
            ,cross_flag -- 
            ,showr_acct_no -- 
            ,cpes_cust_info_id -- 
            ,message_status -- 
            ,reg_addr -- 
            ,per_name -- 
            ,doc_tp -- 
            ,doc_no -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            id -- ID
            ,cust_type -- 客户类型
            ,cust_no -- 客户编号
            ,role_type -- 参与者类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,cust_name -- 客户名称
            ,cust_address -- 地址
            ,telephone -- 电话号码
            ,fax -- 传真
            ,contacter -- 联系人
            ,post -- 邮政编码
            ,province -- 行政区划
            ,city -- 城市
            ,class_id -- 性质ID
            ,scale_id -- 企业规模
            ,trade_type_id -- 所属行业类型
            ,credit_level_id -- 信用等级ID
            ,register_fund -- 注册资金
            ,group_flag -- 集团客户标志
            ,group_id -- 集团客户ID
            ,bank_no -- 人行支付行号
            ,bank_cate_id -- 行分类ID
            ,bank_level -- 行级别
            ,bln_brh_no -- 管理机构编号
            ,top_branch_no -- 所属总行机构
            ,company_up -- 上级公司
            ,company_flag -- 是否总公司： 0 否 1 是
            ,valid_flag -- 生效标志
            ,credit_flag -- 是否授信客户： 0 否 1 是
            ,organ_code -- 组织机构代码
            ,has_sign_web -- 签约网银标志
            ,last_upd_oper_no -- 最后更新操作员
            ,last_upd_time -- 最后更新时间
            ,group_rake -- 是否占用集团客户额度： 0 否 1 是
            ,dualcontrol_locks -- 双岗复核锁标记
            ,agent_flag -- 
            ,top_bank_no -- 
            ,account_no -- 
            ,delete_flag -- 删除标志： 0 否 1 是
            ,ind_cls -- 票交所行业分类
            ,corp_scale -- 票交所企业规模
            ,arc_flag -- 是否三农企业：0-否 1-是
            ,grn_flag -- 是否绿色企业：0-否 1-是
            ,social_credit_no -- 统一社会信用代码
            ,sci_flag -- 是否科技企业： 0 否 1 是
            ,pop_flag -- 是否民企： 0 否 1 是
            ,brh_no -- 会员机构代码
            ,create_time -- 创建时间
            ,quick_accept_flag -- 是否签约秒开： 0 否 1 是
            ,quick_discount_flag -- 是否签约秒贴： 0 否 1 是
            ,quick_collztn_flag -- 是否签约秒押： 0 否 1 是
            ,cross_flag -- 
            ,showr_acct_no -- 
            ,cpes_cust_info_id -- 
            ,message_status -- 
            ,' ' as reg_addr -- 
            ,' ' as per_name -- 
            ,' ' as doc_tp -- 
            ,' ' as doc_no -- 
                        ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from bdms_bms_customer_info_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
