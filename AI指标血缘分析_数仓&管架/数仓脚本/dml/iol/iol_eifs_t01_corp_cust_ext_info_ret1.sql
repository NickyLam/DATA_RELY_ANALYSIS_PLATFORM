/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_t01_corp_cust_ext_info
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
                       FROM eifs_t01_corp_cust_ext_info_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('eifs_t01_corp_cust_ext_info');
  
  if v_var <> 0 then 
    execute immediate 'alter table eifs_t01_corp_cust_ext_info drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table eifs_t01_corp_cust_ext_info add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
 
insert /*+ append */ into ${iol_schema}.eifs_t01_corp_cust_ext_info(
            party_id -- 参与人id
            ,cust_card_level_cd -- 客户持卡等级
            ,cust_asset_level_cd -- 客户资产等级
            ,cust_risk_level_cd -- 风险等级
            ,bad_rec_reason -- 不良记录原因
            ,blklist_cust_ind -- 黑名单客户标志
            ,up_blklist_dt -- 黑名单登记日期
            ,blklist_type -- 上黑名单原因
            ,credit_limit_flag_cd -- 综合授信额度
            ,used_crdt_limit -- 已用授信额度
            ,avail_crdt_limit -- 可用授信额度
            ,loan_card_num -- 贷款卡号
            ,resdnt_char_cd -- 居民性质
            ,group_cust_ind -- 集团客户标志
            ,belong_group_num -- 所属集团编号
            ,belong_group_name -- 所属集团名称
            ,eco_type -- 所有制（经济）性质
            ,list_corp_ind -- 上市公司标志
            ,shares_code -- 股票代码
            ,listed_address -- 上市地
            ,national_treatment -- 国民待遇
            ,first_credit_rela_time -- 首次建立信贷关系年月
            ,admin_number -- 管理人员人数
            ,lei -- lei代码
            ,lei_role -- lei角色
            ,dig_econ -- 数字经济
            ,new_str_eme -- 战略性新兴产业
            ,int_crdt_rating_cd -- 内部信用评级
            ,org_status_cd -- 机构状态
            ,eco_type_cd -- 经济类型
            ,rgst_dt -- 注册日期
            ,indus_type_cd_level5_cls -- 行业类型(五级分类)
            ,indus_type_cd_crdt_rating -- 行业类型(信用评级)
            ,open_cap -- 开办资金
            ,lmt_or_encrge_indus_cd -- 限制或鼓励行业
            ,loan_card_num_status -- 贷款卡号状态
            ,indus_type_cd_nat_stan -- 行业类型-国标
            ,industry_type -- 产业类型
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,owner_type -- 所有制类型
            ,legal_name -- 法人机构名称
            ,legal_org_type -- 法人机构类别
            ,legal_cust_num -- 法人机构客户号
            ,superior_cust_num -- 上级机构客户编号
            ,technology_org_type -- 科技型企业分类
            ,technology_org_affirm_ts -- 科技型企业认定时间
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,belong_type_cd -- 所属类别
            ,self_info_flag -- 自助维护标志
            ,beneficiary_status -- 受益人识别状态
            ,beneficiary_attr -- 受益所有人属性
            ,beneficial_owner -- 受益所有人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            party_id -- 参与人id
            ,cust_card_level_cd -- 客户持卡等级
            ,cust_asset_level_cd -- 客户资产等级
            ,cust_risk_level_cd -- 风险等级
            ,bad_rec_reason -- 不良记录原因
            ,blklist_cust_ind -- 黑名单客户标志
            ,up_blklist_dt -- 黑名单登记日期
            ,blklist_type -- 上黑名单原因
            ,credit_limit_flag_cd -- 综合授信额度
            ,used_crdt_limit -- 已用授信额度
            ,avail_crdt_limit -- 可用授信额度
            ,loan_card_num -- 贷款卡号
            ,resdnt_char_cd -- 居民性质
            ,group_cust_ind -- 集团客户标志
            ,belong_group_num -- 所属集团编号
            ,belong_group_name -- 所属集团名称
            ,eco_type -- 所有制（经济）性质
            ,list_corp_ind -- 上市公司标志
            ,shares_code -- 股票代码
            ,listed_address -- 上市地
            ,national_treatment -- 国民待遇
            ,first_credit_rela_time -- 首次建立信贷关系年月
            ,admin_number -- 管理人员人数
            ,lei -- lei代码
            ,lei_role -- lei角色
            ,dig_econ -- 数字经济
            ,new_str_eme -- 战略性新兴产业
            ,int_crdt_rating_cd -- 内部信用评级
            ,org_status_cd -- 机构状态
            ,eco_type_cd -- 经济类型
            ,rgst_dt -- 注册日期
            ,indus_type_cd_level5_cls -- 行业类型(五级分类)
            ,indus_type_cd_crdt_rating -- 行业类型(信用评级)
            ,open_cap -- 开办资金
            ,lmt_or_encrge_indus_cd -- 限制或鼓励行业
            ,loan_card_num_status -- 贷款卡号状态
            ,indus_type_cd_nat_stan -- 行业类型-国标
            ,industry_type -- 产业类型
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,owner_type -- 所有制类型
            ,legal_name -- 法人机构名称
            ,legal_org_type -- 法人机构类别
            ,legal_cust_num -- 法人机构客户号
            ,superior_cust_num -- 上级机构客户编号
            ,technology_org_type -- 科技型企业分类
            ,technology_org_affirm_ts -- 科技型企业认定时间
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,belong_type_cd -- 所属类别
            ,self_info_flag -- 自助维护标志
            ,beneficiary_status -- 受益人识别状态
            ,beneficiary_attr -- 受益所有人属性
            ,beneficial_owner -- 受益所有人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_corp_cust_ext_info_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
