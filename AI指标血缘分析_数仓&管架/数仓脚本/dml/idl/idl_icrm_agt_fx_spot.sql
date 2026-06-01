/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_agt_fx_spot
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.icrm_agt_fx_spot drop partition p_${last_date};
alter table ${idl_schema}.icrm_agt_fx_spot drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_agt_fx_spot add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_agt_fx_spot partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,agt_id  -- 协议编号
    ,lp_id  -- 法人编号
    ,bus_id  -- 业务编号
    ,dept_id  -- 部门编号
    ,org_id  -- 机构编号
    ,input_dt  -- 录入日期
    ,tran_dt  -- 交易日期
    ,value_dt  -- 起息日期
    ,curr_pairs_id  -- 货币对编号
    ,bag_exch_rat  -- 成交汇率
    ,brch_exch_rat  -- 分行汇率
    ,cost_exch_rat  -- 成本汇率
    ,fst_curr_cd  -- 第一币种代码
    ,secd_curr_cd  -- 第二货币代码
    ,fst_curr_tran_amt  -- 第一币种交易金额
    ,secd_curr_tran_amt  -- 第二币种交易金额
    ,tran_aim_cd  -- 交易目的代码
    ,cntpty_id  -- 交易对手编号
    ,cntpty_abbr  -- 交易对手简称
    ,tran_splt_type_cd  -- 交易拆分类型代码
    ,tran_dir_cd  -- 交易方向代码
    ,tran_flow_num  -- 交易流水号
    ,ctr_nt_status_cd  -- 成交单状态代码
    ,bag_id  -- 成交编号
    ,tran_mode_cd  -- 交易模式代码
    ,tran_src_cd  -- 交易来源代码
    ,tran_site_cd  -- 交易场所代码
    ,clear_way_cd  -- 清算方式代码
    ,rela_tran_id  -- 关联交易编号
    ,portf_tran_id  -- 投组交易编号
    ,portf_id  -- 投组编号
    ,portf_name  -- 投组名称
    ,portf_type_name  -- 投组类型名称
    ,portf_status_cd  -- 投组状态代码
    ,portf_rela_tran_id  -- 投组关联交易编号
    ,clear_org_cd  -- 清算机构代码
    ,modif_rela_flow_num  -- 交易修改关联流水号
    ,job_cd  -- 任务代码
    ,dealer_acct_num --交易员账号
    ,create_dt       --创建日期 
    ,update_dt       --更新日期 
    ,id_mark         --删除标识 
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.agt_id,chr(13),''),chr(10),'')  -- 协议编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.bus_id,chr(13),''),chr(10),'')  -- 业务编号
    ,replace(replace(t1.dept_id,chr(13),''),chr(10),'')  -- 部门编号
    ,replace(replace(t1.org_id,chr(13),''),chr(10),'')  -- 机构编号
    ,t1.input_dt  -- 录入日期
    ,t1.tran_dt  -- 交易日期
    ,t1.value_dt  -- 起息日期
    ,replace(replace(t1.curr_pairs_id,chr(13),''),chr(10),'')  -- 货币对编号
    ,t1.bag_exch_rat  -- 成交汇率
    ,t1.brch_exch_rat  -- 分行汇率
    ,t1.cost_exch_rat  -- 成本汇率
    ,replace(replace(t1.fst_curr_cd,chr(13),''),chr(10),'')  -- 第一币种代码
    ,replace(replace(t1.secd_curr_cd,chr(13),''),chr(10),'')  -- 第二货币代码
    ,t1.fst_curr_tran_amt  -- 第一币种交易金额
    ,t1.secd_curr_tran_amt  -- 第二币种交易金额
    ,replace(replace(t1.tran_aim_cd,chr(13),''),chr(10),'')  -- 交易目的代码
    ,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'')  -- 交易对手编号
    ,replace(replace(t1.cntpty_abbr,chr(13),''),chr(10),'')  -- 交易对手简称
    ,replace(replace(t1.tran_splt_type_cd,chr(13),''),chr(10),'')  -- 交易拆分类型代码
    ,replace(replace(t1.tran_dir_cd,chr(13),''),chr(10),'')  -- 交易方向代码
    ,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'')  -- 交易流水号
    ,replace(replace(t1.ctr_nt_status_cd,chr(13),''),chr(10),'')  -- 成交单状态代码
    ,replace(replace(t1.bag_id,chr(13),''),chr(10),'')  -- 成交编号
    ,replace(replace(t1.tran_mode_cd,chr(13),''),chr(10),'')  -- 交易模式代码
    ,replace(replace(t1.tran_src_cd,chr(13),''),chr(10),'')  -- 交易来源代码
    ,replace(replace(t1.tran_site_cd,chr(13),''),chr(10),'')  -- 交易场所代码
    ,replace(replace(t1.clear_way_cd,chr(13),''),chr(10),'')  -- 清算方式代码
    ,replace(replace(t1.rela_tran_id,chr(13),''),chr(10),'')  -- 关联交易编号
    ,replace(replace(t1.portf_tran_id,chr(13),''),chr(10),'')  -- 投组交易编号
    ,replace(replace(t1.portf_id,chr(13),''),chr(10),'')  -- 投组编号
    ,replace(replace(t1.portf_name,chr(13),''),chr(10),'')  -- 投组名称
    ,replace(replace(t1.portf_type_name,chr(13),''),chr(10),'')  -- 投组类型名称
    ,replace(replace(t1.portf_status_cd,chr(13),''),chr(10),'')  -- 投组状态代码
    ,replace(replace(t1.portf_rela_tran_id,chr(13),''),chr(10),'')  -- 投组关联交易编号
    ,replace(replace(t1.clear_org_cd,chr(13),''),chr(10),'')  -- 清算机构代码
    ,replace(replace(t1.modif_rela_flow_num,chr(13),''),chr(10),'')  -- 交易修改关联流水号
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,replace(replace(t1.dealer_acct_num,chr(13),''),chr(10),'') as dealer_acct_num     -- 交易员账号
    ,t1.create_dt as create_dt                                                         -- 创建日期 
    ,t1.update_dt as update_dt                                                         -- 更新日期 
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark                     -- 删除标识 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iml_schema}.agt_fx_spot t1    --外汇即期交易
where t1.update_dt = to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_agt_fx_spot',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);