/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdps_customer_info
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
                       FROM bdps_customer_info_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('bdps_customer_info');
  
  if v_var <> 0 then 
    execute immediate 'alter table bdps_customer_info drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table bdps_customer_info add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.bdps_customer_info(
            id -- 
            ,cust_type -- 客户类别票据池：1-企业2-银行 3-非银行金融机构商票
            ,cust_no -- 客户号
            ,cust_name -- 客户名称
            ,cust_address -- 地址
            ,telephone -- 电知
            ,fax -- 传真
            ,contacter -- 联系人
            ,post -- 邮政编码
            ,cust_email -- 电子邮件
            ,province -- 省份
            ,city -- 城市
            ,class_id -- 性质ID
            ,scale_id -- 规模
            ,trade_type_id -- 
            ,credit_level_id -- 信用等级
            ,open_bank -- 开户银行
            ,bank_account -- 账号
            ,register_fund -- 注册资金
            ,cust_loan_card_no -- 贷款卡号
            ,group_flag -- 是否集团客户票据池：0-否 1-是
            ,group_id -- 上级公司
            ,bank_no -- 银行行号
            ,bank_cate_id -- 行分类ID
            ,bank_level -- 行级别票据池：1-总行2-一级分行3-二级分行
            ,union_id -- 联行号(银行客户用)
            ,bln_brh_id -- 所属机构表
            ,valid_flag -- 生效标志票据池：0-?未生效 1-生效
            ,credit_flag -- 是否授信客户票据池：0-否1-是
            ,organ_code -- 组织机构代码
            ,in_flag -- 是否系统内客户-产品表（票据池系统无值）0-?否 1-是
            ,last_upd_oper_id -- 最后更新操作员
            ,last_upd_time -- 最后更新时间
            ,chief_bank_flag -- 是否总行票据池：0-否1-是
            ,dualcontrol_lockstatus -- 
            ,cust_yyzh -- 营业执照号*（核心）db.customer.cust_yyzh
            ,cust_sign_add -- 注册地址
            ,cust_farener -- 法人代表名称
            ,cust_faren_card_no -- 法人代表证件号
            ,cust_is_gd -- 是否我行股东
            ,cust_jr_allow_no -- 金融许可证号
            ,cust_eff_dt -- 营业执照有效日期
            ,cust_install_dt -- 企业成立日期
            ,card_if_enable -- 贷款卡号是否有效-产品表（票据池系统无值）
            ,souceflag -- 来源CBMS-商票 LBMS-票据池(本系统维护) SASB-核心 CMSF-老信贷
            ,auto_account -- 托收回款是否自动入账0-否1-是
            ,parent_company_name -- 母公司客户名
            ,cus_manager_code -- 分管客户经理号
            ,cus_manager_name -- 分管客户经理名
            ,company_cust_no -- 集团客户号
            ,parent_company_no -- 母公司客户号
            ,usci_code -- 统一社会信用代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            id -- 
            ,cust_type -- 客户类别票据池：1-企业2-银行 3-非银行金融机构商票
            ,cust_no -- 客户号
            ,cust_name -- 客户名称
            ,cust_address -- 地址
            ,telephone -- 电知
            ,fax -- 传真
            ,contacter -- 联系人
            ,post -- 邮政编码
            ,cust_email -- 电子邮件
            ,to_char(province) -- 省份
            ,city -- 城市
            ,class_id -- 性质ID
            ,to_char(scale_id) -- 规模
            ,trade_type_id -- 
            ,to_char(credit_level_id) -- 信用等级
            ,open_bank -- 开户银行
            ,bank_account -- 账号
            ,to_number(nvl(trim(register_fund),0)) -- 注册资金
            ,cust_loan_card_no -- 贷款卡号
            ,group_flag -- 是否集团客户票据池：0-否 1-是
            ,group_id -- 上级公司
            ,bank_no -- 银行行号
            ,bank_cate_id -- 行分类ID
            ,bank_level -- 行级别票据池：1-总行2-一级分行3-二级分行
            ,union_id -- 联行号(银行客户用)
            ,bln_brh_id -- 所属机构表
            ,valid_flag -- 生效标志票据池：0-?未生效 1-生效
            ,credit_flag -- 是否授信客户票据池：0-否1-是
            ,organ_code -- 组织机构代码
            ,in_flag -- 是否系统内客户-产品表（票据池系统无值）0-?否 1-是
            ,last_upd_oper_id -- 最后更新操作员
            ,last_upd_time -- 最后更新时间
            ,chief_bank_flag -- 是否总行票据池：0-否1-是
            ,dualcontrol_lockstatus -- 
            ,cust_yyzh -- 营业执照号*（核心）db.customer.cust_yyzh
            ,cust_sign_add -- 注册地址
            ,cust_farener -- 法人代表名称
            ,cust_faren_card_no -- 法人代表证件号
            ,cust_is_gd -- 是否我行股东
            ,cust_jr_allow_no -- 金融许可证号
            ,cust_eff_dt -- 营业执照有效日期
            ,cust_install_dt -- 企业成立日期
            ,card_if_enable -- 贷款卡号是否有效-产品表（票据池系统无值）
            ,souceflag -- 来源CBMS-商票 LBMS-票据池(本系统维护) SASB-核心 CMSF-老信贷
            ,auto_account -- 托收回款是否自动入账0-否1-是
            ,parent_company_name -- 母公司客户名
            ,cus_manager_code -- 分管客户经理号
            ,cus_manager_name -- 分管客户经理名
            ,company_cust_no -- 集团客户号
            ,parent_company_no -- 母公司客户号
            ,usci_code -- 统一社会信用代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdps_customer_info_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
