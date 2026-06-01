/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_ALARMSIGN_INFO_ret1
CreateDate: 20240712_月度版本
Logs:
     SUNDEXIN 新建脚本 
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
                       FROM ICMS_ALARMSIGN_INFO_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_ALARMSIGN_INFO');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_ALARMSIGN_INFO drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_ALARMSIGN_INFO add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_ALARMSIGN_INFO(
            signid -- 预警号
            ,inputdate -- 登记日期
            ,signtitle -- 预警主题
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新用户
            ,signdescribe -- 预警描述
            ,optionvalue -- 指标项值
            ,signclass -- 预警CLASS
            ,signname -- 预警名称
            ,inputuserid -- 登记人
            ,signtype -- 预警信号类型(定量指标，定性指标)
            ,signlevel -- 预警层级(预警信号等级)
            ,updateorgid -- 更新机构
            ,isratechangecondition -- 是否触发评级调整的预警信号:no/空-不是yes-是
            ,signoptiontype -- 预警指标类型
            ,thresholdvalue -- 阈值
            ,signobjecttype -- 预警对象类型
            ,judgment -- 判断关系
            ,updatedate -- 更新日期
            ,signcusytomertype -- 客户类型
            ,triggertimes -- 触发频率
            ,remark -- 备注
            ,alertinfosource -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            signid -- 预警号
            ,inputdate -- 登记日期
            ,signtitle -- 预警主题
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新用户
            ,signdescribe -- 预警描述
            ,optionvalue -- 指标项值
            ,signclass -- 预警CLASS
            ,signname -- 预警名称
            ,inputuserid -- 登记人
            ,signtype -- 预警信号类型(定量指标，定性指标)
            ,signlevel -- 预警层级(预警信号等级)
            ,updateorgid -- 更新机构
            ,isratechangecondition -- 是否触发评级调整的预警信号:no/空-不是yes-是
            ,signoptiontype -- 预警指标类型
            ,thresholdvalue -- 阈值
            ,signobjecttype -- 预警对象类型
            ,judgment -- 判断关系
            ,updatedate -- 更新日期
            ,signcusytomertype -- 客户类型
            ,triggertimes -- 触发频率
            ,remark -- 备注
            ,' ' AS alertinfosource -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_ALARMSIGN_INFO_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
