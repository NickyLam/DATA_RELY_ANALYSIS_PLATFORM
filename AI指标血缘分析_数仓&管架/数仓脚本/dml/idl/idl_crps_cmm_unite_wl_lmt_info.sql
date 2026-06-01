/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl crps_cmm_unite_wl_lmt_info
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
alter table ${idl_schema}.crps_cmm_unite_wl_lmt_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.crps_cmm_unite_wl_lmt_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.crps_cmm_unite_wl_lmt_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- ETL处理日期
    ,lp_id  -- 法人编号
    ,lmt_cont_id  -- 额度合同编号
    ,lmt_rela_appl_id  -- 额度关联申请编号
    ,cust_id  -- 客户编号
    ,bus_breed_id  -- 业务品种编号
    ,actv_flg  -- 激活标志
    ,circl_flg  -- 循环标志
    ,low_risk_bus_flg  -- 低风险业务标志
    ,cust_type_cd  -- 客户类型代码
    ,curr_cd  -- 币种代码
    ,status_cd  -- 状态代码
    ,bus_breed_name  -- 业务品种名称
    ,tenor  -- 期限
    ,begin_dt  -- 起始日期
    ,modif_dt  -- 变更日期
    ,exp_dt  -- 到期日期
    ,belong_org_id  -- 所属机构编号
    ,belong_brch_id  -- 所属分行编号
    ,acct_instit_id  -- 账务机构编号
    ,mgmt_org_id  -- 管理机构编号
    ,crdt_lmt  -- 授信额度
    ,occu_crdt_lmt  -- 已占用授信额度
    ,surp_crdt_lmt  -- 剩余授信额度
    ,crdt_open_amt  -- 授信敞口金额
    ,incr_lmt_lmt  -- 提额额度
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- ETL处理日期
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id  -- 法人编号
    ,replace(replace(t.lmt_cont_id,chr(13),''),chr(10),'') as lmt_cont_id  -- 额度合同编号
    ,replace(replace(t.lmt_rela_appl_id,chr(13),''),chr(10),'') as lmt_rela_appl_id  -- 额度关联申请编号
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id  -- 客户编号
    ,replace(replace(t.bus_breed_id,chr(13),''),chr(10),'') as bus_breed_id  -- 业务品种编号
    ,replace(replace(t.actv_flg,chr(13),''),chr(10),'') as actv_flg  -- 激活标志
    ,replace(replace(t.circl_flg,chr(13),''),chr(10),'') as circl_flg  -- 循环标志
    ,replace(replace(t.low_risk_bus_flg,chr(13),''),chr(10),'') as low_risk_bus_flg  -- 低风险业务标志
    ,replace(replace(t.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd  -- 客户类型代码
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd  -- 币种代码
    ,replace(replace(t.status_cd,chr(13),''),chr(10),'') as status_cd  -- 状态代码
    ,replace(replace(t.bus_breed_name,chr(13),''),chr(10),'') as bus_breed_name  -- 业务品种名称
    ,replace(replace(t.tenor,chr(13),''),chr(10),'') as tenor  -- 期限
    ,t.begin_dt as begin_dt  -- 起始日期
    ,t.modif_dt as modif_dt  -- 变更日期
    ,t.exp_dt as exp_dt  -- 到期日期
    ,replace(replace(t.belong_org_id,chr(13),''),chr(10),'') as belong_org_id  -- 所属机构编号
    ,replace(replace(t.belong_brch_id,chr(13),''),chr(10),'') as belong_brch_id  -- 所属分行编号
    ,replace(replace(t.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id  -- 账务机构编号
    ,replace(replace(t.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id  -- 管理机构编号
    ,t.crdt_lmt as crdt_lmt  -- 授信额度
    ,t.occu_crdt_lmt as occu_crdt_lmt  -- 已占用授信额度
    ,t.surp_crdt_lmt as surp_crdt_lmt  -- 剩余授信额度
    ,t.crdt_open_amt as crdt_open_amt  -- 授信敞口金额
    ,t.incr_lmt_lmt as incr_lmt_lmt  -- 提额额度
    ,replace(replace(t.job_cd,chr(13),''),chr(10),'') as job_cd  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 时间戳
 from ${icl_schema}.cmm_unite_wl_lmt_info t--联合网贷额度信息
where t.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;

-- 3 table grant
-- whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.crps_cmm_unite_wl_lmt_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'crps_cmm_unite_wl_lmt_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);