/*
Purpose:    共性加工层-银企对账账户基本信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20200630 icl_cmm_bkcp_check_acct_basic_info
Createdate: 20200910
Logs:       20211107 何桐金 【agt_bkcp_check_sign_h】增加job_cd过滤条件
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_bkcp_check_acct_basic_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_bkcp_check_acct_basic_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none;
drop table ${icl_schema}.cmm_bkcp_check_acct_basic_info_ex purge;


whenever sqlerror exit sql.sqlcode;
-- 2.1 insert into ex table
create table ${icl_schema}.cmm_bkcp_check_acct_basic_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_bkcp_check_acct_basic_info where 0=1
;
commit;



-- 第一组（共一组）银企对账账户基本信息
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_bkcp_check_acct_basic_info_ex(
    etl_dt		            --数据日期
    ,lp_id		            --法人编号
    ,cust_acct_id		    --客户账户编号
    ,cust_sub_acct_num		--客户账户子户号
    ,brch_id		        --分行编号
    ,subrch_id		        --支行编号
    ,org_id		            --机构编号
    ,org_name		        --机构名称
    ,acct_name		        --账户名称
    ,cust_id		        --客户编号
    ,acct_status_cd		    --账户状态代码
    ,sav_type_cd		    --储种代码
    ,espec_acct_flg_cd		--特殊账户标志代码
    ,curr_cd		        --币种代码
    ,check_entry_way_cd		--对账方式代码
    ,check_entry_ped_cd		--对账周期代码
    ,bkcp_open_acct_dt		--银企开户日期
	,last_check_entry_dt    --上次对账日期
	,two_unentry_flg_cd     --两期未对账标志
    ,seal_acct_id		    --验印账户编号
    ,seal_way_cd		    --验印方式代码
    ,rgst_addr		        --注册地址
    ,post_addr		        --邮寄地址
    ,zip_cd		            --邮政编码
    ,sign_flg		        --签约标志
    ,sign_dt		        --签约日期
    ,sign_org_id		    --签约机构编号
    ,sign_teller_id	        --签约柜员编号
    ,sign_cont_id	        --签约合同编号
    ,cotas_name		        --联系人名称
    ,phone_num		        --联系电话号码
    ,resv_phone_num	        --备用联系电话号码
    ,job_cd                 --任务代码
    ,etl_timestamp          --etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')	             as etl_dt	               --数据日期
   ,t1.lp_id	                                     as lp_id	               --法人编号
   ,t1.acct_id	                                     as cust_acct_id	       --客户账户编号
   ,t1.sub_acct_id	                                 as cust_sub_acct_num	   --客户账户子户号
   ,t1.brch_id	                                     as brch_id	               --分行编号
   ,t1.subrch_id	                                 as subrch_id	           --支行编号
   ,t1.brac_id	                                     as org_id	               --机构编号
   ,t1.brac_name	                                 as org_name	           --机构名称
   ,t1.acct_name	                                 as acct_name	           --账户名称
   ,t1.cust_id	                                     as cust_id	               --客户编号
   ,t1.acct_status_cd	                             as acct_status_cd	       --账户状态代码
   ,t1.sav_type_cd	                                 as sav_type_cd	           --储种代码
   ,t1.espec_acct_flg_cd                             as espec_acct_flg_cd	   --特殊账户标志代码
   ,t1.curr_cd	                                     as curr_cd	               --币种代码
   ,t1.check_entry_way_cd                            as check_entry_way_cd	   --对账方式代码
   ,nvl(decode(t3.acccycle,'1','M','2','P',''),t1.check_entry_ped_cd)           as check_entry_ped_cd	   --对账周期代码
   ,trim(t1.open_acct_dt)	                         as bkcp_open_acct_dt	   --银企开户日期
   ,nvl(to_date(trim(t3.docdate),'yyyymmdd'),'')     as last_check_entry_dt    --上次对账日期
   ,case when (nvl(decode(t3.acccycle,'1','M','2','P',''),t1.check_entry_ped_cd)) ='M' and (to_date('${batch_date}','yyyymmdd')-nvl(to_date(trim(t3.docdate),'yyyymmdd'),t1.open_acct_dt)+1) >60 then '1'
         when (nvl(decode(t3.acccycle,'1','M','2','P',''),t1.check_entry_ped_cd)) ='P' and (to_date('${batch_date}','yyyymmdd')-nvl(to_date(trim(t3.docdate),'yyyymmdd'),t1.open_acct_dt)+1) >180 then '1'
         when (nvl(decode(t3.acccycle,'1','M','2','P',''),t1.check_entry_ped_cd)) not in ('M' ,'P') then '9'  
         else '0' end                                as two_unentry_flg_cd     --两期未对账标志
   ,t1.seal_acct_id	                                 as seal_acct_id	       --验印账户编号
   ,t1.seal_way_cd	                                 as seal_way_cd	           --验印方式代码
   ,t1.rgst_addr	                                 as rgst_addr	           --注册地址
   ,t1.post_addr	                                 as post_addr	           --邮寄地址
   ,t1.zip_cd	                                     as zip_cd	               --邮政编码
   ,t1.sign_flg	                                     as sign_flg	           --签约标志
   ,trim(t1.sign_dt)	                             as sign_dt	               --签约日期
   ,t2.org_id	                                     as sign_org_id	           --签约机构编号
   ,t2.teller_id	                                 as sign_teller_id	       --签约柜员编号
   ,t1.sign_cont_id	                                 as sign_cont_id	       --签约合同编号
   ,t1.cotas_name	                                 as cotas_name	           --联系人名称
   ,t1.phone_num	                                 as phone_num	           --联系电话号码
   ,t2.resv_phone_num	                             as resv_phone_num	       --备用联系电话号码
   ,t1.job_cd                                        as job_cd                 --任务代码    
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') --ETL处理时间戳
from ${iml_schema}.agt_bkcp_check_acct_info_h t1
left join (select acct_id,sign_dt,org_id,teller_id,resv_phone_num
                  ,row_number() over (partition by acct_id order by sign_dt desc ) rn
             from ${iml_schema}.agt_bkcp_check_sign_h 
            where start_dt <= to_date('${batch_date}','yyyymmdd') 
              and end_dt > to_date('${batch_date}','yyyymmdd')
              and job_cd='cabsi1'
           ) t2
  on t2.acct_id = t1.acct_id
 and t2.rn=1
left join (select accno,accnoson,acccycle,docdate
                  ,row_number() over (partition by accno,accnoson order by docdate desc ) rn   
             from ${iol_schema}.cabs_ebs_accnomaindata
			where start_dt <= to_date('${batch_date}','yyyymmdd') 
              and end_dt > to_date('${batch_date}','yyyymmdd')) t3
  on t3.accno = t1.acct_id 
 and t3.accnoson=t1.sub_acct_id
 and t3.rn=1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') 
 and t1.end_dt > to_date('${batch_date}','yyyymmdd')	
 and t1.job_cd = 'cabsf1'
 and t1.id_mark <> 'D'
 and trim(t1.sub_acct_id) is not null
;
commit;


-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_bkcp_check_acct_basic_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_bkcp_check_acct_basic_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_bkcp_check_acct_basic_info_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_bkcp_check_acct_basic_info', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
