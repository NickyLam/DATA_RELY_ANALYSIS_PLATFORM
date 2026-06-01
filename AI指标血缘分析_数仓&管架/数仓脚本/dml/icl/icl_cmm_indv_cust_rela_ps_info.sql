 	/*
Purpose:    共性加工层-个人客户关联人信息：数据主要来源于ecif系统，包括我行客户类型为个人客户、临时个人客户、个人担保客户对应的关联人信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20210331 icl_cmm_indv_cust_rela_ps_info
Createdate: 20201017 谢  宁 
Logs:				
            20201017 谢  宁 陈伟峰 建模
            20210324 陈伟峰 修改关联人国籍取值逻辑（自然人部分），从pty_corp取（eifs2.0补充迁移）
            20220608 翟若平	1、调整第一组中字段【关联人电话分机号码】的取数口径
                            2、调整第二组的取数数据源，由原对公信贷系统调整为综合信贷系统
            20220708 温旺清 1、调整第二组中增加关联表CR-客户关联关系
                            2、调整第二组中T2表的关联条件【T1.MAINCUSTOMERID = T2.CUSTOMERID  -》 CR.CUSTOMERID = T2.CUSTOMERID】
                            3、调整第二组中T4表的关联条件【T2.CUST_ID = T4.CUSTOMERID  -》 T1.CUSTOMERID = T4.CUSTOMERID】
                            4、修改第一组的临时表t8  pty_party_elec_addr_h->pty_tel_info_h						
            20220714 曹永茂 1、调整第二组的字段【关联类型代码】的取数逻辑，有转码改为直取
                            2、调整第二组的过滤条件，【RELATIONSHIP = '101' -> RELATIONSHIP = '20101'】 
            20220805 曹永茂 1、增加第二组的过滤条件，(cr.relationship like '03%' or cr.relationship like '201%')，其中 '03%' 是未落标码值
            20220810 温旺清 1、调整【关联人行政区划代码】的取数逻辑		
            20220825 曹永茂 1、调整第二组CR表的关联条件：cr.relationship like '201%' -》 cr.relationship ='100'	
                            2、调整第二组【关联人客户编号】【关联人编号】的取数口径
            20220915 温旺清 取消第二组综合信贷系统数据来源，只从EIFS系统取。
            20221124 温旺清 根据新一代tel_type_cd代码映射调整关联人电话号码的口径
            20230307 温旺清 关联表pty_party_status_h增加状态类型代码条件
			20250407 陈  凭 新增字段【关联人创建时间、关联人录入系统时间】

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_indv_cust_rela_ps_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_indv_cust_rela_ps_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_indv_cust_rela_ps_info_ex purge;

-- 1.2 create table for exchage and add partition
		
-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_indv_cust_rela_ps_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_indv_cust_rela_ps_info where 0=1;


--第一组（共一组）EIFS个人关联人信息
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_indv_cust_rela_ps_info_ex(
   etl_dt                    	                                                    --数据日期     
   ,lp_id                    	                                                    --法人编号     
	 ,cust_id                  	                                                    --客户编号       
	 ,rela_ps_cust_id          	                                                    --关联人客户编号  
	 ,rela_ps_id                                                                    --关联人编号  
	 ,rela_type_cd             	                                                    --关联类型代码     
	 ,rela_ps_name             	                                                    --关联人姓名      
	 ,rela_ps_cert_type_cd     	                                                    --关联人证件类型代码  
	 ,rela_ps_cert_no          	                                                    --关联人证件号码    
	 ,rela_ps_gender_cd        	                                                    --关联人性别代码    
	 ,rela_ps_birth_dt         	                                                    --关联人出生日期    
	 ,rela_ps_nati_place       	                                                    --关联人籍贯      
	 ,rela_ps_nationty_cd      	                                                    --关联人民族代码    
	 ,rela_ps_nation_cd        	                                                    --关联人国籍代码    
	 ,rela_ps_dist_cd          	                                                    --关联人行政区划代码  
	 ,rela_ps_marriage_situ_cd 	                                                    --关联人婚姻状况代码  
	 ,rela_ps_resd_status_cd   	                                                    --关联人居住状态代码  
	 ,rela_ps_politic_status_cd	                                                    --关联人政治面貌代码  
	 ,rela_ps_work_unit_cust_id	                                                    --关联人工作单位客户编号
	 ,rela_ps_work_unit_name   	                                                    --关联人工作单位名称  
	 ,rela_ps_tel_num          	                                                    --关联人电话号码    
	 ,rela_ps_tel_ext_num      	                                                    --关联人电话分机号码  
	 ,rela_ps_mobile_no        	                                                    --关联人手机号码    
	 ,rela_ps_work_unit_addr   	                                                    --关联人工作单位地址  
	 ,rela_ps_work_unit_tel    	                                                    --关联人工作单位电话 
     ,rela_ps_create_tm                                                             --关联人创建时间
     ,rela_ps_input_sys_tm                                                          --关联人录入系统时间	 
     ,job_cd                   	                                                    --任务代码
     ,etl_timestamp                                                                 --etl处理时间戳
)
select to_date('${batch_date}','yyyymmdd')                                         
      ,t1.lp_id                                                                     --数据日期                                                                       
	  ,t1.party_id                                                                  --客户编号        
	  ,nvl(trim(t3.src_party_id),trim(t2.rela_party_id))                            --关联人客户编号  
	  ,t2.rela_party_id                                                             --关联人编号  
	  ,nvl(trim(t2.party_rela_type_cd),'0000')                                      --关联类型代码      
	  ,t4.party_name                                                                --关联人姓名       
	  ,t6.cert_type_cd                                                              --关联人证件类型代码   
	  ,t6.cert_num                                                                  --关联人证件号码     
	  ,case when t41.gender_cd ='0' then ' '                                        
               else t41.gender_cd end                                 		        --关联人性别代码     
	  ,t41.birth_dt                                                                 --关联人出生日期     
	  ,t41.nati_place                                                               --关联人籍贯       
	  ,t41.nationty_cd                                                              --关联人民族代码     
	  ,case when t41.nation_cd ='XXX' then ' '                                      
         else t41.nation_cd end			                                            --关联人国籍代码     
	  ,t41.rg_cd                                                                    --关联人行政区划代码   
	  ,case when t41.marriage_situ_cd='90' then ' '                                 
	        else t41.marriage_situ_cd  end                                          --关联人婚姻状况代码   
	  ,case when t41.resd_status_cd='9' then ' '                                    
	        else t41.resd_status_cd  end    		   	                            --关联人居住状态代码   
	  ,case when t41.politic_status_cd='-' then ' '                                 
         else t41.politic_status_cd end			                                    --关联人政治面貌代码   
	  ,''                                                                           --关联人工作单位客户编号 
	  ,t7.work_unit_name                                                            --关联人工作单位名称   
	  ,coalesce(t8.mobile_phone, t8.other_phone, t8.fax)                            --关联人电话号码     
	  ,''                                                                           --关联人电话分机号码   
	  ,t8.significant_phone                                                         --关联人手机号码     
	  ,t7.work_unit_addr                                                            --关联人工作单位地址   
	  ,t7.tel_num                                                                   --关联人工作单位电话
	  ,t9.init_created_ts     	                                                    --关联人创建时间
	  ,t9.created_ts                                                                --关联人录入系统时间	
      ,t1.job_cd                                                                    --任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')              --etl处理时间戳      
  from ${iml_schema}.pty_party t1
  inner join ${iml_schema}.pty_party_rela_h t2    --调整关联表
    on t1.party_id = t2.party_id
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'eifsf1'
  left join ${iml_schema}.pty_party t3
  	on t2.rela_party_id = t3.party_id
   and t3.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.id_mark <> 'D'
   and t3.job_cd = 'eifsf1' 
  left join ${iml_schema}.pty_party_name_h t4
  	on t3.party_id = t4.party_id
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
   and t4.job_cd = 'eifsf1'
   and t4.party_name_type_cd = '01'
  left join ${iml_schema}.pty_indv t41
  	on t3.party_id = t41.party_id
   and t41.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t41.end_dt > to_date('${batch_date}','yyyymmdd')
   and t41.job_cd = 'eifsf1'
  left join (select s1.*,
				            row_number() over(partition by s1.party_id order by nvl(trim(s1.main_cert_no_flg), '0') desc, s1.cert_effect_dt desc) as rn
	             from ${iml_schema}.pty_party_cert_info_h s1
	            where s1.start_dt <= to_date('${batch_date}','yyyymmdd')
	              and s1.end_dt > to_date('${batch_date}','yyyymmdd')
	              and s1.job_cd = 'eifsf1') t6
  	on t2.rela_party_id = t6.party_id
   and t6.rn = 1
  left join ${iml_schema}.pty_party_work_info_h t7
    on t3.party_id = t7.party_id
   and t7.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t7.end_dt > to_date('${batch_date}','yyyymmdd')
   and t7.job_cd = 'eifsf1'
  left join (select c.party_id,
    								max(decode(c.tel_type_cd, '07', c.tel_num)) significant_phone,
    								max(decode(c.tel_type_cd, '05', c.tel_num)) mobile_phone,
    								max(decode(c.tel_type_cd, '03', c.tel_num)) office_phone,
    								max(decode(c.tel_type_cd, '02', c.tel_num)) home_phone,
    								max(decode(c.tel_type_cd, '99', c.tel_num)) other_phone,
    								max(decode(c.tel_type_cd, '04', c.tel_num)) fax
									--max(decode(c.tel_type_cd, '01', c.tel_num)) rela_tel_num  
							 from ${iml_schema}.pty_tel_info_h c
							where c.tel_type_cd in ('07' ,'05','03','02','99','04')
							  and c.job_cd = 'eifsf1'
                and c.start_dt <= to_date('${batch_date}','yyyymmdd')
							  and c.end_dt > to_date('${batch_date}','yyyymmdd')
							group by c.party_id) t8
	on t3.party_id = t8.party_id	  
  left join ${iml_schema}.pty_party_status_h t13
	on t1.party_id = t13.party_id
   and t13.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t13.end_dt > to_date('${batch_date}','yyyymmdd')
   and t13.job_cd = 'eifsf1'
   and t13.party_status_type_cd = 'CD1271'
  left join ${iol_schema}.eifs_t01_per_rel_per_info t9
    on t3.party_id = t9.rel_id
   and t9.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t9.end_dt > to_date('${batch_date}','yyyymmdd')
   and t9.updated_ts =to_date('99991231','yyyymmdd')
 where t1.party_type_cd in ('201003','201004') 
   and t2.valid_flg = '1' 
   and t13.party_status_cd ='1'   --新一代变更
 --and t13.party_status_cd ='A'
   and t1.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.id_mark <> 'D'
   and t1.job_cd = 'eifsf1'
   and t2.src_table_name in ('eifs_t01_per_rel_per_info');
commit;


-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_indv_cust_rela_ps_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_indv_cust_rela_ps_info_ex;

-- 3.1 drop ex table
--drop table ${icl_schema}.cmm_indv_cust_rela_ps_info_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_indv_cust_rela_ps_info', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
