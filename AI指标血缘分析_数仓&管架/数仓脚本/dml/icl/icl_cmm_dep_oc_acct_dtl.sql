/*
Purpose:    共性加工层-存款开销户明细
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd cmm_dep_oc_acct_dtl
logs:       20220316 翟若平 1、增加字段【子户编号】						
            20220401 翟若平	1、调整字段【全局渠道流水号、冲账标志、交易金额】的取数口径
                            2、置空字段【经办人证件类型代码-OPERR_CERT_TYPE_CD、经办人证件号-OPERR_CERT_NO、经办人手机号-OPERR_MOBILE_NO、经办人信息失效日期-OPERR_INFO_INVALID_DT】"							
            20220418 翟若平	调整字段【储种代码】的取数口径（置空，新核心整合到标准产品）							
            20220526 温旺清	增加字段【代理标识代码、代理人名称、代理人证件类型代码、代理人证件号码、代理人证件开始日、代理人证件到期日】
            20220606 温旺清 新增字段【交易柜员编号、旧子户编号、旧存款产品户编号】			
            20220610 李森辉 1、新增字段【存期期限类型代码】
                            2、调整字段【存期代码】的加工口径，新一代改造，不再作为代码
            20220811 翟若平 1、调整【代办人登记明细】关联取数口径,限制交易码为'CL'\
            20220815 徐子豪 1、调整【全局渠道流水号】、【冲账标志】、【交易金额】取数口径
			      20220817 温旺清 调整存款账户开销户登记簿处理逻辑：开销户信息取最新一笔数据
            20230105 温旺清 新增字段【代理人联系电话、代理人发证机关所在地】
            20230105 陈伟峰 调整NCBS_RB_COMMISSION_REGISTER表关联条件，仅用REFERENCE关联
            20240814 陈伟峰 优化大表关联逻辑，提高跑批效率
            20240828 陈伟峰 新增字段【交易时间】
*/
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_dep_oc_acct_dtl drop partition p_${retain_day};
alter table ${icl_schema}.cmm_dep_oc_acct_dtl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_dep_oc_acct_dtl_ex purge;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_dep_oc_acct_dtl_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_dep_oc_acct_dtl where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_dep_oc_acct_dtl_ex(
    etl_dt                            -- 数据日期
    ,lp_id                            -- 法人编号
    ,oc_acct_flow_num                 -- 开销户流水号
    ,ova_chn_flow_num                 -- 全局渠道流水号
    ,tran_flow_num                    -- 交易流水号
    ,tran_dt                          -- 交易日期
    ,tran_timestamp                   -- 交易时间
    ,acct_id                          -- 账户编号
    ,sub_acct_id                      -- 子户编号
	  ,old_sub_acct_id                  -- 旧子户编号
    ,acct_name                        -- 账户名称
    ,open_vouch_id                    -- 开户凭证编号
    ,dep_prod_acct_id                 -- 存款产品户编号
	  ,old_dep_prod_acct_id             -- 旧存款产品户编号
	  ,tran_teller_id                   -- 交易柜员编号
    ,belong_org_id                    -- 归属机构编号
    ,tran_org_id                      -- 交易机构编号
    ,sav_type_cd                      -- 储种代码
    ,dep_term_cd                      -- 存期代码
    ,dep_term_tenor_type_cd           -- 存期期限类型代码
    ,open_vouch_type_cd               -- 开户凭证类型代码
    ,proc_status_cd                   -- 处理状态代码
    ,chn_cd                           -- 渠道代码
    ,curr_cd                          -- 币种代码
    ,operr_cert_type_cd               -- 经办人证件类型代码
    ,operr_cert_no                    -- 经办人证件号
    ,operr_mobile_no                  -- 经办人手机号
    ,operr_info_invalid_dt            -- 经办人信息失效日期
    ,ec_flg                           -- 钞汇标志
    ,oc_acct_flg                      -- 开销户标志
    ,strk_bal_flg                     -- 冲账标志
    ,tran_amt                         -- 交易金额
    ,agent_idf_cd                     -- 代理标识代码
    ,agent_name                       -- 代理人名称
    ,agent_cert_type_cd               -- 代理人证件类型代码
    ,agent_cert_no                    -- 代理人证件号码
    ,agent_cert_start_dt              -- 代理人证件开始日
    ,agent_cert_exp_dt                -- 代理人证件到期日
    ,agent_phone	                  -- 代理人联系电话
    ,agent_licen_issue_autho_site	  -- 代理人发证机关所在地
    ,job_cd
    ,etl_timestamp                    -- 数据处理时间      
)
select to_date('${batch_date}','yyyymmdd') as etl_dt  --数据日期
      ,t1.lp_id                         -- 法人编号
      ,t1.flow_num                      -- 开销户流水号
      ,t6.ova_flow_num                  -- 全局渠道流水号
      ,nvl(trim(t1.tran_ref_no), t1.flow_num)  -- 交易流水号
      ,t1.tran_dt                       -- 交易日期
      ,t1.fxq_tran_dt                   -- 交易时间
      ,t1.cust_acct_num                 -- 账户编号
      ,t1.sub_acct_num                  -- 子户编号
	    ,t5.acct_seq_no_o                 -- 旧子户编号
      ,t2.acct_name                     -- 账户名称
      ,t1.cust_acct_num                 -- 开户凭证编号
      ,t1.acct_id                       -- 存款产品户编号
	    ,t5.acct_id                       -- 旧存款产品户编号
      ,t1.tran_teller_id                -- 交易柜员编号
      ,t2.open_acct_org_id              -- 归属机构编号
      ,t1.tran_org_id                   -- 交易机构编号
      ,''                               -- 储种代码
      ,t2.dep_term                      -- 存期代码
      ,nvl(trim(t2.tenor_type_cd),'-')  -- 存期期限类型代码
      ,t2.vouch_type_cd                 -- 开户凭证类型代码
      ,'1'                              -- 处理状态代码
      ,t2.open_acct_chn_id              -- 渠道代码 open_acct_chn_id
      ,t1.acct_curr_cd                  -- 币种代码
      ,''                               -- 经办人证件类型代码
      ,''                               -- 经办人证件号
      ,''                               -- 经办人手机号
      ,''                               -- 经办人信息失效日期
      ,t2.bal_type_cd                   -- 钞汇标志
      ,t1.oc_acct_rgst_type_cd          -- 开销户标志
      ,t6.revs_flg                      -- 冲账标志
      ,t6.tran_amt                      -- 交易金额
      ,t4.agent_idf_cd                  -- 代理标识代码
      ,substrb(t4.public_agent_name,1,60)             -- 代理人名称
      ,t4.public_agent_cert_type_cd     -- 代理人证件类型代码
      ,t4.public_agent_cert_no          -- 代理人证件号码
      ,t4.public_agent_cert_effect_dt   -- 代理人证件开始日
      ,t4.public_agent_cert_invalid_dt  -- 代理人证件到期日 
      ,t4.public_agent_tel_num                       -- 代理人联系电话 
      ,t4.public_agent_licen_issue_autho_cty_rg_cd   -- 代理人发证机关所在地
      ,t1.job_cd
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  --数据处理时间
 from (select t.*,
              row_number() over(partition by t.acct_id, t.oc_acct_rgst_type_cd order by t.flow_num desc) rn
  from ${iml_schema}.evt_dep_acct_oc_acct_rgst_b t
 where t.tran_dt <= to_date('${batch_date}','yyyymmdd')
  and t.job_cd = 'ncbsi1') t1 -- 存款账户开销户登记簿 
 left join ${iml_schema}.agt_dep_acct_info_h t2  -- 存款账户信息历史
   on t1.acct_id = t2.acct_id
  and t2.job_cd = 'ncbsf1'
  and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t2.end_dt > to_date('${batch_date}','yyyymmdd')
/* left join ${iml_schema}.evt_batch_open_info_dtl_rgst_b t3	--iol.ncbs_rb_batch_open_details	
   on t1.tran_ref_no = t3.tran_ref_no 
  and t3.job_cd = 'ncbsi1'
  and t3.etl_dt = to_date('${batch_date}', 'yyyymmdd') */
 left join ${iml_schema}.evt_public_agent_rgst_dtl t4
   on t1.tran_ref_no = t4.tran_ref_no
  and trim(t4.tran_ref_no) is not null
  and t4.etl_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t4.job_cd = 'ncbsi1'
  left join ${iol_schema}.ncbs_new_old_seq_no t5	
  on t1.acct_id = t5.internal_key
  left join (
      select t1.acct_id,
             t1.tran_amt,
             t1.revs_flg,
             t1.ova_flow_num,
             row_number()over(partition by t1.acct_id order by t1.tran_tm desc) as rn
        from iml.evt_dep_fin_tran_flow t1
      where t1.tran_dt = to_date('${batch_date}','yyyymmdd')
        and t1.job_cd = 'ncbsi1'
        and t1.etl_dt = to_date('${batch_date}','yyyymmdd')
            ) t6 
    on t1.acct_id=t6.acct_id 
   and t6.rn=1
  where t1.rn = 1
;
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_dep_oc_acct_dtl exchange partition p_${batch_date} with table ${icl_schema}.cmm_dep_oc_acct_dtl_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_dep_oc_acct_dtl_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_dep_oc_acct_dtl', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);