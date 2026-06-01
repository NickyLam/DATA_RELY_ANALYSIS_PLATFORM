/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py yyyymmdd idl_crps_cmm_unite_wl_appl_info
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.crps_cmm_unite_wl_appl_info drop partition p_${last_date};
alter table ${idl_schema}.crps_cmm_unite_wl_appl_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.crps_cmm_unite_wl_appl_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.crps_cmm_unite_wl_appl_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- ETL处理日期
    ,lp_id  -- 法人编号
    ,loan_appl_flow_num  -- 贷款申请流水号
    ,partner_appl_flow_num  -- 合作方申请流水号
    ,prod_id  -- 产品编号
    ,prod_name  -- 产品名称
    ,belong_org_id  -- 所属机构编号
    ,cust_id  -- 客户编号
    ,cust_name  -- 客户姓名
    ,cert_type_cd  -- 证件类型代码
    ,cert_id  -- 证件编号
    ,cont_num  -- 联系号码
    ,hxb_blklist_flg  -- 我行黑名单标志
    ,crdtc_que_flg  -- 征信查询标志
    ,score_val  -- 评分分值
    ,anti_fraud_check_flg  -- 反欺诈校验标志
    ,solv_rating_flg  -- 偿债能力评级标志
    ,partner_apv_rest_flg  -- 合作方审批结果标志
    ,other_acp_lmt_flg  -- 其他花呗额度标志
    ,appl_dt  -- 申请日期
    ,appl_amt  -- 申请金额
    ,apv_start_tm  -- 审批开始时间
    ,apv_status_cd  -- 审批状态代码
    ,apv_amt  -- 审批金额
    ,apv_end_tm  -- 审批结束时间
    ,final_jud_end_tm  -- 终审结束时间
    ,advise_sucs_flg  -- 通知成功标志
    ,refuse_rs  -- 拒绝原因
    ,rela_appl_flow_num  -- 关联申请流水号
    ,custs_mang_lab_pbc_cali  -- 客群经营标签_人行口径
    ,custs_mang_lab_bank_supv_cali  -- 客群经营标签_银监口径
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- ETL处理日期
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id  -- 法人编号
    ,replace(replace(t.loan_appl_flow_num,chr(13),''),chr(10),'') as loan_appl_flow_num  -- 贷款申请流水号
    ,replace(replace(t.partner_appl_flow_num,chr(13),''),chr(10),'') as partner_appl_flow_num  -- 合作方申请流水号
    ,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id  -- 产品编号
    ,replace(replace(t.prod_name,chr(13),''),chr(10),'') as prod_name  -- 产品名称
    ,replace(replace(t.belong_org_id,chr(13),''),chr(10),'') as belong_org_id  -- 所属机构编号
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id  -- 客户编号
    ,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name  -- 客户姓名
    ,replace(replace(t.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd  -- 证件类型代码
    ,replace(replace(t.cert_id,chr(13),''),chr(10),'') as cert_id  -- 证件编号
    ,replace(replace(t.cont_num,chr(13),''),chr(10),'') as cont_num  -- 联系号码
    ,replace(replace(t.hxb_blklist_flg,chr(13),''),chr(10),'') as hxb_blklist_flg  -- 我行黑名单标志
    ,replace(replace(t.crdtc_que_flg,chr(13),''),chr(10),'') as crdtc_que_flg  -- 征信查询标志
    ,t.score_val as score_val  -- 评分分值
    ,replace(replace(t.anti_fraud_check_flg,chr(13),''),chr(10),'') as anti_fraud_check_flg  -- 反欺诈校验标志
    ,replace(replace(t.solv_rating_flg,chr(13),''),chr(10),'') as solv_rating_flg  -- 偿债能力评级标志
    ,replace(replace(t.partner_apv_rest_flg,chr(13),''),chr(10),'') as partner_apv_rest_flg  -- 合作方审批结果标志
    ,replace(replace(t.other_acp_lmt_flg,chr(13),''),chr(10),'') as other_acp_lmt_flg  -- 其他花呗额度标志
    ,t.appl_dt as appl_dt  -- 申请日期
    ,t.appl_amt as appl_amt  -- 申请金额
    ,t.apv_start_tm as apv_start_tm  -- 审批开始时间
    ,replace(replace(t.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd  -- 审批状态代码
    ,t.apv_amt as apv_amt  -- 审批金额
    ,t.apv_end_tm as apv_end_tm  -- 审批结束时间
    ,t.final_jud_end_tm as final_jud_end_tm  -- 终审结束时间
    ,replace(replace(t.advise_sucs_flg,chr(13),''),chr(10),'') as advise_sucs_flg  -- 通知成功标志
    ,replace(replace(t.refuse_rs,chr(13),''),chr(10),'') as refuse_rs  -- 拒绝原因
    ,replace(replace(t.rela_appl_flow_num,chr(13),''),chr(10),'') as rela_appl_flow_num  -- 关联申请流水号
    ,replace(replace(t.custs_mang_lab_pbc_cali,chr(13),''),chr(10),'') as custs_mang_lab_pbc_cali  -- 客群经营标签_人行口径
    ,replace(replace(t.custs_mang_lab_bank_supv_cali,chr(13),''),chr(10),'') as custs_mang_lab_bank_supv_cali  -- 客群经营标签_银监口径
    ,replace(replace(t.job_cd,chr(13),''),chr(10),'') as job_cd  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 时间戳
 from ${icl_schema}.cmm_unite_wl_appl_info t--联合网贷申请信息
where t.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;

-- 3 table grant
-- whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.crps_cmm_unite_wl_appl_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'crps_cmm_unite_wl_appl_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);