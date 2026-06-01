/*
Purpose: 共性加工层-汇入汇款明细
Author: Sunline
Usage: python $ETL_HOME/script/main.py yyyymmdd icl_cmm_abmt_remit_dtl
Createdate: 20210108
Logs:       20220113 李森辉 新增字段【汇款人国家代码、所属机构编号】
            20220822 温旺清 新增字段【折美元交易金额】
            20220825 温旺清 新增字段【汇款人中文名称】
            20220905 温旺清 新增字段【清算行BIC、中间行BIC、汇款行BIC】
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
--alter table ${icl_schema}.cmm_abmt_remit_dtl drop partition p_${retain_day};
alter table ${icl_schema}.cmm_abmt_remit_dtl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));


whenever sqlerror continue none;
drop table ${icl_schema}.cmm_abmt_remit_dtl_ex purge;

-- 2.1 insert into ex table
create table ${icl_schema}.cmm_abmt_remit_dtl_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_abmt_remit_dtl where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_abmt_remit_dtl_ex(
  etl_dt                    -- 数据日期
  ,lp_id                    -- 法人编号
  ,tran_flow_id             -- 交易流水编号
  ,core_tran_flow_num       -- 核心交易流水号
  ,tran_bank_swiftcode      -- 交易行SWIFTCODE
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
  ,recver_cust_type_cd      -- 收款方客户类型代码
  ,recver_name              -- 收款人名称
  ,recver_cn_name           -- 收款人中文名称
  ,recver_cty_cd            -- 收款人国家代码
  ,curr_cd                  -- 币种代码
  ,remit_amt                -- 汇款金额
  ,tran_cd                  -- 交易代码
  ,tran_postsc              -- 交易附言
  ,tran_dtl_cd              -- 交易明细代码
  ,tran_dtl_postsc          -- 交易明细附言
  ,tran_teller_id           -- 交易柜员编号
  ,tran_org_name            -- 交易机构名称
  ,tran_org_id              -- 交易机构编号
  ,tran_chn_descb           -- 交易渠道描述
  ,belong_org_id            -- 所属机构编号
 	,clear_bk_bic             -- 清算行BIC
	,inter_bank_bic           -- 中间行BIC
	,recv_bank_bic            -- 汇款行BIC
  ,msg_info                 -- 报文信息
  ,fee_amt                  -- 费用金额
  ,usd_fee_amt              -- 折美元费用金额
  ,usd_tran_amt             -- 折美元交易金额
  ,job_cd                   -- 任务代码
  ,etl_timestamp            -- 数据处理时间
)
select
  to_date('${batch_date}', 'yyyymmdd')                              -- 数据日期
  ,'9999'                                                           -- 法人编号
  ,t1.inr||t3.inr||t15.inr||t16.inr                                 -- 交易流水编号
  ,t30.itfinr                                                       -- 核心交易流水号
  ,t9.extkey                                                        -- 交易行SWIFTCODE
  ,t3.rptno                                                         -- 申报号码
  ,t2.ownref                                                        -- 汇款编号
  ,t6.extkey                                                        -- 客户编号
  ,t2.pyeact                                                        -- 收款账号
  ,t2.orcact                                                        -- 汇款账号
  ,t2.orcnam                                                        -- 汇款人名称
  ,t23.cn_name                                                      -- 汇款人中文名称
  ,nvl(t22.target_cd_val,'XXX')                                     -- 汇款人国家代码
  ,trunc(t1.CPLDATTIM)                                              -- 汇款完成日期
  ,decode(t2.trntyp, 0, '贸易', 1, '非贸易', 2, '资本', 3, '其他')  -- 汇款性质
  ,decode(t2.gors, 0, '20', 1, '10')                                -- 收款方客户类型代码
  ,t7.nam                                                           -- 收款人名称
  ,t7.nam1                                                          -- 收款人中文名称
  ,decode(trim(t3.objtyp), 'DBA', t4.country, 'DBD', 'CHN', '')     -- 收款人国家代码
  ,t12.cur                                                          -- 币种代码
  ,t12.amt                                                          -- 汇款金额
  ,decode(trim(t3.objtyp), 'DBA', t4.txcode, 'DBD', t5.txcode, '')  -- 交易代码
  ,decode(trim(t3.objtyp), 'DBA', t4.txrem, 'DBD', t5.txrem, '')    -- 交易附言
  ,decode(trim(t3.objtyp), 'DBA', t4.txcode2, 'DBD', t5.txcode2, '')-- 交易明细代码
  ,decode(trim(t3.objtyp), 'DBA', t4.tx2rem, 'DBD', t5.tx2rem, '')  -- 交易明细附言
  ,t1.iniusr                                                        -- 交易柜员编号
  ,t13.bchname                                                      -- 交易机构名称
  ,t13.branch                                                       -- 交易机构编号
  ,decode(trim(t14.sta), 'Y', '门户渠道处理', '柜面渠道处理')       -- 交易渠道描述
  ,t2.othbch                                                        -- 所属机构编号
  ,coalesce(t26.bic_code, t27.bic_code, t28.bic_code)                                                             -- 清算行BIC
  ,(case when t24.rela_id is not null and t8.inr is not null then t27.bic_code else '' end)                       -- 中间行BIC
  ,(case when (t15.tag52a is not null and t15.tag52a <>' ') then t15.tag52a else substr(t8.extkey, 1, 11) end)    -- 汇款行BIC
  ,t15.tag52a                                                       -- 报文信息
  ,round（t16.amt,2)                                                -- 费用金额
  ,round(case when t18.rat > 0
              then (t16.amt / t18.rat * decode(t16.cur, 'USD', 1.00, t17.rat))
         else 0 END,
        2)                                                          -- 折美元费用金额
  ,decode(t1.reloricur, 'USD', t1.reloriamt, round(t1.relamt * t18.rat, 2))  -- 折美元交易金额
  ,'isbsf1'                                                         -- 任务代码
  ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iol_schema}.isbs_trn t1
 left join ${iol_schema}.isbs_cpd t2
   on t1.objinr = t2.inr
  and t1.objtyp = 'CPD'
  and t2.paytyp = 'I'
  and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.isbs_dbl t3
   on t3.trninr = t1.inr
  and t3.objtyp in ('DBA', 'DBD')
  and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.isbs_dbg t4
   on t3.rptno = t4.rptno
  and t3.objtyp = 'DBA'
  and t4.inr = t3.objinr
  and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.isbs_dbr t5
   on t3.rptno = t5.rptno
  and t3.OBJTYP = 'DBD'
  and t5.inr = t3.objinr
  and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.isbs_pts t6
   on t6.objinr = t2.inr
  and t6.objtyp = 'CPD'
  and t6.rol = 'PYE'
  and t6.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t6.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.isbs_pty t7
   on t6.ptyinr = t7.inr
  and t7.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t7.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.isbs_pts t8
   on t8.objinr = t2.inr
  and t8.objtyp = 'CPD'
  and t8.rol = 'SND'
  and t8.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t8.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.isbs_pty t9
   on t8.ptyinr = t9.inr
  and t9.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t9.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.isbs_pts t10
   on t10.objinr = t2.inr
  and t10.objtyp = 'CPD'
  and t10.rol = 'ORI'
  and t10.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t10.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.isbs_pty t11
   on t10.ptyinr = t11.inr
  and t11.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t11.end_dt > to_date('${batch_date}', 'yyyymmdd')
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
 left join ${iol_schema}.isbs_red t14
   on t1.inr = t14.trninr
  and t14.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t14.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.isbs_smh t15
   on t15.trninr = t1.inr
  and t15.dir = '<'
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
 left join ${iml_schema}.agt_intstl_party_rela_h t19
   on t19.bus_table_name = 'CPD'
  and t19.src_agt_id = t2.inr
  and t19.role_type_cd = 'ORC'
  and t19.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t19.end_dt > to_date('${batch_date}','yyyymmdd')
  and t19.job_cd = 'isbsf1'
 left join ${iml_schema}.pty_intstl_addr_rela_h t20
   on t19.party_addr_rela_id = t20.rela_id
  and t20.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t20.end_dt > to_date('${batch_date}','yyyymmdd')
  and t20.job_cd = 'isbsf1'
 left join ${iol_schema}.isbs_adr t21
   on t20.addr_id = t21.inr
  and t21.start_dt<=to_date('${batch_date}','yyyymmdd')
  and t21.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${iml_schema}.ref_pub_cd_map t22
   on t21.loccty=t22.src_code_val
  and t22.sorc_sys_cd = 'ISBS'
  and t22.src_field_en_name = 'STACTY'
  and t22.src_tab_en_name = 'ISBS_GID'
 left join ${iml_schema}.pty_intstl_party t23
   on t2.orcptyinr = t23.src_party_id
  and t23.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t23.id_mark <> 'D'
  and t23.job_cd = 'isbsf1'
 left join ${iml_schema}.agt_intstl_party_rela_h t24
   on t24.bus_table_name = 'CPD'
  and t24.src_agt_id = t1.objinr
  and t24.role_type_cd = 'RCP'
  and t24.start_dt<=to_date('${batch_date}','yyyymmdd')
  and t24.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${iml_schema}.agt_intstl_party_rela_h t25
   on t25.bus_table_name = 'CPD'
  and t25.src_agt_id = t1.objinr
  and t25.role_type_cd = 'SCP'
  and t25.start_dt<=to_date('${batch_date}','yyyymmdd')
  and t25.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${iml_schema}.pty_intstl_addr_rela_h t26
   on t26.rela_id = t24.party_addr_rela_id
  and t26.start_dt<=to_date('${batch_date}','yyyymmdd')
  and t26.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${iml_schema}.pty_intstl_addr_rela_h t27
   on t27.rela_id = t25.party_addr_rela_id
  and t27.start_dt<=to_date('${batch_date}','yyyymmdd')
  and t27.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${iml_schema}.pty_intstl_addr_rela_h t28
   on t28.rela_id = t8.ptainr
  and t28.start_dt<=to_date('${batch_date}','yyyymmdd')
  and t28.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${iol_schema}.isbs_wfs t29
   on t1.inr=t29.objinr
  and t29.objtyp='TRN'
  and t29.start_dt<=to_date('${batch_date}','yyyymmdd')
  and t29.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${iol_schema}.isbs_wfe t30
   on t29.inr=t30.wfsinr
  and t30.srv='ACT'
  and t30.start_dt<=to_date('${batch_date}','yyyymmdd')
  and t30.end_dt > to_date('${batch_date}','yyyymmdd')
where t1.inifrm = 'CPTADV'
  and t1.relflg in ('F', 'R')
  and trunc(t1.cpldattim) = to_date('${batch_date}','yyyymmdd')
  and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_abmt_remit_dtl exchange partition p_${batch_date} with table ${icl_schema}.cmm_abmt_remit_dtl_ex
;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_abmt_remit_dtl_ex purge;
--drop table ${icl_schema}.tmp_cmm_abmt_remit_dtl_01 purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_abmt_remit_dtl',partname => 'p_${batch_date}',granularity => 'PARTITION', degree => 8, cascade => true);
