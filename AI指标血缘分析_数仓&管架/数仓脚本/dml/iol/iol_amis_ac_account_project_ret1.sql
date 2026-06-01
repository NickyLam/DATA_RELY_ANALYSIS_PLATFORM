/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amis_ac_account_project
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
                       FROM amis_ac_account_project_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('amis_ac_account_project');
  
  if v_var <> 0 then 
    execute immediate 'alter table amis_ac_account_project drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table amis_ac_account_project add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.amis_ac_account_project(
            ac_account_project_uuid -- 主键
            ,account_type_code -- 问责类型code
            ,account_type_desc -- 问责类型描述
            ,project_name -- 关联项目
            ,acc_project_code -- 问责项目编号
            ,account_item -- 问责事项
            ,description -- 基本情况
            ,loss_amount -- 损失金额
            ,remarks -- 备注
            ,account_imp_dept -- 问责实施部门
            ,create_person_uuid -- 创建人UUID
            ,create_person_name　 -- 创建人姓名
            ,create_org_name　 -- 创建人机构
            ,create_time　 -- 创建时间
            ,create_org_uuid -- 创建人机构uuid
            ,create_dept -- 创建人部门
            ,create_dept_uuid -- 创建人部门uuid
            ,state -- 审批状态
            ,current_node -- 当前阶段
            ,deleted -- 删除标志位
            ,ext1 -- 扩展字段
            ,ext2 -- 扩展字段
            ,ext3 -- 扩展字段
            ,client_code -- 委托单位CODE
            ,client_desc -- 委托单位
            ,client_date -- 委托日期
            ,project_state -- 项目状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            ac_account_project_uuid -- 主键
            ,account_type_code -- 问责类型code
            ,account_type_desc -- 问责类型描述
            ,project_name -- 关联项目
            ,acc_project_code -- 问责项目编号
            ,account_item -- 问责事项
            ,substr(description,1,1300) -- 基本情况
            ,loss_amount -- 损失金额
            ,remarks -- 备注
            ,account_imp_dept -- 问责实施部门
            ,create_person_uuid -- 创建人UUID
            ,create_person_name　 -- 创建人姓名
            ,create_org_name　 -- 创建人机构
            ,create_time　 -- 创建时间
            ,create_org_uuid -- 创建人机构uuid
            ,create_dept -- 创建人部门
            ,create_dept_uuid -- 创建人部门uuid
            ,state -- 审批状态
            ,current_node -- 当前阶段
            ,deleted -- 删除标志位
            ,ext1 -- 扩展字段
            ,ext2 -- 扩展字段
            ,ext3 -- 扩展字段
            ,client_code -- 委托单位CODE
            ,client_desc -- 委托单位
            ,client_date -- 委托日期
            ,project_state -- 项目状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.amis_ac_account_project_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
