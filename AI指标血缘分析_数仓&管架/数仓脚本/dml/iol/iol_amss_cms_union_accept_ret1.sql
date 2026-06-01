/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_cms_union_accept
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
                       FROM amss_cms_union_accept_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('amss_cms_union_accept');
  
  if v_var <> 0 then 
    execute immediate 'alter table amss_cms_union_accept drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table amss_cms_union_accept add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.amss_cms_union_accept(
            id -- 主键
            ,data_num -- 序号
            ,org_id -- 机构id
            ,org_name -- 机构名
            ,cust_num -- 客户号
            ,cust_account -- 账户
            ,cust_name -- 客户名称
            ,partner_name -- 联合合作商
            ,stat_cycle -- 统计周期
            ,stat_cycle_tra_money -- 统计周期内金额
            ,stat_cycle_tra_count -- 统计周期内笔数
            ,perk -- 联合补贴费用
            ,remark -- 备注
            ,create_user -- 创建用户
            ,create_emp -- 创建者
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,physics_flag -- 物理删除标识 1正常 2删除
            ,address -- 经营地址(省市区+详细地址)
            ,account_type -- 账户类型.账户类型：1企业,2个人
            ,term_count -- 终端数量
            ,partner_dt -- 合作开始时间(YYYY/mm/dd)
            ,is_rural -- 是否农村地区
			,account_num -- 账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            id -- 主键
            ,data_num -- 序号
            ,org_id -- 机构id
            ,org_name -- 机构名
            ,cust_num -- 客户号
            ,cust_account -- 账户
            ,cust_name -- 客户名称
            ,partner_name -- 联合合作商
            ,stat_cycle -- 统计周期
            ,stat_cycle_tra_money -- 统计周期内金额
            ,stat_cycle_tra_count -- 统计周期内笔数
            ,perk -- 联合补贴费用
            ,remark -- 备注
            ,create_user -- 创建用户
            ,create_emp -- 创建者
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,physics_flag -- 物理删除标识 1正常 2删除
            ,' ' as address -- 经营地址(省市区+详细地址)
            ,' ' as account_type -- 账户类型.账户类型：1企业,2个人
            ,0 as term_count -- 终端数量
            ,to_timestamp('00010101', 'yyyymmdd') as partner_dt -- 合作开始时间(YYYY/mm/dd)
            ,0 as is_rural -- 是否农村地区
			,' ' as account_num -- 账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.amss_cms_union_accept_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
