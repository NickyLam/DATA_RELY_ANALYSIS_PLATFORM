/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_compintroduction
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

declare
     v_flag   number(10) :=0;
          
begin
	for tb in (select partition_name,table_name,substr(partition_name,3) as etl_dt 
	             from user_tab_partitions 
	            where table_name = upper('wind_compintroduction_bak${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('wind_compintroduction')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table wind_compintroduction drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table wind_compintroduction add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';

insert /*+ append */ into ${iol_schema}.wind_compintroduction(
    object_id -- 对象ID
    ,comp_id -- 公司ID
    ,comp_name -- 公司名称
    ,comp_sname -- 公司中文简称
    ,comp_name_eng -- 英文名称
    ,comp_snameeng -- 英文名称缩写
    ,province -- 省份
    ,city -- 城市
    ,address -- 注册地址
    ,office -- 办公地址
    ,zipcode -- 邮编
    ,phone -- 电话
    ,fax -- 传真
    ,email -- 电子邮件
    ,website -- 公司网址
    ,registernumber -- 工商登记号
    ,chairman -- 法人代表
    ,president -- 总经理
    ,discloser -- 信息披露人
    ,regcapital -- 注册资本
    ,currencycode -- 货币代码
    ,founddate -- 成立日期
    ,enddate -- 公司终止日期
    ,briefing -- 公司简介
    ,comp_type -- 公司类型
    ,comp_property -- 企业性质
    ,country -- 国籍
    ,businessscope -- 经营范围
    ,company_type -- 公司类别
    ,s_info_totalemployees -- 员工总数(人)
    ,main_business -- 主要产品及业务
    ,opdate -- 
    ,opmode -- 
    ,social_credit_code -- 统一社会信用代码
    ,is_listed -- 是否上市公司
    ,s_info_comptype -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    object_id -- 对象ID
    ,comp_id -- 公司ID
    ,comp_name -- 公司名称
    ,comp_sname -- 公司中文简称
    ,comp_name_eng -- 英文名称
    ,comp_snameeng -- 英文名称缩写
    ,province -- 省份
    ,city -- 城市
    ,address -- 注册地址
    ,office -- 办公地址
    ,zipcode -- 邮编
    ,phone -- 电话
    ,fax -- 传真
    ,email -- 电子邮件
    ,website -- 公司网址
    ,registernumber -- 工商登记号
    ,chairman -- 法人代表
    ,president -- 总经理
    ,discloser -- 信息披露人
    ,regcapital -- 注册资本
    ,currencycode -- 货币代码
    ,founddate -- 成立日期
    ,enddate -- 公司终止日期
    ,briefing -- 公司简介
    ,comp_type -- 公司类型
    ,comp_property -- 企业性质
    ,country -- 国籍
    ,businessscope -- 经营范围
    ,company_type -- 公司类别
    ,s_info_totalemployees -- 员工总数(人)
    ,main_business -- 主要产品及业务
    ,opdate -- 
    ,opmode -- 
    ,social_credit_code -- 统一社会信用代码
    ,0 as is_listed -- 是否上市公司
    ,' ' as s_info_comptype -- 
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from wind_compintroduction_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;
end loop;
end;
/  