/*
Purpose:    应用集市层-跑数脚本。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py ${batch_date} idl_dpss_agt_dpst_acct_info
CreateDate: 20201229
FileType:   DML
Logs:
    dongyl 2020-12-29 新建表本
    cxq    2021-07-07 修改执行利率取值口径，取最小的利率
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.dpss_agt_dpst_acct_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${idl_schema}.dpss_agt_dpst_acct_info_ex purge;
drop table ${idl_schema}.dpss_agt_dpst_acct_info_tmp01 purge;


-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dpss_agt_dpst_acct_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${idl_schema}.dpss_agt_dpst_acct_info where 0=1;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dpss_agt_dpst_acct_info_tmp01
nologging
compress ${option_switch} for query high
as
select * from ${idl_schema}.dpss_agt_dpst_acct_info where 0=1;


-- 2.2 insert data to tmp table

		   
insert/*+append*/ into ${idl_schema}.dpss_agt_dpst_acct_info_tmp01(
        ETL_DT                          --数据日期                     
       ,DATA_SRC_CD                          --数据来源代码            
       ,DEL_FLG                          --删除标志                    
       ,DPST_ACCT_ID                          --存款产品户编号         
       ,PRD_ID                          --产品编号                     
       ,DPST_ACCT_NUM                          --存款账户编号          
       ,SUB_NUM                          --子户号                      
       ,BLNG_PTY_ID                          --所属客户编号            
       ,ACCT_NAME                          --账户名称                  
       ,DACCT_TYP_CD                          --存款分户类型代码       
       ,OPEN_DT                          --开户日期                    
       ,OPEN_TM                          --开户时间                    
       ,INT_START_DT                          --起息日期               
       ,DUE_DT                          --到期日期                     
       ,PREV_ACTI_ACCT_DT                          --上次动户日期      
       ,COLSE_DT                          --销户日期                   
       ,ACCT_STATS_CD                          --账户状态代码          
       ,STOP_PAY_STATUS_CD                          --止付状态代码     
       ,OPEN_ORG_ID                          --开户机构编号            
       ,COLSE_ORG_ID                          --销户机构编号           
       ,OPEN_TELLER_ID                          --开户柜员编号         
       ,COLSE_TELLER_ID                          --销户柜员编号        
       ,PTY_MGR_ID                          --客户经理编号             
       ,CASH_REMIT_IND_CD                          --钞汇标识代码      
       ,DPS_TYPE_CD                          --储种代码                
       ,USW_FLG                          --通存通兑标志                
       ,SLEEP_FLG                          --睡眠户标志                
       ,CCY_CD                          --币种代码                     
       ,ACCT_BAL                          --账户余额                   
       ,USABLE_BAL                          --可用余额                 
       ,DACCT_ACCT_FRZ_AMT                          --冻结金额         
       ,STOP_PAY_AMT                          --止付金额               
       ,RATE_BASE_TYP_CD                          --利率基准类型代码   
       ,RATE_BASE_VAL                          --利率基准值            
       ,FLOAT_RATE_FLG                          --浮动利率标志         
       ,RATE_FLOAT_MODE_CD                          --利率浮动方式代码 
       ,RATE_FLOAT_VAL                          --利率浮动值           
       ,EXEC_RATE                          --执行利率                  
       ,RCVA_INT                          --应计利息                   
       ,DAY_ACCR_INT                          --日应计利息             
       ,DACCT_STL_MODE_CD                          --结息方式代码      
       ,DACCT_INTR_MTH_CD                          --计息方式代码      
       ,MERCH_ID                          --商户编号                   
       ,MERCH_NAME                          --商户名称                 
       ,MERCH_UP_LINE_DT                          --商户上线日期       
       ,INT_BASE_CD                          --计息基准代码            
       ,EXPT_HIGHEST_YLD                          --预期最高收益率     
       ,CONTR_ID                          --合同编号                   
       ,CONTR_DUE_DT                          --合同到期日期           
       ,CO_ORG_NAME                          --合作机构名称            
       ,ISSUE_DPST_PROOF_BK_FLG--开立存款证实书标志
       ,cust_acct_id                     --客户账户编号                 
       ,cust_sub_acct_num                --客户账户子户号
       ,term_code                        --存期编码
       ,JOB_CD                          --任务代码                     
       ,ETL_TIMESTAMP                          --任务处理时间          
) 
select
   to_date('${batch_date}','yyyymmdd')  as etl_dt                          --数据日期
  ,'DPSS' as DATA_SRC_CD  --数据来源代码 
  ,'0' as DEL_FLG   --删除标志 
  ,case when t9.contract_id is not null 
        then (case when length(t9.contract_id)>= 10 
                   then t9.contract_id
                   else 'D'||lpad(t9.contract_id,'9',0) 
                    end) 
        else (case when t1.dep_kind in ('26', '27') then t7.rsv_adfld  
                   when t1.dep_kind='30' then decode(nvl(t7.contract_cod,' '),' ',t2.cust_acctno,'T'||substr(t7.contract_cod,-9))
                   else t2.cust_acctno 
                    end) 
         end  as dpst_acct_id                                              --存款产品户编号

  ,nvl(decode(t8.rsv_affld,' ',null,t8.rsv_affld),t5.value_dscp)      as prd_id                          --产品编号         
  ,case when t1.dep_kind in ('29') then nvl(decode(t6.rsv_acfld,' ',null,t6.rsv_acfld),'XXX') 
        when t1.dep_kind in ('26','27') then nvl(decode(t6.rsv_adfld,' ',null,t6.rsv_adfld),'XXX') 
        else (case when length(nvl(decode(t6.rsv_adfld,' ',null,t6.rsv_adfld),'XXX'))>=15 then nvl(decode(t6.rsv_adfld,' ',null,t6.rsv_adfld),'XXX') 
                   else nvl(decode(t6.rsv_acfld,' ',null,t6.rsv_acfld),'XXX') 
                   end) 
         end  as dpst_acct_num                                             --存款账户编号
  ,nvl(t3.sub_num,'')  as sub_num                                          --子户号
  ,T1.REL_CUSTNUM as BLNG_PTY_ID                          --所属客户编号  
  ,t1.acctno_name      as acct_name                                        --账户名称                                                  
  ,case when t1.dep_kind='01' then 'A02' 
        else 'C29' end as dacct_typ_cd                                     --存款分户类型代码      
  ,trunc(to_date(T1.ACCT_OPEC_DATE,'YYYY-MM-DD'))       --开户日期
  ,''                                                  --开户时间
  ,trunc(to_date(decode(T4.INTC_BDATE,' ',null,T4.INTC_BDATE),'yyyy-mm-dd')) as int_start_dt            --起息日期  
  ,trunc(to_date(decode(t1.acct_due_date,' ',null,t1.acct_due_date),'yyyy-mm-dd')) as due_dt              --到期日期  
  ,trunc(to_date(decode(t1.last_upddate,' ',null,t1.last_upddate),'yyyy-mm-dd')) as prev_acti_acct_dt         --上次动户日期       
  ,trunc(to_date(decode(t1.acctno_clsd_date,' ',null,t1.acctno_clsd_date),'yyyy-mm-dd')) as colse_dt          --销户日期                                                                                                                                                      
  ,case when t1.dpa_asts='A' then 'DS01' 
        when t1.dpa_asts='C' then 'DS38' 
        when t1.dpa_asts='R' then 'DS44'  
        when t1.dpa_asts='Z' then 'DS39' 
        else 'DS99' end as acct_stats_cd                                   --账户状态代码   
  ,'0' as STOP_PAY_STATUS_CD                          --止付状态代码         
  ,case when T15.open_org_id is null  then T1.ACCT_OPEC_OPUN 
        else T15.open_org_id end as OPEN_ORG_ID                          --开户机构编号                
  ,T1.ACCTNO_CLSD_UNIT as COLSE_ORG_ID                          --销户机构编号               
  ,'M0001' as OPEN_TELLER_ID                          --开户柜员编号            
  ,case when T1.Rec_Sts='1' then 'M0001' else '' end as COLSE_TELLER_ID                          --销户柜员编号           
  ,'' as PTY_MGR_ID                          --客户经理编号            
  ,'' as CASH_REMIT_IND_CD                          --钞汇标识代码     
  ,nvl(T8.rsv_acfld,'000') as DPS_TYPE_CD                          --储种代码               
  ,'1' as USW_FLG                          --通存通兑标志               
  ,'0' as SLEEP_FLG                          --睡眠户标志               
  ,nvl(T10.Curr_Simple,'CNY') as CCY_CD                          --币种代码                    
  ,round(T1.CUR_BAL,nvl(T10.Min_Cur_Unit,2)) as ACCT_BAL                          --账户余额                  
  ,case when T1.DPA_ASTS='Z' then round(0.00,nvl(T10.Min_Cur_Unit,2)) else   round(T1.CUR_BAL,nvl(T10.Min_Cur_Unit,2))  end  as USABLE_BAL                          --可用余额                
  ,0.00 as DACCT_ACCT_FRZ_AMT                          --冻结金额        
  ,case when T1.DPA_ASTS='Z' then  round(T1.CUR_BAL,nvl(T10.Min_Cur_Unit,2)) else round(0.00,nvl(T10.Min_Cur_Unit,2)) end  as STOP_PAY_AMT                          --止付金额                
  ,'' as RATE_BASE_TYP_CD                          --利率基准类型代码  
  ,'' as RATE_BASE_VAL                          --利率基准值           
  ,'0' as FLOAT_RATE_FLG                          --浮动利率标志        
  ,'' as RATE_FLOAT_MODE_CD                          --利率浮动方式代码
  ,0.00 as RATE_FLOAT_VAL                          --利率浮动值          
  ,(case when T1.Rec_Sts='1' 
     then (case when t13.cur_execrate is null then 0.00 else t13.cur_execrate end)
         else t4.last_rcal_rate end)*0.01  as exec_rate                    --执行利率    
  ,round(nvl(T4.ACRU_INT,0.00),nvl(T10.Min_Cur_Unit,2))  as RCVA_INT   --应计利息
  ,round(nvl(T4.INT_LDAYCAD,0.00),nvl(T10.Min_Cur_Unit,2))  as DAY_ACCR_INT --日应计利息
  ,case when  T4.PAY_INT_CYCL = '12MA21' then 'B1'
        when  T4.PAY_INT_CYCL = '6MA21' then 'B5'
        when  T4.PAY_INT_CYCL = '1QA21' then 'B2'
        when  T4.PAY_INT_CYCL = '1MA21' then 'B3'
        else  'A0' end as DACCT_STL_MODE_CD   --结息方式代码
  --,t11.list_cbs_cd     as dacct_intr_mth_cd                                --计息方式代码
  ,t8.rsv_aefld        as dacct_intr_mth_cd                                --计息方式代码  --zhujj
  ,'' as MERCH_ID                          --商户编号                       
  ,'' as MERCH_NAME                          --商户名称                        
  ,null as MERCH_UP_LINE_DT                          --商户上线日期          
  ,'01' as INT_BASE_CD                          --计息基准代码               
  ,'' as EXPT_HIGHEST_YLD                          --预期最高收益率      
  ,'' as CONTR_ID                          --合同编号                    
  ,'' as CONTR_DUE_DT                          --合同到期日期            
  ,'' as CO_ORG_NAME                          --合作机构名称             
  ,'' as ISSUE_DPST_PROOF_BK_FLG--开立存款证实书标志                             
  ,t6.rsv_acfld        as cust_acct_id                                     --客户账户编号
  ,t6.rsv_adfld        as cust_sub_acct_num                                --客户账户子户号 
  ,case when t1.acct_dep_term ='1M'  then '201'                
        when t1.acct_dep_term ='3M'  then '203'
        when t1.acct_dep_term ='6M'  then '206'
        when t1.acct_dep_term ='9M'  then '209'
        when t1.acct_dep_term ='1Y'  then '301'
        when t1.acct_dep_term ='18M' then '218'
        when t1.acct_dep_term ='2Y'  then '302' 
        when t1.acct_dep_term ='3Y'  then '303'
        when t1.acct_dep_term ='5Y'  then '305'
        else '000' end as term_code                                        --存期类型代码
  ,'part1'                                                                             as job_cd                          --任务代码     
  ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                     as etl_timestamp                   --数据处理时间                                                             
     from ${iol_schema}.dpss_dpa_acctinf t1  --负债账户信息表
left join ${iol_schema}.dpss_dpa_custacctref t2  --客户账号对照表
       on t1.dpact_no=t2.sys_acctno  
      and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
      and t2.end_dt > to_date('${batch_date}','yyyymmdd')
left join ${iol_schema}.dpss_ref_dpst_acct_sub_num t3
       on t3.cust_acctno =  t1.cust_acctno    
      and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
      and t3.end_dt > to_date('${batch_date}','yyyymmdd')  
left join ${iol_schema}.dpss_dpa_acrudef t4 
       on t1.dpact_no=t4.dpact_no  
      and t4.int_cod='INTERT'
      and T4.start_dt <= to_date('${batch_date}','yyyymmdd')
      and T4.end_dt > to_date('${batch_date}','yyyymmdd')
left join ${iol_schema}.dpss_dpp_flgnamdef t5 
       on t1.prod_cd=t5.flag_field_name               
      and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
      and t5.end_dt > to_date('${batch_date}','yyyymmdd')
left join ${iol_schema}.dpss_dpa_acctinf_add t6 
       on t1.dpact_no=t6.dpact_no 
      and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
      and t6.end_dt > to_date('${batch_date}','yyyymmdd')               
left join ${iol_schema}.dpss_dpa_cdcont t7 --大额存单认购合约表
       on t1.dpact_no=t7.dpact_no
      and t7.start_dt <= to_date('${batch_date}','yyyymmdd')
      and t7.end_dt > to_date('${batch_date}','yyyymmdd')  
left join ${iol_schema}.dpss_dpp_commpara t8 
       on t8.para_kind=t1.dep_kind 
      and t8.para_cod='001'                  
      and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
      and t8.end_dt > to_date('${batch_date}','yyyymmdd')
left join ${iol_schema}.dpss_dps_dpactnodef t9 
       on t9.dpact_no=t1.dpact_no                     
      and t9.start_dt <= to_date('${batch_date}','yyyymmdd')
      and t9.end_dt > to_date('${batch_date}','yyyymmdd')
left join ${iol_schema}.dpss_pmp_curr t10 --货币参数表
       on t6.curr_code=t10.curr_code 
      and t10.start_dt <= to_date('${batch_date}','yyyymmdd')
      and t10.end_dt > to_date('${batch_date}','yyyymmdd')  
/*left join ${idl_schema}.m_sys_lspz t11
       on t11.list_std_cd = t8.rsv_aefld
      and t11.list_cd = 'DACCT_INTR_MTH_CD'*/    --zhujj
      --20201228 到期日期取历史表数据，可以往回重跑 dyl
/*left join ${iml_schema}.agt_imp_dt_h t12 --协议重要日期历史
       on '120014'||t1.dpact_no = t12.agt_id
      and t12.dt_type_cd = '46'
      and t12.job_cd = 'dpssf1'
      and t12.start_dt <= to_date('${batch_date}','yyyymmdd')
      and t12.end_dt > to_date('${batch_date}','yyyymmdd')*/
left join (select dpact_no,cur_execrate,Row_Number() Over(PARTITION BY dpact_no ORDER BY cur_execrate ) as rn --mdf by zyx 20210928 取最小利率
             from ${iol_schema}.dpss_dpj_payintdet 
            where IN_TXN_COD in('dp116','dpa20') 
              and start_dt <= to_date('${batch_date}','yyyymmdd')
              and end_dt > to_date('${batch_date}','yyyymmdd')) t13
    on t1.dpact_no = t13.dpact_no and t13.rn=1
left join (select open_org_id,liab_acct
						 from ${iol_schema}.dpss_dps_transfer_application
					 where status_id='2'and acct_date=to_char('${batch_date}' -1)
					       and start_dt <= to_date('${batch_date}','yyyymmdd')
                 and end_dt > to_date('${batch_date}','yyyymmdd')
                 and rownum=1
             order by last_updated_stamp)T15
             on t15.liab_acct=T1.dpact_no
    where t1.acct_opec_date<=${batch_date}
      and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
      and t1.end_dt > to_date('${batch_date}','yyyymmdd')

union

select
   to_date('${batch_date}','yyyymmdd')       as etl_dt            --数据日期
  ,'DPSS' as DATA_SRC_CD  --数据来源代码 
  ,'0' as DEL_FLG   --删除标志 
  ,t1.dpst_acct_id                           as dpst_acct_id      --存款产品户编号   
  ,t1.prd_id                                 as prd_id            --产品编号       
  ,t1.dpst_acct_num                          as dpst_acct_num     --存款账户编号
  ,t1.sub_num                                as sub_num           --子户号     
  ,t1.BLNG_PTY_ID as BLNG_PTY_ID  --所属客户编号 选填
  ,t1.acct_name                              as acct_name         --账户名称   
  ,t1.dacct_typ_cd                           as dacct_typ_cd      --存款分户类型代码   
  ,t1.OPEN_DT              --开户日期      必填
  ,t1.OPEN_TM              --开户时间      选填    
  ,t1.int_start_dt                           as int_start_dt      --起息日期     
  ,t1.due_dt                                 as due_dt            --到期日期 
  ,t1.prev_acti_acct_dt                      as prev_acti_acct_dt --上次动户日期        
  ,t1.colse_dt                               as colse_dt          --销户日期     
  ,t1.acct_stats_cd                          as acct_stats_cd     --账户状态代码       
  ,t1.STOP_PAY_STATUS_CD                          --止付状态代码         
  ,t1.OPEN_ORG_ID                          --开户机构编号                
  ,t1.COLSE_ORG_ID                          --销户机构编号               
  ,t1.OPEN_TELLER_ID                          --开户柜员编号            
  ,t1.COLSE_TELLER_ID                          --销户柜员编号           
  ,t1.PTY_MGR_ID                          --客户经理编号            
  ,t1.CASH_REMIT_IND_CD                          --钞汇标识代码     
  ,t1.DPS_TYPE_CD                          --储种代码               
  ,t1.USW_FLG                          --通存通兑标志               
  ,t1.SLEEP_FLG                          --睡眠户标志               
  ,t1.CCY_CD                          --币种代码                    
  ,t1.ACCT_BAL                          --账户余额                  
  ,t1.USABLE_BAL                          --可用余额                
  ,t1.DACCT_ACCT_FRZ_AMT                          --冻结金额        
  ,t1.STOP_PAY_AMT                          --止付金额                
  ,t1.RATE_BASE_TYP_CD                          --利率基准类型代码  
  ,'' as RATE_BASE_VAL                          --利率基准值           
  ,t1.FLOAT_RATE_FLG                          --浮动利率标志        
  ,t1.RATE_FLOAT_MODE_CD                          --利率浮动方式代码
  ,t1.RATE_FLOAT_VAL                          --利率浮动值          
  ,nvl(t1.exec_rate,0.00)                    as exec_rate         --执行利率        
  ,nvl(t1.RCVA_INT,0.00)             --应计利息       必填
  ,nvl(t1.DAY_ACCR_INT,0.00)         --日应计利息      必填
  ,t1.DACCT_STL_MODE_CD    --结息方式代码     必填           
 -- ,t11.list_cbs_cd                           as dacct_intr_mth_cd --计息方式代码   
  ,t1.dacct_intr_mth_cd                 --zhujj
  ,t1.MERCH_ID             --商户编号        选填
  ,t1.MERCH_NAME           --商户名称        选填
  ,t1.MERCH_UP_LINE_DT     --商户上线日期      选填
  ,t1.INT_BASE_CD          --计息基准代码
  ,''     --预期最高收益率
  ,''             --合同编号
  ,''         --合同到期日期
  ,''          --合作机构名称
  ,ISSUE_DPST_PROOF_BK_FLG  --开立存款证实书标志
  ,''                                        as cust_acct_id      --客户账户编号
  ,''                                        as cust_sub_acct_num --客户账户子户号   
  ,null                                      as term_code         --存期编码  
  ,'part1'                                   as job_cd            --任务代码     
  ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp                   --数据处理时间                                                                            
  from ${iol_schema}.dpss_agt_dpst_acct_call_cfb_info t1
/*left join ${idl_schema}.m_sys_lspz t11
       on t11.list_std_cd = t1.dacct_intr_mth_cd
      and t11.list_cd = 'DACCT_INTR_MTH_CD'     
    where etl_dt = to_date('${batch_date}','yyyymmdd')
    */   --zhujj
;
commit;

insert/*+append*/ into ${idl_schema}.dpss_agt_dpst_acct_info_ex(
        ETL_DT                          --数据日期                     
       ,DATA_SRC_CD                          --数据来源代码            
       ,DEL_FLG                          --删除标志                    
       ,DPST_ACCT_ID                          --存款产品户编号         
       ,PRD_ID                          --产品编号                     
       ,DPST_ACCT_NUM                          --存款账户编号          
       ,SUB_NUM                          --子户号                      
       ,BLNG_PTY_ID                          --所属客户编号            
       ,ACCT_NAME                          --账户名称                  
       ,DACCT_TYP_CD                          --存款分户类型代码       
       ,OPEN_DT                          --开户日期                    
       ,OPEN_TM                          --开户时间                    
       ,INT_START_DT                          --起息日期               
       ,DUE_DT                          --到期日期                     
       ,PREV_ACTI_ACCT_DT                          --上次动户日期      
       ,COLSE_DT                          --销户日期                   
       ,ACCT_STATS_CD                          --账户状态代码          
       ,STOP_PAY_STATUS_CD                          --止付状态代码     
       ,OPEN_ORG_ID                          --开户机构编号            
       ,COLSE_ORG_ID                          --销户机构编号           
       ,OPEN_TELLER_ID                          --开户柜员编号         
       ,COLSE_TELLER_ID                          --销户柜员编号        
       ,PTY_MGR_ID                          --客户经理编号             
       ,CASH_REMIT_IND_CD                          --钞汇标识代码      
       ,DPS_TYPE_CD                          --储种代码                
       ,USW_FLG                          --通存通兑标志                
       ,SLEEP_FLG                          --睡眠户标志                
       ,CCY_CD                          --币种代码                     
       ,ACCT_BAL                          --账户余额                   
       ,USABLE_BAL                          --可用余额                 
       ,DACCT_ACCT_FRZ_AMT                          --冻结金额         
       ,STOP_PAY_AMT                          --止付金额               
       ,RATE_BASE_TYP_CD                          --利率基准类型代码   
       ,RATE_BASE_VAL                          --利率基准值            
       ,FLOAT_RATE_FLG                          --浮动利率标志         
       ,RATE_FLOAT_MODE_CD                          --利率浮动方式代码 
       ,RATE_FLOAT_VAL                          --利率浮动值           
       ,EXEC_RATE                          --执行利率                  
       ,RCVA_INT                          --应计利息                   
       ,DAY_ACCR_INT                          --日应计利息             
       ,DACCT_STL_MODE_CD                          --结息方式代码      
       ,DACCT_INTR_MTH_CD                          --计息方式代码      
       ,MERCH_ID                          --商户编号                   
       ,MERCH_NAME                          --商户名称                 
       ,MERCH_UP_LINE_DT                          --商户上线日期       
       ,INT_BASE_CD                          --计息基准代码            
       ,EXPT_HIGHEST_YLD                          --预期最高收益率     
       ,CONTR_ID                          --合同编号                   
       ,CONTR_DUE_DT                          --合同到期日期           
       ,CO_ORG_NAME                          --合作机构名称            
       ,ISSUE_DPST_PROOF_BK_FLG--开立存款证实书标志
       ,cust_acct_id                     --客户账户编号                 
       ,cust_sub_acct_num                --客户账户子户号
       ,term_code                        --存期编码
       ,JOB_CD                          --任务代码                     
       ,ETL_TIMESTAMP                          --任务处理时间          
) 

select
t1.ETL_DT                 
,t1.DATA_SRC_CD            
,t1.DEL_FLG                
,t1.DPST_ACCT_ID           
,t1.PRD_ID                 
,t1.DPST_ACCT_NUM          
,t1.SUB_NUM                
,t1.BLNG_PTY_ID            
,t1.ACCT_NAME              
,t1.DACCT_TYP_CD           
,t1.OPEN_DT                
,t1.OPEN_TM                
,t1.INT_START_DT           
,t1.DUE_DT                 
,t1.PREV_ACTI_ACCT_DT      
,t1.COLSE_DT               
,t1.ACCT_STATS_CD          
,t1.STOP_PAY_STATUS_CD     
,t1.OPEN_ORG_ID            
,t1.COLSE_ORG_ID           
,t1.OPEN_TELLER_ID         
,t1.COLSE_TELLER_ID        
,t1.PTY_MGR_ID             
,t1.CASH_REMIT_IND_CD      
,t1.DPS_TYPE_CD            
,t1.USW_FLG                
,t1.SLEEP_FLG              
,t1.CCY_CD                 
,nvl(t2.currt_bal,t1.ACCT_BAL)              
,t1.USABLE_BAL             
,t1.DACCT_ACCT_FRZ_AMT     
,t1.STOP_PAY_AMT           
,t1.RATE_BASE_TYP_CD       
,t1.RATE_BASE_VAL          
,t1.FLOAT_RATE_FLG         
,t1.RATE_FLOAT_MODE_CD     
,t1.RATE_FLOAT_VAL         
,t1.EXEC_RATE              
,t1.RCVA_INT               
,t1.DAY_ACCR_INT           
,t1.DACCT_STL_MODE_CD      
,t1.DACCT_INTR_MTH_CD      
,t1.MERCH_ID               
,t1.MERCH_NAME             
,t1.MERCH_UP_LINE_DT       
,t1.INT_BASE_CD            
,t1.EXPT_HIGHEST_YLD       
,t1.CONTR_ID               
,t1.CONTR_DUE_DT           
,t1.CO_ORG_NAME            
,t1.ISSUE_DPST_PROOF_BK_FLG
,t1.cust_acct_id           
,t1.cust_sub_acct_num      
,t1.term_code              
,t1.JOB_CD                 
,t1.ETL_TIMESTAMP    
from ${idl_schema}.dpss_agt_dpst_acct_info_tmp01 t1   
left join ${icl_schema}.cmm_e_acct_info  t2
on t1.DPST_ACCT_ID=t2.old_acct_id
 and t2.etl_dt=to_date('${batch_date}','yyyymmdd')
where t1.etl_dt=to_date('${batch_date}','yyyymmdd');

commit;

-- 2.3 exchage ex table and target table
alter table ${idl_schema}.dpss_agt_dpst_acct_info exchange partition p_${batch_date} with table ${idl_schema}.dpss_agt_dpst_acct_info_ex;

-- 3.1 drop ex table
drop table ${idl_schema}.dpss_agt_dpst_acct_info_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'dpss_agt_dpst_acct_info', partname => 'p_${batch_date}',  estimate_percent => 10, method_opt => 'for all columns size 1', no_invalidate => false ,granularity => 'PARTITION', degree => 8, cascade => true, force => true);  
  
  