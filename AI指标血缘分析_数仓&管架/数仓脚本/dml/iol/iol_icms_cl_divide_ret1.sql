/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_CL_DIVIDE_ret1
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
                       FROM ICMS_CL_DIVIDE_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_CL_DIVIDE');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_CL_DIVIDE drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_CL_DIVIDE add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_CL_DIVIDE(
            serialno -- 流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,parentserialno -- 上层切分编号上层分配编号
            ,channel -- 渠道
            ,objectno -- 对象编号
            ,ifexclusivecredit -- 是否专属额度
            ,updatedate -- 更新日期
            ,availableexposuresum -- 可用敞口金额
            ,ownercustid -- 额度所属客户(汇总层额度存上次额度客户)
            ,objecttype -- 对象类型
            ,minbusinessrate -- 最低利率
            ,lowriskexposuresum -- 类低风险敞口金额
            ,oldobjectno -- 关联迁出方对象编号
            ,riskexposuresum -- 其中，一般风险敞口限额
            ,nominalsum -- 名义金额
            ,othercommand -- 其他要求
            ,cycleflag -- 是否循环
            ,currency -- 币种币种(默认为顶层额度币种)
            ,availablenominalsum -- 可用名义金额
            ,status -- 状态
            ,inputdate -- 登记日期
            ,divideobjecttype -- 切分对象类型CLDIVIDEOBJECTTYPE（产品、客户、机构）
            ,divideobjectno -- 切分对象编号
            ,occupynominalsum -- 已用名义金额已用名义金额(自动计算)
            ,minbailrate -- 最低保证金比例
            ,guarantytype -- 担保类型
            ,exposuresum -- 敞口金额
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,termmonth -- 期限
            ,oldobjecttype -- 关联迁出方对象类型
            ,occupyexposuresum -- 已用敞口金额已用敞口金额(自动计算)
            ,maxbusinesssum -- 最高单笔金额
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,originserialno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,parentserialno -- 上层切分编号上层分配编号
            ,channel -- 渠道
            ,objectno -- 对象编号
            ,ifexclusivecredit -- 是否专属额度
            ,updatedate -- 更新日期
            ,availableexposuresum -- 可用敞口金额
            ,ownercustid -- 额度所属客户(汇总层额度存上次额度客户)
            ,objecttype -- 对象类型
            ,minbusinessrate -- 最低利率
            ,lowriskexposuresum -- 类低风险敞口金额
            ,oldobjectno -- 关联迁出方对象编号
            ,riskexposuresum -- 其中，一般风险敞口限额
            ,nominalsum -- 名义金额
            ,othercommand -- 其他要求
            ,cycleflag -- 是否循环
            ,currency -- 币种币种(默认为顶层额度币种)
            ,availablenominalsum -- 可用名义金额
            ,status -- 状态
            ,inputdate -- 登记日期
            ,divideobjecttype -- 切分对象类型CLDIVIDEOBJECTTYPE（产品、客户、机构）
            ,divideobjectno -- 切分对象编号
            ,occupynominalsum -- 已用名义金额已用名义金额(自动计算)
            ,minbailrate -- 最低保证金比例
            ,guarantytype -- 担保类型
            ,exposuresum -- 敞口金额
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,termmonth -- 期限
            ,oldobjecttype -- 关联迁出方对象类型
            ,occupyexposuresum -- 已用敞口金额已用敞口金额(自动计算)
            ,maxbusinesssum -- 最高单笔金额
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,' ' AS originserialno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_CL_DIVIDE_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
