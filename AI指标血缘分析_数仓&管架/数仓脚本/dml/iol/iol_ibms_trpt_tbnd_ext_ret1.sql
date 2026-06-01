/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_trpt_tbnd_ext
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
                       FROM ibms_trpt_tbnd_ext_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ibms_trpt_tbnd_ext');
  
  if v_var <> 0 then 
    execute immediate 'alter table ibms_trpt_tbnd_ext drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ibms_trpt_tbnd_ext add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.ibms_trpt_tbnd_ext(
            i_code -- 债券代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,p_class_ext -- 产品分类
            ,hx_businessmiddle -- 业务中类
            ,hx_businesssmall -- 业务小类
            ,hx_investcategory -- 投向行业门类
            ,hx_investbroheading -- 投向行业大类
            ,hx_islocfinanc -- 是否地方政府融资平台
            ,hx_isdistbus -- 是否异地业务
            ,hx_isgover_fund -- 是否政府投资基金
            ,hx_isvc_fund -- 是否创业投资基金
            ,hx_incredit_type -- 增信方式
            ,hx_cremainname -- 增信主体名称
            ,hxabs_invest1_type -- 投资分类1
            ,hxabs_invest2_type -- 投资分类2
            ,hxabs_investamount -- 原投资产总金额（万元）
            ,hxabs_investinfeamount -- 原投资产品劣后级金额（万元）
            ,hxabs_creditassecu -- 信贷资产支持证券
            ,hxabs_csrcalloassecu -- 证监会同意发行的企业资产支持证券
            ,hx_creditpartyid -- 授信主体
            ,hx_basictrader -- 基础资产客户
            ,hx_undatype -- 底层资产类型
            ,hxabs_penetration_type -- 穿透类型
            ,hxabs_isdebt_for_equity -- 是否投向市场化债转股
            ,hxabs_isconsumer_financing -- 是否为消费服务类融资
            ,hxabs_againabs -- 是否再资产证券化(1:是,0否)
            ,hx_amount_level -- 该档次总金额
            ,hx_blc -- 产品当期总余额(亿)
            ,hx_blc_level -- 持有档次当期余额(亿)
            ,hx_grade_date_bond -- 评级日期(债项)
            ,hx_grade_date_inst -- 评级日期(主体)
            ,hx_inst_grade -- 主体评级
            ,hx_inst_grade_org -- 主体评级机构
            ,hx_is_stc -- 是否stc
            ,hx_priority_level -- 优先档次，优先|非优先
            ,hx_estate_bond_type -- 房地产债券类型
            ,hx_is_green_finance -- 
            ,hx_first_option_type -- 
            ,hx_second_option_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            i_code -- 债券代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,p_class_ext -- 产品分类
            ,hx_businessmiddle -- 业务中类
            ,hx_businesssmall -- 业务小类
            ,hx_investcategory -- 投向行业门类
            ,hx_investbroheading -- 投向行业大类
            ,hx_islocfinanc -- 是否地方政府融资平台
            ,hx_isdistbus -- 是否异地业务
            ,hx_isgover_fund -- 是否政府投资基金
            ,hx_isvc_fund -- 是否创业投资基金
            ,hx_incredit_type -- 增信方式
            ,hx_cremainname -- 增信主体名称
            ,hxabs_invest1_type -- 投资分类1
            ,hxabs_invest2_type -- 投资分类2
            ,hxabs_investamount -- 原投资产总金额（万元）
            ,hxabs_investinfeamount -- 原投资产品劣后级金额（万元）
            ,hxabs_creditassecu -- 信贷资产支持证券
            ,hxabs_csrcalloassecu -- 证监会同意发行的企业资产支持证券
            ,hx_creditpartyid -- 授信主体
            ,hx_basictrader -- 基础资产客户
            ,hx_undatype -- 底层资产类型
            ,hxabs_penetration_type -- 穿透类型
            ,hxabs_isdebt_for_equity -- 是否投向市场化债转股
            ,hxabs_isconsumer_financing -- 是否为消费服务类融资
            ,hxabs_againabs -- 是否再资产证券化(1:是,0否)
            ,hx_amount_level -- 该档次总金额
            ,hx_blc -- 产品当期总余额(亿)
            ,hx_blc_level -- 持有档次当期余额(亿)
            ,hx_grade_date_bond -- 评级日期(债项)
            ,hx_grade_date_inst -- 评级日期(主体)
            ,hx_inst_grade -- 主体评级
            ,hx_inst_grade_org -- 主体评级机构
            ,hx_is_stc -- 是否stc
            ,hx_priority_level -- 优先档次，优先|非优先
            ,hx_estate_bond_type -- 房地产债券类型
            ,' ' as hx_is_green_finance -- 
            ,' ' as hx_first_option_type -- 
            ,' ' as hx_second_option_type -- 
                        ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ibms_trpt_tbnd_ext_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
