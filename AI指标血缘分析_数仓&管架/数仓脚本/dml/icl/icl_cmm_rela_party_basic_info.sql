/*
purpose:    共性加工层-关联方基本信息表:关联方基本信息，数据主要来源关联方系统对公关联方信息表、关联方状态表、个人关联方信息表、关联方关系信息表
author:     sunline
usage:      python $etl_home/script/main.py yyyymmdd cmm_rela_party_basic_info
createdate: 20200612
logs:       20240126 关联方系统改造
            20240511 修改当事人和关联方的口径
		      	20251023 谢宁 新增字段【当事人一表通经济类型代码、当事人一表通不良信息、关联方一表通经济类型代码、关联方一表通不良信息】
		      	20260429 陈凭 新增字段【当事人关系有效标志、当事人关系生效日期、当事人关系失效日期、关联方关系有效标志、关联方关系生效日期、关联方关系失效日期】
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_rela_party_basic_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_rela_party_basic_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop temporary table cmm_rela_party_basic_info_ex
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_rela_party_basic_info_ex purge;

-- 2.1 create temporary table cmm_rela_party_basic_info_ex
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_rela_party_basic_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_rela_party_basic_info where 0=1;

-- 2.2 insert into data to temporary table cmm_rela_party_basic_info_ex

--第一组（共两组）个人、华兴当事人关联个人信息

insert /*+ append */ into ${icl_schema}.cmm_rela_party_basic_info_ex(
	      etl_dt                                 -- 数据日期
	     ,lp_id                                  -- 法人编号
	     ,party_id                               -- 当事人编号
	     ,party_name                             -- 当事人名称
	     ,party_type_cd                          -- 当事人类型代码
       ,party_cert_type_cd_1       	           -- 当事人证件类型代码1
       ,party_cert_id_1            	           -- 当事人证件编号1
       ,party_cert_type_cd_2       	           -- 当事人证件类型代码2
       ,party_cert_id_2            	           -- 当事人证件编号2
       ,party_belong_org_id        	           -- 当事人归属机构编号
       ,party_belong_dept_id       	           -- 当事人所属部门编号
       ,party_kins_rela_cd         	           -- 当事人亲属关系代码
       ,party_org_cd               	           -- 当事人组织代码
       ,party_belong_corp_name                 -- 当事人所属公司名称
       ,party_post_name                        -- 当事人职务名称
       ,party_ghb_post_name                    -- 当事人本行职务名称
       ,party_share_ratio                      -- 当事人持股比例
       ,party_dom_overs_flg                    -- 当事人境内外标志
	     ,party_east_econ_type_cd                -- 当事人一表通经济类型代码
       ,party_east_non_info                    -- 当事人一表通不良信息
       ,party_status_cd	                       -- 当事人关系有效标志
       ,party_effect_dt	                       -- 当事人关系生效日期
       ,party_invalid_dt                       -- 当事人关系失效日期
       ,rela_type_cd                           -- 关系类型代码
       ,rela_status_cd                         -- 关系状态代码
       ,rela_effect_dt                         -- 关系生效日期
       ,rela_invalid_dt                        -- 关系失效日期
       ,rela_party_id                          -- 关联方编号
       ,rela_party_name                        -- 关联方名称
       ,rela_party_cert_type_cd_1              -- 关联方证件类型代码1
       ,rela_party_cert_id_1                   -- 关联方证件编号1
       ,rela_party_cert_type_cd_2              -- 关联方证件类型代码2
       ,rela_party_cert_id_2       		         -- 关联方证件编号2
       ,rela_party_belong_org_id   		         -- 关联方归属机构编号
       ,rela_party_belong_dept_id  		         -- 关联方所属部门编号
       ,rela_party_kins_rela_cd    		         -- 关联方亲属关系代码
       ,rela_party_org_cd          		         -- 关联方组织代码
       ,rela_party_belong_corp_name		         -- 关联方所属公司名称
       ,rela_party_post_name       		         -- 关联方职务名称
       ,rela_party_ghb_post_name   		         -- 关联方本行职务名称
       ,rela_party_share_ratio     		         -- 关联方持股比例
       ,rela_party_dom_overs_flg               -- 关联方境内外标志
	     ,rela_east_econ_type_cd                 -- 关联方一表通经济类型代码
       ,rela_east_non_info                     -- 关联方一表通不良信息
       ,rela_party_status_cd	                 -- 关联方关系有效标志
       ,rela_party_effect_dt	                 -- 关联方关系生效日期
       ,rela_party_invalid_dt	                 -- 关联方关系失效日期
       ,shard_or_rela_party_type_cd            -- 股东或关联方类型代码
       ,shard_or_rela_party_bl_induty_cd       -- 股东或关联方所属行业代码
       ,shard_or_rela_party_rgst_addr          -- 股东或关联方注册地址
       ,shard_or_rela_party_rela_type_cd       -- 股东或关联方关系类型代码
       ,mgmt_rela_type_cd                      -- 管理关系类型代码
	     ,create_tm                              -- 创建时间
	     ,final_update_tm                        -- 最后更新时间
		   ,job_cd                                 -- 任务代码
		   ,etl_timestamp                          -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                                             -- 数据日期
       ,'9999'                                                                                         -- 法人编号
       ,t1.super_rela_party_id                                                                         -- 当事人编号
       ,nvl(t2.rela_party_name,' ')                                        	                           -- 当事人名称
       ,'1'                                                                                            -- 当事人类型代码
       ,nvl(trim(t2.ybj_cert_type_cd),' ')                                                             -- 当事人证件类型代码1
       ,nvl(trim(t2.cert_no),' ')                                     	                               -- 当事人证件编号1
       ,' '                                                                                            -- 当事人证件类型代码2
       ,' '                                   	                                                       -- 当事人证件编号2
       ,nvl(t2.create_org_id,' ')                                         	                           -- 当事人归属机构编号
       ,nvl(t2.create_org_id,' ')                                        	                             -- 当事人所属部门编号
       ,' '                                            	                                               -- 当事人亲属关系代码
       ,nvl(t2.create_org_id,' ')                                       	                             -- 当事人组织代码
       ,' '                                       	                                                   -- 当事人所属公司名称
       ,' '                                       	                                                   -- 当事人职务名称
       ,nvl(t2.ghb_post_id,' ')                                               	                       -- 当事人本行职务名称
       ,t1.hold_ratio                                 	                                               -- 当事人持股比例
       ,nvl(trim(t2.dom_overs_idf_cd),'0')                                                             -- 当事人境内外标志
	     ,t2.rrp_rela_party_type_cd                                                                      -- 当事人一表通经济类型代码
       ,t2.rrp_non_type_cd                                                                             -- 当事人一表通不良信息
       ,t2.status_cd	                                                                                 -- 当事人关系有效标志
       ,t2.effect_tm	                                                                                 -- 当事人关系生效日期
       ,t2.invalid_tm                                                                                  -- 当事人关系失效日期
       ,t1.incid_rela_comnt                                	                                           -- 关系类型代码
       ,nvl(t1.valid_flg,'-')                                                   	                     -- 关系状态代码
       ,t1.effect_tm                                                                                   -- 关系生效日期
       ,t1.invalid_tm                                                                                  -- 关系失效日期
       ,t1.this_rela_party_bus_id                                               	                     -- 关联方编号
       ,coalesce(trim(t3.rela_party_name),trim(t4.rela_party_name))                                    -- 关联方名称
       ,coalesce(trim(t3.ybj_cert_type_cd),trim(t4.ybj_cert_type_cd),'0000')                           -- 关联方证件类型代码1
       ,coalesce(trim(t3.cert_no),trim(t4.cert_no))              	                                     -- 关联方证件编号1
       ,' '	                                                                                           -- 关联方证件类型代码2
       ,' '          	                                                                                 -- 关联方证件编号2
       ,nvl(trim(t3.create_org_id),trim(t4.create_org_id))                         	                   -- 关联方归属机构编号
       ,nvl(trim(t3.create_org_id),trim(t4.create_org_id))                        	                   -- 关联方所属部门编号
       ,' '                                      	                                                     -- 关联方亲属关系代码
       ,nvl(trim(t3.create_org_id),trim(t4.create_org_id))                     	                       -- 关联方组织代码
       ,''                       	                                                                     -- 关联方所属公司名称
       ,nvl(trim(t3.ghb_post_id),' ')                                 	                               -- 关联方职务名称
       ,nvl(trim(t3.ghb_post_id),' ')                                         	                       -- 关联方本行职务名称
       ,' '         	                                                                                 -- 关联方持股比例
       ,coalesce(trim(t3.dom_overs_idf_cd),trim(t4.dom_overs_idf_cd),'0')                              -- 关联方境内外标志
	     ,nvl(trim(t3.rrp_rela_party_type_cd),trim(t4.rrp_rela_party_type_cd))                           -- 关联方一表通经济类型代码
       ,nvl(trim(t3.rrp_non_type_cd),trim(t4.rrp_non_type_cd))                                         -- 关联方一表通不良信息
       ,coalesce(trim(t3.status_cd),trim(t4.status_cd),'-')	                                           -- 关联方关系有效标志
       ,coalesce(trim(t3.effect_tm),trim(t4.effect_tm),null)	                                         -- 关联方关系生效日期
       ,coalesce(trim(t3.invalid_tm),trim(t4.invalid_tm),null)	                                       -- 关联方关系失效日期
       ,nvl(trim(t3.east_rela_party_type_cd),trim(t4.east_rela_party_type_cd))                         -- 股东或关联方类型代码
       ,nvl(trim(t4.bl_induty_type_cd),' ')                                                            -- 股东或关联方所属行业代码
       ,nvl(trim(t4.rgst_addr),' ')                                                                    -- 股东或关联方注册地址
       ,nvl(trim(t3.east_rela_party_rela_type_cd),trim(t4.east_incid_rela_type_cd))                    -- 股东或关联方关系类型代码
       ,t1.and_super_incid_rela_type_cd                                                                -- 管理关系类型代码
	     ,t1.create_tm                                                                                   -- 创建时间
	     ,null                                                                                            -- 最后更新时间
       ,' '                                                       				                             -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                                -- etl处理时间戳
from ${iml_schema}.pty_rp_rela_h t1
	inner  join ${iml_schema}.pty_rp_naturer_info_h t2
	  on t2.rela_party_id =t1.super_rela_party_id
   and t2.effect_status_cd='1'
	 and t2.etl_dt=to_date('${batch_date}','yyyymmdd')
	 and t2.job_cd='rptmi1'
left join ${iml_schema}.pty_rp_naturer_info_h t3
	  on t1.this_rela_party_bus_id=t3.rela_party_id
	 and t3.effect_status_cd='1'
	 and t3.etl_dt=to_date('${batch_date}','yyyymmdd')
	 and t3.job_cd='rptmi1'
left join ${iml_schema}.pty_rp_lp_info_h t4
    on t4.rela_party_id = t1.this_rela_party_bus_id
   and t4.effect_status_cd='1'
   and t4.etl_dt=to_date('${batch_date}','yyyymmdd')
   and t4.job_cd='rptmi1'
where  t1.super_rela_party_id not in (select cc.rela_party_id from ${iml_schema}.pty_rp_lp_info_h cc)
   and t1.valid_flg='1'
   --and t1.super_rela_party_id<>'广东华兴银行'
   and t1.etl_dt=to_date('${batch_date}','yyyymmdd')
   and t1.job_cd='rptmi1'

;

commit;


--第二组 公司当事人关联个人、公司方（共二组）

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_rela_party_basic_info_ex(
		   etl_dt                               -- 数据日期
		   ,lp_id                               -- 法人编号
		   ,party_id                            -- 当事人编号
		   ,party_name                          -- 当事人名称
		   ,party_type_cd                       -- 当事人类型代码
       ,party_cert_type_cd_1                -- 当事人证件类型代码1
       ,party_cert_id_1                     -- 当事人证件编号1
       ,party_cert_type_cd_2                -- 当事人证件类型代码2
       ,party_cert_id_2                     -- 当事人证件编号2
       ,party_belong_org_id                 -- 当事人归属机构编号
       ,party_belong_dept_id                -- 当事人所属部门编号
       ,party_kins_rela_cd                  -- 当事人亲属关系代码
       ,party_org_cd                        -- 当事人组织代码
       ,party_belong_corp_name              -- 当事人所属公司名称
       ,party_post_name                     -- 当事人职务名称
       ,party_ghb_post_name                 -- 当事人本行职务名称
       ,party_share_ratio                   -- 当事人持股比例
       ,party_dom_overs_flg                 -- 当事人境内外标志
	     ,party_east_econ_type_cd             -- 当事人一表通经济类型代码
       ,party_east_non_info                 -- 当事人一表通不良信息
       ,party_status_cd	                    -- 当事人关系有效标志
       ,party_effect_dt	                    -- 当事人关系生效日期
       ,party_invalid_dt                    -- 当事人关系失效日期
       ,rela_type_cd                        -- 关系类型代码
       ,rela_status_cd                      -- 关系状态代码
       ,rela_effect_dt                      -- 关系生效日期
       ,rela_invalid_dt                     -- 关系失效日期
       ,rela_party_id                       -- 关联方编号
       ,rela_party_name                     -- 关联方名称
       ,rela_party_cert_type_cd_1           -- 关联方证件类型代码1
       ,rela_party_cert_id_1                -- 关联方证件编号1
       ,rela_party_cert_type_cd_2           -- 关联方证件类型代码2
       ,rela_party_cert_id_2                -- 关联方证件编号2
       ,rela_party_belong_org_id            -- 关联方归属机构编号
       ,rela_party_belong_dept_id           -- 关联方所属部门编号
       ,rela_party_kins_rela_cd             -- 关联方亲属关系代码
       ,rela_party_org_cd                   -- 关联方组织代码
       ,rela_party_belong_corp_name         -- 关联方所属公司名称
       ,rela_party_post_name                -- 关联方职务名称
       ,rela_party_ghb_post_name            -- 关联方本行职务名称
       ,rela_party_share_ratio              -- 关联方持股比例
       ,rela_party_dom_overs_flg            -- 关联方境内外标志
	     ,rela_east_econ_type_cd              -- 关联方一表通经济类型代码
       ,rela_east_non_info                  -- 关联方一表通不良信息
       ,rela_party_status_cd	              -- 关联方关系有效标志
       ,rela_party_effect_dt	              -- 关联方关系生效日期
       ,rela_party_invalid_dt	              -- 关联方关系失效日期
       ,shard_or_rela_party_type_cd         -- 股东或关联方类型代码
       ,shard_or_rela_party_bl_induty_cd    -- 股东或关联方所属行业代码
       ,shard_or_rela_party_rgst_addr       -- 股东或关联方注册地址
       ,shard_or_rela_party_rela_type_cd    -- 股东或关联方关系类型代码
       ,mgmt_rela_type_cd                   -- 管理关系类型代码
	     ,create_tm                           -- 创建时间
	     ,final_update_tm                     -- 最后更新时间
		   ,job_cd                              -- 任务代码
		   ,etl_timestamp                       -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                                -- 数据日期
       ,'9999'                                                                            -- 法人编号
       ,t1.super_rela_party_id                                              	            -- 当事人编号
       ,nvl(t1.super_rela_party_name,' ')                                            	    -- 当事人名称
       ,'2'	                                                                              -- 当事人类型代码
       ,nvl(t1.super_cert_type_cd,'0000')                                                 -- 当事人证件类型代码1
       ,nvl(t1.super_cert_no,'')                                     	                    -- 当事人证件编号1
       ,' '                                                                               -- 当事人证件类型代码2
       ,' '                                  	                                            -- 当事人证件编号2
       ,nvl(t2.create_org_id,' ')                                           	            -- 当事人归属机构编号
       ,nvl(t2.create_org_id,' ')                                          	              -- 当事人所属部门编号
       ,' '                                                               	              -- 当事人亲属关系代码
       ,nvl(t2.create_org_id,' ')                                         	              -- 当事人组织代码
       ,' '                                           	                                  -- 当事人所属公司名称
       ,' '                                                               	              -- 当事人职务名称
       ,' '                                                           	                  -- 当事人本行职务名称
       ,t1.hold_ratio                                  	                                  -- 当事人持股比例
       ,nvl(trim(t2.dom_overs_idf_cd),'0')                                                -- 当事人境内外标志
	     ,t2.rrp_rela_party_type_cd                                                         -- 当事人一表通经济类型代码
       ,t2.rrp_non_type_cd                                                                -- 当事人一表通不良信息
       ,t2.status_cd	                                                                    -- 当事人关系有效标志
       ,t2.effect_tm	                                                                    -- 当事人关系生效日期
       ,t2.invalid_tm                                                                     -- 当事人关系失效日期
       ,t1.incid_rela_comnt                                  	                            -- 关系类型代码
       ,nvl(t1.valid_flg,'-')                                                    	        -- 关系状态代码
       ,t1.effect_tm                                                                      -- 关系生效日期
       ,t1.invalid_tm                                                                     -- 关联失效日期
       ,t1.this_rela_party_bus_id                                                 	      -- 关联方编号
       ,coalesce(trim(t3.rela_party_name),trim(t4.rela_party_name))                       -- 关联方名称
       ,coalesce(trim(t3.ybj_cert_type_cd),trim(t4.ybj_cert_type_cd),'0000')              -- 关联方证件类型代码1
       ,coalesce(trim(t3.cert_no),trim(t4.cert_no))                                       -- 关联方证件编号1
       ,' '                                                                               -- 关联方证件类型代码2
       ,' '            	                                                                  -- 关联方证件编号2
       ,nvl(trim(t3.create_org_id),trim(t4.create_org_id))                           	    -- 关联方归属机构编号
       ,nvl(trim(t3.create_org_id),trim(t4.create_org_id))                          	    -- 关联方所属部门编号
       ,' '                                        	                                      -- 关联方亲属关系代码
       ,nvl(trim(t3.create_org_id),trim(t4.create_org_id))                       	        -- 关联方组织代码
       ,''                         	                                                      -- 关联方所属公司名称
       ,nvl(trim(t4.ghb_post_id),' ')                                   	                -- 关联方职务名称
       ,nvl(trim(t4.ghb_post_id),' ')                                           	        -- 关联方本行职务名称
       ,' '            	                                                                  -- 关联方持股比例
       ,coalesce(trim(t3.dom_overs_idf_cd),trim(t4.dom_overs_idf_cd),'0')                 -- 关联方境内外标志
	     ,nvl(trim(t3.rrp_rela_party_type_cd),trim(t4.rrp_rela_party_type_cd))              -- 关联方一表通经济类型代码
       ,nvl(trim(t3.rrp_non_type_cd),trim(t4.rrp_non_type_cd))                            -- 关联方一表通不良信息
       ,coalesce(trim(t3.status_cd),trim(t4.status_cd),'-')	                              -- 关联方关系有效标志
       ,coalesce(trim(t3.effect_tm),trim(t4.effect_tm),null)	                            -- 关联方关系生效日期
       ,coalesce(trim(t3.invalid_tm),trim(t4.invalid_tm),null)	                          -- 关联方关系失效日期
       ,nvl(trim(t3.east_rela_party_type_cd),trim(t4.east_rela_party_type_cd))            -- 股东或关联方类型代码         
       ,nvl(trim(t3.bl_induty_type_cd),' ')                                               -- 股东或关联方所属行业代码    
       ,nvl(trim(t3.rgst_addr),' ')                                                       -- 股东或关联方注册地址        
       ,nvl(trim(t3.east_incid_rela_type_cd),trim(t4.east_rela_party_rela_type_cd))       -- 股东或关联方关系类型代码 
       ,t1.and_super_incid_rela_type_cd                                                   -- 管理关系类型代码
	     ,t1.create_tm                                                                      -- 创建时间
	     ,null                                                                              -- 最后更新时间  
       ,' '                                                         				              -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')                    -- etl处理时间戳
from ${iml_schema}.pty_rp_rela_h t1
left join ${iml_schema}.pty_rp_lp_info_h t2
  on t2.rela_party_id=t1.super_rela_party_id
 and t2.effect_status_cd='1'
 and t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.job_cd='rptmi1'
left join ${iml_schema}.pty_rp_lp_info_h t3
  on t1.this_rela_party_bus_id=t3.rela_party_id
 and t3.effect_status_cd='1'
 and t3.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t3.job_cd='rptmi1'
left join ${iml_schema}.pty_rp_naturer_info_h t4
  on t1.this_rela_party_bus_id=t4.rela_party_id
 and t4.effect_status_cd='1'
 and t4.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t4.job_cd='rptmi1'
where t1.super_rela_party_id not in (select cc.rela_party_id from ${iml_schema}.pty_rp_naturer_info_h cc)
  and t1.valid_flg='1'
  and t1.etl_dt=to_date('${batch_date}','yyyymmdd')
  and t1.job_cd='rptmi1'
  and t1.super_rela_party_type_cd='1'
;

commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_rela_party_basic_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_rela_party_basic_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_rela_party_basic_info_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_rela_party_basic_info', partname => 'p_${batch_date}', granularity => 'partition', degree => 8, cascade => true);