/*
Purpose:    共性加工层-电子渠道账户签约信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20220930 icl_cmm_elec_chn_acct_sign_info
CreateDate: 20210412
Logs:	
 update by: htj
 update time:20210427
 update comment: substr(t1.open_prvlg_flg_comb,1,1) 	

            20221027 温旺清 【签约渠道代码】渠道代码落标调整，引用代码：CD1751 。1006 -->301001	；1007-->302001；1018-->301003；1024-->302005 
            20221202 陈伟峰 调整tbps部分【账户状态代码】逻辑，M层引用CD2184，与osbs不一致（CD1817），调整成一致
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_elec_chn_acct_sign_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_elec_chn_acct_sign_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_elec_chn_acct_sign_info_ex purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_elec_chn_acct_sign_info_ex nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_elec_chn_acct_sign_info where 0=1;

-- 第一组（共四组）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_elec_chn_acct_sign_info_ex(
	 etl_dt	                             -- 数据日期
   ,lp_id	                             -- 法人编号
   ,acct_id                            -- 账户编号    
   ,open_chn_type_cd                   -- 开通渠道类型代码
   ,sign_chn_cd                        -- 签约渠道代码  
   ,acct_status_cd                     -- 账户状态代码  
   ,vouch_type_cd                      -- 凭证类型代码  
   ,user_id                            -- 用户编号    
   ,cust_id                            -- 客户编号    
   ,acct_alias                         -- 账户别名    
   ,acct_add_dt                        -- 账户加挂日期  
   ,acct_add_org                       -- 账户加挂机构  
   ,tran_prvlg_open_flg                -- 转账权限开通标志
   ,apot_tran_open_flg                 -- 约定转账开通标志
   ,card_type_cd                       -- 卡类型代码   
   ,job_cd                             -- 任务代码
   ,etl_timestamp                      -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd') -- 数据日期
   ,t1.lp_id	                         -- 法人编号
   ,t1.acct_id                         -- 账户编号
   ,t1.sign_way_cd                     -- 开通渠道类型代码
   ,'301001'                             -- 签约渠道代码
   ,t1.acct_status_cd                  -- 账户状态代码
   ,t1.acct_type_cd                    -- 凭证类型代码
   ,t1.cust_id                         -- 用户编号
   ,t1.cust_id                         -- 客户编号
   ,t1.acct_alias                      -- 账户别名
   ,trunc(t1.acct_in_tm)               -- 账户加挂日期
   ,t1.add_org_id                      -- 账户加挂机构
   ,substr(t1.open_prvlg_flg_comb,1,1) -- 转账权限开通标志
   ,substr(t1.open_prvlg_flg_comb,2,1) -- 约定转账开通标志
   ,t1.co_card_type_cd                 -- 卡类型代码 
   ,t1.job_cd                          -- 任务代码
	 ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iml_schema}.agt_ponl_bk_add_acct_h t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
  and t1.job_cd = 'osbsf1'
;
commit;

-- 第二组（共四组）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_elec_chn_acct_sign_info_ex(
	 etl_dt	                             -- 数据日期
   ,lp_id	                             -- 法人编号
   ,acct_id                            -- 账户编号    
   ,open_chn_type_cd                   -- 开通渠道类型代码
   ,sign_chn_cd                        -- 签约渠道代码  
   ,acct_status_cd                     -- 账户状态代码  
   ,vouch_type_cd                      -- 凭证类型代码  
   ,user_id                            -- 用户编号    
   ,cust_id                            -- 客户编号    
   ,acct_alias                         -- 账户别名    
   ,acct_add_dt                        -- 账户加挂日期  
   ,acct_add_org                       -- 账户加挂机构  
   ,tran_prvlg_open_flg                -- 转账权限开通标志
   ,apot_tran_open_flg                 -- 约定转账开通标志
   ,card_type_cd                       -- 卡类型代码   
   ,job_cd                             -- 任务代码
   ,etl_timestamp                      -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd') -- 数据日期
   ,t1.lp_id	                         -- 法人编号
   ,t1.acct_id                         -- 账户编号
   ,t1.sign_way_cd                     -- 开通渠道类型代码
   ,'302001'                             -- 签约渠道代码
   ,t1.acct_status_cd                  -- 账户状态代码
   ,t1.acct_type_cd                    -- 凭证类型代码
   ,t1.cust_id                         -- 用户编号
   ,t1.cust_id                         -- 客户编号
   ,t1.acct_alias                      -- 账户别名
   ,trunc(t1.acct_in_tm)               -- 账户加挂日期
   ,t1.add_org_id                      -- 账户加挂机构
   ,substr(t1.open_prvlg_flg_comb,1,1) -- 转账权限开通标志  --update by htj 20210426
  -- ,t1.open_prvlg_flg_comb             -- 转账权限开通标志
  --,t1.open_prvlg_flg_comb             -- 约定转账开通标志 --update by chf 20210429
   ,substr(t1.open_prvlg_flg_comb,2,1) -- 约定转账开通标志
   ,t1.co_card_type_cd                 -- 卡类型代码 
   ,t1.job_cd                          -- 任务代码
	 ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iml_schema}.agt_ponl_bk_add_acct_h t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
  and t1.job_cd = 'osbsf1'
;
commit;

-- 第三组（共四组）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_elec_chn_acct_sign_info_ex(
	 etl_dt	                             -- 数据日期
   ,lp_id	                             -- 法人编号
   ,acct_id                            -- 账户编号    
   ,open_chn_type_cd                   -- 开通渠道类型代码
   ,sign_chn_cd                        -- 签约渠道代码  
   ,acct_status_cd                     -- 账户状态代码  
   ,vouch_type_cd                      -- 凭证类型代码  
   ,user_id                            -- 用户编号    
   ,cust_id                            -- 客户编号    
   ,acct_alias                         -- 账户别名    
   ,acct_add_dt                        -- 账户加挂日期  
   ,acct_add_org                       -- 账户加挂机构  
   ,tran_prvlg_open_flg                -- 转账权限开通标志
   ,apot_tran_open_flg                 -- 约定转账开通标志
   ,card_type_cd                       -- 卡类型代码   
   ,job_cd                             -- 任务代码
   ,etl_timestamp                      -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd') -- 数据日期
   ,t1.lp_id	                         -- 法人编号
   ,t1.ACCT_ID                     -- 账户编号
   ,t1.ACCT_CATE_CD                -- 开通渠道类型代码
   ,'302005'                         -- 签约渠道代码
   ,decode(t1.acct_status_cd,'0','1','1','11','2','B','3','C','-')          -- 账户状态代码
   ,t1.ACCT_CATE_CD                -- 凭证类型代码
   ,''                             -- 用户编号
   ,t1.CUST_ID                     -- 客户编号
   ,''                             -- 账户别名
   ,trunc(t1.FIR_BIND_TM)          -- 账户加挂日期
   ,t1.OPEN_ACCT_ORG_ID            -- 账户加挂机构
   ,CASE WHEN T2.CUST_TYPE_CD='1' THEN '1' 
     WHEN (SELECT COUNT(*)
             FROM ${iol_schema}.osbs_cpr_auth_conf F
            WHERE F.CAC_GROUPID IN ('BEdraft','BEinvestment','BExpense','BNoticeDraw','BSalary','BTimSav','BTransfer','BLegalOverDraft','BOnlineFinance','BEInnerAccount','BSalaryRefund')
              AND F.CAC_ACCNO = T1.ACCT_ID
              AND F.START_DT <= to_date('${batch_date}','yyyymmdd')
              AND F.END_DT > to_date('${batch_date}','yyyymmdd'))>0
     THEN '1' 
     ELSE '0' 
      END          -- 转账权限开通标志
   ,'1'            -- 约定转账开通标志
   ,''             -- 卡类型代码 
   ,t1.job_cd                          -- 任务代码
	 ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iml_schema}.agt_tran_bank_acct t1
 left join ${iml_schema}.pty_tran_bank_corp_info t2
   on t1.cust_id = t2.party_id
  and t2.job_cd = 'tbpsf1'
  and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t2.id_mark <> 'D'
where t1.acct_cate_cd <> 'EMPD' 
  and t1.acct_id <> '9999' 
  and t2.sign_yqt_flg ='1'
  and t1.job_cd = 'tbpsf1'
  and t1.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.id_mark <> 'D'
;
commit;

-- 第四组（共四组）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_elec_chn_acct_sign_info_ex(
	 etl_dt	                             -- 数据日期
   ,lp_id	                             -- 法人编号
   ,acct_id                            -- 账户编号    
   ,open_chn_type_cd                   -- 开通渠道类型代码
   ,sign_chn_cd                        -- 签约渠道代码  
   ,acct_status_cd                     -- 账户状态代码  
   ,vouch_type_cd                      -- 凭证类型代码  
   ,user_id                            -- 用户编号    
   ,cust_id                            -- 客户编号    
   ,acct_alias                         -- 账户别名    
   ,acct_add_dt                        -- 账户加挂日期  
   ,acct_add_org                       -- 账户加挂机构  
   ,tran_prvlg_open_flg                -- 转账权限开通标志
   ,apot_tran_open_flg                 -- 约定转账开通标志
   ,card_type_cd                       -- 卡类型代码   
   ,job_cd                             -- 任务代码
   ,etl_timestamp                      -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd') -- 数据日期
   ,t1.lp_id	                         -- 法人编号
   ,t1.ACCT_ID                     -- 账户编号
   ,t1.ACCT_CATE_CD                -- 开通渠道类型代码
   ,'301003'                         -- 签约渠道代码
   ,decode(t1.acct_status_cd,'0','1','1','11','2','B','3','C','-')              -- 账户状态代码
   ,t1.ACCT_CATE_CD                -- 凭证类型代码
   ,''                             -- 用户编号
   ,t1.CUST_ID                     -- 客户编号
   ,''                             -- 账户别名
   ,trunc(t1.FIR_BIND_TM)          -- 账户加挂日期
   ,t1.OPEN_ACCT_ORG_ID            -- 账户加挂机构
   ,CASE WHEN T2.CUST_TYPE_CD='1' THEN '1' 
     WHEN (SELECT COUNT(*)
             FROM ${iol_schema}.OSBS_CPR_AUTH_CONF F
            WHERE F.CAC_GROUPID IN ('BEdraft','BEinvestment','BExpense','BNoticeDraw','BSalary','BTimSav','BTransfer','BLegalOverDraft','BOnlineFinance','BEInnerAccount','BSalaryRefund')
              AND F.CAC_ACCNO = T1.ACCT_ID
              AND F.START_DT <= to_date('${batch_date}','yyyymmdd')
              AND F.END_DT > to_date('${batch_date}','yyyymmdd'))>0
     THEN '1' 
     ELSE '0' 
      END          -- 转账权限开通标志
   ,'1'            -- 约定转账开通标志
   ,''             -- 卡类型代码 
   ,t1.job_cd                          -- 任务代码
	 ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iml_schema}.agt_tran_bank_acct t1
 left join ${iml_schema}.pty_tran_bank_corp_info t2
   on t1.cust_id = t2.party_id
  and t2.job_cd = 'tbpsf1'
  and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t2.id_mark <> 'D'
where t1.acct_cate_cd <> 'EMPD' 
  and t1.acct_id <> '9999' 
  and t1.job_cd = 'tbpsf1'
  and t1.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.id_mark <> 'D'
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_elec_chn_acct_sign_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_elec_chn_acct_sign_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_elec_chn_acct_sign_info_ex purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_elec_chn_acct_sign_info',partname => 'p_${batch_date}',granularity => 'PARTITION', degree => 8, cascade => true);