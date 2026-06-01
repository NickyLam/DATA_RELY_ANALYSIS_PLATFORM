/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_t01_corp_rel_corp_info
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
                       FROM eifs_t01_corp_rel_corp_info_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('eifs_t01_corp_rel_corp_info');
  
  if v_var <> 0 then 
    execute immediate 'alter table eifs_t01_corp_rel_corp_info drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table eifs_t01_corp_rel_corp_info add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.eifs_t01_corp_rel_corp_info(
            rel_enterp_id -- 关系企业id
            ,party_id -- 参与人id
            ,rela_cust_rela_cd -- 关联方关系
            ,rela_num -- 关联方编号
            ,party_relationship_type_id -- 关系大类型
            ,rela_name -- 关联方名称
            ,rela_cert_type_cd -- 关联方证件类型
            ,rela_cert_num -- 关联方证件号码
            ,exp_date_of_rela_cert -- 关联方证件失效日期
            ,rela_addr -- 关联方联系地址
            ,rela_tel_num -- 关联方联系电话
            ,rela_stat_cd -- 关联关系状态
            ,tax_pay_ctzn_idnt -- 税收居民身份
            ,rela_group_num -- 关联方集团号
            ,rela_nation_cd -- 关联方国籍
            ,contri_ratio -- 出资比例
            ,hold_stock_amount -- 持股数量
            ,hold_stock_ratio -- 持股比例
            ,oper_timelimit -- 经营期限
            ,corp_found_dt -- 企业成立日期
            ,legal_rep_name -- 法定代表人名称
            ,leg_repres_cert_type -- 法定代表人证件种类
            ,leg_repres_cert_no -- 法定代表人证件号码
            ,legal_cert_valid_date -- 法定代表人证件有效日期
            ,legal_person_tel_no -- 法定代表人联系电话
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
            ,assoc_open_lice -- 关联方开户许可证
            ,superior_org_code -- 上级机构组织机构代码
            ,superior_org_credit_code -- 上级机构信用代码
            ,competent_org_reg_currency -- 主管单位注册币种
            ,competent_org_reg_amt -- 主管单位注册金额
            ,rela_zone_code -- 关联人电话国内区号
            ,phone_no -- 手机号码
            ,mobile_phone -- 联系手机
            ,rela_cert_effect_dt -- 关联人证件生效日期
            ,ctrler_typ_cd -- 控制人类型代码
            ,shrh_typ_cd -- 股东类型
            ,shrh_flag_new -- 是否本行股东标志
            ,role_type_id_to -- 关系小类
            ,lnkm_self_cert_decl_flg -- 关联人自证声明标志
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            rel_enterp_id -- 关系企业id
            ,party_id -- 参与人id
            ,rela_cust_rela_cd -- 关联方关系
            ,rela_num -- 关联方编号
            ,party_relationship_type_id -- 关系大类型
            ,rela_name -- 关联方名称
            ,rela_cert_type_cd -- 关联方证件类型
            ,rela_cert_num -- 关联方证件号码
            ,exp_date_of_rela_cert -- 关联方证件失效日期
            ,rela_addr -- 关联方联系地址
            ,rela_tel_num -- 关联方联系电话
            ,rela_stat_cd -- 关联关系状态
            ,tax_pay_ctzn_idnt -- 税收居民身份
            ,rela_group_num -- 关联方集团号
            ,rela_nation_cd -- 关联方国籍
            ,contri_ratio -- 出资比例
            ,hold_stock_amount -- 持股数量
            ,hold_stock_ratio -- 持股比例
            ,oper_timelimit -- 经营期限
            ,corp_found_dt -- 企业成立日期
            ,legal_rep_name -- 法定代表人名称
            ,leg_repres_cert_type -- 法定代表人证件种类
            ,leg_repres_cert_no -- 法定代表人证件号码
            ,legal_cert_valid_date -- 法定代表人证件有效日期
            ,legal_person_tel_no -- 法定代表人联系电话
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
            ,assoc_open_lice -- 关联方开户许可证
            ,superior_org_code -- 上级机构组织机构代码
            ,superior_org_credit_code -- 上级机构信用代码
            ,competent_org_reg_currency -- 主管单位注册币种
            ,to_number(nvl(trim(competent_org_reg_amt),0)) as competent_org_reg_amt -- 主管单位注册金额
            ,rela_zone_code -- 关联人电话国内区号
            ,phone_no -- 手机号码
            ,mobile_phone -- 联系手机
            ,rela_cert_effect_dt -- 关联人证件生效日期
            ,ctrler_typ_cd -- 控制人类型代码
            ,shrh_typ_cd -- 股东类型
            ,shrh_flag_new -- 是否本行股东标志
            ,role_type_id_to -- 关系小类
            ,lnkm_self_cert_decl_flg -- 关联人自证声明标志
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from eifs_t01_corp_rel_corp_info_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
