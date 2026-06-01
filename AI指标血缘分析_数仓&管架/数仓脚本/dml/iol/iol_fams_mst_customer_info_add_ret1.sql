/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_mst_customer_info_add
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
                       FROM fams_mst_customer_info_add_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('fams_mst_customer_info_add');
  
  if v_var <> 0 then 
    execute immediate 'alter table fams_mst_customer_info_add drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table fams_mst_customer_info_add add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.fams_mst_customer_info_add(
            customer_id -- 客户代码
            ,party_type3 -- 机构类型（技术领域），高新技术企业、其他
            ,party_type2 -- 机构类型（经济类型），国有企业、集体企业、民营企业、其他企业
            ,party_type1 -- 机构类型（规模），大型企业、中小微企业
            ,industry -- 国标一级分类
            ,industry2 -- 国标二级分类
            ,insititute_code -- 组织机构代码/统一社会信用代码
            ,is_gov -- 是否政府融资平台
            ,main_capital -- 核心资本（万元），存的是万元
            ,register_capital -- 注册资本（万元），存的是万元
            ,province -- 所属省
            ,city -- 所属市
            ,county -- 所属县
            ,holding_type -- 控股类型
            ,customer_obj_type -- 客户主体类型，我国中央政府、境外主权国家或经济实体区域政府、中国人民银行、境外中央银行等
            ,is_listed_company -- 是否上市公司
            ,is_group_customer -- 是否集团客户
            ,parent_customer_id -- 所属集团客户编号
            ,parent_customer_name -- 所属集团客户名称
            ,is_private -- 是否民营企业
            ,is_escape_dept -- 是否为逃废债企业
            ,credit_type -- 授信策略
            ,is_credit_related_trd -- 是否授信类关联交易
            ,struct_adjust_type -- 产业结构调整类型
            ,indus_upgrate_type -- 工业转型升级标识
            ,busi_scope -- 经营范围
            ,main_busi -- 主营业务
            ,sex -- 性别
            ,person_id -- 身份证
            ,m_phone -- 移动电话
            ,phone -- 办公电话
            ,position -- 职位
            ,company_name -- 工作单位
            ,address -- 住址
            ,mail -- 电子邮箱
            ,property -- 财产状况
            ,company_nature -- 企业性质
            ,link_id1 -- 外部代码1，存万得代码
            ,link_id2 -- 外部代码2，对于平安存客户编号
            ,link_id3 -- 外部代码3
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,hs_type -- 核算分类
            ,is_fin_licence -- 是否持有金融牌照
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            customer_id -- 客户代码
            ,party_type3 -- 机构类型（技术领域），高新技术企业、其他
            ,party_type2 -- 机构类型（经济类型），国有企业、集体企业、民营企业、其他企业
            ,party_type1 -- 机构类型（规模），大型企业、中小微企业
            ,industry -- 国标一级分类
            ,industry2 -- 国标二级分类
            ,insititute_code -- 组织机构代码/统一社会信用代码
            ,is_gov -- 是否政府融资平台
            ,main_capital -- 核心资本（万元），存的是万元
            ,register_capital -- 注册资本（万元），存的是万元
            ,province -- 所属省
            ,city -- 所属市
            ,county -- 所属县
            ,holding_type -- 控股类型
            ,customer_obj_type -- 客户主体类型，我国中央政府、境外主权国家或经济实体区域政府、中国人民银行、境外中央银行等
            ,is_listed_company -- 是否上市公司
            ,is_group_customer -- 是否集团客户
            ,parent_customer_id -- 所属集团客户编号
            ,parent_customer_name -- 所属集团客户名称
            ,is_private -- 是否民营企业
            ,is_escape_dept -- 是否为逃废债企业
            ,credit_type -- 授信策略
            ,is_credit_related_trd -- 是否授信类关联交易
            ,struct_adjust_type -- 产业结构调整类型
            ,indus_upgrate_type -- 工业转型升级标识
            ,substr(busi_scope,1,1300) -- 经营范围
            ,substr(main_busi,1,1300) -- 主营业务
            ,sex -- 性别
            ,person_id -- 身份证
            ,m_phone -- 移动电话
            ,phone -- 办公电话
            ,position -- 职位
            ,company_name -- 工作单位
            ,address -- 住址
            ,mail -- 电子邮箱
            ,property -- 财产状况
            ,company_nature -- 企业性质
            ,link_id1 -- 外部代码1，存万得代码
            ,link_id2 -- 外部代码2，对于平安存客户编号
            ,link_id3 -- 外部代码3
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,hs_type -- 核算分类
            ,is_fin_licence -- 是否持有金融牌照
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_mst_customer_info_add_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
