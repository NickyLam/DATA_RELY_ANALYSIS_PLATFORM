/*
Purpose: 共性加工层-汇出汇款明细
Author: Sunline
Usage: python $ETL_HOME/script/main.py yyyymmdd icl_cmm_out_remit_dtl
Createdate: 20210108
Logs:       20220113 李森辉 新增字段【汇款人国家代码、所属机构编号】
            20220822 温旺清 新增字段【折美元交易金额】
			      20220531 陈伟峰 新增字段【汇款人中文名称】
			      20220905 温旺清 新增字段【清算行BIC、中间行BIC、收款行BIC】
            20221122 温旺清 新增字段【核心交易流水号】
            20231116 徐子豪 新增字段【客户编号】
            20251104 陈伟峰 新增字段【收款账号、汇款账号】

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_out_remit_dtl drop partition p_${retain_day};
alter table ${icl_schema}.cmm_out_remit_dtl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));


whenever sqlerror continue none;
drop table ${icl_schema}.cmm_out_remit_dtl_ex purge;

-- 2.1 insert into ex table
create table ${icl_schema}.cmm_out_remit_dtl_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_out_remit_dtl where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_out_remit_dtl_ex(
  etl_dt                    -- 数据日期
  ,lp_id                    -- 法人编号
  ,tran_flow_id             -- 交易流水编号
  ,core_tran_flow_num       -- 核心交易流水号
  ,decl_num                 -- 申报号码
  ,remit_id                 -- 汇款编号
  ,cust_id                  -- 客户编号
  ,recvbl_num               -- 收款账号
  ,remit_acct_num           -- 汇款账号
  ,remiter_name             -- 汇款人名称
  ,remiter_cn_name          -- 汇款人中文名称
  ,remiter_cty_cd           -- 汇款人国家代码
  ,remit_cmplt_dt           -- 汇款完成日期
  ,remit_char               -- 汇款性质
  ,value_day                -- 起息日
  ,exp_day                  -- 到期日
  ,recver_cust_type_cd      -- 收款方客户类型代码
  ,recver_name              -- 收款人名称
  ,recver_cn_name           -- 收款人中文名称
  ,recver_cty_cd            -- 收款人国家代码
  ,recver_descb             -- 收款人描述
  ,curr_cd                  -- 币种代码
  ,remit_amt                -- 汇款金额
  ,remit_type_cd            -- 汇款类型代码
  ,tran_cd                  -- 交易代码
  ,tran_postsc              -- 交易附言
  ,tran_dtl_cd              -- 交易明细代码
  ,tran_dtl_postsc          -- 交易明细附言
  ,tran_teller_id           -- 交易柜员编号
  ,tran_org_name            -- 交易机构名称
  ,tran_org_id              -- 交易机构编号
  ,belong_org_id            -- 所属机构编号
  ,clear_bk_bic             -- 清算行BIC
  ,inter_bank_bic           -- 中间行BIC
  ,recv_bank_bic            -- 收款行BIC
  ,msg_info_1               -- 报文信息1
  ,msg_info_2               -- 报文信息2
  ,fee_amt                  -- 费用金额
  ,usd_fee_amt              -- 折美元费用金额
  ,usd_tran_amt             -- 折美元交易金额
  ,job_cd                   -- 任务代码
  ,etl_timestamp            -- 数据处理时间
)
select
  to_date('${batch_date}', 'yyyymmdd')                              -- 数据日期
  ,'9999'                                                           -- 法人编号
  ,t1.inr||t3.inr||t14.inr||t15.inr||t16.inr                        -- 交易流水编号
  ,t25.itfinr                                                       -- 核心交易流水号
  ,t3.rptno                                                         -- 申报号码
  ,t2.ownref                                                        -- 汇款编号
  ,t6.extkey                                                        -- 客户编号
  ,t2.pyeact                                                        -- 收款账号
  ,t2.orcact                                                        -- 汇款账号
  ,t2.orcnam                                                        -- 汇款人名称
  ,t22.cn_name                                                      -- 汇款人中文名称
  ,nvl(t21.target_cd_val,'OTH')                                     -- 汇款人国家代码
  ,trunc(t1.cpldattim)                                              -- 汇款完成日期
  ,decode(t2.trntyp, 0, '贸易', 1, '非贸易', 2, '资本', 3, '其他')  -- 汇款性质
  ,t2.valdat                                                        -- 起息日
  ,t1.inidattim                                                     -- 到期日
  ,decode(t2.gors, 0, '20', 1, '10')                                -- 收款方客户类型代码
  ,t7.nam                                                           -- 收款人名称
  ,t7.nam1                                                          -- 收款人中文名称
  ,decode(trim(t3.objtyp), 'DBB', t4.country, 'DBE', 'CHN', '')     -- 收款人国家代码
  ,t2.pyenam                                                        -- 收款人描述
  ,t12.cur                                                          -- 币种代码
  ,t12.amt                                                          -- 汇款金额
  ,decode(trim(t3.objtyp), 'DBB', t4.paytype, 'DBE', t5.paytype, '')-- 汇款类型代码
  ,decode(trim(t3.objtyp), 'DBB', t4.txcode, 'DBE', t5.txcode, '')  -- 交易代码
  ,t4.txrem                                                         -- 交易附言
  ,decode(trim(t3.objtyp), 'DBB', t4.txcode2, 'DBE', t5.txcode2, '')-- 交易明细代码
  ,t4.tx2rem                                                        -- 交易明细附言
  ,t1.iniusr                                                        -- 交易柜员编号
  ,t13.bchname                                                      -- 交易机构名称
  ,t13.branch                                                       -- 交易机构编号
  ,t2.othbch                                                        -- 所属机构编号
  ,(case when t23.inr is null then t14.sndkey else t23.sndkey end)  -- 清算行BIC
  ,t14.tag56a                                                       -- 中间行BIC
  ,case when t14.inr is not null then (case when t14.tag57a is not null then t14.tag57a else t14.sndkey end)
        else (t23.sndkey) end                                       -- 收款行BIC
  ,case when t14.inr is null then t15.tag56a
        else t14.tag56a end                                         -- 报文信息1
  ,case when t14.inr is null then t15.tag57a
        else t14.tag57a end                                         -- 报文信息2
  ,round(t16.amt,2)                                                 -- 费用金额
  ,round(case when t18.rat > 0
              then (t16.amt / t18.rat * decode(t16.cur, 'USD', 1.00, t17.rat))
         else 0 END,
        2)                                                          -- 折美元费用金额
  ,decode(t9.reloricur, 'USD', t9.reloriamt, round(t9.relamt * t18.rat, 2))  --折美元交易金额
  ,'isbsi1'                                                         -- 任务代码
  ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iol_schema}.isbs_trn t1
 left join ${iol_schema}.isbs_cpd t2
   on t1.objinr = t2.inr
  and t1.objtyp = 'CPD'
  and t2.paytyp = 'O'
  and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.isbs_dbl t3
   on t3.trninr = t1.inr
  and t3.objtyp in ('DBB', 'DBE')
  and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.isbs_dbh t4
   on t3.rptno = t4.rptno
  and t3.objtyp = 'DBB'
  and t4.inr = t3.objinr
  and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.isbs_dbq t5
   on t3.rptno = t5.rptno
  and t3.OBJTYP = 'DBE'
  and t5.inr = t3.objinr
  and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.isbs_pts t6
   on t6.objinr = t2.inr
  and t6.objtyp = 'CPD'
  and t6.rol = 'ORC'
  and t6.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t6.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.isbs_pty t7
   on t6.ptyinr = t7.inr
  and t7.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t7.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.isbs_clr t8
   on t8.srcinr = t1.inr
  and t8.opndat > to_date('20200118', 'YYYYMMDD')
  and t8.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t8.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.isbs_trn t9
   on t9.objtyp = 'CLR'
  and t9.objinr = t8.inr
  and t9.relflg = 'R'
  and t9.inifrm = 'CLOOPN'
  and t9.start_dt <= to_date('${batch_date}','yyyymmdd') 
  and t9.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${iol_schema}.isbs_cbe t12
   on t12.objinr = t2.inr
  and t12.objtyp = 'CPD'
  and t12.extid = 'AMT1'
  and t12.cbt = 'MAXAMT'
  and t12.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t12.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.isbs_bch t13
   on t13.inr = t1.branchinr
  and t13.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t13.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.isbs_smh t14
   on t9.inr = t14.trninr
  and t14.dir = '>'
  and t14.cortyp = 'SWT'
  and t14.msgtyp = '103'
  and t14.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t14.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.isbs_smh t15
   on t15.trninr = t1.inr
  and t15.dir = '>'
  and t15.cortyp = 'SWT'
  and t15.msgtyp = '103'
  and t15.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t15.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.isbs_fep t16
   on t16.dontrninr = t1.inr
  and t16.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t16.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.isbs_rat t17
   on t17.cur = t16.cur
  and t17.mon = to_char(t1.cpldattim, 'yyyymm')
  and t17.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t17.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.isbs_rat t18
   on t18.cur = 'CNY'
  and t18.mon = to_char(t1.cpldattim, 'yyyymm')
  and t18.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t18.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iml_schema}.pty_intstl_addr_rela_h t19
   on t6.ptainr = t19.rela_id
  and t19.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t19.end_dt > to_date('${batch_date}','yyyymmdd')
  and t19.job_cd ='isbsf1'
 left join ${iol_schema}.isbs_adr t20
   on t19.addr_id = t20.inr
  and t20.start_dt<=to_date('${batch_date}','yyyymmdd')
  and t20.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${iml_schema}.ref_pub_cd_map t21
   on t20.loccty=t21.src_code_val
  and t21.sorc_sys_cd = 'ISBS'
  and t21.src_field_en_name = 'STACTY'
  and t21.src_tab_en_name = 'ISBS_GID'
 left join ${iml_schema}.pty_intstl_party t22
   on t2.orcptyinr = t22.src_party_id
  and t22.create_dt<= to_date('${batch_date}','yyyymmdd')
  and t22.id_mark <>'D'
  and t22.job_cd ='isbsf1'
 left join ${iol_schema}.isbs_smh t23
   on t23.trninr = t1.inr
  and t23.dir = '>'
  and t23.cortyp = 'SWT'
  and t23.msgtyp = '202'
  and t23.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t23.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.isbs_wfs t24
   on t1.inr=t24.objinr
  and t24.objtyp='TRN'
  and t24.start_dt<=to_date('${batch_date}','yyyymmdd')
  and t24.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${iol_schema}.isbs_wfe t25
   on t24.inr=t25.wfsinr
  and t25.srv='ACT'
  and t25.start_dt<=to_date('${batch_date}','yyyymmdd')
  and t25.end_dt > to_date('${batch_date}','yyyymmdd')
where t1.inifrm = 'CPTOPN'
  and t1.relflg in ('F', 'R')
  and trunc(t1.cpldattim) = to_date('${batch_date}','yyyymmdd')
  and t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_out_remit_dtl exchange partition p_${batch_date} with table ${icl_schema}.cmm_out_remit_dtl_ex
;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_out_remit_dtl_ex purge;
--drop table ${icl_schema}.tmp_cmm_out_remit_dtl_01 purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_out_remit_dtl',partname => 'p_${batch_date}',granularity => 'PARTITION', degree => 8, cascade => true);
