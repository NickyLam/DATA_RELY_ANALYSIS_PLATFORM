/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_yp_guardsitributeforjour
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
                       FROM mims_yp_guardsitributeforjour_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('mims_yp_guardsitributeforjour');
  
  if v_var <> 0 then 
    execute immediate 'alter table mims_yp_guardsitributeforjour drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table mims_yp_guardsitributeforjour add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
    
insert /*+ append */ into ${iol_schema}.mims_yp_guardsitributeforjour(
            sccode -- 押品编号
            ,contractno -- 合同号
            ,balance -- 合同余额
            ,distvalue -- 贷款分配价值
            ,contguartype -- 合同主担保方式
            ,guartype -- 押品类型
            ,credittype -- 业务品种
            ,barsign -- 条线
            ,interindustry -- 行业
            ,custscale -- 规模
            ,reporttype -- 表内表外标识
            ,deptcode -- 所属机构
            ,fiveclass -- 五级分类
            ,credno -- 借据号
            ,bal -- 借据余额
            ,confmamt -- 分配我行确认价值
            ,firstconfmamt -- 分配初评我行确认价值
            ,datecode -- 报表日期
            ,credlevel -- 分配等级 1:一级分配 2:二级分配
            ,creditname -- 业务品种名称
	    ,occurtype -- 发生类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            sccode -- 押品编号
            ,contractno -- 合同号
            ,balance -- 合同余额
            ,distvalue -- 贷款分配价值
            ,contguartype -- 合同主担保方式
            ,guartype -- 押品类型
            ,credittype -- 业务品种
            ,barsign -- 条线
            ,interindustry -- 行业
            ,custscale -- 规模
            ,reporttype -- 表内表外标识
            ,deptcode -- 所属机构
            ,fiveclass -- 五级分类
            ,credno -- 借据号
            ,bal -- 借据余额
            ,confmamt -- 分配我行确认价值
            ,firstconfmamt -- 分配初评我行确认价值
            ,datecode -- 报表日期
            ,credlevel -- 分配等级 1:一级分配 2:二级分配
            ,creditname -- 业务品种名称
	    ,' ' as occurtype -- 发生类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from mims_yp_guardsitributeforjour_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
