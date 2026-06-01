/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mrms_bth_wft_cms_merchant
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
                       FROM mrms_bth_wft_cms_merchant_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('mrms_bth_wft_cms_merchant');
  
  if v_var <> 0 then 
    execute immediate 'alter table mrms_bth_wft_cms_merchant drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table mrms_bth_wft_cms_merchant add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.mrms_bth_wft_cms_merchant(
            merchant -- 商户编号
            ,merchant_name -- 商户名称
            ,branch_no -- 威富通机构编号
            ,branch_name -- 威富通机构名称
            ,merchant_type -- 商户类型:大商户,普通商户,直营商户,加盟商户
            ,company_id_type -- 企业证件类型:统一社会信用代码证号,营业执照
            ,company_id -- 企业证件号码
            ,company_id_start_date -- 企业证件有效期开始日
            ,company_id_end_date -- 企业证件有效期结束日
            ,business_scope -- 经营范围
            ,register_address -- 注册地址
            ,legal_representative_name -- 法定代表人姓名
            ,legal_representative_sex -- 法定代表人性别:男，女
            ,legal_representative_id_type -- 法定代表人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,legal_representative_id -- 法定代表人证件号码
            ,legal_representative_id_start_date -- 法定代表人证件有效期开始日
            ,legal_representative_id_end_date -- 法定代表人证件有效期到期日
            ,legal_representative_phone -- 法定代表人手机号码
            ,beneficial_owner_name -- 受益所有人姓名
            ,beneficial_owner_id_type -- 受益所有人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,beneficial_owner_id -- 受益所有人证件号码
            ,beneficial_owner_id_start_date -- 受益所有人证件有效期开始日
            ,beneficial_owner_id_end_date -- 受益所有人证件有效期到期日
            ,beneficial_owner_address -- 受益所有人详细地址
            ,control_shareholder_name -- 控股股东名称
            ,control_shareholder_id_type -- 控股股东证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,control_shareholder_id -- 控股股东证件号码
            ,control_shareholder_id_start_date -- 控股股东证件有效期起始日
            ,control_shareholder_id_end_date -- 控股股东证件有效期到期日
            ,author_agent_name -- 授权办理人姓名
            ,author_agent_id_type -- 授权办理人证件类型
            ,author_agent_id -- 授权办理人证件号码
            ,author_agent_id_start_date -- 授权办理人证件有效期起始日
            ,author_agent_id_end_date -- 授权办理人证件有效期到期日
            ,company_id_type_value -- 企业证件类:统一社会信用代码证号,营业执照
            ,legal_representative_sex_value -- 法定代表人性别:男:1,女:2,未知的性别:0,未说明的性别:9
            ,legal_representative_id_type_value -- 法定代表人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,beneficial_owner_id_type_value -- 受益所有人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,control_shareholder_id_type_value -- 控股股东证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,author_agent_id_type_value -- 授权办理人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,ghbank_branch_no -- 华兴银行机构编号
            ,ghbank_branch_name -- 华兴银行机构全称
            ,merchant_okfile -- 商户信息OK文件
            ,merchant_txtfile -- 商户信息明细文件
            ,remark1 -- 商户审核状态:未审核,审核通过,审核不通过,需再次审核
            ,remark2 -- 商户激活状态:未激活,激活成功,激活失败,需再次激活,冻结,注销
            ,remark3 -- 备注3
            ,remark4 -- 备注4
            ,remark5 -- 备注5
            ,remark6 -- 备注6
            ,remark7 -- 备注7
            ,remark8 -- 备注8
            ,create_date -- 创建时间:timestamp(yyyy-MM-dd HH24MiSS)
            ,update_date -- 更新时间:timestamp(yyyy-MM-dd HH24MiSS)
            ,settle_accno_name -- 结算账户名称
            ,settle_accno_type -- 结算账户类型
            ,settle_bank_name -- 结算账户开户行
            ,settle_accno -- 结算账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            merchant -- 商户编号
            ,merchant_name -- 商户名称
            ,branch_no -- 威富通机构编号
            ,branch_name -- 威富通机构名称
            ,merchant_type -- 商户类型:大商户,普通商户,直营商户,加盟商户
            ,company_id_type -- 企业证件类型:统一社会信用代码证号,营业执照
            ,company_id -- 企业证件号码
            ,company_id_start_date -- 企业证件有效期开始日
            ,company_id_end_date -- 企业证件有效期结束日
            ,business_scope -- 经营范围
            ,register_address -- 注册地址
            ,legal_representative_name -- 法定代表人姓名
            ,legal_representative_sex -- 法定代表人性别:男，女
            ,legal_representative_id_type -- 法定代表人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,legal_representative_id -- 法定代表人证件号码
            ,legal_representative_id_start_date -- 法定代表人证件有效期开始日
            ,legal_representative_id_end_date -- 法定代表人证件有效期到期日
            ,legal_representative_phone -- 法定代表人手机号码
            ,beneficial_owner_name -- 受益所有人姓名
            ,beneficial_owner_id_type -- 受益所有人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,beneficial_owner_id -- 受益所有人证件号码
            ,beneficial_owner_id_start_date -- 受益所有人证件有效期开始日
            ,beneficial_owner_id_end_date -- 受益所有人证件有效期到期日
            ,beneficial_owner_address -- 受益所有人详细地址
            ,control_shareholder_name -- 控股股东名称
            ,control_shareholder_id_type -- 控股股东证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,control_shareholder_id -- 控股股东证件号码
            ,control_shareholder_id_start_date -- 控股股东证件有效期起始日
            ,control_shareholder_id_end_date -- 控股股东证件有效期到期日
            ,author_agent_name -- 授权办理人姓名
            ,author_agent_id_type -- 授权办理人证件类型
            ,author_agent_id -- 授权办理人证件号码
            ,author_agent_id_start_date -- 授权办理人证件有效期起始日
            ,author_agent_id_end_date -- 授权办理人证件有效期到期日
            ,company_id_type_value -- 企业证件类:统一社会信用代码证号,营业执照
            ,legal_representative_sex_value -- 法定代表人性别:男:1,女:2,未知的性别:0,未说明的性别:9
            ,legal_representative_id_type_value -- 法定代表人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,beneficial_owner_id_type_value -- 受益所有人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,control_shareholder_id_type_value -- 控股股东证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,author_agent_id_type_value -- 授权办理人证件类型:居民身份证,护照,中国香港居民来往内地通行证,中国台湾居民来往内地通行
            ,ghbank_branch_no -- 华兴银行机构编号
            ,ghbank_branch_name -- 华兴银行机构全称
            ,merchant_okfile -- 商户信息OK文件
            ,merchant_txtfile -- 商户信息明细文件
            ,remark1 -- 商户审核状态:未审核,审核通过,审核不通过,需再次审核
            ,remark2 -- 商户激活状态:未激活,激活成功,激活失败,需再次激活,冻结,注销
            ,remark3 -- 备注3
            ,remark4 -- 备注4
            ,remark5 -- 备注5
            ,remark6 -- 备注6
            ,remark7 -- 备注7
            ,remark8 -- 备注8
            ,' ' as create_date -- 创建时间:timestamp(yyyy-MM-dd HH24MiSS)
            ,' ' as update_date -- 更新时间:timestamp(yyyy-MM-dd HH24MiSS)
            ,' ' as settle_accno_name -- 结算账户名称
            ,' ' as settle_accno_type -- 结算账户类型
            ,' ' as settle_bank_name -- 结算账户开户行
            ,' ' as settle_accno -- 结算账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mrms_bth_wft_cms_merchant_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
