/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_si_orgguarant
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
                       FROM mims_si_orgguarant_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('mims_si_orgguarant');
  
  if v_var <> 0 then 
    execute immediate 'alter table mims_si_orgguarant drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table mims_si_orgguarant add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    

insert /*+ append */ into ${iol_schema}.mims_si_orgguarant(
            sccode -- 押品编号
            ,vouchertype -- 保证人类型
            ,voucherno -- 保证人编号
            ,vouchername -- 保证人名称
            ,cardno -- 保证人组织机构代码
            ,industry -- 保证人国标行业分类
            ,netasset -- 保证人净资产
            ,economic -- 保证人经济成分
            ,independence -- 保证人担保独立性
            ,registcountry -- 保证人注册地所在国家或地区
            ,registcountryresult -- 保证人注册地所在国家或地区外部评级结果
            ,outratingdate -- 保证人外部评级日期
            ,outratingresult -- 保证人外部评级结果
            ,inratingdate -- 保证人内部评级日期
            ,inratingresult -- 保证人内部评级结果
            ,purpose -- 保证目的
            ,insuranceno -- 保证保险保单号码
            ,isstage -- 是否阶段性担保
            ,guarmoney -- 担保金额
            ,guarcash -- 担保公司保证金金额
            ,remark -- 其他说明
            ,tdcurrency -- 币种
            ,isresident -- 是否居民
            ,cardtype -- 证件类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            sccode -- 押品编号
            ,vouchertype -- 保证人类型
            ,voucherno -- 保证人编号
            ,vouchername -- 保证人名称
            ,cardno -- 保证人组织机构代码
            ,industry -- 保证人国标行业分类
            ,netasset -- 保证人净资产
            ,economic -- 保证人经济成分
            ,independence -- 保证人担保独立性
            ,registcountry -- 保证人注册地所在国家或地区
            ,registcountryresult -- 保证人注册地所在国家或地区外部评级结果
            ,outratingdate -- 保证人外部评级日期
            ,outratingresult -- 保证人外部评级结果
            ,inratingdate -- 保证人内部评级日期
            ,inratingresult -- 保证人内部评级结果
            ,purpose -- 保证目的
            ,insuranceno -- 保证保险保单号码
            ,isstage -- 是否阶段性担保
            ,guarmoney -- 担保金额
            ,guarcash -- 担保公司保证金金额
            ,remark -- 其他说明
            ,tdcurrency -- 币种
            ,isresident -- 是否居民
            ,' ' as cardtype -- 证件类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from mims_si_orgguarant_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/