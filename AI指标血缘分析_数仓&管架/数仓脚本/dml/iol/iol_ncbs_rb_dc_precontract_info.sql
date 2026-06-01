/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_dc_precontract_info
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
drop table ${iol_schema}.ncbs_rb_dc_precontract_info_ex purge;
alter table ${iol_schema}.ncbs_rb_dc_precontract_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ncbs_rb_dc_precontract_info;

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_dc_precontract_info_ex nologging
compress
as
select * from ${iol_schema}.ncbs_rb_dc_precontract_info where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_dc_precontract_info_ex(
    client_name -- 客户名称
    ,client_no -- 客户编号
    ,document_id -- 证件号码
    ,document_type -- 客户证件类型
    ,int_type -- 利率类型
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,user_id -- 交易柜员编号
    ,company -- 法人
    ,int_calc_type -- 计息类型
    ,narrative -- 摘要
    ,precontract_no -- 预约号
    ,precontract_status -- 期次产品预约状态
    ,precontract_stype -- 预约/认购方式
    ,res_seq_no -- 限制编号
    ,seq_no -- 序号
    ,source_type -- 渠道编号
    ,stage_code -- 期次代码
    ,stage_prod_class -- 期次产品分类
    ,delete_date -- 删除日期
    ,issue_end_date -- 发行终止日期
    ,issue_start_date -- 发行起始日期
    ,open_date -- 开立日期
    ,precontract_date -- 预约登记日期
    ,precontract_open_date -- 预约开户日期
    ,print_date -- 打印日期
    ,tran_timestamp -- 交易时间戳
    ,iss_country -- 发证国家
    ,actual_rate -- 行内利率
    ,auth_user_id -- 授权柜员
    ,ch_client_name -- 客户中文名称
    ,del_auth_user_id -- 删除授权柜员
    ,del_reason -- 删除原因
    ,del_user_id -- 删除柜员
    ,failure_reason -- 失败原因
    ,float_rate -- 浮动利率
    ,issue_amt -- 期次发行金额
    ,precontract_amt -- 预约金额
    ,precontract_amt_branch -- 大额存单申购可用金额配置机构
    ,precontract_branch -- 预约/认购机构
    ,precontract_ccy -- 期次产品预约币种
    ,print_user_id -- 打印柜员
    ,real_rate -- 执行利率
    ,comb_prod_no -- 组合产品编号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    client_name -- 客户名称
    ,client_no -- 客户编号
    ,document_id -- 证件号码
    ,document_type -- 客户证件类型
    ,int_type -- 利率类型
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,user_id -- 交易柜员编号
    ,company -- 法人
    ,int_calc_type -- 计息类型
    ,narrative -- 摘要
    ,precontract_no -- 预约号
    ,precontract_status -- 期次产品预约状态
    ,precontract_stype -- 预约/认购方式
    ,res_seq_no -- 限制编号
    ,seq_no -- 序号
    ,source_type -- 渠道编号
    ,stage_code -- 期次代码
    ,stage_prod_class -- 期次产品分类
    ,delete_date -- 删除日期
    ,issue_end_date -- 发行终止日期
    ,issue_start_date -- 发行起始日期
    ,open_date -- 开立日期
    ,precontract_date -- 预约登记日期
    ,precontract_open_date -- 预约开户日期
    ,print_date -- 打印日期
    ,tran_timestamp -- 交易时间戳
    ,iss_country -- 发证国家
    ,actual_rate -- 行内利率
    ,auth_user_id -- 授权柜员
    ,ch_client_name -- 客户中文名称
    ,del_auth_user_id -- 删除授权柜员
    ,del_reason -- 删除原因
    ,del_user_id -- 删除柜员
    ,failure_reason -- 失败原因
    ,float_rate -- 浮动利率
    ,issue_amt -- 期次发行金额
    ,precontract_amt -- 预约金额
    ,precontract_amt_branch -- 大额存单申购可用金额配置机构
    ,precontract_branch -- 预约/认购机构
    ,precontract_ccy -- 期次产品预约币种
    ,print_user_id -- 打印柜员
    ,real_rate -- 执行利率
    ,comb_prod_no -- 组合产品编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_dc_precontract_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_dc_precontract_info exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_dc_precontract_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_dc_precontract_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_dc_precontract_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_dc_precontract_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);