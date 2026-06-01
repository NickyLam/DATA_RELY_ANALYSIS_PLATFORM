/*
Purpose:    共性加工层-贷款还款责任人信息
Author:     Sunline/
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_loan_repay_princ_info
Createdate: 20210727
Logs:       20211206 陈伟峰 调整助贷部分的供应商关联逻辑
            20220614 翟若平 1、取数数据源调整，由原零售信贷系统和网贷平台系统调整为综合信贷系统取数
                            2、第二组和第三组合并，原因为综合信贷系统迁移将 助贷供应商信息和网贷的相关还款责任人信息整合到了合作方客户信息表。
            20220627 翟若平 调整第二组的字段【还款责任人姓名、还款责任人证件号码】							
            20220715 李森辉 1、调整零售贷款区分规则，从根据T1.PRODUCTID标准产品编号区分修改为关联ICMS_PRD_CATALOG产品目录表区分
                            2、T1表过滤条件调整，业务状态T1.DUBIL_STATUS_CD IN ('1','4','9') -> T1.DUBIL_STATUS_CD IN ('TER', 'WRN', 'ZHC')  -- TER 终止/WRN 核销/ZHC 正常
            20220720 李森辉 调整表之间的关联方式，有LEFT JOIN -> INNER JOIN
            20220822 李森辉 调整T1表过滤条件调整，业务状态T1.DUBIL_STATUS_CD IN ('TER', 'WRN', 'ZHC') -> T1.DUBIL_STATUS_CD IN ('C','P','A')  -- TER 终止/WRN 核销/ZHC 正常：C 关闭/P 逾期/A 正常
            20240117 饶雅 增加取数数据源，增加额度合同和共同借款人授信变更/年审的批复流水的逻辑
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;
 
-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_loan_repay_princ_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_loan_repay_princ_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_loan_repay_princ_info_ex purge;
drop table ${icl_schema}.tmp_cmm_loan_repay_princ_info_01 purge;
drop table ${icl_schema}.tmp_cmm_loan_repay_princ_info_02 purge;


-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_loan_repay_princ_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_loan_repay_princ_info where 0=1;

--2.2 create tmp table
whenever sqlerror exit sql.sqlcode; 
create table ${icl_schema}.tmp_cmm_loan_repay_princ_info_01
nologging
compress ${option_switch} for query high
as
select distinct serno,rel_desc,cus_id,rel_name,rel_id_type,rel_id_no from (
select brl.bus_flow_num as serno,
       --'共同借款人' as rel_desc, -- 相关还款责任人类型代码
       '1' as rel_desc, -- 相关还款责任人类型代码
       nvl(trim(brl.cust_id), brl.fkd_rela_ps_list_id) as cus_id, -- 相关还款责任人客户号
       brl.rela_ps_name as rel_name, -- 相关还款责任人姓名
       brl.rela_ps_cert_type_cd as rel_id_type, -- 相关还款责任人证件类型
       brl.rela_ps_cert_no as rel_id_no -- 相关还款责任人证件号码
  from ${iml_schema}.pty_fkd_rela_ps_info brl  -- 房快贷关联人列表
 where brl.rela_ps_type_cd = '3'
   and brl.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and brl.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and brl.job_cd = 'icmsf1'
 union all
select distinct ba.obj_id as serno,
       --'共同借款人' as rel_desc, --相关还款责任人类型代码
       '1' as rel_desc, --相关还款责任人类型代码
       ba.applit_cust_id as cus_id, --相关还款责任人客户号
       ba.applit_cust_name as rel_name, --相关还款责任人姓名
       nvl(ci.cert_type_cd,' ') as rel_id_type, --相关还款责任人证件类型
       nvl(ci.cert_no,' ') as rel_id_no --相关还款责任人证件号码
  from ${iml_schema}.agt_loan_co_applit_info_h ba  -- 共同借款人信息
  left join ${iml_schema}.pty_cust ci
    on ba.applit_cust_id = ci.cust_id
   --and ci.job_cd = 'icmsf1'
   and ci.job_cd = 'eifsf1'
   and ci.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and ci.id_mark <> 'D'
 where ba.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and ba.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and ba.job_cd = 'icmsf1'
 union all 
select distinct gr.obj_id as serno,
       --'保证人' as rel_desc, --相关还款责任人类型代码
       '2' as rel_desc, --相关还款责任人类型代码
       nvl(gi.ownerid,' ') as cus_id, --相关还款责任人客户号
       nvl(gi.ownername,' ') as rel_name, --相关还款责任人姓名
       nvl(gi.certtype,' ') as rel_id_type, --相关还款责任人证件类型
       nvl(gi.certid,' ') as rel_id_no --相关还款责任人证件号码
  from ${iml_schema}.agt_guar_cont_guar_rela_h gr --业务_担保_押品关系表 
 inner join ${iml_schema}.agt_guar_cont_info_h gc  
    on gr.guar_cont_id = gc.guar_cont_id
   and gc.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and gc.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and gc.guar_way_cd in ('21', '22')
   and gc.job_cd ='icmsf1'
  left join ${iol_schema}.icms_guaranty_info gi
    on gr.guar_id = gi.guarantyid
   and gi.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and gi.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where gr.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and gr.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and gr.job_cd ='icmsf1');


whenever sqlerror exit sql.sqlcode; 
create table ${icl_schema}.tmp_cmm_loan_repay_princ_info_02
nologging
compress ${option_switch} for query high
as 
select  
        t1.dubil_id as dubil_id --借据编号
       ,t1.lp_id as lp_id --法人编号
       ,t1.cust_id as cust_id --客户编号
       ,t2.rela_cont_id as rela_cont_id --关联合同编号
       ,t1.job_cd as job_cd--任务代码
       ,t3.appl_flow_num as bus_appl_flow_num --业务合同的申请流水号
       ,t5.appl_flow_num as lmt_appl_flow_num --额度合同申请流水号
from ${iml_schema}.agt_loan_dubil_info_h t1
inner join ${iml_schema}.agt_loan_cont_info_h t2 
    on t1.rela_cont_id = t2.cont_id		
   and t2.lmt_cont_flg = '02' --业务合同
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'icmsf1'
left join ${iml_schema}.agt_loan_apv_basic_info_h t3
    on t2.apv_flow_num = t3.apv_flow_num
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   and t3.job_cd = 'icmsf1'
left join ${iml_schema}.agt_loan_cont_info_h t4
   on t2.rela_cont_id = t4.cont_id
   and t4.lmt_cont_flg = '01'--额度合同
   and t4.job_cd = 'icmsf1'
   and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
left join ${iml_schema}.agt_loan_apv_basic_info_h t5
   on t4.apv_flow_num = t5.apv_flow_num
   and t5.job_cd = 'icmsf1'
   and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
inner join ${iml_schema}.prd_loan_prod_info_h t6
   on t1.prod_id = t6.prod_id
   and t6.crdt_prod_cate_cd in ('2', '4')
   and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t6.end_dt > to_date('${batch_date}','yyyymmdd')
   and t6.job_cd = 'icmsf1'
where t1.dubil_status_cd in ('C','P','A')
   and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'icmsf1'; 



--

--第一组（共二组）传统零售 
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_loan_repay_princ_info_ex(
     etl_dt                        -- 数据日期
     ,lp_id                        -- 法人编号
     ,dubil_id                     -- 借据编号
     ,cust_id                      -- 客户编号
     ,repay_princ_cust_no          -- 还款责任人客户号
     ,repay_princ_name             -- 还款责任人姓名
     ,repay_princ_cert_type        -- 还款责任人证件类型
     ,repay_princ_cert_no          -- 还款责任人证件号码
     ,repay_princ_idti_type_cd     -- 还款责任人身份类型代码
     ,repay_princ_type_cd          -- 还款责任人类型代码
     ,job_cd                       -- 任务代码
     ,etl_timestamp                -- 数据处理时间     
)
select distinct etl_dt -- 数据日期
                ,lp_id -- 法人编号
                ,dubil_id -- 借据编号
                ,cust_id -- 客户编号
                ,repay_princ_cust_no -- 还款责任人客户号
                ,repay_princ_name -- 还款责任人姓名
                ,repay_princ_cert_type -- 还款责任人证件类型
                ,repay_princ_cert_no -- 还款责任人证件号码
                ,repay_princ_idti_type_cd  -- 还款责任人身份类型代码
                ,repay_princ_type_cd -- 还款责任人类型代码
                ,job_cd -- 任务代码
                ,etl_timestamp -- 数据处理时间
from
(select to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
       ,t1.lp_id  as lp_id -- 法人编号
       ,t1.dubil_id  as dubil_id -- 借据编号
       ,t1.cust_id as cust_id -- 客户编号
       ,t4.cus_id as repay_princ_cust_no -- 还款责任人客户号
       ,t4.rel_name  as  repay_princ_name -- 还款责任人姓名
       ,t4.rel_id_type  as repay_princ_cert_type -- 还款责任人证件类型
       ,t4.rel_id_no as  repay_princ_cert_no -- 还款责任人证件号码
       ,case when substr(t4.rel_id_type, 1, 1 ) = '2'
	         then '2' else '1'
        end as repay_princ_idti_type_cd  -- 还款责任人身份类型代码
       ,t4.rel_desc as repay_princ_type_cd  -- 还款责任人类型代码
       ,t1.job_cd  as job_cd  -- 任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- 数据处理时间
  from  ${icl_schema}.tmp_cmm_loan_repay_princ_info_02 t1
inner join ${icl_schema}.tmp_cmm_loan_repay_princ_info_01 t4
   on t1.bus_appl_flow_num = t4.serno
union all 
select  to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
       ,t1.lp_id  as lp_id -- 法人编号
       ,t1.dubil_id  as dubil_id -- 借据编号
       ,t1.cust_id as cust_id -- 客户编号
       ,t4.cus_id as repay_princ_cust_no -- 还款责任人客户号
       ,t4.rel_name  as  repay_princ_name -- 还款责任人姓名
       ,t4.rel_id_type  as repay_princ_cert_type -- 还款责任人证件类型
       ,t4.rel_id_no as  repay_princ_cert_no -- 还款责任人证件号码
       ,case when substr(t4.rel_id_type, 1, 1 ) = '2'
	         then '2' else '1'
        end as repay_princ_idti_type_cd  -- 还款责任人身份类型代码
       ,t4.rel_desc as repay_princ_type_cd  -- 还款责任人类型代码
       ,t1.job_cd  as job_cd  -- 任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- 数据处理时间
  from  ${icl_schema}.tmp_cmm_loan_repay_princ_info_02 t1
inner join ${icl_schema}.tmp_cmm_loan_repay_princ_info_01 t4
   on t1.lmt_appl_flow_num=t4.serno
union all  
select  to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
       ,t1.lp_id  as lp_id -- 法人编号
       ,t1.dubil_id  as dubil_id -- 借据编号
       ,t1.cust_id as cust_id -- 客户编号
       ,t4.cus_id as repay_princ_cust_no -- 还款责任人客户号
       ,t4.rel_name  as  repay_princ_name -- 还款责任人姓名
       ,t4.rel_id_type  as repay_princ_cert_type -- 还款责任人证件类型
       ,t4.rel_id_no as  repay_princ_cert_no -- 还款责任人证件号码
       ,case when substr(t4.rel_id_type, 1, 1 ) = '2'
	         then '2' else '1'
        end as repay_princ_idti_type_cd  -- 还款责任人身份类型代码
       ,t4.rel_desc as repay_princ_type_cd  -- 还款责任人类型代码
       ,t1.job_cd  as job_cd  -- 任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- 数据处理时间
  from  ${icl_schema}.tmp_cmm_loan_repay_princ_info_02 t1
left join ${iml_schema}.agt_loan_cont_rela_tab_info_h t2
   on t1.rela_cont_id=t2.cont_id
   and t2.obj_type_name = 'CREDIT_CHANGE'
   and t2.job_cd = 'icmsf1'
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
left join ${iml_schema}.agt_loan_apv_basic_info_h t3
   on t2.obj_id = t3.apv_flow_num
   and t3.job_cd = 'icmsf1'
   and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
inner join ${icl_schema}.tmp_cmm_loan_repay_princ_info_01 t4
   on t3.appl_flow_num=t4.serno);

commit;

--第二组（共二组）助学贷款+网贷	
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_loan_repay_princ_info_ex(
     etl_dt                        -- 数据日期
     ,lp_id                        -- 法人编号
     ,dubil_id                     -- 借据编号
     ,cust_id                      -- 客户编号
     ,repay_princ_cust_no          -- 还款责任人客户号
     ,repay_princ_name             -- 还款责任人姓名
     ,repay_princ_cert_type        -- 还款责任人证件类型
     ,repay_princ_cert_no          -- 还款责任人证件号码
     ,repay_princ_idti_type_cd     -- 还款责任人身份类型代码
     ,repay_princ_type_cd          -- 还款责任人类型代码
     ,job_cd                       -- 任务代码
     ,etl_timestamp                -- 数据处理时间     
)
select distinct 
               etl_dt                        -- 数据日期
              ,lp_id                        -- 法人编号
              ,dubil_id                     -- 借据编号
              ,cust_id                      -- 客户编号
              ,repay_princ_cust_no          -- 还款责任人客户号
              ,repay_princ_name             -- 还款责任人姓名
              ,repay_princ_cert_type        -- 还款责任人证件类型
              ,repay_princ_cert_no          -- 还款责任人证件号码
              ,repay_princ_idti_type_cd     -- 还款责任人身份类型代码
              ,repay_princ_type_cd          -- 还款责任人类型代码
              ,job_cd                       -- 任务代码
              ,etl_timestamp                -- 数据处理时间     
                
from (select to_date('${batch_date}','yyyymmdd') as etl_dt             -- 数据日期
       ,t1.lp_id as  lp_id                                      -- 法人编号
       ,t1.dubil_id  as dubil_id                                  -- 借据编号
       ,t1.cust_id  as cust_id                                    -- 客户编号
       ,coalesce(trim(t7.coreentcustid), trim(t7.customerid), trim(t8.coreentcustid), trim(t8.customerid), ' ') as repay_princ_cust_no  -- 还款责任人客户号
       ,coalesce(trim(t7.repaypersonname), trim(t7.partnername), trim(t8.repaypersonname), t8.partnername, ' ') as repay_princ_name  -- 还款责任人姓名
       ,coalesce(trim(t7.repaypersoncerttype), trim(t7.certtype), trim(t8.repaypersoncerttype), t8.certtype, ' ') as repay_princ_cert_type -- 还款责任人证件类型
       ,coalesce(trim(t7.repaypersoncertid), trim(t7.certid), trim(t8.repaypersoncertid), t8.certid, ' ') as repay_princ_cert_no         -- 还款责任人证件号码
       ,case --when nvl(trim(t7.repaypersonidentity), trim(t8.repaypersoncertid)) is not null then nvl(trim(t7.repaypersonidentity), trim(t8.repaypersoncertid))
             when substr(nvl(trim(t7.certtype), t8.certtype), 1, 1) = '2'  then '2'  -- 组织机构代码
             else '1'
        end as repay_princ_idti_type_cd                                  -- 还款责任人身份类型代码
       ,coalesce(trim(t7.repaypersontype), trim(t8.repaypersontype), '2') as repay_princ_type_cd -- 还款责任人类型代码
       ,t1.job_cd as job_cd                                                       -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- 数据处理时间
  from ${icl_schema}.tmp_cmm_loan_repay_princ_info_02 t1
inner join ${iml_schema}.agt_loan_appl_rela_tab_info_h t2
    on t1.bus_appl_flow_num = t2.appl_flow_num		
   and t2.obj_type_name in ('RelativeProject','RelativePartner')
   and t2.job_cd = 'icmsf1'
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
left join ${iol_schema}.icms_partner_cont_bill t6	
    on t6.contractno = t2.obj_id
   and t6.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t6.end_dt > to_date('${batch_date}', 'yyyymmdd')	  
  left join ${iol_schema}.icms_customer_partner t7	
    on t6.partnerid = t7.partnerid			
   and t7.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t7.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.icms_customer_partner t8	
    on t2.obj_id = t8.partnerid			
   and t8.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t8.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where trim(coalesce(trim(t7.repaypersonname), trim(t7.partnername), trim(t8.repaypersonname), t8.partnername)) is not null
union all
select to_date('${batch_date}','yyyymmdd') as etl_dt             -- 数据日期
       ,t1.lp_id  as  lp_id                                      -- 法人编号
       ,t1.dubil_id  as dubil_id                                   -- 借据编号
       ,t1.cust_id as cust_id                                     -- 客户编号
       ,coalesce(trim(t7.coreentcustid), trim(t7.customerid), trim(t8.coreentcustid), trim(t8.customerid), ' ') as repay_princ_cust_no   -- 还款责任人客户号
       ,coalesce(trim(t7.repaypersonname), trim(t7.partnername), trim(t8.repaypersonname), t8.partnername, ' ') as repay_princ_name   -- 还款责任人姓名
       ,coalesce(trim(t7.repaypersoncerttype), trim(t7.certtype), trim(t8.repaypersoncerttype), t8.certtype, ' ') as repay_princ_cert_type -- 还款责任人证件类型
       ,coalesce(trim(t7.repaypersoncertid), trim(t7.certid), trim(t8.repaypersoncertid), t8.certid, ' ') as repay_princ_cert_no         -- 还款责任人证件号码
       ,case --when nvl(trim(t7.repaypersonidentity), trim(t8.repaypersoncertid)) is not null then nvl(trim(t7.repaypersonidentity), trim(t8.repaypersoncertid))
             when substr(nvl(trim(t7.certtype), t8.certtype), 1, 1) = '2'  then '2'  -- 组织机构代码
             else '1'
        end as repay_princ_idti_type_cd                                  -- 还款责任人身份类型代码
       ,coalesce(trim(t7.repaypersontype), trim(t8.repaypersontype), '2') as repay_princ_type_cd -- 还款责任人类型代码
       ,t1.job_cd as job_cd                                                       -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- 数据处理时间
  from ${icl_schema}.tmp_cmm_loan_repay_princ_info_02 t1
inner join ${iml_schema}.agt_loan_appl_rela_tab_info_h t2
    on t1.lmt_appl_flow_num = t2.appl_flow_num		
   and t2.obj_type_name in ('RelativeProject','RelativePartner')
   and t2.job_cd = 'icmsf1'
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
left join ${iol_schema}.icms_partner_cont_bill t6	
    on t6.contractno = t2.obj_id
   and t6.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t6.end_dt > to_date('${batch_date}', 'yyyymmdd')	  
  left join ${iol_schema}.icms_customer_partner t7	
    on t6.partnerid = t7.partnerid			
   and t7.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t7.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.icms_customer_partner t8	
    on t2.obj_id = t8.partnerid			
   and t8.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t8.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where trim(coalesce(trim(t7.repaypersonname), trim(t7.partnername), trim(t8.repaypersonname), t8.partnername)) is not null)
; 
 commit;
   
-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_loan_repay_princ_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_loan_repay_princ_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_loan_repay_princ_info_ex purge;
--drop table ${icl_schema}.tmp_cmm_loan_repay_princ_info_01 purge;
--drop table ${icl_schema}.tmp_cmm_loan_repay_princ_info_02 purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_loan_repay_princ_info', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);