/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl ncrs_cmm_retl_loan_crdt_lmt_info
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
alter table ${idl_schema}.ncrs_cmm_retl_loan_crdt_lmt_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.ncrs_cmm_retl_loan_crdt_lmt_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.ncrs_cmm_retl_loan_crdt_lmt_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,lmt_cont_id  -- 额度合同编号
    ,lmt_appl_flow_num  -- 额度申请流水号
    ,cust_id  -- 客户编号
    ,tax_num  -- 纳税人识别号
    ,bus_breed_id  -- 业务品种编号
    ,actv_flg  -- 激活标志
    ,circl_flg  -- 循环标志
    ,low_risk_bus_flg  -- 低风险业务标志
    ,cust_type_cd  -- 客户类型代码
    ,prod_type_cd  -- 产品类型代码
    ,tenor_type_cd  -- 期限类型代码
    ,curr_cd  -- 币种代码
    ,main_guar_way_cd  -- 主担保方式代码
    ,sub_guar_way_cd  -- 子担保方式代码
    ,status_cd  -- 状态代码
    ,bus_breed_name  -- 业务品种名称
    ,tenor  -- 期限
    ,begin_dt  -- 起始日期
    ,exp_dt  -- 到期日期
    ,belong_org_id  -- 所属机构编号
    ,belong_brch_id  -- 所属分行编号
    ,acct_instit_id  -- 账务机构编号
    ,mgmt_org_id  -- 管理机构编号
    ,crdt_lmt  -- 授信额度
    ,occu_crdt_lmt  -- 已占用授信额度
    ,surp_crdt_lmt  -- 剩余授信额度
    ,crdt_open_amt  -- 授信敞口金额
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id  -- 法人编号
    ,replace(replace(t1.lmt_cont_id,chr(13),''),chr(10),'') as lmt_cont_id  -- 额度合同编号
    ,replace(replace(t1.lmt_appl_flow_num,chr(13),''),chr(10),'') as lmt_appl_flow_num  -- 额度申请流水号
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id  -- 客户编号
    ,replace(replace(t1.tax_num,chr(13),''),chr(10),'') as tax_num  -- 纳税人识别号
    ,replace(replace(t1.bus_breed_id,chr(13),''),chr(10),'') as bus_breed_id  -- 业务品种编号
    ,replace(replace(t1.actv_flg,chr(13),''),chr(10),'') as actv_flg  -- 激活标志
    ,replace(replace(t1.circl_flg,chr(13),''),chr(10),'') as circl_flg  -- 循环标志
    ,replace(replace(t1.low_risk_bus_flg,chr(13),''),chr(10),'') as low_risk_bus_flg  -- 低风险业务标志
    ,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd  -- 客户类型代码
    ,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'') as prod_type_cd  -- 产品类型代码
    ,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd  -- 期限类型代码
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd  -- 币种代码
    ,replace(replace(t1.main_guar_way_cd,chr(13),''),chr(10),'') as main_guar_way_cd  -- 主担保方式代码
    ,replace(replace(t1.sub_guar_way_cd,chr(13),''),chr(10),'') as sub_guar_way_cd  -- 子担保方式代码
    ,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd  -- 状态代码
    ,replace(replace(t1.bus_breed_name,chr(13),''),chr(10),'') as bus_breed_name  -- 业务品种名称
    ,replace(replace(t1.tenor,chr(13),''),chr(10),'') as tenor  -- 期限
    ,t1.begin_dt as begin_dt  -- 起始日期
    ,t1.exp_dt as exp_dt  -- 到期日期
    ,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id  -- 所属机构编号
    ,replace(replace(t1.belong_brch_id,chr(13),''),chr(10),'') as belong_brch_id  -- 所属分行编号
    ,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id  -- 账务机构编号
    ,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id  -- 管理机构编号
    ,t1.crdt_lmt as crdt_lmt  -- 授信额度
    ,t1.occu_crdt_lmt as occu_crdt_lmt  -- 已占用授信额度
    ,t1.surp_crdt_lmt as surp_crdt_lmt  -- 剩余授信额度
    ,t1.crdt_open_amt as crdt_open_amt  -- 授信敞口金额
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'') as job_cd  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 时间戳
 from icl.cmm_retl_loan_crdt_lmt_info t1
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;

-- 3 table grant
-- whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.ncrs_cmm_retl_loan_crdt_lmt_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'ncrs_cmm_retl_loan_crdt_lmt_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);