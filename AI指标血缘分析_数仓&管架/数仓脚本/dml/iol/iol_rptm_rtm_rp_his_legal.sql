/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rptm_rtm_rp_his_legal
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
drop table ${iol_schema}.rptm_rtm_rp_his_legal_ex purge;
alter table ${iol_schema}.rptm_rtm_rp_his_legal add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.rptm_rtm_rp_his_legal truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.rptm_rtm_rp_his_legal_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rptm_rtm_rp_his_legal where 0=1;

insert /*+ append */ into ${iol_schema}.rptm_rtm_rp_his_legal_ex(
    id -- ID
    ,bus_id -- 业务主键
    ,his_bus_id -- 关联的名单业务编号
    ,east_rp_type -- 关联方类型-EAST报表口径
    ,ybj_rp_type -- 关联方类型-银保监会口径
    ,rp_name -- 关联方名称
    ,ybj_card_type -- 
    ,east_card_type -- 证件类型-EAST报表口径
    ,card_no -- 证件号码
    ,domestic_state -- 境内外
    ,company_type -- 企业性质
    ,economic_nature -- 
    ,business_state -- 经营状态
    ,registered_capital -- 注册资本（万元）
    ,representative -- 法定代表人
    ,bloc_state -- 备用字段
    ,bloc_id -- 备用字段
    ,bloc_name -- 备用字段
    ,bloc_card_no -- 备用字段
    ,registered -- 注册地
    ,economic_scope -- 主营业务或经营范围
    ,east_relation_type -- 关联关系类型-EAST报表口径
    ,industry_code -- 所属行业-EAST报表口径
    ,rea_no -- 关联方成因编号
    ,rea_desc -- 关联方成因描述
    ,inst_org -- 监管机构
    ,remarks -- 备注信息
    ,data_state -- 数据状态
    ,effect_state -- 生效状态
    ,active_time -- 生效时间
    ,invalid_time -- 失效时间
    ,process_time -- 审核通过时间
    ,data_source -- 数据来源
    ,legal_org_code -- 独立法人编码
    ,create_user -- 创建人
    ,create_time -- 创建时间
    ,create_org -- 创建机构
    ,create_dep -- 创建部门
    ,update_user -- 修改人
    ,update_time -- 修改时间
    ,update_org -- 修改机构
    ,update_dep -- 修改部门
    ,wf_state -- 流程状态
    ,agree -- 同意标识
    ,process_instance_id -- 流程实例ID
    ,reserve1 -- 备用字段1
    ,reserve2 -- 备用字段2
    ,reserve3 -- 备用字段3
    ,data_dt -- 数据跑批日期
    ,cust_no -- 备用字段
    ,east_rp_bad_info -- 不良信息-east报表口径
    ,east_rp_economic_nature -- 经济性质和类型-east报表口径
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- ID
    ,bus_id -- 业务主键
    ,his_bus_id -- 关联的名单业务编号
    ,east_rp_type -- 关联方类型-EAST报表口径
    ,ybj_rp_type -- 关联方类型-银保监会口径
    ,rp_name -- 关联方名称
    ,ybj_card_type -- 
    ,east_card_type -- 证件类型-EAST报表口径
    ,card_no -- 证件号码
    ,domestic_state -- 境内外
    ,company_type -- 企业性质
    ,economic_nature -- 
    ,business_state -- 经营状态
    ,registered_capital -- 注册资本（万元）
    ,representative -- 法定代表人
    ,bloc_state -- 备用字段
    ,bloc_id -- 备用字段
    ,bloc_name -- 备用字段
    ,bloc_card_no -- 备用字段
    ,registered -- 注册地
    ,economic_scope -- 主营业务或经营范围
    ,east_relation_type -- 关联关系类型-EAST报表口径
    ,industry_code -- 所属行业-EAST报表口径
    ,rea_no -- 关联方成因编号
    ,rea_desc -- 关联方成因描述
    ,inst_org -- 监管机构
    ,remarks -- 备注信息
    ,data_state -- 数据状态
    ,effect_state -- 生效状态
    ,active_time -- 生效时间
    ,invalid_time -- 失效时间
    ,process_time -- 审核通过时间
    ,data_source -- 数据来源
    ,legal_org_code -- 独立法人编码
    ,create_user -- 创建人
    ,create_time -- 创建时间
    ,create_org -- 创建机构
    ,create_dep -- 创建部门
    ,update_user -- 修改人
    ,update_time -- 修改时间
    ,update_org -- 修改机构
    ,update_dep -- 修改部门
    ,wf_state -- 流程状态
    ,agree -- 同意标识
    ,process_instance_id -- 流程实例ID
    ,reserve1 -- 备用字段1
    ,reserve2 -- 备用字段2
    ,reserve3 -- 备用字段3
    ,data_dt -- 数据跑批日期
    ,cust_no -- 备用字段
    ,east_rp_bad_info -- 不良信息-east报表口径
    ,east_rp_economic_nature -- 经济性质和类型-east报表口径
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rptm_rtm_rp_his_legal
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rptm_rtm_rp_his_legal exchange partition p_${batch_date} with table ${iol_schema}.rptm_rtm_rp_his_legal_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rptm_rtm_rp_his_legal to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rptm_rtm_rp_his_legal_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rptm_rtm_rp_his_legal',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);