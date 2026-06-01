/*
Purpose:    共性加工层-内部机构信息表：包括我行的所有内部机构信息，数据来源统一门户系统机构信息表。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_intnal_org_info
Createdate: 20200326
Logs:       20200605 周沁晖 增加字段【人行人行金融机构编码】
            20200925 陈伟峰 增加字段【机构层级代码】
            20210205 周沁晖 新增字段【机构英文名称】【机构英文简称】【税务登记证号】【支付系统银行行号】【组织机构代码】【明细机构标志】【SWIFTCODE】【国际长途区号】【分机号】【服务电话】【电子邮箱】【网址】【人行所属城市代码】【人行所属城市】
            20220511 李森辉 修改字段取数逻辑【机构名称】【机构简称】【分行编号】【物理地址】
            20220929 温旺清 新增字段【报表上级机构编号】
			      20221024 温旺清 新增字段【自由贸易区标志】
			      20230609 翟若平 调整字段【支付系统银行行号】的加工口径
			      20230609 陈  凭 新增字段【零售管户机构标志】
				  20260402 谭钧泽 调整临时表创建规则
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_intnal_org_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_intnal_org_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_intnal_org_info_ex purge;

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none;
drop table ${icl_schema}.tmp_cmm_intnal_org_info_01 purge;
drop table ${icl_schema}.tmp_cmm_intnal_org_info_02 purge;
whenever sqlerror exit sql.sqlcode; 
create table ${icl_schema}.tmp_cmm_intnal_org_info_01
nologging
compress ${option_switch} for query high
as
select
    t1.org_id     as org_id
    ,t9.org_id    as brch_id
    ,t10.org_name as brch_name
 from ${iml_schema}.org_int_org t1
 left join ${iml_schema}.org_int_org_rela_h t8
   on t1.org_id=t8.org_id
  and t8.org_rela_type_cd = '05'
  and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t8.end_dt > to_date('${batch_date}','yyyymmdd')
  and t8.job_cd = 'uussf1'
 left join ${iml_schema}.org_int_org_rela_h t9
   on t8.rela_org_id = t9.org_id
  and t9.org_rela_type_cd = '05'
  and t9.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t9.end_dt > to_date('${batch_date}','yyyymmdd')
  and t9.job_cd = 'uussf1'
 left join ${iml_schema}.org_intnal_org_name_h t10
   on t9.org_id = t10.org_id
  and t10.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t10.end_dt > to_date('${batch_date}','yyyymmdd')
  and t10.job_cd = 'uussf1'
 left join ${iml_schema}.org_int_org t11
   on t10.org_id = t11.org_id
  and t11.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t11.job_cd = 'uussf1'
  and t11.id_mark <> 'D'
where t1.create_dt <= to_date('${batch_date}','yyyymmdd')
and t1.job_cd = 'uussf1'
and t1.id_mark <> 'D'
;
commit;

create table ${icl_schema}.tmp_cmm_intnal_org_info_02
nologging
compress ${option_switch} for query high
as 

select t1.org_id                                                          -- 机构编号
       ,t3.rela_org_id as cbrc_fin_inst_id                                -- 银监会金融机构编号
       ,t4.rela_org_id as unionpay_fin_inst_id                            -- 银联金融机构编号
       ,t5.rela_org_id as fin_inst_idf_code                               -- 金融机构标识码
       ,case when trim(t6.rela_org_id) is not null then t6.rela_org_id
             when t7.rela_org_id not like 'C%' then t7.rela_org_id
             else ''
        end as pbc_pay_bank_no                                            -- 人行支付行号
       ,case when t83.org_type_cd = '12' then t81.org_id
             when t1.org_type_cd = '12' then t1.org_id
             else null
        end as subrch_id                                                  -- 支行编号
       ,case when t83.org_type_cd = '12' then t82.org_name
             when t1.org_type_cd = '12' then t1.org_name
             else null
        end as subrch_name                                                -- 支行名称
       ,t8.rela_org_id as admin_super_org_id                              -- 行政上级机构编号
       ,t9.rela_org_id as acct_super_org_id                               -- 账务上级机构编号
       ,t10.rela_org_id as accti_super_org_id                             -- 核算上级机构编号
       ,t13.rela_org_id as rept_super_org_id                              -- 报表上级机构编号
       ,t11.rela_org_id as func_org_id                                    -- 职能机构编号  
       ,t12.rela_org_id as func_dept_id                                   -- 职能部门编号
       ,t7.rela_org_id as fin_inst_code                                   -- 人行人行金融机构编码
       ,to_char(t16.lvl) as org_hibchy_cd                                          -- 机构层级代码
       ,t6.rela_org_id as rela_org_id                                     -- 支付系统银行行号
  from ${iml_schema}.org_int_org t1
  left join ${iml_schema}.org_int_org_rela_h t3
    on t1.org_id=t3.org_id
   and t3.org_rela_type_cd = '06'
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   and t3.job_cd = 'uussf1'
  left join ${iml_schema}.org_int_org_rela_h t4
    on t1.org_id=t4.org_id
   and t4.org_rela_type_cd = '07'
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
   and t4.job_cd = 'uussf1'
  left join ${iml_schema}.org_int_org_rela_h t5
    on t1.org_id=t5.org_id
   and t5.org_rela_type_cd = '03'
   and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t5.end_dt > to_date('${batch_date}','yyyymmdd')
   and t5.job_cd = 'uussf1'
  left join ${iml_schema}.org_int_org_rela_h t6
    on t1.org_id=t6.org_id
   and t6.org_rela_type_cd = '09'
   and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t6.end_dt > to_date('${batch_date}','yyyymmdd')
   and t6.job_cd = 'uussf1'
  left join ${iml_schema}.org_int_org_rela_h t7
    on t1.org_id=t7.org_id
   and t7.org_rela_type_cd = '04'
   and t7.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t7.end_dt > to_date('${batch_date}','yyyymmdd')
   and t7.job_cd = 'uussf1'
  left join ${iml_schema}.org_int_org_rela_h t8
    on t1.org_id=t8.org_id
   and t8.org_rela_type_cd = '01'
   and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t8.end_dt > to_date('${batch_date}','yyyymmdd')
   and t8.job_cd = 'uussf1'
  left join ${iml_schema}.org_int_org_rela_h t81
    on t8.rela_org_id = t81.org_id
   and t81.org_rela_type_cd = '01'
   and t81.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t81.end_dt > to_date('${batch_date}','yyyymmdd')
   and t81.job_cd = 'uussf1'
  left join ${iml_schema}.org_intnal_org_name_h t82
    on t81.org_id = t82.org_id
   and t82.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t82.end_dt > to_date('${batch_date}','yyyymmdd')
   and t82.job_cd = 'uussf1'
  left join ${iml_schema}.org_int_org t83
    on t81.org_id = t83.org_id
   and t83.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t83.job_cd = 'uussf1'
   and t83.id_mark <> 'D'
  left join ${iml_schema}.org_int_org_rela_h t9
    on t1.org_id=t9.org_id
   and t9.org_rela_type_cd = '08'
   and t9.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t9.end_dt > to_date('${batch_date}','yyyymmdd')
   and t9.job_cd = 'uussf1'
  left join ${iml_schema}.org_int_org_rela_h t10
    on t1.org_id=t10.org_id
   and t10.org_rela_type_cd = '02'
   and t10.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t10.end_dt > to_date('${batch_date}','yyyymmdd')
   and t10.job_cd = 'uussf1'
  left join ${iml_schema}.org_int_org_rela_h t11
    on t1.org_id=t11.org_id
   and t11.org_rela_type_cd = '11'
   and t11.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t11.end_dt > to_date('${batch_date}','yyyymmdd')
   and t11.job_cd = 'uussf1'
  left join ${iml_schema}.org_int_org_rela_h t12
    on t1.org_id=t12.org_id
   and t12.org_rela_type_cd = '10'
   and t12.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t12.end_dt > to_date('${batch_date}','yyyymmdd')
   and t12.job_cd = 'uussf1'
  /* left join ${iol_schema}.uuss_uus_organ t13
    on t1.org_id = t13.organcode
   and t13.isyy = '1'   --报表机构
   and t13.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t13.end_dt > to_date('${batch_date}','yyyymmdd')  */
  left join ${iml_schema}.org_int_org_rela_h t13
    on t1.org_id=t13.org_id
   and t13.org_rela_type_cd = '13'
   and t13.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t13.end_dt > to_date('${batch_date}','yyyymmdd')
   and t13.job_cd = 'uussf1'
  left join (select level lvl,a.rela_org_id,a.org_id
               from (select rela_org_id,org_id from ${iml_schema}.org_int_org_rela_h t
                      where t.org_rela_type_cd = '01'
                        and t.start_dt <= to_date('${batch_date}','yyyymmdd')
                        and t.end_dt > to_date('${batch_date}','yyyymmdd')
                        and t.job_cd = 'uussf1') a
             start with a.org_id = '000000'
             connect by a.rela_org_id = prior a.org_id) t16
    on t1.org_id=t16.org_id
 where t1.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'uussf1'
   and t1.id_mark <> 'D';
commit;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_intnal_org_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_intnal_org_info where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_intnal_org_info_ex(
   etl_dt                    -- 数据日期     
   ,lp_id                    -- 法人编号     
   ,org_id                   -- 机构编号     
   ,org_name                 -- 机构名称     
   ,org_abbr                 -- 机构简称   
   ,org_en_name              -- 机构英文名称
   ,org_en_abbr              -- 机构英文简称
   ,princ_emply_id           -- 负责人员工编号  
   ,cbrc_fin_inst_id         -- 银监会金融机构编号
   ,unionpay_fin_inst_id     -- 银联金融机构编号 
   ,fin_inst_idf_code        -- 金融机构标识码  
   ,bus_lics_num             -- 营业执照号码   
   ,fin_lics_num             -- 金融许可证号  
   ,tax_regi_cert_num        -- 税务登记证号 
   ,pbc_pay_bank_no          -- 人行支付行号
   ,pay_sys_bank_no          -- 支付系统银行行号
   ,fin_inst_code            -- 人行人行金融机构编码   
   ,hq_org_id                -- 总行机构编号   
   ,hq_org_name              -- 总行机构名称   
   ,brch_id                  -- 分行编号     
   ,brch_name                -- 分行名称     
   ,subrch_id                -- 支行编号     
   ,subrch_name              -- 支行名称     
   ,org_type_cd              -- 机构类型代码   
   ,org_lev_cd               -- 机构级别代码
   ,org_hibchy_cd            -- 机构层级代码
   ,org_status_cd            -- 机构状态代码  
   ,orgnz_cd                 -- 组织机构代码 
   ,bus_status_cd            -- 营业状态代码   
   ,bus_org_flg              -- 营业机构标志   
   ,enty_org_flg             -- 实体机构标志   
   ,accti_org_flg            -- 核算机构标志   
   ,admin_org_flg            -- 行政机构标志   
   ,acct_instit_flg          -- 账务机构标志   
   ,dtl_org_flg              -- 明细机构标志
   ,vtual_accti_org_flg      -- 虚拟核算机构标志 
   ,free_trade_rg_flg        -- 自由贸易区标志
   ,retl_execu_org_flg       -- 零售管户机构标志
   ,admin_super_org_id       -- 行政上级机构编号 
   ,acct_super_org_id        -- 账务上级机构编号 
   ,accti_super_org_id       -- 核算上级机构编号 
   ,rept_super_org_id        -- 报表上级机构编号
   ,func_org_id              -- 职能机构编号   
   ,func_dept_id             -- 职能部门编号   
   ,swiftcode                -- SWIFTCODE
   ,cty_rg_cd                -- 国家和地区代码  
   ,prov_cd                  -- 省代码      
   ,city_cd                  -- 市代码      
   ,county_cd                -- 县代码      
   ,phys_addr                -- 物理地址     
   ,ddd_area_cd              -- 国内长途区号   
   ,idd_area_cd              -- 国际长途区号
   ,phone                    -- 联系电话   
   ,ext_num                  -- 分机号 
   ,serv_tel                 -- 服务电话
   ,e_mail                   -- 电子邮箱
   ,url                      -- 网址    
   ,zip_cd                   -- 邮政编码   
   ,pbc_belong_city_cd       -- 人行所属城市代码
   ,pbc_belong_city          -- 人行所属城市    
   ,org_found_dt             -- 机构成立日期   
   ,org_revo_dt              -- 机构撤销日期   
   ,org_start_bus_tm         -- 机构开始营业时间 
   ,org_end_bus_tm           -- 机构结束营业时间 
   ,job_cd                   -- 任务代码
   ,etl_timestamp            -- etl处理时间戳
)
select to_date('${batch_date}','yyyymmdd')                              -- 数据日期 
      ,t1.lp_id                                                         -- 法人编号                                                                                                                                                           
      ,t1.org_id                                                        -- 机构编号                                                                                                                                                           
      ,t1.org_name                                                      -- 机构名称                                                                                                                                                           
      ,t1.org_abbr                                                      -- 机构简称
      ,t7.organenfullname                                               -- 机构英文名称
      ,t7.organenshortname                                              -- 机构英文简称                                                                                                                                                           
      ,t2.princ_emply_id                                                -- 负责人员工编号                                                                                                                                                        
      ,t3.cbrc_fin_inst_id                                              -- 银监会金融机构编号                                                                                                                                                      
      ,t3.unionpay_fin_inst_id                                          -- 银联金融机构编号                                                                                                                                                       
      ,t3.fin_inst_idf_code                                             -- 金融机构标识码                                                                                                                                                        
      ,t15.bus_lics_num                                                 -- 营业执照号码                                                                                                                                                         
      ,t1.fin_lics_num                                                  -- 金融许可证号  
      ,t7.taxid                                                         -- 税务登记证号                                                                                                                                                       
      ,t3.pbc_pay_bank_no                                               -- 人行支付行号
      ,(case when trim(t7.bankcodeperson) is not null then t7.bankcodeperson 
             else t3.rela_org_id
         end) as pay_sys_bank_no                                        -- 支付系统银行行号
      ,t3.fin_inst_code                                                 -- 人行人行金融机构编码
      ,t13.org_id                                                       -- 总行机构编号                                                                                                                                                         
      ,t13.org_name                                                     -- 总行机构名称                                                                                                                                                         
      ,t14.brch_id                                                      -- 分行编号                                                                                                                                                           
      ,t14.brch_name                                                    -- 分行名称                                                                                                                                                           
      ,t3.subrch_id                                                     -- 支行编号                                                                                                                        
      ,t3.subrch_name                                                   -- 支行名称                                                                                                                                  
      ,t1.org_type_cd                                                   -- 机构类型代码                                                                                                                                                         
      ,t1.org_lev_cd                                                    -- 机构级别代码
      ,case when trim(t3.org_hibchy_cd) is null
            then '0' else t3.org_hibchy_cd
       end                                                              -- 机构层级代码
      ,t1.org_status_cd                                                 -- 机构状态代码 
      ,t7.organizationcode                                              -- 组织机构代码                                                                                                                                                         
      ,t1.org_bus_status_cd                                             -- 营业状态代码                                                                                                                                                         
      ,t1.bus_org_flg                                                   -- 营业机构标志                                                                                                                                                         
      ,t1.enty_org_flg                                                  -- 实体机构标志                                                                                                                                                         
      ,t1.accti_org_flg                                                 -- 核算机构标志                                                                                                                                                         
      ,t1.admin_org_flg                                                 -- 行政机构标志                                                                                                                                                         
      ,t1.acct_instit_flg                                               -- 账务机构标志       
      ,t7.leafnoteflag                                                  -- 明细机构标志                                                                                                                                                 
      ,t1.vtual_org_flg                                                 -- 虚拟核算机构标志
      ,t6.fta_flag	                                                    -- 自由贸易区标志
	    ,nvl(trim(t7.physicsflag),'0')                                    -- 零售管户机构标志
      ,t3.admin_super_org_id                                            -- 行政上级机构编号                                                                                                                                                       
      ,t3.acct_super_org_id                                             -- 账务上级机构编号                                                                                                                                                       
      ,t3.accti_super_org_id                                            -- 核算上级机构编号 
      ,t3.rept_super_org_id                                             -- 报表上级机构编号                                                                                                                                                      
      ,t3.func_org_id                                                   -- 职能机构编号                                                                                                                                                         
      ,t3.func_dept_id                                                  -- 职能部门编号
      ,t7.swiftcode                                                     -- SWIFTCODE                                                                                                                                                         
      ,nvl(trim(t2.cty_or_rg_cd),'XXX')                                 -- 国家和地区代码                                                                                                                                                        
      ,t2.prov_cd                                                       -- 省代码                                                                                                                                                            
      ,t2.city_cd                                                       -- 市代码                                                                                                                                                            
      ,t2.county_cd                                                     -- 县代码                                                                                                                                                            
      ,t2.dtl_addr                                                      -- 物理地址                                                                                                                                                           
      ,t2.ddd_area_cd                                                   -- 国内长途区号 
      ,t7.countrycode                                                   -- 国际长途区号                                                                                                                                                        
      ,t2.tel_num                                                       -- 联系电话  
      ,t7.subphone                                                      -- 分机号 
      ,t7.servicephone                                                  -- 服务电话
      ,t7.email                                                         -- 电子邮箱
      ,t7.url                                                           -- 网址                                                                                                                                                         
      ,t2.zip_cd                                                        -- 邮政编码 
      ,t7.rhregcode                                                     -- 人行所属城市代码
      ,t7.blng_city_pbc                                                 -- 人行所属城市                                                                                                                                                           
      ,t1.org_found_dt                                                  -- 机构成立日期                                                                                                                                                         
      ,t1.org_close_dt                                                  -- 机构撤销日期                                                                                                                                                         
      ,t15.work_start_tm                                                -- 机构开始营业时间
      ,t15.work_end_tm                                                  -- 机构结束营业时间
      ,t1.job_cd                                                        -- 任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳      
  from ${iml_schema}.org_int_org t1
  left join ${iml_schema}.org_int_org_addr_h t2
    on t1.org_id=t2.org_id
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'uussf1'
  left join ${icl_schema}.tmp_cmm_intnal_org_info_02 t3
    on t1.org_id = t3.org_id
  left join ${iml_schema}.org_intnal_org_name_h t13
    on t13.org_id = '000000'
   and t13.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t13.end_dt > to_date('${batch_date}','yyyymmdd')
   and t13.job_cd = 'uussf1'
  left join ${icl_schema}.tmp_cmm_intnal_org_info_01 t14
    on t1.org_id = t14.org_id
  left join ${iml_schema}.org_intnal_org_addit_info t15
    on t1.org_id = t15.org_id
   and t15.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t15.job_cd = 'uussf1'
   and t15.id_mark <> 'D'
  left join ${iol_schema}.uuss_uus_organ t7
    on t1.org_id = t7.organcode
   and t7.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t7.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.ncbs_fm_branch t6
    on t1.org_id = t6.branch
   and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t6.end_dt > to_date('${batch_date}','yyyymmdd')
 where t1.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'uussf1'
   and t1.id_mark <> 'D';
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_intnal_org_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_intnal_org_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_intnal_org_info_ex purge;
drop table ${icl_schema}.tmp_cmm_intnal_org_info_01 purge;
drop table ${icl_schema}.tmp_cmm_intnal_org_info_02 purge;
-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_intnal_org_info', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);