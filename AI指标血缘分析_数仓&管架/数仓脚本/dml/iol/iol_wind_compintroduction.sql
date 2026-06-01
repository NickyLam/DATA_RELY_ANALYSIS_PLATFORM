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

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_compintroduction_ex purge;
alter table ${iol_schema}.wind_compintroduction add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.wind_compintroduction truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_compintroduction_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_compintroduction where 0=1;

insert /*+ append */ into ${iol_schema}.wind_compintroduction_ex(
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
    ,s_info_comptype -- 万得自定义的用来识别公司类型 的编码，如1代表证券公司
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
    ,is_listed -- 是否上市公司
    ,s_info_comptype -- 万得自定义的用来识别公司类型 的编码，如1代表证券公司
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_compintroduction
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_compintroduction exchange partition p_${batch_date} with table ${iol_schema}.wind_compintroduction_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_compintroduction to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_compintroduction_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_compintroduction',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);