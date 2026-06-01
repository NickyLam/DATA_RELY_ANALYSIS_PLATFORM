/*
purpose:    共性加工层-行员信息表，数据主要来源UUSS统一用户系统的员工信息表
author:     sunline
usage:      python $ETL_HOME/script/main.py 20200930 icl_cmm_clerk_info
createdate: 20200812
logs:
            20200812 谢  宁  新增模型 
            20201229 陈伟峰  新增字段【岗位编号】、【岗位类别】、【岗位名称】
            20210205 周沁晖  新增字段【客户经理标志】【客户经理级别】【柜员级别代码】【柜员主管编号】【虚拟核算部门编号】【单位电话分机号】【传真国际区号】【传真分机号】【住宅电话国际区号】【住宅电话国内区号】【住宅电话】【住宅电话分机号】【移动电话号码1】【移动电话号码2】【移动电话号码3】【邮政编码】【所在省份】【所在地区】
                             共18个字段									
            20210426 谢  宁  调整字段【单位电话国际区号】取数逻辑
			      20210528 何桐金	 新增字段【对应钱箱编号】
			      20220419 朱觉军	 1、新增字段【职位代码】【职务类别编号】【职务名称】
			                       2、取数逻辑调整，涉及字段【柜员标志】【客户经理标志】【柜员编号】【职务代码】【岗位编号】【岗位类别】【岗位名称】【员工员工员工入职日期】【所属机构编号】共9个字段
			      20220511 朱觉军	1、取数逻辑调整，涉及字段【岗位编号】【岗位类别】【岗位名称】							
            20220513 朱觉军	1、取数逻辑调整，涉及字段【客户经理标志】
            20230303 陈伟峰 调整pty_teller_post_rela_info关联逻辑，智能网点刘和秒确认机构和柜员取岗位是唯一	
            20230605 陈伟峰 配合M层调整	pty_teller_post_rela_info表算法，增量流水->全量拉链
            20240423 饶雅   新增字段【离职状态代码】
            20251126 陈伟峰 新增字段【JOBS_DESCB2岗位描述2】

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_clerk_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_clerk_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop temporary table cmm_clerk_info_ex
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_clerk_info_ex purge;

-- 2.1 create temporary table cmm_clerk_info_ex
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_clerk_info_ex         
nologging                                                 
compress ${option_switch} for query high                  
as                                                        
select * from ${icl_schema}.cmm_clerk_info where 0=1;

-- 2.2 insert into data to temporary table cmm_clerk_info_ex

--第一组（共一组）行员信息表

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_clerk_info_ex(
        etl_dt                          -- 数据日期
        ,lp_id                          -- 法人编号
        ,clerk_id                       -- 行员编号
        ,clerk_name                     -- 行员名称
        ,teller_flg                     -- 柜员标志
        ,cust_mgr_flg                   -- 客户经理标志
        ,cust_mgr_lev                   -- 客户经理级别
        ,teller_lev_cd                  -- 柜员级别代码
        ,teller_director_id             -- 柜员主管编号
        ,teller_id                      -- 柜员编号
        ,region_acct_num                -- 域账号
        ,emply_type_cd                  -- 员工类型代码
        ,cert_type_cd                   -- 证件类型代码
        ,cert_no                        -- 证件号码
        ,gender_cd                      -- 性别代码
        ,birth_dt                       -- 出生日期
        ,nationty_cd                    -- 民族代码
        ,politic_status_cd              -- 政治面貌代码
        ,marriage_situ_cd               -- 婚姻状况代码
        ,edu_cd                         -- 学历代码
		,postn_cd                       -- 职位代码
        ,post_cd                        -- 职务代码
		,post_cate_id                   -- 职务类别编号
        ,post_name                      -- 职务名称
        ,title_cd                       -- 职称代码
        ,jobs_cd                        -- 岗位编号
        ,jobs_cate                      -- 岗位类别
        ,jobs_name                      -- 岗位名称
		,jobs_id	                    -- 岗位代码
        ,jobs_descb	                    -- 岗位描述
        ,jobs_descb2	                -- 岗位描述2
        ,fir_work_dt                    -- 首次工作日期
        ,empyt_dt                       -- 员工员工员工入职日期
        ,local_dept_id                  -- 所属部门编号
        ,dimission_dt                   -- 离职日期
        ,dimission_status_cd            -- 离职状态代码
        ,emply_status_cd                -- 员工状态代码
        ,emply_sys_status_cd            -- 员工系统状态代码
        ,belong_org_id                  -- 所属机构编号
        ,vtual_accti_org_id             -- 虚拟核算机构编号
        ,work_tel_inter_area_cd         -- 单位电话国际区号
        ,work_tel_area_cd               -- 单位电话区号
        ,work_tel_num                   -- 单位电话号码
        ,work_tel_ext_num               -- 单位电话分机号
        ,fax_area_cd                    -- 传真区号
        ,fax_inter_area_cd              -- 传真国际区号
        ,fax_num                        -- 传真号码
        ,fax_ext_num                    -- 传真分机号   
        ,resd_tel_inter_area_cd         -- 住宅电话国际区号
        ,resd_tel_dom_area_cd           -- 住宅电话国内区号
        ,resd_tel                       -- 住宅电话    
        ,resd_tel_ext_num               -- 住宅电话分机号
        ,mobile_phone_num               -- 移动电话号码
        ,mobile_phone_num_1             -- 移动电话号码1
        ,mobile_phone_num_2             -- 移动电话号码2
        ,mobile_phone_num_3             -- 移动电话号码3
        ,cty_cd                         -- 员工国籍代码
        ,zip_cd                         -- 邮政编码
        ,local_prov                     -- 所在省份
        ,site                           -- 所在地区
        ,dtl_addr                       -- 详细地址
        ,e_mail_addr                    -- 电子邮箱地址
        ,ding_talk_user_id              -- 钉钉用户编号        
        ,job_cd                         -- 任务代码            
        ,etl_timestamp                  -- 数据处理时间          
)                             
select 
    to_date('${batch_date}','yyyymmdd')                                                   -- 数据日期   
    ,t1.lp_id                                                                             -- 法人编号         
    ,t1.emply_id                                                                          -- 行员编号
    ,t1.last_name||t1.first_name                                                          -- 行员名称
    ,case when t1.main_teller_id <> ' ' then '1' else '0' end                             -- 柜员标志
    ,case when t7.jobs_id in ('2017','3005') then '1' --分行客户经理，支行客户经理           
       when t9.managertype <> ' ' then '1'
       else '0' end                                                -- 客户经理标志
    ,t9.managerlevel                                               -- 客户经理级别
    ,t9.tellerlevel                                                -- 柜员级别代码
    ,t9.tellermanagerid                                            -- 柜员主管编号
    ,t1.main_teller_id                                             -- 柜员编号
    ,t1.region_acct_num                                            -- 域账号
    ,t1.emply_type_cd                                              -- 员工类型代码
    ,t3.cert_type_cd                                               -- 证件类型代码
    ,t3.cert_num                                                   -- 证件号码
    ,t1.gender_cd                                                  -- 性别代码
    ,t1.birth_dt                                                   -- 出生日期
    ,t1.nationty_cd                                                -- 民族代码
    ,t1.politic_status_cd                                          -- 政治面貌代码
    ,t1.marriage_situ_cd                                           -- 婚姻状况代码
    ,t1.edu_cd                                                     -- 学历代码
    ,t1.postn_cd                                                   -- 职位代码
    ,t1.post_cd                                                    -- 职务代码
    ,t6.post_cate_id                                               -- 职务类别编号  
    ,t6.post_name                                                  -- 职务名称
    ,t1.title_cd                                                   -- 职称代码	
    ,t7.jobs_id                                                    -- 岗位编号
    ,t7.jobs_type_cd                                               -- 岗位类别
    ,t7.jobs_name                                                  -- 岗位名称
	,t1.post_type_id	                                           -- 岗位代码
    ,t1.post_type_name	                                           -- 岗位描述
    ,t1.post_descb	                                               -- 岗位描述
    ,t1.join_work_dt                                               -- 首次工作日期
    ,t1.empyt_dt                                                   -- 员工员工员工入职日期
    ,t1.belong_dept_id                                             -- 所属部门编号
    ,t1.dimission_dt                                               -- 离职日期
    ,t1.dimission_apv_status_cd                                    -- 离职状态代码
    ,t1.emply_status_cd                                            -- 员工状态代码
    ,t1.emply_sys_status_cd                                        -- 员工系统状态代码
    ,t1.belong_dept_id                                             -- 所属机构编号
    ,t1.vtual_accti_dept_id                                        -- 虚拟核算机构编号
    ,t1.work_tel_inter_area_cd                                     -- 单位电话国际区号
    ,t1.work_tel_dom_area_cd                                       -- 单位电话区号
    ,t1.work_tel_num                                               -- 单位电话号码
    ,t9.companysubphone                                            -- 单位电话分机号
    ,t1.fax_dom_area_cd                                            -- 传真区号
    ,t9.fixcountrycode                                             -- 传真国际区号
    ,t1.fax_num                                                    -- 传真号码
    ,t9.fixsubphone                                                -- 传真分机号   
    ,t9.housecountrycode                                           -- 住宅电话国际区号
    ,t9.houseareacode                                              -- 住宅电话国内区号
    ,t9.homephone                                                  -- 住宅电话    
    ,t9.housesubphone                                              -- 住宅电话分机号
    ,t1.mobile_phone_num                                           -- 移动电话号码
    ,t1.mobile_phone_num_2                                         -- 移动电话号码1
    ,t9.mobile2                                                    -- 移动电话号码2
    ,t9.mobile3                                                    -- 移动电话号码3
    ,t1.cty_cd                                                     -- 员工国籍代码
    ,t9.post                                                       -- 邮政编码
    ,nvl(trim(t9.province),'XXXXXX')                               -- 所在省份
    ,nvl(trim(t9.city),'XXXXXX')                                   -- 所在地区
    ,t1.resd_addr                                                  -- 详细地址
    ,t4.elec_addr                                                  -- 电子邮箱地址
    ,t5.elec_addr                                                  -- 钉钉用户编号                                      
    ,t1.job_cd                                                     -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳  
 from ${iml_schema}.pty_emply t1
 left join ${iml_schema}.pty_party_status_h t2
   on t1.party_id = t2.party_id  
  and t2.party_status_type_cd = 'CD1515' 
  and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t2.job_cd = 'uussf1'
 left join ${iml_schema}.pty_party_cert_info_h t3
   on t1.party_id = t3.party_id
  and t3.sorc_sys_cd = 'UUSS'
  and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t3.end_dt > to_date('${batch_date}', 'yyyymmdd') 
  and t3.job_cd = 'uussf1'
 left join ${iml_schema}.pty_party_elec_addr_h t4
   on t1.party_id = t4.party_id
  and t4.elec_addr_type_cd = '01' --邮箱地址
  and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t4.end_dt > to_date('${batch_date}', 'yyyymmdd') 
  and t4.job_cd = 'uussf1'
 left join ${iml_schema}.pty_party_elec_addr_h t5
   on t1.party_id = t5.party_id
  and t5.elec_addr_type_cd = '10' --钉钉
  and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t5.end_dt > to_date('${batch_date}', 'yyyymmdd') 
  and t5.job_cd = 'uussf1' 
 /*left join ${iol_schema}.uuss_uus_place t6 
 on t1.post_cd = t6.placecode
 and t6.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t6.end_dt > to_date('${batch_date}', 'yyyymmdd') 
 */
 left join ${iml_schema}.ref_emply_post_para t6			
   on t1.post_cd = t6.post_id	
  and t6.create_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t6.job_cd = 'uussf1'	
  and t6.id_mark <> 'D'
 left join ${iml_schema}.pty_teller_info_h t31	--		
   on t1.emply_id = t31.teller_id
  and t31.job_cd = 'nibsf1'
  and t31.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t31.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iml_schema}.pty_teller_post_rela_info t8 --iol.t4			-- 20220823 zhairp 增量批应急
   on t31.org_id = t8.org_id
  and t31.teller_id= t8.teller_id
  and t8.job_cd = 'nibsf1'
  and t8.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t8.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iml_schema}.ref_teller_jobs_info_h t7 --iol.t5		
   on t7.jobs_id = t8.post_id	
  and t7.job_cd = 'nibsf1'
  and t7.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t7.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.uuss_uus_employee t9
   on t1.emply_id = t9.employeeid
  and t9.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t9.end_dt > to_date('${batch_date}', 'yyyymmdd')
where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t1.job_cd = 'uussf1'
  and t1.id_mark <> 'D';   
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_clerk_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_clerk_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_clerk_info_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_clerk_info',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);
