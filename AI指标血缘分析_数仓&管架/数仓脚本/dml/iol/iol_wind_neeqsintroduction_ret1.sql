/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_neeqsintroduction
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
                       FROM wind_neeqsintroduction_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('wind_neeqsintroduction');
  
  if v_var <> 0 then 
    execute immediate 'alter table wind_neeqsintroduction drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table wind_neeqsintroduction add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.wind_neeqsintroduction(
            object_id -- 对象ID
            ,s_info_compcode -- 公司ID
            ,s_info_compname -- 公司名称
            ,s_info_compnameeng -- 英文名称
            ,s_info_country -- 国家及地区
            ,s_info_province -- 省份
            ,s_info_city -- 城市
            ,s_info_chairman -- 法人代表
            ,s_info_president -- 总经理
            ,s_info_bdsecretary -- 董事会秘书
            ,s_info_regcapital -- 注册资本(万元)
            ,s_info_founddate -- 成立日期
            ,s_info_website -- 主页
            ,s_info_email -- 电子邮箱
            ,s_info_office -- 办公地址
            ,ann_dt -- 公告日期
            ,s_info_totalemployees -- 员工总数(人)
            ,s_info_businessscope -- 经营范围
            ,s_info_main_business -- 主要产品及业务
            ,s_info_chineseintroduction -- 公司简介
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            object_id -- 对象ID
            ,s_info_compcode -- 公司ID
            ,s_info_compname -- 公司名称
            ,s_info_compnameeng -- 英文名称
            ,s_info_country -- 国家及地区
            ,s_info_province -- 省份
            ,s_info_city -- 城市
            ,s_info_chairman -- 法人代表
            ,s_info_president -- 总经理
            ,s_info_bdsecretary -- 董事会秘书
            ,s_info_regcapital -- 注册资本(万元)
            ,s_info_founddate -- 成立日期
            ,s_info_website -- 主页
            ,s_info_email -- 电子邮箱
            ,s_info_office -- 办公地址
            ,ann_dt -- 公告日期
            ,s_info_totalemployees -- 员工总数(人)
            ,substr(s_info_businessscope,1,1300) -- 经营范围
            ,s_info_main_business -- 主要产品及业务
            ,s_info_chineseintroduction -- 公司简介
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.wind_neeqsintroduction_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
