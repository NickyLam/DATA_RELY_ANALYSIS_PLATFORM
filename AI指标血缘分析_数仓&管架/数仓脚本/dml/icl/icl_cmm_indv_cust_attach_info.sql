/*
purpose:    共性加工层-个人客户补充信息:数据主要来源于ecif系统EIFS。
author:     sunline
usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_indv_cust_attach_info
createdate: 20200710
logs:       20221012 陈伟峰 新增模型
            20230626 徐子豪 新增字段【小微企业主证件类型、小微企业主证件号码、个体工商户证件类型、个体工商户证件号码】
            20231023 徐子豪 新增字段【收入币种、经营实体所属行业类型代码】
            20240127 饶雅 新增字段【最新更新时间、最新更新机构编号、最新更新渠道代码、最新更新柜员编号】
            20240227 饶雅 新增字段【信贷客户标识代码】
            20240918 陈伟峰 新增字段【跨境电商客户标志】
			20250415 陈  凭 新增字段【电话号码】
			20250508 陈  凭 新增字段【退役军人标志、无营业执照负责人标志】
			20250821 谢  宁 新增字段【单位电话号码】
			20250415 陈  凭 新增字段【信贷客户类型代码】
			                逻辑调整【无营业执照负责人标志】取数逻辑
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_indv_cust_attach_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_indv_cust_attach_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop temporary table cmm_indv_cust_attach_info_ex
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_indv_cust_attach_info_ex purge;

-- 2.1 create temporary table cmm_indv_cust_attach_info_ex
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_indv_cust_attach_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_indv_cust_attach_info where 0=1;

-- 2.2 insert into data to temporary table cmm_indv_cust_attach_info_ex

--第一组（共一组）个人客户补充信息

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_indv_cust_attach_info_ex(
		etl_dt                          -- 数据日期
		,lp_id                          -- 法人编号
        ,cust_id                        -- 客户编号
        ,cust_type_cd                   -- 客户类型
        ,cust_name                      -- 客户名称
		,move_num                       -- 电话号码
		,work_tel_num                   -- 单位电话号码
        ,family_farm_flg                -- 家庭农场标志
        ,mls_acct_flg                   -- 低保户标志
        ,disb_ps_flg                    -- 残疾人标志
		,ex_servsm_flg                  -- 退役军人标志
        ,no_buslics_prc_flg             -- 无营业执照负责人标志
        ,sm_bus_owner_cert_type         -- 小微企业主证件类型
        ,sm_bus_owner_cert_no           -- 小微企业主证件号码
        ,indv_bus_cert_type             -- 个体工商户证件类型
        ,indv_bus_cert_no               -- 个体工商户证件号码
        ,inco_curr                      -- 收入币种
        ,crdt_cust_flg_cd               -- 信贷客户标识代码
        ,crdt_cust_type_cd              -- 信贷客户类型代码
        ,cross_bor_cust_flg             -- 跨境电商客户标志
        ,mang_enty_bl_induty_type_cd    -- 经营实体所属行业类型代码
        ,latest_update_teller_id	    -- 最新更新柜员编号     
        ,latest_update_org_id	        -- 最新更新机构编号    
        ,latest_update_chn_cd	        -- 最新更新渠道代码    
        ,latest_update_tm	            -- 最新更新时间         
        ,job_cd                         -- 任务代码
		,etl_timestamp                  -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd') -- 数据日期
       ,t1.lp_id                           -- 法人编号
       ,t1.party_id                        -- 客户编号
       ,decode(t1.indv_party_type_cd,'1','PRIVATE_TYPE','3','GUARANTEE_PRI_TYPE','PRIVATE_TYPE') -- 客户类型
       ,t1.party_name                      -- 客户名称
	   ,t9.tel_num                         -- 电话号码
	   ,t12.tel_num                        -- 单位电话号码
       ,t2.attr_val                        -- 家庭农场标志
       ,t3.attr_val                        -- 低保户标志
       ,t4.attr_val                        -- 残疾人标志
	   ,nvl(trim(t10.attr_val),'-')        -- 退役军人标志
       ,case 
	      when t11.indtype = '06' then 
		  '1' 
		  else 
		  '0' 
		end                                -- 无营业执照负责人标志
       ,t1.sm_bus_owner_cert_type_cd       -- 小微企业主证件类型
       ,t1.sm_bus_owner_cert_no            -- 小微企业主证件号码
       ,t1.indv_bus_cert_type_cd           -- 个体工商户证件类型
       ,t1.indv_bus_cert_no                -- 个体工商户证件号码
       ,nvl(trim(t5.curr_cd),'-')          -- 收入币种
       ,t7.attr_val                        -- 信贷客户标识代码
       ,t11.indtype                        -- 信贷客户类型代码
       ,t8.attr_val                        -- 跨境电商客户标志
       ,nvl(trim(t5.indus_type_cd),'-')    -- 经营实体所属行业类型代码
       ,t6.last_updated_te                 -- 最新更新柜员编号
       ,t6.last_updated_org                -- 最新更新机构编号
       ,t6.last_system_id                  -- 最新更新渠道代码
       ,t6.last_updated_ts                 -- 最新更新时间
       ,t1.job_cd                          -- 任务代码                  
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- etl处理时间戳       
from ${iml_schema}.pty_indv t1
left join ${iml_schema}.pty_party_attr_h t2
  on t1.party_id = t2.party_id
 and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t2.job_cd = 'eifsf1'
 and t2.attr_name ='P0013'   --个人客户-家庭农场标志
left join ${iml_schema}.pty_party_attr_h t3
  on t1.party_id = t3.party_id
 and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t3.job_cd = 'eifsf1'
 and t3.attr_name ='P0004'   --个人客户-低保户标志
left join ${iml_schema}.pty_party_attr_h t4
  on t1.party_id = t4.party_id
 and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t4.job_cd = 'eifsf1'
 and t4.attr_name ='P0003'   --个人客户-残疾人标志
left join ${iml_schema}.pty_indv_ext_info t5
  on t1.party_id = t5.party_id
 and t5.start_dt<= to_date('${batch_date}','yyyymmdd')
 and t5.end_dt > to_date('${batch_date}','yyyymmdd')
 and t5.job_cd = 'eifsf1'
left join ${iol_schema}.eifs_t00_party_pub_info t6
  on t1.party_id = t6.cust_num
 and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t6.end_dt > to_date('${batch_date}','yyyymmdd')
left join ${iml_schema}.pty_party_attr_h t7
  on t1.party_id = t7.party_id
 and t7.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t7.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t7.job_cd = 'eifsf1'
 and t7.attr_name ='CD2437'   --信贷客户标识代码
left join ${iml_schema}.pty_party_attr_h t8
  on t1.party_id = t8.party_id
 and t8.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t8.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t8.job_cd = 'eifsf1'
 and t8.attr_name ='P0020'   --个人客户-跨境电商客户标志
left join ${iml_schema}.pty_tel_info_h t9
  on t1.party_id = t9.party_id
 and t9.job_cd = 'eifsf1'
 and t9.tel_type_cd = '05'  --移动电话
 and t9.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t9.end_dt > to_date('${batch_date}', 'yyyymmdd')
left join ${iml_schema}.pty_party_attr_h t10
  on t1.party_id = t10.party_id
 and t10.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t10.end_dt > to_date('${batch_date}','yyyymmdd')
 and t10.job_cd = 'eifsf1'
 and t10.attr_name ='P0022'   --个人客户-退役军人标志
left join ${iol_schema}.icms_ind_info t11
  on t11.customerid = t2.party_id
 and t11.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t11.end_dt > to_date('${batch_date}','yyyymmdd')
 --and t11.indtype = '06'  --无营业执照负责人标志
left join ${iml_schema}.pty_tel_info_h t12
  on t1.party_id = t12.party_id
 and t12.job_cd = 'eifsf1'
 and t12.tel_type_cd = '03'  --工作单位电话
 and t12.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t12.end_dt > to_date('${batch_date}', 'yyyymmdd')
where t1.indv_party_type_cd in ('1')
 and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t1.end_dt > to_date('${batch_date}','yyyymmdd')
 and t1.job_cd = 'eifsf1'
;
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_indv_cust_attach_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_indv_cust_attach_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_indv_cust_attach_info_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_indv_cust_attach_info', partname => 'p_${batch_date}', granularity => 'partition', degree => 8, cascade => true);