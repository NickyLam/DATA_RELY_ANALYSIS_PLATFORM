/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rptm_rtm_rp_his_natural
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
	            where table_name = upper('rptm_rtm_rp_his_natural_bak${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('rptm_rtm_rp_his_natural')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table rptm_rtm_rp_his_natural drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table rptm_rtm_rp_his_natural add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';
end loop;
end;
/
insert /*+ append */ into ${iol_schema}.rptm_rtm_rp_his_natural(
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
    ,rea_no -- 关联方成因
    ,rea_desc -- 关联方成因描述
    ,inst_org -- 监管机构
    ,east_relation_type -- 关联关系类型-EAST报表口径
    ,org_type -- 金融机构类型
    ,bloc_state -- 备用字段
    ,bloc_id -- 备用字段
    ,bloc_name -- 备用字段
    ,bloc_card_no -- 备用字段
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
    ,duty -- 本行职务/岗位
    ,cust_no -- 职务编号
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
    ,rea_no -- 关联方成因
    ,rea_desc -- 关联方成因描述
    ,inst_org -- 监管机构
    ,east_relation_type -- 关联关系类型-EAST报表口径
    ,org_type -- 金融机构类型
    ,bloc_state -- 备用字段
    ,bloc_id -- 备用字段
    ,bloc_name -- 备用字段
    ,bloc_card_no -- 备用字段
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
    ,duty -- 本行职务/岗位
    ,cust_no -- 职务编号
    ,' ' as east_rp_bad_info -- 不良信息-east报表口径
    ,' ' as east_rp_economic_nature -- 经济性质和类型-east报表口径
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from rptm_rtm_rp_his_natural_bak${batch_date}

commit;
